--====================================================================================
-- All work by jojos38 & Titch2000.
-- You have no permission to edit, redistribute or upload. Contact us for more info!
--====================================================================================



local M = {}

local function tick()
	local ownMap = vehicleGE.getOwnMap() -- Get map of own vehicles
	for i,v in pairs(ownMap) do -- For each own vehicle
		local veh = be:getObjectByID(i) -- Get vehicle
		if veh then
			veh:queueLuaCommand("positionVE.getVehicleRotation()")
		end
	end
end



local function sendVehiclePosRot(data, gameVehicleID)
	if Network.getStatus() == 2 then -- If UDP connected
		local serverVehicleID = vehicleGE.getServerVehicleID(gameVehicleID) -- Get serverVehicleID
		if serverVehicleID and vehicleGE.isOwn(gameVehicleID) then -- If serverVehicleID not null and player own vehicle
			Network.send(Network.buildPacket(0, 2134, serverVehicleID, data))
		end
	end
end


local function applyPos(data, serverVehicleID, timestamp)

	-- 1 = pos.x
	-- 2 = pos.y
	-- 3 = pos.z
	-- 4 = rot.x
	-- 5 = rot.y
	-- 6 = rot.z
	-- 7 = rot.w

	local gameVehicleID = vehicleGE.getGameVehicleID(serverVehicleID) or -1 -- get gameID
	local veh = be:getObjectByID(gameVehicleID)
	if veh then
		local pr = jsonDecode(data) -- Decoded data
		
		pos = vec3(pr[1], pr[2], pr[3])
		rot = quat(pr[4], pr[5], pr[6], pr[7])
		
		debugDrawer:drawSphere(pos:toPoint3F(), 0.2, ColorF(1.0,0.0,0.0,1.0))
		
		veh:queueLuaCommand("positionVE.setVehiclePosRot(" .. tostring(pos) .. "," .. tostring(rot) .. "," .. timestamp .. ")")
	end
end


M.applyPos          = applyPos
M.tick              = tick
M.sendVehiclePosRot = sendVehiclePosRot


return M
