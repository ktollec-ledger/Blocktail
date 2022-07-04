---@class Beverage : GameObjectCls
local Beverage = GameObject();

function Beverage:init()
    self.sprites = {
        body = Engine.Scene:create_sprite(("{}_body"):format(self.id)),
        glasses = Engine.Scene:create_sprite(("{}_glasses"):format(self.id)),
        shoes = Engine.Scene:create_sprite(("{}_shoes"):format(self.id))
    };
end
