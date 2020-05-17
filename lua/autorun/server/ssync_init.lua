-- leave this file alone
SSync = SSync or {}
SSync.Config = SSync.Config or {}

SSync.Version = "0.0.1a"
SSync.DevelopmentMode = true 

local function _init()
	if not ULib then
		SSync.Error(2, "ULib is required for SSync. Make sure ULib is installed correctly!")
		return
	end

	-- took the format from TeamUlysses. Hope you don't mind <3
	MsgN("//////////////////////////")
	MsgN("//        SSync         //")
	MsgN("//////////////////////////")
	MsgN("// Loading...           //")

	MsgN("//  ssync/util.lua      //")
	include("ssync/util.lua")
	MsgN("//  ssync/config.lua    //")
	include("ssync/config.lua")
	MsgN("//  ssync/mysql.lua     //")
	include("ssync/mysql.lua")
	MsgN("//  ssync/bansync.lua   //")
	include("ssync/bansync.lua")
	MsgN("//  ssync/ranksync.lua  //")
	include("ssync/ranksync.lua")

	MsgN("// Load complete!       //")
	MsgN("//////////////////////////")

	if SSync.DevelopmentMode then
		SSync.Error("This version (%s) is under development. There may be major bugs and some features may
		not work properly or at all. SSync will continue to initialize, but you may encounter errors.", SSync.Version)
	end

	_versionCheck()

	SSync.Update()
end

local function _versionCheck()
	local _version

	http.Fetch("https://raw.githubusercontent.com/iViscosity/SSync/master/build.version", 
	function(b)
		_version = b
	end,
	function(e)
		SSync.Error("Could not check version! %s", e)
	end)

	if _version ~= SSync.Version then
		SSync.Error("SSync is outdated! Local version: %s, Latest version: %s. Get the latest version at https://github.com/iViscosity/SSync/releases", _version, SSync.Version)
	end
end

hook.Add("Initialize", "SSync_Init", _init)