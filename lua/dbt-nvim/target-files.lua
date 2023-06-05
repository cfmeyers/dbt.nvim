local notify = require("notify").notify
local FileUtils = require("dbt-nvim.file-utils")
local Scan = require("plenary.scandir")

M = {}

local function read_file(path)
  local file = io.open(path, "r")
  local data = file:read("*a")
  file.close()
  return data
end

local function get_target_dir()
    root_dir = FileUtils.get_dbt_root_dir()
    return root_dir .. "/target"
end

local function parse_catalog()
    target_dir = get_target_dir()
    catalog_path = target_dir .. "/catalog.json"
    raw_json_data = read_file(catalog_path)
    parsed_json = vim.json.decode(raw_json_data)
    -- put(parsed_json["nodes"]["model.luma.MORNINGSTAR_EXPORT_PRODUCT_CLIENT_MAPPING"])
    return parsed_json
end

catalog = parse_catalog()

local function test_harness()
    put(catalog["nodes"]["model.luma.issuer_mapping"]["metadata"]["comment"])
    -- put(catalog["nodes"])
    -- parse_catalog()
    -- put(insert_model_ref())
end

M.parse_catalog = parse_catalog
M.test_harness = test_harness
return M
