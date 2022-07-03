local Path = require("plenary.path")
local Scan = require("plenary.scandir")
local Jinja = require("dbt-nvim.jinja")
local Yaml = require("dbt-nvim.yaml")
local TelescopeBuiltIn = require("telescope.builtin")

M = {}
local function get_dbt_root_dir()
    -- local buffer_path = vim.api.nvim_eval("expand(\"%:p\")")
    -- local project_yaml = vim.api.nvim_eval("findfile('dbt_project.yml', '.;')")
    local root_dir = vim.api.nvim_eval(
                         "fnamemodify(findfile('dbt_project.yml', '.;'), ':h')"
                     )
    return root_dir
end

local function get_leaf_model_dirs(model_dir_path)
    return Scan.scan_dir(model_dir_path, {hidden = false, only_dirs = true})
end

local function get_model_path(model_name)
    root_dir = get_dbt_root_dir()
    models_dir = root_dir .. "/models"
    all_paths = Scan.scan_dir(
                    models_dir, {
            hidden = false,
            search_pattern = "/" .. model_name .. ".sql$",
        }
                )
    return all_paths[1]
end

local function jump_to_model(model_name)
    model_path = get_model_path(model_name)
    if model_path then
        vim.api.nvim_command("edit " .. model_path)
    else
        print("Could not find file for model '" .. model_name .. "'")
    end
end

local function go_to_definition()
    line = vim.api.nvim_get_current_line()
    ref_model_name = Jinja.get_ref(line)
    source_name, table_name = Jinja.get_source(line)
    if ref_model_name then
        jump_to_model(ref_model_name)
    elseif source_name then
        print(source_name .. "." .. table_name)
    end
end

local function telescope_jump_to_model_file()

    local root_dir = get_dbt_root_dir()
    local models_dir = root_dir .. "/models"
    TelescopeBuiltIn.find_files(
        {
            cwd = models_dir,
            prompt_title = "DBT Models",
            file_ignore_patterns = {".yml$", ".yaml$", ".md$"},
        }
    )
end

local function get_model_names(root_dir)
    local root_dir = root_dir or get_dbt_root_dir()
    local model_dir_path = root_dir .. "/models"
    local model_paths = Scan.scan_dir(model_dir_path,
        {
            hidden = false,
            only_dirs = false,
            add_dirs = false,
            search_pattern = "%.sql$"
        }
    )
    model_names = {}
    for i, v in pairs(model_paths) do
        parts = vim.split(v, "/", true)
        name = vim.split(parts[#parts], ".", true)[1]
        table.insert(model_names, name)
    end
    return model_names
end

local function test_harness()
    put(get_model_names())
end

M.test_harness = test_harness
M.go_to_definition = go_to_definition
M.telescope_jump_to_model_file = telescope_jump_to_model_file
M.get_model_names = get_model_names

return M
