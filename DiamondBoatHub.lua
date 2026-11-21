
--==================================================
-- DIAMOND BOAT HUB V2
-- Build A Boat For Treasure
-- Desktop + Mobile
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function getParent()
    if gethui then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    return Player:WaitForChild("PlayerGui")
end

local Parent = getParent()
local previous = Parent:FindFirstChild("DiamondBoatHub")
if previous then previous:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "DiamondBoatHub"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = Parent

local PURPLE = Color3.fromRGB(130,90,255)
local DARK = Color3.fromRGB(17,17,25)
local PANEL = Color3.fromRGB(27,27,40)
local WHITE = Color3.fromRGB(240,240,250)
local GREEN = Color3.fromRGB(60,180,120)

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    create("UICorner", {
        CornerRadius=UDim.new(0,radius or 8)
    },obj)
end

local function outline(obj)
    create("UIStroke",{
        Color=Color3.fromRGB(75,65,115),
        Thickness=1
    },obj)
end

local Main = create("Frame",{
    Size=UDim2.fromOffset(680,470),
    Position=UDim2.new(.5,-340,.5,-235),
    BackgroundColor3=DARK,
    BorderSizePixel=0
},GUI)
round(Main,12)
outline(Main)

local Top = create("Frame",{
    Size=UDim2.new(1,0,0,48),
    BackgroundColor3=PANEL,
    BorderSizePixel=0
},Main)
round(Top,12)

create("TextLabel",{
    Size=UDim2.new(1,-150,1,0),
    Position=UDim2.fromOffset(15,0),
    BackgroundTransparency=1,
    Text="💎 DIAMOND BOAT HUB V2",
    TextColor3=WHITE,
    TextSize=18,
    Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left
},Top)

local Min = create("TextButton",{
    Size=UDim2.fromOffset(35,30),
    Position=UDim2.new(1,-82,0,9),
    BackgroundColor3=PURPLE,
    Text="—",
    TextColor3=WHITE,
    TextSize=18
},Top)
round(Min,7)

local Close = create("TextButton",{
    Size=UDim2.fromOffset(35,30),
    Position=UDim2.new(1,-42,0,9),
    BackgroundColor3=Color3.fromRGB(170,55,75),
    Text="X",
    TextColor3=WHITE,
    TextSize=15
},Top)
round(Close,7)

local Sidebar = create("Frame",{
    Size=UDim2.new(0,150,1,-58),
    Position=UDim2.fromOffset(7,53),
    BackgroundColor3=PANEL,
    BorderSizePixel=0
},Main)
round(Sidebar,9)

local Content = create("Frame",{
    Size=UDim2.new(1,-165,1,-58),
    Position=UDim2.fromOffset(157,53),
    BackgroundColor3=PANEL,
    BorderSizePixel=0
},Main)
round(Content,9)

local Pages = {}
local CurrentPage

local function makePage(name)
    local page=create("ScrollingFrame",{
        Size=UDim2.new(1,-12,1,-12),
        Position=UDim2.fromOffset(6,6),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=4,
        ScrollBarImageColor3=PURPLE,
        CanvasSize=UDim2.new(0,0,0,0),
        Visible=false
    },Content)

    local layout=create("UIListLayout",{
        Padding=UDim.new(0,7),
        SortOrder=Enum.SortOrder.LayoutOrder
    },page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize=UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+15)
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

local function label(page,text)
    return create("TextLabel",{
        Size=UDim2.new(1,-8,0,30),
        BackgroundTransparency=1,
        Text=text,
        TextColor3=PURPLE,
        TextSize=14,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left
    },page)
end

local function button(page,text,callback)
    local b=create("TextButton",{
        Size=UDim2.new(1,-8,0,38),
        BackgroundColor3=DARK,
        Text=text,
        TextColor3=WHITE,
        TextSize=13,
        Font=Enum.Font.Gotham
    },page)
    round(b,7)
    outline(b)
    b.Activated:Connect(callback)
    return b
end

local function toggle(page,text,default,callback)
    local state=default or false
    local b
    b=button(page,text..": "..(state and "ON" or "OFF"),function()
        state=not state
        b.Text=text..": "..(state and "ON" or "OFF")
        b.BackgroundColor3=state and Color3.fromRGB(65,45,120) or DARK
        callback(state)
    end)
    return b
end

