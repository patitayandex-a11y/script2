-- // BOAT HELPER PREMIUM - ПОЛНАЯ ВЕРСИЯ (ВСЕ СОЕДИНЕНО)
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Настройки
local MenuName = "BoatHelper Premium"
local MenuWidth = 700
local HeaderHeight = 55
local TabHeight = 50
local ItemHeight = 65
local Spacing = 8
local MaxVisibleHeight = 650

if UserInputService.TouchEnabled then
    MenuWidth = 480
    MaxVisibleHeight = 480
end

-- Цветовая схема
local C = {
    BG = Color3.fromRGB(18, 18, 22),
    Header = Color3.fromRGB(28, 28, 36),
    Tab = Color3.fromRGB(22, 22, 28),
    TabActive = Color3.fromRGB(40, 40, 55),
    Item = Color3.fromRGB(30, 30, 38),
    Text = Color3.fromRGB(170, 170, 190),
    Bright = Color3.fromRGB(240, 240, 255),
    On = Color3.fromRGB(0, 200, 120),
    Off = Color3.fromRGB(50, 50, 65),
    Danger = Color3.fromRGB(200, 50, 50),
    Accent = Color3.fromRGB(80, 80, 120),
    SliderFill = Color3.fromRGB(0, 180, 110),
    ScrollBar = Color3.fromRGB(70, 70, 90),
    ArrowBG = Color3.fromRGB(55, 55, 75),
    BindBG = Color3.fromRGB(50, 50, 80),
    Warning = Color3.fromRGB(255, 150, 0),
    Info = Color3.fromRGB(0, 150, 255),
}

