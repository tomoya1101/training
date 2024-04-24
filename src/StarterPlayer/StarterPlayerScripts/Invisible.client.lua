--プレイヤーリストの非表示
local GameStartGui = game:GetService("StarterGui")
GameStartGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList,false)

--マウスカーソルの非表示
local UserInputService = game:GetService("UserInputService")
--UserInputService.MouseIconEnabled = false

--一人称視点に変更
local player = game.Players.LocalPlayer
--player.CameraMode = Enum.CameraMode.LockFirstPerson


--プレイヤーについているHumanoidを取得
local Players = game:GetService("Players")
local Player = Players:FindFirstChildOfClass("Player")
while task.wait() do
    --nilチェック プレイヤー存在しているか
	if Player.Character then
        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")	
        --プレイヤーをジャンプできないようにする
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false) 
    end
end