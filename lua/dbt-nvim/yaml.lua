local TSUtils = require("nvim-treesitter.ts_utils")
local Q = require("vim.treesitter.query")
local ContextManager = require("plenary.context_manager")

M = {}

local function get_file_contents(full_path)
    local with = ContextManager.with
    local open = ContextManager.open

    local result = with(
                       open(full_path), function(reader)
            return reader:read("*all")
        end
                   )
    return result
end

local function get_model_names(full_path)
    -- todo: use metadata in query to get both model names AND model positions within file
    --       so this function can return a list of names + line numbers
    yaml_string = get_file_contents(full_path)
    local language_tree = vim.treesitter.get_string_parser(yaml_string, "yaml")
    local syntax_tree = language_tree:parse()
    local root = syntax_tree[1]:root()

    local query_text = [[
(
    block_mapping_pair
        key: (flow_node (plain_scalar (string_scalar) @models_ss))
        value: (block_node
                    (block_sequence
                        (block_sequence_item
                            (block_node
                                (block_mapping
                                    (block_mapping_pair
                                     key: (flow_node (plain_scalar (string_scalar) @model_name_key_ss ))
                                     value: (flow_node (plain_scalar (string_scalar) @model_name_value_ss ))
                                    ))))))
        (#eq? @models_ss "models")
        (#eq? @model_name_key_ss "name")
)
    ]]
    local query = vim.treesitter.parse_query("yaml", query_text)

    t = {}
    for _, captures, metadata in query:iter_matches(root, yaml_string) do
        table.insert(t, Q.get_node_text(captures[3], yaml_string))
    end
    return t
end

M.get_yaml_version = get_yaml_version
M.get_model_names = get_model_names

return M
