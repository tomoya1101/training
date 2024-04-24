-----------------------------------------------------------------------
-- 定数
-----------------------------------------------------------------------

--Eのキーコードを入れる
local KEY_E = Enum.KeyCode.E
--走るスピード
local RUN_SPEED = 20
--歩くスピード
local WALK_SPEED = 10
--反応距離（Playerの心音を鳴らす）
local FEEDBACK_DISTANCE = 20

-----------------------------------------------------------------------
-- ゲーム内に存在するものを取得
-----------------------------------------------------------------------

--UserInputServiceを取得
local UserInputService = game:GetService("UserInputService")
--プレイヤーを取得
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Player = Players:FindFirstChildOfClass("Player")
--タグを使用する為にCollectionServiceを取得
local CollectionService = game:GetService("CollectionService")

-----------------------------------------------------------------------
-- bool型 変数
-----------------------------------------------------------------------

--近くにN㍶がいるか(treu : いる false : いない)
local near_enemy = false

-----------------------------------------------------------------------
-- 音源 変数
-----------------------------------------------------------------------

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

while task.wait() do
	-----------------------------------------------------------------------
	-- プレイヤー関係
	-----------------------------------------------------------------------

	--nilチェック プレイヤー存在しているか
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
		
		
		--Workspaceに存在する”NPC”Tagがついたものを全て取得
		local Npcs = CollectionService:GetTagged("NPC")
		--距離を配列で確保する
		local distance = {}
		--npcsの数分ループする
		for i, npc in ipairs(Npcs) do
			--Npcに付いているHumanoidRootPartを取得
			local NpcRoot = npc:FindFirstChild("HumanoidRootPart")
			--Playerに付いているHumanoidRootPartを取得
			local PlayerRoot = Player.Character:FindFirstChild("HumanoidRootPart")
			--PlaeyrとNpcの距離をMagnitudeを使い表す
			distance[i] = (NpcRoot.Position - PlayerRoot.Position).Magnitude
			--print(distance) --距離が取れているかテスト
			
			--PlayerとNpcの距離が一定値よりも小さければ
			if distance[i] < FEEDBACK_DISTANCE then
				--近くにいる状態にする
				near_enemy = true
				--以下の処理を行ないたくないのでbreak
				break
			end
			
			--近くにNpcが存在しなかったので
			--近くにいない状態にする
			near_enemy = false
		end
		
		--近くにN㍶がいるか
		if near_enemy then
			--サウンド再生していないとき
			if  HeartSound.IsPlaying == false then
				--心音を鳴らす
				HeartSound:Play()
			end
		else
			--心音を止める
			HeartSound:Stop()
		end
	end
end