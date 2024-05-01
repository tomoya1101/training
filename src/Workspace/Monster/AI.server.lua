--このスクリプトの付いている親の取得
local NPC = script.Parent

--ServerStorageのNpcManagerを使えるようにする
local NpcManager = require(game:GetService("ServerScriptService").NpcManager)
--ネットワーク所有権の設定
NpcManager.NetworkOwner(NPC,nil)
--パスの作成
NpcManager.PathCreate(6,2)

--ServerStorageのPointManagerを使えるようにする
local PointManager = require(game:GetService("ServerScriptService").PointManager)
--足にPartが触れた時に呼び出す
NPC["leftleg"].Touched:Connect(PointManager.PointCount)
NPC["rightleg"].Touched:Connect(PointManager.PointCount)

while true do
	--移動処理
	NpcManager.PassedTimesManyPointMove(NPC)
	--少し待ってから動き出すようにする
	task.wait(Random.new():NextNumber(1,2))
end