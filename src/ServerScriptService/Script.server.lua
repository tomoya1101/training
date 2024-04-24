local CollectionService = game:GetService("CollectionService")
local npcs = CollectionService:GetTagged("NPC")

while wait() do
	for i, npc in ipairs(npcs) do
		--print(i,npc)
		--print(npc.HumanoidRootPart.Position)
		local npcroot = npc:FindFirstChild("HumanoidRootPart")
		--print(npcroot.Position)
	end
end
