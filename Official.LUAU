



local l = game.Players.LocalPlayer.Character
l.Sheathe:Destroy()
l["#KATANAWEAPON"]:Destroy()
		
		--// Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local repStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

--// Paths
local localPlayer = players.LocalPlayer
local localChar = localPlayer.Character
local renderStepped = runService.RenderStepped
local stepped = runService.Stepped
local heartBeat = runService.Heartbeat

local kocAssets = repStorage.Resources:FindFirstChild("Sukuna") or game:GetObjects("rbxassetid://86452577533201")[1]
kocAssets.Parent = repStorage
kocAssets.Name = "Sukuna"
local heianAssets = kocAssets and kocAssets:FindFirstChild("Heian")
local particles = kocAssets and kocAssets:FindFirstChild("Particles")

spawn(function()
    local directory = "SlashyBoy"
    local foldername = "SlashyBoy"
    makefolder(foldername)
    local files = {
        "Chant1",
        "Chant2",
        "Chant3Slash",
        "DismantleFire",
        "DismantleFire2",
        "DismantleM1Hit",
        "DismantleM1Swing",
        "DismantleSwing",
        "Fuga",
        "GetLost",
        "Kai",
        "M1Hit1",
        "M1Hit2",
        "M1Hit4",
        "M1Swing1",
        "M1Swing2",
        "M1Swing4",
        "MalevolentShrineChime",
        "RightThere",
        "RyoikiTenkai",
        "Slashes",
        "WCSCast",
        "WCSCharge",
    }
    for i,v in pairs(files) do
        if not isfile(foldername .. "/" .. v .. ".mp3") then
            local Time = tick()
            local Interlude = request({
                Url = "https://github.com/skibiditoiletfan2007/" .. directory .. "/raw/main/" .. v .. ".mp3",
                Method = "GET"
            }).Body

            if Interlude then
                print("'" .. v .. "' Downloaded in "..string.format("%.2f", tick() - Time).."s.")
                writefile(foldername .. "/" .. v .. ".mp3", Interlude)
            else
                warn("'" .. v .. "' failed to load.")
            end
        end
    end
end)

--------------------------[[Settings]]--------------------------
getgenv().setting1 = true
getgenv().FightMusic = true

--------------------------------------------------------------------------------------
--------------------------[[VARIABLES]]--------------------------
local plr = game.Players.LocalPlayer
local pGui = plr.PlayerGui
local cam = workspace.CurrentCamera
local mouse = plr:GetMouse()

local ch = plr.Character
local rt = ch.HumanoidRootPart
local hum = ch:WaitForChild("Humanoid")
local chosenchar = ch:GetAttribute("Character")

local hotbar = pGui:FindFirstChild("Hotbar")
local backpack = hotbar:FindFirstChild("Backpack")
local hotbarFrame = backpack:FindFirstChild("Hotbar")

--------------------------[[FUNCTIONS]]--------------------------
function lerp(a,b,t) return a + (b - a) * t end
function bezier(p0,p1,p2,t) local q0 = lerp(p0,p1,t) local q1 = lerp(p1,p2,t) return lerp(q0,q1,t) end

function animstop()
	for _, animTrack in pairs(hum:GetPlayingAnimationTracks()) do
		animTrack:Stop()
	end
end

--GET CUSTOM SFX
function GetGitSoundID(GithubSnd,SoundName)
	local url=GithubSnd
	SoundName=tostring(SoundName)
	writefile("customObject_Sound_"..SoundName..".mp3", game:HttpGet(url))
	return (getcustomasset or getsynasset)("customObject_Sound_"..SoundName..".mp3")
end
function noti(t,d,i) --creates notifications
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = t,
		Text = d,
		Icon = "rbxassetid://11370348455"
	})
end

function removecutscene()
	local player = game.Players.LocalPlayer
	task.spawn(function()
		local caught = player.Character:WaitForChild("CameraRig")
		caught.AnimationController:Destroy()
		caught.camera.CFrame = (player.Character.HumanoidRootPart.CFrame*CFrame.new(0,5,15))
		caught.camera:Remove()
	end)
end

function kjanim(id,speed,tim)
	task.spawn(function()
		local Anim = Instance.new("Animation")
		Anim.AnimationId = "rbxassetid://"..id
		local k = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
		Anim.AnimationId = "rbxassetid://0"
		k.Priority = Enum.AnimationPriority.Action4
		k:Play()
		if tim then
			k.TimePosition = tim
		end
		if speed then
			k:AdjustSpeed(speed)
		end
	end)
end

--SHORTCUT CREATE SFX
function sfx(id,p,d)
	local SlashSound = Instance.new("Sound")
	SlashSound.SoundId = id
	SlashSound.Parent = p
	SlashSound.Volume = .7
	if d then
		game.Debris:AddItem(SlashSound,15)
	end
	return SlashSound
	
	--[[EXAMPLE:
	if its set to true then it deletes itself after 15 seconds
	sfx(1234567890,workspace,true)
	]]
end

