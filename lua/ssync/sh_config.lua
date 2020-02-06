--[[SSync Configuration]]--

SSync.Config.Enabled = true -- Whether or not SSync will run.
SSync.Config.Modules = { -- Modules to enable (true) or disable (false)
	BanSync = true, -- Syncs bans between servers
	RankSync = true -- Syncs ranks between servers.
}

SSync.Config.AutomaticUpdate = true -- Whether or not to automatically update the ban table at an interval
SSync.Config.UpdateTimer = 1 -- The time (in minutes) to automatically update the ban table. Only works of AutomaticUpdate is true
SSync.Config.