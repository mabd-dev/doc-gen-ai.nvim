local M = {}

function M.is_empty(s)
    return s == nil or s == ''
end

function M.log(msg, level)
    level = level or vim.log.levels.INFO
    vim.notify('[doc-gen-ai] ' .. msg, level)
end

function M.log_error(msg)
    M.log(msg, vim.log.levels.ERROR)
end

function M.log_warn(msg)
    M.log(msg, vim.log.levels.WARN)
end

return M
