---@class Beverage : GameObjectCls
local Beverage = GameObject();

local DEFAULT_SIZE = 0.04;

function Beverage:_initialize_sprites(sprites)
    for _, sprite in pairs(self.sprites) do
        self.components.SceneNode:add_child(sprite);
    end
    self.sprites.body:set_sublayer(1);
    self.sprites.hat:set_sublayer(0);
    self.sprites.eyes:set_sublayer(0);
    self.sprites.shoes:set_sublayer(0);
    self:set_size(DEFAULT_SIZE);
end

---Build a new Beverage
---@param username string#username of player
function Beverage:init(username, playable)
    self.username = username;
    self.sprites = {
        body = Engine.Scene:create_sprite(("{}_body"):format(self.id)),
        hat = Engine.Scene:create_sprite(("{}_hat"):format(self.id)),
        eyes = Engine.Scene:create_sprite(("{}_eyes"):format(self.id)),
        shoes = Engine.Scene:create_sprite(("{}_shoes"):format(self.id))
    };
    self:make_equipment();
    self:_initialize_sprites();
    if playable then
        Engine.Scene:create_game_object("BeverageController", ("%s_controller"):format(self.id)) {
            beverage = self
        }
    end
end

function Beverage:make_equipment(equipment)
    print("Rebuilding equipment");
    ---@type ContractManager
    local contract = Engine.Scene:get_game_object("contract_manager");
    local equipment = contract:get_player_equipment(self.username);
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
end

---@param angle number
function Beverage:rotate(angle)
    for _, sprite in pairs(self.sprites) do
        sprite:set_rotation(angle);
    end
end

---@param color obe.graphics.Color
function Beverage:set_color(color)
    for _, sprite in pairs(self.sprites) do
        sprite:set_color(color);
    end
end

---@param position obe.transform.UnitVector
function Beverage:set_position(position)
    self.components.SceneNode:set_position(position);
end

function Beverage:set_size(size)
    for _, sprite in pairs(self.sprites) do
        sprite:set_size(obe.transform.UnitVector(size, size));
    end
end

function Event.Actions.SwapEquipment()
    Beverage:make_equipment();
end
