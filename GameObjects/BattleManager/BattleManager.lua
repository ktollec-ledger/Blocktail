---@class BattleManager : GameObjectCls
local BattleManager = GameObject();

function BattleManager:init(player1, player2)
    Engine.Scene:create_game_object("Beverage", "player_1") {
        username = player1,
        playable = false
    };
    Engine.Scene:create_game_object("Beverage", "player_2") {
        username = player2,
        playable = false
    };
end