local ESPColors = {
    Red = Color3.fromRGB(255, 0, 0),
    Blue = Color3.fromRGB(0, 100, 255),
    Green = Color3.fromRGB(0, 255, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Purple = Color3.fromRGB(150, 0, 255),
    White = Color3.fromRGB(255, 255, 255),
    Orange = Color3.fromRGB(255, 150, 0),
    Pink = Color3.fromRGB(255, 0, 150),
    Cyan = Color3.fromRGB(0, 255, 255),
    Lime = Color3.fromRGB(150, 255, 0),
}

local ESPColorNames = {"Red", "Blue", "Green", "Yellow", "Purple", "White", "Orange", "Pink", "Cyan", "Lime"}

-- Настройки
local Settings = {
    ESP = {
        Enabled = false, 
        ShowNames = false, 
        ShowDistance = false, 
        ShowHealth = false, 
        Tracers = false, 
        Expanded = false, 
        ESPColor = "Red", 
        TracerColor = "Red",
        BoxESP = false,
        SkeletonESP = false,
        Chams = false,
        TextSize = 14,
    },
    Aimbot = {
        Enabled = false, 
        TargetBone = "Head", 
        FOV = 180, 
        Smooth = 15, 
        RCSEnabled = false, 
        RCSStrength = 0.5, 
        ShowFOV = true, 
        VisibleCheck = true, 
        TeamCheck = true, 
        TargetPriority = "Distance", 
        Expanded = false,
        SilentAim = false,
        Prediction = 0,
        AimKey = "RightMouse",
        AimMode = "Hold",
    },
    MISC = {
        Fly = {Enabled = false, Speed = 50, Expanded = false}, 
        Noclip = false, 
        SpeedHack = {Enabled = false, Multiplier = 2, Expanded = false}, 
        FullBright = false,
        AntiAFK = false,
        AutoRejoin = false,
        ServerHop = false,
        SpinBot = false,
    },
    AUTO = {AutoFarm = false, HitboxExpander = false, TriggerBot = false},
    PHON = {
        ESPKey = false, 
        AimbotKey = false, 
        FlyKey = false, 
        NoclipKey = false, 
        SpeedKey = false, 
        AutoFarmKey = false,
    },
    PLAYER = {WalkSpeed = 16, JumpPower = 50, FOV = 70, InfiniteJump = false},
    SCRIPT = {InfiniteYieldEnabled = false},
    UIPositions = {MenuPos = nil, ButtonPos = nil, FPSPos = nil},
}

local CurrentESPColor = Settings.ESP.ESPColor or "Red"
local CurrentTracerColor = Settings.ESP.TracerColor or "Red"

-- Система уведомлений
local NotificationSystem = {
    Active = {},
    Create = function(title, text, duration, color)
        local SG = Player:WaitForChild("PlayerGui"):FindFirstChild("Notifications")
        if not SG then
            SG = Instance.new("ScreenGui")
            SG.Name = "Notifications"
            SG.Parent = Player:WaitForChild("PlayerGui")
            SG.ResetOnSpawn = false
            SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        end
        
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 280, 0, 60)
        Frame.Position = UDim2.new(1, 290, 1, -70 - (#NotificationSystem.Active * 70))
        Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        Frame.BorderSizePixel = 0
        Frame.ZIndex = 999
        Frame.Parent = SG
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Frame
        
        local AccentBar = Instance.new("Frame")
        AccentBar.Size = UDim2.new(0, 3, 1, 0)
        AccentBar.BackgroundColor3 = color or C.On
        AccentBar.BorderSizePixel = 0
        AccentBar.ZIndex = 1000
        AccentBar.Parent = Frame
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -20, 0, 25)
        TitleLabel.Position = UDim2.new(0, 10, 0, 5)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = color or C.On
        TitleLabel.Font = Enum.Font.Code
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.ZIndex = 1000
        TitleLabel.Parent = Frame
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, -20, 0, 25)
        TextLabel.Position = UDim2.new(0, 10, 0, 30)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = text
        TextLabel.TextColor3 = C.Text
        TextLabel.Font = Enum.Font.Code
        TextLabel.TextSize = 11
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.ZIndex = 1000
        TextLabel.Parent = Frame
        
        Frame:TweenPosition(
            UDim2.new(1, -290, 1, -70 - (#NotificationSystem.Active * 70)),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.3
        )
        
        table.insert(NotificationSystem.Active, Frame)
        
        task.delay(duration or 3, function()
            Frame:TweenPosition(
                UDim2.new(1, 290, Frame.Position.Y.Scale, Frame.Position.Y.Offset),
                Enum.EasingDirection.In,
                Enum.EasingStyle.Quad,
                0.3
            )
            task.wait(0.3)
            Frame:Destroy()
            table.remove(NotificationSystem.Active, 1)
        end)
    end
}

-- Сохранение/загрузка
local function SaveAllSettings()
    pcall(function()
        local json = HttpService:JSONEncode(Settings)
        if writefile then writefile("BoatHelper_Settings.json", json) end
    end)
end

local function LoadAllSettings()
    pcall(function()
        if readfile then
            local data = readfile("BoatHelper_Settings.json")
            local decoded = HttpService:JSONDecode(data)
            for key, value in pairs(decoded) do
                if Settings[key] then Settings[key] = value end
            end
        end
    end)
end

LoadAllSettings()
CurrentESPColor = Settings.ESP.ESPColor or "Red"
CurrentTracerColor = Settings.ESP.TracerColor or "Red"

-- Главное меню
local Menu = {
    Gui = nil, 
    MainFrame = nil, 
    ItemsContainer = nil, 
    Items = {}, 
    Dragging = false, 
    DragOffset = Vector2.new(0,0), 
    IsOpen = true, 
    FunctionsEnabled = true, 
    CurrentTab = "ESP", 
    TabButtons = {}, 
    ScrollFrame = nil, 
    SliderConnections = {}, 
    WaitingForBind = nil, 
    AllItems = {}, 
    LastPosition = nil
}

-- Состояния вкладок
local TabStates = {
    ESP = {
        ESPEnabled = Settings.ESP.Enabled, 
        ESPExpanded = Settings.ESP.Expanded, 
        ShowNames = Settings.ESP.ShowNames, 
        ShowDistance = Settings.ESP.ShowDistance, 
        ShowHealth = Settings.ESP.ShowHealth, 
        TracersEnabled = Settings.ESP.Tracers,
        BoxESP = Settings.ESP.BoxESP,
        SkeletonESP = Settings.ESP.SkeletonESP,
        Chams = Settings.ESP.Chams,
    },
    AIMBOT = {
        AimbotEnabled = Settings.Aimbot.Enabled, 
        AimbotExpanded = Settings.Aimbot.Expanded,
        SilentAim = Settings.Aimbot.SilentAim,
        Prediction = Settings.Aimbot.Prediction,
        AimKey = Settings.Aimbot.AimKey,
        AimMode = Settings.Aimbot.AimMode,
    },
    MISC = {
        FlyEnabled = Settings.MISC.Fly.Enabled, 
        FlySpeed = Settings.MISC.Fly.Speed, 
        FlyExpanded = Settings.MISC.Fly.Expanded, 
        SpeedHackMultiplier = Settings.MISC.SpeedHack.Multiplier, 
        SpeedHackExpanded = Settings.MISC.SpeedHack.Expanded,
        AntiAFK = Settings.MISC.AntiAFK,
        AutoRejoin = Settings.MISC.AutoRejoin,
        ServerHop = Settings.MISC.ServerHop,
        SpinBot = Settings.MISC.SpinBot,
    },
    AUTO = {
        AutoFarmEnabled = Settings.AUTO.AutoFarm, 
        AutoFarmExpanded = false,
        HitboxExpander = Settings.AUTO.HitboxExpander,
        TriggerBot = Settings.AUTO.TriggerBot,
    },
    PLAYER = {
        WalkSpeed = Settings.PLAYER.WalkSpeed, 
        JumpPower = Settings.PLAYER.JumpPower, 
        FOV = Settings.PLAYER.FOV, 
        InfiniteJump = Settings.PLAYER.InfiniteJump, 
        Expanded = false,
    },
    SCRIPT = {InfiniteYieldEnabled = false},
    PHON = {
        ESPKey = Settings.PHON.ESPKey, 
        AimbotKey = Settings.PHON.AimbotKey, 
        FlyKey = Settings.PHON.FlyKey, 
        NoclipKey = Settings.PHON.NoclipKey, 
        SpeedKey = Settings.PHON.SpeedKey, 
        AutoFarmKey = Settings.PHON.AutoFarmKey,
    },
}

-- Системы
local ESP = {
    Enabled = Settings.ESP.Enabled, 
    Highlights = {}, 
    Connections = {}, 
    ShowNames = Settings.ESP.ShowNames, 
    ShowDistance = Settings.ESP.ShowDistance, 
    ShowHealth = Settings.ESP.ShowHealth, 
    NameLabels = {}, 
    DistanceLabels = {}, 
    HealthLabels = {}, 
    HealthConnections = {},
    BoxESP = Settings.ESP.BoxESP,
    SkeletonESP = Settings.ESP.SkeletonESP,
    Chams = Settings.ESP.Chams,
    BoxFrames = {},
    SkeletonLines = {},
    ChamsObjects = {},
    TextSize = Settings.ESP.TextSize or 14,
}

local Tracers = {Enabled = Settings.ESP.Tracers, Lines = {}, Connection = nil, TracerGui = nil}
local AimbotSettings = {
    Enabled = Settings.Aimbot.Enabled, 
    TargetBone = Settings.Aimbot.TargetBone, 
    FOV = Settings.Aimbot.FOV, 
    ShowFOV = Settings.Aimbot.ShowFOV, 
    FOVCircle = nil, 
    Smooth = Settings.Aimbot.Smooth, 
    RCSEnabled = Settings.Aimbot.RCSEnabled, 
    RCSStrength = Settings.Aimbot.RCSStrength, 
    TargetPriority = Settings.Aimbot.TargetPriority, 
    VisibleCheck = Settings.Aimbot.VisibleCheck, 
    TeamCheck = Settings.Aimbot.TeamCheck, 
    IgnoreDead = true, 
    Connection = nil,
    SilentAim = Settings.Aimbot.SilentAim or false,
    Prediction = Settings.Aimbot.Prediction or 0,
    AimKey = Settings.Aimbot.AimKey or "RightMouse",
    AimMode = Settings.Aimbot.AimMode or "Hold",
    AimToggleState = false,
}
local FlySystem = {Enabled = Settings.MISC.Fly.Enabled, Speed = Settings.MISC.Fly.Speed, Connection = nil}
local Noclip = {Enabled = Settings.MISC.Noclip, Connection = nil}
local SpeedHack = {Enabled = Settings.MISC.SpeedHack.Enabled, Multiplier = Settings.MISC.SpeedHack.Multiplier, OriginalSpeed = 16}
local FullBright = {Enabled = Settings.MISC.FullBright, OriginalBrightness = 2, OriginalClockTime = 14, OriginalAmbient = nil, OriginalFogEnd = 100000, OriginalGlobalShadows = true}
local AutoFarm = {Enabled = Settings.AUTO.AutoFarm, Connection = nil, CurrentStage = 1, IsTeleporting = false, IsWalking = false, WalkTimer = 0, CharacterAddedConnection = nil}
local AntiAFK = {Enabled = Settings.MISC.AntiAFK, Connection = nil, LastAction = os.clock()}
local SpinBot = {Enabled = Settings.MISC.SpinBot, Connection = nil, Angle = 0}
local HitboxExpander = {Enabled = Settings.AUTO.HitboxExpander, OriginalSizes = {}, Connection = nil}
local TriggerBot = {Enabled = Settings.AUTO.TriggerBot, Connection = nil, LastShot = 0}
local PlayerMods = {
    WalkSpeed = Settings.PLAYER.WalkSpeed, 
    JumpPower = Settings.PLAYER.JumpPower, 
    FOV = Settings.PLAYER.FOV, 
    InfiniteJump = Settings.PLAYER.InfiniteJump, 
    OriginalWalkSpeed = 16, 
    OriginalJumpPower = 50, 
    OriginalFOV = 70, 
    JumpConnection = nil
}
local FPSWindow = {Gui = nil, Frame = nil, Dragging = false, DragOffset = Vector2.new(0,0), LastPosition = nil}
local MenuButton = {Gui = nil, Button = nil, Dragging = false, DragOffset = Vector2.new(0,0), LastPosition = nil}

-- ESP функции
function ESP:Enable() 
    if self.Enabled then return end 
    self.Enabled = true 
    self:UpdateESP() 
    Settings.ESP.Enabled = true 
    SaveAllSettings() 
end

function ESP:Disable() 
    if not self.Enabled then return end 
    self.Enabled = false 
    self:ClearESP() 
    Settings.ESP.Enabled = false 
    SaveAllSettings() 
end

function ESP:UpdateESP()
    self:ClearESP() 
    if not self.Enabled then return end
    
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= Player then 
            self:AddESPToPlayer(p) 
        end 
    end
    
    local c1 = Players.PlayerAdded:Connect(function(p) 
        if self.Enabled and p ~= Player then 
            p.CharacterAdded:Connect(function() 
                task.wait(0.5) 
                if self.Enabled then
                    self:AddESPToPlayer(p) 
                end
            end) 
        end 
    end)
    local c2 = Players.PlayerRemoving:Connect(function(p) 
        self:RemoveESPFromPlayer(p) 
    end)
    table.insert(self.Connections, c1) 
    table.insert(self.Connections, c2)
    
    if self.ShowDistance then 
        local c3 = RunService.RenderStepped:Connect(function() 
            if self.Enabled then 
                self:UpdateDistances() 
            end 
        end) 
        table.insert(self.Connections, c3) 
    end
end

function ESP:ClearESP()
    for _, conn in pairs(self.HealthConnections) do
        if conn then conn:Disconnect() end
    end
    self.HealthConnections = {}
    
    for _, h in pairs(self.Highlights) do 
        if h then h:Destroy() end 
    end 
    self.Highlights = {}
    
    for _, l in pairs(self.NameLabels) do 
        if l then l:Destroy() end 
    end 
    self.NameLabels = {}
    
    for _, d in pairs(self.DistanceLabels) do 
        if d then d.Billboard:Destroy() end 
    end 
    self.DistanceLabels = {}
    
    for _, h in pairs(self.HealthLabels) do 
        if h then h.Billboard:Destroy() end 
    end 
    self.HealthLabels = {}
    
    for _, box in pairs(self.BoxFrames) do
        if box then box:Destroy() end
    end
    self.BoxFrames = {}
    
    for _, line in pairs(self.SkeletonLines) do
        if line then line:Destroy() end
    end
    self.SkeletonLines = {}
    
    for _, cham in pairs(self.ChamsObjects) do
        if cham then cham:Destroy() end
    end
    self.ChamsObjects = {}
    
    for _, c in pairs(self.Connections) do 
        c:Disconnect() 
    end 
    self.Connections = {}
end

function ESP:AddESPToPlayer(p)
    if p == Player then return end 
    local char = p.Character 
    if not char then return end
    
    self:RemoveESPFromPlayer(p)
    
    local hl = Instance.new("Highlight") 
    hl.FillColor = ESPColors[CurrentESPColor] or Color3.fromRGB(255,0,0) 
    hl.OutlineColor = Color3.fromRGB(255,255,255) 
    hl.FillTransparency = 0.5 
    hl.Parent = char 
    self.Highlights[p] = hl
    
    local head = char:FindFirstChild("Head") 
    if not head then return end
    
    if self.ShowNames then
        local bb = Instance.new("BillboardGui") 
        bb.Size = UDim2.new(0,100,0,30) 
        bb.StudsOffset = Vector3.new(0,2.5,0) 
        bb.AlwaysOnTop = true 
        bb.Parent = head
        local tl = Instance.new("TextLabel") 
        tl.Size = UDim2.new(1,0,1,0) 
        tl.BackgroundTransparency = 1 
        tl.Text = p.Name 
        tl.TextColor3 = Color3.fromRGB(255,255,255) 
        tl.Font = Enum.Font.Code 
        tl.TextSize = self.TextSize
        tl.Parent = bb
        self.NameLabels[p] = bb
    end
    
    if self.ShowDistance then
        local bb = Instance.new("BillboardGui") 
        bb.Size = UDim2.new(0,100,0,30) 
        bb.StudsOffset = Vector3.new(0,-2.5,0) 
        bb.AlwaysOnTop = true 
        bb.Parent = head
        local tl = Instance.new("TextLabel") 
        tl.Size = UDim2.new(1,0,1,0) 
        tl.BackgroundTransparency = 1 
        tl.Text = "0m" 
        tl.TextColor3 = Color3.fromRGB(255,200,0) 
        tl.Font = Enum.Font.Code 
        tl.TextSize = self.TextSize - 2
        tl.Parent = bb
        self.DistanceLabels[p] = {Billboard = bb, TextLabel = tl}
    end
    
    if self.ShowHealth then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            local bb = Instance.new("BillboardGui") 
            bb.Size = UDim2.new(0,100,0,30) 
            bb.AlwaysOnTop = true 
            bb.Parent = head
            local tl = Instance.new("TextLabel") 
            tl.Size = UDim2.new(1,0,1,0) 
            tl.BackgroundTransparency = 1 
            tl.Text = "HP: "..math.floor(hum.Health) 
            tl.TextColor3 = Color3.fromRGB(0,255,0) 
            tl.Font = Enum.Font.Code 
            tl.TextSize = self.TextSize - 2
            tl.Parent = bb
            self.HealthLabels[p] = {Billboard = bb, TextLabel = tl}
            
            local conn = hum.HealthChanged:Connect(function(h) 
                if self.HealthLabels[p] and self.HealthLabels[p].Billboard then 
                    self.HealthLabels[p].TextLabel.Text = "HP: "..math.floor(h) 
                end 
            end)
            table.insert(self.HealthConnections, conn)
        end
    end
    
    if self.BoxESP then
        self:AddBoxESP(p, char)
    end
    
    if self.SkeletonESP then
        self:AddSkeletonESP(p, char)
    end
    
    if self.Chams then
        self:AddChams(p, char)
    end
end

function ESP:AddBoxESP(p, char)
    local box = Instance.new("Frame")
    box.Name = "ESPBox_"..p.Name
    box.BackgroundColor3 = ESPColors[CurrentESPColor] or Color3.fromRGB(255,0,0)
    box.BackgroundTransparency = 0.7
    box.BorderSizePixel = 0
    box.ZIndex = 5
    box.Visible = false
    box.Parent = Player:WaitForChild("PlayerGui")
    
    self.BoxFrames[p] = {Box = box, Character = char}
end

function ESP:AddSkeletonESP(p, char)
    local connections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
    }
    
    local lines = {}
    for _, conn in pairs(connections) do
        local part1 = char:FindFirstChild(conn[1])
        local part2 = char:FindFirstChild(conn[2])
        if part1 and part2 then
            local line = Instance.new("Frame")
            line.BackgroundColor3 = ESPColors[CurrentESPColor] or Color3.fromRGB(255,0,0)
            line.BorderSizePixel = 0
            line.ZIndex = 5
            line.Visible = false
            line.Parent = Player:WaitForChild("PlayerGui")
            lines[#lines + 1] = {Line = line, Part1 = part1, Part2 = part2}
        end
    end
    self.SkeletonLines[p] = lines
end

function ESP:AddChams(p, char)
    local cham = Instance.new("Highlight")
    cham.FillColor = ESPColors[CurrentESPColor] or Color3.fromRGB(255,0,0)
    cham.OutlineColor = Color3.fromRGB(255,255,255)
    cham.FillTransparency = 0.2
    cham.Parent = char
    self.ChamsObjects[p] = cham
end

function ESP:RemoveESPFromPlayer(p)
    if self.Highlights[p] then 
        self.Highlights[p]:Destroy() 
        self.Highlights[p] = nil 
    end
    if self.NameLabels[p] then 
        self.NameLabels[p]:Destroy() 
        self.NameLabels[p] = nil 
    end
    if self.DistanceLabels[p] then 
        self.DistanceLabels[p].Billboard:Destroy() 
        self.DistanceLabels[p] = nil 
    end
    if self.HealthLabels[p] then 
        self.HealthLabels[p].Billboard:Destroy() 
        self.HealthLabels[p] = nil 
    end
    if self.BoxFrames[p] then
        self.BoxFrames[p].Box:Destroy()
        self.BoxFrames[p] = nil
    end
    if self.SkeletonLines[p] then
        for _, line in pairs(self.SkeletonLines[p]) do
            line.Line:Destroy()
        end
        self.SkeletonLines[p] = nil
    end
    if self.ChamsObjects[p] then
        self.ChamsObjects[p]:Destroy()
        self.ChamsObjects[p] = nil
    end
end

function ESP:UpdateDistances()
    local pc = Player.Character 
    local pr = pc and pc:FindFirstChild("HumanoidRootPart") 
    if not pr then return end
    
    for p, d in pairs(self.DistanceLabels) do 
        local tc = p.Character 
        local tr = tc and tc:FindFirstChild("HumanoidRootPart") 
        if tr and d and d.Billboard and d.Billboard.Parent then 
            d.TextLabel.Text = math.floor((pr.Position - tr.Position).Magnitude).."m" 
        end 
    end
end

function ESP:UpdateBoxESP()
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    for p, data in pairs(self.BoxFrames) do
        local char = data.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if root and head then
            local rootPos = cam:WorldToScreenPoint(root.Position)
            local headPos = cam:WorldToScreenPoint(head.Position + Vector3.new(0, 2, 0))
            
            if rootPos.Z > 0 and headPos.Z > 0 then
                local height = math.abs(rootPos.Y - headPos.Y) * 1.5
                local width = height * 0.6
                
                data.Box.Size = UDim2.new(0, width, 0, height)
                data.Box.Position = UDim2.new(0, headPos.X - width/2, 0, headPos.Y)
                data.Box.Visible = true
            else
                data.Box.Visible = false
            end
        end
    end
end

function ESP:UpdateSkeletonESP()
    local cam = workspace.CurrentCamera
    if not cam then return end
    
    for p, lines in pairs(self.SkeletonLines) do
        for _, data in pairs(lines) do
            local pos1 = cam:WorldToScreenPoint(data.Part1.Position)
            local pos2 = cam:WorldToScreenPoint(data.Part2.Position)
            
            if pos1.Z > 0 and pos2.Z > 0 then
                local dist = (Vector2.new(pos1.X, pos1.Y) - Vector2.new(pos2.X, pos2.Y)).Magnitude
                local angle = math.deg(math.atan2(pos2.Y - pos1.Y, pos2.X - pos1.X))
                
                data.Line.Size = UDim2.new(0, dist, 0, 2)
                data.Line.Position = UDim2.new(0, pos1.X, 0, pos1.Y)
                data.Line.Rotation = angle
                data.Line.Visible = true
            else
                data.Line.Visible = false
            end
        end
    end
end

function ESP:SetShowNames(v) 
    self.ShowNames = v 
    Settings.ESP.ShowNames = v 
    SaveAllSettings() 
    if self.Enabled then self:UpdateESP() end 
end

function ESP:SetShowDistance(v) 
    self.ShowDistance = v 
    Settings.ESP.ShowDistance = v 
    SaveAllSettings() 
    if self.Enabled then self:UpdateESP() end 
end

function ESP:SetShowHealth(v) 
    self.ShowHealth = v 
    Settings.ESP.ShowHealth = v 
    SaveAllSettings() 
    if self.Enabled then self:UpdateESP() end 
end

function ESP:SetBoxESP(v)
    self.BoxESP = v
    Settings.ESP.BoxESP = v
    SaveAllSettings()
    if self.Enabled then self:UpdateESP() end
end

function ESP:SetSkeletonESP(v)
    self.SkeletonESP = v
    Settings.ESP.SkeletonESP = v
    SaveAllSettings()
    if self.Enabled then self:UpdateESP() end
end

function ESP:SetChams(v)
    self.Chams = v
    Settings.ESP.Chams = v
    SaveAllSettings()
    if self.Enabled then self:UpdateESP() end
end

function ESP:SetTextSize(v)
    self.TextSize = v
    Settings.ESP.TextSize = v
    SaveAllSettings()
    if self.Enabled then self:UpdateESP() end
end

-- Tracers
function Tracers:Enable() 
    if self.Enabled then return end 
    self.Enabled = true 
    Settings.ESP.Tracers = true 
    SaveAllSettings() 
    
    if not self.TracerGui then
        local sg = Instance.new("ScreenGui") 
        sg.Name = "TracerContainer" 
        sg.Parent = Player:WaitForChild("PlayerGui") 
        sg.ResetOnSpawn = false 
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.TracerGui = sg
    end
    
    self.Connection = RunService.RenderStepped:Connect(function() 
        if self.Enabled then 
            self:UpdateTracers() 
            if ESP.BoxESP then ESP:UpdateBoxESP() end
            if ESP.SkeletonESP then ESP:UpdateSkeletonESP() end
        end 
    end) 
end

function Tracers:Disable() 
    if not self.Enabled then return end 
    self.Enabled = false 
    Settings.ESP.Tracers = false 
    SaveAllSettings() 
    if self.Connection then 
        self.Connection:Disconnect() 
        self.Connection = nil
    end 
    self:ClearLines() 
    if self.TracerGui then
        self.TracerGui:Destroy()
        self.TracerGui = nil
    end
end

function Tracers:ClearLines() 
    for _, l in pairs(self.Lines) do 
        if l then pcall(function() l:Destroy() end) end 
    end 
    self.Lines = {} 
end

function Tracers:UpdateTracers()
    self:ClearLines()
    
    if not self.TracerGui or not self.TracerGui.Parent then
        local sg = Instance.new("ScreenGui") 
        sg.Name = "TracerContainer" 
        sg.Parent = Player:WaitForChild("PlayerGui") 
        sg.ResetOnSpawn = false 
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.TracerGui = sg
    end
    
    local cam = workspace.CurrentCamera 
    if not cam then return end
    
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= Player then
            local char = p.Character 
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then 
                local sp = cam:WorldToScreenPoint(root.Position)
                if sp.Z > 0 then
                    local line = Instance.new("Frame") 
                    line.BackgroundColor3 = ESPColors[CurrentTracerColor] or Color3.fromRGB(255,0,0) 
                    line.BorderSizePixel = 0 
                    line.AnchorPoint = Vector2.new(0,0.5) 
                    line.Parent = self.TracerGui
                    
                    local dist = (Vector2.new(sp.X,sp.Y) - center).Magnitude 
                    local angle = math.deg(math.atan2(sp.Y-center.Y, sp.X-center.X))
                    line.Size = UDim2.new(0,dist,0,2) 
                    line.Position = UDim2.new(0,center.X,0,center.Y) 
                    line.Rotation = angle
                    self.Lines[p] = line
                end
            end
        end
    end
end

-- Aimbot функции
function GetTargetPart(char, bone)
    if bone == "Head" then return char:FindFirstChild("Head")
    elseif bone == "Neck" then return char:FindFirstChild("Neck") or char:FindFirstChild("UpperTorso")
    elseif bone == "Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
    elseif bone == "Closest" then
        local cam = workspace.CurrentCamera 
        local closest = nil 
        local cd = math.huge
        for _, part in pairs(char:GetChildren()) do 
            if part:IsA("BasePart") then 
                local sp = cam:WorldToScreenPoint(part.Position) 
                local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2) 
                local d = (Vector2.new(sp.X,sp.Y)-center).Magnitude 
                if sp.Z > 0 and d < cd then 
                    cd = d 
                    closest = part 
                end 
            end 
        end
        return closest
    end
    return char:FindFirstChild("Head")
end

function IsTargetVisible(tp)
    if not AimbotSettings.VisibleCheck then return true end
    local pc = Player.Character 
    local ph = pc and pc:FindFirstChild("Head") 
    if not ph then return true end
    
    local rp = RaycastParams.new() 
    rp.FilterDescendantsInstances = {pc} 
    rp.FilterType = Enum.RaycastFilterType.Blacklist
    local dir = (tp.Position - ph.Position).Unit 
    local dist = (tp.Position - ph.Position).Magnitude
    local result = workspace:Raycast(ph.Position, dir * dist, rp)
    if result then 
        local tm = tp:FindFirstAncestorOfClass("Model") 
        if tm and result.Instance:IsDescendantOf(tm) then 
            return true 
        end 
        return false 
    end
    return true
end

function GetValidTargets()
    local targets = {}
    for _, p in pairs(Players:GetPlayers()) do 
        if p ~= Player then
            local char = p.Character 
            if not char then continue end
            local hum = char:FindFirstChild("Humanoid") 
            if not hum then continue end
            if AimbotSettings.IgnoreDead and hum.Health <= 0 then continue end
            if AimbotSettings.TeamCheck and p.Team == Player.Team then continue end
            local tp = GetTargetPart(char, AimbotSettings.TargetBone) 
            if not tp then continue end
            if AimbotSettings.VisibleCheck and not IsTargetVisible(tp) then continue end
            table.insert(targets, {Part = tp, Humanoid = hum, Player = p, Character = char})
        end 
    end
    return targets
end

function SelectBestTarget()
    local targets = GetValidTargets() 
    if #targets == 0 then return nil end
    
    local cam = workspace.CurrentCamera 
    if not cam then return nil end
    
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local fovPx = (AimbotSettings.FOV / 90) * (cam.ViewportSize.Y / 2) * 2.5
    local best = nil 
    local bestValue = math.huge
    
    for _, t in pairs(targets) do 
        local sp = cam:WorldToScreenPoint(t.Part.Position) 
        if sp.Z > 0 then 
            local screenPos = Vector2.new(sp.X, sp.Y)
            local distFromCenter = (screenPos - center).Magnitude
            
            if distFromCenter <= fovPx then
                local value
                if AimbotSettings.TargetPriority == "Health" then
                    value = t.Humanoid.Health
                else
                    value = distFromCenter
                end
                
                if value < bestValue then
                    bestValue = value
                    best = t
                end
            end
        end 
    end 
    return best
end

function CreateFOVCircle()
    if AimbotSettings.FOVCircle then 
        AimbotSettings.FOVCircle:Destroy() 
        AimbotSettings.FOVCircle = nil
    end
    if not AimbotSettings.ShowFOV then return end
    
    local sg = Player:WaitForChild("PlayerGui"):FindFirstChild("FOVContainer")
    if not sg then 
        sg = Instance.new("ScreenGui") 
        sg.Name = "FOVContainer" 
        sg.Parent = Player:WaitForChild("PlayerGui") 
        sg.ResetOnSpawn = false 
        sg.IgnoreGuiInset = true 
    end
    
    local cam = workspace.CurrentCamera 
    if not cam then return end
    
    local fovPx = (AimbotSettings.FOV / 90) * (cam.ViewportSize.Y / 2) * 2.5
    local screenCenterX = cam.ViewportSize.X / 2
    local screenCenterY = cam.ViewportSize.Y / 2
    
    local circle = Instance.new("Frame") 
    circle.Name = "FOVCircle" 
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Size = UDim2.new(0, fovPx*2, 0, fovPx*2) 
    circle.Position = UDim2.new(0, screenCenterX, 0, screenCenterY)
    circle.BackgroundColor3 = Color3.fromRGB(255,0,0) 
    circle.BackgroundTransparency = 0.8 
    circle.BorderSizePixel = 0 
    circle.ZIndex = 999 
    circle.Parent = sg
    
    local corner = Instance.new("UICorner") 
    corner.CornerRadius = UDim.new(1,0) 
    corner.Parent = circle
    local stroke = Instance.new("UIStroke") 
    stroke.Color = Color3.fromRGB(255,0,0) 
    stroke.Thickness = 2 
    stroke.Transparency = 0.5 
    stroke.Parent = circle
    
    AimbotSettings.FOVCircle = circle
end

function UpdateAimbot()
    if not AimbotSettings.Enabled then return end
    
    -- Проверка режима активации
    if AimbotSettings.AimMode == "Hold" then
        local keyName = AimbotSettings.AimKey
        local keyCode = Enum.KeyCode[keyName]
        if keyCode and not UserInputService:IsKeyDown(keyCode) then
            return
        end
    elseif AimbotSettings.AimMode == "Toggle" then
        if not AimbotSettings.AimToggleState then
            return
        end
    end
    -- Для "Always" режима - всегда работает
    
    local target = SelectBestTarget()
    if target then 
        local cam = workspace.CurrentCamera 
        if not cam then return end
        
        local tp = target.Part.Position
        
        -- Предсказание движения
        if AimbotSettings.Prediction > 0 then
            local root = target.Character:FindFirstChild("HumanoidRootPart")
            if root and root.Velocity then
                tp = tp + root.Velocity * (AimbotSettings.Prediction / 100)
            end
        end
        
        -- Обычный аим (Silent Aim требует дополнительных скриптов)
        local lookAt = CFrame.lookAt(cam.CFrame.Position, tp) 
        cam.CFrame = cam.CFrame:Lerp(lookAt, AimbotSettings.Smooth/100) 
        
        if AimbotSettings.RCSEnabled then
            local recoil = AimbotSettings.RCSStrength * 0.1
            cam.CFrame = cam.CFrame * CFrame.Angles(math.rad(recoil), 0, 0)
        end
    end
end

function EnableAimbot() 
    if AimbotSettings.Enabled then return end 
    AimbotSettings.Enabled = true 
    Settings.Aimbot.Enabled = true 
    SaveAllSettings() 
    
    -- Инициализация Toggle состояния
    if AimbotSettings.AimMode == "Toggle" then
        AimbotSettings.AimToggleState = false
    end
    
    CreateFOVCircle() 
    AimbotSettings.Connection = RunService.RenderStepped:Connect(UpdateAimbot) 
    NotificationSystem.Create("BoatHelper", "Aimbot включен", 2) 
end

function DisableAimbot() 
    if not AimbotSettings.Enabled then return end 
    AimbotSettings.Enabled = false 
    Settings.Aimbot.Enabled = false 
    SaveAllSettings() 
    if AimbotSettings.Connection then 
        AimbotSettings.Connection:Disconnect() 
        AimbotSettings.Connection = nil
    end 
    if AimbotSettings.FOVCircle then 
        AimbotSettings.FOVCircle:Destroy() 
        AimbotSettings.FOVCircle = nil 
    end 
    NotificationSystem.Create("BoatHelper", "Aimbot выключен", 2) 
end

-- Fly System
function FlySystem:Enable()
    if self.Enabled then return end 
    self.Enabled = true 
    Settings.MISC.Fly.Enabled = true 
    SaveAllSettings()
    
    local char = Player.Character 
    local hum = char and char:FindFirstChild("Humanoid") 
    if hum then hum.PlatformStand = true end
    
    self.Connection = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end
        local char = Player.Character 
        local hum = char and char:FindFirstChild("Humanoid") 
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            hum.PlatformStand = true 
            local dir = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
            if dir.Magnitude > 0 then root.Velocity = dir.Unit * self.Speed else root.Velocity = Vector3.new(0,0,0) end
        end
    end)
    NotificationSystem.Create("BoatHelper", "Полёт включен", 2)
