# dbt.nvim

A neovim plugin for [dbt](https://www.getdbt.com/).  Still  very much work-in-progress.
Requires [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim), [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim), [nvim-notify](https://github.com/rcarriga/nvim-notify) and Neovim +5.0.

## Features
- [X] jump to model file from `{{ ref() }}`
- [X] select model file to jump to from Telescope fuzzy finder (`DBTGoToDefinition`)
- [X] insert model ref from fuzzy finder  (`DBTInsertModelRef`)
- [ ] jump to model properties in `.yml` file
    - [ ] use treesitter to parse model names and line numbers from `.yaml` file
    - [ ] crawl all .yml files looking for model name
- [ ] jump to source definition (in yaml).
    - [ ] use treesitter to parse source table names and line numbers from `.yaml` file
    - [ ] crawl all .yml files looking for source table name
    - [ ] update `DBTGoToDefinition` to jump to source `.yml` if `{{ source() }}` specified
    - [ ] look at https://github.com/cuducos/yaml.nvim
- [ ] view model columns and definitions in floating window
- [ ] view source columns and definitions in floating window
- [ ] run model from model file
- [ ] run tests for model from model file
- [ ] make vim help for plugin


## Installation with Packer

```lua
return require("packer").startup(
   function()
        use {
            "cfmeyers/dbt.nvim",
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope.nvim",
                "rcarriga/nvim-notify",
            },
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

### `DBTTelescopeJumpToModelFile`
Open a the Telescope fuzzy file picker to select model file to jump to.


### `DBTInsertModelRef`
Select a model name from a fuzzy finder and insert it into a Jinja `{{ ref('') }}` tag.

Suggested remap in `nvim/after/ftplugin/sql`:
```vim
inoremap <buffer> rrr <C-O>:DBTInsertModelRef<CR>
```
