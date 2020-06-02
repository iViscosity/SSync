ssync = ssync or {}
ssync.settings = ssync.settings or {}

-- ssync configuration. this is loaded first because it affects module loading
include("settings.lua")

-- utility functions and logging
include("util.lua")

-- mysql wrapper with mysqloo
include("mysql.lua")

-- for synchronizing ranks
include("ranksync.lua")

-- for synchronizing bans
include("bansync.lua")

-- holds all the hooks that enable ssync to work
include("hooks.lua")