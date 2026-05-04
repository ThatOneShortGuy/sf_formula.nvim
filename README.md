# sf_formula.nvim

Neovim plugin for Salesforce-style formula files (`.sff`).

## Features

- Filetype detection for `.sff`
- Syntax highlighting
- Starts `sf_formula_lsp` for `.sff` buffers

## Requirements

- Neovim `0.10+`
- `sf_formula_lsp` available on `PATH`, or set `vim.g.sf_formula_lsp_cmd`

## Setup (auto-install LSP if missing)

```lua
{
  "ThatOneShortGuy/sf_formula.nvim",
  ft = { "sff" },
  build = function()
    if vim.fn.executable("sf_formula_lsp") == 1 then
      return
    end

    local cmd = {
      "cargo",
      "install",
      "--locked",
      "--git",
      "https://github.com/ThatOneShortGuy/sf-formula-parser",
      "sf_formula_lsp",
    }

    local result = vim.system(cmd, { text = true }):wait()
    if result.code ~= 0 then
      error(result.stderr ~= "" and result.stderr or result.stdout)
    end
  end,
}
```

This installs `sf_formula_lsp` once during plugin build (`:Lazy sync`) when missing.

If you prefer a custom binary location, set:

```lua
vim.g.sf_formula_lsp_cmd = { "/absolute/path/to/sf_formula_lsp" }
```
