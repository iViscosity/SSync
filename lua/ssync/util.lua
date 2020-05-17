--[[
    Function: Timestamp

    Gets the current timestamp (24-hour time)

    Format:
        
        [HH:MM:SS]

    Example:
        
        > local ts = SSync.TimeStamp()
        > print(ts)
        [03:12:07]
]]--
function SSync.TimeStamp()
	return "[" .. os.date("%H:%M:%S", os.time()) .. "] "
end

--[[
	Function: Log

	Takes a message and logs it to the console.

	Parameters:

		message - The message to print
		... - Vararg list of parameters for pattern replacement in message.

	Example:

		name = ply:Nick()
		SSync.Log("Player %s has joined!", name)
]]--
function SSync.Log(message, ...)
	message = SSync.TimeStamp() .. "[SSync] [INFO]" .. string.format(message, ...)

	ServerLog(message)
end

--[[
	Function: Verbose

	*Should only be called internally*. Displays a verbose log. Only does anything if SSync.Config.VerboseLogging is enabled.

	Parameters:

		message - The message to print
		... - Vararg list of parameters for pattern replacement in message.
]]--
function SSync.Verbose(message, ...)
	if SSync.Config.VerboseLogging then
		SSync.Log(message, ...)
	end
end

--[[
	Function: SSync.Error(level, message)

	Takes an error message and logs it to the console.

	Parameters:

		level - The error level. 1 = warning, 2 = fatal
		message - The error message. Can include patterns.
		... - Vararg list of parameters for pattern replacement in message.

	Example:

		SSync.Error(2, "Could not connect to bans database: %s", err)
]]--
function SSync.Error(level, message, ...)
	if type(level) == "string" then
		message = level
		level = 1
	end

	level = math.Clamp(level, 1, 2)
	
	if level == 1 then ErrorNoHalt(SSync.TimeStamp() .. "[SSync] [WARN] " .. string.format(message, ...))
	elseif level == 2 then error(SSync.TimeStamp() .. "[SSync] [FATAL]" .. string.format(message, ...))
	end
end