local M = {}

local config = require('doc-gen-ai.config')
local utils = require('doc-gen-ai.utils')
local generator = require('doc-gen-ai.generator')

function M.setup(opts)
    config.setup(opts)
    local filetypes = table.concat(config.get().filetypes, ',')
    utils.log('plugin loaded with cmd:' .. filetypes)

    -- Register commands
    vim.api.nvim_create_user_command('DocGen', function(cmd_opts)
        generator.run(cmd_opts)
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
