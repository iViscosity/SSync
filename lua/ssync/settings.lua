local c = ssync.settings -- shorthand, don't change

 -- keep this false unless I ask you to enable. this will flood your server console with
 -- tons of messages to help debug, so unless you want a ton of unnecessary I/O load, keep 
 -- it off (false)
c.verboseLogging = false

--[[
	SSync Configuration

	Feel free to edit anything past this point to your liking. You can enable and disable modules
	as well as change the parameters in which data is synchronized.

	Just make sure that your value matches the type of the default. Default values are my suggestion,
	but you can change them to however you want.
]]--

-- Enable/Disable modules. Set to 'false' to disable.
c.enabledModules = {
	banSync = true,
	rankSync = true
}

--[[ BanSync Settings ]]--
--------------------------

-- Minimum ban time for BanSync to sync the ban. Default: 0 (will sync every ban)
c.banSync_minimumBanTime = 0

-- Whether or not to automatically unban a player from all servers if they are manually unbanned.
c.banSync_autoUnban = false


--[[ RankSync Settings ]]--
---------------------------

-- List of ranks to not sync. Do not include "user" here, as that is the default group.
c.rankSync_ignoreRanks = {}

-- Whether or not to sync users added with TempAdd (https://forums.ulyssesmod.net/index.php/topic,5953.0.html)
c.rankSync_tempRanks = false