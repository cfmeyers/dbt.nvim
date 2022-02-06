local file_utils = require("dbt-nvim.file-utils")

local M = {}
M.test_harness = file_utils.test_harness
M.go_to_definition = file_utils.go_to_definition
return M
