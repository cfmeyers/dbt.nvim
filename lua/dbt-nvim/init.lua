local file_utils = require("dbt-nvim.file-utils")

local M = {}
M.test_harness = file_utils.test_harness
M.go_to_definition = file_utils.go_to_definition
M.telescope_jump_to_model_file = file_utils.telescope_jump_to_model_file
return M
