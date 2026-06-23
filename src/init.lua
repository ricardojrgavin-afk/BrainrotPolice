-- File: src/init.lua
local env = getgenv()
local HttpService = game:GetService("HttpService")

-- Load Credits
local success, creditsData = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(env.getgitpath("src").."credits.json"))
end)

if success then
    env.Credits = creditsData
    print("Loaded project by: " .. env.Credits.Developer)
end

-- Load UI
loadstring(game:HttpGet(env.getgitpath("src").."ui.lua"))()
