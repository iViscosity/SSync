if not ssync.settings.enabledModules.banSync then return ssync.verbose("BanSync not enabled") end

ssync.banSync = {}
local bsync = ssync.banSync

function bsync.update()
	local queryString = "SELECT * FROM ssync_bans"
	local query = ssync.db:query(queryString)

	function query:onSuccess(data)
		while self:hasMoreResults() do
			local row = self:getData()[1]

			local steamid = row.steamid
			local time    = row.time
			local unban   = row.unban
			local reason  = row.reason
			local name    = row.name
			local admin   = row.admin

			ULib.addBan(steamid, (unban - time), reason, name, admin)
			ssync.log("%s ban synced", steamid)
		end
	end
end

function bsync.adduser(banData)
	if banData.time < ssync.settings.banSync_minimumBanTime then
		return ssync.verbose("Ignoring %s ban: below minimum ban time (%d < %d)", steamid, banData.time, ssync.settings.banSync_minimumBanTime)
	end


	local queryString = "REPLACE INTO ssync_bans (steamid, time, unban, reason, name, admin) " ..
		string.format("VALUES('%s', %d, %d, '%s', '%s', '%s')",
		banData.steamid,
		banData.time,
		banData.unban,
		banData.reason,
		banData.name,
		banData.admin)

	local query = ssync.db:query(queryString)

	function query:onError(err, sql)
		error("[SSync] An error occured while updating remote BanSync database: " .. err)
	end

	query:start()

	ssync.log("Successfully synced %s's ban.", banData.steamid)
end

function bsync.removeuser(steamid)
	local queryString = ("DELETE FROM ssync_bans WHERE steamid = '%s'"):format(steamid)
	local query = ssync.db:query(queryString)

	function query:onError(err, sql)
		error("[SSync] An error occured while removing a ban from the remote database: " .. err)
	end

	query:start()
end