local c = SSync.Config -- because typing "SSync.Config" over and over hurts my fingees
local enabled = c.Modules.BanSync or c.ModulesRankSync

if not enabled then
    SSync.Log("No SSync Modules are enabled. Aborting...")
    return
end

require("mysqloo")

SSync.DB = mysqloo.connect(c.Hostname, c.Username, c.Password, c.Database, c.Port)
local db = SSync.DB

function db:onConnected()
    SSync.Log("Connected successfully to the database!")
    SSync.Verbose("Connection string: %s@%s:%d", Username, Hostname, Port)

    SSync.Log("Creating tables...")
    SSync.Verbose("Checking modules enabled (BanSync, RankSync): (%s, %s)", tostring(c.Modules.BanSync), tostring(c.Modules.RankSync))

    if c.Modules.BanSync then
        SSync.Verbose("BanSync enabled. Creating table...")

        local query_string = [[
            CREATE TABLE IF NOT EXISTS ssync_bans 
            ( 
                steamid        INTEGER NOT NULL PRIMARY KEY, 
                time           INTEGER NOT NULL, 
                unban          INTEGER NOT NULL, 
                reason         TEXT, 
                name           TEXT, 
                admin          TEXT
            ); 
        ]]

        local query = db:query(query_string)

        function query:onSuccess(data)
            SSync.Verbose("MySQL table 'ssync_bans' created successfully!")
        end

        function query:onError(err, q)
            SSync.Error(2, "Failed to create 'ssync_bans'! Error: %s, Sql: %s", err, q)
        end

        query:start()
    end

    if c.Modules.RankSync then
        SSync.Verbose("RankSync enabled. Creating table...")

        local query_string = [[
            CREATE TABLE IF NOT EXISTS ssync_ranks 
            ( 
                steamid INTEGER NOT NULL PRIMARY KEY, 
                rank    TEXT NOT NULL 
            ); 
        ]]

        local query = db:query(query_string)

        function query:onSuccess(data)
            SSync.Verbose("MySQL table 'ssync_ranks' created successfully!")
        end

        function query:onError(err, q)
            SSync.Error(2, "Failed to create 'ssync_ranks'! Error: %s, Sql: %s", err, q)
        end

        query:start()
    end
end

db:connect()

--[[
    Function: Refresh

    Ensures our ban/rank table is updated with the database.
]]--
function SSync.Refresh(ply)
    SSync.BanSync.Refresh()
    SSync.RankSync.Refresh()
end

--[[
    Function: Update

    Ensures our database is updated with the ban/rank table.

    Parameters:

        ply - The player to update. If nil, updates everyone.
]]--
function SSync.Update(ply)
    SSync.BanSync.Update(ply)
    SSync.RankSync.Update(ply)
end