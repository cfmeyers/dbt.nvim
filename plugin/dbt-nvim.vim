" commands

command! DBTCheck lua require('dbt-nvim').test_harness()
command! DBTGoToDefinition lua require('dbt-nvim').go_to_definition()
command! DBTTelescopeJumpToModelFile lua require('dbt-nvim').telescope_jump_to_model_file()
command! DBTInsertModelRef lua require('dbt-nvim').insert_model_ref()
