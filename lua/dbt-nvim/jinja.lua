M = {}

local function get_ref(line)
    _, _, model_name = string.find(line, "{{%s*ref%(%s*[\'\"]([%w_]+)[\'\"]%s*%)%s*}}")
    return model_name
end

local function get_source(line)
    _, _, source_name, table_name = string.find(
                                        line,
                                        "{{%s*source%(%s*[\'\"]([%w_]+)[\'\"]%s*,%s*[\'\"]([%w_]+)[\'\"]%s*%)%s*}}"
                                    )
    return source_name, table_name
end

local function get_schema(line)
    _, _, model_name = string.find(line, "schema=[\'\"]([%w_]+)[\'\"]")
    return model_name
end

M.get_ref = get_ref
M.get_source = get_source
M.get_schema = get_schema

return M
