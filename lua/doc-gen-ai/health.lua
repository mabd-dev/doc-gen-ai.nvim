local M = {}

function M.check()
    vim.health.start('doc-gen-ai')


    local cmd = 'doc-gen-ai'
    if vim.fn.executable(cmd) == 1 then
        vim.health.ok(cmd .. ' is installed ')
    else
        vim.health.error(cmd .. ' is not installed ', {
            'Install doc-gen-ai: go install github.com/mabd-dev/doc-gen-ai@latest',
            'Check: https://github.com/mabd-dev/doc-gen-ai'
        })
    end
end

return M
