-- r2pdf.commands.lua
-- Author: Lien Zhu
-- Description: This file contains user and auto commands.


-- User command to render_pdf()
vim.api.nvim_create_user_command("R2PDF", require("r2pdf.rendering").render_pdf, {})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rmd",
    callback = function()
        vim.opt_local.formatoptions = ""
        vim.opt_local.autoindent = false        -- Disable auto-indentation
        vim.opt_local.smartindent = false       -- Disable smart indentation
    end,
})
