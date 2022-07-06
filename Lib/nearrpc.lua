local NEAR_RPC_ENDPOINT = "http://rpc.testnet.near.org";

local NETWORK_ENDPOINTS = {
    testnet = "http://rpc.testnet.near.org",
    mainnet = "http://rpc.mainnet.near.org",
    betanet = "https://rpc.betanet.near.org"
}

local ACCOUNT_ID_NETWORK_MAPPING = {
    near = "mainnet",
    testnet = "testnet"
}

local function get_network_from_account_id(account_id)
    return ACCOUNT_ID_NETWORK_MAPPING[account_id:gmatch("%.(%a+)$")()];
end

local function view_account(account_id, network)
    local endpoint = NETWORK_ENDPOINTS[network or get_network_from_account_id(account_id) or "mainnet"];
    local result = jsonrpc(endpoint) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "query",
        params = {
            request_type = "view_account",
            finality = "final",
            account_id = account_id
        }
    }
    return result;
end

local function view_contract_state(account_id, prefix_base64, network)
    local endpoint = NETWORK_ENDPOINTS[network or get_network_from_account_id(account_id) or "mainnet"];
    local result = jsonrpc(endpoint) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "query",
        params = {
            request_type = "view_state",
            finality = "final",
            account_id = account_id,
            prefix_base64 = prefix_base64
        }
    }

    return result;
end

local function send_transaction(signed_transaction_base64, network)
    local endpoint = NETWORK_ENDPOINTS[network or "mainnet"];
    local result = jsonrpc(endpoint) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "broadcast_tx_async",
        params = { signed_transaction_base64 }
    }

    return result;
end

local function get_latest_block(network)
    local endpoint = NETWORK_ENDPOINTS[network or "mainnet"];
    local result = jsonrpc(endpoint) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "block",
        params = {
            finality = "final"
        }
    }

    return result.result.header.height
end

local function get_gas(block, network)
    block = block or get_latest_block();
    local endpoint = NETWORK_ENDPOINTS[network or "mainnet"];
    local result = jsonrpc(endpoint) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "gas_price",
        params = { block }
    }

    return result;
end

local function call_contract_function(account_id, method_name, args_base64, network)
    local endpoint = NETWORK_ENDPOINTS[network or get_network_from_account_id(account_id) or "mainnet"];
    print("ENDPOINT", endpoint, account_id, method_name, args_base64);
    local result = jsonrpc(endpoint) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "query",
        params = {
            request_type = "call_function",
            finality = "final",
            account_id = account_id,
            method_name = method_name,
            args_base64 = args_base64
        }
    };
    print("RPC done")
    return result;
end

local Contract = class();

function Contract:_init(contract_address)
    self.contract_address = contract_address;
end

---@module "Lib.json"
local json = require("lib://json");
---@module "Lib.base64"
local base64 = require("lib://base64");
function Contract:__index(method_name)
    return function(self, fnargs)
        local jsonified_args = json.encode(fnargs);
        local args_b64 = base64.encode(jsonified_args);
        local response = call_contract_function(self.contract_address, method_name, args_b64);
        if response.result ~= nil then
            if response.result.result ~= nil then
                local decoded_string = "";
                for _, charcode in pairs(response.result.result) do
                    decoded_string = decoded_string .. string.char(charcode);
                end
                local decoded_content = json.decode(decoded_string);
                return decoded_content;
            elseif response.result.error ~= nil then
                error(response.result.error);
            else
                error("unhandled case");
            end
        else
            error("missing result field");
        end
    end
end

return {
    view_account = view_account,
    view_contract_state = view_contract_state,
    send_transaction = send_transaction,
    get_latest_block = get_latest_block,
    get_gas = get_gas,
    call_contract_function = call_contract_function,
    Contract = Contract
}
