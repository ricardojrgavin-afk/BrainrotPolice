-- BrainrotPolice Master Framework Loader
-- Revamped & Optimized

local hui = gethui or get_hidden_gui or function() return game:GetService("CoreGui") end
local getexec = identifyexecutor or function() return "Unknown Executor" end

local coregui = game:GetService("CoreGui")
local userinputservice = game:GetService("UserInputService")
local httpservice = game:GetService("HttpService")
local exservice = game:GetService("ExperienceService")
local tweenservice = game:GetService("TweenService")

-- Configuration Variables
local HUB_NAME = "BrainrotPolice"
local GITHUB_REPO_PATH = "https://raw.githubusercontent.com/topsercat/BrainrotPolice/main/src/"

-- Global GitHub Path Builder Fallback
local getgitpath = _G.getgitpath or function(folder)
    if folder == "games" then
        return "https://raw.githubusercontent.com/topsercat/BrainrotPolice/main/games/"
    end
    return GITHUB_REPO_PATH
end

-- Custom Asset Loader Fallback
local import = _G.import or function(assetId)
    local success, obj = pcall(function()
        return game:GetObjects(assetId)[1]
    end)
    if success then return obj end
    
    -- Fallback mock frame structure if asset retrieval fails
    warn("[" .. HUB_NAME .. "]: Failed to fetch UI asset ID. Initiating UI structure fallback.")
    local fallback = Instance.new("ScreenGui")
    local frame = Instance.new("Frame", fallback)
    frame.Name = "Frame"
    frame.Size = UDim2.new(0, 520, 0, 340)
    frame.Position = UDim2.new(0.5, -260, 0.5, -170)
    
    local topBar = Instance.new("Frame", frame) topBar.Name = "TopBar"
    local hideBtn = Instance.new("TextButton", topBar) hideBtn.Name = "hidebtn"
    local sc = Instance.new("Frame", frame) sc.Name = "sectionContainers"
    local tl = Instance.new("Frame", frame) tl.Name = "tablist"
    
    local hf = Instance.new("Frame", sc) hf.Name = "homeframe"
    local gf = Instance.new("Frame", sc) gf.Name = "gameFrame"
    local glf = Instance.new("Frame", sc) glf.Name = "gamelistFrame"
    local sf = Instance.new("Frame", sc) sf.Name = "settingsFrame"
    local cf = Instance.new("Frame", sc) cf.Name = "creditsFrame"
    
    Instance.new("TextLabel", hf).Name = "bugsLabel"
    Instance.new("TextLabel", hf).Name = "discan"
    Instance.new("TextLabel", hf).Name = "ythead"
    Instance.new("TextLabel", hf).Name = "execLabel"
    
    local tBtn = Instance.new("TextButton", fallback) tBtn.Name = "togglebtn"
    tBtn.Visible = false
    
    return fallback
end

-- Initialize the Canvas System
local ui = import("rbxassetid://75281832304062")
ui.Parent = hui()

local ToggleButton = ui:FindFirstChild("togglebtn") or ui.Frame:FindFirstChild("togglebtn")
local MainFrame = ui.Frame

local Topbar = MainFrame.TopBar
local SectionContainers = MainFrame.sectionContainers
local TabList = MainFrame.tablist
local HideButton = Topbar.hidebtn

-- Sections Configuration Array
local Sections = {
    Home = {
        TabBtn = TabList:FindFirstChild("HomeTab") or Instance.new("TextButton"),
        Container = SectionContainers:FindFirstChild("homeframe")
    },
    Game = {
        TabBtn = TabList:FindFirstChild("GameTab") or Instance.new("TextButton"),
        Container = SectionContainers:FindFirstChild("gameFrame")
    },
    GamesList = {
        TabBtn = TabList:FindFirstChild("GameslistTab") or Instance.new("TextButton"),
        Container = SectionContainers:FindFirstChild("gamelistFrame")
    },
    Settings = {
        TabBtn = TabList:FindFirstChild("SettingsTab") or Instance.new("TextButton"),
        Container = SectionContainers:FindFirstChild("settingsFrame")
    },
    Credits = {
        TabBtn = TabList:FindFirstChild("CreditsTab") or Instance.new("TextButton"),
        Container = SectionContainers:FindFirstChild("creditsFrame")
    }
}

local CurSection = Sections.Home

