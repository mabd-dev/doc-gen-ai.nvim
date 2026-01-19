# doc-gen-ai.nvim

A Neovim plugin that generates KDoc documentation for Kotlin functions using local LLMs via Ollama.

## Requirements

- Neovim >= 0.9.0
- [doc-gen-ai](https://github.com/mabd-dev/doc-gen-ai) CLI tool
- [Ollama](https://ollama.ai/) running locally

## Usage
1. Select a piece of code
2. Run `:DocGen` command
3. Documentation will be generated and inserted before the selected code

If existing documentation is detected, you'll be prompted to:
- **Replace existing** - Remove old documentation and insert new
- **Insert new (keep old)** - Keep old documentation and add new above it
- **Cancel** - Abort operation

## Installation

### lazy.nvim

```lua
{
  "mabd-dev/doc-gen-ai.nvim",
  opts = {
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
}
```

### Commands


| Command | Description |
|---------|-------------|
| `:DocGen` | Generate KDoc for selected range |
| `:DocGenCancel` | Cancel running generation job |


## Configuration

### Keymaps

```lua
vim.keymap.set('v', '<leader>kd', ':DocGen<CR>', { desc = 'Generate KDoc' })
vim.keymap.set('n', '<leader>kc', ':DocGenCancel<CR>', { desc = 'Cancel KDoc generation' })
```


## How It Works

1. Selected code is sent to `doc-gen-ai` CLI via stdin
2. CLI uses Ollama to generate documentation
3. Multi-step LLM operation runs to analyze, generate, and polish the documentation
4. Generated documentation is returned via stdout
5. Plugin inserts the documentation above the selected code

> The plugin displays an animated spinner while waiting for generation to complete.

## Limitations
- Currently only works with local LLMs via Ollama.
- Currently only supports Kotlin code.

**Note:** Support for additional languages will be added once the CLI tool is fully polished.

## License

MIT

