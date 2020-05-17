SSync.BanSync = SSync.BanSync or {}
local b = SSync.BanSync
local db = SSync.DB

if not SSync.Config.Modules.BanSync then return end

local function _nilIfNull(p)
    if p == "NULL" then return nil end
    return p
end

function b.Refresh()
    SSync.Verbose("Refreshing ban table...")
    ULib.refreshBans()
    local query_string = "SELECT * FROM ssync_bans;"

    local query = db:query(query_string)

    function query:onSuccess(data)
        while self:hasMoreResults() do
            local row = query:getData()[1]
            
            local steamid = row.steamid
            local time = row.time
            local unban = row.unban
            local reason = _nilIfNull(row.reason)
            local name = _nilIfNull(row.name)
            local admin = _nilIfNull(row.admin)

            if not ULib.bans[steamid] then
                ULib.addBan(steamid, unban - time, reason, name, admin)
            end

            self:getNextResults()
        end
    end
end