end

function FlySystem:Disable() 
    if not self.Enabled then return end 
    self.Enabled = false 
    Settings.MISC.Fly.Enabled = false 
    SaveAllSettings() 
    if self.Connection then self.Connection:Disconnect() self.Connection = nil end 
    local char = Player.Character 
    local hum = char and char:FindFirstChild("Humanoid") 
    if hum then hum.PlatformStand = false end 
    NotificationSystem.Create("BoatHelper", "Полёт выключен", 2) 
end

function FlySystem:SetSpeed(s) 
    self.Speed = s 
    Settings.MISC.Fly.Speed = s 
    SaveAllSettings() 
end

-- Noclip
function Noclip:Enable() 
    if self.Enabled then return end 
    self.Enabled = true 
    Settings.MISC.Noclip = true 
    SaveAllSettings() 
    self.Connection = RunService.Stepped:Connect(function() 
        if not self.Enabled then return end 
        local char = Player.Character 
        if char then 
            for _, p in pairs(char:GetDescendants()) do 
                if p:IsA("BasePart") then p.CanCollide = false end 
            end 
        end 
    end) 
    NotificationSystem.Create("BoatHelper", "Noclip включен", 2) 
end

function Noclip:Disable() 
    if not self.Enabled then return end 
    self.Enabled = false 
    Settings.MISC.Noclip = false 
    SaveAllSettings() 
    if self.Connection then self.Connection:Disconnect() self.Connection = nil end 
    local char = Player.Character 
    if char then 
        for _, p in pairs(char:GetDescendants()) do 
            if p:IsA("BasePart") then p.CanCollide = true end 
        end 
    end 
    NotificationSystem.Create("BoatHelper", "Noclip выключен", 2) 
end

-- SpeedHack
function SpeedHack:Enable() 
    if self.Enabled then return end 
    self.Enabled = true 
    Settings.MISC.SpeedHack.Enabled = true 
    SaveAllSettings() 
    local hum = Player.Character and Player.Character:FindFirstChild("Humanoid") 
    if hum then 
        self.OriginalSpeed = hum.WalkSpeed 
        hum.WalkSpeed = self.OriginalSpeed * self.Multiplier 
    end 
    NotificationSystem.Create("BoatHelper", "Speed Hack включен", 2) 
end

function SpeedHack:Disable() 
    if not self.Enabled then return end 
    self.Enabled = false 
    Settings.MISC.SpeedHack.Enabled = false 
    SaveAllSettings() 
    local hum = Player.Character and Player.Character:FindFirstChild("Humanoid") 
    if hum and self.OriginalSpeed then hum.WalkSpeed = self.OriginalSpeed end 
    NotificationSystem.Create("BoatHelper", "Speed Hack выключен", 2) 
end

-- FullBright
function FullBright:Enable() 
    if self.Enabled then return end 
    self.Enabled = true 
    Settings.MISC.FullBright = true 
    SaveAllSettings() 
    local L = Lighting 
    self.OriginalBrightness = L.Brightness 
    self.OriginalClockTime = L.ClockTime 
    self.OriginalAmbient = L.Ambient 
    self.OriginalFogEnd = L.FogEnd 
    self.OriginalGlobalShadows = L.GlobalShadows 
    
    L.Brightness = 3 
    L.ClockTime = 12 
    L.Ambient = Color3.fromRGB(255,255,255) 
    L.FogEnd = 100000 
    L.GlobalShadows = false 
    NotificationSystem.Create("BoatHelper", "Full Bright включен", 2) 
end

function FullBright:Disable() 
    if not self.Enabled then return end 
    self.Enabled = false 
    Settings.MISC.FullBright = false 
    SaveAllSettings() 
    local L = Lighting 
    L.Brightness = self.OriginalBrightness 
    L.ClockTime = self.OriginalClockTime 
    L.Ambient = self.OriginalAmbient or Color3.fromRGB(0,0,0) 
    L.FogEnd = self.OriginalFogEnd 
    L.GlobalShadows = self.OriginalGlobalShadows 
    NotificationSystem.Create("BoatHelper", "Full Bright выключен", 2) 
end

-- AntiAFK
function AntiAFK:Enable()
    if self.Enabled then return end
    self.Enabled = true
    Settings.MISC.AntiAFK = true
    SaveAllSettings()
    self.LastAction = os.clock()
    
    self.Connection = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end
        if os.clock() - self.LastAction > 180 then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            self.LastAction = os.clock()
        end
    end)
    
    NotificationSystem.Create("BoatHelper", "Anti-AFK включен", 2)
end

function AntiAFK:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    Settings.MISC.AntiAFK = false
    SaveAllSettings()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    NotificationSystem.Create("BoatHelper", "Anti-AFK выключен", 2)
end

