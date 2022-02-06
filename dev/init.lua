for k in pairs(package.loaded) do
    if k:match("^dbt") then
        package.loaded[k] = nil
    end
end

package.loaded["dev"] = nil
require("dbt-nvim").test_harness()
vim.api.nvim_set_keymap("n", ",t", ":luafile dev/init.lua<cr>", {})
vim.api.nvim_set_keymap("v", ",t", ":luafile dev/init.lua<cr>", {})
