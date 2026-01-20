# Changelog


## Unreleased
### Added
- Automatic function detection using treesitter in normal mode
- `:DocGen` now works in both normal mode (treesitter) and visual mode (selection)
- **health check**: 
    - check if `doc-gen-ai` cli cmd is installed
    - check if Kotlin treesitter parser is installed (optional)

### Changed
- `:DocGen` command no longer requires visual selection

## [0.2.0] - 2026-01-17

### Added
- Multiple provider support: `ollama` (local) and `groq` (remote)
- Per-provider configuration for models
- `provider` option to select active provider

More providers coming soon.

## [0.1.0] - 2026-01-17
Initial Release - Experimental
### ✨ Features

- **generate kdoc**: command to generate kdocs for selected function
- **cancel kdoc generation**: command to cancel actively running kdoc generration
- **spinner**: show spinner while kdoc is being generated

