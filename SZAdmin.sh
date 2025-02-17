#!/bin/bash
logo() {
    local emoji="$1"  # Accept emoji as a parameter
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
echo -e "                           \e[36mby Namsaknoi${emoji}"
echo "    "

}

# Example usage
logo "😀"

if [ ! -f "./Saves/${_WORLD}/${_GAMENAME}/main.ttw" ]; then
        echo "🔴  You need to first let the game start once with the selected map or wipe data before using this menu."
        sleep infinity
    fi

while true; do
    
    echo -e "Welcome to Server Management Console, please choose an option."
    echo "  "
    echo "1️⃣  Check/Fix DC rotation"
    echo "2️⃣  Prepare automation for claims/waypoints"
    echo "3️⃣  Export Wipe Data to be used on any server"
    echo "4️⃣  Download files from the internet directly to the server"
    echo "5️⃣  Dad Jokes"
    echo "6️⃣  List exported Wipe Data available"
    echo "7️⃣  Exit/Restart Server"
    echo "  "
    
    # Capture user input
    echo "Enter your choice (1-7): "
    read -p "-> " choice

    case $choice in
    "S")
    sleep 2
kill 1

    ;;
    ###########################################################################################################################
    #                                            1️⃣  Check/Fix DC rotation                                                    #
    ###########################################################################################################################
        1)

logo "😆"
          #  cat sz2.txt
echo -e "  "
echo -e "  "
            echo -e "\nChecking/Fixing DC rotation..."
echo -e "  "
C_INDEX=0
ANIM=("\033[20m" "\033[37m")  # Alternating Dark Gray and Light Gray colors
wrong_rotation=false
singular=true
for letter in {A..H}; do
    total=$(grep -o 'name="DC-'"$letter"'"' ./Data/Worlds/${_WORLD}/prefabs.xml | wc -l)
    non_zero_rotation=$(grep 'name="DC-'"$letter"'"' ./Data/Worlds/${_WORLD}/prefabs.xml | grep -v 'rotation="0"' | wc -l)

    if [[ $non_zero_rotation -eq 0 ]]; then
        color_non_zero="\e[32m0\033[0m"  # Gray if 0
    else
        color_non_zero="\033[31m$non_zero_rotation\033[0m"  # Red if nonzero
        wrong_rotation=true
    fi
    if [[ $total -gt 1 ]]; then
		singular=false
	fi
    
    # Ensuring everything is on the same line
    echo -e "${ANIM[C_INDEX]}DC-$letter: Total = $total, Wrong rotation = $color_non_zero"

    C_INDEX=$(( (C_INDEX + 1) % 2 ))  # Alternates between colors
done
      if [ "$wrong_rotation" = true ]; then
sed -i -E 's/(name="DC-[A-H].*rotation=")[0-9]+"/\10"/g' ./Data/Worlds/${_WORLD}/prefabs.xml
echo -e "  "
echo -e "\e[31mDC POI(s) rotation fixed."
else
echo -e "  "
echo -e "\e[32mAll DC POIs have the right rotation."
fi
      if [ "$singular" = false ]; then
echo -e "  "
env | grep PTERO
echo -e "Make sure to remove the duplicated DC POIs at"
echo -e "\e[33mhttp://szgamepanel.com/server/${P_SERVER_UUID:0:8}/files/edit#/Data/Worlds/${_WORLD}/prefabs.xml"
fi

echo "Enter any char to return..."
read -n 1 -s -r -p "->"
read -t 0.1 -n 100 
sleep 1
exec "$0"  # 🚀 Restart the script
            ;;
    ###########################################################################################################################
    #                                     2️⃣  Prepare automation for claims/waypoints                                         #
    ###########################################################################################################################
		2)
            echo "Preparing automation for claims/waypoints..."
            echo -e "  "
            failed_rotation=false
            failed_unique=false
for letter in {A..H}; do
    total=$(grep -o 'name="DC-'"$letter"'"' ./Data/Worlds/${_WORLD}/prefabs.xml | wc -l)
    non_zero_rotation=$(grep 'name="DC-'"$letter"'"' ./Data/Worlds/${_WORLD}/prefabs.xml | grep -v 'rotation="0"' | wc -l)

    if [[ $non_zero_rotation -ne 0 ]]; then
        failed_rotation=true
    fi
    if [[ $total -gt 1 ]]; then
        failed_unique=true
    fi
