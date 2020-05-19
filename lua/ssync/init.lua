-- leave this file alone
SSync = SSync or {}
SSync.Config = SSync.Config or {}

SSync.Version = "0.0.1a"
SSync.DevelopmentMode = true 

local function _init()
    hook.Run("SSync_PreInitialize")
    -- took the format from TeamUlysses. Hope you don't mind <3
	MsgN("//////////////////////////")
	MsgN("//        SSync         //")
	MsgN("//////////////////////////")
	MsgN("// Loading...           //")

	MsgN("//  util.lua            //")
	include("util.lua")
	MsgN("//  config.lua          //")
	include("config.lua")
	MsgN("//  mysql.lua           //")
	include("mysql.lua")
	MsgN("//  bansync.lua         //")
	include("bansync.lua")
	MsgN("//  ranksync.lua        //")
	include("ranksync.lua")

	MsgN("// Load complete!       //")
	MsgN("//////////////////////////")

    -- Development Mode means that this install may contain experimental code
    -- It's dangerous to use, and may cause serious problems
	if SSync.DevelopmentMode then
		SSync.Error("This version (%s) is under development. There may be major bugs and some features may
		not work properly or at all. SSync will continue to initialize, but you may encounter errors.", SSync.Version)
	end

    -- Check version
	_versionCheck()

    -- Update all data (pull data from DB)
	SSync.Update(true)

    -- Any third-party functions have something to do?
    hook.Run("SSync_PostInitialize")
end

--[[
    Checks SSync's version by performing an HTTP request to the Github repository that it's hosted.
]]--
local function _versionCheck()
	local _version

	http.Fetch("https://raw.githubusercontent.com/iViscosity/SSync/master/build.version", 
	function(body, s, h, code)
        if code == 200 then
		    _version = b
        elseif code >= 500 and code <= 504 then
            return SSync.Error("Could not check version, appears Github service's are down. Error code: %d", code)
        end
	end,
	function(e)
		SSync.Error("Could not check version! %s", e)
	end)

	if _version ~= SSync.Version then
		SSync.Error("SSync is outdated! Local version: %s, Latest version: %s. Get the latest version at https://github.com/iViscosity/SSync/releases", _version, SSync.Version)
	end
end

hook.Add("Initialize", "SSync_Init", _init)