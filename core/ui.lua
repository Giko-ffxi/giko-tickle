local config = require('lib.giko.config')
local common = require('lib.giko.common')

local ui = { hp = {}, mp = {}, tp = {}, dv = {}, ti = {}, bg = { tp = {}, ti = {} }} 

local c_width  = 116
local c_height = 9

ui.load = function()

    ui.hp.text = ui.text('__giko_vital_ui_l4_hp_text', config.ui.position[1] + 130, config.ui.position[2] + 12)
    ui.mp.text = ui.text('__giko_vital_ui_l4_mp_text', config.ui.position[1] + 271, config.ui.position[2] + 12)
    ui.tp.text = ui.text('__giko_vital_ui_l4_tp_text', config.ui.position[1] + 414, config.ui.position[2] + 12)
    ui.ti.text = ui.text('__giko_vital_ui_l4_ti_text', config.ui.position[1] + 557, config.ui.position[2] + 12)
    
    ui.hp.component = ui.component('__giko_vital_ui_l2_hp', 'hp.png', config.ui.position[1] + 15, config.ui.position[2] + 1, c_width, c_height)
    ui.mp.component = ui.component('__giko_vital_ui_l2_mp', 'mp.png', config.ui.position[1] + 156, config.ui.position[2] + 1, c_width, c_height)
    ui.tp.component = ui.component('__giko_vital_ui_l2_tp', 'tp.png', config.ui.position[1] + 299, config.ui.position[2] + 1, 0, c_height)
    ui.ti.component = ui.component('__giko_vital_ui_l2_ti', 'ti.png', config.ui.position[1] + 441, config.ui.position[2] + 1, 0, c_height)
    ui.dv.component = ui.component('__giko_vital_ui_l3_dv', 'dv.png', config.ui.position[1] + 441, config.ui.position[2] + 1, 0, c_height)
    ui.bg.component = ui.component('__giko_vital_ui_l1_bg', 'bg.png', config.ui.position[1], config.ui.position[2], 575, 24)

end 

ui.hp.set = function(hp, hpp)
    ui.hp.text:SetText(string.format('%d', hp))
    ui.hp.component:GetBackground():SetWidth(hpp / 100 * c_width)
end

ui.mp.set = function(mp, mpp)
    ui.mp.text:SetText(string.format('%d', mp))
    ui.mp.component:GetBackground():SetWidth(mpp / 100 * c_width)
end

ui.tp.set = function(tp)
    ui.tp.text:SetText(string.format('%d', tp))
    ui.tp.component:GetBackground():SetWidth(tp / 3000 * c_width)
end

ui.ti.set = function(c, mc, dv)
    ui.ti.text:SetText(string.format('%d', math.max(0, mc - c)))
    ui.dv.component:GetBackground():SetWidth(math.min(c_width * (1 - math.min(c / mc, 1)), c_width * math.min(dv / mc, 1)))
    ui.ti.component:GetBackground():SetWidth(c_width * (1 - math.min(c / mc, 1)))
end

ui.unload = function()
        
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l4_hp_text')
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l4_mp_text')
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l4_tp_text')
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l4_ti_text')

    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l2_hp')
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l2_mp')
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l2_tp')
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l2_ti')
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l3dw_dv')
    AshitaCore:GetFontManager():Delete('__giko_vital_ui_l1_bg')

end

ui.text = function(name, x, y, visibility)

    local text = AshitaCore:GetFontManager():Create(name)

    text:SetBold(true)
    text:SetFontFamily('Verdana')
    text:SetFontHeight(8)
    text:SetRightJustified(true)
    text:SetPositionX(x)
    text:SetPositionY(y)
    text:SetVisibility(visibility == true or visibility == nil or false)
    text:SetAutoResize(false)
    text:SetLocked(true)

    return text

end

ui.component = function(name, img, x, y, w, h, visibility)

    local component = AshitaCore:GetFontManager():Create(name)

    component:GetBackground():SetTextureFromFile(string.format('%s/assets/%s', _addon.path, img))
    component:GetBackground():SetVisibility(visibility == true or visibility == nil or false)
    component:GetBackground():SetColor(0xFFFFFFFF)
    component:GetBackground():SetWidth(w)
    component:GetBackground():SetHeight(h)
    
    component:SetPositionX(x)
    component:SetPositionY(y)
    component:SetVisibility(visibility == true or visibility == nil or false)
    component:SetAutoResize(false)
    component:SetLocked(true)

    return component

end

return ui