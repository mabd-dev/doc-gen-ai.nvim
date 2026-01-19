local M = {}

M.defaults = {
    running_provider = "ollama",
    providers = {
        ollama = {
            base_url = "http://localhost:11434",
            base_model = "qwen2.5-coder:7b",
            polish_docs = true,
        },
        groq = {
            base_url = "https://api.groq.com/openai/v1",
            base_model = "qwen/qwen3-32b",
            polish_docs = false,
        }
    }
}

M.options = {}


function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})

    M.options.filetypes = { 'kotlin' }
end

function M.get()
    return M.options
end

return M
