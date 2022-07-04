---@class Beverage : GameObjectCls
local Beverage = GameObject();

function Beverage:_initialize_sprites(sprites)
    for _, sprite in pairs(self.sprites) do
        sprite:set_size(obe.transform.UnitVector(1, 1));
    end
    self.sprites.body:set_sublayer(1);
    self.sprites.hat:set_sublayer(0);
    self.sprites.eyes:set_sublayer(0);
    self.sprites.shoes:set_sublayer(0);
end

function Beverage:init()
    self.sprites = {
        body = Engine.Scene:create_sprite(("{}_body"):format(self.id)),
        hat = Engine.Scene:create_sprite(("{}_hat"):format(self.id)),
        eyes = Engine.Scene:create_sprite(("{}_eyes"):format(self.id)),
        shoes = Engine.Scene:create_sprite(("{}_shoes"):format(self.id))
    };
    self:make_equipment {
        body = "orange_juice",
        eyes = "normal_eyes",
        hat = "red_hat",
        shoes = "red_shoes"
    };
end

function Beverage:make_equipment(equipment)
    if equipment.body == nil then
        error("equipment.body is mandatory");
    end
    self.sprites.body:load_texture(("sprites://Bodies/%s.png"):format(equipment.body));
    if equipment.hat ~= nil then
        self.sprites.hat:load_texture(("sprites://Hats/%s.png"):format(equipment.hat));
    end
    if equipment.eyes ~= nil then
        self.sprites.eyes:load_texture(("sprites://Eyes/%s.png"):format(equipment.eyes));
    end
    if equipment.shoes ~= nil then
        self.sprites.shoes:load_texture(("sprites://Shoes/%s.png"):format(equipment.shoes));
    end
    self:_initialize_sprites();
end
