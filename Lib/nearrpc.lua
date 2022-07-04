---@module nearrpc
local NEAR_RPC_ENDPOINT = "http://rpc.testnet.near.org";

local function view_account(account_id)
    local result = jsonrpc(NEAR_RPC_ENDPOINT) {
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

local function view_contract_state(account_id, prefix_base64)
    local result = jsonrpc(NEAR_RPC_ENDPOINT) {
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

local function send_transaction(signed_transaction_base64)
    local result = jsonrpc(NEAR_RPC_ENDPOINT) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "broadcast_tx_async",
        params = { signed_transaction_base64 }
    }

    return result;
end

local function get_latest_block()
    local result = jsonrpc(NEAR_RPC_ENDPOINT) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "block",
        params = {
            finality = "final"
        }
    }

    return result.result.header.height
end

local function get_gas(block)
    block = block or get_latest_block()
    local result = jsonrpc(NEAR_RPC_ENDPOINT) {
        jsonrpc = "2.0",
        id = "dontcare",
        method = "gas_price",
        params = { block }
    }

    return result;
end

local function call_contract_function(account_id, method_name, args_base64)
    local result = jsonrpc(NEAR_RPC_ENDPOINT) {
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
    return result;
end

local Contract = class();

function Contract:_init(contract_address)
    self.contract_address = contract_address;
end

---@module json
local json = require("lib://json");
function Contract:__index(method_name)
    return function(...)
        local response = call_contract_function(self.contract_address, method_name, "e30K");
        if response.result ~= nil then
            if response.result.result ~= nil then
                local decoded_string = "";
                for _, charcode in pairs(response.result.result) do
                    print("Charcode", charcode);
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
