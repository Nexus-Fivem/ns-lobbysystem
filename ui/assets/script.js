var open = false;
var hover = false;
var isPlaying = false;
var debounceTimer;

window.addEventListener('message', function(event) {
    if (event.data.type === 'openmenu') {
        open = true;
        $(".root").css("display", "block");
        openLobbyMenu(event.data.data, event.data.theme, event.data.locale);
    }
});

document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
        if (open) {
            Close()
        } 
    }
});

function Close() {
    if (open) {
        open = false;
        $(".root").css("display", "none");
        stopAnimation();
        saveCurrentTheme();
        fetch('https://ns-lobbysystem/close', {
            method: 'POST',
            body: JSON.stringify({})
        });
    } 
}

var currentPlayingLobby = null;

function openLobbyMenu(lobbies, Theme, Locale) {
    const lobbyContainer = document.getElementById('lobbies');
    lobbyContainer.innerHTML = ''; 
    const label = document.querySelector('.btn-color-mode-switch-inner');
    const button = document.querySelector('.button');
    console.log(Locale)
    label.dataset.off = Locale.light;
    label.dataset.on = Locale.dark;
    button.innerHTML = Locale.close
    lobbies.forEach(lobby => {
        const lobbyElement = document.createElement('div');
        lobbyElement.classList.add('lobby');
        lobbyElement.style.backgroundImage = `url('${lobby.Image}')`;
        lobbyElement.style.backgroundSize = 'cover'; 
        lobbyElement.style.backgroundPosition = 'center';
        lobbyElement.style.borderColor = lobby.PrimaryColor;

        lobbyElement.innerHTML = `
            <div class="lobby-things">
                <div class="lobby-players">
                    <div class="circlething" style="box-shadow: #00FF85 0px 0px 20px 0px;">
                        <div class="circlething-inner"></div>
                    </div>${lobby.Players} ${Locale.players}
                </div>
                <div class="lobby-name" style="color: ${lobby.PrimaryColor};">${lobby.Label}</div>
                <div class="lobby-description">${lobby.Desc}</div>
                <div class="lobby-button"style="color: ${lobby.SecondaryColor}; background-color: ${lobby.PrimaryColor};" onclick="connectToLobby(${lobby.Bucket})">
                    <div class="lobby-button-icon" style="background: linear-gradient(to bottom, ${lobby.SecondaryColor} 0%, ${lobby.PrimaryColor} 77%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;"><i class="fa-solid fa-link"></i></div>${Locale.connect}
                </div>
            </div>
            <div class="lobby-hover-gradient" style="background: linear-gradient(rgba(2, 0, 36, 0) 0%, ${lobby.PrimaryColor} 100%);"></div> 
            <div class="lobby-darker-image"></div>
        `;

        lobbyElement.addEventListener('mouseenter', () => {
            playAnimation(lobby.Animation);
        });
        lobbyContainer.appendChild(lobbyElement);
    });
    const checkbox = document.getElementById('color_mode');
    console.log(Theme)
    if (Theme === 'dark') {
        checkbox.checked = true;
        applyDarkTheme();
    } else {
        checkbox.checked = false;
        applyLightTheme();
    }

    checkbox.addEventListener('change', function () {
        if (this.checked) {
            applyDarkTheme();
        } else {
            applyLightTheme();
        }
    });
}

function debounce(func, delay) {
    clearTimeout(debounceTimer); 
    debounceTimer = setTimeout(func, delay);
}

function playAnimation(anim) {
    fetch('https://ns-lobbysystem/playAnimation', {  
        method: 'POST',
        body: JSON.stringify({anim})
    }).catch((error) => {
        console.error('Error:', error);
    });
}

function stopAnimation() {
    fetch('https://ns-lobbysystem/stopAnimation', {  
        method: 'POST',
        body: JSON.stringify({})
    });
}

function connectToLobby(bucket) {
    console.log(bucket);
    fetch('https://ns-lobbysystem/setbucket', {  
        method: 'POST',
        body: JSON.stringify({bucket})
    });
}

function saveCurrentTheme() {
    const checkbox = document.getElementById('color_mode');
    const theme = checkbox.checked ? 'dark' : 'light';
    fetch('https://ns-lobbysystem/settheme', {  
        method: 'POST',
        body: JSON.stringify({ theme })
    });
}

window.addEventListener('message', function(event) {
    if (event.data.type === 'infos') {
        const avatarURL = event.data.steamfoto;
        const steamName = event.data.isim;
        console.log(avatarURL, steamName);
        $(".usercard-steamname").html('<div class="circlething" style="margin-top: 0.88vh; animation: none !important; opacity: 1;"><div class="circlething-inner"></div> </div>' + steamName);
        $(".usercard-steamphoto").attr("src", avatarURL);
    }
});



function applyDarkTheme() {
    $(".lobby-gradient").css("background", "linear-gradient(90deg, rgba(0, 0, 0, 0) 0%, rgb(14, 14, 14) 100%)");
    $(".usercard").css("background", "rgb(29, 29, 29)");
    $(".usercard").css("color", "white");
    $(".usercard").css("box-shadow", "0px 0px 88px -35px rgba(0,0,0,0.75)");
}

function applyLightTheme() {
    $(".lobby-gradient").css("background", "linear-gradient(90deg, rgba(0, 0, 0, 0) 0%, rgb(255, 255, 255) 100%)");
    $(".usercard").css("background", "white");
    $(".usercard").css("color", "black");
    $(".usercard").css("box-shadow", "none");
}
