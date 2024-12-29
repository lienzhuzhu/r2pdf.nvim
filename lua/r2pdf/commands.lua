-- r2pdf.commands.lua
-- Author: Lien Zhu
-- Description: This file contains user and auto commands.
-- https://github.com/nvim-neorocks/nvim-best-practices


---@class R2PDFsubcommand
---@field impl fun(args:string[], opts: table) The command implementation
---@field complete? fun(subcmd_arg_lead: string): string[] (optional) Command completions callback, taking the lead of the subcommand's arguments

---@type table<string, R2PDFsubcommand>
local subcommand_tbl = {
    --[[ Example from best practices guideline. https://github.com/nvim-neorocks/nvim-best-practices
    install = {
        impl = function(args, opts)
            -- Implementation
            print(opts)
            print(args)
        end,
        complete = function(subcmd_arg_lead)
            -- Simplified example
            local install_args = {
                "neorg",
                "rest.nvim",
                "rustaceanvim",
            }
            return vim.iter(install_args)
                :filter(function(install_arg)
                    -- If the user has typed `:R2PDF install ne`,
                    -- this will match 'neorg'
                    return install_arg:find(subcmd_arg_lead) ~= nil
                end)
                :totable()
        end,
    },
    --]]
    render = {
        impl = require("r2pdf.rendering").render_pdf,
    },
}


-- Run the (sub)command
---@param opts table :h lua-guide-commands-create
local function my_cmd(opts)
    local fargs = opts.fargs
    local subcommand_key = fargs[1]
    -- Get the subcommand's arguments, if any
    local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
    local subcommand = subcommand_tbl[subcommand_key]
    if not subcommand then
        vim.notify("R2PDF: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
        return
    end
    -- Invoke the subcommand
    subcommand.impl(args, opts)
end


-- Register `my_cmd` to be invoked by user command 
vim.api.nvim_create_user_command("R2PDF", my_cmd, {
    nargs = "+",
    desc = "R2PDF user command with subcommand parsing",
    complete = function(arg_lead, cmdline, _)
        -- Get the subcommand.
        local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*R2PDF[!]*%s(%S+)%s(.*)$")
        if subcmd_key
            and subcmd_arg_lead
            and subcommand_tbl[subcmd_key]
            and subcommand_tbl[subcmd_key].complete
        then
            return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
        end
        -- Check if cmdline is a subcommand
        if cmdline:match("^['<,'>]*R2PDF[!]*%s+%w*$") then
            -- Filter subcommands that match
            local subcommand_keys = vim.tbl_keys(subcommand_tbl)
            return vim.iter(subcommand_keys)
                :filter(function(key)
                    return key:find(arg_lead) ~= nil
                end)
                :totable()
        end
    end,
    bang = true, -- If you want to support ! modifiers
})



-- R2PDF render autocommand
local timer = nil
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.Rmd",
  --pattern = { "rmd", "markdown" },
  callback = function()
    if timer then
      timer:stop()
    end
    timer = vim.loop.new_timer()
    timer:start(100, 0, vim.schedule_wrap(function()
        vim.cmd("R2PDF render")
    end))
  end,
})
