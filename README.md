# signals

signals is a simple signals module for Lua.

## Simple use
```
local signals = require "signals"

local monster = {is_alive=true}

signals.connect("player_hit_monster", function()
    monster.is_alive = false
end)

signals.send("player_hit_monster")
print(monster.is_alive) -- false
```

## Use of groups

Sometimes, you'll probably want to disconnect a lot of signals at once:
```
local score = 0

signals.connect("player_hit_monster", function()
    score = score + 10
end, "group1")
signals.connect("player_hit_monster", function()
    score = score + 42
end, "group1")

signals.disconnectGroup("group1")
signals.send("player_hit_monster")
print(score) -- 0
```
