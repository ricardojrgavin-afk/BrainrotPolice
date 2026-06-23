-- Modern, High-Quality UI Library Template (Fixed Loading)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Ensure the local player exists and is loaded before building UI
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

local UI = {}

function UI:CreateWindow(hubName)
    -- Protect against simple UI detection algorithms
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Vortex_" .. tostring(math.random(100000, 999999))
    ScreenGui.ResetOnSpawn = false
    
    -- Robust Parent allocation logic
    local success, _ = pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    
    if not success or not ScreenGui.Parent then
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
        if playerGui then
            ScreenGui.Parent = playerGui
        else
            warn("Vortex Hub Error: Could not locate a valid UI container parent.")
            return nil
        end
    end

    -- Main Container Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 5, 0, 5) -- Small initial size for the pop animation
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Styling: Rounded Corners
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Styling: Premium Border Outline
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.5
    MainStroke.Color = Color3.fromRGB(45, 45, 55)
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    -- Top Header Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = hubName or "VORTEX HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TopBar

    -- Gradient Accent for Title
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)), -- Vibrant Purple
        ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 197, 94))   -- Sleek Emerald
    }
    TitleGradient.Parent = Title

    -- Content Container
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -65)
    ContentFrame.Position = UDim2.new(0, 10, 0, 55)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
    ContentFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ContentFrame

    -- Trigger the intro tween safely
    task.spawn(function()
        MainFrame:TweenSize(
            UDim2.new(0, 480, 0, 320), 
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.5,
            true
        )
    end)

    -- Draggable Feature
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Elements = {}

    -- Button Creator
    function Elements:CreateButton(text, callback)
        local callback = callback or function() end
        
        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Name = text .. "Button"
        ButtonFrame.Size = UDim2.new(1, -5, 0, 38)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        ButtonFrame.Text = ""
        ButtonFrame.AutoButtonColor = false
        ButtonFrame.Parent = ContentFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = ButtonFrame

        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Thickness = 1
        ButtonStroke.Color = Color3.fromRGB(45, 45, 55)
        ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ButtonStroke.Parent = ButtonFrame

        local ButtonText = Instance.new("TextLabel")
        ButtonText.Size = UDim2.new(1, 0, 1, 0)
        ButtonText.BackgroundTransparency = 1
        ButtonText.Text = text
        ButtonText.Font = Enum.Font.GothamSemibold
        ButtonText.TextColor3 = Color3.fromRGB(220, 220, 230)
        ButtonText.TextSize = 14
        ButtonText.Parent = ButtonFrame

        ButtonFrame.MouseEnter:Connect(function()
            TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(168, 85, 247)}):Play()
        end)

        ButtonFrame.MouseLeave:Connect(function()
            TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 40)}):Play()
            TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 55)}):Play()
        end)

        ButtonFrame.MouseButton1Click:Connect(function()
            ButtonFrame.Size = UDim2.new(1, -10, 0, 36)
            task.wait(0.05)
            ButtonFrame.Size = UDim2.new(1, -5, 0, 38)
            pcall(callback)
        end)
    end

    return Elements
end

-- Initialize the window and add your buttons
local Window = UI:CreateWindow("VORTEX HUB")

if Window then
    Window:CreateButton("Auto Farm", function()
        print("Farming started.")
    end)

    Window:CreateButton("Teleport", function()
        print("Teleporting.")
    end)
end    MainCorner.Parent = MainFrame

    -- Styling: Premium Border Outline
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1.5
    MainStroke.Color = Color3.fromRGB(45, 45, 55)
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    -- Top Header Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    TopBar.Parent = MainFrame

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = hubName or "VORTEX HUB"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = TopBar

    -- Gradient Accent for Title
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(168, 85, 247)), -- Vibrant Purple
        ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 197, 94))   -- Sleek Emerald/Green
    }
    TitleGradient.Parent = Title

    -- Content Container (Where buttons/toggles go)
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -20, 1, -65)
    ContentFrame.Position = UDim2.new(0, 10, 0, 55)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
    ContentFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ContentFrame

    -- Smooth Opening Animation (Tween)
    MainFrame:TweenSize(
        UDim2.new(0, 480, 0, 320), -- Final sleek, mobile-friendly scale layout
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quart,
        0.5,
        true
    )

    -- Making the UI Draggable (Desktop friendly)
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Internal components function creator
    local Elements = {}

    -- HIGH QUALITY BUTTON COMPONENT
    function Elements:CreateButton(text, callback)
        local callback = callback or function() end
        
        local ButtonFrame = Instance.new("TextButton")
        ButtonFrame.Name = text .. "Button"
        ButtonFrame.Size = UDim2.new(1, -5, 0, 38)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        ButtonFrame.Text = ""
        ButtonFrame.AutoButtonColor = false
        ButtonFrame.Parent = ContentFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = ButtonFrame

        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Thickness = 1
        ButtonStroke.Color = Color3.fromRGB(45, 45, 55)
        ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ButtonStroke.Parent = ButtonFrame

        local ButtonText = Instance.new("TextLabel")
        ButtonText.Size = UDim2.new(1, 0, 1, 0)
        ButtonText.BackgroundTransparency = 1
        ButtonText.Text = text
        ButtonText.Font = Enum.Font.GothamSemibold
        ButtonText.TextColor3 = Color3.fromRGB(220, 220, 230)
        ButtonText.TextSize = 14
        ButtonText.Parent = ButtonFrame

        -- Micro-Interactions: Hover & Click Effects
        ButtonFrame.MouseEnter:Connect(function()
            TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
            TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(168, 85, 247)}):Play() -- Accent glow
        end)

        ButtonFrame.MouseLeave:Connect(function()
            TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 40)}):Play()
            TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 55)}):Play()
        end)

        ButtonFrame.MouseButton1Click:Connect(function()
            -- Quick visual bounce/click feedback
            ButtonFrame.Size = UDim2.new(1, -10, 0, 36)
            task.wait(0.05)
            ButtonFrame.Size = UDim2.new(1, -5, 0, 38)
            
            pcall(callback)
        end)
    end

    return Elements
end

return UI
