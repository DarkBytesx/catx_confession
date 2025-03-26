# CATX Confession Script

Features

/confess Command: Players can send confessions in-game.

Confirmation Prompt: Warns players of a bank fee before confessing.

Input Dialog: Choose to display as real name or anonymously, with a text area for the confession.

Confession Fee: Deducts a configurable amount (default: $1000) from the player's bank.

Discord Integration: Sends confessions to a specified Discord webhook.

Society Account: Confession fees go to a specified society account (default: society_admin).

Bank Check: Ensures players have enough money before processing.

Notifications: Success and failure alerts via ox_lib.

Server Logs: Logs success or failure of confession sending.

Configurable: Fee, webhook, and society account set in config.lua.

Dependencies

ESX Framework

ox_lib for notifications and input.

Summary

A fun in-game-to-Discord confession system with bank fees, anonymity options, and Discord integration.
