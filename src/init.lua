--[[
For a more in depth explanation and rundown of this script, I recommend you check out https://github.com/ricardojrgavin-afk/BrainrotPolice
]]

local env = getgenv()

if not isfolder("BrainrotPolice") then makefolder("BrainrotPolice") end

function env.import(id)
    return game:GetObjects(id)[1]
end

function env.getgitpath(where)
    -- Cleaned up by removing /refs/heads/ and leaving it right at main/
    local mainBuild = "https://raw.githubusercontent.com/ricardojrgavin-afk/BrainrotPolice/main/"
    if where == "src" then
        return mainBuild .. "src/"
    elseif where == "games" then
        return mainBuild .. "src/games/"
    end
end

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    if env.autorjjjj then
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
end)

loadstring(game:HttpGet(getgitpath("src").."ui.lua"))()