local debuffs = {
	["NoBlock"] = true,
	["NoJump"] = true,
	["StopRunning"] = true,
	["Freeze"] = true,
	["Slowed"] = true,
	["ComboStun"] = true,
	["M1CD"] = true,
	["NoDash"] = true,
	["NoPunch"] = true,
	["UsedDash"] = true,
	["Ragdoll"] = true,
	["RagdollSim"] = true,
	["LaunchLanded"] = true,
	["LaunchEnded"] = true,
	["NoRotate"] = true,
	["BeingGrabbed"] = true,
	["NoVel"] = true,
	["BeingLaunched"] = true,
}


--------------------------[[ANIM PRESETS]]--------------------------
local baseanims = {
	["Minicut"]=10503381238; --3 m1 then uppercut
	["Downslam"]=10470104242; --3 m1 then downslam

	["FrontDash"]=10479335397;
	["leftdash"]=10480796021;
	["rightdash"]=10480793962;

	["block"]=10470389827;
}
local atomicanims = {
	["M1"]=15259161390;
	["M2"]=15240216931;
	["M3"]=15240176873;
	["M4"]=15162694192;
	
	["QuickSlice"]=15290930205;
	["AtmosCleave"]=15145462680;
	["PinpointCut"]=15295895753;
	["SplitSecond"]=15311685628;
	["SplitCounter"]=15334974550;

	["BlaUltimate"]=15391323441;
	["Sunset"]=15520132233;
	["SolarCleave"]=12447707844;
	["Sunrise"]=11343318134;
	["AtomicSlash"]=11343318134;

	["WallCombo"]=15997042291;
	["Spawn"] = 15983615423;
}

--------------------------[[MAIN CODE]]--------------------------
print(chosenchar) --prints the character ur currently using (press F9 to see prints)

if chosenchar == "Blade" then --checks if using right character
	local isult = false
	local died = false
	local nostun = false
	
	
	--------------------------[[ULTIMATE BAR & Other]]--------------------------
	local LocalPlayer = game.Players.LocalPlayer
 
local function typewriterEffect(label, text, delayTime)
    label.Text = ""
    for i = 1, #text do
        label.Text = label.Text .. text:sub(i, i)
        wait(delayTime)
    end
end
 
local function resetHotbarText()
    coroutine.wrap(function()
        local magicHealth = LocalPlayer.PlayerGui.ScreenGui:WaitForChild("MagicHealth")
        local healthBar = magicHealth:WaitForChild("Health"):WaitForChild("Bar"):WaitForChild("Bar")
        local healthGlow = magicHealth.Health.Glow
        local hotbar = LocalPlayer.PlayerGui.Hotbar.Backpack.Hotbar
 
        -- Image for the ult Bar
        healthBar.Image = "rbxassetid://17136251960"
        healthGlow.Image = "rbxassetid://17136251821"
 
       healthBar.ImageColor3 = Color3.fromRGB(130,15,45)
        game:GetService("TweenService"):Create(healthBar, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {ImageColor3 = Color3.fromRGB(30, 30, 30)}):Play()
       

        typewriterEffect(magicHealth.TextLabel, "THE STRONGEST IN HISTORY", 0.08)
 
    end)()
end
 
