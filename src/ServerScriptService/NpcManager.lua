local NpcManager = {}
-----------------------------------------------------------------------
-- ネットワーク所有権
-----------------------------------------------------------------------
--ネットワーク所有権の設定（scriptの付いている親、true(所有権を取得) or nil(所有権を破棄)）
function NpcManager.NetworkOwner(Npc,bool)
	for _,descendants in pairs(Npc:GetDescendants()) do
		if descendants:IsA("Part") or descendants:IsA("MeshPart") then
			descendants:SetNetworkOwner(bool)
		end
	end
end

-----------------------------------------------------------------------
-- パス
-----------------------------------------------------------------------
--パスを入れる変数
local Path

--パスの作成（NPC高さ、NPC横幅）
function NpcManager.PathCreate(height,radius)
	--パスパラメーター
	local PathParames ={
		["AgentHeight"] = height,
		["AgentRadius"] = radius
	}
	Path = game:GetService("PathfindingService"):CreatePath(PathParames)
end

-----------------------------------------------------------------------
-- ポイントの取得
-----------------------------------------------------------------------
--ServerStorageのPointManagerを使えるようにする
local PointManager = require(game:GetService("ServerScriptService").PointManager)

-----------------------------------------------------------------------
-- 移動処理
-----------------------------------------------------------------------
--NPC移動処理、通った回数が最小値のポイントに移動（scriptの付いている親）
function NpcManager.PassedTimesFewPointMove(Npc)
	--Pointの座標を入れる変数
	local point_position = PointManager.MinPassedPosition()
	local rand_position =  point_position[math.random(1, #point_position)]
	--開始地点から終了地点までのパスを計算
	Path:ComputeAsync(Npc.HumanoidRootPart.Position,rand_position)

	--ウェイポイントの数分ループを回す
	for _,waypoint in ipairs(Path:GetWaypoints()) do
		--NPCをウェイポイントまで移動する
		Npc.Humanoid:MoveTo(waypoint.Position)
		--パスファインダーが設定したポイントに移動しているときは、MoveToFinished:Wait()移動が完了するまで待機します。
		Npc.Humanoid.MoveToFinished:Wait()
	end
end

--NPC移動処理、通った回数が最小値より多いポイントに移動（scriptの付いている親）
function NpcManager.PassedTimesManyPointMove(Npc)
	--Pointの座標を入れる変数
	local point_position = PointManager.ManyPassedPosition()
	local rand_position =  point_position[math.random(1, #point_position)]
	--開始地点から終了地点までのパスを計算
	Path:ComputeAsync(Npc.HumanoidRootPart.Position,rand_position)

	--ウェイポイントの数分ループを回す
	for _,waypoint in ipairs(Path:GetWaypoints()) do
		--NPCをウェイポイントまで移動する
		Npc.Humanoid:MoveTo(waypoint.Position)
		--パスファインダーが設定したポイントに移動しているときは、MoveToFinished:Wait()移動が完了するまで待機します。
		Npc.Humanoid.MoveToFinished:Wait()
	end
end

return NpcManager
