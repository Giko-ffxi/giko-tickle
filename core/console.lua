local config  = require('lib.giko.config')
local common  = require('lib.giko.common')
local death   = require('lib.giko.death')
local monster = require('lib.giko.monster')
local chat    = require('lib.giko.chat')
local console = { command= {} }

console.input = function(command, ntype)

    local command, args = string.match(command, '^/giko[%s-]+tickle%s+(%w+)(.*)')

    if command == nil then
        return false
    end

    local registry = 
    {
        ['visible']  = console.command.visible,
        ['enable']   = console.command.enable,
        ['disable']  = console.command.disable,
        ['help']     = console.command.help,
    }

    if registry[command] then
        registry[command](args)
    end
    
    if registry[command] == nil then
        console.command.help()
    end

    return true

end

console.command.visible = function(args)

    config.ui.visible = not config.ui.visible 
    config.save()

end

console.command.enable = function(args)

    local tokens = common.split(string.lower(args), ' ')
    
    for k,pg in ipairs({'hp', 'mp', 'tp', 'tick'}) do
        if common.in_array(tokens, string.lower(pg)) or common.in_array(tokens, string.lower('all')) then
            config[pg].enabled = true
        end
    end

    config.save()
    
end

console.command.disable = function(args)

    local tokens = common.split(string.lower(args), ' ')
    
    for k,pg in ipairs({'hp', 'mp', 'tp', 'tick'}) do
        if common.in_array(tokens, string.lower(pg)) or common.in_array(tokens, string.lower('all')) then
            config[pg].enabled = false
        end
    end
    
    config.save()
    
end

console.command.help = function(args)

    common.help('/giko tickle', 
    {
        {'/giko timer visible', 'Toggle the ui on and off.'},
        {'/giko timer enable <bar>', 'Show the <hp/mp/tp/tick> bar.'},
        {'/giko timer disable <bar>', 'Hide the <hp/mp/tp/tick> bar.'},
    })

end

return console