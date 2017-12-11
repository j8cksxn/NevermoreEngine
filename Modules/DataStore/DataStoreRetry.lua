--- General usage datastore retry function.
-- @module DataStoreRetry

local RunService = game:GetService("RunService")

local DATASTORE_RETRIES = 3

-- @function DataStoreRetry
--- Retries calls to the datastore
local function DataStoreRetry(DataStoreFunction)
	local Tries = 0	
	local Success = true
	local Data = nil
	repeat
		Tries = Tries + 1
		local Error
		Success, Error = ypcall(function() 
			Data = DataStoreFunction() 
		end)
		if not Success then
			warn(("[DataStoreRetry] - Datastore failure '%s'. Retrying!"):format(tostring(Error)))
			if not RunService:IsStudio() then
				wait(1)
			end
		end
	until Tries == DATASTORE_RETRIES or Success
	if not Success then
		warn("[DataStoreRetry] - Datastore completely failed. No more recovery attempts.")
	end
	return Success, Data
end

return DataStoreRetry