done

abort=false
if [[ $failed_rotation == true && $failed_unique == true ]]; then
    echo -e "🔴  \e[31mThere is at least 1 DC POI with the wrong rotation and doubled."
    echo -e "  \e[31mPlease use option 1 to fix rotation and find out the duplicate."
    abort=true
elif [[ $failed_rotation == true ]]; then    echo -e "🔴  \e[31mThere is at least 1 DC POI with the wrong rotation."
    echo -e "  \e[31mPlease use option 1 to fix this."
    abort=true
elif [[ $failed_unique == true ]]; then
    echo -e "🔴  \e[31mThere is at least 1 DC POI doubled."
    echo -e "  \e[31mPlease use option 1 to find out which one."
    abort=true
fi

#    if [ ! -f server_id.takaro ]; then
 #       READY_FOR_EXPORT=false
  #      echo "🔴  Server Id From Takaro is Missing!"
   #     echo "🔴  Make sure this Server is connected to Takaro, let the game load once and try again."
    #fi

if [[ $abort == true ]]; then
	echo -e "  "
	echo "Enter any char to return..."
	read -n 1 -s -r -p "->"
	read -t 0.1 -n 100 
	sleep 1
	exec "$0"  # 🚀 Restart the script
fi

############### good to go ###############

# Define the command file
command_file="./SZ/commands.txt"

# Clear the file before writing new commands
> "$command_file"
echo "${_WORLD}" >> "$command_file"
# Ask for the name of the donor trader POI
echo "Enter the name of the donor trader POI: "
tput cuu1 && tput hpa 40
read -p "" donor_poi_name

# Extract donor POI position
poi_position=$(grep -o 'name="'"$donor_poi_name"'" position="[^"]*"' ./Data/Worlds/${_WORLD}/prefabs.xml | cut -d'"' -f4)

if [[ -n "$poi_position" ]]; then
    IFS=',' read -r poi_x poi_y poi_z <<< "$poi_position"
	poi_file="./LocalPrefabs/${donor_poi_name}.xml"
	if [[ ! -f "$poi_file" ]]; then
    	poi_file=$(find ./Mods -type f -path "*/SZ*/*" -name "${donor_poi_name}.xml" | head -n 1)
	fi
else
    echo "🔴  $donor_poi_name not found in prefabs.xml"
    echo "🔴  Verify the name and try again or set it manually later."
#	exec "$0"  # 🚀 Restart the script
fi

# Look for the POI file in LocalPrefabs

if [[ -n "$poi_file" ]]; then
    poi_size=$(sed -n 's/.*value="\([^"]*\)".*/\1/p' ${poi_file})
    IFS=',' read -r poi_x_size _ poi_z_size <<< "$poi_size"
    fi
    
if [[ -n "$poi_file" && ! "$poi_size" ]]; then
    echo "🔴  $donor_poi_name file not found. Assuming size is 60x60"
    echo "🔴  You can check the file and try again if needed."
    poi_x_size=60
    poi_z_size=60
fi

# Add commands for donor trader POI
if [[ -n "$poi_position" ]]; then
echo "ccc add nozombiesDT $((poi_x - 20)) $((poi_x + poi_x_size + 20)) $((poi_z + poi_z_size + 20)) $((poi_z - 20)) -1 hostilefree" >> "$command_file"
echo "ccc add donorsonlytraders $((poi_x - 20)) $((poi_x + poi_x_size + 20)) $((poi_z + poi_z_size + 20)) $((poi_z - 20)) -1" >> "$command_file"
echo "wpc add trader $((poi_x + (poi_x_size / 2))) $((poi_y + 2)) $((poi_z + (poi_z_size / 2)))" >> "$command_file"
echo "wpc add traders $((poi_x + (poi_x_size / 2))) $((poi_y + 2)) $((poi_z + (poi_z_size / 2)))" >> "$command_file"
fi
# Extract trader positions
mapfile -t trader_positions < <(awk -F'position="' '/name="trader_/ {split($2, a, "\""); print a[1]}' ./Data/Worlds/${_WORLD}/prefabs.xml)

