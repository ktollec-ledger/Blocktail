---@class LoginManager : GameObjectCls
local LoginManager = GameObject();

---@module "nearrpc"
local nearrpc = require("lib://nearrpc");

local function get_character()
    local zube = nearrpc.Contract("zube.testnet");
    local result = zube:get_num();
    print("Result", result, type(result));
end

function LoginManager:init()
    get_character();
end
