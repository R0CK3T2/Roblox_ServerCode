local DataStoreService = game:GetService("DataStoreService")
local CodeDataStore = DataStoreService:GetDataStore("UntitledServerCodeDatastore")
function RemoveCodeFromDataStore()
	pcall(function()
		CodeDataStore:RemoveAsync(game.ReplicatedStorage.ServerCode.Value)
	end)
end

game:BindToClose(RemoveCodeFromDataStore)