-- Tab Interactivity & Animation Handler
for _, sect in pairs(Sections) do
    if sect.TabBtn and sect.Container then
        sect.TabBtn.MouseEnter:Connect(function()
            for _, stroke in pairs(sect.TabBtn:GetChildren()) do
                if stroke.Name == "InnerShadow" then
                    tweenservice:Create(stroke, TweenInfo.new(0.15), {Transparency = 0.95}):Play()
                end
            end
        end)

        sect.TabBtn.MouseLeave:Connect(function()
            for _, stroke in pairs(sect.TabBtn:GetChildren()) do
                if stroke.Name == "InnerShadow" then
                    tweenservice:Create(stroke, TweenInfo.new(0.15), {Transparency = 1}):Play()
                end
            end
        end)

        sect.TabBtn.MouseButton1Click:Connect(function()
            if CurSection == sect then return end

            if CurSection then
                CurSection.TabBtn.BackgroundTransparency = 1
                CurSection.Container:TweenPosition(UDim2.new(0.5, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            end

            sect.TabBtn.BackgroundTransparency = 0
            sect.Container:TweenPosition(UDim2.new(0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            sect.Container.Visible = true

            CurSection = sect
        end)
    end
end

-- Screen Minimization Logic
HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    if ToggleButton then ToggleButton.Visible = true end
end)

if ToggleButton then
    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        ToggleButton.Visible = false
    end)
end

-- Enhanced Smooth Canvas Dragging (Mobile + PC Optimized)
local dragging = false
local dragInput, mousePos, framePos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userinputservice.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        local targetPos = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
        tweenservice:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.OutQuad), {Position = targetPos}):Play()
    end
end)

-- Formatting Home Labels Cleanly
local home = Sections.Home.Container
if home then
    if home:FindFirstChild("bugsLabel") then home.bugsLabel.Text = home.bugsLabel.Text:gsub("redacted", "discord.gg/vaehz") end
    if home:FindFirstChild("discan") then home.discan.Text = home.discan.Text:gsub("redacted", "discord.gg/vaehz") end
    if home:FindFirstChild("ythead") then home.ythead.Text = home.ythead.Text:gsub("redacted", "YouTube") end
    if home:FindFirstChild("execLabel") then home.execLabel.Text = "Executor: " .. getexec() end
end

-- Dynamic Content Loading Pipeline
local ok, gamePath = pcall(function()
    return game:HttpGet(getgitpath("games") .. tostring(game.PlaceId) .. ".lua")
end)

local gameList = {}
pcall(function() gameList = httpservice:JSONDecode(game:HttpGet(getgitpath("src") .. "gameslist.json")) end)

local creditsList = {}
pcall(function() creditsList = httpservice:JSONDecode(game:HttpGet(getgitpath("src") .. "credits.json")) end)

local elements = {}
pcall(function() elements = loadstring(game:HttpGet(getgitpath("src") .. "elements.lua"))() end)

-- Handle Unrecognized/Universal Games Execution
if not ok or #gamePath == 0 or gamePath == "404: Not Found" then
    local handledLocally = false

    if getgenv().FileScripts then
        local internalPath = HUB_NAME .. "/" .. tostring(game.PlaceId) .. ".lua"
        if isfile and isfile(internalPath) then
            local gameModule = loadstring(readfile(internalPath))()
            if type(gameModule) == "function" then
                gameModule(Sections.Game.Container)
                handledLocally = true
            end
        end
    end

    if not handledLocally and elements and elements.Unsupported then
        elements:Unsupported(Sections.Game.Container, function()
            if CurSection then
                CurSection.TabBtn.BackgroundTransparency = 1
                CurSection.Container:TweenPosition(UDim2.new(0.5, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            end

            Sections.GamesList.TabBtn.BackgroundTransparency = 0
            Sections.GamesList.Container:TweenPosition(UDim2.new(0.5, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            Sections.GamesList.Container.Visible = true

            CurSection = Sections.GamesList
        end)
    end
else
    -- Run Recognized Database Feature Script
    local gameModule = loadstring(gamePath)()
    if type(gameModule) == "function" then
        gameModule(Sections.Game.Container)
    end
end

-- Map External JSON Server Records to Client Elements
if elements and elements.Button then
    for _, g in ipairs(gameList) do
        elements:Button((g.status or "") .. " " .. (g["game"] or "Unknown"), Sections.GamesList.Container, function()
            if g.id then exservice:LaunchExperience({placeId = g.id}) end
        end)
    end
end

if elements and elements.CredHead and elements.CredPerson then
    for sect, c in pairs(creditsList) do
        elements:CredHead(Sections.Credits.Container, sect)
        for _, person in ipairs(c) do
            elements:CredPerson(Sections.Credits.Container, person)
        end
    end
end

-- Settings Control Initializations
if elements and elements.Toggle then
    elements:Toggle("Disable 3D Rendering", Sections.Settings.Container, function(v)
        game:GetService("RunService"):Set3dRenderingEnabled(not v)
    end)

    elements:Toggle("Auto Rejoin (when kicked)", Sections.Settings.Container, function(v)
        getgenv().autorjjjj = v
    end)
end
