--Eのキーコードを入れる
local KEY_E = Enum.KeyCode.E
--走るスピード
local RUN_SPEED = 20
--歩くスピード
local WALK_SPEED = 10

--UserInputServiceを取得
local UserInputService = game:GetService("UserInputService")
--プレイヤーを取得
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Player = Players:FindFirstChildOfClass("Player")

--足音を追加する
local FootSound = Instance.new("Sound")
--追加する音のID
FootSound.SoundId = "rbxassetid://2076455443"
--親を決める
FootSound.Parent = script.Parent
--ループするか(true : ループする false : ループしない)
FootSound.Looped = true

--心音を追加する
local HeartSound = Instance.new("Sound")
--追加する音のID
HeartSound.SoundId = "rbxassetid://5948090748"
--親を決める
HeartSound.Parent = script.Parent
--ループするか(true : ループする false : ループしない)
HeartSound.Looped = true

while wait() do
	--nilチェック
	if Player.Character then
		--プレイヤーについているHumanoidを取得
		local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")	
		
		--スピードが走りより遅いときまたは
		--しゃがんでいるとき
		if Humanoid.WalkSpeed < RUN_SPEED or
			UserInputService:IsKeyDown(KEY_E) then

			--走る音を止める
			FootSound:Stop()
		else
			--サウンド再生していないとき
			if  FootSound.IsPlaying == false then
				--走る音を再生
				FootSound:Play()
			end
		end


		local CollectionService = game:GetService("CollectionService")
		local obj = workspace.Model
		local tags = CollectionService:GetTags(obj)
		print("The object " .. obj:GetFullName() .. " has tags: " .. table.concat(tags, ", "))

	end
end