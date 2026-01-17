# doc-gen-ai.nvim

A Neovim plugin that generates KDoc documentation for Kotlin functions using local LLMs via Ollama.

## Requirements

- Neovim >= 0.9.0
- [doc-gen-ai](https://github.com/mabd-dev/doc-gen-ai) CLI tool
- [Ollama](https://ollama.ai/) running locally

## Usage
1. Select peice of code
2. run `:DocGen` cmd
3. Documetation will be generated and inserted before the selected code

If existing doc is detected, you'll be prompted to:
- Replace existing - Remove old doc and insert new
- Insert new (keep old) - Keep old doc and add new above it
- Cancel - Abort operation

## Installation

### lazy.nvim

```lua
{
  "mabd-dev/doc-gen-ai.nvim",
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

1. Selected code is send to `doc-gen-ai` CLI via stdin
2. CLI uses Ollama to generate documentation
3. Multi-step llm operation will run to analyze, generate and polish good documentation
4. Generated documentation is returned via stdout 
5. Plugin inserts the documentation above the selected code

> The plugin displays an animated spinner while waiting for generation to complete.

## Limitation
- Only works with local llm for now
- Only works with kotlin code

For now we will support only kotlin code. Once the CLI tool is polished we will start supporting more languages.