-- SpinBot
function SpinBot:Enable()
    if self.Enabled then return end
    self.Enabled = true
    Settings.MISC.SpinBot = true
    SaveAllSettings()
    
    self.Connection = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            self.Angle = self.Angle + 10
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(10), 0)
        end
    end)
    
    NotificationSystem.Create("BoatHelper", "Spin Bot включен", 2)
end

function SpinBot:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    Settings.MISC.SpinBot = false
    SaveAllSettings()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    NotificationSystem.Create("BoatHelper", "Spin Bot выключен", 2)
end

-- Hitbox Expander
function HitboxExpander:Enable()
    if self.Enabled then return end
    self.Enabled = true
    Settings.AUTO.HitboxExpander = true
    SaveAllSettings()
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Player then
            local char = p.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        self.OriginalSizes[part] = part.Size
                        part.Size = part.Size * 1.5
                    end
                end
            end
        end
    end
    
    self.Connection = Players.PlayerAdded:Connect(function(p)
        if self.Enabled and p ~= Player then
            p.CharacterAdded:Connect(function(char)
                task.wait(0.5)
                if self.Enabled then
                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            self.OriginalSizes[part] = part.Size
                            part.Size = part.Size * 1.5
                        end
                    end
                end
            end)
        end
    end)
    
    NotificationSystem.Create("BoatHelper", "Hitbox Expander включен", 2)
end

function HitboxExpander:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    Settings.AUTO.HitboxExpander = false
    SaveAllSettings()
    
    for part, originalSize in pairs(self.OriginalSizes) do
        if part and part.Parent then
            part.Size = originalSize
        end
    end
    self.OriginalSizes = {}
    
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    NotificationSystem.Create("BoatHelper", "Hitbox Expander выключен", 2)
end

-- Trigger Bot
function TriggerBot:Enable()
    if self.Enabled then return end
    self.Enabled = true
    Settings.AUTO.TriggerBot = true
    SaveAllSettings()
    
    self.Connection = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end
        if os.clock() - self.LastShot < 0.1 then return end
        
        local target = SelectBestTarget()
        if target then
            self.LastShot = os.clock()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end)
    
    NotificationSystem.Create("BoatHelper", "Trigger Bot включен", 2)
end

function TriggerBot:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    Settings.AUTO.TriggerBot = false
    SaveAllSettings()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    NotificationSystem.Create("BoatHelper", "Trigger Bot выключен", 2)
end

-- Player Mods
function PlayerMods:Apply()
    local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = self.WalkSpeed
        hum.JumpPower = self.JumpPower
    end
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = self.FOV
    end
    
    if self.JumpConnection then
        self.JumpConnection:Disconnect()
        self.JumpConnection = nil
    end
    
    if self.InfiniteJump then
        self.JumpConnection = UserInputService.JumpRequest:Connect(function()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

function PlayerMods:SetWalkSpeed(v) self.WalkSpeed = v Settings.PLAYER.WalkSpeed = v SaveAllSettings() self:Apply() end
function PlayerMods:SetJumpPower(v) self.JumpPower = v Settings.PLAYER.JumpPower = v SaveAllSettings() self:Apply() end
function PlayerMods:SetFOV(v) self.FOV = v Settings.PLAYER.FOV = v SaveAllSettings() self:Apply() end
function PlayerMods:SetInfiniteJump(v) self.InfiniteJump = v Settings.PLAYER.InfiniteJump = v SaveAllSettings() self:Apply() end

-- AutoFarm
function AutoFarm:Enable()
    if self.Enabled then return end 
    self.Enabled = true 
    Settings.AUTO.AutoFarm = true 
    SaveAllSettings() 
    self.CurrentStage = 1 
    self.IsTeleporting = false 
    self.IsWalking = true 
    self.WalkTimer = 0
    
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "BoatHelper", Text = "Немного хожу перед запуском цикла...", Duration = 3})
    
    task.spawn(function()
        while self.Enabled and self.IsWalking do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            if math.random(1, 50) == 1 then 
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.A, false, game) 
                task.wait(0.3) 
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
            elseif math.random(1, 50) == 1 then 
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.D, false, game) 
                task.wait(0.3) 
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game) 
            end
            task.wait(0.1)
        end
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
    end)
    
    self.Connection = RunService.Heartbeat:Connect(function(dt)
        if not self.Enabled or self.IsTeleporting then return end
        local char = Player.Character 
        local root = char and char:FindFirstChild("HumanoidRootPart") 
        local hum = char and char:FindFirstChild("Humanoid")
        if not root or not hum then return end
        
        if self.IsWalking then
            self.WalkTimer += dt
            if self.WalkTimer < 3 then 
                return
            else 
                self.IsWalking = false 
                self.WalkTimer = 0
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game) 
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game) 
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game) 
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
                game:GetService("StarterGui"):SetCore("SendNotification", {Title = "BoatHelper", Text = "Запускаю цикл фарма!", Duration = 3})
            end
        end
        
        if not self.IsWalking then
            self.IsTeleporting = true 
            workspace.Gravity = 0
            
            if self.CurrentStage <= 10 then
                local tp = self:FindStage(self.CurrentStage)
                if tp then 
                    root.CFrame = tp.CFrame + Vector3.new(0,3,0) 
                    task.wait(1.5) 
                    self.CurrentStage += 1
                else 
                    task.wait(0.5) 
                    self.CurrentStage += 1 
                end
                workspace.Gravity = 196.2 
                self.IsTeleporting = false
            else
                local chest = self:FindGoldenChest()
                if chest then
                    workspace.Gravity = 196.2
                    root.CFrame = chest.CFrame + Vector3.new(0,5,0)
                    task.wait(2)
                    
                    local trigger = chest:FindFirstChild("Trigger")
                    if trigger and trigger:IsA("BasePart") then 
                        root.CFrame = trigger.CFrame + Vector3.new(0,3,0) 
                        task.wait(1) 
                    elseif trigger and trigger:IsA("ProximityPrompt") then 
                        fireproximityprompt(trigger) 
                    end
                    
                    task.wait(15) 
                    self.CurrentStage = 1 
                    self.IsWalking = true 
                    self.WalkTimer = 0
                    self.IsTeleporting = false
                    
                    task.spawn(function()
                        while self.Enabled and self.IsWalking do
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                            if math.random(1, 50) == 1 then 
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.A, false, game) 
                                task.wait(0.3) 
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
                            elseif math.random(1, 50) == 1 then 
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.D, false, game) 
                                task.wait(0.3) 
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game) 
                            end
                            task.wait(0.1)
                        end
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                    end)
                else 
                    task.wait(5) 
                    self.CurrentStage = 1 
                    self.IsWalking = true 
                    self.WalkTimer = 0
                    self.IsTeleporting = false
                end
                workspace.Gravity = 196.2
            end
        end
    end)
    
    self.CharacterAddedConnection = Player.CharacterAdded:Connect(function() 
        if self.Enabled then 
            workspace.Gravity = 0 
            self.CurrentStage = 1 
            self.IsWalking = true 
            self.WalkTimer = 0
            self.IsTeleporting = false
            task.spawn(function() 
                while self.Enabled and self.IsWalking do 
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game) 
                    task.wait(0.1) 
                end 
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game) 
            end)
        end 
    end)
end

function AutoFarm:FindStage(num)
    local bs = workspace:FindFirstChild("BoatStages") 
    if not bs then return nil end
    local ns = bs:FindFirstChild("NormalStages") 
    if not ns then return nil end
    local names = {"CaveStage"..num, "CaveStage"..string.format("%02d",num), "Stage"..num, "Cave"..num, "CaveStage"..string.format("%03d",num)}
    for _, n in pairs(names) do 
        local stage = ns:FindFirstChild(n) 
        if stage then
            local dp = stage:FindFirstChild("DarknessPart") 
            if dp then return dp end
            for _, c in pairs(stage:GetChildren()) do 
                if c:IsA("BasePart") then return c end 
            end
            for _, c in pairs(stage:GetDescendants()) do 
                if c:IsA("BasePart") then return c end 
            end
        end 
    end
    for _, child in pairs(ns:GetChildren()) do 
        if child.Name:lower():find("stage") and child.Name:lower():find(tostring(num)) then
            for _, c in pairs(child:GetDescendants()) do 
                if c:IsA("BasePart") then return c end 
            end
        end 
    end
    return nil
end

function AutoFarm:FindGoldenChest()
    local bs = workspace:FindFirstChild("BoatStages") 
    if not bs then return nil end
    local ns = bs:FindFirstChild("NormalStages") 
    if not ns then return nil end
    local theEnd = ns:FindFirstChild("TheEnd") 
    if not theEnd then return nil end
    local goldenChest = theEnd:FindFirstChild("GoldenChest") 
    if not goldenChest then return nil end
    local trigger = goldenChest:FindFirstChild("Trigger") 
    if trigger then return trigger end
    return goldenChest
end

function AutoFarm:Disable() 
    if not self.Enabled then return end 
    self.Enabled = false 
    Settings.AUTO.AutoFarm = false 
    SaveAllSettings() 
    self.IsTeleporting = false 
    self.CurrentStage = 1 
    self.IsWalking = false 
    self.WalkTimer = 0
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game) 
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game) 
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game) 
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
    if self.Connection then self.Connection:Disconnect() self.Connection = nil end 
    if self.CharacterAddedConnection then
        self.CharacterAddedConnection:Disconnect()
        self.CharacterAddedConnection = nil
    end
    workspace.Gravity = 196.2 
end

-- FPS Window
local function CreateFPSWindow()
    local SG = Instance.new("ScreenGui") 
    SG.Name = "FPSWindow" 
    SG.Parent = Player:WaitForChild("PlayerGui") 
    SG.ResetOnSpawn = false
    
    local Frame = Instance.new("Frame") 
    Frame.Size = UDim2.new(0, 100, 0, 45) 
    Frame.Position = UDim2.new(0.9, 0, 0.05, 0) 
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) 
    Frame.BorderSizePixel = 0 
    Frame.Parent = SG
    
    local Corner = Instance.new("UICorner") 
    Corner.CornerRadius = UDim.new(0, 5) 
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel") 
    Label.Size = UDim2.new(1, 0, 0, 20) 
    Label.Position = UDim2.new(0, 0, 0, 5) 
    Label.BackgroundTransparency = 1 
    Label.Text = "FPS: 0" 
    Label.TextColor3 = Color3.fromRGB(0, 255, 0) 
    Label.Font = Enum.Font.Code 
    Label.TextSize = 14 
    Label.Parent = Frame
    
    local PingLabel = Instance.new("TextLabel") 
    PingLabel.Size = UDim2.new(1, 0, 0, 20) 
    PingLabel.Position = UDim2.new(0, 0, 0, 25) 
    PingLabel.BackgroundTransparency = 1 
    PingLabel.Text = "Ping: 0ms" 
    PingLabel.TextColor3 = Color3.fromRGB(255, 200, 0) 
    PingLabel.Font = Enum.Font.Code 
    PingLabel.TextSize = 12 
    PingLabel.Parent = Frame
    
    local frameCount = 0 
    local lastTime = os.clock()
    RunService.RenderStepped:Connect(function() 
        frameCount += 1 
        local currentTime = os.clock() 
        if currentTime - lastTime >= 1 then 
            Label.Text = "FPS: " .. frameCount 
            frameCount = 0 
            lastTime = currentTime 
        end 
    end)
    
    task.spawn(function()
        while true do
            pcall(function()
                local ping = Stats:GetChildren()[1]:GetChildren()[1]:GetChildren()[1].Value
                PingLabel.Text = "Ping: " .. math.floor(ping) .. "ms"
            end)
            task.wait(1)
        end
    end)
    
    Frame.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            FPSWindow.Dragging = true
            FPSWindow.LastPosition = input.Position
            FPSWindow.DragOffset = Vector2.new(input.Position.X - Frame.AbsolutePosition.X, input.Position.Y - Frame.AbsolutePosition.Y)
        end 
    end)
    Frame.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            FPSWindow.Dragging = false
            FPSWindow.LastPosition = nil
        end 
    end)
    
    FPSWindow.Gui = SG 
    FPSWindow.Frame = Frame
end

-- Menu Button
local function CreateMenuButton()
    local SG = Instance.new("ScreenGui") 
    SG.Name = "MenuButtonGui" 
    SG.Parent = Player:WaitForChild("PlayerGui") 
    SG.ResetOnSpawn = false 
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local btn = Instance.new("TextButton") 
    btn.Name = "MenuButton" 
    btn.Size = UDim2.new(0, 50, 0, 50) 
    btn.Position = UDim2.new(0.85, 0, 0.85, 0) 
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 120) 
    btn.BorderSizePixel = 0 
    btn.Text = "B" 
    btn.TextColor3 = Color3.fromRGB(255, 255, 255) 
    btn.Font = Enum.Font.Code 
    btn.TextSize = 20 
    btn.AutoButtonColor = false 
    btn.Parent = SG
    
    local Corner = Instance.new("UICorner") 
    Corner.CornerRadius = UDim.new(1, 0) 
    Corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function() 
        if Menu.Gui and Menu.MainFrame then 
            Menu.IsOpen = not Menu.IsOpen 
            Menu.MainFrame.Visible = Menu.IsOpen 
        end 
    end)
    
    btn.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            MenuButton.Dragging = true
            MenuButton.LastPosition = input.Position
            MenuButton.DragOffset = Vector2.new(input.Position.X - btn.AbsolutePosition.X, input.Position.Y - btn.AbsolutePosition.Y)
        end 
    end)
    btn.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            MenuButton.Dragging = false
            MenuButton.LastPosition = nil
        end 
    end)
    
    MenuButton.Gui = SG 
    MenuButton.Button = btn
end

