#!/bin/bash
clear
function_User_Information(){
	
	echo "Current User    : $(whoami)"
	echo "Logged-in Users : $(who)"
	echo "---------------------------"
	read -p  "Press enter to continue....."
	sleep 1
	return 0
}

function_Disk_Usage(){
	echo "-> DISK USAGE <-"
	echo "---------------------------"
	echo "$(df -h)"
	echo "---------------------------"
	echo "-> MEMORY USAGE <-"
	echo "$(free -h)"
	echo "---------------------------"
	read -p  "Press enter to continue....."
	sleep 1
	return 0
}

function_File_Operations(){
	while true;
	do 
	echo "----- WELCOME IN FILE OPERATION MODULE-----"
	echo "
	1.File Information
	2.Count lines in a file
	3.Copy content from one file to another
	4.Check file permissions
	5.Clean files older than X days from a directory
	"
	read -p "Enter your choice [1-4]:" choice
	case $choice in 
	1) read -p "Enter the file path (/path/path/random.txt):" path
		if [ -f $path ];then
			echo "FILE INFORMATION"
			stat $path
		else
			echo "File does'nt exist"
		fi
		break
		;;
	2) read -p "Enter the file path (/path/path/random.txt):" path
		if [ -f $path ];then
			echo "Number of lines in $path : $(wc -l < $path)"
		else
			echo "File does'nt exist"
		fi
		break
		;;
	3) read -p "Enter the source file path (/path/path/random.txt):" path1
	   read -p "Enter the destination file path (/path/path/random.txt):" path2
		if [ -f $path1 ];then
			cp $path1 $path2
			echo "Content Copied Successfully"
		else
			echo "File does'nt exist"
		fi
		break
		;;
	4) read -p "Enter the source file path (/path/path/random.txt):" path
		if [ -f $path ];then
			echo "FILE PERMISSION"
			ls -l $path
		else
			echo "File does'nt exist"
		fi
		break
		;;
	5) read -p "Enter the source file path (/path/path/random.txt):" path
	   read -p "Enter the number of Days" num
	   	if [ $num -eq 0 ];then
	   		echo "invalid number"
	   		sleep 2
	   		break
	   	fi
		if [ -d $path ];then
			find $path -type f -mtime +"$num" -delete
		else
			echo "File does'nt exist"
		fi
		break
		;;
	esac
	done
	echo "---------------------------"
	read -p  "Press enter to continue....."
	sleep 1
	return 0
}

function_Process_Monitoring(){
	read -p "Enter process name :" process
		if systemctl list-unit-files | awk '{print $1}' | grep -qx "$process.service"; then
		
		    if systemctl is-active --quiet "$process"; then
			PID=$(systemctl show "$process" --property=MainPID --value)

			if [ "$PID" -ne 0 ]; then
			    echo "$process is running"
			    echo "PID: $PID"
			else
			    echo "$process is running but PID not available"
			fi

		    else
			echo "$process is NOT running"
			read -p "Do you want to start $process? (y/n): " ans

			if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
			    sudo systemctl start "$process"

			    PID=$(systemctl show "$process" --property=MainPID --value)
			    echo "$process started"
			    echo "PID: $PID"
			else
			    echo "Start cancelled"
			fi
		    fi

		else
		    echo "Invalid service name: $SERVICE"
		fi

	echo "---------------------------"
	read -p  "Press enter to continue....."
	sleep 1
	return 0
}

function_Network_Connectivity(){
	read -p "Enter the Hostname : " host
	echo "Checking connectivity status"
	if ping -c 1 google.com &>/dev/null; then
    		echo "Network Status: CONNECTED"
	else
    		echo "Network Status: DISCONNECTED"
	fi
	echo "pinging the host...."
	echo "--------------------"
	ping -c 3 $host
	echo "---------------------------"
	read -p  "Press enter to continue....."
	sleep 1
	return 0
}

function_Log_Analysis(){
	    MAX_SIZE_MB=5
	    BACKUP_DIR="./log_backup"
	    logfile=$1
	    
	    if [ -f "$logfile" ]; then
		error_count=$(grep -c "ERROR" "$logfile")
		    warning_count=$(grep -c "WARNING" "$logfile")

		    echo "ERROR count   : $error_count"
		    echo "WARNING count : $warning_count"

		    
		    filesize=$(du -m "$logfile" | cut -f1)

		
		    if [ "$filesize" -ge "$MAX_SIZE_MB" ]; then
			mkdir -p "$BACKUP_DIR"
			timestamp=$(date +%Y%m%d_%H%M%S)
			mv "$logfile" "$BACKUP_DIR/$(basename $logfile)_$timestamp"
			touch "$logfile"
			echo "Log rotated (size exceeded ${MAX_SIZE_MB}MB)"
		    else
			echo "Log size is under limit (${filesize}MB)"
		    fi
	    else
	    	echo "Log file does not exist!"
		return 
	    fi
	echo "---------------------------"
	read -p  "Press enter to continue....."
	sleep 1
	return 0
}


function_exit(){
	echo "ThankYou Goodbye......."
	sleep 1
	exit
}



while true; do
		echo "================================================"
		echo "LINUX SYSTEMMM UTILITY MENU"
		echo "================================================"
		echo "
		1. User Information
		2. Disk Usage & Memory Usage
		3. File Operations
		4. Process Monitoring
		5. Network Connectivity Check
		6. Log Analysis
		7. Exit
		----------------------------------------
		"
		read -p "Enter your choice [1-7]:" choice

		case $choice in
		1) function_User_Information ;;	
		2) function_Disk_Usage ;;
		3) function_File_Operations ;;
		4) function_Process_Monitoring ;;
		5) function_Network_Connectivity ;;
		6) function_Log_Analysis ;;
		7) function_exit ;;
			
		*) echo "invalid choice"
			break ;;
		esac	
	done




