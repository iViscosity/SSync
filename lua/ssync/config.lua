---------------------------
-- General Configuration --
---------------------------

SSync.Config.Modules = { -- Modules to enable (true) or disable (false)
	BanSync = true, -- Syncs bans between servers
	RankSync = true -- Syncs ranks between servers
}
SSync.Config.UpdateTimer = 1 -- The time (in minutes) to automatically update modules.
SSync.Config.VerboseLogging = false -- Whether or not to enable verbose logging. This will send a ton of debug messages in the console. Not recommended unless I ask you to to help debug.

----------------------------------
-- MySQL Database Configuration --
----------------------------------

SSync.Config.Hostname = ""
SSync.Config.Username = ""
SSync.Config.Password = ""
SSync.Config.Database = ""
SSync.Config.Port     = 3306 -- don't change unless you're sure