# Process trader positions
for i in "${!trader_positions[@]}"; do
    IFS=',' read -r trader_x _ trader_z <<< "${trader_positions[$i]}"
    
    echo "ccc add NoBuildingCloseToTraders$((i + 1)) $((trader_x - 200)) $((trader_x + 260)) $((trader_z + 260)) $((trader_z - 200)) -1 lcbfree" >> "$command_file"
    echo "ccc add bmonly(22-4)_NoStayingAtTraders$((i + 1)) ${trader_x} $((trader_x + 60)) $((trader_z + 60)) ${trader_z} -1" >> "$command_file"
done

# Process DC locations
for letter in {A..H}; do
    position=$(grep -o 'name="DC-'"$letter"'" position="[^"]*"' ./Data/Worlds/${_WORLD}/prefabs.xml | cut -d'"' -f4)

    if [[ -n "$position" ]]; then
        IFS=',' read -r pos_x pos_y pos_z <<< "$position"

        echo "ccc add nozombies${letter} ${pos_x} $((pos_x + 164)) $((pos_z + 164)) ${pos_z} -1 hostilefree" >> "$command_file"
        echo "ccc add DC${letter} $((pos_x - 130)) $((pos_x + 164 + 130)) $((pos_z + 164 + 130)) $((pos_z - 130)) -1 lcbfree" >> "$command_file"
        echo "ccc add DC2${letter} ${pos_x} $((pos_x + 164)) $((pos_z + 164)) ${pos_z} -1 landclaim" >> "$command_file"

        first_plot_x=$((pos_x + 38))
        first_plot_y=$((pos_y + 1))
        first_plot_z=$((pos_z + 109))
        
        offset_x=44
        offset_z=-44
        iteration=1

        for row in {0..2}; do
            z=$((first_plot_z + (row * offset_z)))
            for col in {0..2}; do
                x=$((first_plot_x + (col * offset_x)))
                plot_name="${letter}${iteration}"
                echo "wpc add ${plot_name} ${x} ${first_plot_y} ${z}" >> "$command_file"
                echo "ccc add ${plot_name} $((x - 17)) $((x + 17)) $((z + 34)) ${z} -1 landclaim" >> "$command_file"
                ((iteration++))
            done
        done

        # Add city waypoint per DC letter
        echo "wpc add city${letter} $((pos_x + 83)) $((pos_y + 2)) $((pos_z + 104))" >> "$command_file"
    fi

done
    echo -e "\e[33m$(( $(wc -l < "$command_file") - 1 )) commands ready to be executed on server restart."

##### sending stuff directly to takaro... not used anymore, so i'm blocking with a falsy if
    if [[ 1 -eq 2 ]]; then

 read -r server_id < server_id.takaro

# Prompt the user for their email address
echo "Enter your Takaro login email: "
tput cuu1 && tput hpa 31
read -p "" email

# Prompt the user for their password (input hidden)
echo "Enter your Takaro password: "
tput cuu1 && tput hpa 29
read -sp "" password
echo -e "  "
echo -e "  "
loginresponse=$(curl -sS -X POST "https://api.takaro.io/login" \
 -H 'accept: application/json'\
 -H 'content-type: application/json' \
 -d '{"username":"'"$email"'","password":"'"$password"'"}')
token=$(echo "$loginresponse" | grep -o '"token":"[^"]*"' | sed 's/"token":"//; s/"//')
if [[ $token == "" ]]; then
		echo "Email or password invalid. Please try again."
	sleep5
	exec "$0"  # 🚀 Restart the script
fi
# echo "$token"


for letter in {A..H}; do
	position=$(grep -o 'name="DC-'"$letter"'" position="[^"]*"' ./Data/Worlds/${_WORLD}/prefabs.xml | cut -d'"' -f4)
        if [[ $position ]]; then

		# Send request to execute a command
		  response=$(curl -s -X POST "https://api.takaro.io/hook/trigger" \
		 -H "Authorization: Bearer $token" \
 		-H 'accept: application/json'\
 		-H 'content-type: application/json' \
        -d "{
           \"gameServerId\": \"${server_id}\",
           \"eventType\": \"log\",
           \"eventMeta\": {
             \"msg\":	\"NewDC_Automated_AdminConsole\",
             \"DC\": 	\"${letter}\",
             \"coords\":\"${position}\",
             \"R20\": 	\"is the best\"
           }
         }" 2>/dev/null)
  
