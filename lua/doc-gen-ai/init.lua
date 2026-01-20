local M = {}

local config = require('doc-gen-ai.config')
local utils = require('doc-gen-ai.utils')
local generator = require('doc-gen-ai.generator')
local generator_helpers = require('doc-gen-ai.generator_helpers')

function M.setup(opts)
    config.setup(opts)
    local filetypes = table.concat(config.get().filetypes, ',')
    utils.log('plugin loaded with cmd:' .. filetypes)

    -- Register commands
    vim.api.nvim_create_user_command('DocGen', function(cmd_opts)
        if cmd_opts.range == 2 then
            -- visual mode

            generator.run(cmd_opts, cmd_opts.line1, cmd_opts.line2)
        else
            -- normal mode
            local currFunc = generator_helpers.get_current_function()

            if not currFunc then
                utils.log_error('no function found under current cursor')
                return
            end

            -- TODO: make code works with 0-based start_line and end_line
            generator.run(cmd_opts, currFunc.start_row + 1, currFunc.end_row + 1)
        end
    end, {
        range = true,
        desc = 'Generate KDoc for selected code',
    })

    vim.api.nvim_create_user_command('DocGenCancel', function(cmd_opts)
        generator.cancel()
    end, {
        desc = 'Cancel running kdoc job'
    })
end

return M