-- GUI
local function CreateMenu()
    local SG = Instance.new("ScreenGui") 
    SG.Name = "BoatHelperMenu" 
    SG.Parent = Player:WaitForChild("PlayerGui") 
    SG.ResetOnSpawn = false 
    SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MF = Instance.new("Frame") 
    MF.Size = UDim2.new(0,MenuWidth,0,HeaderHeight+TabHeight) 
    MF.Position = UDim2.new(0.5,-MenuWidth/2,0.1,0) 
    MF.BackgroundColor3 = C.BG 
    MF.BorderSizePixel = 0 
    MF.Parent = SG 
    MF.ZIndex = 2
    
    local TopBar = Instance.new("Frame") 
    TopBar.Size = UDim2.new(1,0,0,3) 
    TopBar.BackgroundColor3 = C.On 
    TopBar.BorderSizePixel = 0 
    TopBar.ZIndex = 5 
    TopBar.Parent = MF
    
    local Header = Instance.new("Frame") 
    Header.Size = UDim2.new(1,0,0,HeaderHeight) 
    Header.BackgroundColor3 = C.Header 
    Header.BorderSizePixel = 0 
    Header.ZIndex = 3 
    Header.Parent = MF
    
    local Logo = Instance.new("Frame") 
    Logo.Size = UDim2.new(0,30,0,30) 
    Logo.Position = UDim2.new(0,15,0.5,-15) 
    Logo.BackgroundColor3 = C.On 
    Logo.BorderSizePixel = 0 
    Logo.ZIndex = 4 
    Logo.Parent = Header
    
    local LogoCorner = Instance.new("UICorner") 
    LogoCorner.CornerRadius = UDim.new(1,0) 
    LogoCorner.Parent = Logo
    
    local LogoText = Instance.new("TextLabel") 
    LogoText.Size = UDim2.new(1,0,1,0) 
    LogoText.BackgroundTransparency = 1 
    LogoText.Text = "B" 
    LogoText.TextColor3 = Color3.fromRGB(255,255,255) 
    LogoText.Font = Enum.Font.Code 
    LogoText.TextSize = 18 
    LogoText.ZIndex = 5 
    LogoText.Parent = Logo
    
    local HeaderText = Instance.new("TextLabel") 
    HeaderText.Size = UDim2.new(1,-180,1,0) 
    HeaderText.Position = UDim2.new(0,55,0,0) 
    HeaderText.BackgroundTransparency = 1 
    HeaderText.Text = MenuName 
    HeaderText.TextColor3 = C.Bright 
    HeaderText.Font = Enum.Font.Code 
    HeaderText.TextSize = 22 
    HeaderText.TextXAlignment = Enum.TextXAlignment.Left 
    HeaderText.ZIndex = 4 
    HeaderText.Parent = Header
    
    local KillBtn = Instance.new("TextButton") 
    KillBtn.Size = UDim2.new(0,55,0,30) 
    KillBtn.Position = UDim2.new(1,-110,0.5,-15) 
    KillBtn.BackgroundColor3 = C.Danger 
    KillBtn.BorderSizePixel = 0 
    KillBtn.Text = "KILL" 
    KillBtn.TextColor3 = C.Bright 
    KillBtn.Font = Enum.Font.Code 
    KillBtn.TextSize = 12 
    KillBtn.AutoButtonColor = false 
    KillBtn.ZIndex = 4 
    KillBtn.Parent = Header
    
    local CloseBtn = Instance.new("TextButton") 
    CloseBtn.Size = UDim2.new(0,35,0,30) 
    CloseBtn.Position = UDim2.new(1,-45,0.5,-15) 
    CloseBtn.BackgroundColor3 = C.Off 
    CloseBtn.BorderSizePixel = 0 
    CloseBtn.Text = "X" 
    CloseBtn.TextColor3 = C.Bright 
    CloseBtn.Font = Enum.Font.Code 
    CloseBtn.TextSize = 14 
    CloseBtn.AutoButtonColor = false 
    CloseBtn.ZIndex = 4 
    CloseBtn.Parent = Header
    
    CloseBtn.MouseButton1Click:Connect(function() Menu:Destroy() end) 
    KillBtn.MouseButton1Click:Connect(function() Menu:Destroy() end)
    
    local TabPanel = Instance.new("Frame") 
    TabPanel.Size = UDim2.new(1,0,0,TabHeight) 
    TabPanel.Position = UDim2.new(0,0,0,HeaderHeight) 
    TabPanel.BackgroundColor3 = C.Tab 
    TabPanel.BorderSizePixel = 0 
    TabPanel.ZIndex = 3 
    TabPanel.Parent = MF
    
    local Tabs = {"ESP","AIMBOT","MISC","AUTO","PLAYER","SCRIPT","SETTINGS","PHON"}
    for i, tabName in ipairs(Tabs) do
        local TabBtn = Instance.new("TextButton") 
        TabBtn.Size = UDim2.new(1/8,-4,0,TabHeight-8) 
        TabBtn.Position = UDim2.new((i-1)/8,2,0,4) 
        TabBtn.BackgroundColor3 = i==1 and C.TabActive or C.Tab 
        TabBtn.BorderSizePixel = 0 
        TabBtn.Text = tabName 
        TabBtn.TextColor3 = i==1 and C.Bright or C.Text 
        TabBtn.Font = Enum.Font.Code 
        TabBtn.TextSize = 11 
        TabBtn.AutoButtonColor = false 
        TabBtn.ZIndex = 4 
        TabBtn.Parent = TabPanel
        
        local TabCorner = Instance.new("UICorner") 
        TabCorner.CornerRadius = UDim.new(0,5) 
        TabCorner.Parent = TabBtn
        TabBtn.MouseButton1Click:Connect(function() Menu:SwitchTab(tabName) end)
        Menu.TabButtons[tabName] = TabBtn
    end
    
    local ScrollFrame = Instance.new("ScrollingFrame") 
    ScrollFrame.Size = UDim2.new(1,0,1,-HeaderHeight-TabHeight) 
    ScrollFrame.Position = UDim2.new(0,0,0,HeaderHeight+TabHeight) 
    ScrollFrame.BackgroundTransparency = 1 
    ScrollFrame.BorderSizePixel = 0 
    ScrollFrame.ZIndex = 3 
    ScrollFrame.Parent = MF 
    ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y 
    ScrollFrame.ScrollBarThickness = 6 
    ScrollFrame.ScrollBarImageColor3 = C.ScrollBar 
    ScrollFrame.CanvasSize = UDim2.new(0,0,0,0) 
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y 
    ScrollFrame.ScrollBarImageTransparency = 0.3
    
    Menu.ScrollFrame = ScrollFrame 
    Menu.ItemsContainer = ScrollFrame
    
    Header.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            Menu.Dragging = true
            Menu.LastPosition = input.Position
            Menu.DragOffset = Vector2.new(input.Position.X - MF.AbsolutePosition.X, input.Position.Y - MF.AbsolutePosition.Y)
        end 
    end)
    Header.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            Menu.Dragging = false
            Menu.LastPosition = nil
            Settings.UIPositions.MenuPos = MF.Position
            SaveAllSettings()
        end 
    end)
    
    Menu.Gui = SG 
    Menu.MainFrame = MF
end

function Menu:SaveCurrentStates()
    TabStates.ESP.ESPEnabled = ESP.Enabled
    TabStates.ESP.ShowNames = ESP.ShowNames
    TabStates.ESP.ShowDistance = ESP.ShowDistance
    TabStates.ESP.ShowHealth = ESP.ShowHealth
    TabStates.ESP.TracersEnabled = Tracers.Enabled
    TabStates.AIMBOT.AimbotEnabled = AimbotSettings.Enabled
    TabStates.MISC.FlyEnabled = FlySystem.Enabled
    TabStates.MISC.FlySpeed = FlySystem.Speed
    TabStates.MISC.SpeedHackMultiplier = SpeedHack.Multiplier
    TabStates.AUTO.AutoFarmEnabled = AutoFarm.Enabled
    SaveAllSettings()
end

function Menu:SwitchTab(tabName)
    self:SaveCurrentStates()
    self.CurrentTab = tabName
    for _, c in pairs(self.SliderConnections) do if c then c:Disconnect() end end 
    self.SliderConnections = {}
    
    for name, btn in pairs(self.TabButtons) do 
        if name == tabName then 
            btn.BackgroundColor3 = C.TabActive 
            btn.TextColor3 = C.Bright 
        else 
            btn.BackgroundColor3 = C.Tab 
            btn.TextColor3 = C.Text 
        end 
    end
    
    if self.ItemsContainer then 
        for _, c in pairs(self.ItemsContainer:GetChildren()) do c:Destroy() end 
    end
    
    self.Items = {} 
    self.AllItems = {}
    
    if tabName == "ESP" then self:AddESPItems() 
    elseif tabName == "AIMBOT" then self:AddAimbotItems() 
    elseif tabName == "MISC" then self:AddMiscItems() 
    elseif tabName == "AUTO" then self:AddAutoItems() 
    elseif tabName == "PLAYER" then self:AddPlayerItems() 
    elseif tabName == "SCRIPT" then self:AddScriptItems() 
    elseif tabName == "SETTINGS" then self:AddSettingsItems() 
    elseif tabName == "PHON" then self:AddPhonItems() 
    end
    
    self:UpdateSize()
end

function Menu:UpdateSize()
    local h = HeaderHeight + TabHeight + 10
    for _, item in pairs(self.Items) do h += item.Height + Spacing end
    if h > MaxVisibleHeight then h = MaxVisibleHeight end
    self.MainFrame.Size = UDim2.new(0,MenuWidth,0,h) 
    self.ItemsContainer.Size = UDim2.new(1,0,0,h-HeaderHeight-TabHeight)
end

function Menu:RecalculatePositions()
    local y = 5
    for _, item in pairs(self.Items) do 
        item.Frame.Position = UDim2.new(0,0,0,y) 
        y += item.Height + Spacing 
    end
    self:UpdateSize()
end

function Menu:StartBinding(item, cb) 
    self.WaitingForBind = {item=item, callback=cb} 
    item.BindButton.Text = "..." 
end

function Menu:AddToggleWithExpand(name, desc, default, callback, expandContent, savedExpanded, expandHeight)
    local count = #self.Items 
    local y = 5 + count*(ItemHeight+Spacing)
    
    local MainContainer = Instance.new("Frame") 
    MainContainer.Size = UDim2.new(1,0,0,ItemHeight) 
    MainContainer.Position = UDim2.new(0,0,0,y) 
    MainContainer.BackgroundTransparency = 1 
    MainContainer.BorderSizePixel = 0 
    MainContainer.ZIndex = 3 
    MainContainer.Parent = self.ItemsContainer
    
    local Frame = Instance.new("Frame") 
    Frame.Size = UDim2.new(1,-20,0,ItemHeight) 
    Frame.Position = UDim2.new(0,10,0,0) 
    Frame.BackgroundColor3 = C.Item 
    Frame.BorderSizePixel = 0 
    Frame.ZIndex = 3 
    Frame.Parent = MainContainer
    
    local Corner = Instance.new("UICorner") 
    Corner.CornerRadius = UDim.new(0,5) 
    Corner.Parent = Frame
    
    local Name = Instance.new("TextLabel") 
    Name.Size = UDim2.new(0.45,0,0,24) 
    Name.Position = UDim2.new(0,15,0,6) 
    Name.BackgroundTransparency = 1 
    Name.Text = name 
    Name.TextColor3 = C.Bright 
    Name.Font = Enum.Font.Code 
    Name.TextSize = 16 
    Name.TextXAlignment = Enum.TextXAlignment.Left 
    Name.ZIndex = 4 
    Name.Parent = Frame
    
    local Desc = Instance.new("TextLabel") 
    Desc.Size = UDim2.new(0.45,0,0,18) 
    Desc.Position = UDim2.new(0,15,0,34) 
    Desc.BackgroundTransparency = 1 
    Desc.Text = desc or "" 
    Desc.TextColor3 = C.Text 
    Desc.Font = Enum.Font.Code 
    Desc.TextSize = 11 
    Desc.TextXAlignment = Enum.TextXAlignment.Left 
    Desc.ZIndex = 4 
    Desc.Parent = Frame
    
    local ArrowBtn = Instance.new("TextButton") 
    ArrowBtn.Size = UDim2.new(0,25,0,25) 
    ArrowBtn.Position = UDim2.new(0.55,0,0.5,-12) 
    ArrowBtn.BackgroundColor3 = C.ArrowBG 
    ArrowBtn.BorderSizePixel = 0 
    ArrowBtn.Text = savedExpanded and "v" or ">" 
    ArrowBtn.TextColor3 = C.Bright 
    ArrowBtn.Font = Enum.Font.Code 
    ArrowBtn.TextSize = 14 
    ArrowBtn.AutoButtonColor = false 
    ArrowBtn.ZIndex = 4 
    ArrowBtn.Parent = Frame
    
    local BindButton = Instance.new("TextButton") 
    BindButton.Size = UDim2.new(0,40,0,25) 
    BindButton.Position = UDim2.new(0.6,0,0.5,-12) 
    BindButton.BackgroundColor3 = C.BindBG 
    BindButton.BorderSizePixel = 0 
    BindButton.Text = "BIND" 
    BindButton.TextColor3 = C.Bright 
    BindButton.Font = Enum.Font.Code 
    BindButton.TextSize = 10 
    BindButton.AutoButtonColor = false 
    BindButton.ZIndex = 4 
    BindButton.Parent = Frame
    
    local Toggle = Instance.new("TextButton") 
    Toggle.Size = UDim2.new(0,50,0,28) 
    Toggle.Position = UDim2.new(0.85,0,0.5,-14) 
    Toggle.BackgroundColor3 = default and C.On or C.Off 
    Toggle.BorderSizePixel = 0 
    Toggle.Text = "" 
    Toggle.AutoButtonColor = false 
    Toggle.ZIndex = 4 
    Toggle.Parent = Frame
    
    local ToggleCorner = Instance.new("UICorner") 
    ToggleCorner.CornerRadius = UDim.new(0,14) 
    ToggleCorner.Parent = Toggle
    
    local Knob = Instance.new("Frame") 
    Knob.Size = UDim2.new(0,22,0,22) 
    Knob.Position = UDim2.new(0,default and 35 or 3,0.5,-11) 
    Knob.BackgroundColor3 = C.Bright 
    Knob.BorderSizePixel = 0 
    Knob.ZIndex = 5 
    Knob.Parent = Toggle
    
    local KnobCorner = Instance.new("UICorner") 
    KnobCorner.CornerRadius = UDim.new(1,0) 
    KnobCorner.Parent = Knob
    
    local State = Instance.new("TextLabel") 
    State.Size = UDim2.new(0,35,0,22) 
    State.Position = UDim2.new(0.85,-45,0.5,-11) 
    State.BackgroundTransparency = 1 
    State.Text = default and "ON" or "OFF" 
    State.TextColor3 = default and C.On or C.Text 
    State.Font = Enum.Font.Code 
    State.TextSize = 11 
    State.TextXAlignment = Enum.TextXAlignment.Right 
    State.ZIndex = 4 
    State.Parent = Frame
    
    local ExpandFrame = Instance.new("Frame") 
    ExpandFrame.Size = UDim2.new(1,-30,0,0) 
    ExpandFrame.Position = UDim2.new(0,15,0,ItemHeight) 
    ExpandFrame.BackgroundColor3 = C.Item 
    ExpandFrame.BorderSizePixel = 0 
    ExpandFrame.ZIndex = 3 
    ExpandFrame.Visible = savedExpanded or false 
    ExpandFrame.Parent = MainContainer
    
    local isExpanded = savedExpanded or false 
    local state = default or false 
    local expHeight = expandHeight or 70
    
    local item = {
        Frame = MainContainer, 
        BindButton = BindButton, 
        BindKey = nil, 
        Height = isExpanded and (ItemHeight + expHeight) or ItemHeight,
        ToggleFunction = function() 
            state = not state 
            Toggle.BackgroundColor3 = state and C.On or C.Off 
            Knob.Position = UDim2.new(0,state and 35 or 3,0.5,-11) 
            State.Text = state and "ON" or "OFF" 
            State.TextColor3 = state and C.On or C.Text 
            if callback then callback(state) end 
        end,
        SetState = function(s) 
            state = s 
            Toggle.BackgroundColor3 = state and C.On or C.Off 
            Knob.Position = UDim2.new(0,state and 35 or 3,0.5,-11) 
            State.Text = state and "ON" or "OFF" 
            State.TextColor3 = state and C.On or C.Text 
            if callback then callback(state) end 
        end,
        GetState = function() return state end
    }
    
    local function UpdateHeight()
        if isExpanded then 
            item.Height = ItemHeight + expHeight 
            MainContainer.Size = UDim2.new(1,0,0,item.Height) 
        else 
            item.Height = ItemHeight 
            MainContainer.Size = UDim2.new(1,0,0,item.Height) 
        end
        Menu:RecalculatePositions()
    end
    
    ArrowBtn.MouseButton1Click:Connect(function() 
        isExpanded = not isExpanded 
        ExpandFrame.Visible = isExpanded 
        ArrowBtn.Text = isExpanded and "v" or ">" 
        if isExpanded and expandContent then expandContent(ExpandFrame) end 
        UpdateHeight() 
    end)
    
    BindButton.MouseButton1Click:Connect(function() 
        Menu:StartBinding(item, function(key) 
            item.BindKey = key 
            BindButton.Text = key.Name 
        end) 
    end)
    
    Toggle.MouseButton1Click:Connect(function() 
        if Menu.FunctionsEnabled then item.ToggleFunction() end 
    end)
    
    if isExpanded and expandContent then 
        expandContent(ExpandFrame) 
        MainContainer.Size = UDim2.new(1,0,0,item.Height) 
    end
    
    table.insert(self.Items, item) 
    table.insert(self.AllItems, item) 
    self:UpdateSize() 
    return item