# ✅ Clean handling of the response
				if [[ "$response" == '{"meta":{},"data":{}}' ]]; then
				#    echo -e "⚠️\e[33m  Takaro Overwrote the Response! 🚨"
				    echo -e "✅\e[32m  DC-${letter} set successfully."
				else	
				    echo "🔍\e[31m  Received a potential error response from Takaro:"
				    echo "$response"
				fi
		fi
done	

fi

########### end of takaro bit


echo "Enter any char to return..."
read -n 1 -s -r -p "->"
read -t 0.1 -n 100 
sleep 1
exec "$0"  # 🚀 Restart the script

;;

    ###########################################################################################################################
    #                            4️⃣  Transfer files from the internet directly to the server                                  #
    ###########################################################################################################################

        4) 
        
logo "😀"

echo -e "Select where do you want to download the file to:"
    echo "  "
    echo "1️⃣  root (/home/container/)"
    echo "2️⃣  Mods folder (./Mods/)"
    echo "3️⃣  Worlds folder (./Data/Worlds/)"
    echo "4️⃣  Saves folder (./Saves/)"
    echo "5️⃣  Return"
    echo "  "    
    # Capture user input
    echo "Enter your choice (1-5): "
 
while true; do
    
    read -p "-> " choice

    case $choice in
        1)
_PATH="." 
break
;;
		2)
_PATH="./Mods"
break
;;
        3) 
_PATH="./Data/Worlds"
break
;;
        4) 
_PATH="./Saves"
break
;;
        5)        

echo -e "  "
    echo "Here goes a Dad Joke before you go..."
    joke=$(curl -s https://official-joke-api.appspot.com/random_joke)
    # Extract setup and punchline from the same joke
    setup=$(echo "$joke" | grep -Eo '"setup":"[^"]*"' | cut -d'"' -f4)
    punchline=$(echo "$joke" | grep -Eo '"punchline":"[^"]*"' | cut -d'"' -f4)

    # Display setup
    echo "$setup"
sleep 1    
for i in {3..1}; do
    echo "$i..."
    sleep 1
tput cuu1 && tput el    
done
    # Display punchline
    echo "$punchline"
    sleep 3
            exec "$0"  # 🚀 Restart the script
            ;;
        *)
            echo -e "\e[31mInvalid choice... it has to be a number between 1 and 5."            
             echo "Try again..."
            ;;
    esac
            
done
#####################

#https://us-5.offcloud.com:3010/download/679e2d15ae800269c8f753f0/679e48dfae800269c8f755a3/EXPORTED_Jan31_Voc.tar.gz

echo "Enter the URL to download from or exit to return to the main menu: "
tput cuu1 && tput hpa 31
read -p "" _URL

_URL_lc=${_URL,,}  # Convert to lowercase

if [[ $_URL_lc == "exit" ]]; then
		echo "Exiting..."
	sleep 2
	exec "$0"  # 🚀 Restart the script
fi

FILENAME=$(basename "$_URL")

echo "🚀  Starting Download... 🚀"
sleep 1
tput cuu1 && tput el

curl -L --fail --retry 10 --retry-delay 5 \
     --connect-timeout 30 --max-time 0 \
     --speed-limit 100000 --speed-time 30 \
     --progress-bar \
     --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
     -o "$_PATH/$FILENAME" "$_URL" & PID=$! 

LOGFILE="./logs/download_speed.log"

# Ensure the log file exists
touch "$LOGFILE"


# Monitor the file size dynamically and update speed display
PREV_SIZE=0
START_TIME=$(date +%s)  # Record start time
		ANIM=(".  " ".. " "...")
		ANIM_INDEX=0
		ANIM2=0

MAX_WAIT_TIME=10  # Maximum time in seconds to allow 0 B/s before retrying
STALL_COUNTER=0   # Tracks how long we've been stuck

