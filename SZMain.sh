#!/bin/bash

clear
echo -e "\e[93m   _____       _ _                       "
echo -e "\e[93m  / ____|     | | |                      "
echo -e "\e[93m | (___   __ _| | |_ _   _               "
echo -e "\e[93m  \___ \ / _\` | | __| | | |              "
echo -e "\e[33m  ____) | (_| | | |_| |_| |              "
echo -e "\e[33m |_____/ \__,_|_|\__|\__, |              "
echo -e "\e[33m                      __/ |              "
echo -e "\e[31m  ______             \e[33m|___/   \e[31m_           "
echo -e "\e[31m |___  /              | |   (_)          "
echo -e "\e[31m    / / ___  _ __ ___ | |__  _  ___  ___ "
echo -e "\e[31m   / / / _ \| '_ \` _ \| '_ \| |/ _ \/ __|"
echo -e "\e[31m  / /_| (_) | | | | | | |_) | |  __/\__ \\"
echo -e "\e[31m /_____\___/|_| |_| |_|_.__/|_|\___||___/"
echo -e "                            \e[36mby Namsaknoi😀"
echo "                                        "
#;ls ./Saves

#curl -o PVP_News https://raw.githubusercontent.com/200779b/links/refs/heads/main/PVP_News
#wget -O PVP_News2 https://raw.githubusercontent.com/200779b/links/refs/heads/main/PVP_News


if [ ${_ADMIN} = 1 ]; then

echo "wait"
sleep 5
./SZ/SZAdmin.sh
sleep infinity
fi
_LIVEMAPPORT=$((SERVER_PORT + 7))  # Calculate the expected WebUI_Port value

if [ -f "./Saves/CpmSettings.xml" ]; then

# Extract the current <WebUI_Port> value from the XML file
_CURRENTPORT=$(grep -oP '(?<=<WebUI_Port>)[0-9]+(?=</WebUI_Port>)' ./Saves/CpmSettings.xml)

if [[ -z "$_CURRENTPORT" ]]; then
    echo "WebUI_Port not found in the CpmSettings.xml file."
    exit 1
fi

# Compare the current port with the expected port
if [[ "$_CURRENTPORT" -eq "$_LIVEMAPPORT" ]]; then
    echo -e "🧟  Live map: \e[38;5;111mhttp://$SERVER_IP:$_LIVEMAPPORT\e[0m."
else
    echo -e "⛔  Live map port seems incorrect. Expected: \e[38;5;111m$_LIVEMAPPORT\e[0m, Found: \e[38;5;9m$_CURRENTPORT\e[0m. ⛔"
    echo -e "Do you want to update it? (y/n - 10 seconds to answer)"
    echo -ne "Reply: "

    if ! read -t 10 yn < /dev/tty; then  # ✅ Fix: Explicitly read from the terminal
        echo -e "\nTimed out! Live map port unchanged."
        echo -e "🧟  Live map: \e[38;5;111mhttp://$SERVER_IP:$_CURRENTPORT\e[0m."
        yn="n"  # Default to "no" on timeout
    fi

    # Loop until valid input (y/n)
    while [[ ! "$yn" =~ ^[YyNn]$ ]]; do
        echo -ne "Invalid response. Please enter 'y' or 'n': "
        read yn < /dev/tty  # ✅ Fix: Ensuring input is taken from the terminal
    done

    case $yn in
        [Yy]* ) 
            echo "Live map port updated."
            sed -i "s|<WebUI_Port>[0-9]*</WebUI_Port>|<WebUI_Port>${_LIVEMAPPORT}</WebUI_Port>|" ./Saves/CpmSettings.xml
            echo -e "🧟  Live map: \e[38;5;111mhttp://$SERVER_IP:$_LIVEMAPPORT\e[0m."
            ;;
        [Nn]* ) 
            echo "Live map port unchanged."
            echo -e "🧟  Live map: \e[38;5;111mhttp://$SERVER_IP:$_CURRENTPORT\e[0m."
            ;;
    esac
fi

else
    echo -e "⛔  CPM not installed yet. Manually set live map port to \e[38;5;111m$_LIVEMAPPORT\e[0m or restart the server to adjust in here. ⛔"

fi

