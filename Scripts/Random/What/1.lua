local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer


local QUEST_NAME = "Getting Started!"
local NPC_NAME = "Sensei Moro"
local QUEST_OPTION_ARG = "GiveIntroduction1"
local MOVE_SPEED = 25


local State = {
    noclipConn = nil,
    moveConn = nil,
    bodyVelocity = nil,
    bodyGyro = nil,
}

local function restoreCollisions()
    local char = player.Character
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

local function cleanupState()
    if State.noclipConn then
        State.noclipConn:Disconnect()
        State.noclipConn = nil
    end
    if State.moveConn then
        State.moveConn:Disconnect()
        State.moveConn = nil
    end
    if State.bodyVelocity then
        State.bodyVelocity:Destroy()
        State.bodyVelocity = nil
    end
    if State.bodyGyro then
        State.bodyGyro:Destroy()
        State.bodyGyro = nil
    end


    restoreCollisions()
end


local function enableNoclip()
    if State.noclipConn then return end
    
    local char = player.Character
    if not char then return end
    
    State.noclipConn = RunService.Stepped:Connect(function()
        if not char or not char.Parent then
            if State.noclipConn then State.noclipConn:Disconnect() State.noclipConn = nil end
            return
        end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function disableNoclip()
    if State.noclipConn then
        State.noclipConn:Disconnect()
        State.noclipConn = nil
    end

    restoreCollisions()
end


local function smoothMoveTo(targetPos, callback)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    

    if State.moveConn then State.moveConn:Disconnect() State.moveConn = nil end
    if State.bodyVelocity then State.bodyVelocity:Destroy() State.bodyVelocity = nil end
    if State.bodyGyro then State.bodyGyro:Destroy() State.bodyGyro = nil end
    

    enableNoclip()
    
  
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = hrp
    State.bodyVelocity = bv
    

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 10000
    bg.D = 500
    bg.Parent = hrp
    State.bodyGyro = bg
    
    print(string.format("   🚀 Moving to (%.1f, %.1f, %.1f)...", targetPos.X, targetPos.Y, targetPos.Z))
    
    State.moveConn = RunService.Heartbeat:Connect(function()
        if not char or not char.Parent or not hrp or not hrp.Parent then
            if State.moveConn then State.moveConn:Disconnect() State.moveConn = nil end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            State.bodyVelocity = nil
            State.bodyGyro = nil
            return
        end
        
        local currentPos = hrp.Position
        local direction = (targetPos - currentPos)
        local distance = direction.Magnitude
        
        if distance < 5 then
            print("   ✅ Reached NPC!")
            
            bv.Velocity = Vector3.zero
            task.wait(0.1)
            
            bv:Destroy()
            bg:Destroy()
            State.bodyVelocity = nil
            State.bodyGyro = nil
            
            if State.moveConn then State.moveConn:Disconnect() State.moveConn = nil end
            
            if callback then callback() end
            return
        end
        
        local speed = math.min(MOVE_SPEED, distance * 10)
        local velocity = direction.Unit * speed
        
        bv.Velocity = velocity
        bg.CFrame = CFrame.lookAt(currentPos, targetPos)
    end)
    
    return true
end


local function invokeDialogueStart(npcModel)
    local remote = ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Packages"):WaitForChild("Knit")
        :WaitForChild("Services"):WaitForChild("ProximityService")
        :WaitForChild("RF"):WaitForChild("Dialogue")
    if remote then
        remote:InvokeServer(npcModel)
        print("📡 1. Started Dialogue")
    end
end

local function invokeRunCommand(commandName)
    local remote = ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Packages"):WaitForChild("Knit")
        :WaitForChild("Services"):WaitForChild("DialogueService")
        :WaitForChild("RF"):WaitForChild("RunCommand")
    if remote then
        print("📡 2. Selecting Option: " .. commandName)
        pcall(function() remote:InvokeServer(commandName) end)
    end
end


local function ForceEndDialogueAndRestore()
    print("🔧 3. Forcing Cleanup & UI Restore...")

  
    local gui = player:FindFirstChild("PlayerGui")
    if gui then
        local dUI = gui:FindFirstChild("DialogueUI")
        if dUI then
            dUI.Enabled = false
            local bb = dUI:FindFirstChild("ResponseBillboard")
            if bb then bb.Visible = false end
        end
    end

    local cam = Workspace.CurrentCamera
    if cam then
        cam.CameraType = Enum.CameraType.Custom
        cam.FieldOfView = 70
    end

 
    local char = player.Character
    if char then
        local status = char:FindFirstChild("Status")
        if status then
            for _, tag in ipairs(status:GetChildren()) do
                if tag.Name == "DisableBackpack" or tag.Name == "NoMovement" or tag.Name == "Talking" then
                    tag:Destroy()
                    print("   - Removed Status Tag: " .. tag.Name)
                end
            end
        end
        
   
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end

   
    if gui then
        local main = gui:FindFirstChild("Main")
        if main then 
            main.Enabled = true 
            print("   - Main UI (Quest) Restored")
        end
        
        local backpack = gui:FindFirstChild("BackpackGui")
        if backpack then 
            backpack.Enabled = true 
            print("   - Backpack Restored")
        end
        
        local compass = gui:FindFirstChild("Compass")
        if compass then compass.Enabled = true end
        
        local mobile = gui:FindFirstChild("MobileButtons")
        if mobile then mobile.Enabled = true end
    end

  
    local remote = ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("Packages"):WaitForChild("Knit")
        :WaitForChild("Services"):WaitForChild("DialogueService")
        :WaitForChild("RE"):WaitForChild("DialogueEvent")
    if remote then
        remote:FireServer("Closed")
    end
    
    print("✅ Restore Complete")
end


local function getPlayerLevel()
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return nil end
    
    local levelLabel = gui:FindFirstChild("Main")
                      and gui.Main:FindFirstChild("Screen")
                      and gui.Main.Screen:FindFirstChild("Hud")
                      and gui.Main.Screen.Hud:FindFirstChild("Level")
    
    if not levelLabel or not levelLabel:IsA("TextLabel") then
        return nil
    end
    
    local levelText = levelLabel.Text
    local level = tonumber(string.match(levelText, "%d+"))
    return level
end


local function getActiveQuestName()
    local gui = player:FindFirstChild("PlayerGui")
    if not gui then return nil end
    local list = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Screen") 
                 and gui.Main.Screen:FindFirstChild("Quests") and gui.Main.Screen.Quests:FindFirstChild("List")
    if not list then return nil end
    for _, child in ipairs(list:GetChildren()) do
        if string.match(child.Name, "^Introduction%d+Title$") then
            local frame = child:FindFirstChild("Frame")
            if frame then
                local label = frame:FindFirstChild("TextLabel")
                if label and label.Text ~= "" then return label.Text end
            end
        end
    end
    return nil
end

local function getNpcModel(name)
    local prox = Workspace:FindFirstChild("Proximity")
    return prox and prox:FindFirstChild(name)
end


local NPC_POSITION = Vector3.new(-200.07, 30.37, 158.41)

local function forceCompleteQuest1()
    print("\n🔧 Checking if force complete is needed...")
    

    local gui = player:FindFirstChild("PlayerGui")
    local isQuestListEmpty = true
    
    if gui then
        local list = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Screen") 
                     and gui.Main.Screen:FindFirstChild("Quests") and gui.Main.Screen.Quests:FindFirstChild("List")
        if list then
            for _, child in ipairs(list:GetChildren()) do
             
                if child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                    isQuestListEmpty = false
                    break
                end
            end
        end
    end
    
 e
    if not isQuestListEmpty then
        print("   ⏭️  Quest List has items (not empty)")
        print("   → Skipping force complete (other quests active)")
        return false
    end
    
 
        NPC_POSITION.X, NPC_POSITION.Y, NPC_POSITION.Z))
    

    enableNoclip()
    
    local moveComplete = false
    smoothMoveTo(NPC_POSITION, function()
        moveComplete = true
    end)
    

    local timeout = 30
    local startTime = tick()
    while not moveComplete and tick() - startTime < timeout do
        task.wait(0.1)
    end
    
  
    cleanupState()
    disableNoclip()
    
    if not moveComplete then
   
    else
  
    end
    
    task.wait(0.5)
    
  
    local npcModel = getNpcModel(NPC_NAME)
    if npcModel then
     
        invokeDialogueStart(npcModel)
        task.wait(0.5)
    else
    
    end
    
    
  
    pcall(function()
        invokeRunCommand(QUEST_OPTION_ARG)
    end)
    task.wait(0.5)
  
    ForceEndDialogueAndRestore()
    
  
    return true
