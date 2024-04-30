--このスクリプトの付いている親の取得
local NPC = script.Parent

--ServerStorageのNpcManagerを使えるようにする
local NpcManager = require(game:GetService("ServerStorage").NpcManager)
--ネットワーク所有権の設定
NpcManager.NetworkOwner(NPC,nil)
--パスの作成
NpcManager.PathCreate(6,2)

--ServerStorageのPointManagerを使えるようにする
local PointManager = require(game:GetService("ServerStorage").PointManager)
--足にPartが触れた時に呼び出す
NPC["Left Leg"].Touched:Connect(PointManager.PointCount)
NPC["Right Leg"].Touched:Connect(PointManager.PointCount)

while true do
	--移動処理
	NpcManager.Move(NPC)
	--少し待ってから動き出すようにする
	task.wait(Random.new():NextNumber(1,3))
end