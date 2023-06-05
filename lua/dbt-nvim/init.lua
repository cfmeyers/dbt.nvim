local file_utils = require("dbt-nvim.file-utils")
local target_files = require("dbt-nvim.target-files")

local M = {}
M.go_to_definition = file_utils.go_to_definition
M.telescope_jump_to_model_file = file_utils.telescope_jump_to_model_file
M.get_model_names = file_utils.get_model_names
M.get_current_model_name = file_utils.get_current_model_name
M.yank_current_model_name_to_clipboard = file_utils.yank_current_model_name_to_clipboard
M.insert_model_ref = file_utils.insert_model_ref
-- M.test_harness = file_utils.test_harness
M.test_harness = target_files.test_harness
return M
