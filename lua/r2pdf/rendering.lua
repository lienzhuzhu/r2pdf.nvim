-- tutorial/rendering.lua
-- Author: Lien Zhu
-- Description: Logic for rendering PDFs


local render_pdf = function ()
    local file = vim.fn.expand("%:p")
    print("INFO: Rendering PDF from " .. file)
    local cmd = "Rscript -e \"rmarkdown::render('" .. file .. "')\""
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        print("Error: Failed to render " .. file)
    end
    print("INFO: Rendered PDF from" .. file)
end

return {
    render_pdf = render_pdf
}
