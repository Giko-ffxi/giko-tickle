local config = require('lib.giko.config')
local common = require('lib.giko.common')

local ui = { hp = {}, mp = {}, tp = {}, dv = {}, mi = {}, ti = {}} 

local c_width  = 116
local c_height = 9

ui.load = function()

    ui.mi.bg = ui.component('__giko_tickle_ui_l9_mi_bg', 'dot.png', config.ui.position[1] or (ashita.gui.io.DisplaySize.x / 2 - 140), config.ui.position[2] or (ashita.gui.io.DisplaySize.y - 300), 600, 25)

    ui.hp.bg = ui.component('__giko_tickle_ui_l1_hp_bg', 'bg.png', 0, 0, 126, 12, ui.mi.bg)
    ui.mp.bg = ui.component('__giko_tickle_ui_l1_mp_bg', 'bg.png', 0, 0, 126, 12, ui.mi.bg)
    ui.tp.bg = ui.component('__giko_tickle_ui_l1_tp_bg', 'bg.png', 0, 0, 126, 12, ui.mi.bg)
    ui.ti.bg = ui.component('__giko_tickle_ui_l1_ti_bg', 'bg.png', 0, 0, 126, 12, ui.mi.bg)
        
    ui.hp.pg = ui.component('__giko_tickle_ui_l2_hp_pg', 'hp.png', 5, 1, c_width, c_height, ui.hp.bg)
    ui.mp.pg = ui.component('__giko_tickle_ui_l2_mp_pg', 'mp.png', 5, 1, c_width, c_height, ui.mp.bg)
    ui.tp.pg = ui.component('__giko_tickle_ui_l2_tp_pg', 'tp.png', 5, 1, 0, c_height, ui.tp.bg)
    ui.ti.pg = ui.component('__giko_tickle_ui_l2_ti_pg', 'ti.png', 5, 1, 0, c_height, ui.ti.bg)
    ui.dv.pg = ui.component('__giko_tickle_ui_l3_dv_pg', 'dv.png', 5, 1, 0, c_height, ui.ti.bg)

    ui.hp.tt = ui.text('__giko_tickle_ui_l4_hp_tt', nil, true, 120, 14, ui.hp.bg)
    ui.mp.tt = ui.text('__giko_tickle_ui_l4_mp_tt', nil, true, 120, 14, ui.mp.bg)
    ui.tp.tt = ui.text('__giko_tickle_ui_l4_tp_tt', nil, true, 120, 14, ui.tp.bg)
    ui.ti.tt = ui.text('__giko_tickle_ui_l4_ti_tt', nil, true, 120, 14, ui.ti.bg)
    
    ui.hp.ll = ui.text('__giko_tickle_ui_l4_hp_ll', 'Hp', false, 3, 14, ui.hp.bg)
    ui.mp.ll = ui.text('__giko_tickle_ui_l4_mp_ll', 'Mp', false, 3, 14, ui.mp.bg)
    ui.tp.ll = ui.text('__giko_tickle_ui_l4_tp_ll', 'Tp', false, 3, 14, ui.tp.bg)
    ui.ti.ll = ui.text('__giko_tickle_ui_l4_ti_ll', 'Tickle', false, 3, 14, ui.ti.bg)

end 

