local steamData = {}

function GetBucketPlayerCount()
    local bucketCounts = {}
    for _, playerId in ipairs(GetPlayers()) do
        local playerBucket = GetPlayerRoutingBucket(playerId)
        if not bucketCounts[playerBucket] then
            bucketCounts[playerBucket] = 0
        end
        bucketCounts[playerBucket] = bucketCounts[playerBucket] + 1
    end

    return bucketCounts
end

function ExtractIdentifiers(src)
    local identifiers = {}
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        end
    end
    return identifiers
end

RegisterNetEvent("ns-lobbysystem:setbucket", function(bucket)
    src = source
    SetPlayerRoutingBucket(src, bucket)
    print(src, bucket)
end)

RegisterNetEvent("ns-lobbysystem:refreshdata")
AddEventHandler("ns-lobbysystem:refreshdata", function()
    local source = source
    local ids = ExtractIdentifiers(source)
    local steamID = ""
    if ids.steam then
        steamID = ids.steam:gsub("steam:", "")
    else
        steamID = ""
    end
    steamID = tonumber(steamID, 16)
    local steamAPIKey = Config.steamAPIKey
    local steamAPIURL = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" .. steamAPIKey .. "&steamids=" .. steamID
    PerformHttpRequest(steamAPIURL, function(err, text, headers)
        local jsonData = json.decode(text)
        local profile = jsonData.response.players[1]
        if profile then
            local avatarURL = profile.avatarfull
            local steamName = profile.personaname
            steamData[source] = {
                steamID = steamID,
                avatarURL = avatarURL,
                steamName = steamName
            }
            local bucketCounts = GetBucketPlayerCount()
            TriggerClientEvent("ns-lobbysystem:getdata", source, steamData[source], bucketCounts)
        else
            print("Steam profile UNKNOWN.")
        end
    end)
end)