export TZ=tc/GMT+6
echo "Current date: "`date +%Y-%m-%d\(%Hh%M-CST\)`

# Define the log directory and file
LOG_DIR="./logs"  # Change this to your log directory
LATEST_LOG="${LOG_DIR}/latest.log"

# Get the highest log number
LAST_NUM=$(ls -1 "${LOG_DIR}"/log_*.log 2>/dev/null | sed -E 's/.*log_([0-9]+).*/\1/' | sort -n | tail -1)

# Default to 0 if no log files exist
if [[ -z "$LAST_NUM" ]]; then
    LAST_NUM=0
fi

# Increment log number
NEW_NUM=$((LAST_NUM + 1))

# Get the timestamp in CST format
NOW_TIMESTAMP=$(date +"%Y_%m_%d_%Hh%M_CST")

# Rename latest.log to log_<number>(<timestamp>).log
if [[ -f "$LATEST_LOG" ]]; then
TIMESTAMP=$(date -d @"$(stat --format '%W' $LATEST_LOG)" +"%Y_%m_%d_%Hh%M_CST")
    mv "$LATEST_LOG" "${LOG_DIR}/log_${NEW_NUM}(${TIMESTAMP}).log"
    echo "Renamed latest.log -> log_${NEW_NUM}(${TIMESTAMP}).log"

    else
    echo "latest.log not found at $LATEST_LOG"
fi
# Keep only the latest 100 logs
ls -1t "${LOG_DIR}"/log_*.log 2>/dev/null | tail -n +51 | xargs -r rm

if [[ -f "./logs/latest_errors.log" ]]; then
    mv "./logs/latest_errors.log" "./logs/previous_errors.log"
fi


################### tem que ver se não estã apontando para wipe data 
MAP_FOLDER="./Data/Worlds/$_WORLD"
EXPORTED_DATA="/home/container/shared/EXPORTED_${_WORLD}.tar.gz"
if [[ ! -d "$MAP_FOLDER" ]]; then
	echo "Existing Map not found."
 	if [ -f "$EXPORTED_DATA" ]; then
    echo "Existing exported data found. Importing..."
	cp $EXPORTED_DATA ./
    sleep 3
    tar -xvzf $EXPORTED_DATA -C ./
    sleep 3
    elif [ -f "$MAP_FOLDER/${_WORLD}.tar.gz" ]; then
    echo "Existing ${_WORLD}.tar.gz archive found. Extracting..."
    tar -xvzf "$MAP_FOLDER/${_WORLD}.tar.gz" -C ./
    elif [ -f "$MAP_FOLDER/${_WORLD}.zip" ]; then
    echo "Existing ${_WORLD}.zip archive found. Extracting..."
    unzip "$MAP_FOLDER/${_WORLD}.zip" -d ./
    elif [ -f "$MAP_FOLDER/${_WORLD}.rar" ]; then
    echo "Existing ${_WORLD}.rar archive found. Extracting..."
    unrar x "$MAP_FOLDER/${_WORLD}.rar" ./
    else 
    echo "🔴  Check the Map/World selected and/or uploaded files/exported data and try again."
    sleep infinity
    fi
fi






# Build the command dynamically
CMD=(./7DaysToDieServer.x86_64 -configfile=serverconfig.xml -quit -batchmode -nographics -dedicated -ServerDisabledNetworkProtocols=SteamNetworking)
CMD+=(-ServerPort=${SERVER_PORT})
CMD+=(-ServerName="${_NAME}")
CMD+=(-ServerDescription="${_DESCRIPTION}")
CMD+=(-ServerWebsiteURL="${_WEBSITE}")
CMD+=(-ServerPassword="${_PASSWORD}")
[[ $_PURGE == "1" ]] && echo -e "🔴  \e[31mPURGE is enabled" || echo -e "🟢  \e[32mPURGE is disabled"
[[ $_PVP == "1" ]] && echo "🔴  This is a PVP server" || echo -e "🟢  This is a \e[32mPVE\e[0m server"
if [[ $_PURGE == "1" ]]; then
    CMD+=(-LandClaimSize="${_DEFAULTLCB}" -PlayerKillingMode="2")
elif [[ $_PVP == "1" ]]; then
    CMD+=(-LandClaimSize="${_DEFAULTLCB}" -PlayerKillingMode="2")
