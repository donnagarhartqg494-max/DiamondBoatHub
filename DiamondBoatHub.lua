
--==================================================
-- DIAMOND BOAT HUB V8
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
    Text="💎 DIAMOND BOAT HUB V8",
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
        for i,item in ipairs(snapshot) do
            if not buildRunning then break end
            local currentBuildRF=getBuildTool()
            if not currentBuildRF then
                failed+=1
                warn("BuildingTool недоступен для блока",i)
                task.wait(0.2)
                continue
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
                for attempt=1,12 do
                    placedBlock=findJustPlacedBlock(beforeSet,item.name,item.cframe)
                    if placedBlock then break end
                    task.wait(0.05)
                end
                if placedBlock and item.size then
                    local scalingTool=equipScalingTool()
                    local scalingRF=scalingTool and scalingTool:FindFirstChild("RF")
                    if scalingRF and scalingRF:IsA("RemoteFunction") then
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
            if i%8==0 then task.wait(0.12) else task.wait(0.035) end
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

-- AUTO FARM V8
label(farm,"AUTO FARM GOLD V8")
label(farm,"Activates each CaveStage event, checks OtherData progress, touches chest, claims gold.")

local farmEnabled=false
local farmRunId=0
local farmDelay=1.2

local function farmLog(...)
    print("[DIAMOND AUTO FARM V8]",...)
end

local function farmObjects()
    local stages=Workspace:FindFirstChild("BoatStages")
    local normal=stages and stages:FindFirstChild("NormalStages")
    if not normal then return nil,nil,nil,nil,"BoatStages.NormalStages missing" end
    local finish=normal:FindFirstChild("TheEnd")
    local chest=finish and finish:FindFirstChild("GoldenChest")
    local trigger=chest and chest:FindFirstChild("Trigger")
    local claim=Workspace:FindFirstChild("ClaimRiverResultsGold")
    local other=Player:FindFirstChild("OtherData")
    if not trigger or not trigger:IsA("BasePart") then return normal,nil,claim,other,"GoldenChest.Trigger missing" end
    return normal,trigger,claim,other,nil
end

local function farmAlive()
    local char=Player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return char,root,hum
end

local function farmMove(cf)
    local char,root,hum=farmAlive()
    if not char or not root or not hum or hum.Health<=0 then return false end
    char:PivotTo(cf)
    return true
end

local function waitStageProgress(other,index,runId)
    if not other then return true end
    local value=other:FindFirstChild("Stage"..index)
    if not value then return true end
    local deadline=os.clock()+3
    while farmEnabled and runId==farmRunId and os.clock()<deadline do
        local v=value.Value
        if v~=nil and v~="" and v~=false and v~=0 then return true end
        task.wait(0.1)
    end
    return false
end

local function touchChest(trigger)
    local char,root,hum=farmAlive()
    if not char or not root or not hum or hum.Health<=0 then return false end
    local target=trigger.CFrame*CFrame.new(-5,-1.7,0)*CFrame.Angles(0,math.rad(-90),0)
    char:PivotTo(target)
    task.wait(0.15)
    if typeof(firetouchinterest)=="function" then
        pcall(function()
            firetouchinterest(root,trigger,1)
            task.wait(0.1)
            firetouchinterest(root,trigger,0)
        end)
    end
    return true
end

local function runFarm(runId)
    local normal,chest,claim,other,err=farmObjects()
    if err then farmLog("STOP:",err); farmEnabled=false; return end
    if not farmAlive() then Player.CharacterAdded:Wait() end

    for i=1,10 do
        if not farmEnabled or runId~=farmRunId then return end
        local stage=normal:FindFirstChild("CaveStage"..i)
        local darkness=stage and stage:FindFirstChild("DarknessPart")
        if not darkness or not darkness:IsA("BasePart") then
            farmLog("Missing CaveStage"..i..".DarknessPart")
            farmEnabled=false
            return
        end
        if not farmMove(darkness.CFrame) then
            farmLog("Character not ready at stage",i)
            farmEnabled=false
            return
        end
        local event=darkness:FindFirstChild("Event")
        if event and event:IsA("BindableEvent") then
            pcall(function() event:Fire() end)
        elseif event and event:IsA("RemoteEvent") then
            pcall(function() event:FireServer() end)
        end
        farmLog("Stage",i,"activated")
        if not waitStageProgress(other,i,runId) then
            farmLog("Stage"..i.." progress not confirmed; continuing cautiously")
        end
        task.wait(farmDelay)
    end

    if not farmEnabled or runId~=farmRunId then return end
    local oldChar=Player.Character
    local respawned=false
    local conn=Player.CharacterAdded:Connect(function() respawned=true end)
    farmLog("Touching Golden Chest")
    touchChest(chest)

    local deadline=os.clock()+25
    while farmEnabled and runId==farmRunId and not respawned and os.clock()<deadline do
        task.wait(0.2)
    end
    conn:Disconnect()
    if not farmEnabled or runId~=farmRunId then return end
    if not respawned and Player.Character==oldChar then
        farmLog("Chest did not respawn character. Check whether all stages unlocked and touch is supported.")
        farmEnabled=false
        return
    end

    task.wait(1.5)
    if claim and claim:IsA("RemoteEvent") then
        local ok,why=pcall(function() claim:FireServer() end)
        farmLog("ClaimRiverResultsGold:",ok and "sent" or tostring(why))
    else
        farmLog("ClaimRiverResultsGold RemoteEvent missing; chest may auto-claim")
    end
    task.wait(5)
    farmLog("Run complete")
end

button(farm,"START AUTO FARM",function()
    if farmEnabled then farmLog("Already running"); return end
    local _,_,_,_,err=farmObjects()
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
    farmLog("Stop requested")
end)

button(farm,"SCAN FARM ROUTE",function()
    local normal,chest,claim,other,err=farmObjects()
    if err then farmLog("SCAN:",err); return end
    farmLog("NormalStages:",normal:GetFullName())
    for i=1,10 do
        local stage=normal:FindFirstChild("CaveStage"..i)
        local dark=stage and stage:FindFirstChild("DarknessPart")
        local event=dark and dark:FindFirstChild("Event")
        local progress=other and other:FindFirstChild("Stage"..i)
        farmLog("CaveStage"..i,dark and dark:GetFullName() or "MISSING",
            "Event:",event and event.ClassName or "none",
            "Progress:",progress and tostring(progress.Value) or "not found")
    end
    farmLog("Chest:",chest:GetFullName())
    farmLog("Claim:",claim and claim:GetFullName() or "MISSING")
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
print("DIAMOND BOAT HUB V8 LOADED")