while kill -0 $PID 2>/dev/null; do
    sleep 1  # Update every second

    # Get current file size
    if [ -f "$_PATH/$FILENAME" ]; then
        CUR_SIZE=$(stat -c%s "$_PATH/$FILENAME")
        SPEED=$((CUR_SIZE - PREV_SIZE))
        PREV_SIZE=$CUR_SIZE

        # Convert speed to human-readable format
        if [ "$SPEED" -gt 1048576 ]; then
            SPEED_HR="$(awk "BEGIN {printf \"%.2f MB/s\", $SPEED/1048576}")"
        elif [ "$SPEED" -gt 1024 ]; then
            SPEED_HR="$(awk "BEGIN {printf \"%.2f KB/s\", $SPEED/1024}")"
        else
            SPEED_HR="$SPEED B/s"
        fi

# Check if download is stuck (speed = 0 B/s)
        if [ "$SPEED" -eq 0 ]; then
            ((STALL_COUNTER++))
        else
            STALL_COUNTER=0  # Reset if speed recovers
        fi

        # If download is stuck for too long, trigger a warning
        if [ "$STALL_COUNTER" -ge "$MAX_WAIT_TIME" ]; then
            echo -e "\n❌ Warning: Download has not started (0 B/s for $MAX_WAIT_TIME seconds)."
            echo "🔁 Retrying..."
            kill $PID  # Kill stuck curl process
            sleep 2
            STALL_COUNTER=0  # Reset stall counter
API_KEY="yC14N4AnpDF11OhekApRHrOegTGnCfXi"
RESPONSE=$(curl -s -X POST "https://offcloud.com/api/remote/instant" \
        -H "Content-Type: application/json" \
        -d "{\"apikey\": \"$API_KEY\", \"url\": \"$_URL\"}")
DOWNLOAD_URL=$(echo "$RESPONSE" | grep -o '"link":"[^"]*' | cut -d'"' -f4)
if [[ -z "$DOWNLOAD_URL" ]]; then
    echo "❌ Error: No valid download link received from Offcloud API."
    echo "API Response: $RESPONSE"
    exit 1
fi
    echo "🚀 Starting download: $DOWNLOAD_URL"
FILENAME=$(basename "$DOWNLOAD_URL")
   
curl -L --fail --retry 10 --retry-delay 5 \
     --connect-timeout 30 --max-time 0 \
     --speed-limit 100000 --speed-time 30 \
     --progress-bar \
     --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
h     -o "$FILENAME" "$DOWNLOAD_URL" & PID=$! 
fi


echo "$(date '+%Y-%m-%d %H:%M:%S') - Speed: $SPEED_HR" >> "$LOGFILE"
        
        # Force real-time progress update
		echo " 🚀  Downloading${ANIM[ANIM_INDEX]} Speed: $SPEED_HR      "
		ANIM_INDEX=$(( (ANIM_INDEX + 1) % 3 ))
        tput cuu1 && tput el; sync
        
    fi
done

# Clear the last line and print completion message
echo "" && tput el
echo "✅ Download completed: $_PATH/$FILENAME"
echo "📄 Speed log saved in: $LOGFILE"
echo ""


while true; do
    for ((color=30; color<=34; color++)); do
        printf "\e[%smEdit the startup settings, stop/kill the server, and start it again.\e[0m\n" "$color"
        sleep 0.2
        tput cuu1 && tput el
    done
done

echo "Edit the startup settings, stop/kill the server, and start it again."
sleep infinity
exit 0







######################
            ;;
    ###########################################################################################################################
    #                              3️⃣ Export Wipe Data to be transferred to another server                                    #
    ###########################################################################################################################

        3)
