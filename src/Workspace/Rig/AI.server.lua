local PathfindingService = game:GetService("PathfindingService") 
local NPC = script.Parent
local part = workspace.Point.Point

local path = PathfindingService:CreatePath()
path:ComputeAsync(NPC.HumanoidRootPart.Position,part.Position)

for _, waypoint in pairs(path:GetWaypoints()) do
	NPC.Humanoid:MoveTo(waypoint.Position)
	NPC.Humanoid.MoveToFinished:Wait()
end