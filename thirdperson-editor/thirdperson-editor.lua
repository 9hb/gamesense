-- -------------- --
-- made by domcqq --
-- -------------- --


local console_cmd = client.exec
local ui_get = ui.get

local a = ui.new_label("config", "lua", " ")

local vzdalenost = ui.new_slider("config", "lua", "Distance Editor", 1, 180, 100, true)

local function funkce(val)
    console_cmd("cam_idealdist " .. ui_get(val))
end

ui.set_callback(vzdalenost, funkce)