echo -e "  "
            echo "Preparing to exporting Wipe Data..."
            READY_FOR_EXPORT=true
            
    # Check if the export file already exists
 if [ -f /home/container/shared/EXPORTED_${_WORLD}.tar.gz ]; then
    echo "🔴  The files have already been exported for the current map. Delete them to export again? (y/n)"
    read -p "-> " input1
        while [[ ! "$input1" =~ ^[YyNn]$ ]]; do
        echo "Invalid response. Please enter 'y' or 'n': "
        read input1 < /dev/tty  # ✅ Fix: Ensuring input is taken from the terminal
        done

    if [[ "$input1" =~ ^[Nn]$ ]]; then
        READY_FOR_EXPORT=false
        echo "Aborting!"
        echo "To use that data in another server just write ${_WORLD} in the Map/World setting in startup tab."
        break
		sleep 5
        exec "$0"  # 🚀 Restart the script
    else
    	rm -f /home/container/shared/EXPORTED_${_WORLD}.tar.gz
        echo "✅  File deleted."
    fi
 fi

    # Check if waypoints file exists
    if [ ! -f ./Saves/${_WORLD}/${_GAMENAME}/CpmWaypoints.db ]; then
        READY_FOR_EXPORT=false
        echo "🔴  You are missing the waypoints! Set them and try again."
    fi

    # Check if claims file exists
    if [ ! -f ./Saves/${_WORLD}/${_GAMENAME}/CpmClaims.db ]; then
        READY_FOR_EXPORT=false
        echo "🔴  You are missing the claims! Set them and try again."
    fi

    if [ ! -f ./Saves/ResetRegions/regions.txt ] || [ ! -s ./Saves/ResetRegions/regions.txt ]; then
        READY_FOR_EXPORT=false
        echo "🔴  You are missing the reset regions!"
    fi

    # Check if export_temp already exists
#    if [ -d ./export_temp ]; then
 #       READY_FOR_EXPORT=false
  #  fi

    # Proceed with export if all conditions are met
    if [ "$READY_FOR_EXPORT" = true ]; then 
        mkdir -p ./export_temp/Saves
        mkdir -p ./export_temp/Data/Worlds
        
        echo "✅  Temporary Folders created. Copying files."

        cp -r ./Saves/${_WORLD} ./export_temp/Saves/
      #  cp ./Saves/ResetRegions/regions.txt ./export_temp/Saves/ResetRegions/
        cp -r ./Data/Worlds/${_WORLD} ./export_temp/Data/Worlds/
        rm -rf ./export_temp/Saves/${_WORLD}/${_GAMENAME}/Region
		rm -f ./export_temp/Saves/${_WORLD}/${_GAMENAME}/players.xml    
        echo "✅  Files copied. Compacting them."


        tar -czf /home/container/shared/EXPORTED_${_WORLD}.tar.gz -C ./export_temp .
        rm -rf ./export_temp
echo -e "  "
        echo "✅  Export ready. Deleting temporary files."
echo -e "  "
#curl -F "file=@./home/container/shared/EXPORTED_${_WORLD}.tar.gz" https://store1.gofile.io/uploadFile		
# curl -F "file=@./Mods/1CSMM_Patrons/cpmcc/img/EXPORTED_${_WORLD}.tar.gz" https://store1.gofile.io/uploadFile		

        echo -e "\e[33mExported data is ready."
        echo -e "\e[33mTo use in anohter server just write \e[36m${_WORLD}\e[33m in the Map/World setting in startup tab."
echo -e "  "
#    echo "Press Enter to continue..."
 #   read -p ""

echo "Enter any char to return..."
read -n 1 -s -r -p "->"
read -t 0.1 -n 100 
#sleep 1
exec "$0"  # 🚀 Restart the script
fi
            ;;
    ###########################################################################################################################
    #                                                      5️⃣  Dad Jokes                                                      #
    ###########################################################################################################################

        5)        
while true; do
echo -e "  "
    joke=$(curl -s https://official-joke-api.appspot.com/random_joke)
    # Extract setup and punchline from the same joke
    setup=$(echo "$joke" | grep -Eo '"setup":"[^"]*"' | cut -d'"' -f4)
    punchline=$(echo "$joke" | grep -Eo '"punchline":"[^"]*"' | cut -d'"' -f4)

    # Display setup
    echo "$setup"
sleep 1    
for i in {3..1}; do
    echo "$i..."
    sleep 1
tput cuu1 && tput el    
done
    # Display punchline
    echo "$punchline"
    sleep 1
        echo -e "  "    
    echo "Do you want another joke? (y/n): " 
    read -p "-> " another
        while [[ ! "$another" =~ ^[YyNn]$ ]]; do
        echo "Invalid response. Please enter 'y' or 'n': "
        read another < /dev/tty  # ✅ Fix: Ensuring input is taken from the terminal
    done

    if [[ "$another" =~ ^[Nn]$ ]]; then
        echo "Goodbye!"
        break
        else
        tput cuu1 && tput el    
        tput cuu1 && tput el    
        tput cuu1 && tput el    

    fi
done
            exec "$0"  # 🚀 Restart the script
            ;;
    ###########################################################################################################################
    #                                               6️⃣  List exported Wipe Data                                               #
    ########################################################################################################################### 
        6)
        echo "Exported wipe data:"