local function getCharacter()
    local char=Player.Character
    if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local root=char:FindFirstChild("HumanoidRootPart")
    return char,hum,root
end

-- PAGES

local home=makePage("HOME")
local movement=makePage("MOVEMENT")
local visuals=makePage("VISUALS")
local teleport=makePage("TELEPORTS")
local build=makePage("AUTO BUILD")
local farm=makePage("AUTO FARM")
local tools=makePage("TOOLS")
local settings=makePage("SETTINGS")

local tabLayout=create("UIListLayout",{
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
},Sidebar)

for _,name in ipairs({
    "HOME","MOVEMENT","VISUALS","TELEPORTS",
    "AUTO BUILD","AUTO FARM","TOOLS","SETTINGS"
}) do
    local b=create("TextButton",{
        Size=UDim2.new(1,-12,0,38),
        BackgroundColor3=DARK,
        Text=name,
        TextColor3=WHITE,
        TextSize=12,
        Font=Enum.Font.GothamSemibold
    },Sidebar)
    round(b,7)
    b.Activated:Connect(function()
        showPage(name)
    end)
end

-- HOME

label(home,"Welcome to Diamond Boat Hub")
label(home,"Build A Boat For Treasure")
button(home,"Player information",function()
    print("Player:",Player.Name)
    print("UserId:",Player.UserId)
    print("PlaceId:",game.PlaceId)
end)

button(home,"Character information",function()
    local char,hum,root=getCharacter()
    print("Character:",char)
    print("Humanoid:",hum)
    print("Root:",root)
end)

button(home,"Reset character",function()
    local _,hum=getCharacter()
    if hum then hum.Health=0 end
end)

-- MOVEMENT

label(movement,"Movement controls")

local speedOn=false
local jumpOn=false
local infiniteJump=false
local flyOn=false
local flyConnection
local flyVelocity
local flyGyro

local function updateSpeed()
    local _,hum=getCharacter()
    if hum then hum.WalkSpeed=speedOn and 45 or 16 end
end

local function updateJump()
    local _,hum=getCharacter()
    if hum then
        hum.UseJumpPower=true
        hum.JumpPower=jumpOn and 100 or 50
    end
end

toggle(movement,"Speed boost",false,function(v)
    speedOn=v
    updateSpeed()
end)

toggle(movement,"High jump",false,function(v)
    jumpOn=v
    updateJump()
end)

toggle(movement,"Infinite jump",false,function(v)
    infiniteJump=v
end)

