# signals
signals is a simple signals module for Lua.

## Simple use
```
local signals = require 'signals'

local monster = {}
monster.is_alive = true

local function my_callback(sender)
    sender.is_alive = false
end

signals.connect('hero_hit_monster', my_callback)
signals.send('hero_hit_monster', monster)
```
