function waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)
	if child then return child end
	while true do
		child = parent.ChildAdded:wait()
		if child.Name==childName then return child end
	end
end

local Figure = script.Parent
local Torso = waitForChild(Figure, "Torso")
local RightShoulder = waitForChild(Torso, "Right Shoulder")
local LeftShoulder = waitForChild(Torso, "Left Shoulder")
local RightHip = waitForChild(Torso, "Right Hip")
local LeftHip = waitForChild(Torso, "Left Hip")
local Neck = waitForChild(Torso, "Neck")
local Humanoid = waitForChild(Figure, "Humanoid")
local pose = "Standing"

local currentAnim = ""
local currentAnimTrack = nil
local currentAnimKeyframeHandler = nil
local oldAnimTrack = nil
local animTable = {}
local animNames = {
	idle = 	{	
				{ id = "http://www.roblox.com/asset/?id=125750544", weight = 9 },
				{ id = "http://www.roblox.com/asset/?id=125750618", weight = 1 }
			},
	walk = 	{ 	
				{ id = "http://www.roblox.com/asset/?id=125749145", weight = 10 }
			},
}

-- Setup animation objects
for name, fileList in pairs(animNames) do
	animTable[name] = {}
	animTable[name].count = 0
	animTable[name].totalWeight = 0

	-- check for config values
	local config = script:FindFirstChild(name)
	if (config ~= nil) then
--		print("Loading anims " .. name)
		local idx = 1
		for _, childPart in pairs(config:GetChildren()) do
			animTable[name][idx] = {}
			animTable[name][idx].anim = childPart
			local weightObject = childPart:FindFirstChild("Weight")
			if (weightObject == nil) then
				animTable[name][idx].weight = 1
			else
				animTable[name][idx].weight = weightObject.Value
			end
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
--			print(name .. " [" .. idx .. "] " .. animTable[name][idx].anim.AnimationId .. " (" .. animTable[name][idx].weight .. ")")
			idx = idx + 1
		end
	end

	-- fallback to defaults
	if (animTable[name].count <= 0) then
		for idx, anim in pairs(fileList) do
			animTable[name][idx] = {}
			animTable[name][idx].anim = Instance.new("Animation")
			animTable[name][idx].anim.Name = name
			animTable[name][idx].anim.AnimationId = anim.id
			animTable[name][idx].weight = anim.weight
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + anim.weight
--			print(name .. " [" .. idx .. "] " .. anim.id .. " (" .. anim.weight .. ")")
		end
	end
end

-- ANIMATION

-- functions

function stopAllAnimations()
	local oldAnim = currentAnim

	currentAnim = ""
	if (currentAnimKeyframeHandler ~= nil) then
		currentAnimKeyframeHandler:disconnect()
	end

	if (oldAnimTrack ~= nil) then
		oldAnimTrack:Stop()
		oldAnimTrack:Destroy()
		oldAnimTrack = nil
	end
	if (currentAnimTrack ~= nil) then
		currentAnimTrack:Stop()
		currentAnimTrack:Destroy()
		currentAnimTrack = nil
	end
	return oldAnim
end

local function keyFrameReachedFunc(frameName)
	if (frameName == "End") then
--		print("Keyframe : ".. frameName)
		local repeatAnim = stopAllAnimations()
		playAnimation(repeatAnim, 0.0, Humanoid)
	end
end

-- Preload animations
function playAnimation(animName, transitionTime, humanoid)
	if (animName ~= currentAnim) then		
		
		if (oldAnimTrack ~= nil) then
			oldAnimTrack:Stop()
			oldAnimTrack:Destroy()
		end

		local roll = math.random(1, animTable[animName].totalWeight)
		local origRoll = roll
		local idx = 1
		while (roll > animTable[animName][idx].weight) do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end
--		print(animName .. " " .. idx .. " [" .. origRoll .. "]")
		local anim = animTable[animName][idx].anim

		-- load it to the humanoid; get AnimationTrack
		oldAnimTrack = currentAnimTrack
		currentAnimTrack = humanoid:LoadAnimation(anim)
		
		-- play the animation
		currentAnimTrack:Play(transitionTime)
		currentAnim = animName

		-- set up keyframe name triggers
		if (currentAnimKeyframeHandler ~= nil) then
			currentAnimKeyframeHandler:disconnect()
		end
		currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
	end
end

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------


function onRunning(speed)
	if speed>0 then
		playAnimation("walk", 0.1, Humanoid)
		pose = "Running"
	else
		playAnimation("idle", 0.1, Humanoid)
		pose = "Standing"
	end
end

function onDied()
	pose = "Dead"
end

local function moveSit()
	RightShoulder.MaxVelocity = 0.15
	LeftShoulder.MaxVelocity = 0.15
	RightShoulder:SetDesiredAngle(3.14 /2)
	LeftShoulder:SetDesiredAngle(-3.14 /2)
	RightHip:SetDesiredAngle(3.14 /2)
	LeftHip:SetDesiredAngle(-3.14 /2)
end

local lastTick = 0

function move(time)
	local amplitude = 1
	local frequency = 1
	local deltaTime = time - lastTick
	lastTick = time

	local climbFudge = 0
	local setAngles = false

	if (setAngles) then
		local desiredAngle = amplitude * math.sin(time * frequency)

		RightShoulder:SetDesiredAngle(desiredAngle + climbFudge)
		LeftShoulder:SetDesiredAngle(desiredAngle - climbFudge)
		RightHip:SetDesiredAngle(-desiredAngle)
		LeftHip:SetDesiredAngle(-desiredAngle)
	end
end

-- connect events
Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)

-- main program

local runService = game:service("RunService");

-- initialize to idle
playAnimation("idle", 1, Humanoid)
pose = "Standing"

while Figure.Parent~=nil do
	local _, time = wait(1)
	move(time)
end
