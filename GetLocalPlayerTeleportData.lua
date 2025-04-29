local TeleportService = game:GetService("TeleportService")

game.ReplicatedStorage.ObtainServerCode.OnClientInvoke:Connect(function()
	local ServerCode = TeleportService:GetLocalPlayerTeleportData()
	if ServerCode ~= nil then
		return ServerCode
	else
		warn("Attempt to Code From Player Failed, Returning Nil")
		return nil
	end
end)
