--このスクリプトの付いている親の取得
local NPC = script.Parent

local NpcManager = require(game:GetService("ServerStorage").NpcManager)

--ServerStorageのポイントマネジャーを使えるようにする
local PointManager = require(game:GetService("ServerStorage").PointManager)
--足にPartが触れた時に呼び出す
NPC["Left Leg"].Touched:Connect(PointManager.PointCount)
NPC["Right Leg"].Touched:Connect(PointManager.PointCount)


--パスの作成
local PathParames = {
	["AgentHeight"] = 6,
	["AgentRadius"] = 2.5
}
local Path = game:GetService("PathfindingService"):CreatePath(PathParames)

--タグを使用する為にCollectionServiceを取得
local CollectionService = game:GetService("CollectionService")
--タグの付いているものを取得
local Point = CollectionService:GetTagged("Point")
--Pointの座標を入れる変数
local point_position = {}

--Pointの数分ループする
for i, point in ipairs(Point) do	
	--pointの座標を取得
	point_position[i] = point.Position
	--print(point_position[i])
end

--親のすべての子孫の中にPart、MeshPartがあればネットワークの所有権をなくす
for _,descendants in pairs(NPC:GetDescendants()) do
	if descendants:IsA("Part") or descendants:IsA("MeshPart") then
		descendants:SetNetworkOwner(nil)
	end
end


while true do
	--開始地点から終了地点までのパスを計算
	Path:ComputeAsync(NPC.HumanoidRootPart.Position, point_position[math.random(1, #point_position)])
	--ウェイポイントの数分ループを回す
	for _,waypoint in ipairs(Path:GetWaypoints()) do
		--NPCをウェイポイントまで移動する
		NPC.Humanoid:MoveTo(waypoint.Position)
		--パスファインダーが設定したポイントに移動しているときは、MoveToFinished:Wait()移動が完了するまで待機します。
		NPC.Humanoid.MoveToFinished:Wait()
	end
	--少し待ってから動き出すようにする
	task.wait(Random.new():NextNumber(1,3))
end