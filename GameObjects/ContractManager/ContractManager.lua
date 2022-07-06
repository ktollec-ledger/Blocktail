---@class ContractManager : GameObjectCls
local ContractManager = GameObject();

---@module "Lib.nearrpc"
local nearrpc = require("lib://nearrpc");

---@module "Lib.base58"
local base58 = require("lib://base58");

local NETWORK = "near";
local NFT_COLLECTION_ID = "testcollection-by-aubenear";

function ContractManager:init()
    print("VERSION VERSION", ledger.get_version());
    local account_id = ledger.bip32_path_to_bytes("44'/397'/0'/0'/1'", --[[prepend_length=]] false);
    print("ACCOUNT ID", account_id)
    local public_key = ledger.get_public_key(account_id);
    local b58_s = "";
    for k, v in pairs(public_key) do
        b58_s = b58_s .. string.char(v)
    end
    print("B58_s", b58_s);
    local public_key_d = base58.decode_base58(b58_s)
    print("PUBLIC KEY", public_key)
    for k, v in pairs(public_key) do
        print("  =====>", k, v);
    end
    print("PUBLIC_KEY DECODED", public_key_d);
    self.contract = nearrpc.Contract(("v2.blocktail.%s"):format(NETWORK));
    self.nfts = jsonrpc("http://api-v2-mainnet.paras.id");
end

local function hardcoded_equipment()
    return {
        body = "orange_juice",
        eyes = "drunk_wink_eyes",
        hat = "red_hat",
        shoes = "red_shoes"
    };
end

---Get equipment of given player
---@param username string#Username of player ({username}.near or {username}.testnet for example)
function ContractManager:get_player_equipment(username)
    local account_id = ("%s.%s"):format(username, NETWORK);
    local result = self.contract:get_equipments {
        account_id = "v2.blocktail.near"
    };
    return result;
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
