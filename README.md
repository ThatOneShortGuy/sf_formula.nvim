# sf_formula.nvim

Neovim plugin for Salesforce-style formula files (`.sff`).

## Features

- Filetype detection for `.sff`
- Syntax highlighting
- Starts `sf_formula_lsp` for `.sff` buffers

## Requirements

- Neovim `0.10+`
- `sf_formula_lsp` available on `PATH`, or set `vim.g.sf_formula_lsp_cmd`

## Minimal setup

```lua
{
  "ThatOneShortGuy/sf_formula.nvim",
  ft = { "sff" },
}
```

If the LSP binary is not on your `PATH`, point the plugin at it directly:

```lua
vim.g.sf_formula_lsp_cmd = { "/absolute/path/to/sf_formula_lsp" }
```
