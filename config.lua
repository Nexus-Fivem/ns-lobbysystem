Config = {}

Config.steamAPIKey = ""

Config.DefaultTheme = "dark"  -- "light" or "dark"

Config.LobbyCommand = "lobby"

Config.OnMenu = {
    Teleport = true,
    TeleportCoords = vec4(2178.21, 2913.26, -84.80, 66.19)
}

Config.LobbyList = {
    [1] = {
        Label = "Main Lobby", --Main Text
        Desc  = "Main place to meet everyone.", -- Bottom Desription 
        PrimaryColor = "#23c27a",
        SecondaryColor = "#a6fff3",
        Image = "https://nexusdev.online/assets/img/nexusreklam.png",
        Animation = "wait13",
        Bucket = 0
    },
    [2] = {
        Label = "Drift Lobby",
        Desc  = "Freeroam area for drifting enthusiasts.",
        PrimaryColor = "#fc7303",
        SecondaryColor = "#fafafa",
        Image = "https://nexusdev.online/assets/img/nexusreklam.png",
        Animation = "pointpose",
        Bucket = 2
    },
    [3] = {
        Label = "PVP Lobby",
        Desc  = "Competitive combat zone for player versus player.",
        PrimaryColor = "#ff0000",
        SecondaryColor = "#000000",
        Image = "https://nexusdev.online/assets/img/nexusreklam.png",
        Animation = "mafia",
        Bucket = 3
    },
    [4] = {
        Label = "Racing Lobby",
        Desc  = "Race track for racing enthusiasts.",
        PrimaryColor = "#5a36a3",
        SecondaryColor = "#1f2159",
        Image = "https://nexusdev.online/assets/img/nexusreklam.png",
        Animation = "cashcase2",
        Bucket = 4
    },
    [5] = {
        Label = "Flight Lobby",
        Desc  = "Fly planes, helicopters, and other aircraft.",
        PrimaryColor = "#05faee",
        SecondaryColor = "#b3b2ab",
        Image = "https://nexusdev.online/assets/img/nexusreklam.png",
        Animation = "tpose",
        Bucket = 5
    },
    [6] = {
        Label = "RP Lobby 1",
        Desc  = "Roleplay area for immersive experiences.",
        PrimaryColor = "#23c27a",
        SecondaryColor = "#a6fff3",
        Image = "https://nexusdev.online/assets/img/nexusreklam.png",
        Animation = "army2l",
        Bucket = 6
    }
}

Config.Locale = {
    players = "Players",
    connect = "Connect",
    light = "Light",
    dark = "Dark",
    close = "Close"
}