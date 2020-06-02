--[[
	SSync Utilities

	Includes functions for logging and other utility functions.
]]--

local dataPath = "data/ssync/logs/"
local logFile = os.date("data/ssync/logs/%m-%d-%y.txt")

if not ULib.fileExists(logFile) then
	ULib.fileWrite(logFile, "")
else
	ULib.fileWrite(logFile, "\r\n=====\r\n")
end
ULib.fileWrite("Map change: " .. game.GetMap())

--[[
	Function: ssync.timestamp

	Creates a timestamp in the format "<DD/MM/YY> @ [HH:mm:SS]" (pattern is <%x> @ [%X]) (pattern info: https://wiki.facepunch.com/gmod/os.date)
]]--
function ssync.timestamp()
	return os.date("<%x> @ [%X]")
end

--[[
	Function: ssync.log

	Logs a message to server console and writes to log file.

	Parameters:

		message - The message to write. Can use patterns.
		... - Vararg list of parameters to replace into message.
]]--
function ssync.log(message, ...)
	local m = ssync.timestamp() .. message:format(...) -- faster than string.format (~33%)

	ServerLog("[SSync] " .. m)
	ULib.fileWrite(logFile, m)
end

--[[
	Function: ssync.verbose

	Writes a verbose log, only performed if settings.verboseLogging is enabled. 
]]--
function ssync.verbose(message, ...)
	if ssync.settings.verboseLogging then
		ssync.log(message, ...)
	end
end