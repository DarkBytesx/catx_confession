local ESX = exports['es_extended']:getSharedObject()
local Config = Config or {}

local function generateRandomId()
    return math.random(100000, 999999)
end

local function getColorByType(type)
    if type == "anger" then
        return 16711680
    elseif type == "love" then
        return 255
    else
        return 65280
    end
end

local function logConfession(xPlayer, confessionId, price, replyToId)
    -- Discord logging
    local logWebhook = "" -- Logging Who Fucking Use it 
    local logEmbed = {
        {
            title = "Confession Log",
            fields = {
                {name = "Who", value = xPlayer.getName(), inline = true},
                {name = "Society", value = Config.ConfessionSociety, inline = true},
                {name = "Amount", value = "$" .. price, inline = true},
                {name = "Reply To", value = replyToId and ("#" .. replyToId) or "No", inline = true},
                {name = "Confession ID", value = tostring(confessionId), inline = true},
                {name = "Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true}
            },
            color = 3447003
        }
    }

    PerformHttpRequest(logWebhook, function(statusCode, response, headers)
        if statusCode == 204 then
            print("[Confession Log] Log sent to Discord successfully.")
        else
            print("[Confession Log] Failed to send log to Discord. Status Code: " .. statusCode)
        end
    end, "POST", json.encode({embeds = logEmbed}), { ["Content-Type"] = "application/json" })
end

RegisterNetEvent("catx_confession:sv:ctd")
AddEventHandler("catx_confession:sv:ctd", function(displayName, confession, confessionType, replyToId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then return end

    local author = (displayName == "anonymous") and "Anonymous" or xPlayer.getName()
    local price = Config.ConfessionFee

    if price == 0 or xPlayer.getAccount("bank").money >= price then
        if price > 0 then
            xPlayer.removeAccountMoney("bank", price)
            TriggerEvent("esx_addonaccount:getSharedAccount", Config.ConfessionSociety, function(account)
                if account then
                    account.addMoney(price)
                end
            end)
        end

        local confessionId = generateRandomId()
        local embedTitle = (replyToId and replyToId > 0) and (author .. " - Reply to #" .. replyToId) or (author .. " - Confession #" .. confessionId)

        local embedData = {
            {
                title = embedTitle,
                description = confession,
                color = getColorByType(confessionType),
                footer = { text = "CATX Confession - ID: " .. confessionId },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }

        PerformHttpRequest(Config.ConfessionWebhook, function(statusCode, response, headers)
            if statusCode == 204 then
                print("[Confession] Message sent successfully.") -- nicesu
            else
                print("[Confession] Failed to send message. Status Code: " .. statusCode) -- you fucked
            end
        end, "POST", json.encode({embeds = embedData}), { ["Content-Type"] = "application/json" })

        logConfession(xPlayer, confessionId, price, replyToId)

        local notifyMessage = (price > 0) and ("You have been charged $%s for confessing. Confession ID: %s"):format(price, confessionId) or ("Your confession has been sent for free. Confession ID: %s"):format(confessionId)

        TriggerClientEvent("ox_lib:notify", src, {
            title = "Confession",
            description = notifyMessage,
            type = "info", 
            position = "center-right"
        })

        TriggerClientEvent("updatehulingalaala", -1, confessionId)
    else
        TriggerClientEvent("ox_lib:notify", src, {
            title = "Confession",
            description = "You do not have enough money in your bank to confess!",
            type = "error", 
            position = "center-right"
        })
    end
end)
