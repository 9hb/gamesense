-- ------------------------- --
-- original code by Aviarita --
-- ------------------------- --

-- ------------------------- --
--     I just fixed code     --
-- ------------------------- --


package.path = package.path .. ".\\?.lua;.\\libs\\?.lua;"
local surface, err = pcall(require, "surface")
if err and surface == false then
    client.log(err)
    error("\a969696C8surface lua missing")
    return
end
local ffi = require("ffi")

local 
    client_latency,
    client_create_interface,
    client_set_event_callback,
    math_floor,
    require,
    string_format,
    ffi_cdef,
    ffi_cast,
    ui_get,
    ui_new_checkbox,
    ui_new_combobox,
    ui_new_hotkey,
    ui_new_slider,
    ui_reference =
    client.latency,
    client.create_interface,
    client.set_event_callback,
    math.floor,
    require,
    string.format,
    ffi.cdef,
    ffi.cast,
    ui.get,
    ui.new_checkbox,
    ui.new_combobox,
    ui.new_hotkey,
    ui.new_slider,
    ui.reference

ffi_cdef[[
    typedef void*(__thiscall* get_client_entity_t)(void*, int);
]]

local raw_ent_list = client_create_interface("client_panorama.dll", "VClientEntityList003")
local ent_list = ffi_cast(ffi.typeof("void***"), raw_ent_list)
local get_client_entity = ffi_cast("get_client_entity_t", ent_list[0][3])

local Verdana = renderer.create_font("Tahoma", 14, 700, {0x200})

local function round(b, c)
    local d = 10 ^ (c or 0)
    return math_floor(b * d + 0.5) / d
end

local b = ui.new_label("config", "lua", " ")
local b = ui.new_label("config", "lua", "\aE1FF00C8>> \aFFFFFFC8X88 UI \aE1FF00C8<<")

local x88Toggle = ui_new_hotkey("config", "lua", "\a969696C8Toggle")

local aimbot = ui_reference("legit", "Aimbot", "Enabled")
local triggerbot = ui_reference("legit", "Triggerbot", "Enabled")
local backtrack = ui_reference("legit", "Other", "Accuracy boost")
local quickstoplegit = ui_reference("legit", "Aimbot", "Quick stop")
local standalonercs = ui_reference("legit", "Other", "Standalone recoil compensation")
local reactshit = ui_reference("legit", "Aimbot", "Reaction time")

local BoxESP = ui_reference("visuals", "Player ESP", "Bounding box")
local NameESP = ui_reference("visuals", "Player ESP", "Name")
local GlowESP = ui_reference("visuals", "Player ESP", "Glow")
local WeaponESP = ui_reference("visuals", "Player ESP", "Weapon text")
local WeaponESP2 = ui_reference("visuals", "Player ESP", "Weapon icon")
local Skeleton = ui_reference("visuals", "Player ESP", "Skeleton")
local Radar = ui_reference("visuals", "Other ESP", "Radar")
local Speclist = ui_reference("visuals", "Other ESP", "Spectators")
local NoSky = ui_reference("visuals", "Effects", "Remove skybox")

local Bunnyhop = ui_reference("misc", "Movement", "Bunny hop")
local AutoStrafer = ui_reference("misc", "Movement", "Air strafe")
local ifdck = ui_reference("misc", "Movement", "Infinite duck")
local PingSpikeRef, PingSpikeHotkey, PingSpikeSlider = ui_reference("MISC", "Miscellaneous", "Ping spike")
local knifebot = ui_reference("misc", "Miscellaneous", "Knifebot")
local GetAll = entity.get_all
local GetProp = entity.get_prop
local rageaimbot, rageaimbothotkey = ui_reference("rage", "Aimbot", "Enabled")
local target = ui_reference("rage", "Aimbot", "Target Selection")
local multipoint = ui_reference("rage", "Aimbot", "Multi-point scale")
local autofire = ui_reference("rage", "Aimbot", "Automatic fire")
local autowall = ui_reference("rage", "Aimbot", "Automatic penetration")
local silentaim = ui_reference("rage", "Aimbot", "Silent aim")
local hitc = ui_reference("rage", "Aimbot", "Minimum Hit chance")
local mind = ui_reference("rage", "Aimbot", "Minimum damage")
local autoscope = ui_reference("rage", "Aimbot", "Automatic scope")
local aimstep = ui_reference("rage", "Aimbot", "Reduce aim step")
local norecoil = ui_reference("rage", "Other", "Remove recoil")
local autostop = ui_reference("rage", "Other", "Quick stop")
local resolver = ui_reference("rage", "Other", "Anti-aim correction")
local baim = ui_reference("rage", "Other", "Prefer body aim")

local slowmotion = ui_reference("AA", "Other", "Slow motion")
local onshot = ui_reference("AA", "Other", "On shot anti-aim")

