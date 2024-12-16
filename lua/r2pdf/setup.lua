-- r2pdf/setup.lua
-- Author: Lien Zhu
-- Description: Logic for setup and configuration of r2pdf.


local _config = {
    output_type = "pdf_document",
    pdf_reader = "sioyek"
}


local _update_config = function (opts)
    print("DEBUG: _setup() was called")
    ---[[
    _config = vim.tbl_deep_extend("force", _config, opts or {})
    --]]
end

local _get_config = function ()
    return _config
end

local _print_config = function()
    for k, v in pairs(_config) do
        print(k .. ": " .. tostring(v))
    end
end

return {
    update_config = _update_config,
    get_config = _get_config,
    print_config = _print_config,
}
