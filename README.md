# signals
signals is a simple signals module for Lua.

## Simple use
```
local signals = require 'signals'

local monster = {}
monster.is_alive = true

signals.connect('hero_hit_monster', function ()
    monster.is_alive = false
end)

signals.send('hero_hit_monster')
-- now, monster.is_alive = false
```
