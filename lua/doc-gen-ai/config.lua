local M = {}

M.defaults = {
    filetypes = { 'kotlin' },
}

M.options = {}


function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

function M.get()
    return M.options
end

return M
