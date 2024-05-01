-----------------------------------------------------------------------
-- プレイヤー捜索
-----------------------------------------------------------------------
local PlayerService = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local npcModels = CollectionService:GetTagged("NPC")
--NPCがどこまで見れるか
local viewRange = 30
--NPCの視野
local fieldOfView = 70
--NPCが最後に見たオブジェクト
local objectLastDetected = nil
--ゲーム内のすべてのプレイヤーのキャラクターのを返します。
local function getCharacters()
	local characters = {}
	local players = PlayerService:GetPlayers()

	for index, player in players do
		table.insert(characters, player.Character)
	end

	return characters
end
--レイキャストヒット検出を行ない結果を返す
local function raycast(npc, start, finish)
	--Raycast操作のパラメータが格納される空のRaycastParmsを作成
	local parameters = RaycastParams.new()
	--レイキャスティング候補のフィルタリングにその子孫が使用されるオブジェクトの配列
	parameters.FilterDescendantsInstances = {npc, getCharacters()}
	--レイキャスト操作内のすべてのBasePart は、フィルター リスト内のオブジェクトの子孫であるものを除き、考慮されます。
	--npcとプレイヤーには当たらない
	parameters.FilterType = Enum.RaycastFilterType.Exclude
	--レイキャストヒット検出
	local raycast = workspace:Raycast(start, (finish - start), parameters)

	if raycast then
		print(raycast.Instance)
		print(raycast.Material)
		print(raycast.Distance)
		return true
	else
		return false
	end
end

local function checkSight(npc)
	local detectable = {}

	local characters = getCharacters()
	local taggedObjects = CollectionService:GetTagged("Detectable")

	for index, character in characters do
		table.insert(detectable, character)
	end

	for index, object in taggedObjects do
		table.insert(detectable, object)
	end

	--存在するキャラクターとDetectableタグの付いているオブジェクトの数ループする
	for index, object in detectable do
		--objectが特定の型かチェックする
		if object:IsA("Model") then
			--デフォルトはHumanoidRootPartが設定されているのでHumanoidRootPartが返ってくる
			object = object.PrimaryPart
		end

		local headPosition = npc.Head.Position

		local objectPosition = object.Position
		local headCFrame = npc.Head.CFrame

		--npcの頭からobjcetまでのベクトル
		local npcToObject = (objectPosition - headPosition).Unit
		--npcの頭から前方向コンポーネント
		local npcLookVector = headCFrame.LookVector
		--２つのベクトルが向いている方向が同じかどうか（-1 ~ 1）で返ってくる
		local dotProduct = npcToObject:Dot(npcLookVector)
		--角度 x (ラジアンで指定) を度単位で返します
		--逆余弦dotProduct
		local angle = math.deg(math.acos(dotProduct))
		--npcとobjcetの距離を求める
		local distance = (headPosition - objectPosition).Magnitude
		--視野外ならreturn
		if angle > fieldOfView then
			return
		end
		--距離が離れていればreturn
		if distance > viewRange then
			return
		end

		--レイキャストヒットすればreturn
		if raycast(npc, headPosition, objectPosition) then
			return
		end

		--objectが特定の型かチェックする
		if object:IsA("Model") then
			--Model型ならその親を最後に見たオブジェクトにする
			objectLastDetected = object.Parent
		else
			--Model型でなければそれを最後にみたオブジェクトにする
			objectLastDetected = object
		end

		return true
	end
end

for index, npc in npcModels do
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	--npcがModel型でなければcontinue
	if not npc:IsA("Model") then
		continue
	end
	--humanoidが見つからなければcontinue
	if not humanoid then
		continue
	end

	--
	local function checking()
		while task.wait(1) do
			if checkSight(npc) then
				print("test")
				-- Code for when an NPC sees a detectable object
			else
				print("test2")
				-- Code for when an NPC does not see a detectable object
			end
		end
	end

	coroutine.wrap(checking)()
end