end

function CreateSliderInExpand(parent, name, min, max, default, yPos, callback)
    local SliderName = Instance.new("TextLabel") 
    SliderName.Size = UDim2.new(1,-30,0,20) 
    SliderName.Position = UDim2.new(0,15,0,yPos) 
    SliderName.BackgroundTransparency = 1 
    SliderName.Text = name..": "..default 
    SliderName.TextColor3 = C.Bright 
    SliderName.Font = Enum.Font.Code 
    SliderName.TextSize = 12 
    SliderName.TextXAlignment = Enum.TextXAlignment.Left 
    SliderName.ZIndex = 4 
    SliderName.Parent = parent
    
    local SliderButton = Instance.new("TextButton") 
    SliderButton.Size = UDim2.new(1,-30,0,18) 
    SliderButton.Position = UDim2.new(0,15,0,yPos+18) 
    SliderButton.BackgroundTransparency = 1 
    SliderButton.BorderSizePixel = 0 
    SliderButton.Text = "" 
    SliderButton.AutoButtonColor = false 
    SliderButton.ZIndex = 6 
    SliderButton.Parent = parent
    
    local SliderFrame = Instance.new("Frame") 
    SliderFrame.Size = UDim2.new(1,0,0,6) 
    SliderFrame.Position = UDim2.new(0,0,0.5,-3) 
    SliderFrame.BackgroundColor3 = C.Off 
    SliderFrame.BorderSizePixel = 0 
    SliderFrame.ZIndex = 4 
    SliderFrame.Parent = SliderButton
    
    local Fill = Instance.new("Frame") 
    local percent = (default-min)/(max-min) 
    Fill.Size = UDim2.new(percent,0,1,0) 
    Fill.BackgroundColor3 = C.SliderFill 
    Fill.BorderSizePixel = 0 
    Fill.ZIndex = 5 
    Fill.Parent = SliderFrame
    
    local Knob = Instance.new("Frame") 
    Knob.Size = UDim2.new(0,14,0,14) 
    Knob.Position = UDim2.new(percent,-7,0.5,-7) 
    Knob.BackgroundColor3 = C.Bright 
    Knob.BorderSizePixel = 0 
    Knob.ZIndex = 6 
    Knob.Parent = SliderFrame
    
    local dragging = false
    
    local function UpdateValue(inputX)
        local absX = SliderButton.AbsolutePosition.X 
        local width = SliderButton.AbsoluteSize.X 
        local p = math.clamp((inputX-absX)/width,0,1)
        local val = math.floor(min+(max-min)*p+0.5)
        Fill.Size = UDim2.new(p,0,1,0) 
        Knob.Position = UDim2.new(p,-7,0.5,-7) 
        SliderName.Text = name..": "..val
        if callback then callback(val) end
    end
    
    SliderButton.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true 
            UpdateValue(input.Position.X) 
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end 
    end)
    
    RunService.RenderStepped:Connect(function() 
        if dragging and Menu.FunctionsEnabled then 
            local mousePos = UserInputService:GetMouseLocation()
            UpdateValue(mousePos.X) 
        end 
    end)
end

function CreateToggleInExpand(parent, name, default, yPos, callback)
    local TF = Instance.new("Frame") 
    TF.Size = UDim2.new(1,-20,0,35) 
    TF.Position = UDim2.new(0,10,0,yPos) 
    TF.BackgroundColor3 = C.Item 
    TF.BorderSizePixel = 0 
    TF.ZIndex = 4 
    TF.Parent = parent
    
    local Label = Instance.new("TextLabel") 
    Label.Size = UDim2.new(0.7,0,1,0) 
    Label.Position = UDim2.new(0,10,0,0) 
    Label.BackgroundTransparency = 1 
    Label.Text = name 
    Label.TextColor3 = C.Bright 
    Label.Font = Enum.Font.Code 
    Label.TextSize = 11 
    Label.TextXAlignment = Enum.TextXAlignment.Left 
    Label.ZIndex = 5 
    Label.Parent = TF
    
    local Btn = Instance.new("TextButton") 
    Btn.Size = UDim2.new(0,40,0,20) 
    Btn.Position = UDim2.new(0.8,0,0.5,-10) 
    Btn.BackgroundColor3 = default and C.On or C.Off 
    Btn.BorderSizePixel = 0 
    Btn.Text = "" 
    Btn.AutoButtonColor = false 
    Btn.ZIndex = 5 
    Btn.Parent = TF
    
    local Knob = Instance.new("Frame") 
    Knob.Size = UDim2.new(0,14,0,14) 
    Knob.Position = UDim2.new(0,default and 23 or 3,0.5,-7) 
    Knob.BackgroundColor3 = C.Bright 
    Knob.BorderSizePixel = 0 
    Knob.ZIndex = 6 
    Knob.Parent = Btn
    
    local state = default
    
    Btn.MouseButton1Click:Connect(function() 
        state = not state 
        Btn.BackgroundColor3 = state and C.On or C.Off 
        Knob.Position = UDim2.new(0,state and 23 or 3,0.5,-7) 
        if callback then callback(state) end 
    end)
end

-- Вкладки
function Menu:AddESPItems()
    self:AddToggleWithExpand("ESP Игроков", "Подсветка всех игроков", ESP.Enabled, function(state)
        if state then ESP:Enable() else ESP:Disable() end
    end, function(ef)
        ef.Size = UDim2.new(1,-30,0,350)
        CreateToggleInExpand(ef, "Показывать имена", ESP.ShowNames, 5, function(s) ESP:SetShowNames(s) end)
        CreateToggleInExpand(ef, "Показывать расстояние", ESP.ShowDistance, 45, function(s) ESP:SetShowDistance(s) end)
        CreateToggleInExpand(ef, "Показывать здоровье", ESP.ShowHealth, 85, function(s) ESP:SetShowHealth(s) end)
        CreateToggleInExpand(ef, "Box ESP", ESP.BoxESP, 125, function(s) ESP:SetBoxESP(s) end)
        CreateToggleInExpand(ef, "Skeleton ESP", ESP.SkeletonESP, 165, function(s) ESP:SetSkeletonESP(s) end)
        CreateToggleInExpand(ef, "Chams", ESP.Chams, 205, function(s) ESP:SetChams(s) end)
        CreateSliderInExpand(ef, "Размер текста", 10, 20, ESP.TextSize, 245, function(v) ESP:SetTextSize(v) end)
    end, TabStates.ESP.ESPExpanded, 350)
    
    self:AddToggleWithExpand("Трасеры", "Линии к игрокам", Tracers.Enabled, function(state)
        if state then Tracers:Enable() else Tracers:Disable() end
    end)
end