local aapitch = ui_reference("AA", "Anti-aimbot angles", "Pitch")
local aayaw = ui_reference("AA", "Anti-aimbot angles", "Yaw")
local yawjit = ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")
local DesyncYaw = ui_reference("AA", "Anti-aimbot angles", "Body yaw")
local edge = ui_reference("AA", "Anti-aimbot angles", "Edge yaw")



local screenx, screeny = client.screen_size()

local x_offset = ui_new_slider("config", "lua", "\a91909090× Offset X", 0, screenx, 110)
local y_offset = ui_new_slider("config", "lua", "\a91909090× Offset Y", 0, screeny, 100)

local table_insert, table_remove = table.insert, table.remove
local globals_realtime, globals_absoluteframetime, globals_tickinterval =
    globals.realtime,
    globals.absoluteframetime,
    globals.tickinterval
local get_local_player, get_prop = entity.get_local_player, entity.get_prop
local min, abs, sqrt, floor = math.min, math.abs, math.sqrt, math_floor
local fklag = ui_reference("AA", "Fake lag", "Enabled")
local choke = ui_reference("AA", "Fake lag", "Limit")
local variance = ui_reference("AA", "Fake lag", "Variance")
local fklagtype = ui_reference("AA", "Fake lag", "Amount")
local GetLocalPlayer = entity.get_local_player
local min, abs, sqrt, floor = math.min, math.abs, math.sqrt, math_floor
local frametimes = {}
local fps_prev = 0
local chokedcommands = 0
local last_update_time = 0


local function accumulate_fps()
    local ft = globals_absoluteframetime()
    if ft > 0 then
        table_insert(frametimes, 1, ft)
    end

    local count = #frametimes
    if count == 0 then
        return 0
    end

    local i, accum = 0, 0
    while accum < 0.5 do
        i = i + 1
        accum = accum + frametimes[i]
        if i >= count then
            break
        end
    end
    accum = accum / i
    while i < count do
        i = i + 1
        table_remove(frametimes)
    end

    local fps = 1 / accum
    local rt = globals_realtime()
    if abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
        fps_prev = fps
        last_update_time = rt
    else
        fps = fps_prev
    end

    return floor(fps + 0.5)
end
local function clamp(min, max, current)
    if current > max then
        current = max
    elseif current < min then
        current = min
    end
    return floor(current)
end
local function DEC_HEX(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.fmod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

local basex = ui_get(x_offset)
local basey = 9 + ui_get(y_offset)
local multiplier = basey

ui.set_callback(x_offset, function() 
    basex = ui_get(x_offset)
end)

ui.set_callback(y_offset, function()
    basey = 9 + ui_get(y_offset)
    multiplier = 9 + ui_get(y_offset)
end)

local function draw_legitbot(multiplier, m_iKills, m_iDeaths, fps)
    local real_ping = floor(min(1000, client_latency()*1000) + 0.5)

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Aimbot: ")
    if ui_get(aimbot) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Quickstop: ")
    if ui_get(quickstoplegit) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15
    
    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Triggerbot: ")
    if ui_get(triggerbot) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Backtrack: ")
    --if ui_get(backtrack) == "Off" then
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, ui_get(backtrack))
    --end
    --if ui_get(backtrack) == "Low" then
    --    renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Low")
    --end
    --if ui_get(backtrack) == "High" then
    --    renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "High")
    --end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "StandaloneRCS: ")
    if ui_get(standalonercs) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "ReactionTime: ")
    renderer.draw_text(basex + 105, 30 + multiplier, 30, 209, 244, 255, Verdana, ui_get(reactshit))
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "BoxESP: ")
    if ui_get(BoxESP) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "NameESP: ")
    if ui_get(NameESP) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "WeaponESP: ")
    if ui_get(WeaponESP2) or ui_get(WeaponESP) then -- 200iq
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Glow: ")
    if ui_get(GlowESP) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Skeleton: ")
    if ui_get(Skeleton) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Radar: ")
    if ui_get(Radar) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "SpectatorList: ")
    if ui_get(Speclist) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "NoSky: ")
    if ui_get(NoSky) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    multiplier = basey

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Bunnyhop:")
    if ui_get(Bunnyhop) then
        renderer.draw_text(basex + 260, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "AutoStrafer:")
    if ui_get(AutoStrafer) then
        renderer.draw_text(basex + 260, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "FakeLatency:")
    if ui_get(PingSpikeRef) then
        renderer.draw_text(basex + 260, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Amount: ")
    renderer.draw_text(basex + 260, 30 + multiplier, 30, 209, 244, 255, Verdana, ui_get(PingSpikeSlider))
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "KnifeBot:")
    if ui_get(knifebot) then
        renderer.draw_text(basex + 260, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    local r, g, b
	if real_ping < 40 then
		r, g, b = 159, 202, 43
	elseif real_ping < 80 then
		r, g, b = 255, 222, 0
	else
		r, g, b = 255, 0, 60
	end


    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "RealPing: ")
    renderer.draw_text(basex + 260, 30 + multiplier, r, g, b, 255, Verdana, clamp(0, 309, real_ping), " ms")
    multiplier = multiplier + 15

    local tickrate = 1 / globals_tickinterval()
	if fps < tickrate then
		r, g, b = 255, 0, 60
	else
		r, g, b = 159, 202, 43
	end

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "FPS: ")
    renderer.draw_text(basex + 260, 30 + multiplier, r, g, b, 255, Verdana, fps)
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Kills: ")
    renderer.draw_text(basex + 260, 30 + multiplier, 159, 202, 43, 255, Verdana, m_iKills)
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Deaths: ")
    renderer.draw_text(basex + 260, 30 + multiplier, 159, 202, 43, 255, Verdana, m_iDeaths)
    multiplier = multiplier + 15
    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "KD: ")
    local kd = round(m_iKills/m_iDeaths, 2)
    if kd == math.huge or kd == -math.huge or kd~=kd then
        kd = m_iKills 
    end
    renderer.draw_text(basex + 260, 30 + multiplier, 159, 202, 43, 255, Verdana, kd)
