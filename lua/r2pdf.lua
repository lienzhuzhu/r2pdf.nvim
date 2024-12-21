-- r2pdf.lua
-- Author: Lien Zhu
-- Description: r2pdf NeoVim plugin entry point.


local internal_setup = require("r2pdf.setup")

local function setup(opts)
    internal_setup.update_config(opts)
    require("r2pdf.commands")
end

return {
    setup = setup,
    print_config = internal_setup.print_config,
}
