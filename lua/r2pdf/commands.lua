-- r2pdf.commands.lua
-- Author: Lien Zhu
-- Description: This file contains user and auto commands.


-- User command to render_pdf()
vim.api.nvim_create_user_command("R2PDF", require("r2pdf.rendering").render_pdf, {})