ui.render = function()

    local entity = GetPlayerEntity()

    ui.mi.bg:SetVisibility(config.ui.visible and entity ~= nil)

    ui.hp.bg:SetVisibility(config.ui.visible and config.hp.enabled and entity ~= nil)
    ui.hp.pg:SetVisibility(config.ui.visible and config.hp.enabled and entity ~= nil)
    ui.hp.tt:SetVisibility(config.ui.visible and config.hp.enabled and entity ~= nil)
    ui.hp.ll:SetVisibility(config.ui.visible and config.hp.enabled and entity ~= nil)

    ui.mp.bg:SetVisibility(config.ui.visible and config.mp.enabled and entity ~= nil)
    ui.mp.pg:SetVisibility(config.ui.visible and config.mp.enabled and entity ~= nil)
    ui.mp.tt:SetVisibility(config.ui.visible and config.mp.enabled and entity ~= nil)
    ui.mp.ll:SetVisibility(config.ui.visible and config.mp.enabled and entity ~= nil)    
    
    ui.tp.bg:SetVisibility(config.ui.visible and config.tp.enabled and entity ~= nil)
    ui.tp.pg:SetVisibility(config.ui.visible and config.tp.enabled and entity ~= nil)
    ui.tp.tt:SetVisibility(config.ui.visible and config.tp.enabled and entity ~= nil)
    ui.tp.ll:SetVisibility(config.ui.visible and config.tp.enabled and entity ~= nil)

    ui.ti.bg:SetVisibility(config.ui.visible and config.tick.enabled and entity ~= nil)
    ui.ti.pg:SetVisibility(config.ui.visible and config.tick.enabled and entity ~= nil)
    ui.dv.pg:SetVisibility(config.ui.visible and config.tick.enabled and entity ~= nil)
    ui.ti.tt:SetVisibility(config.ui.visible and config.tick.enabled and entity ~= nil)
    ui.ti.ll:SetVisibility(config.ui.visible and config.tick.enabled and entity ~= nil)

    ui.mp.bg:SetPositionX((config.hp.enabled and 1 or 0) * 145)
    ui.tp.bg:SetPositionX(((config.hp.enabled and 1 or 0) + (config.mp.enabled and 1 or 0)) * 145)
    ui.ti.bg:SetPositionX(((config.hp.enabled and 1 or 0) + (config.mp.enabled and 1 or 0) + (config.tp.enabled and 1 or 0)) * 145)

    ui.mi.bg:GetBackground():SetWidth(math.max(0, (((config.hp.enabled and 1 or 0) + (config.mp.enabled and 1 or 0) + (config.tp.enabled and 1 or 0) + (config.tick.enabled and 1 or 0) - 1) * 145) + 126))

end

ui.hp.set = function(hp, hpp)

    ui.hp.pg:GetBackground():SetWidth(hpp / 100 * c_width)
    ui.hp.tt:SetText(string.format('%d', hp))

end

ui.mp.set = function(mp, mpp)

    ui.mp.pg:GetBackground():SetWidth(mpp / 100 * c_width)
    ui.mp.tt:SetText(string.format('%d', mp))

end

ui.tp.set = function(tp)

    ui.tp.pg:GetBackground():SetWidth(tp / 3000 * c_width)
    ui.tp.tt:SetText(string.format('%d', tp))

end

ui.ti.set = function(c, mc, dv)

    ui.dv.pg:GetBackground():SetWidth(math.min(c_width * (1 - math.min(c / mc, 1)), c_width * math.min(dv / mc, 1)))
    ui.ti.pg:GetBackground():SetWidth(c_width * (1 - math.min(c / mc, 1)))
    ui.ti.tt:SetText(string.format('%d', math.max(0, mc - c)))

end

ui.unload = function()
        
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l9_mi_bg')
	
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l1_hp_bg')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l1_mp_bg')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l1_tp_bg')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l1_ti_bg')
	
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l2_hp_pg')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l2_mp_pg')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l2_tp_pg')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l2_ti_pg')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l3_dv_pg')    
    
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l4_hp_ll')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l4_mp_ll')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l4_tp_ll')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l4_ti_ll')

    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l4_hp_tt')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l4_mp_tt')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l4_tp_tt')
    AshitaCore:GetFontManager():Delete('__giko_tickle_ui_l4_ti_tt')

end

ui.text = function(name, val, right, x, y, parent, visibility)

    local text = AshitaCore:GetFontManager():Create(name)

    text:SetText(val ~= nil and val or '')
    text:SetBold(true)
    text:SetParent(parent)
    text:SetFontFamily('Verdana')
    text:SetFontHeight(8)
    text:SetRightJustified(right)
    text:SetColor(0xFFE2E2E2)
    text:SetPositionX(x)
    text:SetPositionY(y)
    text:SetVisibility(visibility == true or visibility == nil or false)
    text:SetAutoResize(false)
    text:SetLocked(true)

    return text

end

ui.component = function(name, img, x, y, w, h, parent, visibility)

    local component = AshitaCore:GetFontManager():Create(name)

    component:GetBackground():SetTextureFromFile(string.format('%s/assets/%s', _addon.path, img))
    component:GetBackground():SetVisibility(visibility == true or visibility == nil or false)
    component:GetBackground():SetColor(0xFFFFFFFF)
    component:GetBackground():SetWidth(w)
    component:GetBackground():SetHeight(h)
    
    component:SetParent(parent)
    component:SetPositionX(x)
    component:SetPositionY(y)
    component:SetVisibility(visibility == true or visibility == nil or false)
    component:SetAutoResize(false)

    return component

end

return ui