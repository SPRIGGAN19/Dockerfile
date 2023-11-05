#!/bin/bash

# Exécutez uniquement en tant que root.
    # myWHOAMI=$(whoami)
    # if [ "$myWHOAMI" != "root" ]
    #   then
    #     echo "Doit être exécuté en tant que root ..."
    #     exit
    # fi

# Liste des conteneurs à vérifier
myCONTAINERS=("e9f47e87b340" "2fa996618aec" "9312c042972d")

# État du trou noir
myBLACKHOLE_STATUS=$(ip r | grep "blackhole" -c)
if [ "$myBLACKHOLE_STATUS" -gt "500" ];
  then
    myBLACKHOLE_STATUS="${myGREEN}ACTIVÉ"
  else
    myBLACKHOLE_STATUS="${myRED}DÉSACTIVÉ"
fi

function fuGETTPOT_STATUS {
# État de T-Pot
myTPOT_STATUS=$(systemctl status tpot | grep "Active" | awk '{ print $2 }')
if [ "$myTPOT_STATUS" == "active" ];
  then
    echo "${myGREEN}ACTIF"
  else
    echo "${myRED}INACTIF"
  fi
}

function fuGETSTATUS {
grc --colour=on docker ps -f status=running -f status=exited --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -v "NAME" | sort
}

function fuGETSYS {
printf "[ ========| Système |======== ]\n"
printf "${myBLUE}%+11s ${myWHITE}%-20s\n" "DATE: " "$(date)"
printf "${myBLUE}%+11s ${myWHITE}%-20s\n" "UPTIME: " "$(grc --colour=on uptime)"
printf "${myMAGENTA}%+11s %-20s\n" "T-POT: " "$(fuGETTPOT_STATUS)"
printf "${myMAGENTA}%+11s %-20s\n" "Trou noir: " "$myBLACKHOLE_STATUS${myWHITE}"
echo
}

    myDPS=$(fuGETSTATUS)
    myDPSNAMES=$(echo "$myDPS" | awk '{ print $1 }' | sort)
    fuGETSYS
    printf "%-21s %-28s %s\n" "NOM" "STATUT" "PORTS"
    if [ "$myDPS" != "" ];
      then
        echo "$myDPS"
    fi
    for i in "${myCONTAINERS[@]}"; do
      myAVAIL=$(echo "$myDPSNAMES" | grep -o "$i" | uniq | wc -l)      	    
      if [ "$myAVAIL" = "0" ];
	then
	  printf "%-28s %-28s\n" "$myRED$i" "EN BAS$myWHITE"
      fi
    done
