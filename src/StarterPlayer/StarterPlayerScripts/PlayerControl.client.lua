--Lshiftのキーコードを入れる
local KEY_LSHIFT = Enum.KeyCode.LeftShift
--Zのキーコードを入れる
local KEY_Z = Enum.KeyCode.Z
--走るスピード
local RUN_SPEED = 20
--歩くスピード
local WALK_SPEED = 10
--最大スタミナ
local MAX_STAMINA = 100
--スタミナ固定値
local STAMINA_FIXED_VALUE = 20
--疲労回復する値
local FATIGUE_RECOVERY = 30

--UserInputServiceを取得
local UserInputService = game:GetService("UserInputService")
--プレイヤーを取得
local Players = game:GetService("Players")
local Player = Players:FindFirstChildOfClass("Player")
--ReplicatedStorageを取得
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--RemoteEventを取得
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
--時間管理のために取得
local RunService = game:GetService("RunService")

--スタミナ
local stamina = MAX_STAMINA
--疲労状態(true : 疲労している false : 疲労していない)
local fatigue_state = false
--走っているか(true : 走っている false : 走っていない)
local running = false
--しゃがんでいるか(true : しゃがんでいる false : しゃがんでいない)
local crouch = false

--プレイヤースピードを変える
local function SpeedConversion(active)
	--プレイヤーについているHumanoidを取得
	local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")	

	--走っているときかつ、しゃがんいないとき
	if active  and crouch ~= true then
		--プレイヤーのスピードを走るスピードに変える
		Humanoid.WalkSpeed = RUN_SPEED
	else
		--プレイヤーのスピードを歩くスピードに変える
		Humanoid.WalkSpeed = WALK_SPEED
	end
end

--プレイヤーのしゃがみ変換
local function Crouching(down)
	--プレイヤーについているHumanoidを取得
	local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")	

	if down then
		--プレイヤーのスピードを歩くスピードに変える
		Humanoid.WalkSpeed = WALK_SPEED
	else
		--しゃがみ解除したときに走っていれば走るようにする
		if running then
			--プレイヤーのスピードを走るスピードに変える
			Humanoid.WalkSpeed = RUN_SPEED
		end
	end

	--しゃがんでいるかの情報をサーバー側に渡す
	RemoteEvent:FireServer(down)
end


--入力した時の処理
local function PushKey(key)		
	--Lshiftを押しているとき
	if key.KeyCode == KEY_LSHIFT then
		--走っている状態に
		running = true
		SpeedConversion(running)
	end
	
	--Zキーを押したときかつ、しゃがんでいないとき
	if key.KeyCode == KEY_Z and crouch ~= true then
		--プレイヤーをしゃがみ状態に
		crouch = true
		Crouching(crouch)
	end
end

--離された時の処理
local function ReleaseKey(key)	
	--離したキーがLshiftの時
	if key.KeyCode == KEY_LSHIFT then
		--走っていない状態に
		running = false;
		SpeedConversion(running)
	end

	--離したキーがZの時
	if key.KeyCode == KEY_Z then
		--プレイヤーをしゃがみ状態を解除
		crouch = false
		Crouching(crouch)
	end
end

--スタミナ管理
local function StaminaManagement(deltatime)
	--走っているとき
	if running then
		--スタミナが残っていれば
		if stamina > 0 then
			--スタミナを減らす
			--今のスタミナ　－　スタミナ固定値　×　前のフレームからの経過時間(40fps なら 1/40)
			stamina = stamina - STAMINA_FIXED_VALUE * deltatime
		--スタミナが無いとき
		else
			--歩き状態にする
			SpeedConversion(false)
			--疲労状態にする
			fatigue_state = true
		end
	--走っていないとき
	--スタミナが満タンでなければ
	elseif stamina < MAX_STAMINA then
		--スタミナを回復する
		--今のスタミナ　+　スタミナ固定値　×　前のフレームからの経過時間(40fps なら 1/40)
		stamina = stamina + STAMINA_FIXED_VALUE * deltatime
		--スタミナが疲労回復する値より大きければ
		if stamina > FATIGUE_RECOVERY then
			--疲労状態を回復
			fatigue_state = false
		end

	end
end

--プレイヤーの入力（キーボード、マウス）を検知したときに呼び出す
UserInputService.InputBegan:Connect(PushKey)
--プレイヤーがキーボード、マウスを離したときに呼び出す
UserInputService.InputEnded:Connect(ReleaseKey)

RunService.Heartbeat:Connect(StaminaManagement)