UIS.JumpRequest:Connect(function()
    if infiniteJump then
        local _,hum=getCharacter()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function stopFly()
    flyOn=false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection=nil
    end
    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity=nil
    end
    if flyGyro then
        flyGyro:Destroy()
        flyGyro=nil
    end
end

toggle(movement,"Fly",false,function(v)
    if not v then
        stopFly()
        return
    end

    local _,hum,root=getCharacter()
    if not root or not hum then return end

    flyOn=true

    flyVelocity=Instance.new("BodyVelocity")
    flyVelocity.MaxForce=Vector3.new(1e6,1e6,1e6)
    flyVelocity.Velocity=Vector3.zero
    flyVelocity.Parent=root

    flyGyro=Instance.new("BodyGyro")
    flyGyro.MaxTorque=Vector3.new(1e6,1e6,1e6)
    flyGyro.P=1e5
    flyGyro.CFrame=Camera.CFrame
    flyGyro.Parent=root

    flyConnection=RunService.RenderStepped:Connect(function()
        if not flyOn or not root.Parent then
            stopFly()
            return
        end

        local cf=Camera.CFrame
        local dir=Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=Vector3.yAxis end

        flyVelocity.Velocity=dir.Magnitude>0 and dir.Unit*55 or Vector3.zero
        flyGyro.CFrame=cf
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end)
end)

button(movement,"Reset movement",function()
    speedOn=false
    jumpOn=false
    updateSpeed()
    updateJump()
end)

-- VISUALS

label(visuals,"Visual settings")

local originalFov=Camera.FieldOfView
toggle(visuals,"Wide FOV",false,function(v)
    Camera.FieldOfView=v and 100 or originalFov
end)

local oldLighting={
    Brightness=Lighting.Brightness,
    ClockTime=Lighting.ClockTime,
    GlobalShadows=Lighting.GlobalShadows,
    FogEnd=Lighting.FogEnd
}

toggle(visuals,"Fullbright",false,function(v)
    if v then
        Lighting.Brightness=3
        Lighting.ClockTime=14
        Lighting.GlobalShadows=false
        Lighting.FogEnd=100000
    else
        for k,value in pairs(oldLighting) do
            Lighting[k]=value
        end
    end
end)

toggle(visuals,"Hide GUI",false,function(v)
    Sidebar.Visible=not v
    Content.Visible=not v
end)

-- TELEPORTS

label(teleport,"Position manager")

local savedPosition

button(teleport,"Save current position",function()
    local _,_,root=getCharacter()
    if root then
        savedPosition=root.CFrame
        print("Position saved")
    end
end)

button(teleport,"Return to saved position",function()
    local _,_,root=getCharacter()
    if root and savedPosition then
        root.CFrame=savedPosition
    end
end)

button(teleport,"Move 20 studs upward",function()
    local _,_,root=getCharacter()
    if root then
        root.CFrame=root.CFrame+Vector3.new(0,20,0)
    end
end)

button(teleport,"Move 20 studs downward",function()
    local _,_,root=getCharacter()
    if root then
        root.CFrame=root.CFrame-Vector3.new(0,20,0)
    end
end)

-- AUTO BUILD

label(build,"Base scanner")
label(build,"Scan candidate bases, then select one")

local selectedBase=nil
local baseButtons={}
local previewModel=nil

local selectedLabel=label(build,"Selected base: none")

local function clearPreview()
    if previewModel then
        previewModel:Destroy()
        previewModel=nil
    end
end

local function clearBaseButtons()
    for _,b in ipairs(baseButtons) do
        if b and b.Parent then b:Destroy() end
    end
    table.clear(baseButtons)
end

local function scanBases()
    clearBaseButtons()
    clearPreview()
    selectedBase=nil
    selectedLabel.Text="Selected base: none"

    local candidates={}
    local seen={}

    for _,obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            local n=obj.Name:lower()
            local relevant=n:find("boat") or n:find("plot")
                or n:find("base") or n:find("ship")

            if relevant and not seen[obj] then
                seen[obj]=true
                local parts=0
                for _,d in ipairs(obj:GetDescendants()) do
                    if d:IsA("BasePart") then parts+=1 end
                end

                if parts>0 then
                    table.insert(candidates,{
                        object=obj,
                        parts=parts
                    })
                end
            end
        end
    end

    table.sort(candidates,function(a,b)
        return a.parts>b.parts
    end)

    print("DIAMOND BASE SCAN:",#candidates,"candidates")

    for i,item in ipairs(candidates) do
        local obj=item.object
        local b=button(build,
            i..". "..obj.Name.." ["..item.parts.." parts]",
            function()
                selectedBase=obj
                selectedLabel.Text="Selected: "..obj.Name
                print("Selected:",obj:GetFullName())
            end
        )
        table.insert(baseButtons,b)
    end

    if #candidates==0 then
        local b=button(build,"No candidate bases found",function()
            scanBases()
        end)
        table.insert(baseButtons,b)
    end
end

button(build,"SCAN BASES",scanBases)

button(build,"SHOW SELECTED BASE INFO",function()
    if not selectedBase or not selectedBase.Parent then
        warn("Select a base first")
        return
    end

    local parts=0
    for _,obj in ipairs(selectedBase:GetDescendants()) do
        if obj:IsA("BasePart") then parts+=1 end
    end

    print("BASE:",selectedBase:GetFullName())
    print("PART COUNT:",parts)
end)

button(build,"LOCAL COPY PREVIEW",function()
    if not selectedBase or not selectedBase.Parent then
        warn("Select a base first")
        return
    end

    clearPreview()

    local ok,clone=pcall(function()
        return selectedBase:Clone()
    end)

    if not ok or not clone then
        warn("Could not clone selected model")
        return
    end

    clone.Name="DIAMOND_LOCAL_PREVIEW"
    clone.Parent=Workspace

    local _,_,root=getCharacter()
    if root then
        local pivot
        if clone:IsA("Model") then
            pivot=clone:GetPivot()
            clone:PivotTo(root.CFrame*CFrame.new(0,0,-35))
        else
            clone:Destroy()
            warn("Select a Model, not a Folder")
            return
        end

        for _,obj in ipairs(clone:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Anchored=true
                obj.CanCollide=false
                obj.Transparency=math.max(obj.Transparency,0.35)
            end
        end
    end

    previewModel=clone
    print("Local preview created. This is not a server build.")
end)

button(build,"REMOVE LOCAL PREVIEW",clearPreview)

button(build,"CLEAR BASE SELECTION",function()
    selectedBase=nil
    selectedLabel.Text="Selected base: none"
    clearPreview()
end)

button(build,"SCAN BUILD REMOTES",function()
    local count=0
    for _,root in ipairs({
        ReplicatedStorage,
        game:GetService("ReplicatedFirst")
    }) do
        for _,obj in ipairs(root:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local n=obj.Name:lower()
                if n:find("build") or n:find("place")
                or n:find("block") or n:find("boat")
                or n:find("plot") then
                    print("[BUILD REMOTE]",obj:GetFullName(),obj.ClassName)
                    count+=1
                end
            end
        end
    end
    print("Remote matches:",count)
end)

-- AUTO FARM

label(farm,"Stage and treasure scanner")
label(farm,"Find stage, finish and chest candidates")

local farmMatches={}

button(farm,"SCAN STAGES AND CHESTS",function()
    table.clear(farmMatches)

    for _,obj in ipairs(Workspace:GetDescendants()) do
        local n=obj.Name:lower()

        if n:find("stage") or n:find("chest")
        or n:find("treasure") or n:find("finish")
        or n:find("gold") then
            table.insert(farmMatches,obj)
            print("[FARM SCAN]",obj:GetFullName(),obj.ClassName)
        end
    end

    print("Farm candidates:",#farmMatches)
end)

button(farm,"LIST FARM CANDIDATES",function()
    for i,obj in ipairs(farmMatches) do
        if obj and obj.Parent then
            print(i,obj:GetFullName(),obj.ClassName)
        end
    end
end)

button(farm,"CLEAR FARM SCAN",function()
    table.clear(farmMatches)
    print("Farm scan cleared")
end)

-- TOOLS

label(tools,"Game diagnostics")

button(tools,"Scan Workspace roots",function()
    for _,obj in ipairs(Workspace:GetChildren()) do
        print("[ROOT]",obj.Name,obj.ClassName)
    end
end)

button(tools,"Scan ReplicatedStorage remotes",function()
    local count=0
    for _,obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            print("[REMOTE]",obj:GetFullName(),obj.ClassName)
            count+=1
        end
    end
    print("Total remotes:",count)
end)

button(tools,"Scan player attributes",function()
    for k,v in pairs(Player:GetAttributes()) do
        print("[PLAYER ATTRIBUTE]",k,v)
    end
end)

button(tools,"Print current position",function()
    local _,_,root=getCharacter()
    if root then print("POSITION:",root.Position) end
end)

button(tools,"Print game information",function()
    print("PlaceId:",game.PlaceId)
    print("JobId:",game.JobId)
    print("Player:",Player.Name)
end)

-- SETTINGS

label(settings,"Hub settings")

button(settings,"Reset character",function()
    local _,hum=getCharacter()
    if hum then hum.Health=0 end
end)

button(settings,"Destroy local preview",clearPreview)

button(settings,"Restore lighting",function()
    for k,v in pairs(oldLighting) do
        Lighting[k]=v
    end
end)

button(settings,"Restore camera FOV",function()
    Camera.FieldOfView=originalFov
end)

-- DRAG

local dragging=false
local dragStart
local startPosition

Top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPosition=Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch
    ) then
        local delta=input.Position-dragStart
        Main.Position=UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset+delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

-- MINIMIZE / REOPEN

local minimized=false

local reopen=create("TextButton",{
    Size=UDim2.fromOffset(55,55),
    Position=UDim2.new(0,15,.5,-25),
    BackgroundColor3=PURPLE,
    Text="💎",
    TextSize=23,
    TextColor3=WHITE,
    Visible=false
},GUI)
round(reopen,50)

Min.Activated:Connect(function()
    minimized=not minimized
    Sidebar.Visible=not minimized
    Content.Visible=not minimized
    Main.Size=minimized and UDim2.fromOffset(680,48)
        or UDim2.fromOffset(680,470)
    Min.Text=minimized and "+" or "—"
end)

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
    updateSpeed()
    updateJump()
    if flyOn then stopFly() end
end)

showPage("HOME")
print("DIAMOND BOAT HUB V2 LOADED")
