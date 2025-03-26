RegisterCommand("confess", function()
    local confirm = lib.alertDialog({
        header = "Are you sure you want to confess?",
        content = ("This will deduct $%s from your bank, and the confession will be sent to Discord for everyone to see."):format(Config.ConfessionFee),
        centered = true,
        cancel = true
    })

    if confirm ~= "confirm" then
        lib.notify({title = "Confession", description = "Confession cancelled.", type = "error"})
        return
    end

    local input = lib.inputDialog("In-Game To Discord Confession", {
        {type = "select", label = "Display As", description = "Too Afraid ? Select Annonymous", options = {
            {label = "Name", value = "name"},
            {label = "Anonymous", value = "anonymous"}
        }},
        {type = "textarea", label = "Confession", description = "Pour your heart out — whether it's love, hate, or a simple confession."}
    })

    if not input or not input[1] or not input[2] then
        lib.notify({title = "Confession", description = "You must fill in all fields!", type = "error"})
        return
    end

    local displayName = input[1]
    local confession = input[2]

    TriggerServerEvent("catx_confession:sv:confesstodc", displayName, confession)

    lib.notify({title = "Confession", description = "Your confession has been sent!", type = "success", position = "center-right",})
end, false)
