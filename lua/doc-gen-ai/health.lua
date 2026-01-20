local M = {}

local health = vim.health

function M.check()
    health.start('doc-gen-ai')


    local cmd = 'doc-gen-ai'
    if vim.fn.executable(cmd) == 1 then
        health.ok(cmd .. ' is installed ')
    else
        health.error(cmd .. ' is not installed ', {
            'Install doc-gen-ai: go install github.com/mabd-dev/doc-gen-ai@latest',
            'Check: https://github.com/mabd-dev/doc-gen-ai'
        })
    end

    local ok = pcall(vim.treesitter.language.inspect, "kotlin")
    if ok then
        health.ok("Kotlin treesitter parser installed")
    else
        health.warn(
            "Kotlin treesitter parser not found",
            "Install with :TSInstall kotlin (requires nvim-treesitter)"
        )
    end
end

return M
