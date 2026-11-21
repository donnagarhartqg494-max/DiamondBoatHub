
--==================================================
-- DIAMOND BOAT HUB V24
-- Build A Boat For Treasure
-- Desktop + Mobile
--==================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

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
    Visible=false,
    Size=UDim2.fromOffset(680,470),
    Position=UDim2.new(.5,-340,.5,-235),
    BackgroundColor3=DARK,
    BorderSizePixel=0
},GUI)
round(Main,12)
outline(Main)
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(31,24,55),Color3.fromRGB(12,13,22)),Rotation=35},Main)
local MainScale=create("UIScale",{Scale=1},Main)
local function fitToScreen()
    local cam=Workspace.CurrentCamera
    if cam then MainScale.Scale=math.clamp(math.min(cam.ViewportSize.X/760,cam.ViewportSize.Y/540),0.68,1) end
end
fitToScreen()
if Workspace.CurrentCamera then Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitToScreen) end

local Top = create("Frame",{
    Size=UDim2.new(1,0,0,48),
    BackgroundColor3=PANEL,
    BorderSizePixel=0
},Main)
round(Top,12)
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(82,54,150),Color3.fromRGB(30,32,55)),Rotation=0},Top)

create("TextLabel",{
    Size=UDim2.new(1,-150,1,0),
    Position=UDim2.fromOffset(15,0),
    BackgroundTransparency=1,
    Text="💎 DIAMOND BOAT HUB V19",
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
    round(b,9)
    outline(b)
    b.AutoButtonColor=false
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(55,43,86)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=DARK}):Play() end)
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
local music=makePage("MUSIC")
local farm=makePage("AUTO FARM")
local tools=makePage("TOOLS")
local settings=makePage("SETTINGS")

local tabLayout=create("UIListLayout",{
    Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder
},Sidebar)