function Menu:AddAimbotItems()
    self:AddToggleWithExpand("Aim Bot", "Мастер переключатель", AimbotSettings.Enabled, function(state)
        if state then EnableAimbot() else DisableAimbot() end
    end, function(ef)
        ef.Size = UDim2.new(1,-30,0,550)
        
        -- Часть тела
        local BoneFrame = Instance.new("Frame") 
        BoneFrame.Size = UDim2.new(1,-20,0,40) 
        BoneFrame.Position = UDim2.new(0,10,0,5) 
        BoneFrame.BackgroundColor3 = C.Item 
        BoneFrame.BorderSizePixel = 0 
        BoneFrame.ZIndex = 4 
        BoneFrame.Parent = ef
        
        local BoneLabel = Instance.new("TextLabel") 
        BoneLabel.Size = UDim2.new(0.5,0,1,0) 
        BoneLabel.Position = UDim2.new(0,10,0,0) 
        BoneLabel.BackgroundTransparency = 1 
        BoneLabel.Text = "Часть тела" 
        BoneLabel.TextColor3 = C.Bright 
        BoneLabel.Font = Enum.Font.Code 
        BoneLabel.TextSize = 12 
        BoneLabel.TextXAlignment = Enum.TextXAlignment.Left 
        BoneLabel.ZIndex = 5 
        BoneLabel.Parent = BoneFrame
        
        local BoneBtn = Instance.new("TextButton") 
        BoneBtn.Size = UDim2.new(0,100,0,25) 
        BoneBtn.Position = UDim2.new(0.6,0,0.5,-12) 
        BoneBtn.BackgroundColor3 = C.Accent 
        BoneBtn.BorderSizePixel = 0 
        BoneBtn.Text = AimbotSettings.TargetBone 
        BoneBtn.TextColor3 = C.Bright 
        BoneBtn.Font = Enum.Font.Code 
        BoneBtn.TextSize = 10 
        BoneBtn.AutoButtonColor = false 
        BoneBtn.ZIndex = 5 
        BoneBtn.Parent = BoneFrame
        
        local bones = {"Head","Neck","Chest","Closest"} 
        local bi = 1 
        for i,b in pairs(bones) do 
            if b == AimbotSettings.TargetBone then bi = i end 
        end
        
        BoneBtn.MouseButton1Click:Connect(function() 
            bi = bi + 1 
            if bi > #bones then bi = 1 end 
            AimbotSettings.TargetBone = bones[bi] 
            Settings.Aimbot.TargetBone = bones[bi] 
            SaveAllSettings() 
            BoneBtn.Text = bones[bi] 
        end)
        
        -- Приоритет
        local PF = Instance.new("Frame") 
        PF.Size = UDim2.new(1,-20,0,40) 
        PF.Position = UDim2.new(0,10,0,50) 
        PF.BackgroundColor3 = C.Item 
        PF.BorderSizePixel = 0 
        PF.ZIndex = 4 
        PF.Parent = ef
        
        local PL = Instance.new("TextLabel") 
        PL.Size = UDim2.new(0.5,0,1,0) 
        PL.Position = UDim2.new(0,10,0,0) 
        PL.BackgroundTransparency = 1 
        PL.Text = "Приоритет" 
        PL.TextColor3 = C.Bright 
        PL.Font = Enum.Font.Code 
        PL.TextSize = 12 
        PL.TextXAlignment = Enum.TextXAlignment.Left 
        PL.ZIndex = 5 
        PL.Parent = PF
        
        local PB = Instance.new("TextButton") 
        PB.Size = UDim2.new(0,100,0,25) 
        PB.Position = UDim2.new(0.6,0,0.5,-12) 
        PB.BackgroundColor3 = C.Accent 
        PB.BorderSizePixel = 0 
        PB.Text = AimbotSettings.TargetPriority 
        PB.TextColor3 = C.Bright 
        PB.Font = Enum.Font.Code 
        PB.TextSize = 10 
        PB.AutoButtonColor = false 
        PB.ZIndex = 5 
        PB.Parent = PF
        
        PB.MouseButton1Click:Connect(function() 
            if AimbotSettings.TargetPriority == "Distance" then 
                AimbotSettings.TargetPriority = "Health" 
            else 
                AimbotSettings.TargetPriority = "Distance" 
            end 
            Settings.Aimbot.TargetPriority = AimbotSettings.TargetPriority 
            SaveAllSettings() 
            PB.Text = AimbotSettings.TargetPriority 
        end)
        
        -- Клавиша активации
        local KeyFrame = Instance.new("Frame") 
        KeyFrame.Size = UDim2.new(1,-20,0,40) 
        KeyFrame.Position = UDim2.new(0,10,0,95) 
        KeyFrame.BackgroundColor3 = C.Item 
        KeyFrame.BorderSizePixel = 0 
        KeyFrame.ZIndex = 4 
        KeyFrame.Parent = ef
        
        local KeyLabel = Instance.new("TextLabel") 
        KeyLabel.Size = UDim2.new(0.5,0,1,0) 
        KeyLabel.Position = UDim2.new(0,10,0,0) 
        KeyLabel.BackgroundTransparency = 1 
        KeyLabel.Text = "Клавиша аима" 
        KeyLabel.TextColor3 = C.Bright 
        KeyLabel.Font = Enum.Font.Code 
        KeyLabel.TextSize = 12 
        KeyLabel.TextXAlignment = Enum.TextXAlignment.Left 
        KeyLabel.ZIndex = 5 
        KeyLabel.Parent = KeyFrame
        
        local KeyBtn = Instance.new("TextButton") 
        KeyBtn.Size = UDim2.new(0,100,0,25) 
        KeyBtn.Position = UDim2.new(0.6,0,0.5,-12) 
        KeyBtn.BackgroundColor3 = C.BindBG 
        KeyBtn.BorderSizePixel = 0 
        KeyBtn.Text = AimbotSettings.AimKey 
        KeyBtn.TextColor3 = C.Bright 
        KeyBtn.Font = Enum.Font.Code 
        KeyBtn.TextSize = 10 
        KeyBtn.AutoButtonColor = false 
        KeyBtn.ZIndex = 5 
        KeyBtn.Parent = KeyFrame
        
        KeyBtn.MouseButton1Click:Connect(function()
            KeyBtn.Text = "Нажмите..."
            local connection
            connection = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    AimbotSettings.AimKey = input.KeyCode.Name
                    Settings.Aimbot.AimKey = input.KeyCode.Name
                    SaveAllSettings()
                    KeyBtn.Text = input.KeyCode.Name
                    connection:Disconnect()
                end
            end)
        end)
        
        -- Режим активации
        local ModeFrame = Instance.new("Frame") 
        ModeFrame.Size = UDim2.new(1,-20,0,40) 
        ModeFrame.Position = UDim2.new(0,10,0,140) 
        ModeFrame.BackgroundColor3 = C.Item 
        ModeFrame.BorderSizePixel = 0 
        ModeFrame.ZIndex = 4 
        ModeFrame.Parent = ef
        
        local ModeLabel = Instance.new("TextLabel") 
        ModeLabel.Size = UDim2.new(0.5,0,1,0) 
        ModeLabel.Position = UDim2.new(0,10,0,0) 
        ModeLabel.BackgroundTransparency = 1 
        ModeLabel.Text = "Режим" 
        ModeLabel.TextColor3 = C.Bright 
        ModeLabel.Font = Enum.Font.Code 
        ModeLabel.TextSize = 12 
        ModeLabel.TextXAlignment = Enum.TextXAlignment.Left 
        ModeLabel.ZIndex = 5 
        ModeLabel.Parent = ModeFrame
        
        local ModeBtn = Instance.new("TextButton") 
        ModeBtn.Size = UDim2.new(0,100,0,25) 
        ModeBtn.Position = UDim2.new(0.6,0,0.5,-12) 
        ModeBtn.BackgroundColor3 = C.Accent 
        ModeBtn.BorderSizePixel = 0 
        ModeBtn.Text = AimbotSettings.AimMode 
        ModeBtn.TextColor3 = C.Bright 
        ModeBtn.Font = Enum.Font.Code 
        ModeBtn.TextSize = 10 
        ModeBtn.AutoButtonColor = false 
        ModeBtn.ZIndex = 5 
        ModeBtn.Parent = ModeFrame
        
        ModeBtn.MouseButton1Click:Connect(function()
            if AimbotSettings.AimMode == "Hold" then
                AimbotSettings.AimMode = "Toggle"
                Settings.Aimbot.AimMode = "Toggle"
                AimbotSettings.AimToggleState = false
            elseif AimbotSettings.AimMode == "Toggle" then
                AimbotSettings.AimMode = "Always"
                Settings.Aimbot.AimMode = "Always"
            else
                AimbotSettings.AimMode = "Hold"
                Settings.Aimbot.AimMode = "Hold"
            end
            SaveAllSettings()
            ModeBtn.Text = AimbotSettings.AimMode
        end)
        
        -- Слайдеры
        CreateSliderInExpand(ef, "FOV (градусы)", 0, 360, AimbotSettings.FOV, 185, function(v) 
            AimbotSettings.FOV = v 
            Settings.Aimbot.FOV = v 
            SaveAllSettings() 
            if AimbotSettings.ShowFOV then CreateFOVCircle() end 
        end)
        
        CreateSliderInExpand(ef, "Плавность", 1, 100, AimbotSettings.Smooth, 230, function(v) 
            AimbotSettings.Smooth = v 
            Settings.Aimbot.Smooth = v 
            SaveAllSettings() 
        end)
        
        CreateSliderInExpand(ef, "Prediction", 0, 100, AimbotSettings.Prediction, 275, function(v) 
            AimbotSettings.Prediction = v 
            Settings.Aimbot.Prediction = v 
            SaveAllSettings() 
        end)
        
        CreateSliderInExpand(ef, "Сила RCS", 0, 100, AimbotSettings.RCSStrength*100, 320, function(v) 
            AimbotSettings.RCSStrength = v/100 
            Settings.Aimbot.RCSStrength = v/100 
            SaveAllSettings() 
        end)
        
        -- Переключатели
        CreateToggleInExpand(ef, "Silent Aim", AimbotSettings.SilentAim, 365, function(s) 
            AimbotSettings.SilentAim = s 
            Settings.Aimbot.SilentAim = s 
            SaveAllSettings() 
        end)
        
        CreateToggleInExpand(ef, "Показывать FOV круг", AimbotSettings.ShowFOV, 405, function(s) 
            AimbotSettings.ShowFOV = s 
            Settings.Aimbot.ShowFOV = s 
            SaveAllSettings() 
            if s then 
                CreateFOVCircle() 
            elseif AimbotSettings.FOVCircle then 
                AimbotSettings.FOVCircle:Destroy() 
                AimbotSettings.FOVCircle = nil 
            end 
        end)
        
        CreateToggleInExpand(ef, "Включить RCS", AimbotSettings.RCSEnabled, 445, function(s) 
            AimbotSettings.RCSEnabled = s 
            Settings.Aimbot.RCSEnabled = s 
            SaveAllSettings() 
        end)
        
        CreateToggleInExpand(ef, "Проверка видимости", AimbotSettings.VisibleCheck, 485, function(s) 
            AimbotSettings.VisibleCheck = s 
            Settings.Aimbot.VisibleCheck = s 
            SaveAllSettings() 
        end)
        
        CreateToggleInExpand(ef, "Team Check", AimbotSettings.TeamCheck, 525, function(s) 
            AimbotSettings.TeamCheck = s 
            Settings.Aimbot.TeamCheck = s 
            SaveAllSettings() 
        end)
        
    end, TabStates.AIMBOT.AimbotExpanded, 550)
end

function Menu:AddMiscItems()
    self:AddToggleWithExpand("Полёт", "WASD + Space/Shift", FlySystem.Enabled, function(state)
        if state then FlySystem:Enable() else FlySystem:Disable() end
    end, function(ef)
        ef.Size = UDim2.new(1,-30,0,70)
        CreateSliderInExpand(ef, "Скорость полёта", 10, 200, FlySystem.Speed, 5, function(v) FlySystem:SetSpeed(v) end)
    end, TabStates.MISC.FlyExpanded, 70)
    
    self:AddToggleWithExpand("Noclip", "Прохождение сквозь стены", Noclip.Enabled, function(state) if state then Noclip:Enable() else Noclip:Disable() end end)
    
    self:AddToggleWithExpand("Speed Hack", "Ускорение x"..SpeedHack.Multiplier, SpeedHack.Enabled, function(state) if state then SpeedHack:Enable() else SpeedHack:Disable() end end, function(ef)
        ef.Size = UDim2.new(1,-30,0,70)
        CreateSliderInExpand(ef, "Множитель", 1, 10, SpeedHack.Multiplier, 5, function(v) SpeedHack.Multiplier = v Settings.MISC.SpeedHack.Multiplier = v SaveAllSettings() if SpeedHack.Enabled then local h = Player.Character and Player.Character:FindFirstChild("Humanoid") if h then h.WalkSpeed = SpeedHack.OriginalSpeed * v end end end)
    end, TabStates.MISC.SpeedHackExpanded, 70)
    
    self:AddToggleWithExpand("Full Bright", "Полная яркость", FullBright.Enabled, function(state) if state then FullBright:Enable() else FullBright:Disable() end end)
    self:AddToggleWithExpand("Anti-AFK", "Защита от кика", AntiAFK.Enabled, function(state) if state then AntiAFK:Enable() else AntiAFK:Disable() end end)
    self:AddToggleWithExpand("Spin Bot", "Вращение персонажа", SpinBot.Enabled, function(state) if state then SpinBot:Enable() else SpinBot:Disable() end end)
end

function Menu:AddAutoItems()
    self:AddToggleWithExpand("Авто фарм", "Ходьба + пещеры + сундук", AutoFarm.Enabled, function(state)
        if state then AutoFarm:Enable() else AutoFarm:Disable() end
    end)
    self:AddToggleWithExpand("Hitbox Expander", "Увеличение хитбоксов", HitboxExpander.Enabled, function(state)
        if state then HitboxExpander:Enable() else HitboxExpander:Disable() end
    end)
    self:AddToggleWithExpand("Trigger Bot", "Автострельба", TriggerBot.Enabled, function(state)
        if state then TriggerBot:Enable() else TriggerBot:Disable() end
    end)
end

function Menu:AddPlayerItems()
    self:AddToggleWithExpand("Модификации игрока", "Настройки персонажа", false, nil, function(ef)
        ef.Size = UDim2.new(1,-30,0,250)
        CreateSliderInExpand(ef, "Скорость ходьбы", 0, 100, PlayerMods.WalkSpeed, 5, function(v) PlayerMods:SetWalkSpeed(v) end)
        CreateSliderInExpand(ef, "Сила прыжка", 0, 200, PlayerMods.JumpPower, 50, function(v) PlayerMods:SetJumpPower(v) end)
        CreateSliderInExpand(ef, "FOV", 30, 120, PlayerMods.FOV, 95, function(v) PlayerMods:SetFOV(v) end)
        CreateToggleInExpand(ef, "Бесконечный прыжок", PlayerMods.InfiniteJump, 140, function(s) PlayerMods:SetInfiniteJump(s) end)
    end, false, 250)
end

function Menu:AddScriptItems()
    local Frame = Instance.new("Frame") Frame.Size = UDim2.new(1,-20,0,ItemHeight) Frame.Position = UDim2.new(0,10,0,5) Frame.BackgroundColor3 = C.Item Frame.BorderSizePixel = 0 Frame.ZIndex = 3 Frame.Parent = self.ItemsContainer
    local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0,5) Corner.Parent = Frame
    local Name = Instance.new("TextLabel") Name.Size = UDim2.new(0.6,0,0,24) Name.Position = UDim2.new(0,15,0,6) Name.BackgroundTransparency = 1 Name.Text = "Infinite Yield" Name.TextColor3 = C.Bright Name.Font = Enum.Font.Code Name.TextSize = 16 Name.TextXAlignment = Enum.TextXAlignment.Left Name.ZIndex = 4 Name.Parent = Frame
    local Desc = Instance.new("TextLabel") Desc.Size = UDim2.new(0.6,0,0,18) Desc.Position = UDim2.new(0,15,0,34) Desc.BackgroundTransparency = 1 Desc.Text = "Нажмите для запуска скрипта" Desc.TextColor3 = C.Text Desc.Font = Enum.Font.Code Desc.TextSize = 11 Desc.TextXAlignment = Enum.TextXAlignment.Left Desc.ZIndex = 4 Desc.Parent = Frame
    local LaunchBtn = Instance.new("TextButton") LaunchBtn.Size = UDim2.new(0,100,0,35) LaunchBtn.Position = UDim2.new(0.75,0,0.5,-17) LaunchBtn.BackgroundColor3 = C.On LaunchBtn.BorderSizePixel = 0 LaunchBtn.Text = "ЗАПУСК" LaunchBtn.TextColor3 = C.Bright LaunchBtn.Font = Enum.Font.Code LaunchBtn.TextSize = 14 LaunchBtn.AutoButtonColor = false LaunchBtn.ZIndex = 4 LaunchBtn.Parent = Frame
    local BtnCorner = Instance.new("UICorner") BtnCorner.CornerRadius = UDim.new(0,6) BtnCorner.Parent = LaunchBtn
    LaunchBtn.MouseButton1Click:Connect(function()
        LaunchBtn.Text = "ЗАГРУЗКА..." LaunchBtn.BackgroundColor3 = C.Accent
        task.spawn(function()
            local success, err = pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
            if success then
                LaunchBtn.Text = "ГОТОВО!" LaunchBtn.BackgroundColor3 = C.On
                NotificationSystem.Create("BoatHelper", "Infinite Yield успешно запущен!", 3)
                task.wait(2) LaunchBtn.Text = "ЗАПУСК"
            else
                LaunchBtn.Text = "ОШИБКА!" LaunchBtn.BackgroundColor3 = C.Danger
                NotificationSystem.Create("BoatHelper", "Не удалось запустить Infinite Yield!", 5)
                task.wait(2) LaunchBtn.Text = "ЗАПУСК" LaunchBtn.BackgroundColor3 = C.On
            end
        end)
    end)
    local item = {Frame = Frame, Height = ItemHeight, ToggleFunction = function() end, SetState = function() end, GetState = function() return false end}
    table.insert(self.Items, item) table.insert(self.AllItems, item) self:UpdateSize()
