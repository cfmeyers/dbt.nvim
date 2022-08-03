local Path = require("plenary.path")
local Scan = require("plenary.scandir")
local Jinja = require("dbt-nvim.jinja")
local Yaml = require("dbt-nvim.yaml")
local TelescopeBuiltIn = require("telescope.builtin")
local notify = require("notify").notify

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

local function jump_to_model(model_name, buffer_edit_mode)
    model_path = get_model_path(model_name)
    if model_path then
        vim.api.nvim_command(buffer_edit_mode .. " " .. model_path)
    else
        print("Could not find file for model '" .. model_name .. "'")
    end
end


local function in_yaml_file()
    return vim.bo.filetype == 'yaml'
end

local function in_sql_file()
    return vim.bo.filetype == 'sql'
end



local function go_to_definition(buffer_edit_mode)
    line = vim.api.nvim_get_current_line()
    if in_yaml_file() then
        ref_model_name = Yaml.get_name_from_line(line)
    else
        ref_model_name = Jinja.get_ref(line)
    end
    source_name, table_name = Jinja.get_source(line)
    if ref_model_name then
        jump_to_model(ref_model_name, buffer_edit_mode)
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

local function insert_text_at_current_position(text)
    text = text .. " "
    local row_num = vim.api.nvim_win_get_cursor(0)[1]
    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local line = vim.api.nvim_get_current_line()
    local nline = line:sub(0, pos) .. text .. line:sub(pos + 1)
    vim.api.nvim_set_current_line(nline)
    local text_length = #text
    vim.api.nvim_win_set_cursor(0, {row_num, pos+text_length})
end

local function insert_model_ref()
    local model_names = get_model_names()

    vim.ui.select(model_names, {prompt = "DBT MODELS"},
        function(model_name)
            local text = "{{ ref('" .. model_name .. "') }}"
            insert_text_at_current_position(text)
            vim.api.nvim_command("normal! a")
        end
        )
end

local function get_current_model_name(include_schema)
    local file_name = vim.api.nvim_eval('expand("%:t")')
    local table_name = vim.split(file_name, ".", true)[1]
    local schema_name = ""
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    for _, v in pairs(lines) do
        local maybe_schema = Jinja.get_schema(v)
        if maybe_schema then
            schema_name = maybe_schema
        end
    end
    local full_name = ""
    if schema_name ~= "" and include_schema then
        full_name = schema_name .. "." .. table_name
    else
        full_name = table_name
    end
    return full_name
end

local function yank_current_model_name_to_clipboard(options)
    local full_name = ""

    if options["include_schema"] == false then
        full_name = get_current_model_name(false)
    else
        full_name = get_current_model_name(true)
    end

    if options["lowercase"] then
        full_name = string.lower(full_name)
    end
    if options["prefix"] ~= nil then
        full_name = options["prefix"] .. full_name
    end
    vim.fn.setreg("+", full_name)
    notify("Yanking model name " .. full_name, "info", {title = "Get DBT model", timeout = 1000})
end

local function test_harness()
    put(insert_model_ref())
end

M.test_harness = test_harness
M.go_to_definition = go_to_definition
M.telescope_jump_to_model_file = telescope_jump_to_model_file
M.get_model_names = get_model_names
M.get_current_model_name = get_current_model_name
M.yank_current_model_name_to_clipboard = yank_current_model_name_to_clipboard
M.insert_model_ref = insert_model_ref

return M
