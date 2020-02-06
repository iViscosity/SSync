-- Leave this file alone
SSync = {}
SSync.Config = {}

SSync.Version = "0.01a"
SSync.Author = "iViscosity"
-- If this is true, the current state of the addon is potentially unusable. There may be major bugs and things not working.
-- Stable releases will have this set to "false"
SSync.DevelopmentMode = true 

AddCSLuaFile()
AddCSLuaFile("ssync/sh_config.lua")
include("ssync/sh_config.lua")

--[[
	Function: Log

	Takes a vararg (comma-separated) parameter and logs it to the console. Automatically adds spaces.

	Parameters:

		... - Vararg (comma-separated) parameters to be concatenated into a message.
]]--
function SSync.Log(...)
	local message = "[SSync] "
	for k, v in pairs(arg) do
		if k ~= "n" then
			if type(v) == "number" then
				message = message .. " " .. tostring(v)
			elseif type(v) == "table" then
				for _, j in pairs(v) do
					message = message .. " " .. tostring(j)
				end
			else -- assume string
				message = message .. " " .. v
			end
		end
	end

	if SERVER then
		ServerLog(message)
	elseif CLIENT then
		MsgN(message)
	end
end

--[[
	Function: SSync.Error(level, message)

	Takes an error level and a message and logs it to the console. Severe errors will cause a stack break.

	Parameters:

		level - 0, 1, or 2. 
			0 - "info". Same thing as SSync.Log(message).
			1 - "error". This is something that I recommend tending to ASAP. Will throw an ErrorNoHalt (code will continue to execute).
			2 - "failure". Something serious has gone wrong and things are going to hell in a handbasket.
			Any other value will result in calling SSync.Log(message).
]]--
function SSync.Error(level, message)
	if type(level) == "string" then
		message = level
		level = 0
	end
	
	if level == 1 then ErrorNoHalt("[SSync Error] " .. message)
	elseif level == 2 then error("[SSync Failure] " .. message)
	else SSync.Log(message)
	end
end

--[[
	Function: Initialize

	Starts initialization for SSync. Only called if SSync.Config.Enabled = true.
]]--
function SSync.Initialize()
	if SSync.DevelopmentMode then
		SSync.Error(1, [[Warning: This version (]] .. SSync.Version .. [[) is under development. There may be major bugs and some features may
		not work properly or at all. SSync will continue to initialize, but you may encounter errors.]])
	end

	local shared_files = file.Find("ssync/sh_*.lua", "LUA")
	local client_files = file.Find("ssync/cl_*.lua", "LUA")
	if SERVER then
		local server_files = file.Find("ssync/sv_*.lua", "LUA")
		for _, fil in pairs(server_files) do
			SSync.Log("Including SERVER file:", fil)
			include("ssync/" .. fil)
		end

		for _, fil in pairs(shared_files) do
			SSync.Log("Including SHARED file:", fil)
			include("ssync/" .. fil)
			AddCSLuaFile("ssync/" .. fil)
		end

		for _, fil in pairs(client_files) do
			SSync.Log("Adding CLIENT file:", fil)
			AddCSLuaFile("ssync/" .. fil)
		end
	elseif CLIENT then
		for _, fil in pairs(shared_files) do
			SSync.Log("Including SHARED file:", fil)
			include("ssync/" .. fil)
		end

		for _, fil in pairs(client_files) do
			SSync.Log("Adding CLIENT file:", fil)
			include("ssync/" .. fil)
		end
	end
end

if SSync.Config.Enabled then
	SSync.Initialize()
else
	SSync.Log("SSync is not enabled. Not initializing...")
end