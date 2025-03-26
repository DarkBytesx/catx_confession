local ESX = exports['es_extended']:getSharedObject()
local Config = Config or {}

RegisterNetEvent("catx_confession:sv:confesstodc")
AddEventHandler("catx_confession:sv:confesstodc", function(displayName, confession)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then return end

    local author = (displayName == "anonymous") and "Anonymous" or xPlayer.getName()
    local price = Config.ConfessionFee

    if xPlayer.getAccount("bank").money >= price then
        xPlayer.removeAccountMoney("bank", price)
        TriggerEvent("esx_addonaccount:getSharedAccount", Config.ConfessionSociety, function(account)
            if account then
                account.addMoney(price)
            end
        end)

        local embedData = {
            {
                title = "Confession By ".. author,
                description = confession,
                color = 16711680,
                footer = { text = "CATX Confession" },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }

        PerformHttpRequest(Config.ConfessionWebhook, function(statusCode, response, headers) 
            if statusCode == 204 then
                print("[Confession] Message sent successfully.") -- check status if successfully sent or forwarded
            else
                print("[Confession] Failed to send message. Status Code: " .. statusCode) -- fuck when this appears you fucked up
            end
        end, "POST", json.encode({embeds = embedData}), { ["Content-Type"] = "application/json" })

        TriggerClientEvent("ox_lib:notify", src, {
           -- title = "Confession",
            description = ("You have been charged $%s for confessing."):format(price),
            type = "info",
            position = "center-right",
        })
    else
        TriggerClientEvent("ox_lib:notify", src, {
          --  title = "Confession",
            description = "You do not have enough money in your bank to confess!",
            type = "error",
            position = "center-right",
        })
    end
end)
