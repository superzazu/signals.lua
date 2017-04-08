local signals = require "..signals"

describe("signals test", function()
    before_each(function()
        signals.reset()
    end)

    it("can send a simple signal", function()
        local monster = {is_alive=true}

        signals.connect("hero_hit_monster", function()
            monster.is_alive = false
        end)

        signals.send("hero_hit_monster")
        assert.are.equal(monster.is_alive, false)
    end)

    it("can connect multiple callbacks to the same signal", function()
        local monster = {is_alive=true}
        local score = 0

        signals.connect("hero_hit_monster", function()
            monster.is_alive = false
        end)
        signals.connect("hero_hit_monster", function()
            score = score + 10
        end)

        signals.send("hero_hit_monster")
        assert.are.equal(monster.is_alive, false)
        assert.are.equal(score, 10)
    end)

    it("can pass parameters to send", function()
        local log_kills = ""
        local monster = {name="monster1"}

        signals.connect("monster_killed", function(sender)
            log_kills = log_kills .. sender.name .. " has been killed!"
        end)

        signals.send("monster_killed", monster)
        assert.are.equal(log_kills, "monster1 has been killed!")
    end)

    it("can disconnect signal", function()
        local monster = {is_alive=true}

        local signal_id = signals.connect("monster_hit", function()
            monster.is_alive = false
        end)

        signals.disconnect(signal_id)
        signals.send("monster_hit")

        assert.are.equal(monster.is_alive, true)
    end)

    it("sending/disconnecting non-existent signal does nothing", function()
        signals.send('non_existent_signal')
        signals.disconnect(42)
    end)

    it("can group signals", function()
        local score = 0

        local id1 = signals.connect("monster_killed", function()
            score = score + 10
        end, "group1")
        local id2 = signals.connect("monster_killed", function()
            score = score + 11
        end, "group1")
        local id3 = signals.connect("monster_killed", function()
            score = score + 12
        end, "group2")

        signals.disconnectGroup("group1")

        signals.send("monster_killed")
        assert.are.equal(score, 12)
    end)

    it("can have callbacks triggered for every signal", function()
        local score = 0

        signals.connect("monster_killed", function()
            score = score + 10
        end)

        signals.connect("", function()
            -- will be called every time a signal is sent
            score = score + 10
        end)

        signals.send("monster_killed")
        assert.are.equal(score, 20)
    end)
end)
