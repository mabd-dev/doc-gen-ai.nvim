# doc-gen-ai.nvim

A Neovim plugin that generates KDoc documentation for Kotlin functions using local LLMs via Ollama.

## Requirements

- Neovim >= 0.9.0
- [doc-gen-ai](https://github.com/mabd-dev/doc-gen-ai) CLI tool
- [Ollama](https://ollama.ai/) for local models
- [Groq](https://groq.com/) API key for remote models
- Kotlin treesitter parser (optional, for automatic function detection)

## Usage

Run `:DocGen` to generate documentation. The command works in two modes:

| Mode | Behavior |
|------|----------|
| **Normal mode** | Automatically detects the function under cursor using treesitter |
| **Visual mode** | Uses your selected text |

If existing documentation is detected, you'll be prompted to:
- **Replace existing** - Remove old documentation and insert new
- **Insert new (keep old)** - Keep old documentation and add new above it
- **Cancel** - Abort operation

### Treesitter Setup

For automatic function detection in normal mode, install the Kotlin parser:
```vim
:TSInstall kotlin
```

Run `:checkhealth doc-gen-ai` to verify your setup.

## Installation

### lazy.nvim
```lua
{
  "mabd-dev/doc-gen-ai.nvim",
}
```

latest stable version
```lua
{
  "mabd-dev/doc-gen-ai.nvim",
  tag = "<latest-tag>",
}
```

### Commands

| Command | Description |
|---------|-------------|
| `:DocGen` | Generate KDoc (auto-detect function or use selection) |
| `:DocGenCancel` | Cancel running generation job |

## Configuration

### Default Options
```lua
{
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
```

### Keymaps
```lua
vim.keymap.set('n', '<leader>kd', ':DocGen<CR>', { desc = 'Generate KDoc' })
vim.keymap.set('v', '<leader>kd', ':DocGen<CR>', { desc = 'Generate KDoc for selection' })
vim.keymap.set('n', '<leader>kc', ':DocGenCancel<CR>', { desc = 'Cancel KDoc generation' })
```

## How It Works

1. Function code is captured (via treesitter or selection)
2. Code is sent to `doc-gen-ai` CLI via stdin
3. CLI uses **user chosen provider** to generate documentation
4. Multi-step LLM operation runs to analyze, generate, and polish the documentation
5. Generated documentation is returned via stdout
6. Plugin inserts the documentation above the function

> The plugin displays an animated spinner while waiting for generation to complete.

## Limitations

- Currently only supports Kotlin code.

**Note:** Support for additional languages will be added once the CLI tool is fully polished.

## License

MIT
