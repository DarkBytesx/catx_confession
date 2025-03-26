--- cl_lua.lua

local hulingalaala = {}

local function containsFilteredWord(text)
    if not Config.EnableWordFilter then return false end
    for _, word in ipairs(Config.WordFilter) do
        if string.find(text:lower(), word:lower()) then
            return true
        end
    end
    return false
end

RegisterCommand("confess", function()
    local feeMessage = (Config.ConfessionFee > 0) and ("This will deduct $%s from your bank, and the confession will be sent to Discord for everyone to see."):format(Config.ConfessionFee) or "This confession is free of charge and will be sent to Discord for everyone to see."

    local confirm = lib.alertDialog({
        header = "Are you sure you want to confess?",
        content = feeMessage,
        centered = true,
        cancel = true
    })

    if confirm ~= "confirm" then
        lib.notify({title = "Confession", description = "Confession cancelled.", type = "error", position = "center-right"})
        return
    end

    local options = {}
    for _, id in ipairs(hulingalaala) do
        table.insert(options, {label = "Confession ID: #" .. id, value = id})
    end

    local input = lib.inputDialog("In-Game To Discord Confession", {
        {type = "select", label = "Display As", description = "Too Afraid ? Select Anonymous", options = {
            {label = "Name", value = "name"},
            {label = "Anonymous", value = "anonymous"}
        }, default = "name"},
        {type = "textarea", label = "Confession", description = "Pour your heart out — whether it's love, hate, or a simple confession.", required = true},
        {type = "select", label = "Type of Confession", description = "Select the type of your confession.", options = {
            {label = "Anger or Hate", value = "anger"},
            {label = "Love", value = "love"},
            {label = "Neutral", value = "neutral"}
        }, default = "neutral"},
        {type = "select", label = "Replying to Confession (Optional)", description = "Select a confession to reply to.", options = options, required = false}
    })

    if not input or not input[1] or not input[2] or not input[3] then
        lib.notify({title = "Confession", description = "You must fill in all fields!", type = "error", position = "center-right"})
        return
    end

    local displayName = input[1]
    local confession = input[2]
    local confessionType = input[3]
    local replyToId = input[4] and tonumber(input[4]) or nil

    if containsFilteredWord(confession) then
        lib.notify({title = "Confession", description = "Your confession contains prohibited words and has been cancelled.", type = "error", position = "center-right"})
        return
    end

    TriggerServerEvent("catx_confession:sv:ctd", displayName, confession, confessionType, replyToId)
end, false)

RegisterNetEvent("updatehulingalaala", function(id)
    table.insert(hulingalaala, 1, id)
    if #hulingalaala > 10 then
        table.remove(hulingalaala, 11)
    end
end)
