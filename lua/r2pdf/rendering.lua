-- tutorial/rendering.lua
-- Author: Lien Zhu
-- Description: Logic for rendering PDFs


local render_pdf = function()
    local file = vim.fn.expand("%:p")
    local cmd = "Rscript -e \"rmarkdown::render('" .. file .. "')\""

    vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
            if code == 0 then
                vim.notify("Rendering complete: " .. file, vim.log.levels.INFO)
            else
                vim.notify("Rendering failed: " .. file, vim.log.levels.ERROR)
            end
        end,
    })
end

return {
    render_pdf = render_pdf
}
