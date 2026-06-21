-- BrainrotPolice Elements Module
-- Upgraded with Smooth Animations & Framework Safety

local tweenservice = game:GetService("TweenService")
local elements = import("rbxassetid://113037265185555")
local stuff = {}

-- Smooth configuration definition for UI tweens
local TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

function stuff:Label(str, king)
    if not elements or not elements:FindFirstChild("LabelElement") then return end
    local newLabel = elements.LabelElement:Clone()
    newLabel.Text = str
    newLabel.Parent = king
    return newLabel
end

function stuff:Button(str, king, cb)
    if not elements or not elements:FindFirstChild("ButtonElement") then return end
    local newBtn = elements.ButtonElement:Clone()
    
    local textLabel = newBtn:FindFirstChild("TextLabel") or newBtn
    textLabel.Text = str
    newBtn.Parent = king

    newBtn.MouseButton1Click:Connect(cb)
    return newBtn
end

function stuff:Toggle(str, king, cb)
    if not elements or not elements:FindFirstChild("ToggleElement") then return end
    local newTog = elements.ToggleElement:Clone()
    
    local textLabel = newTog:FindFirstChild("TextLabel") or newTog
    textLabel.Text = str
    newTog.Parent = king

    local isTog = false
    local toggleBg = newTog:FindFirstChild("togglebg")
    local indicator = toggleBg and toggleBg:FindFirstChild("leftrightlol")

    newTog.MouseButton1Click:Connect(function()
        isTog = not isTog
        
        if toggleBg and indicator then
            if isTog then
                -- Smooth transition to Active State (Green)
                tweenservice:Create(toggleBg, TWEEN_INFO, {BackgroundColor3 = Color3.fromRGB(59, 164, 57)}):Play()
                tweenservice:Create(indicator, TWEEN_INFO, {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -2, 0.5, 0) -- Slight padding offset looks cleaner
                }):Play()
            else
                -- Smooth transition to Inactive State (Red)
                tweenservice:Create(toggleBg, TWEEN_INFO, {BackgroundColor3 = Color3.fromRGB(164, 58, 58)}):Play()
                tweenservice:Create(indicator, TWEEN_INFO, {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 2, 0.5, 0)
                }):Play()
            end
        end
        
        cb(isTog)
    end)
    return newTog
end

function stuff:Textbox(str, king, cb)
    if not elements or not elements:FindFirstChild("TextboxElement") then return end
    local newTb = elements.TextboxElement:Clone()
    
    local textLabel = newTb:FindFirstChild("TextLabel") or newTb
    textLabel.Text = str
    newTb.Parent = king

    local tbbg = newTb:FindFirstChild("tbbg")
    local inputField = tbbg and tbbg:FindFirstChild("Inp")

    if inputField then
        inputField.FocusLost:Connect(function(enterPressed)
            cb(inputField.Text, enterPressed)
        end)
    end
    return newTb
end

function stuff:Unsupported(king, cb)
    if not elements or not elements:FindFirstChild("unsupportElement") then return end
    local newUs = elements.unsupportElement:Clone()
    newUs.Parent = king

    local suggestBtn = newUs:FindFirstChild("suggestbtn")
    local gameListBtn = newUs:FindFirstChild("glbtn")

    if suggestBtn then
        suggestBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("https://discord.gg/vaehz")
                suggestBtn.Text = "Copied Link!"
                task.wait(1.5)
                suggestBtn.Text = "Suggest Game"
            else
                suggestBtn.Text = "discord.gg/vaehz"
            end
        end)
    end

    if gameListBtn then
        gameListBtn.MouseButton1Click:Connect(cb)
    end
    return newUs
end

function stuff:CredHead(king, txt)
    if not elements or not elements:FindFirstChild("CreditHeader") then return end
    local newHead = elements.CreditHeader:Clone()
    newHead.Text = "> " .. tostring(txt):upper() -- Enforcing upper-case headers for branding
    newHead.Parent = king
    return newHead
end

function stuff:CredPerson(king, txt)
    if not elements or not elements:FindFirstChild("CreditPerson") then return end
    local newCred = elements.CreditPerson:Clone()
    newCred.Text = "      + " .. tostring(txt)
    newCred.Parent = king
    return newCred
end

return stuff
