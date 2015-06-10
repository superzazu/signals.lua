describe("signals test", function ()

    setup(function ()
        signals = require '..signals'
        class = require 'spec.middleclass'
    end)

    it("can create simple signal", function ()
        local Monster = class('Monster')
        function Monster:initialize()
            self.is_alive = true
            signals.connect('hero_hit_monster', function ()
                self.is_alive = false
            end)
        end

        local m = Monster:new()
        assert.are.equal(m.is_alive, true)
        signals.send('hero_hit_monster')
        assert.are.equal(m.is_alive, false)
    end)

    it("test with two different instances", function ()
        local Monster = class('Monster')
        function Monster:initialize()
            self.is_alive = true
            self.can_die = true
            signals.connect('hero_hit_monster', function ()
                if self.can_die then
                    self.is_alive = false
                end
            end)
        end

        local m = Monster:new()
        local m2 = Monster:new()
        m2.can_die = false

        assert.are.equal(m.is_alive, true)
        assert.are.equal(m2.is_alive, true)
        signals.send('hero_hit_monster')
        assert.are.equal(m.is_alive, false)
        assert.are.equal(m2.is_alive, true)
    end)

    it("'real life' test", function ()
        -- when player is hit, we want to trigger two callbacks :
        --     kill the player + change the game state

        local Player = class('Player')
        function Player:initialize()
            self.is_alive = true
            signals.connect('player_died', function ()
                self.is_alive = false
            end)
        end
        function Player:is_hit()
            signals.send('player_died')
        end

        local Game = class('Game')
        function Game:initialize()
            self.state = 'game'
            signals.connect('player_died', function ()
                self.state = 'game_over'
            end)
        end

        local g = Game:new()
        local p = Player:new()
        assert.are.equal(g.state, 'game')
        assert.are.equal(p.is_alive, true)

        p.is_hit()

        assert.are.equal(g.state, 'game_over')
        assert.are.equal(p.is_alive, false)

    end)

    it("can pass parameters to send", function ()
        local log_kills = ''

        local Monster = class('Monster')
        function Monster:initialize()
            self.name = 'monster1'
        end
        function Monster:is_hit()
            signals.send('monster_killed', self)
        end

        local Game = class('Game')
        function Game:initialize()
            signals.connect('monster_killed', function (sender)
                log_kills = log_kills .. sender.name .. ' has been killed!'
            end)
        end

        local g = Game:new()
        local m = Monster:new()
        m:is_hit()

        assert.are.equal(log_kills, 'monster1 has been killed!')
    end)

    it("can disconnect signal", function ()
        local monster = {is_alive=true}
        local signal_id = signals.connect('kill_monster', function ()
            monster.is_alive = false
        end)

        signals.disconnect('kill_monster', signal_id)
        signals.send('kill_monster', monster)

        assert.are.equal(monster.is_alive, true)
    end)

    it("sending/disconnecting non-existent signal does nothing", function ()
        signals.send('non_existent_signal')
        signals.disconnect('non_existent_signal', 2)
    end)
end)
