local CurrentPart = nil
local MaxInc = 11

function onTouched(hit)
	if hit.Parent == nil then
		return
	end

	local humanoid = hit.Parent:findFirstChild("Humanoid")

	if humanoid == nil then
		CurrentPart = hit
	end
end

function waitForChild(parent, childName)
	local child = parent:findFirstChild(childName)

	if child then
		return child
	end

	while true do
		print(childName)

		child = parent.ChildAdded:wait()

		if child.Name==childName then
			return child
		end
	end
end

local Figure = script.Parent
local Humanoid = waitForChild(Figure, "Humanoid")
local Torso = waitForChild(Figure, "Torso")
local Left = waitForChild(Figure, "Left Leg")
local Right = waitForChild(Figure, "Right Leg")

Humanoid.Jump = true

Left.Touched:connect(onTouched)
Right.Touched:connect(onTouched)

while true do
	wait(math.random(0.001, 3))

	if CurrentPart ~= nil then
		if math.random(1, 2) == 1 then
			Humanoid.Jump = false
		end

		Humanoid:MoveTo(Torso.Position + Vector3.new(math.random(-MaxInc, MaxInc), 0, math.random(-MaxInc, MaxInc)), CurrentPart)
	end
end
