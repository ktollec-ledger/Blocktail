---@class ContractManager : GameObjectCls
local ContractManager = GameObject();

---@module "Lib.nearrpc"
local nearrpc = require("lib://nearrpc");

local NETWORK = "testnet";
local NFT_COLLECTION_ID = "testcollection-by-aubenear";

function ContractManager:init()
    self.contract = nearrpc.Contract(("maximilientemp.%s"):format(NETWORK));
    self.nfts = jsonrpc("http://api-v2-mainnet.paras.id");
end

---Get equipment of given player
---@param username string#Username of player ({username}.near or {username}.testnet for example)
function ContractManager:get_player_equipment(username)
    local account_id = ("%s.%s"):format(username, NETWORK);
    return {
        body = "orange_juice",
        eyes = "drunk_wink_eyes",
        hat = "red_hat",
        shoes = "red_shoes"
    };
end

---Get of all shops on map
function ContractManager:get_shops()
    return self.contract:get_all_shop_pos();
end

function ContractManager:get_all_items()
    local url_parameters = (
        "/token-series?collection_id=%s&exclude_total_burn=true&lookup_likes=true&__limit=50&lookup_token=true"):format(NFT_COLLECTION_ID);
    local response = self.nfts:get(url_parameters);
    for _, nft in pairs(response.data.result) do
        local token_series_id = nft.token_series_id;
        local url_parameters = ("/token?token_series_id=%s&contract_id=x.paras.near&__limit=100&__sort=price::1"):format(token_series_id);
        local response2 = self.nfts:get(url_parameters);
    end
end
