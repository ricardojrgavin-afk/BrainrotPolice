-- become a brainrot

return function(section, data)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    local env = getgenv()
    local plr = game:GetService("Players").LocalPlayer

    local runTrigger = workspace.RunTrigger

    env.Farming = false

    local setdata = data[tostring(game.PlaceId)] or {}
    setdata.farming = setdata.farming or false
    data[tostring(game.PlaceId)] = setdata
    writefile("BrainrotPolice/Config.json", game:GetService("HttpService"):JSONEncode(data))

    elements:Toggle("Autofarm", section, env.Farming, function(v)
        env.Farming = v
        getgenv().setconfig("farming", v)
        if not v then return end

        while env.Farming do
            pcall(function()
                firetouchinterest(plr.Character.Head, runTrigger, true)
                task.wait()
                firetouchinterest(plr.Character.Head, runTrigger, false)
                task.wait(0.5)
                plr.Character:MoveTo(Vector3.new(46, 4, -1816))
                local firstbr
                repeat
                    firstbr = workspace.Locations.End.Brainrots:FindFirstChildOfClass("Model")
                    task.wait()
                until firstbr

                plr.Character:MoveTo(firstbr.PrimaryPart.Position)
                task.wait()
                repeat
                    fireproximityprompt(firstbr.PrimaryPart.ProximityPrompt)
                    task.wait()
                until not firstbr or firstbr.Parent ~= workspace.Locations.End.Brainrots
                task.wait()
                plr.Character:MoveTo(workspace.EscapeHitbox.Position)
            end)
            task.wait(1)
        end
    end)

end
