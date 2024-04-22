--プレイヤーの取得
local Players = game:GetService("Players")
--ReplicatedStorageを取得
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--RemoteEventを取得
local remoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

--ローカルからのデータを受けとる（player : どのプレイヤーか,data : ローカルから渡される）
remoteEvent.OnServerEvent:Connect(function(player, data)
	--プレイヤーについているHUmanoidを取得
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")	
	--humanoidに付いているHumanoidDescriptionを取得
	local description = humanoid:WaitForChild("HumanoidDescription")
	--しゃがみ状態の時
	if data then
		--プレイヤーのサイズを小さくする
		description.HeightScale -= 0.3
		--変更を適用
		humanoid:ApplyDescription(description)
	else
		--プレイヤーのサイズを大きくする
		description.HeightScale += 0.3
		--変更を適用
		humanoid:ApplyDescription(description)		
	end
end)
