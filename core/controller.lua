local config = require('lib.giko.config')
local common = require('lib.giko.common')
local packer = require('lib.giko.packer')
local ui     = require('core.ui')

local controller = { incoming_heals = {}, tics = {} }

controller.load = function()

    ui.load()

end

controller.render = function()
       
    local hp  = AshitaCore:GetDataManager():GetParty():GetMemberCurrentHP(0)
    local mp  = AshitaCore:GetDataManager():GetParty():GetMemberCurrentMP(0)
    local tp  = AshitaCore:GetDataManager():GetParty():GetMemberCurrentTP(0)
    local hpp = AshitaCore:GetDataManager():GetParty():GetMemberCurrentHPP(0)
    local mpp = AshitaCore:GetDataManager():GetParty():GetMemberCurrentMPP(0)

    local c  = #controller.tics > 0 and (os.clock() - controller.tics[#controller.tics]) or 0
    local mc, dv = controller.next()

    ui.hp.set(hp, hpp)
    ui.mp.set(mp, mpp)
    ui.tp.set(tp)
    ui.ti.set(c, (hpp ~= 100 or mpp ~= 100) and mc or 0, dv)
    ui.render()

end

controller.incoming = function(id, size, packet, packet_modified, blocked)
    
    local entity = GetPlayerEntity()

    if entity ~= nil then

        if (id == 0x28) then

            local action = packer.get_action(packet)
            local heals  = {7, 24, 25, 26, 102, 103, 122, 152, 167, 224, 238, 263, 276, 306, 318, 367, 384, 651}

            for i, target in ipairs(action.targets) do

                if action.type == 4 and target.id == AshitaCore:GetDataManager():GetParty():GetMemberServerId(0) and common.in_array(heals, target.actions[1].message) then
                    
                    table.insert(controller.incoming_heals, {time = os.clock, amount = target.actions[1].parameter})

                end

            end

        end

        if (id == 0x037) then   

            local ps = entity.Status
            local ns = struct.unpack('B', packet, 0x30 + 1)

            if ns == 33 and ps ~= 33 then                  
                controller.tics = {os.clock()}
            end

            if ps == 33 and ns ~= 33 then                  
                controller.tics = {}
            end

        end

        if id == 0x0DF and struct.unpack('I', packet, 0x04 + 1) == AshitaCore:GetDataManager():GetParty():GetMemberServerId(0) then  

            local es  = entity.Status
            local hp  = struct.unpack('I', packet, 0x08 + 1)
            local mp  = struct.unpack('I', packet, 0x0C + 1)
            local chp = AshitaCore:GetDataManager():GetParty():GetMemberCurrentHP(0)
            local cmp = AshitaCore:GetDataManager():GetParty():GetMemberCurrentMP(0)

            local c  = #controller.tics > 0 and (os.clock() - controller.tics[#controller.tics]) or 0
            local mc, dv = controller.next()

            if es == 33 and (hp - chp >= 10 or mp - cmp >= 12) and (c > (mc - dv)) then

                if hp - chp >= 10 then
                    for i, h in ipairs(controller.incoming_heals) do
                        if hp - chp == h.amount then
                            table.remove(controller.incoming_heals, i)           
                            return false
                        end
                    end
                end

                table.insert(controller.tics, os.clock())

            end
                
        end

    end

    return false;

end

controller.next = function()

    local avg = 0
    local dev = 0

    if #controller.tics == 1 then
        avg = 19
        dev = 3.5
    end
    
    if #controller.tics == 2 or #controller.tics == 3 then        
        avg = 8
        dev = 3.5
    end
        
    if #controller.tics > 3 then        
        avg = (controller.tics[#controller.tics - 1] - controller.tics[#controller.tics - 2]) < 10 and (controller.tics[#controller.tics] - controller.tics[#controller.tics - 1]) < 10 and 11 or 8
        dev = 1.5
    end

    return avg + dev, dev
    
end

controller.mouse = function(id, x, y, delta, blocked)

    local x1 = ui.mi.bg:GetBackground():GetPositionX()
    local y1 = ui.mi.bg:GetBackground():GetPositionY()
    local x2 = x1 + ui.mi.bg:GetBackground():GetWidth()
    local y2 = y1 + ui.mi.bg:GetBackground():GetHeight()

    ui.hover = x > x1 and x < x2 and y > y1 and y < y2

    if id == 512 and (config.ui.position[1] ~= x1 or config.ui.position[2] ~= y1) then
    
        config.ui.position[1] = x1
        config.ui.position[2] = y1

        ashita.timer.create('save', 1, 1, function()
            config.save()
        end)

    end

    return false

end

controller.unload = function()
 
    ui.unload()

end

return controller
