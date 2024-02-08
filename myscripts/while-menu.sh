#!/bin/bash

# while-menu: a menu-driven system information program

DELAY=3 # Number of seconds to display results

while true; do
  clear
  cat <<EOF
Please Select Stats to Display:

1. System Information [uptime,uname]
2. Disk Space [df]
3. Home Space Utilization [du]
0. Quit

EOF

  read -p "Enter selection [0-3] > "

  if [[ $REPLY =~ ^[0-3]$ ]]; then
    case $REPLY in
      1)
        uname -a
        uptime
        sleep $DELAY
        continue
        ;;
      2)
        df -h
        sleep $DELAY
        continue
        ;;
      3)
        if [[ $(id -u) -eq 0 ]]; then
          echo "Home Space Utilization (All Users) ..."
          du -sh /home/* 2> /dev/null
        else
          echo "Home Space Utilization ($USER) ..."
          du -sh $HOME 2> /dev/null
        fi
        sleep $DELAY
        continue
        ;;
      0)
        break
        ;;
    esac
  else
    echo "Invalid entry!"
    sleep 1
  fi
done
echo "Program terminated OK."