end


local function Run_Quest1()
  
    
 
    local gui = player:FindFirstChild("PlayerGui")
    local hasQuest1UI = false
    
    if gui then
        local list = gui:FindFirstChild("Main") and gui.Main:FindFirstChild("Screen") 
                     and gui.Main.Screen:FindFirstChild("Quests") and gui.Main.Screen.Quests:FindFirstChild("List")
        if list and list:FindFirstChild("Introduction0Title") then
            hasQuest1UI = true
        end
    end
    
    if hasQuest1UI then
     
     
    else
     
        
        
        local success = forceCompleteQuest1()
        if success then
            cleanupState()
            disableNoclip()
          
            return
        end
    end

    local npcModel = getNpcModel(NPC_NAME)
    if not npcModel then 
        cleanupState()
        disableNoclip()
        return warn("❌ NPC Not Found") 
    end
    
    local targetPart = npcModel.PrimaryPart or npcModel:FindFirstChildWhichIsA("BasePart")
    if not targetPart then
        cleanupState()
        disableNoclip()
        return warn("❌ NPC has no valid part")
    end
    
    local targetPos = targetPart.Position
    

        NPC_NAME, targetPos.X, targetPos.Y, targetPos.Z))
    
  
    local moveComplete = false
    smoothMoveTo(targetPos, function()
        moveComplete = true
    end)
    
  
    local timeout = 60
    local startTime = tick()
    while not moveComplete and tick() - startTime < timeout do
        task.wait(0.1)
    end
    
 
    if State.moveConn then State.moveConn:Disconnect() State.moveConn = nil end
    if State.bodyVelocity then State.bodyVelocity:Destroy() State.bodyVelocity = nil end
    if State.bodyGyro then State.bodyGyro:Destroy() State.bodyGyro = nil end
    
    if not moveComplete then
        cleanupState()
        disableNoclip()
        return warn("❌ Failed to reach NPC (timeout)")
    end
    
  
    task.wait(0.5)
    invokeDialogueStart(npcModel)
    
  
    task.wait(1.5)
    
  
    invokeRunCommand(QUEST_OPTION_ARG)
    
    print("⏳ Processing...")
    task.wait(0.5)
    
    ForceEndDialogueAndRestore()
    
  
    cleanupState()
    disableNoclip()
    
   
end

Run_Quest1()