find /home/container/shared -maxdepth 1 -type f -printf "%f %TY-%Tm-%Td\n" | awk '{gsub(/^EXPORTED_/,"",$1); sub(/\..*$/, "", $1); print $1, "(" $2 ")" }'
echo "Enter any char to return..."
read -n 1 -s -r -p "->"
read -t 0.1 -n 100 
#sleep 1
exec "$0"  # 🚀 Restart the script

            ;;
    ###########################################################################################################################
    #                                               7️⃣  Exit/Restart Server                                                   #
    ########################################################################################################################### 
        7) 
            echo -e "\033[31mServer restarting in 10 seconds. Make sure you turned off the toggle to start the game..."
            sleep 1  # Optional: Delay for better UX
L1="  (__((__((___()" 
L2=" (__((__((___()()"
L3="(__((__((___()()()---------"
echo -e "  "
echo "$L1"
echo "$L2"
echo "$L3🔥"

for i in {10..1}; do
tput cuu1 && tput el    
    L3=$(echo "$L3" | sed 's/-$//')
sleep 1
    echo "$L3🔥"
done

# Final explosion message
# echo "💥 BOOM! 💥"
# sleep 1
tput cuu1 && tput el    
tput cuu1 && tput el    
tput cuu1 && tput el    
cat <<EOF
   🔥🔥🔥🔥🔥     
   🔥🔥   🔥🔥   
   🔥🔥   🔥🔥 
   🔥🔥🔥🔥🔥🔥    
   🔥🔥   🔥🔥 
   🔥🔥   🔥🔥 
   🔥🔥🔥🔥🔥    
EOF
echo -e "  "
cat <<EOF
     🔥🔥🔥🔥 
  🔥🔥     🔥🔥  
 🔥🔥       🔥🔥  
 🔥🔥       🔥🔥  
 🔥🔥       🔥🔥  
  🔥🔥     🔥🔥  
     🔥🔥🔥🔥  
EOF
echo -e "  "
cat <<EOF
     🔥🔥🔥🔥 
  🔥🔥     🔥🔥  
 🔥🔥       🔥🔥  
 🔥🔥       🔥🔥  
 🔥🔥       🔥🔥  
  🔥🔥     🔥🔥  
     🔥🔥🔥🔥  
EOF
echo -e "  "
cat <<EOF
 🔥🔥     🔥🔥
 🔥🔥🔥   🔥🔥🔥
 🔥🔥 🔥 🔥 🔥🔥
 🔥🔥  🔥  🔥🔥
 🔥🔥     🔥🔥
 🔥🔥     🔥🔥
 🔥🔥     🔥🔥
EOF
sleep 2
kill 1
# exec "$0"  # 🚀 Restart the script
            ;;
            9)
            DOWNLOAD_URL=$(curl -s "https://api.gofile.io/getContent?contentId=gIT7AW" | grep -o '"link":"[^"]*' | cut -d'"' -f4)
curl -L -o EXPORTED_Salty.tar.gz "$DOWNLOAD_URL"

echo "🚀  Starting Download... 🚀"
sleep 1
tput cuu1 && tput el

curl -L --fail --retry 10 --retry-delay 5 \
     --connect-timeout 30 --max-time 0 \
     --speed-limit 100000 --speed-time 30 \
     --progress-bar \
     --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
     -o "./test.txt" "$DOWNLOAD_URL" & PID=$! 

            ;;
        *)
            echo -e "\e[31mInvalid choice... it has to be a number between 1 and 6."
            sleep 2
            exec "$0"  # 🚀 Restart the script
            ;;
    esac

    echo "Press Enter to continue..."
    read -p ""
done
