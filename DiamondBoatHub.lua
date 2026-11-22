
--==================================================
-- DIAMOND BOAT HUB V1 [BETA] V24
-- Build A Boat For Treasure
-- Desktop + Mobile
--==================================================

repeat task.wait() until game:IsLoaded()

Players = game:GetService("Players")
UIS = game:GetService("UserInputService")
VirtualUser = game:GetService("VirtualUser")
RunService = game:GetService("RunService")
Lighting = game:GetService("Lighting")
Workspace = game:GetService("Workspace")
ReplicatedStorage = game:GetService("ReplicatedStorage")
TweenService = game:GetService("TweenService")
TeleportService = game:GetService("TeleportService")

Player = Players.LocalPlayer
Camera = Workspace.CurrentCamera

function getParent()
    if gethui then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    return Player:WaitForChild("PlayerGui")
end

Parent = getParent()
previous = Parent:FindFirstChild("DiamondBoatHub")
if previous then previous:Destroy() end

GUI = Instance.new("ScreenGui")
GUI.Name = "DiamondBoatHub"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = Parent

PURPLE = Color3.fromRGB(150,150,150)
DARK = Color3.fromRGB(0,0,0)
PANEL = Color3.fromRGB(0,0,0)
WHITE = Color3.fromRGB(255,255,255)
BUTTON_WHITE = Color3.fromRGB(255,255,255)
BUTTON_HOVER = Color3.fromRGB(190,190,190)
TEXT_DARK = Color3.fromRGB(20,20,20)
GREEN = Color3.fromRGB(60,180,120)

function create(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

function round(obj, radius)
    create("UICorner", {
        CornerRadius=UDim.new(0,radius or 8)
    },obj)
end

function outline(obj)
    return create("UIStroke",{Color=Color3.fromRGB(95,78,145),Thickness=1,Transparency=0.35},obj)
end

Main = create("Frame",{
    Visible=false,
    Size=UDim2.fromOffset(680,470),
    Position=UDim2.new(.5,-340,.5,-235),
    BackgroundColor3=DARK,
    BorderSizePixel=0
},GUI)
round(Main,16)
mainStroke=outline(Main)
mainStroke.Thickness=1.4
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(0,0,0),Color3.fromRGB(8,8,8)),Rotation=90},Main)
MainScale=create("UIScale",{Scale=1},Main)
isTouchDevice=UIS.TouchEnabled
deviceMode=isTouchDevice and "phone" or "pc"
windowMode="medium"
desktopSizes={small=Vector2.new(560,390),medium=Vector2.new(680,470),large=Vector2.new(800,560)}
function fitToScreen()
    local cam=Workspace.CurrentCamera
    if not cam then return end
    local viewport=cam.ViewportSize
    MainScale.Scale=1
    if deviceMode=="phone" then
        -- Fit the hub to the actual phone viewport without forcing oversized minimums.
        local w=math.clamp(math.floor(viewport.X-16),220,680)
        local h=math.clamp(math.floor(viewport.Y-32),280,720)
        Main.Size=UDim2.fromOffset(w,h)
    elseif windowMode=="fullscreen" then
        Main.Size=UDim2.new(1,0,1,0)
    elseif viewport.X<620 then
        local w=math.clamp(math.floor(viewport.X*0.92),300,900)
        local h=math.clamp(math.floor(viewport.Y*0.86),360,1000)
        Main.Size=UDim2.fromOffset(w,h)
    else
        local size=desktopSizes[windowMode] or desktopSizes.medium
        Main.Size=UDim2.fromOffset(size.X,size.Y)
    end
    Main.Position=UDim2.new(0.5,-Main.Size.X.Offset/2,0.5,-Main.Size.Y.Offset/2)
    Main.ClipsDescendants=true
end
fitToScreen()
if Workspace.CurrentCamera then Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitToScreen) end

Top = create("Frame",{
    Size=UDim2.new(1,0,0,48),
    BackgroundColor3=Color3.fromRGB(0,0,0),
    BorderSizePixel=0
},Main)
round(Top,15)
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(12,12,12),Color3.fromRGB(0,0,0)),Rotation=0},Top)

DragHandle=create("TextButton",{
    Name="DragHandle",Size=UDim2.new(1,-100,1,0),Position=UDim2.fromOffset(0,0),
    BackgroundTransparency=1,Text="",AutoButtonColor=false,Active=true,ZIndex=2
},Top)
TitleLabel=create("TextLabel",{
    Size=UDim2.new(1,-150,1,0),
    Position=UDim2.fromOffset(15,0),
    BackgroundTransparency=1,
    Text="💎  DIAMOND BOAT HUB V1 [BETA]",
    TextColor3=WHITE,
    TextSize=18,
    Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,
    Active=false,ZIndex=3
},Top)

Min = create("TextButton",{
    Size=UDim2.fromOffset(30,28),
    AnchorPoint=Vector2.new(1,0),
    Position=UDim2.new(1,-46,0,10),
    BackgroundColor3=BUTTON_WHITE,
    Text="—",
    TextColor3=WHITE,
    TextSize=18
},Top)
round(Min,8)
outline(Min)
Min.Font=Enum.Font.GothamBold
Min.BackgroundColor3=BUTTON_WHITE
Min.TextColor3=TEXT_DARK
Min.AutoButtonColor=false

Close = create("TextButton",{
    Size=UDim2.fromOffset(30,28),
    AnchorPoint=Vector2.new(1,0),
    Position=UDim2.new(1,-10,0,10),
    BackgroundColor3=BUTTON_WHITE,
    Text="X",
    TextColor3=WHITE,
    TextSize=15
},Top)
round(Close,8)
outline(Close)
Close.TextColor3=TEXT_DARK
Close.Font=Enum.Font.GothamBold
Close.AutoButtonColor=false

Sidebar = create("ScrollingFrame",{
    Size=UDim2.new(1,-14,0,66),
    Position=UDim2.fromOffset(7,53),
    BackgroundColor3=Color3.fromRGB(0,0,0),
    BorderSizePixel=0,
    ScrollingDirection=Enum.ScrollingDirection.X,
    ScrollBarThickness=2,
    CanvasSize=UDim2.new(0,0,0,0),
    ClipsDescendants=true
},Main)
round(Sidebar,10)
outline(Sidebar)
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(0,0,0),Color3.fromRGB(5,5,5)),Rotation=90},Sidebar)

Content = create("Frame",{
    Size=UDim2.new(1,-14,1,-136),
    Position=UDim2.fromOffset(7,129),
    BackgroundColor3=PANEL,
    BorderSizePixel=0
},Main)
round(Content,12)
outline(Content)
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(0,0,0),Color3.fromRGB(5,5,5)),Rotation=90},Content)

Pages = {}
CurrentPage = nil
buttonStyle="Modern"
animatedBackground=true
playerPrefix="Player"
prefixColor=Color3.fromRGB(185,205,255)
backgroundGradient = nil
credits = nil

function makePage(name)
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

credits=makePage("CREDITS")

TabButtons={}
function showPage(name)
    for n,p in pairs(Pages) do p.Visible=(n==name) end
    for n,b in pairs(TabButtons) do
        local active=(n==name)
        b.BackgroundColor3=active and BUTTON_HOVER or BUTTON_WHITE
        b.TextColor3=TEXT_DARK
        local mark=b:FindFirstChild("ActiveMark")
        if mark then mark.Visible=active end
        local stroke=b:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Transparency=active and 0.08 or 0.35 end
    end
    CurrentPage=name
end

function label(page,text)
    return create("TextLabel",{
        Size=UDim2.new(1,-8,0,30),
        BackgroundTransparency=1,
        Text=text,
        TextColor3=Color3.fromRGB(235,235,235),
        TextSize=14,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left
    },page)
end

function button(page,text,callback)
    local b=create("TextButton",{
        Size=UDim2.new(1,-8,0,42),BackgroundColor3=Color3.fromRGB(24,24,31),
        Text="   "..text,TextColor3=Color3.fromRGB(242,242,248),TextSize=13,Font=Enum.Font.GothamSemibold,
        TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,BorderSizePixel=0
    },page)
    b:SetAttribute("HubStyledButton",true)
    round(b,11)
    local stroke=outline(b)
    stroke.Color=Color3.fromRGB(75,75,94)
    stroke.Transparency=0.55
    local accent=create("Frame",{Size=UDim2.new(0,3,1,-14),Position=UDim2.fromOffset(0,7),BackgroundColor3=PURPLE,BorderSizePixel=0},b)
    round(accent,3)
    if buttonStyle=="Liquid Glass" then
        b.BackgroundColor3=Color3.fromRGB(75,82,100)
        b.BackgroundTransparency=0.38
        stroke.Color=Color3.fromRGB(210,225,255)
        stroke.Transparency=0.22
        create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(220,235,255),Color3.fromRGB(85,100,135)),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.22),NumberSequenceKeypoint.new(1,0.62)}),Rotation=90},b)
    elseif buttonStyle=="Neon" then
        b.BackgroundColor3=Color3.fromRGB(15,18,28)
        stroke.Color=PURPLE
        stroke.Transparency=0.05
        stroke.Thickness=1.5
    end
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.13),{BackgroundColor3=Color3.fromRGB(39,39,51)}):Play()
        TweenService:Create(stroke,TweenInfo.new(0.13),{Transparency=0.12}):Play()
        TweenService:Create(accent,TweenInfo.new(0.13),{Size=UDim2.new(0,4,1,-8),Position=UDim2.fromOffset(0,4)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.13),{BackgroundColor3=Color3.fromRGB(24,24,31)}):Play()
        TweenService:Create(stroke,TweenInfo.new(0.13),{Transparency=0.55}):Play()
        TweenService:Create(accent,TweenInfo.new(0.13),{Size=UDim2.new(0,3,1,-14),Position=UDim2.fromOffset(0,7)}):Play()
    end)
    b.Activated:Connect(callback)
    return b
end

function setButtonStyle(style)
    if style~="Modern" and style~="Liquid Glass" and style~="Neon" then return end
    buttonStyle=style
    for _,obj in ipairs(GUI:GetDescendants()) do
        if obj:IsA("TextButton") and obj:GetAttribute("HubStyledButton") then
            local stroke=obj:FindFirstChildOfClass("UIStroke")
            local grad=obj:FindFirstChildOfClass("UIGradient")
            if grad then grad:Destroy() end
            obj.BackgroundTransparency=0
            if style=="Liquid Glass" then
                obj.BackgroundColor3=Color3.fromRGB(75,82,100)
                obj.BackgroundTransparency=0.34
                if stroke then stroke.Color=Color3.fromRGB(210,225,255); stroke.Transparency=0.18 end
                create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(220,235,255),Color3.fromRGB(75,90,125)),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,0.58)}),Rotation=90},obj)
            elseif style=="Neon" then
                obj.BackgroundColor3=Color3.fromRGB(15,18,28)
                if stroke then stroke.Color=PURPLE; stroke.Transparency=0.02; stroke.Thickness=1.5 end
            else
                obj.BackgroundColor3=Color3.fromRGB(24,24,31)
                if stroke then stroke.Color=Color3.fromRGB(75,75,94); stroke.Transparency=0.55; stroke.Thickness=1 end
            end
        end
    end
end

function toggle(page,text,default,callback)
    local state=default or false
    local b
    b=button(page,text..": "..(state and "ON" or "OFF"),function()
        state=not state
        b.Text=text..": "..(state and "ON" or "OFF")
        b.BackgroundColor3=state and BUTTON_HOVER or BUTTON_WHITE
        callback(state)
    end)
    return b
end

function getCharacter()
    local char=Player.Character
    if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local root=char:FindFirstChild("HumanoidRootPart")
    return char,hum,root
end

-- PAGES

home=makePage("HOME")
movement=makePage("MOVEMENT")
visuals=makePage("VISUALS")
teleport=makePage("TELEPORTS")
build=makePage("AUTO BUILD")
music=makePage("MUSIC")
farm=makePage("AUTO FARM")
shop=makePage("SHOP")
tools=makePage("TOOLS")
settings=makePage("SETTINGS")

tabLayout=create("UIListLayout",{
    FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder,
    VerticalAlignment=Enum.VerticalAlignment.Center
},Sidebar)
create("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,3),PaddingBottom=UDim.new(0,3)},Sidebar)
tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Sidebar.CanvasSize=UDim2.new(0,tabLayout.AbsoluteContentSize.X+16,0,0)
end)

tabIcons={
    HOME="rbxassetid://10723407389",
    MOVEMENT="rbxassetid://10734906744",
    VISUALS="rbxassetid://10723346959",
    TELEPORTS="rbxassetid://10734886004",
    ["AUTO BUILD"]="rbxassetid://10723405360",
    MUSIC="rbxassetid://10734905958",
    ["AUTO FARM"]="rbxassetid://10723395708",
    SHOP="rbxassetid://10734952479",
    TOOLS="rbxassetid://10723405749",
    SETTINGS="rbxassetid://10734950309",
    CREDITS="rbxassetid://10709819149"
}
for _,name in ipairs({
    "HOME","MOVEMENT","VISUALS","TELEPORTS",
    "AUTO BUILD","MUSIC","AUTO FARM","SHOP","TOOLS","SETTINGS","CREDITS"
}) do
    local b=create("TextButton",{
        Size=UDim2.new(0,58,0,56),
        ClipsDescendants=true,
        BackgroundColor3=BUTTON_WHITE,
        Text=({HOME="HOME",MOVEMENT="MOVE",VISUALS="VISUAL",TELEPORTS="TELEPORT",["AUTO BUILD"]="BUILD",MUSIC="MUSIC",["AUTO FARM"]="FARM",SHOP="SHOP",TOOLS="TOOLS",SETTINGS="SET",CREDITS="CREDITS"})[name] or name,
        TextColor3=TEXT_DARK,
        TextSize=9,
        TextTruncate=Enum.TextTruncate.AtEnd,
        TextWrapped=true,
        Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Center,
        TextYAlignment=Enum.TextYAlignment.Top,
        AutoButtonColor=false
    },Sidebar)
    round(b,8)
    local tabIcon=Instance.new("ImageLabel")
    tabIcon.Name="TabIcon"; tabIcon.BackgroundTransparency=1
    tabIcon.AnchorPoint=Vector2.new(0.5,0)
    tabIcon.Size=UDim2.fromOffset(19,19)
    tabIcon.Position=UDim2.new(0.5,0,0,30)
    tabIcon.Image=tabIcons[name] or ""; tabIcon.ImageColor3=TEXT_DARK
    tabIcon.ScaleType=Enum.ScaleType.Fit
    tabIcon.Parent=b
    b.TextXAlignment=Enum.TextXAlignment.Center
    b.TextYAlignment=Enum.TextYAlignment.Top
    local tabStroke=outline(b)
    tabStroke.Color=Color3.fromRGB(90,90,90)
    tabStroke.Transparency=0.35
    create("UIPadding",{PaddingTop=UDim.new(0,7),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2)},b)
    local mark=create("Frame",{Name="ActiveMark",Size=UDim2.new(1,-14,0,2),Position=UDim2.new(0,7,1,-3),BackgroundColor3=PURPLE,BorderSizePixel=0,Visible=false},b)
    round(mark,2)
    TabButtons[name]=b
    b.MouseEnter:Connect(function()
        if CurrentPage~=name then TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(215,213,226)}):Play() end
    end)
    b.MouseLeave:Connect(function()
        if CurrentPage~=name then TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=BUTTON_WHITE}):Play() end
    end)
    b.Activated:Connect(function() showPage(name) end)
end

-- HOME

label(home,"Welcome to Diamond Boat Hub")
label(home,"Build A Boat For Treasure")
rejoinBusy=false
button(home,"⚡ INSTANT REJOIN",function()
    if rejoinBusy then return end
    rejoinBusy=true
    print("[DIAMOND] Rejoining current server...")
    local ok,err=pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,Player)
    end)
    if not ok then
        warn("[DIAMOND] Same-server rejoin failed:",err,"Trying a fresh server...")
        local fallbackOk,fallbackErr=pcall(function()
            TeleportService:Teleport(game.PlaceId,Player)
        end)
        if not fallbackOk then
            rejoinBusy=false
            warn("[DIAMOND] Rejoin failed:",fallbackErr)
        end
    end
end)

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

speedOn=false
jumpOn=false
infiniteJump=false
noclipOn=false
noclipConnection = nil
noclipOriginal={}
configuredSpeed=45
configuredJump=100
flyOn=false
flyConnection = nil
flyVelocity = nil
flyGyro = nil

function updateSpeed()
    local _,hum=getCharacter()
    if hum then hum.WalkSpeed=speedOn and configuredSpeed or 16 end
end

function updateJump()
    local _,hum=getCharacter()
    if hum then
        hum.UseJumpPower=true
        hum.JumpPower=jumpOn and configuredJump or 50
    end
end

function addNumericSetting(parent,title,default,minValue,maxValue,onValue)
    label(parent,title)
    local box=create("TextBox",{
        Size=UDim2.new(1,-8,0,38),BackgroundColor3=Color3.fromRGB(24,24,31),
        TextColor3=Color3.fromRGB(245,245,250),PlaceholderColor3=Color3.fromRGB(145,145,155),
        PlaceholderText=tostring(default),Text=tostring(default),ClearTextOnFocus=false,
        Font=Enum.Font.GothamSemibold,TextSize=14
    },parent)
    round(box,9); outline(box)
    box.FocusLost:Connect(function()
        local n=tonumber(box.Text)
        if not n then box.Text=tostring(default); return end
        n=math.clamp(n,minValue,maxValue)
        box.Text=tostring(n)
        onValue(n)
    end)
    return box
end

addNumericSetting(movement,"WALK SPEED (16–250)",configuredSpeed,16,250,function(v)
    configuredSpeed=v; if speedOn then updateSpeed() end
end)
addNumericSetting(movement,"JUMP POWER (50–300)",configuredJump,50,300,function(v)
    configuredJump=v; if jumpOn then updateJump() end
end)

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

toggle(movement,"Noclip",false,function(v)
    noclipOn=v
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection=nil end
    if not v then
        for part,old in pairs(noclipOriginal) do
            if part and part.Parent then part.CanCollide=old end
        end
        table.clear(noclipOriginal)
        return
    end
    noclipConnection=RunService.Stepped:Connect(function()
        local char=Player.Character
        if not char then return end
        for _,part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if noclipOriginal[part]==nil then noclipOriginal[part]=part.CanCollide end
                part.CanCollide=false
            end
        end
    end)
end)

