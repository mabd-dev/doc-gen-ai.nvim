local M = {}

local config = require('doc-gen-ai.config')
local utils = require('doc-gen-ai.utils')

function M.setup(opts)
    config.setup(opts)
    local filetypes = table.concat(config.get().filetypes, ',')
    utils.log('plugin loaded with cmd:' .. filetypes)
end
return M
