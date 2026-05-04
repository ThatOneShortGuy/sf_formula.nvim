# sf_formula.nvim

Neovim plugin for Salesforce-style formula files (`.sff`).

## Features

- Filetype detection for `.sff`
- Syntax highlighting
- Starts `sf_formula_lsp` for `.sff` buffers

## Requirements

- Neovim `0.10+`
- `sf_formula_lsp` available on `PATH`, or set `vim.g.sf_formula_lsp_cmd`

## Setup

```lua
{
  "ThatOneShortGuy/sf_formula.nvim",
  ft = { "sff" },
  build = function()
    require("sf_formula.build").ensure_lsp()
  end,
}
```

This checks the upstream git `HEAD` hash during plugin build (`:Lazy sync`) and reinstalls `sf_formula_lsp` when missing or out of date.
The binary is installed to `stdpath("data") .. "/sf_formula_nvim/bin"`, so it does not need to be on your shell `PATH`.

If you prefer a custom binary location, set:

```lua
vim.g.sf_formula_lsp_cmd = { "/absolute/path/to/sf_formula_lsp" }
```