UIS.JumpRequest:Connect(function()
    if infiniteJump then
        local _,hum=getCharacter()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

function stopFly()
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

antiAfkConnection = nil
toggle(visuals,"Anti-AFK",false,function(enabled)
    if antiAfkConnection then antiAfkConnection:Disconnect(); antiAfkConnection=nil end
    if enabled then
        antiAfkConnection=Player.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
    end
end)

savedEffects={}
lowGraphicsOn=false
toggle(visuals,"Low graphics / FPS boost",false,function(enabled)
    if enabled and not lowGraphicsOn then
        lowGraphicsOn=true
        savedEffects={}
        for _,effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                savedEffects[effect]={Enabled=effect.Enabled}
                effect.Enabled=false
            end
        end
        Lighting.GlobalShadows=false
        pcall(function() Workspace.Terrain.Decoration=false end)
        for _,obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                savedEffects[obj]={Enabled=obj.Enabled}
                obj.Enabled=false
            end
        end
    elseif not enabled and lowGraphicsOn then
        lowGraphicsOn=false
        for obj,props in pairs(savedEffects) do
            if obj and obj.Parent then pcall(function() obj.Enabled=props.Enabled end) end
        end
        savedEffects={}
        pcall(function() Workspace.Terrain.Decoration=true end)
        Lighting.GlobalShadows=oldLighting.GlobalShadows
    end
end)

originalFov=Camera.FieldOfView
toggle(visuals,"Wide FOV",false,function(v)
    Camera.FieldOfView=v and 100 or originalFov
end)

oldLighting={
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

savedPosition = nil

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
    if root then root.CFrame=root.CFrame-Vector3.new(0,20,0) end
end)

button(teleport,"Teleport to nearest spawn",function()
    local _,_,root=getCharacter()
    if not root then return end
    local nearest,dist=nil,math.huge
    for _,obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then
            local d=(obj.Position-root.Position).Magnitude
            if d<dist then nearest,dist=obj,d end
        end
    end
    if nearest then root.CFrame=nearest.CFrame*CFrame.new(0,4,0) else warn("[DIAMOND] No SpawnLocation found") end
end)

button(teleport,"Copy coordinates",function()
    local _,_,root=getCharacter()
    if root then
        local p=root.Position
        local value=string.format("Vector3.new(%.2f, %.2f, %.2f)",p.X,p.Y,p.Z)
        if setclipboard then pcall(setclipboard,value) end
        print("[DIAMOND] Coordinates:",value)
    end
end)

button(teleport,"Stop current movement",function()
    local _,_,root=getCharacter()
    if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
end)

-- AUTO BUILD

label(build,"Base scanner")
label(build,"Select a candidate and inspect it. Preview is local only.")

selectedBase=nil
baseButtons={}
previewModel=nil

selectedLabel=label(build,"Selected base: none")

function clearPreview()
    if previewModel then
        previewModel:Destroy()
        previewModel=nil
    end
end

function clearBaseButtons()
    for _,b in ipairs(baseButtons) do
        if b and b.Parent then b:Destroy() end
    end
    table.clear(baseButtons)
end

function scanBases()
    clearBaseButtons()
    clearPreview()
    selectedBase=nil
    selectedLabel.Text="Selected base: none"

    local blocksFolder=Workspace:FindFirstChild("Blocks")
    local candidates={}
    if blocksFolder then
        for _,folder in ipairs(blocksFolder:GetChildren()) do
            if folder:IsA("Folder") and folder.Name~=Player.Name then
                local owner=Players:FindFirstChild(folder.Name)
                local count=0
                for _,block in ipairs(folder:GetChildren()) do
                    if block:IsA("Model") and block:FindFirstChild("PPart") then
                        count+=1
                    end
                end
                if owner and count>0 then
                    table.insert(candidates,{object=folder,parts=count,owner=owner})
                end
            end
        end
    end

    if #candidates==0 then
        warn("Workspace.Blocks player folders not found. Check game version and join a server with visible player builds.")
    end

    table.sort(candidates,function(a,b) return a.parts>b.parts end)
    print("DIAMOND PLAYER BASE SCAN:",#candidates)

    for i,item in ipairs(candidates) do
        local b=button(build,
            i..". "..item.owner.DisplayName.." (@"..item.owner.Name..") ["..item.parts.." blocks]",
            function()
                selectedBase=item.object
                selectedLabel.Text="Selected: "..item.owner.Name.." ["..item.parts.."]"
                print("Selected player build:",selectedBase:GetFullName())
            end
        )
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

button(build,"AUTO BUILD PREVIEW ON MY PLOT",function()
    if not selectedBase or not selectedBase.Parent then
        warn("Select a base first")
        return
    end
    local sourcePlayer=Players:FindFirstChild(selectedBase.Name)
    local sourceZone=getPlayerZone(sourcePlayer)
    local targetZone=getPlayerZone(Player)
    if not sourceZone or not targetZone then
        warn("Could not locate source/your plot")
        return
    end
    clearPreview()
    local ok,clone=pcall(function() return selectedBase:Clone() end)
    if not ok or not clone or not clone:IsA("Model") then
        if clone then clone:Destroy() end
        warn("Preview clone failed")
        return
    end
    local sourcePivot=clone:GetPivot()
    local targetPivot=targetZone.CFrame*sourceZone.CFrame:ToObjectSpace(sourcePivot)
    clone.Name="DIAMOND_AUTO_BUILD_GHOST"
    clone.Parent=Workspace
    clone:PivotTo(targetPivot)
    for _,obj in ipairs(clone:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Anchored=true
            obj.CanCollide=false
            obj.CanTouch=false
            obj.CanQuery=false
            obj.Transparency=math.max(obj.Transparency,0.58)
        end
    end
    previewModel=clone
    buildProgressLabel.Text="Auto Build preview: ghost only"
    print("[DIAMOND AUTO BUILD] Plot preview displayed locally; no server blocks placed.")
end)

button(build,"REMOVE LOCAL PREVIEW",clearPreview)

-- REAL AUTO BUILD V4
buildRunning=false
buildProgressLabel=label(build,"Auto Build: idle")

function getPlayerZone(plr)
    if not plr then return nil end
    for _,obj in ipairs(Workspace:GetChildren()) do
        local teamColor=obj:FindFirstChild("TeamColor")
        if teamColor and teamColor.Value==plr.TeamColor then
            return obj
        end
    end
    return nil
end

function getBuildTool()
    local char,hum=getCharacter()
    if not char or not hum then return nil end
    local tool=char:FindFirstChild("BuildingTool")
    if not tool then
        local backpack=Player:FindFirstChildOfClass("Backpack")
        local stored=backpack and backpack:FindFirstChild("BuildingTool")
        if not stored then
            warn("BuildingTool not found in Character or Backpack")
            return nil
        end
        hum:EquipTool(stored)
        task.wait(0.25)
        tool=char:FindFirstChild("BuildingTool")
    end
    if not tool then return nil end
    local remote=tool:FindFirstChild("RF")
    if not remote or not remote:IsA("RemoteFunction") then
        warn("BuildingTool.RF RemoteFunction not found")
        return nil
    end
    return remote
end

-- Inventory counts and block template IDs are separate in BABFT.
-- Data values are quantities; BuildingParts order supplies the placement ID.
function findPlayerDataValue(blockName)
    local data=Player:FindFirstChild("Data")
    if not data then return nil end
    local direct=data:FindFirstChild(blockName)
    if direct and direct:IsA("ValueBase") then return direct end
    local wanted=string.lower(blockName)
    for _,obj in ipairs(data:GetDescendants()) do
        if obj:IsA("ValueBase") and string.lower(obj.Name)==wanted then return obj end
    end
    return nil
end
function getInventoryCount(blockName)
    local value=findPlayerDataValue(blockName)
    if not value then return 0 end
    local n=tonumber(value.Value)
    return n and math.max(0,n) or 0
end
function getBlockTypeId(blockName)
    -- BABFT block IDs are stored as numeric values, not the child index
    -- of ReplicatedStorage.BuildingParts (GetChildren order is not an ID).
    local containers={
        ReplicatedStorage:FindFirstChild("BlockData"),
        ReplicatedStorage:FindFirstChild("BlockIds"),
        ReplicatedStorage:FindFirstChild("BuildingParts")
    }
    for _,container in ipairs(containers) do
        if container then
            local value=container:FindFirstChild(blockName,true)
            if value and value:IsA("ValueBase") then
                local id=tonumber(value.Value)
                if id then return id end
            end
            local template=container:FindFirstChild(blockName)
            if template then
                local attribute=tonumber(template:GetAttribute("ID") or template:GetAttribute("Id") or template:GetAttribute("BlockId"))
                if attribute then return attribute end
                for _,child in ipairs(template:GetChildren()) do
                    if child:IsA("ValueBase") and (child.Name=="ID" or child.Name=="Id" or child.Name=="BlockId") then
                        local id=tonumber(child.Value)
                        if id then return id end
                    end
                end
            end
        end
    end
    if blockName=="WoodBlock" then return 9 end
    return nil
end

function getNewBlockCFrame(sourceBlock,sourceZone,targetZone)
    local part=sourceBlock:FindFirstChild("PPart")
    if not part or not sourceZone or not targetZone then return nil end
    local offset=sourceZone.CFrame:ToObjectSpace(part.CFrame)
    return targetZone.CFrame*offset
end

button(build,"COPY SELECTED PLAYER BASE",function()
    if not selectedBase or not selectedBase.Parent then
        warn("Сначала нажми SCAN BASES и выбери игрока")
        return
    end
    local count=0
    for _,block in ipairs(selectedBase:GetChildren()) do
        if block:IsA("Model") and block:FindFirstChild("PPart") then count+=1 end
    end
    print("Selected build:",selectedBase.Name,"blocks:",count)
    buildProgressLabel.Text="Auto Build: selected "..count.." blocks"
end)

button(build,"AUTO BUILD TO MY BASE",function()
    if buildRunning then
        warn("Auto Build уже выполняется")
        return
    end
    if not selectedBase or not selectedBase.Parent then
        warn("Сначала выбери базу игрока")
        return
    end

    local blocksFolder=Workspace:FindFirstChild("Blocks")
    local myBlocks=blocksFolder and blocksFolder:FindFirstChild(Player.Name)
    local sourcePlayer=Players:FindFirstChild(selectedBase.Name)
    local sourceZone=getPlayerZone(sourcePlayer)
    local targetZone=getPlayerZone(Player)
    if not myBlocks then
        warn("Не найдена твоя папка Workspace.Blocks."..Player.Name)
        return
    end
    if not sourcePlayer or not sourceZone or not targetZone then
        warn("Не удалось определить участок исходного игрока или твою базу по TeamColor")
        return
    end

    local buildRF=getBuildTool()
    if not buildRF then return end

    local function equipScalingTool()
        local char,hum=getCharacter()
        if not char or not hum then return nil end
        local tool=char:FindFirstChild("ScalingTool")
        if tool then return tool end
        local backpack=Player:FindFirstChildOfClass("Backpack")
        local stored=backpack and backpack:FindFirstChild("ScalingTool")
        if not stored then
            warn("ScalingTool не найден в инвентаре")
            return nil
        end
        hum:EquipTool(stored)
        for _=1,30 do
            task.wait(0.1)
            tool=char:FindFirstChild("ScalingTool")
            if tool then return tool end
        end
        return nil
    end

    local function findJustPlacedBlock(beforeSet, expectedName, expectedCFrame)
        local best,bestDist=nil,math.huge
        for _,candidate in ipairs(myBlocks:GetChildren()) do
            if candidate:IsA("Model") and candidate.Name==expectedName
                and candidate:FindFirstChild("PPart") and not beforeSet[candidate] then
                local dist=(candidate.PPart.Position-expectedCFrame.Position).Magnitude
                if dist<bestDist then best,bestDist=candidate,dist end
            end
        end
        return best,bestDist
    end

    local snapshot={}
    for _,block in ipairs(selectedBase:GetChildren()) do
        if block:IsA("Model") and block:FindFirstChild("PPart") then
            local pos=getNewBlockCFrame(block,sourceZone,targetZone)
            local blockId=getBlockTypeId(block.Name)
            if pos and blockId~=nil then
                table.insert(snapshot,{
                    name=block.Name,
                    id=blockId,
                    cframe=pos,
                    anchored=block.PPart.Anchored,
                    size=block.PPart.Size,
                    color=block.PPart.Color,
                    transparency=block.PPart.Transparency
                })
            else
                warn("Пропуск блока (нет ID или PPart):",block.Name)
            end
        end
    end

    if #snapshot==0 then
        warn("Не найдено блоков для копирования")
        return
    end

    -- Preflight by exact block type; report missing stock instead of silently skipping.
    local requiredByName={}
    for _,item in ipairs(snapshot) do
        requiredByName[item.name]=(requiredByName[item.name] or 0)+1
    end
    local missing={}
    for name,needed in pairs(requiredByName) do
        local have=getInventoryCount(name)
        if have<needed then
            missing[#missing+1]=string.format("%s: need %d / have %d",name,needed,have)
        end
    end
    if #missing>0 then
        table.sort(missing)
        buildProgressLabel.Text="Auto Build: missing inventory ("..#missing.." types)"
        warn("[DIAMOND AUTO BUILD] Inventory check failed:\n"..table.concat(missing,"\n"))
        return
    end

    buildRunning=true
    task.spawn(function()
        local placed=0
        local failed=0
        -- Cache the remote once; InvokeServer itself waits for the server response.
        local currentBuildRF=buildRF
        local scalingRF=nil
        local char=Player.Character
        local backpack=Player:FindFirstChildOfClass("Backpack")
        local scalingTool=(char and char:FindFirstChild("ScalingTool")) or (backpack and backpack:FindFirstChild("ScalingTool"))
        if scalingTool then
            local candidate=scalingTool:FindFirstChild("RF")
            if candidate and candidate:IsA("RemoteFunction") then scalingRF=candidate end
        end
        for i,item in ipairs(snapshot) do
            if not buildRunning then break end
            if not currentBuildRF or not currentBuildRF.Parent then
                failed+=1
                warn("BuildingTool недоступен для блока",i)
                break
            end
            local beforeSet={}
            for _,existing in ipairs(myBlocks:GetChildren()) do beforeSet[existing]=true end
            local localCF=targetZone.CFrame:ToObjectSpace(item.cframe)
            local args={item.name,item.id,targetZone,localCF,true,item.cframe,false}
            local ok,result=pcall(function()
                return currentBuildRF:InvokeServer(unpack(args))
            end)
            if not ok then
                failed+=1
                warn("Ошибка размещения блока",i,item.name,result)
            else
                local placedBlock=nil
                for attempt=1,10 do
                    placedBlock=findJustPlacedBlock(beforeSet,item.name,item.cframe)
                    if placedBlock then break end
                    task.wait(0.035)
                end
                if placedBlock and item.size then
                    if scalingRF and scalingRF.Parent then
                        local scaleOK,scaleResult=pcall(function()
                            return scalingRF:InvokeServer(placedBlock,item.size,item.cframe)
                        end)
                        if scaleOK then placed+=1 else
                            failed+=1
                            warn("Блок поставлен, но масштабирование не прошло:",item.name,scaleResult)
                        end
                    else
                        failed+=1
                        warn("ScalingTool.RF не найден. Блок поставлен без растяжения:",item.name)
                    end
                elseif placedBlock then
                    placed+=1
                else
                    failed+=1
                    warn("Новый блок не найден после размещения:",item.name)
                end
            end
            buildProgressLabel.Text="Auto Build: "..i.."/"..#snapshot.." | errors: "..failed
            if i%25==0 then task.wait() end
        end
        buildRunning=false
        buildProgressLabel.Text="Auto Build: finished "..placed.."/"..#snapshot
        print("[DIAMOND AUTO BUILD] Finished. Placed requests:",placed,"Errors:",failed)
        print("[DIAMOND AUTO BUILD] Blocks are placed through the game's BuildingTool RemoteFunction; game inventory/limits still apply.")
    end)
end)

button(build,"STOP AUTO BUILD",function()
    buildRunning=false
    buildProgressLabel.Text="Auto Build: stopping..."
end)

-- Procedural shapes and ready-made starter builds.
function getMyBuildContext()
    local zone=getPlayerZone(Player)
    local remote=getBuildTool()
    if not zone or not remote then
        warn("[DIAMOND SHAPES] Не найдена твоя база или BuildingTool")
        return nil
    end
    local blocks=Workspace:FindFirstChild("Blocks")
    local myFolder=blocks and blocks:FindFirstChild(Player.Name)
    if not myFolder then
        warn("[DIAMOND SHAPES] Не найдена твоя папка блоков")
        return nil
    end
    return zone,remote,myFolder
end

function buildWoodPattern(name,offsets)
    if buildRunning then warn("[DIAMOND SHAPES] Сначала останови текущую стройку"); return end
    if #offsets>350 then warn("[DIAMOND SHAPES] Пресет превышает лимит 350 блоков"); return end
    local zone,remote,myFolder=getMyBuildContext()
    if not zone then return end
    local blockId=getBlockTypeId("WoodBlock") or 9
    local blockTemplate=nil
    for _,obj in ipairs(myFolder:GetChildren()) do
        if obj:IsA("Model") and obj.Name=="WoodBlock" and obj:FindFirstChild("PPart") then blockTemplate=obj; break end
    end
    local baseSize=(blockTemplate and blockTemplate.PPart.Size) or Vector3.new(4,1,2)
    local char,hum=getCharacter()
    local backpack=Player:FindFirstChildOfClass("Backpack")
    local scalingTool=(char and char:FindFirstChild("ScalingTool")) or (backpack and backpack:FindFirstChild("ScalingTool"))
    local scalingRF=scalingTool and scalingTool:FindFirstChild("RF")
    local useScaling=scalingRF and scalingRF:IsA("RemoteFunction")
    buildRunning=true
    buildProgressLabel.Text=name..": 0/"..#offsets..(useScaling and " | Scaling ON" or " | block mode")
    task.spawn(function()
        local done,failed=0,0
        for i,entry in ipairs(offsets) do
            if not buildRunning then break end
            local localCF=CFrame.new(entry.x,entry.y,entry.z)*CFrame.Angles(0,entry.yaw or 0,entry.roll or 0)
            local worldCF=zone.CFrame*localCF
            local before={}
            for _,obj in ipairs(myFolder:GetChildren()) do before[obj]=true end
            local ok,err=pcall(function()
                remote:InvokeServer("WoodBlock",blockId,zone,localCF,true,worldCF,false)
            end)
            if ok then
                local newBlock=nil
                for attempt=1,8 do
                    for _,obj in ipairs(myFolder:GetChildren()) do
                        if not before[obj] and obj:IsA("Model") and obj.Name=="WoodBlock" and obj:FindFirstChild("PPart") then newBlock=obj; break end
                    end
                    if newBlock then break end
                    task.wait(0.025)
                end
                if newBlock and useScaling and entry.size then
                    local scaleOK,scaleErr=pcall(function()
                        scalingRF:InvokeServer(newBlock,entry.size,worldCF)
                    end)
                    if scaleOK then done+=1 else failed+=1; warn("[DIAMOND SHAPES] Scaling failed; fallback block:",scaleErr) end
                elseif newBlock then
                    done+=1
                else
                    failed+=1
                end
            else
                failed+=1
                warn("[DIAMOND SHAPES] Placement failed:",i,err)
            end
            buildProgressLabel.Text=name..": "..i.."/"..#offsets.." | errors: "..failed
            if i%15==0 then task.wait() end
        end
        buildRunning=false
        buildProgressLabel.Text=name..": "..done.."/"..#offsets.." | errors: "..failed
        print("[DIAMOND SHAPES]",name,"placed:",done,"errors:",failed,"ScalingTool:",useScaling and "available" or "not found; standard blocks used")
    end)
end

-- Filled disk: rows of adjacent blocks, not just an outline ring.
function makeCircle(radius,step,y)
    local points={}
    for x=-radius,radius,step do
        for z=-radius,radius,step do
            if x*x+z*z<=radius*radius then
                points[#points+1]={x=x,y=y,z=z,size=Vector3.new(step,baseSize and 1 or 1,step)}
            end
        end
    end
    return points
end

-- Dense spherical shell with a smaller grid spacing to avoid visible gaps.
function makeSphere(radius,step)
    local points={}
    for y=-radius,radius,step do
        for x=-radius,radius,step do
            for z=-radius,radius,step do
                local d=x*x+y*y+z*z
                if d<=radius*radius and d>=(radius-step*1.25)^2 then
                    points[#points+1]={x=x,y=y+radius+8,z=z,size=Vector3.new(step,step,step)}
                end
            end
        end
    end
    return points
end

label(build,"SHAPE BUILDER — FILLED")
label(build,"ScalingTool found = stretch blocks. No ScalingTool = dense standard blocks.")
button(build,"FILLED CIRCLE",function() buildWoodPattern("Filled circle",makeCircle(24,4,8)) end)
button(build,"LARGE FILLED CIRCLE",function() buildWoodPattern("Large filled circle",makeCircle(36,4,8)) end)
button(build,"SPHERE — DENSE",function() buildWoodPattern("Dense sphere",makeSphere(16,4)) end)
button(build,"SMALL SPHERE",function() buildWoodPattern("Small sphere",makeSphere(10,4)) end)

label(build,"IMPROVED BUILD PRESETS")
button(build,"PRESET: WIDE PLATFORM",function()
    local p={}
    for x=-6,6 do for z=-5,5 do p[#p+1]={x=x*4,y=8,z=z*4,size=Vector3.new(4,1,4)} end end
    buildWoodPattern("Wide platform",p)
end)
button(build,"PRESET: FORTRESS",function()
    local p={}
    for x=-5,5 do for z=-5,5 do p[#p+1]={x=x*4,y=8,z=z*4} end end
    for y=0,5 do
        for a=0,15 do
            local angle=math.pi*2*a/16
            p[#p+1]={x=math.cos(angle)*24,y=10+y*3,z=math.sin(angle)*24,yaw=-angle}
        end
    end
    for x=-5,5 do p[#p+1]={x=x*4,y=28,z=-24}; p[#p+1]={x=x*4,y=28,z=24} end
    buildWoodPattern("Fortress",p)
end)
button(build,"PRESET: BRIDGE",function()
    local p={}
    for x=0,24 do
        for z=-2,2 do p[#p+1]={x=x*4,y=8,z=z*4} end
    end
    for side=-1,1,2 do
        for x=0,24 do p[#p+1]={x=x*4,y=12,z=side*12} end
    end
    buildWoodPattern("Bridge",p)
end)
button(build,"PRESET: HOUSE PLUS",function()
    local p={}
    for x=-4,4 do for z=-4,4 do p[#p+1]={x=x*4,y=8,z=z*4} end end
    for y=0,4 do
        for x=-4,4 do p[#p+1]={x=x*4,y=10+y*3,z=-16}; p[#p+1]={x=x*4,y=10+y*3,z=16} end
        for z=-3,3 do p[#p+1]={x=-16,y=10+y*3,z=z*4}; p[#p+1]={x=16,y=10+y*3,z=z*4} end
    end
    for x=-4,4 do for z=-4,4 do p[#p+1]={x=x*4,y=25,z=z*4} end end
    buildWoodPattern("House Plus",p)
end)
button(build,"PRESET: ROCKET SHIP",function()
    local p={}
    for y=0,12 do
        local radius=math.max(1,math.floor((12-y)*0.55))
        for x=-radius,radius do for z=-radius,radius do
            if x*x+z*z<=radius*radius then p[#p+1]={x=x*3,y=8+y*3,z=z*3} end
        end end
    end
    for side=-1,1,2 do
        for y=0,4 do for x=-2,2 do p[#p+1]={x=side*9+x*2,y=5+y*3,z=0} end end
    end
    buildWoodPattern("Rocket Ship",p)
end)
button(build,"PRESET: AIRCRAFT",function()
    local p={}
    for x=-2,2 do for y=0,1 do p[#p+1]={x=x*3,y=8+y*2,z=0} end end
    for z=-9,9 do
        for x=-5,5 do if math.abs(x)<=math.max(1,math.floor((10-math.abs(z))*0.7)) then p[#p+1]={x=x*3,y=9,z=z*3} end end
    end
    for y=0,5 do p[#p+1]={x=0,y=9+y*2,z=-30}; p[#p+1]={x=-6,y=9+y*2,z=-27}; p[#p+1]={x=6,y=9+y*2,z=-27} end
    buildWoodPattern("Aircraft",p)
end)
button(build,"PRESET: PYRAMID",function()
    local p={}
    for y=0,10 do
        local radius=10-y
        for x=-radius,radius do for z=-radius,radius do
            if math.abs(x)==radius or math.abs(z)==radius or y==0 then
                p[#p+1]={x=x*3,y=8+y*3,z=z*3}
            end
        end end
    end
    buildWoodPattern("Pyramid",p)
end)
button(build,"PRESET: CHRISTMAS TREE",function()
    local p={}
    for y=0,10 do
        local radius=math.max(1,10-y)
        for x=-radius,radius do for z=-radius,radius do
            if math.abs(x)+math.abs(z)<=radius then p[#p+1]={x=x*2,y=8+y*3,z=z*2} end
        end end
    end
    for y=0,4 do p[#p+1]={x=0,y=38+y*3,z=0} end
    buildWoodPattern("Christmas Tree",p)
end)

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


-- CROSS-PLATFORM MIDI IMPORT V1
-- Same URL/base64 workflow on desktop Solara and Android Delta; no native file picker required.
label(music,"EASY MIDI IMPORT")
label(music,"Paste a .mid download link, an OnlineSequencer song link, or a local file path. No Base64 converter needed.")
midiInput=create("TextBox",{
    Size=UDim2.new(1,-8,0,76), BackgroundColor3=DARK, Text="",
    PlaceholderText="song.mid (in Solara workspace) or direct .mid URL...",
    TextColor3=WHITE, TextSize=12, Font=Enum.Font.Gotham,
    ClearTextOnFocus=false, MultiLine=true, TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top
},music)
round(midiInput,8); outline(midiInput)
midiStatus=label(music,"MIDI: waiting for input")
parsedMidi=nil
function decodeBase64(data)
    local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local map={}
    for i=1,#chars do map[chars:sub(i,i)]=i-1 end
    local out,buffer,bits={},0,0
    data=data:gsub("%s",""):gsub("-","+"):gsub("_","/")
    for i=1,#data do
        local c=data:sub(i,i)
        if c=="=" then break end
        local v=map[c]
        if v==nil then error("Invalid Base64 character: "..c) end
        buffer=buffer*64+v; bits=bits+6
        if bits>=8 then
            bits=bits-8
            local b=math.floor(buffer/2^bits)%256
            out[#out+1]=string.char(b)
            buffer=buffer%2^bits
        end
    end
    return table.concat(out)
end
function readMidi(data)
    if #data<14 or data:sub(1,4)~="MThd" then error("Not a Standard MIDI file (missing MThd)") end
    local function u16(p) local a,b=data:byte(p,p+1); if not b then error("Unexpected end of MIDI") end; return a*256+b end
    local function u32(p) local a,b,c,d=data:byte(p,p+3); if not d then error("Unexpected end of MIDI") end; return ((a*256+b)*256+c)*256+d end
    local headerLen=u32(5)
    local format=u16(9); local trackCount=u16(11); local division=u16(13)
    if format>1 then error("MIDI format 2 is not supported") end
    if division>=32768 or division==0 then error("SMPTE/invalid MIDI timing is not supported") end
    local pos=9+headerLen
    local allNotes,tempos={},{}
    for track=1,trackCount do
        if data:sub(pos,pos+3)~="MTrk" then error("Missing MIDI track "..track) end
        local length=u32(pos+4); local first=pos+8; local last=first+length-1
        if last>#data then error("Truncated MIDI track") end
        local p,tick,running=first,0,nil
        local active={}
        local function vlq()
            local value=0
            for _=1,4 do
                if p>last then error("Truncated variable-length value") end
                local b=data:byte(p); p=p+1
                value=value*128+(b%128)
                if b<128 then return value end
            end
            error("Invalid MIDI variable-length value")
        end
        while p<=last do
            tick=tick+vlq()
            if p>last then break end
            local status=data:byte(p)
            if status>=128 then p=p+1 else
                if not running then error("Invalid MIDI running status") end
                status=running
            end
            if status==255 then
                running=nil
                local meta=data:byte(p); p=p+1
                local n=vlq()
                if meta==81 and n==3 then
                    local a,b,c=data:byte(p,p+2)
                    tempos[#tempos+1]={tick=tick,us=a*65536+b*256+c}
                end
                p=p+n
            elseif status==240 or status==247 then
                running=nil; local n=vlq(); p=p+n
            elseif status>=128 and status<240 then
                running=status
                local kind=math.floor(status/16)
                local channel=status%16
                local a=data:byte(p); p=p+1
                local b=0
                if kind~=12 and kind~=13 then b=data:byte(p); p=p+1 end
                if kind==9 and b>0 then
                    local key=channel..":"..a
                    active[key]=active[key] or {}
                    table.insert(active[key],{tick=tick,pitch=a,velocity=b})
                elseif kind==8 or (kind==9 and b==0) then
                    local key=channel..":"..a
                    local queue=active[key]
                    if queue and #queue>0 then
                        local start=table.remove(queue,1)
                        allNotes[#allNotes+1]={start=start.tick,finish=math.max(tick,start.tick+1),pitch=start.pitch,velocity=start.velocity,channel=channel}
                    end
                end
            else
                error("Unsupported MIDI event status")
            end
        end
        pos=last+1
    end
    table.sort(tempos,function(a,b) return a.tick<b.tick end)
    table.sort(allNotes,function(a,b) return a.start<b.start end)
    local function secondsAt(target)
        local currentTick,seconds,tempo=0,0,500000
        for _,change in ipairs(tempos) do
            if change.tick>target then break end
            if change.tick>currentTick then seconds=seconds+(change.tick-currentTick)*tempo/(division*1000000); currentTick=change.tick end
            tempo=change.us
        end
        return seconds+(target-currentTick)*tempo/(division*1000000)
    end
    for _,note in ipairs(allNotes) do
        note.time=secondsAt(note.start)
        note.duration=math.max(0.05,secondsAt(note.finish)-note.time)
    end
    return {format=format,tracks=trackCount,division=division,notes=allNotes}
end
function getMidiBytes(input)
    input=input:gsub("^%s+",""):gsub("%s+$","")
    local function validMidi(data)
        return type(data)=="string" and #data>=14 and data:sub(1,4)=="MThd"
    end
    local function tryRead(path)
        if type(readfile)~="function" then return nil end
        local ok,data=pcall(readfile,path)
        if ok and type(data)=="string" and #data>0 then return data end
        return nil
    end
    if input=="" or not input:match("^https?://") then
        if input~="" then
            local candidates={input,"workspace/"..input}
            for _,path in ipairs(candidates) do
                local data=tryRead(path)
                if data then
                    if validMidi(data) then return data end
                    error("File was read, but it is not a MIDI file: "..path)
                end
            end
        end
        -- Solara stores executor files in its workspace. Search subfolders too.
        local found={}
        if type(listfiles)=="function" then
            local visited={}
            local function scan(folder,depth)
                if depth>4 or visited[folder] then return end
                visited[folder]=true
                local ok,items=pcall(listfiles,folder)
                if not ok or type(items)~="table" then return end
                for _,path in ipairs(items) do
                    if type(path)=="string" then
                        local clean=path:gsub("\\","/")
                        if clean:lower():match("%.midi?$") then
                            table.insert(found,clean)
                            local base=clean:match("([^/]+)$")
                            if input=="" or (base and base:lower()==input:match("([^/]+)$"):lower()) then
                                local data=tryRead(path)
                                if validMidi(data) then return data end
                            end
                        elseif depth<4 then
                            local isDir=false
                            if type(isfolder)=="function" then
                                local okDir,result=pcall(isfolder,path)
                                isDir=okDir and result
                            elseif not clean:match("%.[^/]+$") then
                                isDir=true
                            end
                            if isDir then
                                local data=scan(path,depth+1)
                                if data then return data end
                            end
                        end
                    end
                end
            end
            local data=scan("",0)
            if data then return data end
        end
        local ok,raw=pcall(decodeBase64,input)
        if ok and validMidi(raw) then return raw end
        local list=#found>0 and table.concat(found,", ") or "no .mid files found"
        error("Can't find/read the MIDI file. Put it in Solara workspace and enter its filename (example: song.mid). Found: "..list)
    end

    local function httpGet(url)
        local methods={
            function() return game:HttpGet(url) end,
            function() if request then local r=request({Url=url,Method="GET"}); if r and r.Body then return r.Body end end end,
            function() if http_request then local r=http_request({Url=url,Method="GET"}); if r and r.Body then return r.Body end end end,
            function() if syn and syn.request then local r=syn.request({Url=url,Method="GET"}); if r and r.Body then return r.Body end end end
        }
        local lastError="HTTP request failed"
        for _,method in ipairs(methods) do
            local ok,result=pcall(method)
            if ok and type(result)=="string" and #result>0 then return result end
            if not ok then lastError=tostring(result) end
        end
        error(lastError)
    end
    local bytes=httpGet(input)
    if validMidi(bytes) then return bytes end
    error("This link did not return a MIDI file. Use a direct .mid download link.")
end
button(music,"AUTO FIND + LOAD MIDI",function()
    parsedMidi=nil
    midiStatus.Text="MIDI: searching Solara workspace..."
    local ok,result=pcall(function()
        local bytes=getMidiBytes("")
        if #bytes>12000000 then error("MIDI exceeds 12 MB safety limit") end
        local parsed=readMidi(bytes)
        if #parsed.notes==0 then error("No paired note-on/note-off events found") end
        return parsed
    end)
    if not ok then
        midiStatus.Text="AUTO FIND ERROR: "..tostring(result)
        warn("[DIAMOND MIDI] "..tostring(result))
        return
    end
    parsedMidi=result
    local totalDuration=0
    for _,note in ipairs(result.notes) do totalDuration=math.max(totalDuration,note.time+note.duration) end
    midiStatus.Text=string.format("READY: %d notes | %d tracks | %.1f sec | format %d",#result.notes,result.tracks,totalDuration,result.format)
    print("[DIAMOND MIDI] Auto-loaded:",#result.notes,"notes")
end)
button(music,"IMPORT / PARSE MIDI",function()
    parsedMidi=nil
    midiStatus.Text="MIDI: importing..."
    local ok,result=pcall(function()
        local bytes=getMidiBytes(midiInput.Text)
        if #bytes>12000000 then error("MIDI exceeds 12 MB safety limit") end
        local parsed=readMidi(bytes)
        if #parsed.notes==0 then error("No paired note-on/note-off events found") end
        return parsed
    end)
    if not ok then
        midiStatus.Text="MIDI ERROR: "..tostring(result)
        warn("[DIAMOND MIDI] "..tostring(result))
        return
    end
    parsedMidi=result
    local totalDuration=0
    for _,note in ipairs(result.notes) do totalDuration=math.max(totalDuration,note.time+note.duration) end
    midiStatus.Text=string.format("READY: %d notes | %d tracks | %.1f sec | format %d",#result.notes,result.tracks,totalDuration,result.format)
    print("========== DIAMOND MIDI IMPORT ==========")
    print("[MIDI] Parsed notes:",#result.notes,"Tracks:",result.tracks,"Duration:",string.format("%.2f",totalDuration),"seconds")
    print("[MIDI] First 30 events (seconds, MIDI pitch, duration):")
    for i=1,math.min(30,#result.notes) do
        local n=result.notes[i]
        print(string.format("[MIDI %03d] t=%.3f pitch=%d duration=%.3f velocity=%d channel=%d",i,n.time,n.pitch,n.duration,n.velocity,n.channel))
    end
    print("[MIDI] Full parsed event table is stored in the running hub as parsedMidi.")
    print("=========================================")
end)
button(music,"SHOW MIDI SUMMARY",function()
    if not parsedMidi then warn("[DIAMOND MIDI] Import a MIDI file first"); return end
    print("[MIDI SUMMARY] Notes:",#parsedMidi.notes,"Tracks:",parsedMidi.tracks,"Format:",parsedMidi.format)
    for i,n in ipairs(parsedMidi.notes) do
        if i>100 then print("[MIDI SUMMARY] Output capped at 100 events"); break end
        print(i,string.format("%.3f",n.time),"pitch",n.pitch,"duration",string.format("%.3f",n.duration))
    end
end)
label(music,"Solara: put your .mid file in workspace, then press AUTO FIND + LOAD MIDI. No filename needed.")
label(music,"This stage imports and parses the actual MIDI. Automatic placement, pitch configuration and wiring remain locked until the live PropertyTool/BindingTool remote arguments are verified; the hub will not fake a successful build.")

-- MUSIC HELPER V1: inventory checks, verified sequence links and safe duplication notes.
label(music,"ONE-CLICK MIDI CONVERTER")
label(music,"Convert a local .mid file into a BABFT music blueprint with Note keys, Delay timing and wiring steps.")
midiConverterUrl="https://babft-music-note.vercel.app/"
button(music,"COPY / OPEN MIDI → BABFT CONVERTER",function()
    local copied=false
    if setclipboard then copied=pcall(setclipboard,midiConverterUrl) end
    print("[DIAMOND MUSIC] MIDI converter:",midiConverterUrl)
    if copied then
        print("[DIAMOND MUSIC] Link copied. Open it, choose your .mid file, then follow its BABFT build plan.")
    else
        warn("[DIAMOND MUSIC] Open this URL manually:",midiConverterUrl)
    end
end)
button(music,"COPY MIDI CONVERTER LINK",function()
    if setclipboard then
        local ok=pcall(setclipboard,midiConverterUrl)
        if ok then print("[DIAMOND MUSIC] Converter link copied") return end
    end
    print("[DIAMOND MUSIC] Converter URL:",midiConverterUrl)
end)
label(music,"MUSIC BUILDER — MIDI SOURCES")
label(music,"Song charts are linked below. Property Tool settings and note bindings must be verified in-game before a full automatic arrangement can be generated.")
holyWarUrl="https://onlinesequencer.net/5314889"
rushEUrl="https://onlinesequencer.net/5775937"
function copyMusicUrl(url,title)
    if setclipboard then
        local ok=pcall(setclipboard,url)
        if ok then print("[DIAMOND MUSIC] Copied "..title..": "..url); return end
    end
    print("[DIAMOND MUSIC] "..title.." MIDI source: "..url)
end
button(music,"COPY HOLY WAR — URAL GAYSIN MIDI LINK",function()
    copyMusicUrl(holyWarUrl,"Holy War — Ural Gaysin")
end)
button(music,"COPY RUSH E MIDI LINK",function()
    copyMusicUrl(rushEUrl,"Rush E")
end)
label(music,"BABFT BLOCK CHECK")
musicInventoryLabel=label(music,"Inventory: not scanned")
button(music,"DEEP SCAN PLAYER INVENTORY",function()
    local totalValues=0
    local matches={}
    local function inspect(root,tag)
        if not root then return end
        for _,obj in ipairs(root:GetDescendants()) do
            local nm=obj.Name:lower()
            local relevant=nm:find("music",1,true) or nm:find("note",1,true) or nm:find("delay",1,true)
            if obj:IsA("ValueBase") then
                totalValues+=1
                if relevant then
                    local value=obj.Value
                    if typeof(value)=="Instance" then value=value:GetFullName() end
                    table.insert(matches,tag.." | "..obj:GetFullName().." ["..obj.ClassName.."] = "..tostring(value))
                end
            elseif relevant then
                table.insert(matches,tag.." | "..obj:GetFullName().." ["..obj.ClassName.."]")
            end
        end
    end
    local data=Player:FindFirstChild("Data")
    local noteCount=data and data:FindFirstChild("Note")
    local delayCount=data and data:FindFirstChild("Delay")
    noteCount=(noteCount and noteCount.Value) or 0
    delayCount=(delayCount and delayCount.Value) or 0
    if data then inspect(data,"PLAYER_DATA") else warn("[MUSIC SCAN] Player.Data missing") end
    inspect(Player:FindFirstChildOfClass("Backpack"),"BACKPACK")
    inspect(Player.Character,"CHARACTER")
    inspect(Player:FindFirstChild("PlayerGui"),"PLAYER_GUI")
    table.sort(matches)
    print("========== DIAMOND MUSIC DEEP SCAN ==========")
    print("[MUSIC SCAN] Player.Data found:",data~=nil,"Descendants in Data:",data and #data:GetDescendants() or 0)
    print("[MUSIC SCAN] ValueBase objects scanned:",totalValues,"Actual name matches:",#matches)
    print("[MUSIC INVENTORY] Music Note:",noteCount,"| Delay:",delayCount)
    musicInventoryLabel.Text="Inventory: "..noteCount.." Notes / "..delayCount.." Delays"
    for _,row in ipairs(matches) do print("[MUSIC SCAN]",row) end
    if #matches==0 then
        musicInventoryLabel.Text="No Music/Note/Delay names found — see F9"
        warn("[MUSIC SCAN] No matching object names in Data, Backpack, Character or PlayerGui.")
    else
        musicInventoryLabel.Text="Found "..#matches.." Music/Note/Delay rows — see F9"
    end
    print("========== END MUSIC SCAN ==========")
end)
button(music,"SCAN BUILDING TOOL INVENTORY UI",function()
    local found=0
    local function scan(root,tag)
        if not root then return end
        for _,obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                local txt=tostring(obj.Text)
                local low=txt:lower()
                if low:find("music",1,true) or low:find("note",1,true) or low:find("delay",1,true) then
                    found+=1
                    print("[BUILD INVENTORY UI]",tag,obj:GetFullName(),"TEXT=",txt)
                end
            end
        end
    end
    scan(Player:FindFirstChild("PlayerGui"),"PLAYER_GUI")
    scan(getParent(),"EXECUTOR_GUI")
    local char=Player.Character
    local backpack=Player:FindFirstChildOfClass("Backpack")
    scan(char and char:FindFirstChild("BuildingTool"),"EQUIPPED_BUILDING_TOOL")
    scan(backpack and backpack:FindFirstChild("BuildingTool"),"BACKPACK_BUILDING_TOOL")
    print("[BUILD INVENTORY UI] Matches:",found)
    musicInventoryLabel.Text="UI scan complete: "..found.." matches — see F9"
end)
label(music,"MUSIC BUILDER — BLOCK ID / TOOL DIAGNOSTICS")
label(music,"Checks real block templates and tool remotes before automatic placement.")
button(music,"SCAN MUSIC BUILDER API",function()
    local RS=game:GetService("ReplicatedStorage")
    local parts=RS:FindFirstChild("BuildingParts")
    local data=Player:FindFirstChild("Data")
    local function stock(name)
        local v=data and data:FindFirstChild(name)
        return v and v.Value or 0
    end
    print("========== DIAMOND MUSIC BUILDER API ==========")
    print("[MUSIC API] ReplicatedStorage.BuildingParts:",parts and "FOUND" or "MISSING")
    if parts then
        local children=parts:GetChildren()
        for index,obj in ipairs(children) do
            local low=obj.Name:lower()
            if low:find("note",1,true) or low:find("delay",1,true) then
                print("[MUSIC API] TEMPLATE",obj.Name,"INDEX/ID CANDIDATE",index,"CLASS",obj.ClassName,
                    "PrimaryPart",obj:IsA("Model") and tostring(obj.PrimaryPart) or "n/a",
                    "PPart",tostring(obj:FindFirstChild("PPart")))
            end
        end
        print("[MUSIC API] BuildingParts total templates:",#children)
    end
    print("[MUSIC API] Inventory Note:",stock("Note"),"Delay:",stock("Delay"))
    local backpack=Player:FindFirstChildOfClass("Backpack")
    local char=Player.Character
    for _,toolName in ipairs({"BuildingTool","PropertiesTool","PropertyTool","BindingTool"}) do
        local tool=(char and char:FindFirstChild(toolName)) or (backpack and backpack:FindFirstChild(toolName))
        print("[MUSIC API] TOOL",toolName,tool and "FOUND" or "NOT FOUND")
        if tool then
            for _,obj in ipairs(tool:GetDescendants()) do
                if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                    print("[MUSIC API] REMOTE",toolName,obj:GetFullName(),obj.ClassName)
                end
            end
        end
    end
    local blocks=Workspace:FindFirstChild("Blocks")
    local own=blocks and blocks:FindFirstChild(Player.Name)
    if own then
        for _,obj in ipairs(own:GetChildren()) do
            local low=obj.Name:lower()
            if low:find("note",1,true) or low:find("delay",1,true) then
                print("[MUSIC API] OWNED BLOCK",obj.Name,obj:GetFullName())
                for attr,value in pairs(obj:GetAttributes()) do print("[MUSIC API] ATTRIBUTE",attr,tostring(value)) end
                local part=obj:FindFirstChild("PPart")
                if part then for attr,value in pairs(part:GetAttributes()) do print("[MUSIC API] PART ATTRIBUTE",attr,tostring(value)) end end
            end
        end
    else
        warn("[MUSIC API] Own Workspace.Blocks folder not found")
    end
    print("========== END MUSIC BUILDER API ==========")
end)
label(music,"KNOWN GAME LIMITS")
label(music,"Music Note: 25 pitches from F#3 to F#5; note sustain is about 0.85 sec.")
label(music,"Delay Block: 0.05–10 sec. Key and delay values are set with the in-game Property Tool.")
label(music,"MIDI conversion is available from the linked converter. Direct in-game import is not enabled yet: the live Property Tool and BindingTool APIs must be confirmed before the hub can safely set pitch, delay and wiring automatically.")
-- MIDI AUTO BUILD V1: places actual Note/Delay blocks and applies pitch/timing properties.
-- BindingTool wire protocol is deliberately not guessed; blocks are laid out in an easy-to-bind row.
midiBuildRunning=false
midiBuildStatus=label(music,"MIDI BUILD: waiting for parsed MIDI")
function findTool(names)
    local char=Player.Character
    local backpack=Player:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(names) do
        local tool=(char and char:FindFirstChild(name)) or (backpack and backpack:FindFirstChild(name))
        if tool then
            if char and tool.Parent==backpack then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(tool) end); task.wait(0.25) end
            end
            return (Player.Character and Player.Character:FindFirstChild(name)) or tool
        end
    end
end
function findPropertyRemote()
    local tool=findTool({"PropertiesTool","PropertyTool"})
    if not tool then return nil end
    local rf=tool:FindFirstChild("SetPropertieRF",true) or tool:FindFirstChild("SetPropertyRF",true)
    return rf and rf:IsA("RemoteFunction") and rf or nil
end
function getMusicBlockId(name)
    if getInventoryCount(name)<=0 then return nil end
    return getBlockTypeId(name)
end
function equipMusicTool(tool)
    if not tool then return false end
    local char=Player.Character
    if not char then return false end
    if tool.Parent==char then return true end
    local backpack=Player:FindFirstChildOfClass("Backpack")
    if tool.Parent~=backpack then return false end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local ok=pcall(function() hum:EquipTool(tool) end)
    if not ok then return false end
    for _=1,20 do
        if tool.Parent==Player.Character then return true end
        task.wait(0.05)
    end
    return tool.Parent==Player.Character
end
function setMusicProperty(remote,property,block,value)
    local tool=remote and remote:FindFirstAncestorOfClass("Tool")
    if not tool or not equipMusicTool(tool) then
        return false,"PropertiesTool could not be equipped"
    end
    local ok,result=pcall(function()
        return remote:InvokeServer(property,{block},value)
    end)
    if not ok then return false,tostring(result) end
    return true,result
end
function findBindValue(block)
    if not block then return nil end
    local direct=block:FindFirstChild("BindFire")
    if direct and direct:IsA("IntValue") then return direct end
    for _,obj in ipairs(block:GetDescendants()) do
        if obj:IsA("IntValue") and obj.Name:sub(1,4)=="Bind" then return obj end
    end
    return nil
end
function findMusicInput(folder)
    local names={Button=true,Switch=true,SwitchBig=true,BigSwitch=true,Lever=true}
    for _,obj in ipairs(folder:GetChildren()) do
        if obj:IsA("Model") and names[obj.Name] and obj:FindFirstChild("PPart") then
            return obj
        end
    end
    return nil
end
function bindMusicTarget(remote,target,controller)
    local bindValue=findBindValue(target)
    if not bindValue then return false,"No Bind IntValue in "..target.Name end
    local tool=remote and remote:FindFirstAncestorOfClass("Tool")
    if not tool or not equipMusicTool(tool) then
        return false,"BindingTool could not be equipped"
    end
    local ok,result=pcall(function()
        return remote:InvokeServer({bindValue},controller,bindValue.Value or -1,false)
    end)
    if not ok then return false,tostring(result) end
    return true
end
function startMidiBuild()
    if midiBuildRunning then warn("[MIDI BUILD] Already running"); return end
    if not parsedMidi or #parsedMidi.notes==0 then warn("[MIDI BUILD] Import a MIDI first"); return end

    local data=Player:FindFirstChild("Data")
    local noteId=getMusicBlockId("Note")
    local delayId=getMusicBlockId("Delay")
    if not noteId or not delayId then
        warn("[MIDI BUILD] Inventory missing Note or Delay blocks")
        midiBuildStatus.Text="MIDI BUILD: missing Note/Delay inventory"
        return
    end

    -- Group simultaneous MIDI notes so chords fire from the same Delay.
    local groups={}
    for _,n in ipairs(parsedMidi.notes) do
        local g=groups[#groups]
        if not g or math.abs(g.time-n.time)>0.012 then
            g={time=n.time,notes={}}
            table.insert(groups,g)
        end
        table.insert(g.notes,n)
    end
    local requiredNotes=0
    for _,g in ipairs(groups) do requiredNotes+=#g.notes end
    local noteCount=getInventoryCount("Note")
    local delayCount=getInventoryCount("Delay")
    if noteCount<requiredNotes or delayCount<#groups then
        midiBuildStatus.Text=string.format("Need %d Notes + %d Delays; have %d + %d",requiredNotes,#groups,noteCount,delayCount)
        warn("[MIDI BUILD] Not enough inventory. Need",requiredNotes,"Notes and",#groups,"Delays; have",noteCount,delayCount)
        return
    end

    local zone=getPlayerZone(Player)
    local buildRF=getBuildTool()
    if not zone or not buildRF then
        midiBuildStatus.Text="MIDI BUILD: plot or BuildingTool unavailable"
        return
    end
    local propertyRF=findPropertyRemote()
    if not propertyRF then
        midiBuildStatus.Text="MIDI BUILD: equip PropertiesTool first"
        return
    end
    local folder=Workspace:FindFirstChild("Blocks")
    local myFolder=folder and folder:FindFirstChild(Player.Name)
    if not myFolder then warn("[MIDI BUILD] Own block folder missing"); return end

    local input=findMusicInput(myFolder)
    local buttonId=getMusicBlockId("Button")
    local needsButton=not input
    if needsButton and not buttonId then
        midiBuildStatus.Text="MIDI BUILD: add a Button or Switch to your base"
        warn("[MIDI BUILD] No existing Button/Switch/Lever found. Add one input block, then retry.")
        return
    end

    local char,hum,root=getCharacter()
    local origin=root and (root.CFrame*CFrame.new(0,8,-18))
    if not origin then warn("[MIDI BUILD] Character root missing"); return end

    local keyNames={"F#3","G3","G#3","A3","A#3","B3","C4","C#4","D4","D#4","E4","F4","F#4","G4","G#4","A4","A#4","B4","C5","C#5","D5","D#5","E5","F5","F#5"}
    local prepared={}
    for i,g in ipairs(groups) do
        local groupData={time=g.time,notes={}}
        for _,n in ipairs(g.notes) do
            local key=n.pitch-54
            if key<0 or key>24 then
                midiBuildStatus.Text="MIDI BUILD: pitch outside F#3–F#5 (see F9)"
                warn("[MIDI BUILD] Pitch outside Music Note range F#3-F#5:",n.pitch)
                return
            end
            table.insert(groupData.notes,{key=keyNames[key+1],pitch=n.pitch,duration=n.duration})
        end
        local delta=i>1 and (g.time-groups[i-1].time) or g.time
        groupData.delay=math.clamp(delta,0.05,10)
        table.insert(prepared,groupData)
    end

    midiBuildRunning=true
    midiBuildStatus.Text="MIDI BUILD: placing "..requiredNotes.." Notes + "..#groups.." Delays..."
    task.spawn(function()
        local madeNotes,madeDelays={},{}
        local errors,placedNotes,placedDelays,binds=0,0,0,0
        local function place(name,id,cf)
            local before={}
            for _,obj in ipairs(myFolder:GetChildren()) do before[obj]=true end
            local localCF=zone.CFrame:ToObjectSpace(cf)
            local activeBuildRF
            local ok,err=pcall(function()
                local buildTool=findTool({"BuildingTool"})
                if not buildTool or not equipMusicTool(buildTool) then
                    error("BuildingTool could not be equipped")
                end
                activeBuildRF=buildTool:FindFirstChild("RF")
                if not activeBuildRF or not activeBuildRF:IsA("RemoteFunction") then
                    error("BuildingTool.RF unavailable")
                end
                activeBuildRF:InvokeServer(name,id,zone,localCF,true,cf,false)
            end)
            if not ok then return nil,tostring(err) end
            for _=1,30 do
                for _,obj in ipairs(myFolder:GetChildren()) do
                    if not before[obj] and obj.Name==name and obj:FindFirstChild("PPart") then return obj end
                end
                task.wait(0.05)
            end
            return nil,"server did not replicate placed "..name
        end

        -- Create a starter input only if the base has no existing input block.
        if needsButton then
            input=place("Button",buttonId,origin*CFrame.new(-7,0,0))
            if not input then
                midiBuildRunning=false
                midiBuildStatus.Text="MIDI BUILD: could not place starter Button"
                warn("[MIDI BUILD] Failed to create starter Button")
                return
            end
        end

        local bindingTool=findTool({"BindingTool"})
        local bindRF=bindingTool and bindingTool:FindFirstChild("RF",true)
        if not bindRF or not bindRF:IsA("RemoteFunction") then
            midiBuildRunning=false
            midiBuildStatus.Text="MIDI BUILD: BindingTool.RF unavailable"
            warn("[MIDI BUILD] BindingTool.RF not found")
            return
        end

        for i,item in ipairs(prepared) do
            if not midiBuildRunning then break end
            local delayCF=origin*CFrame.new((i-1)*7,0,0)
            local delayBlock,delayErr=place("Delay",delayId,delayCF)
            if not delayBlock then
                errors+=1
                warn("[MIDI BUILD] Delay placement failed",i,delayErr)
                break
            end
            table.insert(madeDelays,delayBlock)
            placedDelays+=1
            local propOK,propErr=setMusicProperty(propertyRF,"Delay",delayBlock,item.delay)
            if not propOK then errors+=1; warn("[MIDI BUILD] Delay property failed",i,propErr) end

            for j,noteData in ipairs(item.notes) do
                if not midiBuildRunning then break end
                local noteCF=delayCF*CFrame.new(0,0,-3-(j-1)*3)
                local noteBlock,noteErr=place("Note",noteId,noteCF)
                if noteBlock then
                    table.insert(madeNotes,noteBlock)
                    placedNotes+=1
                    local keyOK,keyErr=setMusicProperty(propertyRF,"Key",noteBlock,noteData.key)
                    if not keyOK then errors+=1; warn("[MIDI BUILD] Note key failed",i,j,keyErr) end
                else
                    errors+=1
                    warn("[MIDI BUILD] Note placement failed",i,j,noteErr)
                end
            end

            -- Every Delay triggers only the Notes in its own timestamp group.
            local controller=delayBlock
            local firstNoteIndex=#madeNotes-#item.notes+1
            for ni=firstNoteIndex,#madeNotes do
                local ok,err=bindMusicTarget(bindRF,madeNotes[ni],controller)
                if ok then binds+=1 else errors+=1; warn("[MIDI BUILD] Note bind failed",i,err) end
            end

            if i==1 then
                local ok,err=bindMusicTarget(bindRF,delayBlock,input)
                if ok then binds+=1 else errors+=1; warn("[MIDI BUILD] Starter bind failed",err) end
            else
                local ok,err=bindMusicTarget(bindRF,delayBlock,madeDelays[i-1])
                if ok then binds+=1 else errors+=1; warn("[MIDI BUILD] Delay chain bind failed",i,err) end
            end

            midiBuildStatus.Text=string.format("MIDI BUILD: %d/%d groups | Notes %d/%d | links %d | errors %d",i,#prepared,placedNotes,requiredNotes,binds,errors)
            if i%3==0 then task.wait(0.1) end
        end

        midiBuildRunning=false
        midiBuildStatus.Text=string.format("Built %d/%d Notes, %d/%d Delays, %d links, %d errors",placedNotes,requiredNotes,placedDelays,#prepared,binds,errors)
        print("[MIDI BUILD] Finished. Notes:",placedNotes,"Delays:",placedDelays,"Links:",binds,"Errors:",errors)
        print("[MIDI BUILD] Simultaneous notes were grouped into chords. Existing input:",input and input.Name or "none")
        print("[MIDI BUILD] Note sustain in BABFT is limited to about 0.85 seconds; longer MIDI durations cannot be reproduced exactly.")
        print("[MIDI BUILD] Long gaps over 10 seconds are clamped to 10 seconds by the Delay block limit.")
    end)
end
button(music,"AUTO BUILD + WIRE MIDI",startMidiBuild)
-- ONE-CLICK SONG BUILDER V2: fetch Online Sequencer's saved note data (no MIDI file).
-- Online Sequencer stores each note as: cellTime pitch length instrument; sequence data starts with BPM.
HttpService = game:GetService("HttpService")
function loadOnlineSequencerSong(title, sequenceId)
    local id = tostring(sequenceId)
    local urls = {
        "https://onlinesequencer.net/ajax/load.php?id=" .. id,
        "https://www.onlinesequencer.net/ajax/load.php?id=" .. id,
        -- The sequencer page itself embeds the saved note string in its startup script.
        "https://onlinesequencer.net/" .. id,
        "https://www.onlinesequencer.net/" .. id
    }
    local headers = {
        ["Accept"] = "application/json, text/plain, */*",
        ["Referer"] = "https://onlinesequencer.net/" .. id,
        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36"
    }
    local response, rawPage, lastError
    for _, url in ipairs(urls) do
        local attempts = {
            function()
                if type(request) == "function" then
                    local r = request({Url=url, Method="GET", Headers=headers})
                    if r and r.Body and (not r.StatusCode or r.StatusCode == 200) then return r.Body end
                    error("HTTP status " .. tostring(r and r.StatusCode))
                end
            end,
            function()
                if type(http_request) == "function" then
                    local r = http_request({Url=url, Method="GET", Headers=headers})
                    if r and r.Body and (not r.StatusCode or r.StatusCode == 200) then return r.Body end
                    error("HTTP status " .. tostring(r and r.StatusCode))
                end
            end,
            function()
                if syn and type(syn.request) == "function" then
                    local r = syn.request({Url=url, Method="GET", Headers=headers})
                    if r and r.Body and (not r.StatusCode or r.StatusCode == 200) then return r.Body end
                    error("HTTP status " .. tostring(r and r.StatusCode))
                end
            end,
            function() return game:HttpGet(url) end
        }
        for _, attempt in ipairs(attempts) do
            local ok, body = pcall(attempt)
            if ok and type(body) == "string" and #body > 0 then
                local decodedOk, decoded = pcall(function() return HttpService:JSONDecode(body) end)
                if decodedOk and type(decoded) == "table" and type(decoded.data) == "string" then
                    response = decoded
                    break
                end
                if not rawPage and #body > 100 then rawPage = body end
                lastError = "Non-JSON response (" .. tostring(#body) .. " bytes): " .. body:sub(1,160):gsub("[%c]"," ")
            elseif not ok then
                lastError = tostring(body)
            end
        end
        if response then break end
    end
    local sequenceData
    if response then
        sequenceData = response.data
    elseif rawPage then
        -- Some Online Sequencer deployments return the saved sequence embedded in HTML
        -- rather than JSON. Extract the server-rendered note string without JSON decoding.
        sequenceData = rawPage:match('var%s+data%s*=%s*"([^"]*)"')
            or rawPage:match("var%s+data%s*=%s*'([^']*)'")
        if not sequenceData then
            local escaped = rawPage:match('data\\?"%s*:%s*\\?"([^"]+)')
            if escaped then sequenceData = escaped:gsub('\\\\n',''):gsub('\\\\"','"') end
        end
    end
    if type(sequenceData) ~= "string" or #sequenceData == 0 then
        error("Online Sequencer returned neither readable JSON nor embedded note data. " .. tostring(lastError))
    end
    local bpmText, noteText = sequenceData:match("^%s*(%d+)%s*:(.*)$")
    local bpm = tonumber(bpmText)
    if not bpm or bpm < 10 or bpm > 999 then
        error("Could not read song BPM from sequence data")
    end
    local notes = {}
    for entry in noteText:gmatch("[^;]+") do
        local cellTime, pitchName, cellLength, instrument = entry:match("^%s*([%d%.]+)%s+([A-Ga-g][#b]?%-?%d+)%s+([%d%.]+)%s*(%d*)")
        if cellTime and pitchName and cellLength then
            local letter, accidental, octave = pitchName:match("^([A-Ga-g])([#b]?)(%-?%d+)$")
            local semitones = ({C=0,D=2,E=4,F=5,G=7,A=9,B=11})[letter:upper()]
            if accidental == "#" then semitones = semitones + 1 elseif accidental == "b" then semitones = semitones - 1 end
            local midiPitch = (tonumber(octave) + 1) * 12 + semitones
            -- Online Sequencer uses four cells per quarter note.
            local secondsPerCell = 60 / bpm / 4
            notes[#notes+1] = {
                time = tonumber(cellTime) * secondsPerCell,
                duration = math.max(0.04, tonumber(cellLength) * secondsPerCell),
                pitch = midiPitch,
                velocity = 100,
                channel = tonumber(instrument) or 0
            }
        end
    end
    if #notes == 0 then
        error("Sequence loaded, but no notes could be parsed")
    end
    table.sort(notes, function(a,b) return a.time < b.time end)
    return {notes=notes, bpm=bpm, tracks=1, source="Online Sequencer"}
end

function loadAndBuildSong(title, sequenceId)
    if midiBuildRunning then warn("[DIAMOND MUSIC] Builder is already running"); return end
    midiBuildStatus.Text = "Loading " .. title .. " sequence..."
    task.spawn(function()
        local ok, parsed = pcall(loadOnlineSequencerSong, title, sequenceId)
        if not ok then
            midiBuildStatus.Text = title .. " load failed — see F9"
            warn("[DIAMOND MUSIC] " .. title .. " sequence fetch failed:", parsed)
            return
        end
        parsedMidi = parsed
        local duration = 0
        for _, note in ipairs(parsed.notes) do
            duration = math.max(duration, note.time + note.duration)
        end
        midiStatus.Text = string.format("%s loaded: %d notes | %.1f sec | %d BPM", title, #parsed.notes, duration, parsed.bpm)
        print("[DIAMOND MUSIC] Loaded", title, "from Online Sequencer sequence", sequenceId, "notes", #parsed.notes, "BPM", parsed.bpm)
        startMidiBuild()
    end)
end
label(music,"READY SONGS — CLICK TO BUILD ON YOUR BASE")
-- Quaver chart loader. This is a 4-lane rhythm chart, not a piano transcription:
-- each lane is mapped to one BABFT pitch. It reproduces the chart rhythm, not the
-- original song's full melodic pitches.
function loadQuaverHolyWar()
    local url="https://api.quavergame.com/d/web/map/190014"
    local body
    local methods={
        function() return game:HttpGet(url) end,
        function()
            if type(request)=="function" then
                local r=request({Url=url,Method="GET"})
                if r and r.Body and (not r.StatusCode or r.StatusCode==200) then return r.Body end
                error("HTTP "..tostring(r and r.StatusCode))
            end
        end,
        function()
            if type(http_request)=="function" then
                local r=http_request({Url=url,Method="GET"})
                if r and r.Body and (not r.StatusCode or r.StatusCode==200) then return r.Body end
                error("HTTP "..tostring(r and r.StatusCode))
            end
        end,
        function()
            if syn and type(syn.request)=="function" then
                local r=syn.request({Url=url,Method="GET"})
                if r and r.Body and (not r.StatusCode or r.StatusCode==200) then return r.Body end
                error("HTTP "..tostring(r and r.StatusCode))
            end
        end
    }
    local lastError="No supported HTTP method"
    for _,fn in ipairs(methods) do
        local ok,result=pcall(fn)
        if ok and type(result)=="string" and #result>100 then body=result; break end
        if not ok then lastError=tostring(result) end
    end
    if not body then error("Quaver map download failed: "..lastError) end
    if body:sub(1,2)=="PK" or body:byte(1)==31 then
        error("Quaver returned a compressed package; this executor cannot parse it as plain .qua text")
    end
    local hitSection=body:match("HitObjects:%s*\r?\n([%s%S]+)")
    if not hitSection then error("Downloaded Quaver file has no HitObjects section") end
    local notes={}
    local current=nil
    local function finish()
        if current and current.time and current.lane then
            local pitches={54,57,60,62}
            local pitch=pitches[current.lane]
            if pitch then
                notes[#notes+1]={
                    time=current.time/1000,
                    duration=math.max(0.05,((current.finish or 0)-current.time)/1000),
                    pitch=pitch,velocity=100,channel=0
                }
            end
        end
        current=nil
    end
    for line in hitSection:gmatch("[^\r\n]+") do
        local start=line:match("^%s*%-%s*StartTime:%s*(%-?%d+)")
        if start then
            finish()
            current={time=tonumber(start)}
        elseif current then
            local lane=line:match("^%s*Lane:%s*(%d+)")
            local ending=line:match("^%s*EndTime:%s*(%-?%d+)")
            if lane then current.lane=tonumber(lane) end
            if ending then current.finish=tonumber(ending) end
        end
    end
    finish()
    if #notes==0 then error("Quaver file downloaded, but no supported 4-lane hit objects were parsed") end
    table.sort(notes,function(a,b) return a.time<b.time end)
    return {notes=notes,bpm=150,tracks=1,source="Quaver map 190014 (4-lane rhythm approximation)"}
end

function loadAndBuildQuaverHolyWar()
    if midiBuildRunning then warn("[DIAMOND MUSIC] Builder is already running"); return end
    midiBuildStatus.Text="Downloading Holy War chart from Quaver..."
    task.spawn(function()
        local ok,parsed=pcall(loadQuaverHolyWar)
        if not ok then
            midiBuildStatus.Text="Holy War chart load failed — see F9"
            warn("[DIAMOND MUSIC] Quaver Holy War load failed:",parsed)
            return
        end
        parsedMidi=parsed
        midiStatus.Text=string.format("Holy War rhythm chart: %d hits | 94 sec | 150 BPM",#parsed.notes)
        print("[DIAMOND MUSIC] Loaded Quaver map 190014:",#parsed.notes,"rhythm hits. Lanes are mapped to four pitches; this is NOT a full piano transcription.")
        startMidiBuild()
    end)
end

button(music,"BUILD HOLY WAR — QUAVER RHYTHM",loadAndBuildQuaverHolyWar)
button(music,"BUILD RUSH E",function()
    loadAndBuildSong("Rush E", 5775937)
end)

-- BINDING TOOL API SCAN V1
function dumpToolTree(root,tag)
    if not root then print("[BIND SCAN]",tag,"MISSING"); return end
    print("[BIND SCAN]",tag,root:GetFullName(),root.ClassName)
    for _,obj in ipairs(root:GetDescendants()) do
        if obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") or obj:IsA("BindableFunction") or obj:IsA("BindableEvent") then
            print("[BIND SCAN] REMOTE",obj:GetFullName(),obj.ClassName)
        elseif obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            print("[BIND SCAN] SCRIPT",obj:GetFullName(),obj.ClassName)
        elseif obj:IsA("Tool") then
            print("[BIND SCAN] NESTED TOOL",obj:GetFullName())
        end
    end
end
button(music,"SCAN BINDING TOOL API",function()
    local char=Player.Character
    local backpack=Player:FindFirstChildOfClass("Backpack")
    local tool=(char and (char:FindFirstChild("BindingTool") or char:FindFirstChild("BindTool")))
        or (backpack and (backpack:FindFirstChild("BindingTool") or backpack:FindFirstChild("BindTool")))
    dumpToolTree(tool,"BINDING TOOL")
    local rs=game:GetService("ReplicatedStorage")
    local matches=0
    for _,obj in ipairs(rs:GetDescendants()) do
        local low=obj.Name:lower()
        if low:find("bind",1,true) and (obj:IsA("RemoteFunction") or obj:IsA("RemoteEvent") or obj:IsA("BindableFunction") or obj:IsA("BindableEvent")) then
            matches+=1
            print("[BIND SCAN] REPLICATED STORAGE",obj:GetFullName(),obj.ClassName)
        end
    end
    print("[BIND SCAN] ReplicatedStorage bind remotes:",matches)
    local folder=Workspace:FindFirstChild("Blocks")
    local own=folder and folder:FindFirstChild(Player.Name)
    local shown=0
    if own then
        for _,block in ipairs(own:GetChildren()) do
            if block.Name=="Delay" or block.Name=="Note" or block.Name=="MusicNote" then
                shown+=1
                print("[BIND SCAN] MUSIC BLOCK",block:GetFullName(),"PPart",block:FindFirstChild("PPart"))
                if shown>=12 then break end
            end
        end
    end
    print("[BIND SCAN] Own music blocks inspected:",shown)
    print("[BIND SCAN] Send this F9 output to add the exact chain-binding call. No remote arguments are guessed.")
    local localScript=tool and tool:FindFirstChild("BindLocalScript",true)
    if localScript then
        local decompiler=decompile or (syn and syn.decompile)
        if type(decompiler)=="function" then
            local ok,source=pcall(decompiler,localScript)
            if ok and type(source)=="string" then
                print("[BIND SCAN] ===== BindLocalScript DECOMPILED SOURCE BEGIN =====")
                print("[BIND SCAN] Decompiled source length:",#source)
                local lineNo=0
                for line in source:gmatch("[^\\r\\n]+") do
                    lineNo+=1
                    print(string.format("[BIND SOURCE %03d] %s",lineNo,line))
                end
                print("[BIND SCAN] ===== FULL SOURCE END =====")
            else
                warn("[BIND SCAN] Decompile failed:",tostring(source))
            end
        else
            print("[BIND SCAN] Executor has no decompile/syn.decompile API")
        end
    else
        print("[BIND SCAN] BindLocalScript not found under tool")
    end

end)

button(music,"STOP MIDI AUTO BUILD",function()
    midiBuildRunning=false
    midiBuildStatus.Text="MIDI BUILD: stopping..."
end)
label(music,"AUTO BUILD places Note + Delay pairs in a row and applies pitch/timing properties. BindingTool wiring is not automated yet; do not expect playback until the chain is connected in-game.")

label(music,"DUPLICATION — CHOOSE TARGET SAVE SLOT")
label(music,"Enter the slot number you are willing to overwrite. The hub does not press Save/Load for you.")
selectedSaveSlot=1
slotLabel=label(music,"Target slot: 1")
slotInput=create("TextBox",{
    Size=UDim2.new(1,-8,0,38),
    BackgroundColor3=DARK,
    Text="1",
    PlaceholderText="Save slot number (1–192)",
    TextColor3=WHITE,
    TextSize=14,
    Font=Enum.Font.Gotham,
    ClearTextOnFocus=false
},music)
round(slotInput,8)
outline(slotInput)
slotInput.FocusLost:Connect(function()
    local n=tonumber(slotInput.Text)
    if not n or n%1~=0 or n<1 or n>192 then
        slotInput.Text=tostring(selectedSaveSlot)
        warn("[DIAMOND DUPLICATION] Enter a whole slot number from 1 to 192")
        return
    end
    selectedSaveSlot=n
    slotLabel.Text="Target slot: "..n.." (THIS SLOT MAY BE OVERWRITTEN)"
end)
button(music,"CONFIRM TARGET SLOT",function()
    print("[DIAMOND DUPLICATION] Selected target slot #"..selectedSaveSlot)
    print("[DIAMOND DUPLICATION] In the game's Save menu, manually select slot #"..selectedSaveSlot.." before pressing Save. Do not choose a slot containing a boat you want to keep.")
    slotLabel.Text="CONFIRMED: slot "..selectedSaveSlot.." — may be overwritten"
end)
label(music,"BABFT gives 3 free save slots; purchased slots can increase the total (up to 192). The in-game Save menu is authoritative.")
label(music,"The selected number is a reminder only; slot order can be rearranged in-game. Verify the slot name before saving.")
label(music,"Documented glitch (may be patched): save boat → move it outside plot render distance → load same saved boat → bring original back → save to the chosen slot.")
label(music,"Make a backup in a DIFFERENT slot first. Load Old Versions can restore one of the previous four versions.")
button(music,"PRINT TARGET SLOT + DUPLICATION STEPS",function()
    print("[DIAMOND DUPLICATION GUIDE] TARGET SLOT:",selectedSaveSlot)
    print("1) In the game Save menu, manually select slot #"..selectedSaveSlot..".")
    print("2) Confirm it is the slot you intend to overwrite; make a backup elsewhere.")
    print("3) Follow the documented glitch only if it still works on this server; the hub does not automate save/load.")
end)

-- SHOP AUTO BUY V1
label(shop,"AUTO BUY — BUILD A BOAT FOR TREASURE")
label(shop,"Enter the exact item name shown in the in-game shop. Bulk purchase supports up to 1000 per request.")
shopItemInput=create("TextBox",{Size=UDim2.new(1,-8,0,40),BackgroundColor3=DARK,Text="Note",PlaceholderText="Exact shop item name (e.g. Note)",TextColor3=WHITE,TextSize=14,Font=Enum.Font.Gotham,ClearTextOnFocus=false},shop)
round(shopItemInput,8)
outline(shopItemInput)
label(shop,"QUANTITY (1–1000)")
shopQuantityInput=create("TextBox",{Size=UDim2.new(1,-8,0,40),BackgroundColor3=DARK,Text="100",PlaceholderText="Quantity",TextColor3=WHITE,TextSize=14,Font=Enum.Font.Gotham,ClearTextOnFocus=false},shop)
round(shopQuantityInput,8)
outline(shopQuantityInput)
shopBuyStatus=label(shop,"SHOP: ready")
shopBuying=false
shopAutoEnabled=false
shopAutoButton = nil
function getShopPurchaseArgs()
    local itemName=shopItemInput.Text:gsub("^%s+",""):gsub("%s+$","")
    local quantity=tonumber(shopQuantityInput.Text)
    if itemName=="" then return nil,nil,"SHOP: enter an item name" end
    if not quantity or quantity%1~=0 or quantity<1 or quantity>1000 then
        return nil,nil,"SHOP: quantity must be a whole number from 1 to 1000"
    end
    return itemName,quantity,nil
end
function getShopRemote()
    local remote=Workspace:FindFirstChild("ItemBoughtFromShop")
    if not remote then return nil,"SHOP: purchase remote not found" end
    if not remote:IsA("RemoteFunction") then return nil,"SHOP: unexpected remote type" end
    return remote
end
button(shop,"BUY SELECTED ITEM × QUANTITY",function()
    if shopBuying then shopBuyStatus.Text="SHOP: purchase already in progress"; return end
    local itemName,quantity,err=getShopPurchaseArgs()
    if err then shopBuyStatus.Text=err; return end
    local remote,remoteErr=getShopRemote()
    if not remote then shopBuyStatus.Text=remoteErr; warn("[DIAMOND SHOP]",remoteErr); return end
    shopBuying=true
    shopBuyStatus.Text=string.format("SHOP: buying %d × %s...",quantity,itemName)
    task.spawn(function()
        local ok,result=pcall(function() return remote:InvokeServer(itemName,quantity) end)
        shopBuying=false
        if ok then
            shopBuyStatus.Text=string.format("SHOP: request sent — %d × %s",quantity,itemName)
            print("[DIAMOND SHOP] Purchase request:",itemName,"quantity:",quantity,"server response:",tostring(result))
        else
            shopBuyStatus.Text="SHOP: purchase failed — see F9"
            warn("[DIAMOND SHOP] Purchase failed:",tostring(result))
        end
    end)
end)
shopAutoButton=button(shop,"AUTO BUY: OFF",function()
    if shopAutoEnabled then
        shopAutoEnabled=false
        shopAutoButton.Text="AUTO BUY: OFF"
        shopBuyStatus.Text="SHOP: auto-buy stopped"
        return
    end
    local itemName,quantity,err=getShopPurchaseArgs()
    if err then shopBuyStatus.Text=err; return end
    local remote,remoteErr=getShopRemote()
    if not remote then shopBuyStatus.Text=remoteErr; warn("[DIAMOND SHOP]",remoteErr); return end
    shopAutoEnabled=true
    shopAutoButton.Text="AUTO BUY: ON"
    shopBuyStatus.Text="SHOP: auto-buy running — "..itemName
    task.spawn(function()
        while shopAutoEnabled do
            if not shopBuying then
                local currentName,currentQuantity,currentErr=getShopPurchaseArgs()
                if currentErr then
                    shopAutoEnabled=false
                    shopAutoButton.Text="AUTO BUY: OFF"
                    shopBuyStatus.Text=currentErr
                    break
                end
                local currentRemote,currentRemoteErr=getShopRemote()
                if not currentRemote then
                    shopAutoEnabled=false
                    shopAutoButton.Text="AUTO BUY: OFF"
                    shopBuyStatus.Text=currentRemoteErr
                    warn("[DIAMOND SHOP]",currentRemoteErr)
                    break
                end
                shopBuying=true
                local ok,result=pcall(function()
                    return currentRemote:InvokeServer(currentName,currentQuantity)
                end)
                shopBuying=false
                if not ok then
                    shopAutoEnabled=false
                    shopAutoButton.Text="AUTO BUY: OFF"
                    shopBuyStatus.Text="SHOP: auto-buy failed — see F9"
                    warn("[DIAMOND SHOP] Auto-buy failed:",tostring(result))
                    break
                end
                print("[DIAMOND SHOP] Auto purchase:",currentName,"quantity:",currentQuantity,"server response:",tostring(result))
                shopBuyStatus.Text=string.format("SHOP: auto-buy sent %d × %s",currentQuantity,currentName)
            end
            task.wait(2)
        end
    end)
end)
label(shop,"AUTO BUY repeats the selected quantity every 2 seconds until switched OFF. Watch your gold; the game server still validates every purchase.")
label(shop,"The game server checks the item, price and your gold. This does not bypass payment or guarantee stock.")

-- AUTO FARM V10
label(farm,"AUTO FARM GOLD V10")
label(farm,"Continuous fast route: no idle pauses between stages. Respawn and server registration checks remain.")

farmEnabled=false
farmRunId=0
farmDelay=1.25

function farmLog(...)
    print("[DIAMOND AUTO FARM V10]",...)
end

function farmGet()
    local boatStages=Workspace:FindFirstChild("BoatStages")
    local normal=boatStages and boatStages:FindFirstChild("NormalStages")
    if not normal then return nil,nil,nil,nil,"Workspace.BoatStages.NormalStages not found" end
    local finish=normal:FindFirstChild("TheEnd")
    local chest=finish and finish:FindFirstChild("GoldenChest")
    local trigger=chest and chest:FindFirstChild("Trigger")
    local other=Player:FindFirstChild("OtherData")
    local claim=Workspace:FindFirstChild("ClaimRiverResultsGold")
    if not trigger or not trigger:IsA("BasePart") then return normal,nil,other,claim,"GoldenChest.Trigger missing" end
    if not other then return normal,trigger,nil,claim,"LocalPlayer.OtherData missing" end
    if not claim or not claim:IsA("RemoteEvent") then return normal,trigger,other,nil,nil end
    return normal,trigger,other,claim,nil
end

function farmCharacter()
    local char=Player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return char,root,hum
end

function farmWaitAlive(runId,timeout)
    local deadline=os.clock()+(timeout or 25)
    while farmEnabled and runId==farmRunId and os.clock()<deadline do
        local char,root,hum=farmCharacter()
        if char and root and hum and hum.Health>0 then return char,root,hum end
        task.wait(0.15)
    end
    return nil
end

function farmStageValue(other,index)
    local v=other:FindFirstChild("Stage"..index)
    return v and v.Value or nil
end

function farmHasProgress(value)
    return value~=nil and value~="" and value~=false and value~=0
end

function farmWaitStage(other,index,oldValue,runId,timeout)
    local v=other:FindFirstChild("Stage"..index)
    if not v then return false,"OtherData.Stage"..index.." missing" end
    local deadline=os.clock()+(timeout or 18)
    while farmEnabled and runId==farmRunId and os.clock()<deadline do
        if farmHasProgress(v.Value) and (v.Value~=oldValue or not farmHasProgress(oldValue)) then
            return true
        end
        -- If this character died while the stage registered, wait for respawn
        -- before the next teleport. Do not race ahead with a dead character.
        local char,root,hum=farmCharacter()
        if not char or not root or not hum or hum.Health<=0 then
            farmLog("Died during stage",index+1,"— waiting for respawn")
            local newChar=farmWaitAlive(runId,25)
            if not newChar then return false,"Respawn timeout" end
        end
        task.wait(0.03)
    end
    return false,"Stage progress timeout"
end

function farmNudge(runId)
    local char,root,hum=farmWaitAlive(runId,15)
    if not root then return false end
    local base=root.CFrame
    root.CFrame=base*CFrame.new(-10,0,-10)
    task.wait(0.03)
    if not farmEnabled or runId~=farmRunId then return false end
    char,root,hum=farmWaitAlive(runId,15)
    if not root then return false end
    root.CFrame=base
    return true
end

function farmTouchChest(trigger,runId)
    local char,root,hum=farmWaitAlive(runId,20)
    if not root then return false end
    local chestCF=trigger.CFrame*CFrame.new(-5,-1.7,0)*CFrame.Angles(0,math.rad(-90),0)
    char:PivotTo(chestCF)
    task.wait(0.03)
    if typeof(firetouchinterest)=="function" then
        local ok,err=pcall(function()
            firetouchinterest(root,trigger,1)
            task.wait(0.03)
            firetouchinterest(root,trigger,0)
        end)
        if not ok then farmLog("Touch error:",err) end
        return ok
    end
    -- Fallback: stand directly on the trigger; normal game touch handling may activate it.
    char:PivotTo(trigger.CFrame*CFrame.new(0,3,0))
    return true
end

function farmWaitReset(other,runId)
    local deadline=os.clock()+25
    while farmEnabled and runId==farmRunId and os.clock()<deadline do
        local cleared=true
        for i=0,9 do
            local v=other:FindFirstChild("Stage"..i)
            if v and farmHasProgress(v.Value) then cleared=false break end
        end
        if cleared then return true end
        task.wait(0.2)
    end
    return false
end

farmHoldVelocity=nil
function farmFlyTo(root,targetCFrame,runId)
    if farmHoldVelocity then pcall(function() farmHoldVelocity:Destroy() end) end
    farmHoldVelocity=nil
    if not root or not root.Parent then return false end
    local distance=(root.Position-targetCFrame.Position).Magnitude
    local duration=math.clamp(distance/150,0.08,0.45)
    local tween=TweenService:Create(root,TweenInfo.new(duration,Enum.EasingStyle.Linear),{CFrame=targetCFrame})
    tween:Play()
    local finished=false
    local connection=tween.Completed:Connect(function() finished=true end)
    local deadline=os.clock()+duration+1
    while not finished and os.clock()<deadline do
        if not farmEnabled or runId~=farmRunId or not root.Parent then
            pcall(function() tween:Cancel() end)
            connection:Disconnect()
            return false
        end
        RunService.Heartbeat:Wait()
    end
    connection:Disconnect()
    return finished
end
function farmHold(root)
    if farmHoldVelocity then pcall(function() farmHoldVelocity:Destroy() end) end
    farmHoldVelocity=nil
    if not root or not root:IsA("BasePart") then return end
    local hold=Instance.new("BodyVelocity")
    hold.Name="DiamondFarmHover"
    hold.Velocity=Vector3.zero
    hold.MaxForce=Vector3.new(1e9,1e9,1e9)
    hold.P=1e5
    hold.Parent=root
    farmHoldVelocity=hold
end
function farmRelease()
    if farmHoldVelocity then pcall(function() farmHoldVelocity:Destroy() end) end
    farmHoldVelocity=nil
end

function runFarm(runId)
    local normal,chest,other,claim,err=farmGet()
    if err then farmLog("STOP:",err); farmEnabled=false; return end
    if not farmWaitAlive(runId,25) then farmLog("Character unavailable"); farmEnabled=false; return end

    -- Controlled pacing: allow the game to register each stage before moving on.
    for i=1,10 do
        if not farmEnabled or runId~=farmRunId then return end
        local stage=normal:FindFirstChild("CaveStage"..i)
        local dark=stage and stage:FindFirstChild("DarknessPart")
        local event=dark and dark:FindFirstChild("Event")
        if not dark or not dark:IsA("BasePart") then
            farmLog("Missing CaveStage"..i..".DarknessPart"); farmEnabled=false; return
        end
        if not event or not event:IsA("BindableEvent") then
            farmLog("Missing BindableEvent at",dark:GetFullName()..".Event"); farmEnabled=false; return
        end

        local char,root,hum=farmWaitAlive(runId,20)
        if not root then farmLog("No live character at stage",i); farmEnabled=false; return end

        local progress=other:FindFirstChild("Stage"..(i-1))
        local oldValue=progress and progress.Value or nil

        -- Fly to the stage, then physically touch its trigger. A client-side
        -- BindableEvent alone does not guarantee that the server records it.
        if not farmFlyTo(root,dark.CFrame*CFrame.new(0,1.5,0),runId) then return end
        farmHold(root)
        -- No idle pause at stage: trigger immediately after arrival.
        if not farmEnabled or runId~=farmRunId then return end
        pcall(function() event:Fire() end)
        if typeof(firetouchinterest)=="function" then
            pcall(function()
                firetouchinterest(root,dark,0)
                task.wait(0.03)
                firetouchinterest(root,dark,1)
            end)
        end

        local confirmed=false
        if progress then
            local deadline=os.clock()+6
            while farmEnabled and runId==farmRunId and os.clock()<deadline do
                if farmHasProgress(progress.Value) and
                    (progress.Value~=oldValue or not farmHasProgress(oldValue)) then
                    confirmed=true
                    break
                end
                task.wait(0.03)
            end
        end
        if not confirmed and typeof(firetouchinterest)=="function" then
            farmLog("Stage",i,"not confirmed; retrying touch")
            pcall(function()
                firetouchinterest(root,dark,0)
                task.wait(0.03)
                firetouchinterest(root,dark,1)
            end)
            if progress then
                local deadline=os.clock()+4
                while farmEnabled and runId==farmRunId and os.clock()<deadline do
                    if farmHasProgress(progress.Value) and
                        (progress.Value~=oldValue or not farmHasProgress(oldValue)) then
                        confirmed=true
                        break
                    end
                    task.wait(0.03)
                end
            end
        end
        farmLog("Stage",i,confirmed and "CONFIRMED" or "progress not detected","; continuing immediately")
    end

    if not farmEnabled or runId~=farmRunId then return end
    local char,root,hum=farmWaitAlive(runId,20)
    if not root then farmLog("No live character before chest"); farmEnabled=false; return end

    farmLog("All stage triggers sent; moving to Golden Chest.")
    if not farmEnabled or runId~=farmRunId then return end

    -- Connect the respawn listener BEFORE touching the chest so a fast reset is not missed.
    local oldCharacter=Player.Character
    local respawned=false
    local conn=Player.CharacterAdded:Connect(function(newChar)
        if newChar~=oldCharacter then respawned=true end
    end)

    char,root,hum=farmCharacter()
    if not char or not root or not hum or hum.Health<=0 then
        conn:Disconnect()
        farmLog("No live character at chest")
        farmEnabled=false
        return
    end

    farmLog("Teleporting to Golden Chest trigger.")
    if not farmFlyTo(root,chest.CFrame*CFrame.new(0,3,0),runId) then conn:Disconnect(); return end
    farmHold(root)
    if not farmEnabled or runId~=farmRunId then conn:Disconnect(); return end

    char,root,hum=farmCharacter()
    if root and hum and hum.Health>0 and typeof(firetouchinterest)=="function" then
        pcall(function()
            firetouchinterest(root,chest,0)
            task.wait(0.15)
            firetouchinterest(root,chest,1)
        end)
        farmLog("Chest touch sent; checking game response immediately.")
        RunService.Heartbeat:Wait()
    elseif root and hum and hum.Health>0 then
        farmLog("firetouchinterest unavailable; allowing natural chest contact.")
        RunService.Heartbeat:Wait()
    end

    -- If the chest kills/resets the avatar, wait for the respawn before claiming.
    local deadline=os.clock()+20
    while farmEnabled and runId==farmRunId and not respawned and os.clock()<deadline do
        local c=Player.Character
        if c and c~=oldCharacter then respawned=true break end
        task.wait(0.03)
    end
    conn:Disconnect()
    if not farmEnabled or runId~=farmRunId then return end

    if claim and claim:IsA("RemoteEvent") then
        pcall(function() claim:FireServer() end)
        farmLog("Reward claim request sent")
    else
        farmLog("Chest trigger reached; no claim remote found")
    end
    farmRelease()
    farmLog("Route finished. Chest response processed; checking reward before next cycle.")
end

button(farm,"START AUTO FARM",function()
    if farmEnabled then farmLog("Already running"); return end
    local _,_,_,_,err=farmGet()
    if err then farmLog("Cannot start:",err); return end
    farmEnabled=true
    farmRunId+=1
    local id=farmRunId
    farmLog("Started")
    task.spawn(function()
        while farmEnabled and id==farmRunId do
            runFarm(id)
            if farmEnabled and id==farmRunId then RunService.Heartbeat:Wait() end
        end
        farmLog("Stopped")
    end)
end)

button(farm,"STOP AUTO FARM",function()
    farmEnabled=false
    farmRunId+=1
    farmRelease()
    farmLog("Stop requested")
end)

button(farm,"SCAN FARM ROUTE",function()
    local normal,chest,other,claim,err=farmGet()
    if err then farmLog("SCAN:",err); return end
    for i=1,10 do
        local stage=normal:FindFirstChild("CaveStage"..i)
        local dark=stage and stage:FindFirstChild("DarknessPart")
        local event=dark and dark:FindFirstChild("Event")
        local value=other:FindFirstChild("Stage"..(i-1))
        farmLog("Stage",i,"Part:",dark and dark:GetFullName() or "MISSING",
            "Event:",event and event.ClassName or "MISSING",
            "Progress:",value and tostring(value.Value) or "MISSING")
    end
    farmLog("Chest:",chest:GetFullName(),"Claim:",claim and claim:GetFullName() or "MISSING")
end)

-- TOOLS

label(tools,"Game diagnostics")
label(tools,"DIAGNOSTICS V3: вывод в консоль F9")

function printInstanceDetails(obj, prefix)
    print(prefix, obj:GetFullName(), obj.ClassName)
    local attrs = obj:GetAttributes()
    for k,v in pairs(attrs) do
        print("  [ATTRIBUTE]", k, v)
    end
    for _,v in ipairs(obj:GetChildren()) do
        if v:IsA("StringValue") or v:IsA("IntValue") or v:IsA("NumberValue")
        or v:IsA("BoolValue") or v:IsA("ObjectValue") then
            local value = v.Value
            if typeof(value) == "Instance" then value = value:GetFullName() end
            print("  [VALUE]", v.Name, value)
        end
    end
end

button(tools,"FULL GAME STRUCTURE SCAN",function()
    local roots = {Workspace, ReplicatedStorage, game:GetService("ReplicatedFirst")}
    local count = 0
    local keywords = {"boat","plot","base","ship","stage","chest","treasure","finish","gold","build","block","place","claim","reward"}
    for _,rootFolder in ipairs(roots) do
        print("\\n========== ROOT:",rootFolder.Name,"==========")
        for _,obj in ipairs(rootFolder:GetDescendants()) do
            local name = obj.Name:lower()
            local match = false
            for _,word in ipairs(keywords) do
                if name:find(word,1,true) then match = true break end
            end
            if match and count < 250 then
                count += 1
                printInstanceDetails(obj,"[MATCH]")
            end
        end
    end
    print("[DIAGNOSTIC] Matching objects printed:",count,"(limit 250)")
    print("[DIAGNOSTIC] Open Developer Console with F9 and copy output.")
end)

button(tools,"SCAN REMOTES (BUILD + REWARDS)",function()
    local count = 0
    local words = {"build","place","block","boat","plot","chest","treasure","gold","claim","reward","stage","unlock"}
    for _,rootFolder in ipairs({ReplicatedStorage,game:GetService("ReplicatedFirst")}) do
        for _,obj in ipairs(rootFolder:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                local name = obj.Name:lower()
                for _,word in ipairs(words) do
                    if name:find(word,1,true) then
                        count += 1
                        print("[REMOTE]",obj:GetFullName(),obj.ClassName)
                        break
                    end
                end
            end
        end
    end
    print("[REMOTE SCAN] Matches:",count)
end)

button(tools,"SCAN INTERACTION OBJECTS",function()
    local count = 0
    for _,obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") then
            count += 1
            if count <= 150 then
                print("[INTERACTION]",obj:GetFullName(),obj.ClassName)
                if obj:IsA("ProximityPrompt") then
                    print("  ActionText:",obj.ActionText,"ObjectText:",obj.ObjectText,"HoldDuration:",obj.HoldDuration)
                end
            end
        end
    end
    print("[INTERACTION SCAN] Matches:",count,"(limit 150)")
end)

button(tools,"SCAN MY CHARACTER + PLAYER DATA",function()
    local char,hum,root = getCharacter()
    print("[PLAYER]",Player.Name,"UserId:",Player.UserId)
    for k,v in pairs(Player:GetAttributes()) do print("[PLAYER ATTRIBUTE]",k,v) end
    if char then
        printInstanceDetails(char,"[CHARACTER]")
        if hum then print("[HUMANOID] Health:",hum.Health,"WalkSpeed:",hum.WalkSpeed,"JumpPower:",hum.JumpPower) end
        if root then print("[ROOT POSITION]",root.Position) end
    end
end)

button(tools,"COPY DIAGNOSTIC INSTRUCTIONS",function()
    print("DIAMOND BOAT HUB V1 [BETA]: press F9, open Client log, run FULL GAME STRUCTURE SCAN, SCAN REMOTES and SCAN INTERACTION OBJECTS. Copy the output.")
end)


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
label(settings,"Window size")

function setWindowMode(mode)
    windowMode=mode
    fitToScreen()
    print("[DIAMOND] Window size:",mode)
end
button(settings,"Window: Small",function() setWindowMode("small") end)
button(settings,"Window: Medium",function() setWindowMode("medium") end)
button(settings,"Window: Large",function() setWindowMode("large") end)
button(settings,"Window: Full screen",function()
    windowMode="fullscreen"
    fitToScreen()
end)
button(settings,"Reset window size",function() setWindowMode(isTouchDevice and "large" or "medium") end)

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
label(settings,"Appearance / Внешний вид")
themes={
    Purple={main=Color3.fromRGB(130,90,255),panel=Color3.fromRGB(27,27,40),dark=Color3.fromRGB(17,17,25)},
    Cyan={main=Color3.fromRGB(0,190,220),panel=Color3.fromRGB(20,38,48),dark=Color3.fromRGB(10,20,28)},
    Red={main=Color3.fromRGB(235,75,90),panel=Color3.fromRGB(48,27,34),dark=Color3.fromRGB(24,14,19)},
    Green={main=Color3.fromRGB(65,190,125),panel=Color3.fromRGB(24,43,36),dark=Color3.fromRGB(13,24,19)},
    Gold={main=Color3.fromRGB(220,170,55),panel=Color3.fromRGB(48,40,25),dark=Color3.fromRGB(25,21,14)}
}
currentTheme="Purple"
function applyTheme(name)
    local t=themes[name]
    if not t then return end
    currentTheme=name
    PURPLE=t.main; PANEL=t.panel; DARK=t.dark
    Main.BackgroundColor3=DARK
    Top.BackgroundColor3=DARK
    Sidebar.BackgroundColor3=PANEL
    Content.BackgroundColor3=PANEL
    for _,obj in ipairs(GUI:GetDescendants()) do
        if obj:IsA("UIStroke") then
            obj.Color=PURPLE
        elseif obj:IsA("ScrollingFrame") then
            obj.ScrollBarImageColor3=PURPLE
        elseif obj:IsA("TextButton") and obj:GetAttribute("HubStyledButton") then
            local stroke=obj:FindFirstChildOfClass("UIStroke")
            local accent=obj:FindFirstChildWhichIsA("Frame")
            if stroke then stroke.Color=PURPLE end
            if accent then accent.BackgroundColor3=PURPLE end
        elseif obj.Name=="ActiveMark" then
            obj.BackgroundColor3=PURPLE
        end
    end
    for _,b in pairs(TabButtons) do
        local active=(CurrentPage and b==TabButtons[CurrentPage])
        b.BackgroundColor3=active and t.main or Color3.fromRGB(35,35,44)
        b.TextColor3=WHITE
        local icon=b:FindFirstChild("TabIcon")
        if icon then icon.ImageColor3=WHITE end
    end
    Min.BackgroundColor3=PURPLE
    Min.TextColor3=WHITE
    Close.BackgroundColor3=PURPLE
    Close.TextColor3=WHITE
    print("[DIAMOND] Theme:",name)
end
button(settings,"Theme: Purple",function() applyTheme("Purple") end)
button(settings,"Theme: Cyan",function() applyTheme("Cyan") end)
button(settings,"Theme: Red",function() applyTheme("Red") end)
button(settings,"Theme: Green",function() applyTheme("Green") end)
button(settings,"Theme: Gold",function() applyTheme("Gold") end)
button(settings,"Reset appearance",function() applyTheme("Purple") end)
label(settings,"GUI STYLE / СТИЛЬ ИНТЕРФЕЙСА")
button(settings,"Style: Modern",function() setButtonStyle("Modern") end)
button(settings,"Style: Liquid Glass (iPhone)",function() setButtonStyle("Liquid Glass") end)
button(settings,"Style: Neon",function() setButtonStyle("Neon") end)
label(settings,"ANIMATED BACKGROUND / ФОН")
backgroundMode="Aurora"
seasonalSnow=false
backgroundPresets={
    Aurora=ColorSequence.new(Color3.fromRGB(15,10,42),Color3.fromRGB(20,75,90)),
    Ocean=ColorSequence.new(Color3.fromRGB(4,24,58),Color3.fromRGB(0,120,145)),
    Sunset=ColorSequence.new(Color3.fromRGB(65,18,55),Color3.fromRGB(210,95,45)),
    Matrix=ColorSequence.new(Color3.fromRGB(0,24,12),Color3.fromRGB(0,100,48)),
    Mono=ColorSequence.new(Color3.fromRGB(8,8,12),Color3.fromRGB(60,60,72)),
    Winter=ColorSequence.new(Color3.fromRGB(5,28,58),Color3.fromRGB(75,155,205)),
    Christmas=ColorSequence.new(Color3.fromRGB(18,55,43),Color3.fromRGB(125,25,42))
}
function setBackgroundMode(name)
    if not backgroundPresets[name] then return end
    backgroundMode=name
    seasonalSnow=(name=="Winter" or name=="Christmas")
    if backgroundGradient then
        backgroundGradient.Color=backgroundPresets[name]
        backgroundGradient.Enabled=true
    end
    if mainBackgroundGradient then
        mainBackgroundGradient.Color=backgroundPresets[name]
        mainBackgroundGradient.Enabled=true
    end
    if BackgroundLayer then BackgroundLayer.Visible=true end
    if snowLayer then snowLayer.Visible=seasonalSnow end
    print("[DIAMOND] Background:",name)
end
for _,name in ipairs({"Aurora","Ocean","Sunset","Matrix","Mono","Winter","Christmas"}) do
    button(settings,"Background: "..name,function() setBackgroundMode(name) end)
end
button(settings,"Animated background: ON / OFF",function()
    animatedBackground=not animatedBackground
    if backgroundGradient then backgroundGradient.Enabled=true end
    if mainBackgroundGradient then mainBackgroundGradient.Enabled=true end
    if BackgroundLayer then BackgroundLayer.Visible=true end
end)
label(settings,"PLAYER TAG PREFIX")
prefixBox=create("TextBox",{Size=UDim2.new(1,-8,0,38),BackgroundColor3=Color3.fromRGB(24,24,31),TextColor3=WHITE,PlaceholderText="Your prefix",Text=playerPrefix,ClearTextOnFocus=false,Font=Enum.Font.Gotham,TextSize=13},settings)
round(prefixBox,9)
local function censorPrefixText(value)
    value=tostring(value or "")
    value=string.sub(value,1,16)
    -- Basic client-side profanity mask. This is only a convenience filter,
    -- not Roblox's official server-side TextService moderation.
    local blocked={"сука","блять","бляд","хуй","пизд","еба","fuck","shit","bitch","asshole"}
    local lower=string.lower(value)
    for _,word in ipairs(blocked) do
        local startAt=1
        while true do
            local a,b=string.find(lower,word,startAt,true)
            if not a then break end
            value=string.sub(value,1,a-1)..string.rep("*",b-a+1)..string.sub(value,b+1)
            lower=string.lower(value)
            startAt=b+1
        end
    end
    return value
end
prefixBox.FocusLost:Connect(function()
    playerPrefix=censorPrefixText(prefixBox.Text)
    prefixBox.Text=playerPrefix
    refreshPlayerTags()
end)
label(settings,"PREFIX COLOR / ЦВЕТ ПРЕФИКСА")
for _,choice in ipairs({
    {"White",Color3.fromRGB(255,255,255)},{"Red",Color3.fromRGB(255,75,75)},
    {"Orange",Color3.fromRGB(255,150,55)},{"Yellow",Color3.fromRGB(255,225,70)},
    {"Green",Color3.fromRGB(70,230,120)},{"Cyan",Color3.fromRGB(55,220,255)},
    {"Blue",Color3.fromRGB(80,130,255)},{"Purple",Color3.fromRGB(180,100,255)},
    {"Pink",Color3.fromRGB(255,110,190)},{"Gold",Color3.fromRGB(255,195,65)}
}) do
    local colorButton=button(settings,"●  "..choice[1],function()
        prefixColor=choice[2]
        refreshPlayerTags()
        print("[DIAMOND] Prefix color:",choice[1])
    end)
    colorButton.TextColor3=choice[2]
end
label(settings,"PREFIX CENSOR / ЦЕНЗУРА")
label(settings,"Нецензурные слова в пользовательском префиксе частично заменяются звёздочками. Это локальная базовая проверка, не официальная фильтрация Roblox.")
label(settings,"PREFIX VISIBILITY")
label(settings,"Префиксы этого executor видны локально. Чтобы все пользователи скрипта видели друг друга, нужен серверный обмен данными и Roblox TextService; клиентский скрипт не может безопасно создать такую репликацию.")


-- Dedicated animated background layer. Keep every large panel translucent
-- so the gradient is actually visible behind the pages.
Main.BackgroundTransparency=0
mainBackgroundGradient=Main:FindFirstChildOfClass("UIGradient")
BackgroundLayer=create("Frame",{
    Name="AnimatedBackground",Size=UDim2.new(1,0,1,0),Position=UDim2.fromOffset(0,0),
    BackgroundColor3=Color3.fromRGB(8,12,25),BorderSizePixel=0,ZIndex=0
},Main)
backgroundGradient=create("UIGradient",{
    Color=backgroundPresets[backgroundMode] or backgroundPresets.Aurora,
    Rotation=0,
    Offset=Vector2.new(-0.35,0)
},BackgroundLayer)
Top.BackgroundTransparency=0.12
Sidebar.BackgroundTransparency=0.32
Content.BackgroundTransparency=0.38
snowLayer=create("Frame",{
    Name="SeasonalSnow",Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    ClipsDescendants=true,Visible=false,ZIndex=1
},Main)
for i=1,20 do
    local flake=create("TextLabel",{
        Name="Snowflake"..i,BackgroundTransparency=1,Text="❄",
        TextColor3=Color3.fromRGB(225,242,255),TextTransparency=0.18,
        TextSize=math.random(10,19),Font=Enum.Font.GothamBold,
        Size=UDim2.fromOffset(22,22),
        Position=UDim2.new(math.random(),0,math.random(),0),
        ZIndex=1
    },snowLayer)
    task.spawn(function()
        while GUI.Parent and flake.Parent do
            flake.Position=UDim2.new(math.random(),0,-0.08,0)
            flake.TextTransparency=math.random(5,35)/100
            local fall=TweenService:Create(flake,TweenInfo.new(math.random(65,115)/10,Enum.EasingStyle.Linear),{
                Position=UDim2.new(math.clamp(flake.Position.X.Scale+math.random(-12,12)/100,0,1),0,1.08,0)
            })
            fall:Play()
            fall.Completed:Wait()
            task.wait(math.random(0,12)/10)
        end
    end)
end
snowLayer.Visible=seasonalSnow
task.spawn(function()
    while GUI.Parent do
        if animatedBackground and mainBackgroundGradient and mainBackgroundGradient.Parent then
            local first=TweenService:Create(mainBackgroundGradient,TweenInfo.new(7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
                Rotation=180,Offset=Vector2.new(0.35,0)
            })
            first:Play(); first.Completed:Wait()
            if not GUI.Parent then break end
            local second=TweenService:Create(mainBackgroundGradient,TweenInfo.new(7,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{
                Rotation=360,Offset=Vector2.new(-0.35,0)
            })
            second:Play(); second.Completed:Wait()
        else
            task.wait(0.35)
        end
    end
end)

-- Local-only overhead labels; executor clients cannot replicate tags to other clients.
playerTagConnections={}
refreshPlayerTags=function()
    for _,plr in ipairs(Players:GetPlayers()) do
        local char=plr.Character
        local head=char and char:FindFirstChild("Head")
        if head then
            local old=head:FindFirstChild("DiamondPlayerTag")
            if old then old:Destroy() end
            local role,roleColor
            if plr.UserId==7162643277 then role,roleColor="OWNER",Color3.fromRGB(255,65,65)
            elseif plr.UserId==4918761384 then role,roleColor="SCRIPT DEV",Color3.fromRGB(255,205,45) end
            local prefix=(plr.UserId==Player.UserId and playerPrefix or "Player")
            local tag=Instance.new("BillboardGui")
            tag.Name="DiamondPlayerTag"; tag.Size=UDim2.fromOffset(170,role and 42 or 24)
            tag.StudsOffset=Vector3.new(0,role and 3.1 or 2.8,0)
            tag.AlwaysOnTop=true; tag.MaxDistance=120; tag.Adornee=head; tag.Parent=head
            local prefixLabel=Instance.new("TextLabel")
            prefixLabel.Size=UDim2.new(1,0,0,role and 20 or 24)
            prefixLabel.Position=UDim2.fromOffset(0,0); prefixLabel.BackgroundTransparency=1
            prefixLabel.Text=(role and prefix~="" and prefix or (role and "" or "{"..prefix.."}"))
            prefixLabel.TextColor3=prefixColor or Color3.fromRGB(185,205,255); prefixLabel.TextStrokeTransparency=0.35
            prefixLabel.Font=Enum.Font.GothamBold; prefixLabel.TextSize=13; prefixLabel.Parent=tag
            if plr.UserId==7162643277 or plr.UserId==4918761384 then
                prefixLabel.TextColor3=Color3.new(1,1,1)
                local rainbow=Instance.new("UIGradient")
                rainbow.Name="DiamondRainbowPrefix"
                rainbow.Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,55,85)),
                    ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,170,45)),
                    ColorSequenceKeypoint.new(0.34,Color3.fromRGB(255,245,75)),
                    ColorSequenceKeypoint.new(0.51,Color3.fromRGB(55,235,125)),
                    ColorSequenceKeypoint.new(0.68,Color3.fromRGB(55,180,255)),
                    ColorSequenceKeypoint.new(0.85,Color3.fromRGB(175,85,255)),
                    ColorSequenceKeypoint.new(1,Color3.fromRGB(255,55,170))
                })
                rainbow.Parent=prefixLabel
                task.spawn(function()
                    while rainbow.Parent and tag.Parent do
                        local spin=TweenService:Create(rainbow,TweenInfo.new(3,Enum.EasingStyle.Linear),{Rotation=360})
                        spin:Play()
                        spin.Completed:Wait()
                        if rainbow.Parent then rainbow.Rotation=0 end
                    end
                end)
            end
            if role then
                local roleLabel=Instance.new("TextLabel")
                roleLabel.Size=UDim2.new(1,0,0,20); roleLabel.Position=UDim2.fromOffset(0,19)
                roleLabel.BackgroundTransparency=1; roleLabel.Text=role
                roleLabel.TextColor3=roleColor; roleLabel.TextStrokeTransparency=0.3
                roleLabel.Font=Enum.Font.GothamBlack; roleLabel.TextSize=13; roleLabel.Parent=tag
            end
        end
    end
end
function addDiamondPlayerTag(plr)
    if playerTagConnections[plr] then playerTagConnections[plr]:Disconnect() end
    playerTagConnections[plr]=plr.CharacterAdded:Connect(function()
        task.wait(0.25)
        refreshPlayerTags()
    end)
    task.defer(refreshPlayerTags)
end
for _,plr in ipairs(Players:GetPlayers()) do addDiamondPlayerTag(plr) end
Players.PlayerAdded:Connect(addDiamondPlayerTag)
Players.PlayerRemoving:Connect(function(plr)
    if playerTagConnections[plr] then playerTagConnections[plr]:Disconnect(); playerTagConnections[plr]=nil end
end)

-- CHAT tab removed: no in-game chat bypass or duplicate chat UI.

-- CREDITS PAGE
label(credits,"DIAMOND BABFT")
label(credits,"Script creators")
label(credits,"Gfhkm_20")
label(credits,"Xone42_2")
button(credits,"OPEN TELEGRAM CHANNEL",function()
    local url="https://t.me/diamond_scripts"
    local opened=false
    local ok=pcall(function()
        local guiService=game:GetService("GuiService")
        assert(type(guiService.OpenBrowserWindow)=="function","browser API unavailable")
        guiService:OpenBrowserWindow(url)
        opened=true
    end)
    if not opened then
        local copied=false
        if type(setclipboard)=="function" then copied=pcall(setclipboard,url) end
        if copied then
            warn("[DIAMOND] Telegram could not open automatically; link copied: "..url)
        else
            warn("[DIAMOND] Open Telegram manually: "..url)
        end
    end
end)
label(credits,"DIAMOND BOAT HUB V1 [BETA]")

-- DRAG

-- Resize grips: bottom-right corner, right edge and bottom edge. Touch and mouse supported.
resizing=false
resizeStart = nil
resizeStartSize = nil
resizeGrip = nil
function makeResizeGrip(name,size,pos,cursor)
    local grip=create("TextButton",{Name=name,Size=size,Position=pos,BackgroundColor3=PURPLE,BackgroundTransparency=0.12,Text="",AutoButtonColor=false,ZIndex=20,Active=true},Main)
    round(grip,7)
    grip.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            resizing=true
            resizeGrip=name
            resizeStart=input.Position
            resizeStartSize=Vector2.new(Main.AbsoluteSize.X,Main.AbsoluteSize.Y)
        end
    end)
    return grip
end
cornerGrip=makeResizeGrip("ResizeCorner",UDim2.fromOffset(26,26),UDim2.new(1,-26,1,-26))
rightGrip=makeResizeGrip("ResizeRight",UDim2.fromOffset(8,52),UDim2.new(1,-8,0.5,-26))
bottomGrip=makeResizeGrip("ResizeBottom",UDim2.new(0.45,0,0,8),UDim2.new(0.275,0,1,-8))
function applyResize(inputPosition)
    if not resizing or not resizeStart then return end
    local delta=inputPosition-resizeStart
    local cam=Workspace.CurrentCamera
    local viewport=cam and cam.ViewportSize or Vector2.new(1280,720)
    local w,h=resizeStartSize.X,resizeStartSize.Y
    if resizeGrip=="ResizeCorner" or resizeGrip=="ResizeRight" then w=w+delta.X end
    if resizeGrip=="ResizeCorner" or resizeGrip=="ResizeBottom" then h=h+delta.Y end
    local minW=isTouchDevice and 280 or 420
    local minH=isTouchDevice and 340 or 300
    w=math.clamp(w,minW,math.max(minW,viewport.X-16))
    h=math.clamp(h,minH,math.max(minH,viewport.Y-16))
    Main.Size=UDim2.fromOffset(w,h)
    Main.Position=UDim2.new(0.5,-w/2,0.5,-h/2)
    windowMode="custom"
end
UIS.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then applyResize(input.Position) end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then resizing=false; resizeGrip=nil end
end)

dragging=false
dragStart = nil
startAbsolutePosition = nil

DragHandle.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startAbsolutePosition=Main.AbsolutePosition
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch
    ) then
        local delta=input.Position-dragStart
        local cam=Workspace.CurrentCamera
        local scale=MainScale.Scale
        local x=startAbsolutePosition.X+delta.X
        local y=startAbsolutePosition.Y+delta.Y
        if cam then
            local viewport=cam.ViewportSize
            local renderedSize=Main.AbsoluteSize
            x=math.clamp(x,0,math.max(0,viewport.X-renderedSize.X))
            y=math.clamp(y,0,math.max(0,viewport.Y-renderedSize.Y))
        end
        -- UIScale scales offsets too, so convert screen pixels back to GUI offsets.
        Main.Position=UDim2.fromOffset(x/math.max(scale,0.01),y/math.max(scale,0.01))
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

-- MINIMIZE / REOPEN

minimized=false

reopen=create("TextButton",{
    Size=UDim2.fromOffset(55,55),
    Position=UDim2.new(0,15,.5,-25),
    BackgroundColor3=PURPLE,
    Text="💎",
    TextSize=23,
    TextColor3=WHITE,
    Visible=false
},GUI)
round(reopen,50)
outline(reopen)
reopen.AutoButtonColor=false
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(175,130,255),Color3.fromRGB(70,50,175)),Rotation=45},reopen)

-- Drag the floating reopen button with mouse or touch.
reopenDragging=false
reopenDragStart = nil
reopenStartPosition = nil
reopen.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        reopenDragging=true
        reopenDragStart=input.Position
        reopenStartPosition=reopen.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if reopenDragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-reopenDragStart
        local x=reopenStartPosition.X.Offset+delta.X
        local y=reopenStartPosition.Y.Offset+delta.Y
        local cam=Workspace.CurrentCamera
        if cam then
            x=math.clamp(x,0,math.max(0,cam.ViewportSize.X-reopen.AbsoluteSize.X))
            y=math.clamp(y,0,math.max(0,cam.ViewportSize.Y-reopen.AbsoluteSize.Y))
        end
        reopen.Position=UDim2.new(reopenStartPosition.X.Scale,x,reopenStartPosition.Y.Scale,y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then reopenDragging=false end
end)

function animateOpen()
    Main.Visible=true
    reopen.Visible=false
    MainScale.Scale=0.88
    Main.BackgroundTransparency=0.18
    TweenService:Create(MainScale,TweenInfo.new(0.24,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
    TweenService:Create(Main,TweenInfo.new(0.2),{BackgroundTransparency=0}):Play()
end

function animateClose()
    local tween=TweenService:Create(MainScale,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Scale=0.86})
    TweenService:Create(Main,TweenInfo.new(0.16),{BackgroundTransparency=0.2}):Play()
    tween:Play()
    tween.Completed:Once(function()
        Main.Visible=false
        Main.BackgroundTransparency=0
        MainScale.Scale=1
        reopen.Visible=true
        local iconScale=reopen:FindFirstChildOfClass("UIScale") or create("UIScale",{Scale=0.7},reopen)
        iconScale.Scale=0.7
        TweenService:Create(iconScale,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
    end)
end

Min.Activated:Connect(function()
    minimized=not minimized
    Sidebar.Visible=not minimized
    Content.Visible=not minimized
    local target=minimized and UDim2.fromOffset(680,48) or (deviceMode=="phone" and UDim2.new(1,0,1,0) or UDim2.fromOffset(680,470))
    TweenService:Create(Main,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=target}):Play()
    Min.Text=minimized and "+" or "—"
end)

Close.Activated:Connect(animateClose)

reopen.Activated:Connect(animateOpen)

Player.CharacterAdded:Connect(function()
    task.wait(1)
    updateSpeed()
    updateJump()
    if flyOn then stopFly() end
end)

-- FIRST START LANGUAGE MENU + LOCALIZATION
CurrentLanguage="en"
CurrentTranslations={}
function localizeText(value)
    if type(value)~="string" then return value end
    return CurrentTranslations[value] or value
end

Intro=create("Frame",{
    Size=UDim2.fromOffset(390,440),
    Position=UDim2.new(0.5,-195,0.5,-220),
    BackgroundColor3=DARK,
    BorderSizePixel=0,
    ZIndex=50
},GUI)
round(Intro,18)
outline(Intro)
Intro.ClipsDescendants=true
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(18,18,18),Color3.fromRGB(0,0,0)),Rotation=90},Intro)
IntroScale=create("UIScale",{Scale=0.92},Intro)
function fitIntro()
    local cam=Workspace.CurrentCamera
    if not cam then return end
    local viewport=cam.ViewportSize
    -- Keep the complete setup flow (device, language list and Continue) inside
    -- the visible area on both portrait and landscape phones.
    Intro.Size=UDim2.fromOffset(390,540)
    Intro.Position=UDim2.new(0.5,-195,0.5,-270)
    local fitX=(viewport.X-16)/390
    local fitY=(viewport.Y-16)/540
    IntroScale.Scale=math.clamp(math.min(fitX,fitY,1),0.55,1)
end
fitIntro()
if Workspace.CurrentCamera then Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitIntro) end

create("TextLabel",{
    Size=UDim2.new(1,-20,0,48),
    Position=UDim2.fromOffset(10,18),
    BackgroundTransparency=1,
    Text="💎 DIAMOND BOAT HUB V1 [BETA]",
    TextColor3=WHITE,
    TextSize=20,
    Font=Enum.Font.GothamBold,
    ZIndex=51
},Intro)
create("TextLabel",{
    Size=UDim2.new(1,-20,0,30),
    Position=UDim2.fromOffset(10,64),
    BackgroundTransparency=1,
    Text="Choose your language / Выбери язык",
    TextColor3=Color3.fromRGB(205,205,205),
    TextSize=14,
    Font=Enum.Font.Gotham,
    ZIndex=51
},Intro)
create("TextLabel",{
    Size=UDim2.new(1,-30,0,20),
    Position=UDim2.fromOffset(15,91),
    BackgroundTransparency=1,
    Text="1. Choose device  2. Choose language",
    TextColor3=Color3.fromRGB(145,145,145),
    TextSize=11,
    Font=Enum.Font.Gotham,
    ZIndex=51
},Intro)

function deviceButton(caption,y,mode)
    local b=create("TextButton",{
        Size=UDim2.new(1,-44,0,34),Position=UDim2.fromOffset(22,y),
        BackgroundColor3=Color3.fromRGB(35,35,48),Text=caption,
        TextColor3=WHITE,TextSize=13,Font=Enum.Font.GothamBold,
        AutoButtonColor=false,ZIndex=52
    },Intro)
    round(b,9)
    local st=outline(b)
    b.Activated:Connect(function()
        deviceMode=mode
        isTouchDevice=(mode=="phone")
        fitToScreen()
        fitIntro()
        for tabName,tabButton in pairs(TabButtons) do
            tabButton.Size=UDim2.new(0,mode=="phone" and 54 or 58,0,56)
        end
        for _,child in ipairs(Intro:GetChildren()) do
            if child:IsA("TextButton") and child~=b and (child.Name=="DevicePC" or child.Name=="DevicePhone") then
                child.BackgroundColor3=Color3.fromRGB(35,35,48)
            end
        end
        b.BackgroundColor3=PURPLE
        if deviceTitle then deviceTitle.Visible=false end
        if pcDeviceButton then pcDeviceButton.Visible=false end
        if phoneDeviceButton then phoneDeviceButton.Visible=false end
        if languageTitle then languageTitle.Visible=true end
        if languageList then languageList.Visible=true end
        if continueButton then continueButton.Visible=true end
        print("[DIAMOND] Device layout selected:",mode,"Choose a language from the scrolling list.")
    end)
    b.Name=(mode=="phone" and "DevicePhone" or "DevicePC")
    return b
end

function languageButton(caption,y,callback)
    local b=create("TextButton",{
        Size=UDim2.new(1,-44,0,36),
        Position=UDim2.fromOffset(22,y),
        BackgroundColor3=BUTTON_WHITE,
        Text=caption,
        TextColor3=TEXT_DARK,
        TextSize=14,
        Font=Enum.Font.GothamSemibold,
        AutoButtonColor=false,
        ZIndex=51
    },Intro)
    round(b,9)
    local st=outline(b)
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=BUTTON_HOVER}):Play()
        TweenService:Create(st,TweenInfo.new(0.12),{Transparency=0.05}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=BUTTON_WHITE}):Play()
        TweenService:Create(st,TweenInfo.new(0.12),{Transparency=0.35}):Play()
    end)
    b.Activated:Connect(callback)
    return b
end

translations={
ru={
["HOME"]="ГЛАВНАЯ",["MOVEMENT"]="ДВИЖЕНИЕ",["VISUALS"]="ГРАФИКА",["TELEPORTS"]="ТЕЛЕПОРТЫ",["AUTO BUILD"]="АВТОСТРОЙКА",["MUSIC"]="МУЗЫКА",["AUTO FARM"]="АВТОФАРМ",["SHOP"]="МАГАЗИН",["TOOLS"]="ИНСТРУМЕНТЫ",["SETTINGS"]="НАСТРОЙКИ",
["Welcome to Diamond Boat Hub"]="Добро пожаловать в Diamond Boat Hub",["Build A Boat For Treasure"]="Build A Boat For Treasure",["INSTANT REJOIN"]="БЫСТРЫЙ ПЕРЕЗАХОД",["Player information"]="Информация об игроке",["Character information"]="Информация о персонаже",["Reset character"]="Перезапустить персонажа",
["Movement controls"]="Управление движением",["Speed boost"]="Ускорение",["High jump"]="Высокий прыжок",["Infinite jump"]="Бесконечный прыжок",["Fly"]="Полёт",["Noclip"]="Проходить сквозь стены",["Reset movement"]="Сбросить движение",
["Visual settings"]="Настройки графики",["Wide FOV"]="Широкий угол обзора",["Fullbright"]="Полное освещение",["Hide GUI"]="Скрыть интерфейс",["Anti-AFK"]="Анти-АФК",["Low graphics / FPS boost"]="Низкая графика / повышение FPS",
["Position manager"]="Управление позицией",["Save current position"]="Сохранить позицию",["Return to saved position"]="Вернуться к сохранённой позиции",["Move 20 studs upward"]="Переместиться вверх на 20",["Move 20 studs downward"]="Переместиться вниз на 20",["Teleport to nearest spawn"]="Телепорт к ближайшему спавну",["Copy coordinates"]="Копировать координаты",["Stop current movement"]="Остановить движение",
["Base scanner"]="Сканер баз",["Select a candidate and inspect it. Preview is local only."]="Выбери базу для просмотра. Превью видно только тебе.",["Selected base: none"]="Выбранная база: нет",["SCAN BASES"]="СКАНИРОВАТЬ БАЗЫ",["SHOW SELECTED BASE INFO"]="ИНФОРМАЦИЯ О ВЫБРАННОЙ БАЗЕ",["LOCAL COPY PREVIEW"]="ЛОКАЛЬНОЕ ПРЕВЬЮ КОПИИ",["REMOVE LOCAL PREVIEW"]="УДАЛИТЬ ПРЕВЬЮ",["COPY SELECTED PLAYER BASE"]="КОПИРОВАТЬ БАЗУ ИГРОКА",["AUTO BUILD TO MY BASE"]="СТРОИТЬ НА МОЕЙ БАЗЕ",["STOP AUTO BUILD"]="ОСТАНОВИТЬ СТРОЙКУ",["CLEAR BASE SELECTION"]="СБРОСИТЬ ВЫБОР БАЗЫ",["SCAN BUILD REMOTES"]="СКАНИРОВАТЬ REMOTE СТРОИТЕЛЬСТВА",
["SHAPE BUILDER — FILLED"]="ПОСТРОИТЕЛЬ ФИГУР",["FILLED CIRCLE"]="ЗАПОЛНЕННЫЙ КРУГ",["LARGE FILLED CIRCLE"]="БОЛЬШОЙ ЗАПОЛНЕННЫЙ КРУГ",["SPHERE — DENSE"]="ПЛОТНАЯ СФЕРА",["SMALL SPHERE"]="МАЛЕНЬКАЯ СФЕРА",["IMPROVED BUILD PRESETS"]="УЛУЧШЕННЫЕ ШАБЛОНЫ",["PRESET: WIDE PLATFORM"]="ШАБЛОН: ШИРОКАЯ ПЛАТФОРМА",["PRESET: FORTRESS"]="ШАБЛОН: КРЕПОСТЬ",["PRESET: BRIDGE"]="ШАБЛОН: МОСТ",["PRESET: HOUSE PLUS"]="ШАБЛОН: ДОМ",
["EASY MIDI IMPORT"]="ПРОСТОЙ ИМПОРТ MIDI",["MIDI: waiting for input"]="MIDI: ожидание данных",["AUTO FIND + LOAD MIDI"]="НАЙТИ И ЗАГРУЗИТЬ MIDI",["IMPORT / PARSE MIDI"]="ИМПОРТ / ЧТЕНИЕ MIDI",["SHOW MIDI SUMMARY"]="ПОКАЗАТЬ СВЕДЕНИЯ MIDI",["MUSIC BUILDER — MIDI SOURCES"]="МУЗЫКАЛЬНЫЙ РЕДАКТОР — MIDI",["BUILD HOLY WAR — QUAVER RHYTHM"]="ПОСТРОИТЬ HOLY WAR — РИТМ",["BUILD RUSH E"]="ПОСТРОИТЬ RUSH E",["AUTO BUILD + WIRE MIDI"]="АВТОСТРОЙКА И СОЕДИНЕНИЕ MIDI",["STOP MIDI AUTO BUILD"]="ОСТАНОВИТЬ MIDI-АВТОСТРОЙКУ",["BABFT BLOCK CHECK"]="ПРОВЕРКА БЛОКОВ BABFT",
["AUTO BUY — BUILD A BOAT FOR TREASURE"]="АВТОПОКУПКА — BUILD A BOAT FOR TREASURE",["QUANTITY (1–1000)"]="КОЛИЧЕСТВО (1–1000)",["BUY SELECTED ITEM × QUANTITY"]="КУПИТЬ ВЫБРАННЫЙ ПРЕДМЕТ × КОЛИЧЕСТВО",["AUTO BUY: OFF"]="АВТОСКУПКА: ВЫКЛ",["AUTO BUY: ON"]="АВТОСКУПКА: ВКЛ",["AUTO BUY repeats the selected quantity every 2 seconds until switched OFF. Watch your gold; the game server still validates every purchase."]="Автоскупка повторяет покупку каждые 2 секунды, пока не выключишь. Следи за золотом.",["The game server checks the item, price and your gold. This does not bypass payment or guarantee stock."]="Игра проверяет предмет, цену и золото. Оплата не обходится.",["SHOP: ready"]="МАГАЗИН: готов",["Game diagnostics"]="Диагностика игры",["FULL GAME STRUCTURE SCAN"]="ПОЛНОЕ СКАНИРОВАНИЕ ИГРЫ",["SCAN REMOTES (BUILD + REWARDS)"]="СКАНИРОВАТЬ REMOTE (СТРОЙКА + НАГРАДЫ)",["SCAN INTERACTION OBJECTS"]="СКАНИРОВАТЬ ОБЪЕКТЫ ВЗАИМОДЕЙСТВИЯ",["Hub settings"]="Настройки хаба",["Appearance / Внешний вид"]="Внешний вид",["Reset appearance"]="Сбросить оформление",["Theme: Purple"]="Тема: фиолетовая",["Theme: Cyan"]="Тема: голубая",["Theme: Red"]="Тема: красная",["Theme: Green"]="Тема: зелёная",["Theme: Gold"]="Тема: золотая",["Reset"]="Сбросить",
["Choose your language / Выбери язык"]="Выбери язык интерфейса",["Select language to translate the hub interface"]="Выбери язык, на который перевести меню"
},
es={["HOME"]="INICIO",["MOVEMENT"]="MOVIMIENTO",["VISUALS"]="VISUAL",["TELEPORTS"]="TELETRANSPORTE",["AUTO BUILD"]="CONSTRUCCIÓN AUTO",["MUSIC"]="MÚSICA",["AUTO FARM"]="FARMEO AUTO",["SHOP"]="TIENDA",["TOOLS"]="HERRAMIENTAS",["SETTINGS"]="AJUSTES",["Welcome to Diamond Boat Hub"]="Bienvenido a Diamond Boat Hub",["Movement controls"]="Controles de movimiento",["Visual settings"]="Ajustes visuales",["Position manager"]="Gestor de posición",["Base scanner"]="Escáner de bases",["EASY MIDI IMPORT"]="IMPORTAR MIDI",["AUTO FIND + LOAD MIDI"]="BUSCAR Y CARGAR MIDI",["IMPORT / PARSE MIDI"]="IMPORTAR / LEER MIDI",["BUY SELECTED ITEM × QUANTITY"]="COMPRAR ARTÍCULO × CANTIDAD",["Hub settings"]="Ajustes del hub",["Choose your language / Выбери язык"]="Elige el idioma"},
de={["HOME"]="START",["MOVEMENT"]="BEWEGUNG",["VISUALS"]="GRAFIK",["TELEPORTS"]="TELEPORT",["AUTO BUILD"]="AUTO-BAU",["MUSIC"]="MUSIK",["AUTO FARM"]="AUTO-FARM",["SHOP"]="SHOP",["TOOLS"]="WERKZEUGE",["SETTINGS"]="EINSTELLUNGEN",["Welcome to Diamond Boat Hub"]="Willkommen bei Diamond Boat Hub",["Movement controls"]="Bewegungssteuerung",["Visual settings"]="Grafikeinstellungen",["Position manager"]="Positionsverwaltung",["Base scanner"]="Basis-Scanner",["EASY MIDI IMPORT"]="MIDI-IMPORT",["AUTO FIND + LOAD MIDI"]="MIDI AUTOMATISCH FINDEN",["IMPORT / PARSE MIDI"]="MIDI IMPORTIEREN",["BUY SELECTED ITEM × QUANTITY"]="AUSGEWÄHLTEN ARTIKEL KAUFEN",["Hub settings"]="Hub-Einstellungen",["Choose your language / Выбери язык"]="Sprache auswählen"},
fr={["HOME"]="ACCUEIL",["MOVEMENT"]="MOUVEMENT",["VISUALS"]="VISUEL",["TELEPORTS"]="TÉLÉPORTS",["AUTO BUILD"]="CONSTRUCTION AUTO",["MUSIC"]="MUSIQUE",["AUTO FARM"]="FARM AUTO",["SHOP"]="BOUTIQUE",["TOOLS"]="OUTILS",["SETTINGS"]="PARAMÈTRES",["Welcome to Diamond Boat Hub"]="Bienvenue sur Diamond Boat Hub",["Movement controls"]="Contrôles de mouvement",["Visual settings"]="Paramètres visuels",["Position manager"]="Gestion de position",["Base scanner"]="Scanner de base",["EASY MIDI IMPORT"]="IMPORT MIDI",["AUTO FIND + LOAD MIDI"]="TROUVER ET CHARGER MIDI",["IMPORT / PARSE MIDI"]="IMPORTER / LIRE MIDI",["BUY SELECTED ITEM × QUANTITY"]="ACHETER L'ARTICLE",["Hub settings"]="Paramètres du hub",["Choose your language / Выбери язык"]="Choisissez la langue"},
pt={["HOME"]="INÍCIO",["MOVEMENT"]="MOVIMENTO",["VISUALS"]="VISUAL",["TELEPORTS"]="TELEPORTES",["AUTO BUILD"]="CONSTRUÇÃO AUTO",["MUSIC"]="MÚSICA",["AUTO FARM"]="FARM AUTO",["SHOP"]="LOJA",["TOOLS"]="FERRAMENTAS",["SETTINGS"]="CONFIGURAÇÕES",["Welcome to Diamond Boat Hub"]="Bem-vindo ao Diamond Boat Hub",["Movement controls"]="Controles de movimento",["Visual settings"]="Configurações visuais",["Position manager"]="Gerenciador de posição",["Base scanner"]="Scanner de bases",["EASY MIDI IMPORT"]="IMPORTAR MIDI",["AUTO FIND + LOAD MIDI"]="LOCALIZAR E CARREGAR MIDI",["IMPORT / PARSE MIDI"]="IMPORTAR MIDI",["BUY SELECTED ITEM × QUANTITY"]="COMPRAR ITEM SELECIONADO",["Hub settings"]="Configurações do hub",["Choose your language / Выбери язык"]="Escolha o idioma"},
tr={["HOME"]="ANA SAYFA",["MOVEMENT"]="HAREKET",["VISUALS"]="GÖRÜNÜM",["TELEPORTS"]="IŞINLANMA",["AUTO BUILD"]="OTOMATİK İNŞA",["MUSIC"]="MÜZİK",["AUTO FARM"]="OTOMATİK KASMA",["SHOP"]="MAĞAZA",["TOOLS"]="ARAÇLAR",["SETTINGS"]="AYARLAR",["Welcome to Diamond Boat Hub"]="Diamond Boat Hub'a hoş geldin",["Movement controls"]="Hareket kontrolleri",["Visual settings"]="Görünüm ayarları",["Position manager"]="Konum yöneticisi",["Base scanner"]="Üs tarayıcı",["EASY MIDI IMPORT"]="MIDI İÇE AKTAR",["AUTO FIND + LOAD MIDI"]="MIDI BUL VE YÜKLE",["IMPORT / PARSE MIDI"]="MIDI İÇE AKTAR",["BUY SELECTED ITEM × QUANTITY"]="SEÇİLİ ÖĞEYİ SATIN AL",["Hub settings"]="Hub ayarları",["Choose your language / Выбери язык"]="Dilini seç"},
pl={["HOME"]="GŁÓWNA",["MOVEMENT"]="RUCH",["VISUALS"]="GRAFIKA",["TELEPORTS"]="TELEPORTY",["AUTO BUILD"]="AUTO BUDOWA",["MUSIC"]="MUZYKA",["AUTO FARM"]="AUTO FARM",["SHOP"]="SKLEP",["TOOLS"]="NARZĘDZIA",["SETTINGS"]="USTAWIENIA",["Welcome to Diamond Boat Hub"]="Witamy w Diamond Boat Hub",["Movement controls"]="Sterowanie ruchem",["Visual settings"]="Ustawienia grafiki",["Position manager"]="Menedżer pozycji",["Base scanner"]="Skaner baz",["EASY MIDI IMPORT"]="IMPORT MIDI",["AUTO FIND + LOAD MIDI"]="ZNAJDŹ I ZAŁADUJ MIDI",["IMPORT / PARSE MIDI"]="IMPORTUJ MIDI",["BUY SELECTED ITEM × QUANTITY"]="KUP WYBRANY PRZEDMIOT",["Hub settings"]="Ustawienia huba",["Choose your language / Выбери язык"]="Wybierz język"},
zh={["HOME"]="主页",["MOVEMENT"]="移动",["VISUALS"]="画面",["TELEPORTS"]="传送",["AUTO BUILD"]="自动建造",["MUSIC"]="音乐",["AUTO FARM"]="自动刷取",["SHOP"]="商店",["TOOLS"]="工具",["SETTINGS"]="设置",["Welcome to Diamond Boat Hub"]="欢迎使用 Diamond Boat Hub",["Movement controls"]="移动控制",["Visual settings"]="画面设置",["Position manager"]="位置管理",["Base scanner"]="基地扫描",["EASY MIDI IMPORT"]="导入 MIDI",["AUTO FIND + LOAD MIDI"]="自动查找并加载 MIDI",["IMPORT / PARSE MIDI"]="导入 / 解析 MIDI",["BUY SELECTED ITEM × QUANTITY"]="购买所选物品",["Hub settings"]="Hub 设置",["Choose your language / Выбери язык"]="选择语言"}
}

languageNames={
{"Русский","ru"},{"English","en"},{"Español","es"},{"Deutsch","de"},
{"Français","fr"},{"Português","pt"},{"Türkçe","tr"},{"Polski","pl"},{"中文","zh"}
}
function applyLanguage(lang)
    CurrentLanguage=lang
    CurrentTranslations=translations[lang] or {}
    for _,obj in ipairs(GUI:GetDescendants()) do
        if obj:IsA("TextButton") or obj:IsA("TextLabel") then
            local original=obj:GetAttribute("OriginalText")
            if not original then
                original=obj.Text
                obj:SetAttribute("OriginalText",original)
            end
            obj.Text=CurrentTranslations[original] or original
        end
    end
    TitleLabel.Text="💎  DIAMOND BOAT HUB V1 [BETA]"
    Intro.Visible=false
    Main.Visible=true
    MainScale.Scale=0.88
    IntroScale.Scale=0.92
    TweenService:Create(IntroScale,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Scale=0.85}):Play()
    animateOpen()
    showPage("HOME")
end

deviceTitle=create("TextLabel",{Size=UDim2.new(1,-30,0,22),Position=UDim2.fromOffset(15,112),BackgroundTransparency=1,Text="DEVICE / УСТРОЙСТВО",TextColor3=Color3.fromRGB(190,190,205),TextSize=12,Font=Enum.Font.GothamBold,ZIndex=51},Intro)
pcDeviceButton=deviceButton("PC / КОМПЬЮТЕР",136,"pc")
phoneDeviceButton=deviceButton("PHONE / ТЕЛЕФОН",174,"phone")
pcDeviceButton.Size=UDim2.new(0.5,-26,0,48); pcDeviceButton.Position=UDim2.new(0,16,0,145)
phoneDeviceButton.Size=UDim2.new(0.5,-26,0,48); phoneDeviceButton.Position=UDim2.new(0.5,10,0,145)
languageTitle=create("TextLabel",{Visible=false,Size=UDim2.new(1,-30,0,22),Position=UDim2.fromOffset(15,218),BackgroundTransparency=1,Text="LANGUAGE / ЯЗЫК — ВЫБЕРИ ЯЗЫК",TextColor3=Color3.fromRGB(190,190,205),TextSize=12,Font=Enum.Font.GothamBold,ZIndex=51},Intro)
selectedLanguage="ru"
languageList=create("ScrollingFrame",{Visible=false,Size=UDim2.new(1,-44,0,205),Position=UDim2.fromOffset(22,246),BackgroundColor3=Color3.fromRGB(18,18,24),BorderSizePixel=0,ScrollBarThickness=5,ScrollBarImageColor3=PURPLE,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollingDirection=Enum.ScrollingDirection.Y,ZIndex=52},Intro)
round(languageList,10); outline(languageList)
languageLayout=create("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},languageList)
create("UIPadding",{PaddingTop=UDim.new(0,7),PaddingBottom=UDim.new(0,7),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7)},languageList)
for index,item in ipairs(languageNames) do
    local langButton=create("TextButton",{Name="Language_"..item[2],Size=UDim2.new(1,-4,0,34),BackgroundColor3=(item[2]==selectedLanguage and PURPLE or Color3.fromRGB(38,38,48)),Text=item[1]..(item[2]==selectedLanguage and "  ✓" or ""),TextColor3=WHITE,TextSize=14,Font=Enum.Font.GothamSemibold,AutoButtonColor=false,LayoutOrder=index,ZIndex=53},languageList)
    round(langButton,8)
    langButton.Activated:Connect(function()
        selectedLanguage=item[2]
        for _,entry in ipairs(languageList:GetChildren()) do
            if entry:IsA("TextButton") then
                local active=entry.Name=="Language_"..selectedLanguage
                entry.BackgroundColor3=active and PURPLE or Color3.fromRGB(38,38,48)
                entry.Text=entry.Text:gsub("  ✓$","")..(active and "  ✓" or "")
            end
        end
    end)
end
continueButton=languageButton("CONTINUE / ПРОДОЛЖИТЬ",462,function() applyLanguage(selectedLanguage) end)
continueButton.Visible=false
continueButton.Position=UDim2.fromOffset(22,462)
continueButton.Size=UDim2.new(1,-44,0,42)
continueButton.BackgroundColor3=PURPLE; continueButton.TextColor3=WHITE

Intro.Visible=true
Main.Visible=false
TweenService:Create(IntroScale,TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()

showPage("HOME")
-- DELTA-FRIENDLY CONFIGURATION + RELOAD
HttpService=game:GetService("HttpService")
CONFIG_FILE="DiamondBoatHub_Config.json"
configStatus = nil
function setConfigStatus(message)
    if configStatus and configStatus.Parent then configStatus.Text=message end
    print("[DIAMOND CONFIG]",message)
end
function getSharedConfig()
    local env=nil
    if type(getgenv)=="function" then pcall(function() env=getgenv() end) end
    if type(env)=="table" then return env end
    return _G
end
function saveHubConfig()
    local data={version=1,language=CurrentLanguage or "en",windowMode=windowMode or "medium",width=Main.AbsoluteSize.X,height=Main.AbsoluteSize.Y,theme=currentTheme or "Purple",buttonStyle=buttonStyle,animatedBackground=animatedBackground,backgroundMode=backgroundMode,prefix=playerPrefix,prefixColor=prefixColor and {prefixColor.R,prefixColor.G,prefixColor.B} or nil,speed=configuredSpeed,jump=configuredJump}
    local encoded=HttpService:JSONEncode(data)
    local shared=getSharedConfig()
    shared.__DIAMOND_BOAT_HUB_CONFIG=data
    if type(writefile)=="function" then
        local ok,err=pcall(function() writefile(CONFIG_FILE,encoded) end)
        if ok then setConfigStatus("CONFIG: saved to "..CONFIG_FILE); return true end
        warn("[DIAMOND CONFIG] File save failed:",tostring(err))
    end
    setConfigStatus("CONFIG: kept in executor session (file API unavailable)")
    return true
end
function loadHubConfig()
    local data
    if type(isfile)=="function" and type(readfile)=="function" then
        local ok,result=pcall(function()
            if not isfile(CONFIG_FILE) then error("config file not found") end
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if ok and type(result)=="table" then data=result end
    end
    if not data then
        local shared=getSharedConfig()
        if type(shared.__DIAMOND_BOAT_HUB_CONFIG)=="table" then data=shared.__DIAMOND_BOAT_HUB_CONFIG end
    end
    if type(data)~="table" then setConfigStatus("CONFIG: no saved config found"); return false end
    if type(data.language)=="string" and (data.language=="en" or translations[data.language]) then applyLanguage(data.language) end
    if type(data.windowMode)=="string" then
        if data.windowMode=="fullscreen" then windowMode="fullscreen"; fitToScreen()
        elseif desktopSizes[data.windowMode] then setWindowMode(data.windowMode)
        elseif data.windowMode=="custom" and tonumber(data.width) and tonumber(data.height) then
            local cam=Workspace.CurrentCamera; local vp=cam and cam.ViewportSize or Vector2.new(1280,720)
            local w=math.clamp(data.width,280,vp.X-16); local h=math.clamp(data.height,340,vp.Y-16)
            Main.Size=UDim2.fromOffset(w,h); Main.Position=UDim2.new(0.5,-w/2,0.5,-h/2); windowMode="custom"
        end
    end
    if type(data.theme)=="string" and themes[data.theme] then applyTheme(data.theme) end
    if data.buttonStyle=="Modern" or data.buttonStyle=="Liquid Glass" or data.buttonStyle=="Neon" then setButtonStyle(data.buttonStyle) end
    if type(data.animatedBackground)=="boolean" then
        animatedBackground=data.animatedBackground
        if backgroundGradient then backgroundGradient.Enabled=true end
        if mainBackgroundGradient then mainBackgroundGradient.Enabled=true end
    end
    if type(data.backgroundMode)=="string" then setBackgroundMode(data.backgroundMode) end
    if type(data.prefix)=="string" then playerPrefix=string.sub(data.prefix,1,16); if prefixBox then prefixBox.Text=playerPrefix end end
    if type(data.prefixColor)=="table" and #data.prefixColor==3 then prefixColor=Color3.new(math.clamp(data.prefixColor[1],0,1),math.clamp(data.prefixColor[2],0,1),math.clamp(data.prefixColor[3],0,1)) end
    refreshPlayerTags()
    if tonumber(data.speed) then configuredSpeed=math.clamp(data.speed,16,250); updateSpeed() end
    if tonumber(data.jump) then configuredJump=math.clamp(data.jump,50,300); updateJump() end
    setConfigStatus("CONFIG: loaded successfully")
    return true
end

configStatus=label(settings,"CONFIG: ready")
button(settings,"SAVE CONFIG",function() saveHubConfig() end)
button(settings,"LOAD CONFIG",function() loadHubConfig() end)
button(settings,"DESTROY HUB",function()
    -- Stop active loops and release any movement/input state before removing the UI.
    farmEnabled=false
    farmRunId+=1
    pcall(function() farmRelease() end)
    pcall(function() clearPreview() end)
    pcall(function() GUI:Destroy() end)
    print("[DIAMOND BOAT HUB] Destroyed. Run the loader again to reopen.")
end)
button(settings,"RELOAD SCRIPT",function()
    farmEnabled=false
    farmRunId+=1
    farmRelease()
    local url="https://raw.githubusercontent.com/donnagarhartqg494-max/DiamondBoatHub/main/DiamondBoatHub.lua"
    local ok,err=pcall(function()
        assert(type(loadstring)=="function","loadstring unavailable")
        local source=game:HttpGet(url)
        assert(type(source)=="string" and #source>1000,"download returned invalid script")
        local chunk=loadstring(source)
        assert(type(chunk)=="function","script compilation failed")
        chunk()
    end)
    if not ok then warn("[DIAMOND RELOAD] Failed:",tostring(err)) end
end)

print("DIAMOND BOAT HUB V1 [BETA] LOADED")
