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
                local pdf = vim.fn.expand("%:r") .. ".pdf"
                vim.fn.jobstart("sioyek " .. pdf .. " &") --TODO: replace with opts.pdf_reader
            else
                vim.notify("Rendering failed: " .. file, vim.log.levels.ERROR)
            end
        end,
    })
end

return {
    render_pdf = render_pdf
}
