---@class BattleManager : GameObjectCls
local BattleManager = GameObject();

function BattleManager:init(player1, player2)
    ---@type Beverage
    self.p1 = Engine.Scene:create_game_object("Beverage", "player_1") {
        username = player1,
        playable = false
    };
    ---@type Beverage
    self.p2 = Engine.Scene:create_game_object("Beverage", "player_2") {
        username = player2,
        playable = false
    };
    -- self.p2 = Engine.Scene:get_g
    print("p1", self.p1.sprites.body:get_position());
    print("p2", self.p2.sprites.body:get_position());
    self.p1:set_position(obe.transform.UnitVector(0.6, 0.3));
    print("p1", self.p1.sprites.body:get_position());
    print("p2", self.p2.sprites.body:get_position());
    self.p2:set_position(obe.transform.UnitVector(0.8, 0.4));
    print("p1", self.p1.sprites.body:get_position());
    print("p2", self.p2.sprites.body:get_position());
    self.p1:set_size(0.4);
    self.p2:set_size(0.4);
    Task.Battle();
end

local SPIN_SPEED = 100;

function Task.Battle(ctx)
    ctx:wait_for(1);
    local spin = 0;
    ctx:wait_for(function(evt)
        spin = spin + (evt.dt * SPIN_SPEED);
        BattleManager.p1:rotate(spin);
        if spin > 360 then
            BattleManager.p1:rotate(0);
            return true;
        end
    end);
    ctx:wait_for(1);
    ctx:wait_for(function(evt)
        spin = spin + (evt.dt * SPIN_SPEED);
        BattleManager.p2:rotate(spin);
        if spin > 360 then
            BattleManager.p2:rotate(0);
            return true;
        end
    end);
    ctx:wait_for(1);

    if math.random() > 0.5 then
        BattleManager.p1:set_color(obe.graphics.Color.Green);
        BattleManager.p2:set_color(obe.graphics.Color.Red);
    else
        BattleManager.p1:set_color(obe.graphics.Color.Red);
        BattleManager.p2:set_color(obe.graphics.Color.Green);
    end
end
