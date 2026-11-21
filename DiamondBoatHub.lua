
--[[
    DIAMOND BOAT HUB
    Build A Boat For Treasure
    Desktop + Mobile
    Version 1.0
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local old = (gethui and gethui() or game:GetService("CoreGui")):FindFirstChild("DiamondBoatHub")
if old then old:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "DiamondBoatHub"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parent
pcall(function()
    if gethui then
        parent = gethui()
    end
end)
if not parent then
    parent = Player:WaitForChild("PlayerGui")
end
GUI.Parent = parent

local function new(class, props, parentObj)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parentObj
    return obj
end

local function corner(obj, radius)
    new("UICorner", {CornerRadius=UDim.new(0,radius or 8)}, obj)
end

local function stroke(obj, color)
    new("UIStroke", {
        Color=color or Color3.fromRGB(100,75,220),
        Thickness=1
    }, obj)
end

local Purple = Color3.fromRGB(125,85,255)
local Dark = Color3.fromRGB(17,17,25)
local Panel = Color3.fromRGB(26,26,38)
local White = Color3.fromRGB(240,240,250)

local Main = new("Frame", {
    Size=UDim2.fromOffset(650,430),
    Position=UDim2.new(0.5,-325,0.5,-215),
    BackgroundColor3=Dark,
    BorderSizePixel=0
}, GUI)
corner(Main,12)
stroke(Main)

local Top = new("Frame", {
    Size=UDim2.new(1,0,0,48),
    BackgroundColor3=Panel,
    BorderSizePixel=0
},Main)
corner(Top,12)

new("TextLabel", {
    Size=UDim2.new(1,-120,1,0),
    Position=UDim2.fromOffset(15,0),
    BackgroundTransparency=1,
    Text="💎 DIAMOND BOAT HUB",
    TextColor3=White,
    TextSize=18,
    Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left
},Top)

local Min = new("TextButton", {
    Size=UDim2.fromOffset(38,30),
    Position=UDim2.new(1,-85,0,9),
    BackgroundColor3=Purple,
    Text="—",
    TextColor3=White,
    TextSize=20,
    Font=Enum.Font.GothamBold
},Top)
corner(Min,7)

local Close = new("TextButton", {
    Size=UDim2.fromOffset(38,30),
    Position=UDim2.new(1,-43,0,9),
    BackgroundColor3=Color3.fromRGB(180,55,75),
    Text="X",
    TextColor3=White,
    TextSize=16,
    Font=Enum.Font.GothamBold
},Top)
corner(Close,7)

local Sidebar = new("Frame", {
    Size=UDim2.new(0,145,1,-60),
    Position=UDim2.fromOffset(8,54),
    BackgroundColor3=Panel,
    BorderSizePixel=0
},Main)
corner(Sidebar,9)

local Content = new("Frame", {
    Size=UDim2.new(1,-165,1,-60),
    Position=UDim2.fromOffset(155,54),
    BackgroundColor3=Panel,
    BorderSizePixel=0
},Main)
corner(Content,9)

local Pages = {}
local CurrentPage

local function makePage(name)
    local page = new("ScrollingFrame", {
        Name=name,
        Size=UDim2.new(1,-12,1,-12),
        Position=UDim2.fromOffset(6,6),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=4,
        ScrollBarImageColor3=Purple,
        CanvasSize=UDim2.new(0,0,0,0),
        Visible=false
    },Content)

    local layout = new("UIListLayout", {
        Padding=UDim.new(0,7),
        SortOrder=Enum.SortOrder.LayoutOrder
    },page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+12)
    end)

    Pages[name]=page
    return page
end

local function showPage(name)
    for n,p in pairs(Pages) do
        p.Visible=(n==name)
    end
    CurrentPage=name
end

local function tab(name)
    local b=new("TextButton",{
        Size=UDim2.new(1,-12,0,35),
        Position=UDim2.fromOffset(6,0),
        BackgroundColor3=Dark,
        Text=name,
        TextColor3=White,
        TextSize=13,
        Font=Enum.Font.GothamSemibold
    },Sidebar)
    corner(b,7)
    b.Activated:Connect(function()
        showPage(name)
    end)
    return b
end

local function button(page, text, callback)
    local b=new("TextButton",{
        Size=UDim2.new(1,-8,0,38),
        BackgroundColor3=Dark,
        Text=text,
        TextColor3=White,
        TextSize=13,
        Font=Enum.Font.Gotham
    },page)
    corner(b,7)
    stroke(b,Color3.fromRGB(55,55,80))
    b.Activated:Connect(callback)
    return b
end

local function label(page,text)
    return new("TextLabel",{
        Size=UDim2.new(1,-8,0,30),
        BackgroundTransparency=1,
        Text=text,
        TextColor3=Purple,
        TextSize=14,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left
    },page)
end

local function toggle(page,text,default,callback)
    local state=default or false
    local b=button(page,text..": "..(state and "ON" or "OFF"),function()
        state=not state
        b.Text=text..": "..(state and "ON" or "OFF")
        b.BackgroundColor3=state and Color3.fromRGB(65,45,120) or Dark
        callback(state)
    end)
    return b
end

local home=makePage("HOME")
local movement=makePage("MOVEMENT")
local visuals=makePage("VISUALS")
local teleport=makePage("TELEPORTS")
local farm=makePage("AUTO FARM")
local build=makePage("AUTO BUILD")
local settings=makePage("SETTINGS")

for _,name in ipairs({
    "HOME","MOVEMENT","VISUALS","TELEPORTS",
    "AUTO FARM","AUTO BUILD","SETTINGS"
}) do
    tab(name)
end

-- HOME
label(home,"Welcome to Diamond Boat Hub")
label(home,"Build A Boat For Treasure")
button(home,"Check character",function()
    local char=Player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    print("Character:",char,"Humanoid:",hum)
end)
button(home,"Show player information",function()
    print("Player:",Player.Name)
    print("UserId:",Player.UserId)
    print("PlaceId:",game.PlaceId)
end)
button(home,"Reset character",function()
    local hum=Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health=0 end
end)

-- MOVEMENT
label(movement,"Movement settings")

local speedEnabled=false
local jumpEnabled=false
local infiniteJump=false
local flyEnabled=false
local flyConnection
local bodyVelocity
local bodyGyro

local function humanoid()
    local char=Player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function applySpeed()
    local h=humanoid()
    if h then h.WalkSpeed=speedEnabled and 45 or 16 end
end

local function applyJump()
    local h=humanoid()
    if h then
        h.UseJumpPower=true
        h.JumpPower=jumpEnabled and 100 or 50
    end
end

toggle(movement,"Speed boost",false,function(v)
    speedEnabled=v
    applySpeed()
end)

toggle(movement,"High jump",false,function(v)
    jumpEnabled=v
    applyJump()
end)

toggle(movement,"Infinite jump",false,function(v)
    infiniteJump=v
end)

UIS.JumpRequest:Connect(function()
    if infiniteJump then
        local h=humanoid()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local function stopFly()
    flyEnabled=false
    if flyConnection then flyConnection:Disconnect() flyConnection=nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity=nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro=nil end
end

toggle(movement,"Fly",false,function(v)
    if not v then
        stopFly()
        return
    end

    local char=Player.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local h=humanoid()
    if not root or not h then return end

    flyEnabled=true
    bodyVelocity=Instance.new("BodyVelocity")
    bodyVelocity.MaxForce=Vector3.new(1e6,1e6,1e6)
    bodyVelocity.Velocity=Vector3.zero
    bodyVelocity.Parent=root

    bodyGyro=Instance.new("BodyGyro")
    bodyGyro.MaxTorque=Vector3.new(1e6,1e6,1e6)
    bodyGyro.P=1e5
    bodyGyro.CFrame=Camera.CFrame
    bodyGyro.Parent=root

    flyConnection=RunService.RenderStepped:Connect(function()
        if not flyEnabled or not root.Parent then
            stopFly()
            return
        end

        local direction=Vector3.zero
        local cf=Camera.CFrame

        if UIS:IsKeyDown(Enum.KeyCode.W) then direction+=cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction-=cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then direction-=cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then direction+=cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then direction+=Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then direction-=Vector3.yAxis end

        bodyVelocity.Velocity=direction.Magnitude>0 and direction.Unit*55 or Vector3.zero
        bodyGyro.CFrame=cf
        h:ChangeState(Enum.HumanoidStateType.Physics)
    end)
end)

-- VISUALS
label(visuals,"Visual settings")

local oldFov=Camera.FieldOfView
toggle(visuals,"Wide FOV",false,function(v)
    Camera.FieldOfView=v and 100 or oldFov
end)

local oldLighting={}
for _,prop in ipairs({"Brightness","ClockTime","GlobalShadows","FogEnd"}) do
    oldLighting[prop]=Lighting[prop]
end

toggle(visuals,"Fullbright",false,function(v)
    if v then
        Lighting.Brightness=3
        Lighting.ClockTime=14
        Lighting.GlobalShadows=false
        Lighting.FogEnd=100000
    else
        for prop,value in pairs(oldLighting) do
            Lighting[prop]=value
        end
    end
end)

-- TELEPORTS
label(teleport,"Position tools")
local savedPosition

button(teleport,"Save current position",function()
    local root=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        savedPosition=root.CFrame
        print("Position saved:",savedPosition)
    end
end)

button(teleport,"Return to saved position",function()
    local root=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if root and savedPosition then
        root.CFrame=savedPosition
    end
end)

button(teleport,"Teleport 20 studs upward",function()
    local root=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame=root.CFrame+Vector3.new(0,20,0) end
end)

button(teleport,"Teleport to spawn",function()
    local root=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    local spawn=Workspace:FindFirstChildWhichIsA("SpawnLocation",true)
    if root and spawn then
        root.CFrame=spawn.CFrame+Vector3.new(0,5,0)
    else
        warn("SpawnLocation not found")
    end
end)

-- AUTO FARM
label(farm,"Auto Farm")
label(farm,"Not activated: game objects need to be identified.")
button(farm,"Scan stages and treasure objects",function()
    local found=0
    for _,obj in ipairs(Workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if n:find("stage") or n:find("chest") or n:find("treasure")
        or n:find("gold") or n:find("finish") then
            print("[DIAMOND SCAN]",obj:GetFullName(),obj.ClassName)
            found+=1
        end
    end
    print("Scan finished. Matches:",found)
end)

-- AUTO BUILD
label(build,"Auto Build")
label(build,"Real boat copying needs the game's actual build remotes.")
button(build,"Scan boats, plots and bases",function()
    local found=0
    for _,obj in ipairs(Workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if n:find("boat") or n:find("plot") or n:find("base")
        or n:find("ship") or n:find("build") then
            if obj:IsA("Model") or obj:IsA("Folder") then
                print("[DIAMOND BUILD SCAN]",obj:GetFullName(),obj.ClassName)
                found+=1
            end
        end
    end
    print("Candidate objects:",found)
end)

button(build,"Find building remotes",function()
    local count=0
    for _,root in ipairs({
        game:GetService("ReplicatedStorage"),
        game:GetService("ReplicatedFirst")
    }) do
        for _,obj in ipairs(root:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local n=obj.Name:lower()
                if n:find("build") or n:find("place") or n:find("block")
                or n:find("boat") or n:find("plot") then
                    print("[DIAMOND REMOTE]",obj:GetFullName(),obj.ClassName)
                    count+=1
                end
            end
        end
    end
    print("Matching remotes:",count)
end)

-- SETTINGS
label(settings,"Hub settings")
button(settings,"Reapply movement settings",function()
    applySpeed()
    applyJump()
end)

button(settings,"Destroy GUI",function()
    stopFly()
    GUI:Destroy()
end)

-- Window drag (mouse + touch)
local dragging=false
local dragStart
local startPos

Top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch
    ) then
        local delta=input.Position-dragStart
        Main.Position=UDim2.new(
            startPos.X.Scale,startPos.X.Offset+delta.X,
            startPos.Y.Scale,startPos.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

local minimized=false
Min.Activated:Connect(function()
    minimized=not minimized
    Sidebar.Visible=not minimized
    Content.Visible=not minimized
    Main.Size=minimized and UDim2.fromOffset(650,48)
        or UDim2.fromOffset(650,430)
    Min.Text=minimized and "+" or "—"
end)

local reopen=new("TextButton",{
    Size=UDim2.fromOffset(55,55),
    Position=UDim2.new(0,15,0.5,-25),
    BackgroundColor3=Purple,
    Text="💎",
    TextSize=24,
    TextColor3=White,
    Visible=false
},GUI)
corner(reopen,50)

Close.Activated:Connect(function()
    Main.Visible=false
    reopen.Visible=true
end)

reopen.Activated:Connect(function()
    Main.Visible=true
    reopen.Visible=false
end)

Player.CharacterAdded:Connect(function()
    task.wait(1)
    applySpeed()
    applyJump()
    if flyEnabled then stopFly() end
end)

showPage("HOME")
print("DIAMOND BOAT HUB v1.0 loaded!")
