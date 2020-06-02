--[[
	SSync MySQL

	An interface using MySQLOO to send data to an external (or internal) MySQL Database.
	Make sure your settings here are correct, or else it will fail.
]]--

--[[ SSync MySQL Settings ]]--

local hostname = ""   -- url or IP for database
local username = ""   -- login username
local password = ""   -- login password
local database = ""   -- database in IP
local     port = 3306 -- port. probably 3306, only change if you're sure

--[[ End Settings : Do not edit past this line ]]--

if not ULib.fileExists("lua/bin/gsmv_mysqloo_*.dll") then
	return error("[SSync] Could not find MySQLOO module. Make sure it is located in 'garrysmod/lua/bin/'.")
end

require "mysqloo" -- load module

if tonumber(mysqloo.VERSION) < 9 then
	ErrorNoHalt("[SSync] MySQLOO module outdated. Things will probably still work but there may be security issues.")
end

local db = mysqloo.connect(hostname, username, password, database, port)

function db:onConnected()
	ssync.log("Database connected successfully. Initializing tables...")
	
	if ssync.settings.enabledModules.banSync then
		ssync.verbose("BanSync enabled, initializing...")

		local queryString = "CREATE TABLE IF NOT EXISTS ssync_bans (" ..
			"steamid TEXT NOT NULL PRIMARY KEY, " ..
			"time INTEGER NOT NULL, " ..
			"unban INTEGER NOT NULL, " ..
			"reason TEXT, " ..
			"name TEXT, " ..
			"admin TEXT);" -- I don't include "modified_time" and "_admin" because I don't want to lol
		
		ssync.verbose("Query string: \"%s\"", queryString)

		local query = db:query(queryString)

		function query:onError(err, sql)
			error("Could not create BanSync table: " .. err)
		end

		query:start()

		ssync.verbose("BanSync table created successfully.")
	end

	if ssync.settings.enabledModules.rankSync then
		ssync.verbose("RankSync enabled, initializing...")

		local queryString = "CREATE TABLE IF NOT EXISTS ssync_ranks (" ..
			"steamid TEXT NOT NULL PRIMARY KEY, " ..
			"role TEXT NOT NULL, " ..
			"temp TEXT DEFAULT 'N');"

		ssync.verbose("Query string: \"%s\"", queryString)

		local query = db:query(queryString)

		function query:onError(err, sql)
			error("Could not create RankSync table: " .. err)
		end

		query:start()

		ssync.verbose("RankSync table created successfully.")
	end
end

function db:onConnectionFailed(err)
	error("[SSync] Could not connect to the MySQL Database! Are your settings correct? (" .. err .. ")")
end

ssync.db = db
ssync.db:connect()