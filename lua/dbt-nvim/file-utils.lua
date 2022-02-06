local Path = require("plenary.path")
local Scan = require("plenary.scandir")
local Jinja = require("dbt-nvim.jinja")

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

local function test_harness()
    root_dir = get_dbt_root_dir()
    models_dir = root_dir .. "/models"
    leaf_model_dirs = get_leaf_model_dirs(models_dir)
    go_to_definition()
end

-- return {test_harness = test_harness}
M.test_harness = test_harness
M.go_to_definition = go_to_definition

return M
