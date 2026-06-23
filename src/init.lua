-if not game:IsLoaded() then
    game.Loaded:Wait()
end
local env = getgenv()

-- 1. Setup Local Storage
if not isfolder("BrainrotPolice") then makefolder("BrainrotPolice") end
if not isfile("BrainrotPolice/Config.json") then
    writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode({
        settings = {
            auto_rejoin_on_kick = false,
            disable_3d_rendering = false
        }
    }))
end

-- 2. Define Helper Functions
function env.getgitpath(where)
    local mainBuild = "https://raw.githubusercontent.com/ricardojrgavin-afk/BrainrotPolice/main/"
    if where == "src" then
        return mainBuild .. "src/"
    end
end

-- 3. Trigger the Initialization
-- This reaches out to your GitHub to start your init.lua
local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ricardojrgavin-afk/BrainrotPolice/main/src/init.lua"))()
end)

if not success then
    warn("Failed to load: " .. tostring(err))
end

-- 4. Ensure Persistence
if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/ricardojrgavin-afk/BrainrotPolice/main/src/init.lua"))()')
end

-- Load UI
loadstring(game:HttpGet(env.getgitpath("src").."ui.lua"))()
