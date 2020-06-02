if not ssync.settings.enabledModules.rankSync then 
	return ssync.verbose("RankSync not enabled.")
end

ssync.rankSync = {}
local rsync = ssync.rankSync

-- updates our local ranks with the database
function rsync.update()
	local queryString = "SELECT * FROM ssync_ranks"
	local query = ssync.db:query(queryString)

	function query:onSuccess(data)
		while self:hasMoreResults() do
			local row = self:getData()[1]

			local sid  = row.steamid
			local rank = row.role
			local temp = row.temp

			if temp and not file.Exists("ulx/tempuserdata/" .. sid .. ".txt", "DATA") then
				ssync.verbose("Player %s has a temporary role that has expired. Deleting...", util.SteamIDFrom64(sid))
				ULib.queueFunctionCall(rsync.delete, sid)
				continue
			end

			ULib.ucl.addUser(util.SteamIDFrom64(sid), nil, nil, rank)
			ssync.log("Synced %s's rank (%s).", sid, rank)
		end
	end

	function query:onError(err, sql)
		error("[SSync] An error occurred while updating local groups table: " .. err)
	end

	query:start()
end

-- update the database with a person's new rank.
function rsync.adduser(steamid, group, temp)
	if not temp then temp = false end

	if temp and not ssync.settings.rankSync_tempRanks then
		return ssync.verbose("Not syncing %s's temporary rank: %s", steamid, group)
	end

	if table.HasValue(ssync.settings.rankSync_ignoreRanks, group) then
		return ssync.verbose("Ignoring sync on rank: %s", group)
	end

	local queryString = "REPLACE INTO ssync_ranks (steamid, role, temp) " .. string.format("VALUES ('%s', '%s', '%s');", steamid, group, temp and "Y" or "N")
	local query = ssync.db:query(queryString)

	function query:onError(err, sql)
		error("[SSync] An error occurred while updating remote RankSync database: " .. err)
	end

	query:start()

	ssync.log("Successfully synced %s's rank (%s)", steamid, group)
end