resetHotbarText()
	
	--------------------------[[CUSTOM FIGHT MUSIC]]--------------------------
	local fightsong = getgenv().FightMusic
	if fightsong then
		local fsong = Instance.new("Sound",workspace)
		fsong.SoundId = customsfx
		fsong.Volume = 2
		fsong.Name = "SFX"
		
		local lasthealth = hum.Health
		local isplaying = false
		hum.Changed:Connect(function()
			if hum.Health<75 and isult == false then
				if isplaying == false then
					isplaying = true
					lasthealth = hum.Health
					fsong.Volume = 2
					fsong:Play()
					fsong.TimePosition = 23
					
					local timer = os.clock()
					repeat
						wait()
					until hum.Health > 99 or died == true or isult == true --os.clock()-timer>
					game.TweenService:Create(fsong,TweenInfo.new(2),{Volume = 0}):Play()
					wait(2)
					fsong:Stop()
					isplaying = false
				end
			end
		end)
	end
	
	--Anti-Stun
	local stundebounce = false
	task.spawn(function()
		game:GetService("RunService").Heartbeat:Connect(function()
			if nostun then
				for i,v in pairs(ch:GetChildren()) do
					if debuffs[v.Name] then
						v:Remove()
					end
				end
			end
		end)
	end)
	
	--Thing
	local real1 = hotbarFrame["1"].Base.ToolName:Clone()
	hotbarFrame["1"].Base.ToolName.Visible = false
	real1.Parent = hotbarFrame["1"].Base
	local real2 = hotbarFrame["2"].Base.ToolName:Clone()
	hotbarFrame["2"].Base.ToolName.Visible = false
	real2.Parent = hotbarFrame["2"].Base
	local real3 = hotbarFrame["3"].Base.ToolName:Clone()
	hotbarFrame["3"].Base.ToolName.Visible = false
	real3.Parent = hotbarFrame["3"].Base
	local real4 = hotbarFrame["4"].Base.ToolName:Clone()
	hotbarFrame["4"].Base.ToolName.Visible = false
	real4.Parent = hotbarFrame["4"].Base
	local num1 = plr.PlayerGui.Hotbar.Backpack.Hotbar["1"]
	local num2 = plr.PlayerGui.Hotbar.Backpack.Hotbar["2"]
	local num3 = plr.PlayerGui.Hotbar.Backpack.Hotbar["3"]
	local num4 = plr.PlayerGui.Hotbar.Backpack.Hotbar["4"]
	
	
	--------------------------[[MOVESET NAMER]]--------------------------
	function basemove()		
		real1.Text = "Ruthless Dismantle"
		real2.Text = "Demonic Slashes"
		real3.Text = "Blitzing Cleave"
		real4.Text = "Quick-Step Slashes"
		isult = false
		wait(.1)
		
		local plr = game.Players.LocalPlayer
		for i,v in pairs(plr.Backpack:GetChildren()) do
			print(i,v)
		end
		for i,v in pairs(plr.PlayerGui.Hotbar.Backpack.Hotbar:GetChildren()) do
			print(i,v)
		end
	end
	function ultimatemove()
		isult = true
		real1.Text = "Divine Comboing Flames"
		real2.Text = ""
		real3.Text = "?"
		real4.Text = "?"
	end
	basemove()
	
	
	
	--------------------------[[SPAWN]]--------------------------
	function spawnt()
		task.spawn(function()
			animstop()
			
			local Anim1 = Instance.new("Animation")
			Anim1.AnimationId = "rbxassetid://"..00000000000
			local k = hum:LoadAnimation(Anim1)
			k.Priority = Enum.AnimationPriority.Action2
			k:Play()
			k.TimePosition = 5
			k:AdjustSpeed(1)
				
			repeat
				wait(.1)
			until rt.AssemblyLinearVelocity.Magnitude>10
			
			k:Stop()
		end)
	end
	spawnt()
	
	
	----------------------------[[MOVESET Editor]]----------------------------
	function MovesetEditor(animationTrack)
		local playinga = animationTrack.Animation.AnimationId
		
		--[[Base]]--------------------
		if playinga == "rbxassetid://" .. atomicanimns["NormalPunch"] then	
			animstop()
			local AnimAnim = Instance.new("Animation")
			AnimAnim.AnimationId = "rbxassetid://"..00000 

			local Anim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(AnimAnim)
			Anim:Play()
			Anim.TimePosition = .5
		end
		
		
		--[[Ultimate]]--------------------
		if playinga == "rbxassetid://" .. atomicanimns["SeriousPunch"] then	
			animstop()
			removecutscene()

			task.delay(.1,function()
				for i,v in pairs(workspace:GetChildren()) do
					if v:IsA("Sound") then
						if v.SoundId == "rbxassetid://15103769292" then
							v:Remove()
						end
					end
				end
			end)
		end
	end--end of moveseteditor
	

	----------------------------[[CoreStuff Editor]]----------------------------
	function CoreEditor(animationTrack)
		local playinga = animationTrack.Animation.AnimationId
		
		--[[M1s]]--------------------
		if animationTrack.Animation.AnimationId == "rbxassetid://" .. atomicanimns["M1"] then
			task.spawn(function()
				animationTrack:Play(99999)
			end)
			local AnimAnim = Instance.new("Animation")
			AnimAnim.AnimationId = "rbxassetid://"..13532562418--13390230973

			local Anim = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(AnimAnim)
			Anim:Play()
			Anim:AdjustSpeed(1)

			sfx(9041161094,workspace,true)
		end
		if animationTrack.Animation.AnimationId == "rbxassetid://" .. atomicanimns["M2"] then
			sfx(9041161094,workspace,true)
		end
		if animationTrack.Animation.AnimationId == "rbxassetid://" .. atomicanimns["M3"] then
			sfx(9041161094,workspace,true)
		end
		if animationTrack.Animation.AnimationId == "rbxassetid://" .. atomicanimns["M4"] then
			sfx(9041161094,workspace,true)
		end
		
		--[[OtherCores]]--------------------
		if playinga == "rbxassetid://" .. baldanims["Spawn"] then
			local Humanoid = plr.Character:WaitForChild("Humanoid")
			animstop()
			spawnt()
		end
		if playinga == "rbxassetid://" .. baldanims["SaiUltimate"] then
			animstop()

			sfx(9041161094,workspace,true)

			wait()
			ultimatemove()
		end
	end--end of coreeditor
	

	----------------------------[[Other]]----------------------------
	hum.Animator.AnimationPlayed:Connect(MovesetEditor)
	hum.Animator.AnimationPlayed:Connect(CoreEditor)
	
	ch.ChildAdded:Connect(function(h)
		if h:IsA("Highlight") then
			h.FillColor = Color3.fromRGB(150,0,0) --character ults fill color, this is red on default
		end
	end)

	ch.Humanoid.Died:Connect(function()
		died = true
	end)
	
else --if using the wrong character
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = "Use Atomic",
		Text = "You cant use this without the character",
		Icon = "rbxassetid://"
	})
end --end of bald
