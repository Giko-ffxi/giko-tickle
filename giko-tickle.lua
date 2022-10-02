package.path = (string.gsub(_addon.path, '[^\\]+\\?$', '')) .. 'giko-common\\' .. '?.lua;' .. package.path

_addon.author 	= 'giko'
_addon.name 	= 'giko-tickle'
_addon.version 	= '1.0.5'

controller = require('core.controller')

ashita.register_event('load', controller.load)
ashita.register_event('render', controller.render)
ashita.register_event('unload', controller.unload)
ashita.register_event('incoming_packet', controller.incoming)