local M = {}

local config = require('doc-gen-ai.config')
local utils = require('doc-gen-ai.utils')

function M.setup(opts)
    config.setup(opts)
    local filetypes = table.concat(config.get().filetypes, ',')
    utils.log('plugin loaded with cmd:' .. filetypes)

    -- Register commands
    vim.api.nvim_create_user_command('DocGen', function(cmd_opts)
        M.generate(cmd_opts)
    end, {
        range = true,
        desc = 'Generate KDoc for selected code',
    })

    vim.api.nvim_create_user_command('CancelDocGen', function(cmd_opts)
        M.cancel(cmd_opts)
    end, {
        desc = 'Cancel running kdoc job'
    })
end

function M.generate(opts)
    local cfg = config.get()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype

    -- Check filetype
    if not vim.tbl_contains(cfg.filetypes, filetype) then
        utils.log_warn('Unsupported filetype: ' .. filetype)
        return
    end

    print("Fake generating kdoc")
end

function M.cancel(opts)
    print("Fake cancel generating kdoc")
end

return M
