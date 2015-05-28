describe("signals test", function()

    setup(function()
        signals = require '..signals'
    end)

    it("can create simple signal", function()
        local monster = {}
        monster.is_alive = true

        local function my_callback(sender)
            sender.is_alive = false
        end

        signals.connect('hero_hit_monster', my_callback)
        signals.send('hero_hit_monster', monster)

        assert.are.equal(monster.is_alive, false)
    end)

    it("can disconnect signal", function()
        local monster = {is_alive=true}

        local function my_callback(sender)
            sender.is_alive = false
        end

        signals.connect('kill_monster', my_callback)
        signals.disconnect('kill_monster')
        signals.send('kill_monster', monster)

        assert.are.equal(monster.is_alive, true)
    end)

    it("empty signal does nothing", function()
        signals.send('non_existent_signal')
    end)

    it("test with multiple instances", function()
        local monster = {is_alive=true}
        local monster2 = {is_alive=true}

        local function kill_monster(sender)
            sender.is_alive = false
        end

        signals.connect('kill_monster', kill_monster)
        signals.send('kill_monster', monster)
        signals.send('kill_monster', monster2)

        assert.are.equal(monster.is_alive, false)
        assert.are.equal(monster2.is_alive, false)
    end)
end)