for _,name in ipairs({
    "HOME","MOVEMENT","VISUALS","TELEPORTS",
    "AUTO BUILD","MUSIC","AUTO FARM","TOOLS","SETTINGS"
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
local rejoinBusy=false
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

local antiAfkConnection
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

local savedEffects={}
local lowGraphicsOn=false
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

button(build,"REMOVE LOCAL PREVIEW",clearPreview)

-- REAL AUTO BUILD V4
local buildRunning=false
local buildProgressLabel=label(build,"Auto Build: idle")

local function getPlayerZone(plr)
    if not plr then return nil end
    for _,obj in ipairs(Workspace:GetChildren()) do
        local teamColor=obj:FindFirstChild("TeamColor")
        if teamColor and teamColor.Value==plr.TeamColor then
            return obj
        end
    end
    return nil
end

local function getBuildTool()
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

local function getBlockTypeId(blockName)
    local data=Player:FindFirstChild("Data")
    local value=data and data:FindFirstChild(blockName)
    if value and (value:IsA("IntValue") or value:IsA("NumberValue")) then
        return value.Value
    end
    if blockName=="WoodBlock" then return 9 end
    return nil
end

local function getNewBlockCFrame(sourceBlock,sourceZone,targetZone)
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
local function getMyBuildContext()
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

local function buildWoodPattern(name,offsets)
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
local function makeCircle(radius,step,y)
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
local function makeSphere(radius,step)
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
label(music,"CROSS-PLATFORM MIDI IMPORT")
label(music,"Paste a DIRECT .mid/.midi download URL or Base64 MIDI data. OnlineSequencer page URLs are not direct MIDI files.")
local midiInput=create("TextBox",{
    Size=UDim2.new(1,-8,0,76), BackgroundColor3=DARK, Text="",
    PlaceholderText="https://.../song.mid  OR  Base64 MIDI data",
    TextColor3=WHITE, TextSize=12, Font=Enum.Font.Gotham,
    ClearTextOnFocus=false, MultiLine=true, TextWrapped=true,
    TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top
},music)
round(midiInput,8); outline(midiInput)
local midiStatus=label(music,"MIDI: waiting for input")
local parsedMidi=nil
local function decodeBase64(data)
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
local function readMidi(data)
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
local function getMidiBytes(input)
    input=input:gsub("^%s+",""):gsub("%s+$","")
    if input=="" then error("Paste a MIDI URL or Base64 data first") end
    if input:match("^https?://") then
        local methods={
            function() return game:HttpGet(input) end,
            function() if request then local r=request({Url=input,Method="GET"}); if r and r.Body then return r.Body end end end,
            function() if http_request then local r=http_request({Url=input,Method="GET"}); if r and r.Body then return r.Body end end end,
            function() if syn and syn.request then local r=syn.request({Url=input,Method="GET"}); if r and r.Body then return r.Body end end end
        }
        local errors={}
        for _,method in ipairs(methods) do
            local ok,result=pcall(method)
            if ok and type(result)=="string" and #result>0 then return result end
            if not ok then errors[#errors+1]=tostring(result) end
        end
        error("Download failed. Use a direct raw .mid URL; executor HTTP may be blocked. "..table.concat(errors," | "))
    end
    local raw=decodeBase64(input)
    return raw
end
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
label(music,"Import uses the same text box on Solara PC and Delta Android. For a local .mid file, convert it to Base64 first; a direct raw .mid URL is easier.")
label(music,"This stage imports and parses the actual MIDI. Automatic placement, pitch configuration and wiring remain locked until the live PropertyTool/BindingTool remote arguments are verified; the hub will not fake a successful build.")

-- MUSIC HELPER V1: inventory checks, verified sequence links and safe duplication notes.
label(music,"ONE-CLICK MIDI CONVERTER")
label(music,"Convert a local .mid file into a BABFT music blueprint with Note keys, Delay timing and wiring steps.")
local midiConverterUrl="https://babft-music-note.vercel.app/"
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
local holyWarUrl="https://onlinesequencer.net/5314889"
local rushEUrl="https://onlinesequencer.net/5775937"
local function copyMusicUrl(url,title)
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
local musicInventoryLabel=label(music,"Inventory: not scanned")
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
local midiBuildRunning=false
local midiBuildStatus=label(music,"MIDI BUILD: waiting for parsed MIDI")
local function findTool(names)
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
local function findPropertyRemote()
    local tool=findTool({"PropertiesTool","PropertyTool"})
    if not tool then return nil end
    local rf=tool:FindFirstChild("SetPropertieRF",true) or tool:FindFirstChild("SetPropertyRF",true)
    return rf and rf:IsA("RemoteFunction") and rf or nil
end
local function getMusicBlockId(name)
    local data=Player:FindFirstChild("Data")
    local v=data and data:FindFirstChild(name)
    if v and v.Value>0 then return v.Value end
    return nil
end
local function setMusicProperty(remote,property,block,value)
    local ok,result=pcall(function()
        return remote:InvokeServer(property,{block},value)
    end)
    if not ok then return false,tostring(result) end
    return true,result
end
button(music,"AUTO BUILD MUSIC ON MY BASE",function()
    if midiBuildRunning then warn("[MIDI BUILD] Already running"); return end
    if not parsedMidi or #parsedMidi.notes==0 then warn("[MIDI BUILD] Import a MIDI first"); return end
    local noteId=getMusicBlockId("Note")
    local delayId=getMusicBlockId("Delay")
    if not noteId or not delayId then
        warn("[MIDI BUILD] Inventory missing Note or Delay blocks")
        midiBuildStatus.Text="MIDI BUILD: missing Note/Delay inventory"
        return
    end
    local data=Player:FindFirstChild("Data")
    local noteCount=data.Note.Value
    local delayCount=data.Delay.Value
    local required=#parsedMidi.notes
    if noteCount<required or delayCount<required then
        warn("[MIDI BUILD] Need",required,"Notes +",required,"Delays. Have",noteCount,"+",delayCount)
        midiBuildStatus.Text=string.format("Need %d Notes + %d Delays; have %d + %d",required,required,noteCount,delayCount)
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
        warn("[MIDI BUILD] PropertiesTool.SetPropertieRF not found; blocks will not be configured.")
        midiBuildStatus.Text="MIDI BUILD: equip Properties Tool first"
        return
    end
    local folder=Workspace:FindFirstChild("Blocks")
    local myFolder=folder and folder:FindFirstChild(Player.Name)
    if not myFolder then warn("[MIDI BUILD] Own block folder missing"); return end
    local char,hum,root=getCharacter()
    local origin=root and (root.CFrame*CFrame.new(0,8,-18))
    if not origin then warn("[MIDI BUILD] Character root missing"); return end
    local keyNames={"F#3","G3","G#3","A3","A#3","B3","C4","C#4","D4","D#4","E4","F4","F#4","G4","G#4","A4","A#4","B4","C5","C#5","D5","D#5","E5","F5","F#5"}
    local prepared={}
    for i,n in ipairs(parsedMidi.notes) do
        local key=n.pitch-54
        if key<0 or key>24 then
            warn("[MIDI BUILD] Pitch outside Music Note range F#3-F#5:",n.pitch,"event",i)
            midiBuildStatus.Text="MIDI BUILD: pitch outside F#3–F#5 (see F9)"
            return
        end
        local delta=i>1 and (n.time-parsedMidi.notes[i-1].time) or n.time
        prepared[i]={key=keyNames[key+1],delay=math.clamp(delta,0.05,10),time=n.time}
    end
    midiBuildRunning=true
    midiBuildStatus.Text="MIDI BUILD: placing "..required.." note/delay pairs..."
    task.spawn(function()
        local madeNotes,madeDelays,errors={}, {},0
        local function place(name,id,cf)
            local before={}
            for _,obj in ipairs(myFolder:GetChildren()) do before[obj]=true end
            local localCF=zone.CFrame:ToObjectSpace(cf)
            local ok,err=pcall(function()
                buildRF:InvokeServer(name,id,zone,localCF,true,cf,false)
            end)
            if not ok then return nil,tostring(err) end
            for _=1,20 do
                for _,obj in ipairs(myFolder:GetChildren()) do
                    if not before[obj] and obj.Name==name and obj:FindFirstChild("PPart") then return obj end
                end
                task.wait(0.05)
            end
            return nil,"server did not replicate placed "..name
        end
        for i,item in ipairs(prepared) do
            if not midiBuildRunning then break end
            local delayCF=origin*CFrame.new((i-1)*7,0,0)
            local noteCF=delayCF*CFrame.new(0,0,-3)
            local delayBlock,delayErr=place("Delay",delayId,delayCF)
            local noteBlock,noteErr=place("Note",noteId,noteCF)
            if delayBlock then
                local ok,err=setMusicProperty(propertyRF,"Delay",delayBlock,item.delay)
                if ok then table.insert(madeDelays,delayBlock) else errors+=1; warn("[MIDI BUILD] Delay property failed",i,err) end
            else errors+=1; warn("[MIDI BUILD] Delay placement failed",i,delayErr) end
            if noteBlock then
                local ok,err=setMusicProperty(propertyRF,"Key",noteBlock,item.key)
                if ok then table.insert(madeNotes,noteBlock) else errors+=1; warn("[MIDI BUILD] Note key failed",i,err) end
            else errors+=1; warn("[MIDI BUILD] Note placement failed",i,noteErr) end
            midiBuildStatus.Text=string.format("MIDI BUILD: %d/%d pairs | errors %d",i,required,errors)
            if i%4==0 then task.wait(0.1) end
        end
        midiBuildRunning=false
        midiBuildStatus.Text=string.format("Placed %d Notes + %d Delays | errors %d | wiring not done",#madeNotes,#madeDelays,errors)
        print("[MIDI BUILD] Finished. Notes:",#madeNotes,"Delays:",#madeDelays,"Errors:",errors)
        print("[MIDI BUILD] Blocks are arranged in pairs along a straight row. BindingTool connections are NOT automated in this version.")
        print("[MIDI BUILD] Key and Delay property calls used SetPropertieRF; verify in-game before saving.")
    end)
end)
-- BINDING TOOL API SCAN V1
local function dumpToolTree(root,tag)
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
local selectedSaveSlot=1
local slotLabel=label(music,"Target slot: 1")
local slotInput=create("TextBox",{
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

-- AUTO FARM V10
label(farm,"AUTO FARM GOLD V10")
label(farm,"Each cave stage is confirmed before moving on. Death/respawn is awaited.")

local farmEnabled=false
local farmRunId=0
local farmDelay=1.25

local function farmLog(...)
    print("[DIAMOND AUTO FARM V10]",...)
end

local function farmGet()
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

local function farmCharacter()
    local char=Player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return char,root,hum
end

local function farmWaitAlive(runId,timeout)
    local deadline=os.clock()+(timeout or 25)
    while farmEnabled and runId==farmRunId and os.clock()<deadline do
        local char,root,hum=farmCharacter()
        if char and root and hum and hum.Health>0 then return char,root,hum end
        task.wait(0.15)
    end
    return nil
end

local function farmStageValue(other,index)
    local v=other:FindFirstChild("Stage"..index)
    return v and v.Value or nil
end

local function farmHasProgress(value)
    return value~=nil and value~="" and value~=false and value~=0
end

local function farmWaitStage(other,index,oldValue,runId,timeout)
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
        task.wait(0.1)
    end
    return false,"Stage progress timeout"
end

local function farmNudge(runId)
    local char,root,hum=farmWaitAlive(runId,15)
    if not root then return false end
    local base=root.CFrame
    root.CFrame=base*CFrame.new(-10,0,-10)
    task.wait(0.1)
    if not farmEnabled or runId~=farmRunId then return false end
    char,root,hum=farmWaitAlive(runId,15)
    if not root then return false end
    root.CFrame=base
    return true
end

local function farmTouchChest(trigger,runId)
    local char,root,hum=farmWaitAlive(runId,20)
    if not root then return false end
    local chestCF=trigger.CFrame*CFrame.new(-5,-1.7,0)*CFrame.Angles(0,math.rad(-90),0)
    char:PivotTo(chestCF)
    task.wait(0.2)
    if typeof(firetouchinterest)=="function" then
        local ok,err=pcall(function()
            firetouchinterest(root,trigger,1)
            task.wait(0.15)
            firetouchinterest(root,trigger,0)
        end)
        if not ok then farmLog("Touch error:",err) end
        return ok
    end
    -- Fallback: stand directly on the trigger; normal game touch handling may activate it.
    char:PivotTo(trigger.CFrame*CFrame.new(0,3,0))
    return true
end

local function farmWaitReset(other,runId)
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

local farmHoldVelocity=nil
local function farmFlyTo(root,targetCFrame,runId)
    if farmHoldVelocity then pcall(function() farmHoldVelocity:Destroy() end) end
    farmHoldVelocity=nil
    if not root or not root.Parent then return false end
    local distance=(root.Position-targetCFrame.Position).Magnitude
    local duration=math.clamp(distance/55,0.35,1.25)
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
local function farmHold(root)
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
local function farmRelease()
    if farmHoldVelocity then pcall(function() farmHoldVelocity:Destroy() end) end
    farmHoldVelocity=nil
end

local function runFarm(runId)
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
        -- Pause at every location for half a second before activating the stage.
        local stopUntil=os.clock()+0.5
        while farmEnabled and runId==farmRunId and os.clock()<stopUntil do
            RunService.Heartbeat:Wait()
        end
        if not farmEnabled or runId~=farmRunId then return end
        pcall(function() event:Fire() end)
        if typeof(firetouchinterest)=="function" then
            pcall(function()
                firetouchinterest(root,dark,0)
                task.wait(0.12)
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
                task.wait(0.1)
            end
        end
        if not confirmed and typeof(firetouchinterest)=="function" then
            farmLog("Stage",i,"not confirmed; retrying touch")
            pcall(function()
                firetouchinterest(root,dark,0)
                task.wait(0.15)
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
                    task.wait(0.1)
                end
            end
        end
        farmLog("Stage",i,confirmed and "CONFIRMED" or "progress not detected","; waiting 1s")
        task.wait(1)
    end

    if not farmEnabled or runId~=farmRunId then return end
    local char,root,hum=farmWaitAlive(runId,20)
    if not root then farmLog("No live character before chest"); farmEnabled=false; return end

    farmLog("All stage triggers sent; waiting 0.7s before Golden Chest.")
    task.wait(0.7)
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
    task.wait(0.7)
    if not farmEnabled or runId~=farmRunId then conn:Disconnect(); return end

    char,root,hum=farmCharacter()
    if root and hum and hum.Health>0 and typeof(firetouchinterest)=="function" then
        pcall(function()
            firetouchinterest(root,chest,0)
            task.wait(0.15)
            firetouchinterest(root,chest,1)
        end)
        farmLog("Chest touch sent; waiting 1.5s for game response.")
        task.wait(1.5)
    elseif root and hum and hum.Health>0 then
        farmLog("firetouchinterest unavailable; waiting for natural chest contact.")
        task.wait(1.5)
    end

    -- If the chest kills/resets the avatar, wait for the respawn before claiming.
    local deadline=os.clock()+20
    while farmEnabled and runId==farmRunId and not respawned and os.clock()<deadline do
        local c=Player.Character
        if c and c~=oldCharacter then respawned=true break end
        task.wait(0.1)
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
            if farmEnabled and id==farmRunId then task.wait(2) end
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

local function printInstanceDetails(obj, prefix)
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
    print("DIAMOND BOAT HUB: press F9, open Client log, run FULL GAME STRUCTURE SCAN, SCAN REMOTES and SCAN INTERACTION OBJECTS. Copy the output.")
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
local themes={
    Purple={main=Color3.fromRGB(130,90,255),panel=Color3.fromRGB(27,27,40),dark=Color3.fromRGB(17,17,25)},
    Cyan={main=Color3.fromRGB(0,190,220),panel=Color3.fromRGB(20,38,48),dark=Color3.fromRGB(10,20,28)},
    Red={main=Color3.fromRGB(235,75,90),panel=Color3.fromRGB(48,27,34),dark=Color3.fromRGB(24,14,19)},
    Green={main=Color3.fromRGB(65,190,125),panel=Color3.fromRGB(24,43,36),dark=Color3.fromRGB(13,24,19)},
    Gold={main=Color3.fromRGB(220,170,55),panel=Color3.fromRGB(48,40,25),dark=Color3.fromRGB(25,21,14)}
}
local function applyTheme(name)
    local t=themes[name]
    if not t then return end
    PURPLE=t.main; PANEL=t.panel; DARK=t.dark
    Main.BackgroundColor3=DARK; Top.BackgroundColor3=PANEL
    Sidebar.BackgroundColor3=PANEL; Content.BackgroundColor3=PANEL
    for _,obj in ipairs(GUI:GetDescendants()) do
        if obj:IsA("UIStroke") then
            obj.Color=PURPLE
        elseif obj:IsA("TextButton") and obj~=Close and obj~=Min then
            obj.BackgroundColor3=DARK
        end
    end
    Min.BackgroundColor3=PURPLE
    print("[DIAMOND] Theme:",name)
end
button(settings,"Theme: Purple",function() applyTheme("Purple") end)
button(settings,"Theme: Cyan",function() applyTheme("Cyan") end)
button(settings,"Theme: Red",function() applyTheme("Red") end)
button(settings,"Theme: Green",function() applyTheme("Green") end)
button(settings,"Theme: Gold",function() applyTheme("Gold") end)
button(settings,"Reset appearance",function() applyTheme("Purple") end)


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
outline(reopen)
reopen.AutoButtonColor=false
create("UIGradient",{Color=ColorSequence.new(Color3.fromRGB(175,130,255),Color3.fromRGB(70,50,175)),Rotation=45},reopen)

-- Drag the floating reopen button with mouse or touch.
local reopenDragging=false
local reopenDragStart
local reopenStartPosition
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

-- FIRST START LANGUAGE MENU
local Intro=create("Frame",{
    Size=UDim2.fromOffset(360,250),
    Position=UDim2.new(0.5,-180,0.5,-125),
    BackgroundColor3=DARK,
    BorderSizePixel=0,
    ZIndex=50
},GUI)
round(Intro,14)
outline(Intro)

create("TextLabel",{
    Size=UDim2.new(1,-20,0,48),
    Position=UDim2.fromOffset(10,18),
    BackgroundTransparency=1,
    Text="💎 DIAMOND BOAT HUB V24",
    TextColor3=WHITE,
    TextSize=20,
    Font=Enum.Font.GothamBold,
    ZIndex=51
},Intro)
create("TextLabel",{
    Size=UDim2.new(1,-20,0,30),
    Position=UDim2.fromOffset(10,72),
    BackgroundTransparency=1,
    Text="Choose your language / Выбери язык",
    TextColor3=PURPLE,
    TextSize=14,
    Font=Enum.Font.Gotham,
    ZIndex=51
},Intro)

local function languageButton(caption,y,callback)
    local b=create("TextButton",{
        Size=UDim2.new(1,-44,0,44),
        Position=UDim2.fromOffset(22,y),
        BackgroundColor3=PANEL,
        Text=caption,
        TextColor3=WHITE,
        TextSize=16,
        Font=Enum.Font.GothamSemibold,
        ZIndex=51
    },Intro)
    round(b,8)
    b.Activated:Connect(callback)
end

local function applyLanguage(lang)
    local ru=lang=="ru"

    local translations={
        ["HOME"]="ГЛАВНАЯ",["MOVEMENT"]="ДВИЖЕНИЕ",["VISUALS"]="ГРАФИКА",["TELEPORTS"]="ТЕЛЕПОРТЫ",["AUTO BUILD"]="АВТОСТРОЙКА",["MUSIC"]="МУЗЫКА",["AUTO FARM"]="АВТОФАРМ",["TOOLS"]="ИНСТРУМЕНТЫ",["SETTINGS"]="НАСТРОЙКИ",
        ["Welcome to Diamond Boat Hub"]="Добро пожаловать в Diamond Boat Hub",["Player information"]="Информация об игроке",["Character information"]="Информация о персонаже",["Reset character"]="Перезапустить персонажа",["Movement controls"]="Управление движением",
        ["Speed boost"]="Ускорение",["High jump"]="Высокий прыжок",["Infinite jump"]="Бесконечный прыжок",["Fly"]="Полёт",["Reset movement"]="Сбросить движение",
        ["Visual settings"]="Настройки графики",["Wide FOV"]="Широкий угол обзора",["Fullbright"]="Полное освещение",["Hide GUI"]="Скрыть интерфейс",["Anti-AFK"]="Анти-AFK",["Low graphics / FPS boost"]="Низкая графика / повышение FPS",
        ["Position manager"]="Управление позицией",["Save current position"]="Сохранить позицию",["Return to saved position"]="Вернуться к сохранённой позиции",["Move 20 studs upward"]="Переместиться вверх на 20",["Move 20 studs downward"]="Переместиться вниз на 20",
        ["Base scanner"]="Сканер баз",["Select a candidate and inspect it. Preview is local only."]="Выбери базу для просмотра. Превью видно только тебе.",["Selected base: none"]="Выбранная база: нет",
        ["SCAN BASES"]="СКАНИРОВАТЬ БАЗЫ",["SHOW SELECTED BASE INFO"]="ИНФОРМАЦИЯ О ВЫБРАННОЙ БАЗЕ",["LOCAL COPY PREVIEW"]="ЛОКАЛЬНОЕ ПРЕВЬЮ КОПИИ",["REMOVE LOCAL PREVIEW"]="УДАЛИТЬ ПРЕВЬЮ",
        ["COPY SELECTED PLAYER BASE"]="КОПИРОВАТЬ БАЗУ ИГРОКА",["AUTO BUILD TO MY BASE"]="СТРОИТЬ НА МОЕЙ БАЗЕ",["STOP AUTO BUILD"]="ОСТАНОВИТЬ СТРОЙКУ",["CLEAR BASE SELECTION"]="СБРОСИТЬ ВЫБОР БАЗЫ",["SCAN BUILD REMOTES"]="СКАНИРОВАТЬ REMOTE СТРОИТЕЛЬСТВА",
        ["AUTO FARM GOLD V14"]="АВТОФАРМ ЗОЛОТА V12",["Each cave stage is confirmed before moving on. Death/respawn is awaited."]="Каждый этап проверяется. После смерти скрипт ждёт возрождения.",["START AUTO FARM"]="ЗАПУСТИТЬ АВТОФАРМ",["STOP AUTO FARM"]="ОСТАНОВИТЬ АВТОФАРМ",["SCAN FARM ROUTE"]="СКАНИРОВАТЬ МАРШРУТ",
        ["MUSIC BUILDER — MIDI SOURCES"]="МУЗЫКАЛЬНЫЙ РЕДАКТОР — MIDI",["COPY HOLY WAR — URAL GAYSIN MIDI LINK"]="КОПИРОВАТЬ MIDI HOLY WAR — УРАЛ ГАЙСИН",["COPY RUSH E MIDI LINK"]="КОПИРОВАТЬ MIDI RUSH E",["SCAN MUSIC BLOCK INVENTORY"]="СКАНИРОВАТЬ МУЗЫКАЛЬНЫЕ БЛОКИ",["PRINT DUPLICATION STEPS TO CONSOLE"]="ВЫВЕСТИ ШАГИ ДЮПА В КОНСОЛЬ",["Game diagnostics"]="Диагностика игры",["DIAGNOSTICS V3: вывод в консоль F9"]="ДИАГНОСТИКА V3: вывод в консоль F9",["FULL GAME STRUCTURE SCAN"]="ПОЛНОЕ СКАНИРОВАНИЕ ИГРЫ",["SCAN REMOTES (BUILD + REWARDS)"]="СКАНИРОВАТЬ REMOTE (СТРОЙКА + НАГРАДЫ)",["SCAN INTERACTION OBJECTS"]="СКАНИРОВАТЬ ОБЪЕКТЫ ВЗАИМОДЕЙСТВИЯ",
        ["SCAN MY CHARACTER + PLAYER DATA"]="СКАНИРОВАТЬ ПЕРСОНАЖА И ДАННЫЕ",["COPY DIAGNOSTIC INSTRUCTIONS"]="КОПИРОВАТЬ ИНСТРУКЦИЮ ДИАГНОСТИКИ",["Scan Workspace roots"]="СКАНИРОВАТЬ ОБЪЕКТЫ WORKSPACE",["Scan ReplicatedStorage remotes"]="СКАНИРОВАТЬ REMOTE В REPLICATEDSTORAGE",["Scan player attributes"]="СКАНИРОВАТЬ АТРИБУТЫ ИГРОКА",["Print current position"]="ПОКАЗАТЬ ТЕКУЩУЮ ПОЗИЦИЮ",["Print game information"]="ПОКАЗАТЬ ИНФОРМАЦИЮ ОБ ИГРЕ",
        ["Hub settings"]="Настройки хаба",["Destroy local preview"]="Удалить локальное превью",["Restore lighting"]="Восстановить освещение",["Restore camera FOV"]="Восстановить угол обзора",["Appearance / Внешний вид"]="Внешний вид",["Reset appearance"]="Сбросить внешний вид",
        ["Theme: Purple"]="Тема: Фиолетовая",["Theme: Cyan"]="Тема: Голубая",["Theme: Red"]="Тема: Красная",["Theme: Green"]="Тема: Зелёная",["Theme: Gold"]="Тема: Золотая",
        ["Choose your language / Выбери язык"]="Выбери язык / Choose your language"
    }
    if ru then
        for _,obj in ipairs(GUI:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("TextLabel") then
                local translated=translations[obj.Text]
                if translated then
                    obj.Text=translated
                elseif obj.Text:match("^Selected base:") then
                    obj.Text="Выбранная база:"..obj.Text:sub(14)
                elseif obj.Text:match("^Auto Build:") then
                    obj.Text="Автостройка:"..obj.Text:sub(12)
                end
            end
        end
        Top:FindFirstChildOfClass("TextLabel").Text="💎 DIAMOND BOAT HUB V21"
    else
        for _,obj in ipairs(GUI:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("TextLabel") then
                for english,russian in pairs(translations) do
                    if obj.Text==russian then obj.Text=english end
                end
            end
        end
        Top:FindFirstChildOfClass("TextLabel").Text="💎 DIAMOND BOAT HUB V21"
    end
    Intro.Visible=false
    Main.Visible=true
    showPage("HOME")
end

languageButton("🇷🇺 Русский",122,function() applyLanguage("ru") end)
languageButton("🇬🇧 English",174,function() applyLanguage("en") end)

showPage("HOME")
print("DIAMOND BOAT HUB V21 LOADED")