end

local function draw_ragebot(multiplier, m_iKills, m_iDeaths, fps)
    local real_ping = floor(client_latency() * 1000)

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Aimbot: ")
    if ui_get(rageaimbot) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Target: ")
    if ui_get(target) == "Cycle" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Cycle")
    end
    if ui_get(target) == "Cycle (2x)" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Cycle 2x")
    end
    if ui_get(target) == "Near crosshair" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Crosshair")
    end
    if ui_get(target) == "Highest damage" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Damage")
    end
    if ui_get(target) == "Lowest ping" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "LowestPing")
    end
    if ui_get(target) == "Best K/D ratio" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "K/D ratio")
    end
    if ui_get(target) == "Best hit chance" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Hitchance")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "MP Scale: ")
    renderer.draw_text(basex + 105, 30 + multiplier, 30, 209, 244, 255, Verdana, ui_get(multipoint))
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "AutoFire: ")
    if ui_get(autofire) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "AutoWall: ")
    if ui_get(autowall) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "SilentAim: ")
    if ui_get(silentaim) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "HitChance: ")
    renderer.draw_text(basex + 105, 30 + multiplier, 30, 209, 244, 255, Verdana, ui_get(hitc))
    multiplier = multiplier + 15
    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "MinDamage: ")
    renderer.draw_text(basex + 105, 30 + multiplier, 30, 209, 244, 255, Verdana, ui_get(mind))
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "AutoScope: ")
    if ui_get(autoscope) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "AimStep: ")
    if ui_get(aimstep) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "NoRecoil: ")
    if ui_get(norecoil) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "AutoStop: ")
    if ui_get(autostop) == "Off" then
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    if ui_get(autostop) == "On" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Normal")
    end
    if ui_get(autostop) == "On + duck" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Duck")
    end
    if ui_get(autostop) == "On + slow motion" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "SlowMotion")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "Resolver: ")
    if ui_get(resolver) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "BAIM: ")
    if ui_get(baim) == "Off" then
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    if ui_get(baim) == "Always on" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Always")
    end
    if ui_get(baim) == "Moving targets" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "MovingTargets")
    end
    if ui_get(baim) == "Aggressive" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Aggressive")
    end
    if ui_get(baim) == "High inaccuracy" then
        renderer.draw_text(basex + 105, 30 + multiplier, 20, 255, 20, 255, Verdana, "Inaccuracy")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex, 30 + multiplier, 255, 255, 255, 255, Verdana, "FakeWalk: ")
    if ui_get(slowmotion) then
        renderer.draw_text(basex + 105, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 105, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = basey
    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "AAPitch: ")
    if ui_get(aapitch) == "Off" then
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    if ui_get(aapitch) == "Default" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Down")
    end
    if ui_get(aapitch) == "Up" then
        renderer.draw_text(basex + 260, 30 + multiplier + multiplier, 20, 255, 20, 255, Verdana, "Up")
    end
    if ui_get(aapitch) == "Down" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Down")
    end
    if ui_get(aapitch) == "Minimal" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Minimal")
    end
    if ui_get(aapitch) == "Random" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Random")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "AAYaw: ")
    if ui_get(aayaw) == "Off" then
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    if ui_get(aayaw) == "180" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Backwards")
    end
    if ui_get(aayaw) == "Spin" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "SpinBot")
    end
    if ui_get(aayaw) == "Static" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Static")
    end
    if ui_get(aayaw) == "180 Z" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "HalfSpin")
    end
    if ui_get(aayaw) == "Crosshair" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Crosshair")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "YawJitter: ")
    if ui_get(yawjit) == "Off" then
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    if ui_get(yawjit) == "Offset" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Offset")
    end
    if ui_get(yawjit) == "Center" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Center")
    end
    if ui_get(yawjit) == "Random" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Random")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "DesyncYaw: ")
    if ui_get(DesyncYaw) == "Off" then
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    if ui_get(DesyncYaw) == "Opposite" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Opposite")
    end
    if ui_get(DesyncYaw) == "Jitter" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Jitter")
    end
    if ui_get(DesyncYaw) == "Static" then
        renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, "Static")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Edge: ")
    if ui_get(edge) == "Off" then
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    if ui_get(edge) == "Static" then
        renderer.draw_text(basex + 260, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "FakeLag: ")
    if ui_get(fklag) then
        renderer.draw_text(basex + 260, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Type: ")
    renderer.draw_text(basex + 260, 30 + multiplier, 20, 255, 20, 255, Verdana, ui_get(fklagtype))
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Variance: ")
    renderer.draw_text(basex + 260, 30 + multiplier, 30, 209, 244, 255, Verdana, ui_get(variance))
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Choke: ")
    renderer.draw_text(basex + 260, 30 + multiplier, 30, 209, 244, 255, Verdana, ui_get(choke))
    renderer.draw_text(basex + 290, 30 + multiplier, 255, 255, 255, 255, Verdana, "Choked: ")
    renderer.draw_text(basex + 350, 30 + multiplier, 30, 209, 244, 255, Verdana, chokedcommands)
    multiplier = multiplier + 15


    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "InfiniteDuck: ")
    if ui_get(ifdck) then
        renderer.draw_text(basex + 260, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "HideShots: ")
    if ui_get(onshot) then
        renderer.draw_text(basex + 260, 30 + multiplier, 36, 141, 255, 255, Verdana, "ON")
    else
        renderer.draw_text(basex + 260, 30 + multiplier, 255, 255, 255, 255, Verdana, "OFF")
    end
    multiplier = multiplier + 30

    local r, g, b
	if real_ping < 40 then
		r, g, b = 159, 202, 43
	elseif real_ping < 80 then
		r, g, b = 255, 222, 0
	else
		r, g, b = 255, 0, 60
	end

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Ping: ")
    renderer.draw_text(basex + 260, 30 + multiplier, r, g, b, 255, Verdana, clamp(0, 309, real_ping), " ms")
    multiplier = multiplier + 15

    local tickrate = 1 / globals_tickinterval()
	if fps < tickrate then
		r, g, b = 255, 0, 60
	else
		r, g, b = 159, 202, 43
	end

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "FPS: ")
    renderer.draw_text(basex + 260, 30 + multiplier, r, g, b, 255, Verdana, fps)
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Kills: ")
    renderer.draw_text(basex + 260, 30 + multiplier, 159, 202, 43, 255, Verdana, m_iKills)
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "Deaths: ")
    renderer.draw_text(basex + 260, 30 + multiplier, 159, 202, 43, 255, Verdana, m_iDeaths)
    multiplier = multiplier + 15

    renderer.draw_text(basex + 180, 30 + multiplier, 255, 255, 255, 255, Verdana, "KD: ")

    local kd = round(m_iKills/m_iDeaths, 2)
    if kd == math.huge or kd == -math.huge or kd~=kd then
        kd = m_iKills 
    end
    renderer.draw_text(basex + 260, 30 + multiplier, 159, 202, 43, 255, Verdana, kd)
end

client_set_event_callback("run_command", function(e)
    chokedcommands = e.chokedcommands
end)

local function OnPaint(ctx)
    local playerresource = GetAll("CCSPlayerResource")[1]
    local m_iKills = GetProp(playerresource, "m_iKills", GetLocalPlayer())
    local m_iDeaths = GetProp(playerresource, "m_iDeaths", GetLocalPlayer())

    local fps = accumulate_fps()


    if ui_get(x88Toggle) then 
        local lp_address = ffi_cast("int*", get_client_entity(ent_list, GetLocalPlayer()))[0]
		
        renderer.draw_text(basex, 5 + multiplier - 15, 255, 255, 0, 255, Verdana, "Hello esoterik :)")
        renderer.draw_text(basex, 5 + multiplier, 255, 255, 0, 255, Verdana, "Hello domcqq :)")
		
        if ui_get(rageaimbot) and ui_get(rageaimbothotkey) then 
            draw_ragebot(multiplier, m_iKills, m_iDeaths, fps)
        else
            draw_legitbot(multiplier, m_iKills, m_iDeaths, fps)
        end
    end
end

client_set_event_callback("paint", OnPaint)
