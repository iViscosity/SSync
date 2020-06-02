--[[
	Hooks

	Contain the functions and hooks that allow SSync to work properly.
]]--

function ssync.onPlayerBanned(steamid, banData)
	if ssync.settings.enabledModules.banSync then
		ssync.banSync.adduser(banData)
	end
end
hook.Add("ULibPlayerBanned", "SSync.OnPlayerBanned", ssync.onPlayerBanned)

function ssync.onPlayerUnbanned(steamid, admin)
	if ssync.settings.enabledModules.banSync and ssync.settings.banSync_autoUnban then
		ssync.banSync.removeuser(steamid)
	end
end
hook.Add("ULibPlayerUnBanned", "SSync.OnPlayerUnbanned", ssync.onPlayerUnbanned)

function ssync.onPlayerGroupChanged(id, allow, deny, group)
	local temp = file.Exists("ulx/tempuserdata/" .. util.SteamIDTo64(id), ".txt", "DATA")

	if ssync.settings.enabledModules.rankSync then
		if temp and not ssync.settings.rankSync_tempRanks then return end
		ssync.rankSync.adduser(id, group, temp)
	end
end
hook.Add("ULibUserGroupChange", "SSync.OnPlayerGroupChanged", ssync.onPlayerGroupChanged)