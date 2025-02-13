#!/bin/bash
SEED_INFORMED=false
BLOODMOON_TRIGGERED=false

LOG_FILE="./logs/latest.log"
KEYWORDS_FILE="./SZ/logged_keywords.list"
ERROR_LOG="./logs/latest_errors.log"  # File to store matched logs

# Define ANSI color codes (bold red for visibility)
BOLD_RED='\033'
RESET='\033'

# Read keywords into an array
mapfile -t KEYWORDS < "$KEYWORDS_FILE"

export TZ="Etc/GMT+6"

trap "exit 0" SIGTERM
tail -n 0 -f --sleep-interval=5 ./logs/latest.log 2>/dev/null | while read line; do

    if echo "$line" | grep -q "BloodMoon"; then #1
        if [ "$BLOODMOON_TRIGGERED" = false ]; then #2
            BLOODMOON_TRIGGERED=true  # Mark as triggered

if [ ! -f "./Saves/${_WORLD}/${_GAMENAME}/players.xml" ]; then #3
	    echo  -e "🟡  \e[31mWipe detected! Updating player exports."
        if [ ! -f "./Data/VanillaPrefabs.tar.gz" ]; then #4
        tar -cvf ./Data/VanillaPrefabs.tar.gz ./Data/Prefabs > /dev/null
        sleep 3
        fi #4
{
  sleep 3
  echo "prefabupdater loadtable ./SZBlockUpdates.csv"
  sleep 3
  echo "prefabupdater updateblocks"
  sleep 5
  echo "exit"
} | stdbuf -oL -eL telnet 127.0.0.1 ${TELNET_PORT} | tee ./logs/prefabupdater.log

tar -xvf ./Data/VanillaPrefabs.tar.gz -C ./Data/ > /dev/null
sleep 5
    echo  -e "🟡  \e[33mFinished player exports update."
else
    echo  -e "🟡  \e[33mSkipping player exports update."
fi #3
fi #2
fi #1





if echo "$line" | grep -q "Started Webserver on port"; then 

    sleep 1
        echo -e "\e[93m   _____       _ _                       "
        echo -e "\e[93m  / ____|     | | |                      "
        echo -e "\e[93m | (___   __ _| | |_ _   _               "
        echo -e "\e[93m  \___ \ / _\ | | __| | | |              "
        echo -e "\e[33m  ____) | (_| | | |_| |_| |              "
        echo -e "\e[33m |_____/ \__,_|_|\__|\__, |              "
        echo -e "\e[33m                      __/ |              "
        echo -e "\e[31m  ______             \e[33m|___/   \e[31m_           "
        echo -e "\e[31m |___  /              | |   (_)          "
        echo -e "\e[31m    / / ___  _ __ ___ | |__  _  ___  ___ "
        echo -e "\e[31m   / / / _ \| '_ \ _ \| '_ \| |/ _ \/ __|"
        echo -e "\e[31m  / /_| (_) | | | | | | |_) | |  __/\__ \\"
        echo -e "\e[31m /_____\___/|_| |_| |_|_.__/|_|\___||___/"
        echo -e "                             \e[36mby Namsaknoi"
        echo "                                        "
fi

if echo "$line" | grep -q "[CSMM_Patrons] Stopped Location monitoring."; then 
    sleep 1
        echo -e "\e[93m   _____       _ _                       "
        echo -e "\e[93m  / ____|     | | |                      "
        echo -e "\e[93m | (___   __ _| | |_ _   _               "
        echo -e "\e[93m  \___ \ / _\ | | __| | | |              "
        echo -e "\e[33m  ____) | (_| | | |_| |_| |              "
        echo -e "\e[33m |_____/ \__,_|_|\__|\__, |              "
        echo -e "\e[33m                      __/ |              "
        echo -e "\e[31m  ______             \e[33m|___/   \e[31m_           "
        echo -e "\e[31m |___  /              | |   (_)          "
        echo -e "\e[31m    / / ___  _ __ ___ | |__  _  ___  ___ "
        echo -e "\e[31m   / / / _ \| '_ \ _ \| '_ \| |/ _ \/ __|"
        echo -e "\e[31m  / /_| (_) | | | | | | |_) | |  __/\__ \\"
        echo -e "\e[31m /_____\___/|_| |_| |_|_.__/|_|\___||___/"
        echo -e "                             \e[36mby Namsaknoi"
        echo "                                        "
fi

### error log
  CONTROL="OFF"
  MODIFIED_LINE="$LINE"

  for KEYWORD in "${KEYWORDS[@]}"; do
    if [[ "$MODIFIED_LINE" == *"$KEYWORD"* ]]; then
      MODIFIED_LINE="${MODIFIED_LINE//$KEYWORD/${BOLD_RED}$KEYWORD${RESET}}"
      CONTROL="ON"
    fi
  done

  # Only print and log lines that contain a keyword
  if [[ "$CONTROL" == "ON" ]]; then
  
TIMESTAMP="$(date +'%Y-%m-%d (%Hh%M-CST)')"
    echo -e "$TIMESTAMP $MODIFIED_LINE" >> "$ERROR_LOG"
  fi
###

### commands
if echo "$line" | grep -q "Connection opened from"; then #1

    if [ "$SEED_INFORMED" = false ]; then #2
        SEED_INFORMED=true  # Mark as triggered
        
        {
            sleep 2
            echo "w2l \"SEEDINFO:${_WORLD:0:5}_${_GAMENAME:0:5}\""
            sleep 2
            echo "exit"
        } | telnet 127.0.0.1 ${TELNET_PORT} &> /dev/null &
    fi #2

    # Check if commands.txt exists
if [ -f "./SZ/commands.txt" ]; then
    FIRST_LINE=$(head -n 1 ./SZ/commands.txt)

    if [ "$FIRST_LINE" = "${_WORLD}" ]; then
        cp ./SZ/commands.txt ./SZ/commands.txt.bak  # Criar um backup

        TMP_FILE=$(mktemp)  # Criar um arquivo temporário

        tail -n +2 ./SZ/commands.txt > "$TMP_FILE"  # Copiar todas as linhas exceto a primeira para o arquivo temporário

        # Conectar ao Telnet e enviar comandos com pausas
        {
            echo "sleep 5"  # Pausa de 5 segundos no início
            while IFS= read -r CMD; do
                echo "$CMD"
                sleep 0.2
            done < "$TMP_FILE"
            echo "exit"
        } | telnet 127.0.0.1 ${TELNET_PORT} &> /dev/null

        mv "$TMP_FILE" ./SZ/commands.txt  # Atualizar commands.txt sem a primeira linha

        [ ! -s "commands.txt" ] && rm -f ./SZ/commands.txt  # Se estiver vazio, apagar
    fi
fi

# tail should stop here while server still runs...    
fi #1

done