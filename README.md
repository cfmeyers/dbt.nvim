# dbt.nvim

A neovim plugin for [dbt](https://www.getdbt.com/).  Still  very much work-in-progress.
Requires [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) and Neovim +5.0.

## Features
- [X] jump to model file from `{{ ref() }}`
- [ ] jump to source definition (in yaml).
- [ ] view model columns and definitions in floating window
- [ ] view source columns and definitions in floating window
- [ ] jump to model properties in `.yml` file
- [ ] run model from model file
- [ ] run tests for model from model file
- [ ] make vim help for plugin


## Installation with Packer

```lua
return require("packer").startup(
   function()
        use {
            "cfmeyers/dbt.nvim",
            requires = {{"nvim-lua/plenary.nvim"}},
        }
    end
)
```

## Command

### `DBTGoToDefinition`
Jumps to the `/models/nested/directories/your_model_name.sql` file where `{{ ref(your_model_name) }}` is defined.
Suggested remap in `nvim/after/ftplugin/sql`:

```vim
nnoremap <buffer> gd :DBTGoToDefinition<CR>
```
