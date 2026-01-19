local M = {}

local config = require('doc-gen-ai.config')
local utils = require('doc-gen-ai.utils')
local helpers = require('doc-gen-ai.generator_helpers')

local active_job = nil

local ns_id = vim.api.nvim_create_namespace('docgen_loader')
local spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local spinner_timer = nil
local spinner_idx = 1

local function show_loader(bufnr, line)
    spinner_idx = 1

    local function update_spinner()
        vim.api.nvim_buf_clear_namespace(bufnr, ns_id, line - 2, line)

        vim.api.nvim_buf_set_extmark(bufnr, ns_id, line - 1, 0, {
            virt_text = { { ' ' .. spinner_frames[spinner_idx], 'DiagnosticInfo' } },
            virt_text_pos = 'eol',
        })

        spinner_idx = (spinner_idx % #spinner_frames) + 1
    end

    update_spinner()

    spinner_timer = vim.fn.timer_start(100, function()
        vim.schedule(update_spinner)
    end, { ['repeat'] = -1 })
end

local function hide_loader(bufnr)
    if spinner_timer then
        vim.fn.timer_stop(spinner_timer)
        spinner_timer = nil
    end
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

local function supported_file_type(filetype)
    local cfg = config.get()

    if not vim.tbl_contains(cfg.filetypes, filetype) then
        return false
    end
    return true
end

-- TODO: re-check function signature position and insert above it
-- While doc is being generated, file might have been changed, thus function start_line
-- might have changed. So search the file for the function start_line and insert above it
local function do_insert(bufnr, doc_lines, replace_existing, existing, start_line, end_line)
    if replace_existing and existing then
        -- Replace existing KDoc
        vim.api.nvim_buf_set_lines(bufnr, existing.start_line - 1, existing.end_line, false, doc_lines)
        vim.notify('KDoc replaced!', vim.log.levels.INFO)
    else
        -- Insert above function
        vim.api.nvim_buf_set_lines(bufnr, start_line - 1, start_line - 1, false, doc_lines)
        vim.notify('KDoc inserted!', vim.log.levels.INFO)
    end
end


local function run_docgen(bufnr, input, replace_existing, existing, start_line, end_line)
    local stdout_chunks = {}
    local stderr_chunks = {}

    show_loader(bufnr, start_line)

    local running_provider = config.options.running_provider

    local base_url = ''
    local base_model = ''
    if running_provider == 'ollama' then
        base_url = config.options.providers.ollama.base_url
        base_model = config.options.providers.ollama.base_model
    elseif running_provider == 'groq' then
        base_url = config.options.providers.groq.base_url
        base_model = config.options.providers.groq.base_model
    end

    active_job = vim.fn.jobstart(
        {
            'doc-gen-ai',
            '--provider=' .. running_provider,
            '--base-url=' .. base_url,
            '--base-model=' .. base_model,
        },
        {
            stdin = 'pipe',
            stdout_buffered = true,
            stderr_buffered = true,

            on_stdout = function(_, data)
                if data then vim.list_extend(stdout_chunks, data) end
            end,

            on_stderr = function(_, data)
                if data then vim.list_extend(stderr_chunks, data) end
            end,

            on_exit = function(_, exit_code)
                vim.schedule(function()
                    hide_loader(bufnr)

                    if exit_code ~= 0 then
                        utils.log_error('doc-gen-ai failed:\n' .. table.concat(stderr_chunks, '\n'))
                        return
                    end

                    while #stdout_chunks > 0 and stdout_chunks[#stdout_chunks] == '' do
                        table.remove(stdout_chunks)
                    end

                    if #stdout_chunks == 0 then
                        utils.log_warn('doc-gen-ai: empty output')
                        return
                    end

                    utils.log('should insert kdoc now')
                    do_insert(bufnr, stdout_chunks, replace_existing, existing, start_line, end_line)
                end)
            end
        })

    -- Send input and close stdin
    vim.fn.chansend(active_job, input)
    vim.fn.chanclose(active_job, 'stdin')
end

function M.is_running()
    return active_job ~= nil
end

function M.cancel()
    if M.is_running() then
        vim.fn.jobstop(active_job)
        active_job = nil
        utils.log('Cancelled')
        return true
    end

    utils.log_warn('No active job')
    return false
end

function M.run(opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype

    if not supported_file_type(filetype) then
        utils.log_warn('Unsupported filetype: ' .. filetype)
        return
    end

    local start_line = opts.line1
    local end_line = opts.line2
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
    local input = table.concat(lines, "\n")

    utils.log('Generating KDoc...')

    local existing = helpers.find_existing_kdoc(bufnr, start_line)

    if existing then
        vim.ui.select(
            { 'Replace existing', 'Insert new (keep old)', 'Cancel' },
            { prompt = 'Existing KDoc found:' },
            function(choice)
                if choice == 'Replace existing' then
                    run_docgen(bufnr, input, true, existing, start_line, end_line)
                elseif choice == 'Insert new (keep old)' then
                    run_docgen(bufnr, input, false, existing, start_line, end_line)
                end
                -- Cancel does nothing
            end
        )
    else
        run_docgen(bufnr, input, false, existing, start_line, end_line)
    end
end

return M
