local Mob = script.Parent.Parent.Parent.Parent.Parent:FindFirstChild("Humanoid")

while true do
	wait(0.1)
	
	script.Parent.HealthNum.Text = math.floor(Mob.Health) .. " / " .. math.floor(Mob.MaxHealth)
	
	local pie = (Mob.Health / Mob.MaxHealth)
	script.Parent.Healthbar.Size = UDim2.new(pie, 0, 1, 0)
end