else
    CMD+=(-LandClaimSize="${_DEFAULTLCB}" -PlayerKillingMode="0")
fi
CMD+=(-LandClaimCount=${_LCBCOUNT})
CMD+=(-LandClaimDeadZone=${_LCBDEADZONE})
CMD+=(-LandClaimExpiryTime="90")
CMD+=(-LandClaimDecayMode="2")
CMD+=(-LandClaimOnlineDurabilityModifier="0")
CMD+=(-LandClaimOfflineDurabilityModifier="0")
CMD+=(-DynamicMeshEnabled=false)
CMD+=(-DynamicMeshLandClaimOnly=false)
CMD+=(-ServerMaxPlayerCount=${_MAXPLAYERS})
CMD+=(-GameDifficulty=${_DIFFICULTY})
CMD+=(-ControlPanelEnabled=false)
CMD+=(-TelnetEnabled=true)
CMD+=(-TelnetPort=${TELNET_PORT})
CMD+=(-TelnetPassword="${TELNET_PASSWORD}")
CMD+=(-WebDashboardEnabled=true)
CMD+=(-WebDashboardPort=$((SERVER_PORT + 4)))
CMD+=(-logfile logs/latest.log)
CMD+=(-Region=${_REGION})
CMD+=(-UserDataFolder="/home/container/")
[[ $_EAC == 1 ]] && CMD+=(-EACEnabled="true")|| CMD+=(-EACEnabled="false")
CMD+=(-GameWorld=${_WORLD})
CMD+=(-GameName=${_GAMENAME})
CMD+=(-DayNightLength="90")
CMD+=(-DropOnDeath="3")
CMD+=(-XPMultiplier=${_XP})
CMD+=(-LootAbundance=${_LOOT})
CMD+=(-AirDropFrequency="24")
CMD+=(-LootRespawnDays="5")
CMD+=(-AirDropFrequency="24")
CMD+=(-PartySharedKillRange="500")
CMD+=(-QuestProgressionDailyLimit=${_QUESTLIMIT})
sleep 5
# Print the command for debugging purposes
echo "Starting server with the following arguments:"
#echo $CMD
for arg in "${CMD[@]}"; do
    if [[ "$arg" == -ServerName=* ]]; then
        key="${arg%%=*}"   # Extract key before '='
        value="${arg#*=}"  # Extract value after '='

        echo -e "$key=\e[38;5;135m$value"
    else
        echo "$arg"
    fi
done
sleep 1
# "${CMD[@]}" &  # Start the server in the background
"${CMD[@]}" &

echo -e "Checking on telnet connection"
sleep 1
until nc -z -v -w5 127.0.0.1 ${TELNET_PORT}
do 
echo -e "Checking on telnet connection"
sleep 1
done 

cleanup() {
    echo "🛑 Desligando servidor corretamente..."

    # Finalizar Telnet
    TELNET_PID=$(pgrep -f "telnet -E 127.0.0.1 ${TELNET_PORT}")
    if [ ! -z "$TELNET_PID" ]; then
        echo "🛑 Finalizando Telnet (PID: $TELNET_PID)..."
        kill -SIGTERM "$TELNET_PID"
    fi

    # Finalizar Log Monitor (`tail -f`)
    TAIL_PID=$(pgrep -f "tail -n 0 -f")
    if [ ! -z "$TAIL_PID" ]; then
        echo "🛑 Finalizando Monitor de Logs (PID: $TAIL_PID)..."
        kill -SIGTERM "$TAIL_PID"
    fi

    # Finalizar Servidor do Jogo
    SERVER_PID=$(pgrep -f "7DaysToDieServer.x86_64")
    if [ ! -z "$SERVER_PID" ]; then
        echo "🛑 Finalizando Servidor (PID: $SERVER_PID)..."
        kill -SIGTERM "$SERVER_PID"
    fi

    # Garantir que o script termine corretamente
    exit 0
}

# Capturar Sinal de Encerramento do Pterodactyl
trap cleanup EXIT

script -qc "telnet -E 127.0.0.1 ${TELNET_PORT}" /dev/null < /dev/tty &

bash ./SZ/SZLogMonitor.sh &

wait