end

function Menu:AddSettingsItems()
    local SizeFrame = Instance.new("Frame")
    SizeFrame.Size = UDim2.new(1, -20, 0, 170)
    SizeFrame.Position = UDim2.new(0, 10, 0, 5)
    SizeFrame.BackgroundColor3 = C.Item
    SizeFrame.BorderSizePixel = 0
    SizeFrame.ZIndex = 3
    SizeFrame.Parent = self.ItemsContainer

    local SizeCorner = Instance.new("UICorner")
    SizeCorner.CornerRadius = UDim.new(0, 5)
    SizeCorner.Parent = SizeFrame

    local SizeTitle = Instance.new("TextLabel")
    SizeTitle.Size = UDim2.new(1, -30, 0, 25)
    SizeTitle.Position = UDim2.new(0, 15, 0, 5)
    SizeTitle.BackgroundTransparency = 1
    SizeTitle.Text = "📏 Размер меню"
    SizeTitle.TextColor3 = C.Bright
    SizeTitle.Font = Enum.Font.Code
    SizeTitle.TextSize = 16
    SizeTitle.TextXAlignment = Enum.TextXAlignment.Left
    SizeTitle.ZIndex = 4
    SizeTitle.Parent = SizeFrame

    CreateSliderInExpand(SizeFrame, "Ширина (X)", 400, 800, MenuWidth, 35, function(v)
        MenuWidth = v
        self:UpdateSize()
    end)
    
    CreateSliderInExpand(SizeFrame, "Высота (Y)", 400, 800, MaxVisibleHeight, 75, function(v)
        MaxVisibleHeight = v
        self:UpdateSize()
    end)

    CreateSliderInExpand(SizeFrame, "Прозрачность", 0, 90, 0, 115, function(v)
        self.MainFrame.BackgroundTransparency = v / 100
    end)

    local sizeItem = {
        Frame = SizeFrame, 
        Height = 170, 
        ToggleFunction = function() end, 
        SetState = function() end, 
        GetState = function() return false end
    }
    table.insert(self.Items, sizeItem)
    table.insert(self.AllItems, sizeItem)

    self:UpdateSize()
end

function Menu:AddPhonItems()
    self:AddToggleWithExpand("Бинды для функций", "Включить/выключить кнопки", false, nil, function(ef)
        ef.Size = UDim2.new(1,-30,0,250)
        local function CreateDraggableButton(guiName, btnName, text, yPos, getState, toggleFunc)
            local SG = Instance.new("ScreenGui") SG.Name = guiName SG.Parent = Player:WaitForChild("PlayerGui") SG.ResetOnSpawn = false SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            local btn = Instance.new("TextButton") btn.Name = btnName btn.Size = UDim2.new(0,70,0,40) btn.Position = UDim2.new(0.85,0,yPos,0) btn.BackgroundColor3 = getState() and Color3.fromRGB(0,200,120) or Color3.fromRGB(50,50,65) btn.BorderSizePixel = 0 btn.Text = text btn.TextColor3 = Color3.fromRGB(240,240,255) btn.Font = Enum.Font.Code btn.TextSize = 12 btn.AutoButtonColor = false btn.Parent = SG
            local Corner = Instance.new("UICorner") Corner.CornerRadius = UDim.new(0,8) Corner.Parent = btn
            btn.MouseButton1Click:Connect(function() toggleFunc() btn.BackgroundColor3 = getState() and Color3.fromRGB(0,200,120) or Color3.fromRGB(50,50,65) end)
            
            local dragging = false local dragOffset = Vector2.new(0,0) local lastPosition = nil
            
            btn.InputBegan:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                    dragging = true
                    lastPosition = input.Position
                    dragOffset = Vector2.new(input.Position.X - btn.AbsolutePosition.X, input.Position.Y - btn.AbsolutePosition.Y)
                end 
            end)
            btn.InputEnded:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                    dragging = false
                    lastPosition = nil
                end 
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and lastPosition and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    lastPosition = input.Position
                end
            end)
            
            RunService.RenderStepped:Connect(function() 
                if dragging and btn.Parent and lastPosition then 
                    btn.Position = UDim2.new(0, lastPosition.X - dragOffset.X, 0, lastPosition.Y - dragOffset.Y) 
                end 
            end)
            
            return SG
        end
        CreateToggleInExpand(ef, "Кнопка для ESP", TabStates.PHON.ESPKey, 5, function(s) TabStates.PHON.ESPKey = s Settings.PHON.ESPKey = s SaveAllSettings() if s then CreateDraggableButton("ESPKeyGui","ESPKeyBtn","ESP",0.15,function() return ESP.Enabled end,function() if ESP.Enabled then ESP:Disable() else ESP:Enable() end end) else local SG = Player:WaitForChild("PlayerGui"):FindFirstChild("ESPKeyGui") if SG then SG:Destroy() end end end)
        CreateToggleInExpand(ef, "Кнопка для Aimbot", TabStates.PHON.AimbotKey, 45, function(s) TabStates.PHON.AimbotKey = s Settings.PHON.AimbotKey = s SaveAllSettings() if s then CreateDraggableButton("AimbotKeyGui","AimbotKeyBtn","AIMBOT",0.25,function() return AimbotSettings.Enabled end,function() if AimbotSettings.Enabled then DisableAimbot() else EnableAimbot() end end) else local SG = Player:WaitForChild("PlayerGui"):FindFirstChild("AimbotKeyGui") if SG then SG:Destroy() end end end)
        CreateToggleInExpand(ef, "Кнопка для Fly", TabStates.PHON.FlyKey, 85, function(s) TabStates.PHON.FlyKey = s Settings.PHON.FlyKey = s SaveAllSettings() if s then CreateDraggableButton("FlyKeyGui","FlyKeyBtn","FLY",0.35,function() return FlySystem.Enabled end,function() if FlySystem.Enabled then FlySystem:Disable() else FlySystem:Enable() end end) else local SG = Player:WaitForChild("PlayerGui"):FindFirstChild("FlyKeyGui") if SG then SG:Destroy() end end end)
        CreateToggleInExpand(ef, "Кнопка для Noclip", TabStates.PHON.NoclipKey, 125, function(s) TabStates.PHON.NoclipKey = s Settings.PHON.NoclipKey = s SaveAllSettings() if s then CreateDraggableButton("NoclipKeyGui","NoclipKeyBtn","NOCLIP",0.45,function() return Noclip.Enabled end,function() if Noclip.Enabled then Noclip:Disable() else Noclip:Enable() end end) else local SG = Player:WaitForChild("PlayerGui"):FindFirstChild("NoclipKeyGui") if SG then SG:Destroy() end end end)
        CreateToggleInExpand(ef, "Кнопка для Speed", TabStates.PHON.SpeedKey, 165, function(s) TabStates.PHON.SpeedKey = s Settings.PHON.SpeedKey = s SaveAllSettings() if s then CreateDraggableButton("SpeedKeyGui","SpeedKeyBtn","SPEED",0.55,function() return SpeedHack.Enabled end,function() if SpeedHack.Enabled then SpeedHack:Disable() else SpeedHack:Enable() end end) else local SG = Player:WaitForChild("PlayerGui"):FindFirstChild("SpeedKeyGui") if SG then SG:Destroy() end end end)
        CreateToggleInExpand(ef, "Кнопка для AutoFarm", TabStates.PHON.AutoFarmKey, 205, function(s) TabStates.PHON.AutoFarmKey = s Settings.PHON.AutoFarmKey = s SaveAllSettings() if s then CreateDraggableButton("AutoFarmKeyGui","AutoFarmKeyBtn","FARM",0.65,function() return AutoFarm.Enabled end,function() if AutoFarm.Enabled then AutoFarm:Disable() else AutoFarm:Enable() end end) else local SG = Player:WaitForChild("PlayerGui"):FindFirstChild("AutoFarmKeyGui") if SG then SG:Destroy() end end end)
    end, false, 250)
end

function Menu:Destroy()
    Menu.FunctionsEnabled = false 
    Menu.IsOpen = false 
    Menu.Dragging = false
    for _, c in pairs(self.SliderConnections) do if c then c:Disconnect() end end
    SaveAllSettings()
    if Menu.Gui then Menu.Gui:Destroy() end
end

-- Горячие клавиши
local Hotkeys = {
    [Enum.KeyCode.F1] = function() if ESP.Enabled then ESP:Disable() else ESP:Enable() end end,
    [Enum.KeyCode.F2] = function() if AimbotSettings.Enabled then DisableAimbot() else EnableAimbot() end end,
    [Enum.KeyCode.F3] = function() if FlySystem.Enabled then FlySystem:Disable() else FlySystem:Enable() end end,
    [Enum.KeyCode.F4] = function() if Noclip.Enabled then Noclip:Disable() else Noclip:Enable() end end,
    [Enum.KeyCode.F5] = function() if SpeedHack.Enabled then SpeedHack:Disable() else SpeedHack:Enable() end end,
    [Enum.KeyCode.F6] = function() if AutoFarm.Enabled then AutoFarm:Disable() else AutoFarm:Enable() end end,
}

-- Инициализация
if ESP.Enabled then ESP:Enable() end
if Tracers.Enabled then Tracers:Enable() end
if AimbotSettings.Enabled then EnableAimbot() end
if FlySystem.Enabled then FlySystem:Enable() end
if Noclip.Enabled then Noclip:Enable() end
if SpeedHack.Enabled then SpeedHack:Enable() end
if FullBright.Enabled then FullBright:Enable() end
if AutoFarm.Enabled then AutoFarm:Enable() end
if AntiAFK.Enabled then AntiAFK:Enable() end
if SpinBot.Enabled then SpinBot:Enable() end
if HitboxExpander.Enabled then HitboxExpander:Enable() end
if TriggerBot.Enabled then TriggerBot:Enable() end

CreateMenu()
Menu:SwitchTab("ESP")
CreateFPSWindow()
CreateMenuButton()
PlayerMods:Apply()

-- Обработчики ввода
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    -- Переключение Toggle режима аима
    if AimbotSettings.Enabled and AimbotSettings.AimMode == "Toggle" then
        local keyName = AimbotSettings.AimKey
        local keyCode = Enum.KeyCode[keyName]
        if keyCode and input.KeyCode == keyCode then
            AimbotSettings.AimToggleState = not AimbotSettings.AimToggleState
            if AimbotSettings.AimToggleState then
                NotificationSystem.Create("BoatHelper", "Aim активирован", 1, C.On)
            else
                NotificationSystem.Create("BoatHelper", "Aim деактивирован", 1, C.Off)
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode.Insert and Menu.Gui and Menu.MainFrame then
        Menu.IsOpen = not Menu.IsOpen 
        Menu.MainFrame.Visible = Menu.IsOpen
        if Menu.IsOpen then
            Menu:SaveCurrentStates()
            Menu:SwitchTab(Menu.CurrentTab)
        end
    end
    
    local hotkey = Hotkeys[input.KeyCode]
    if hotkey then hotkey() end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Menu.WaitingForBind then
        local bind = Menu.WaitingForBind 
        Menu.WaitingForBind = nil
        bind.callback(input.KeyCode) 
        return
    end
    for _, item in pairs(Menu.AllItems) do
        if item.BindKey and input.KeyCode == item.BindKey then item.ToggleFunction() end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if Menu.Dragging and Menu.LastPosition then Menu.LastPosition = input.Position end
        if FPSWindow.Dragging and FPSWindow.LastPosition then FPSWindow.LastPosition = input.Position end
        if MenuButton.Dragging and MenuButton.LastPosition then MenuButton.LastPosition = input.Position end
    end
end)

RunService.RenderStepped:Connect(function()
    if Menu.Dragging and Menu.MainFrame and Menu.FunctionsEnabled and Menu.LastPosition then
        local x = math.clamp(Menu.LastPosition.X - Menu.DragOffset.X, 0, workspace.CurrentCamera.ViewportSize.X - Menu.MainFrame.AbsoluteSize.X)
        local y = math.clamp(Menu.LastPosition.Y - Menu.DragOffset.Y, 0, workspace.CurrentCamera.ViewportSize.Y - Menu.MainFrame.AbsoluteSize.Y)
        Menu.MainFrame.Position = UDim2.new(0,x,0,y)
    end
    if FPSWindow.Dragging and FPSWindow.Frame and FPSWindow.LastPosition then
        FPSWindow.Frame.Position = UDim2.new(0, FPSWindow.LastPosition.X - FPSWindow.DragOffset.X, 0, FPSWindow.LastPosition.Y - FPSWindow.DragOffset.Y)
    end
    if MenuButton.Dragging and MenuButton.Button and MenuButton.LastPosition then
        MenuButton.Button.Position = UDim2.new(0, MenuButton.LastPosition.X - MenuButton.DragOffset.X, 0, MenuButton.LastPosition.Y - MenuButton.DragOffset.Y)
    end
end)

NotificationSystem.Create("BoatHelper Premium", "Загружено! Нажмите на кнопку B", 5, C.On)
print("[BoatHelper Premium] Загружено! Нажмите на кнопку B")
