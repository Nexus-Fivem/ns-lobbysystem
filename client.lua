local CachePos = nil
local CacheBucket = nil
RegisterNetEvent("ns-lobbysystem:getdata", function(data, bucketCounts)
    local theme = GetResourceKvpString('lobbytheme') or Config.DefaultTheme
    local locale = Config.Locale
    for i, lobby in ipairs(Config.LobbyList) do
        if bucketCounts[lobby.Bucket] then
            lobby.Players = bucketCounts[lobby.Bucket]
        else
            lobby.Players = 0
        end
    end
    SendNUIMessage({
        type = 'infos',
        steamfoto = data.avatarURL,
        isim = data.steamName
    })
    SendNUIMessage({
        type = "openmenu",
        data = Config.LobbyList,
        theme = theme,
        locale = locale

    })
end)

local function UpdateCamera()
    if cam then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        local boneIndex = 39317
        local boneCoords = GetPedBoneCoords(ped, boneIndex, -0.1, -0.5, 0.0)
            AttachCamToEntity(cam, ped, -1.0, 1.0, 0.4, true)
            PointCamAtCoord(cam, boneCoords.x, boneCoords.y, boneCoords.z)
    end
end

local function CreateCamera()
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamFov(cam, 60.0)
    SetCamUseShallowDofMode(cam, true)
    SetCamNearDof(cam, 0.1)
    SetCamFarDof(cam, 5.0)
    SetCamDofStrength(cam, 1.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, true)
    CreateThread(function()
        while DoesCamExist(cam) do
            UpdateCamera()
            SetUseHiDof()
            Wait(0)  
        end
    end)
end

local function DestroyCamera()
    if cam then
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
end

RegisterNetEvent("ns-lobbysystem:openmenu", function()
    if Config.OnMenu.Teleport then 
        local randombucket = source..""..math.random(1111, 9999)
        print(randombucket)
        CachePos = GetEntityCoords(PlayerPedId())
        DoScreenFadeOut(500)
        TriggerServerEvent("ns-lobbysystem:setbucket", randombucket)
        Wait(500)
        CreateCamera()
        FreezeEntityPosition(PlayerPedId(), toggle)
        SetEntityCoords(PlayerPedId(), Config.OnMenu.TeleportCoords.x, Config.OnMenu.TeleportCoords.y, Config.OnMenu.TeleportCoords.z)
        SetEntityHeading(PlayerPedId(), Config.OnMenu.TeleportCoords.w)
        Wait(1000)
        DoScreenFadeIn(500)
        TriggerServerEvent("ns-lobbysystem:refreshdata")
        local theme = GetResourceKvpString('lobbytheme') or Config.DefaultTheme
        print("lua tema: "..theme)
        local data = Config.LobbyList
        local locale = Config.Locale
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "openmenu",
            data = data,
            theme = theme,
            locale = locale
        })
    else
        TriggerServerEvent("ns-lobbysystem:refreshdata")
        local theme = GetResourceKvpString('lobbytheme') or Config.DefaultTheme
        print("lua tema: "..theme)
        CreateCamera()
        local data = Config.LobbyList
        SetNuiFocus(true, true)
        local locale = Config.Locale
        SendNUIMessage({
            type = "openmenu",
            data = data,
            theme = theme,
            locale = locale
        })
    end
end)

RegisterNUICallback("setbucket", function(data, cb)
    if Config.OnMenu.Teleport then 
        CacheBucket = data.bucket
    else
        TriggerServerEvent("ns-lobbysystem:setbucket", data.bucket)
        TriggerServerEvent("ns-lobbysystem:refreshdata")
    end
    print(data.bucket)
    cb('ok')
end)

RegisterNUICallback("playAnimation", function(data, cb)
        ExecuteCommand("e c")
        ExecuteCommand("e "..data.anim)
    cb('ok')
end)

RegisterNUICallback("stopAnimation", function(data, cb)
        local playerPed = PlayerPedId()
        ExecuteCommand("e c")
        Wait(100)
        ClearPedTasks(playerPed)
        cb('ok')
    end)

RegisterNUICallback("close", function(data, cb)
    if Config.OnMenu.Teleport then 
        print(CachePos)
        DoScreenFadeOut(500)
        Wait(500)
        SetEntityCoords(PlayerPedId(), CachePos)
        TriggerServerEvent("ns-lobbysystem:setbucket", CacheBucket)
        Wait(1000)
        CacheBucket = nil
        DestroyCamera()
        local playerPed = PlayerPedId()
        Wait(10)
        ExecuteCommand("e c")
        SetNuiFocus(false, false)
        CachePos = nil
        DoScreenFadeIn(500)
    else
        DestroyCamera()
        local playerPed = PlayerPedId()
        Wait(10)
        ExecuteCommand("e c")
        SetNuiFocus(false, false)
    end
    cb('ok')
end)

RegisterNUICallback("settheme", function(data, cb)
    SetResourceKvp('lobbytheme', data.theme)
    print("settheme "..data.theme)
    cb('ok')
end)

RegisterCommand(Config.LobbyCommand, function()
    TriggerEvent("ns-lobbysystem:openmenu")
end)