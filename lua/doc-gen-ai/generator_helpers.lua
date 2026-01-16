local M = {}

-- Helper: find existing KDoc above a line
function M.find_existing_kdoc(bufnr, line)
    -- Look backwards from line-1 for a KDoc block
    local search_start = line - 1

    -- Skip blank lines
    while search_start > 0 do
        local l = vim.api.nvim_buf_get_lines(bufnr, search_start - 1, search_start, false)[1]
        if l:match('^%s*$') then
            search_start = search_start - 1
        else
            break
        end
    end

    if search_start < 1 then return nil end

    -- Check if this line ends a KDoc (ends with */)
    local end_line_content = vim.api.nvim_buf_get_lines(bufnr, search_start - 1, search_start, false)[1]
    if not end_line_content:match('%*/%s*$') then
        return nil
    end

    -- Find the start of the KDoc (/**)
    local kdoc_end = search_start
    local kdoc_start = search_start

    for i = search_start, 1, -1 do
        local l = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
        if l:match('/%*%*') then
            kdoc_start = i
            break
        end
    end

    return { start_line = kdoc_start, end_line = kdoc_end }
end

return M
