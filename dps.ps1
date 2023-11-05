# Exécutez uniquement en tant qu'administrateur.
# $myWHOAMI = whoami
# if ($myWHOAMI -ne "Administrator") {
#     echo "Doit être exécuté en tant qu'administrateur ..."
#     exit
# }

# Liste des conteneurs à vérifier
$myCONTAINERS = ('2fa996618aec')

# État du trou noir
$myBLACKHOLE_STATUS = netstat -an | findstr /c "0.0.0.0"
if ($myBLACKHOLE_STATUS -gt 500) {
    $myBLACKHOLE_STATUS = "ACTIF"
} else {
    $myBLACKHOLE_STATUS = "DÉSACTIVÉ"
}

function fuGETTPOT_STATUS {
    # État de T-Pot
    $myTPOT_STATUS = Get-Service tpot | select status
    if ($myTPOT_STATUS -eq "Running") {
        echo "ACTIF"
    } else {
        echo "INACTIF"
    }
}

function fuGETSTATUS {
    docker ps -f status=running -f status=exited | Format-Table -HideTableHeaders -Property Names, Status, PORTS
}

function fuGETSYS {
    Write-Host "[ ========| Système |======== ]"
    Write-Host "DATE: " (Get-Date)
    Write-Host "UPTIME: " (Get-Uptime)
    Write-Host "T-POT: " (fuGETTPOT_STATUS)
    Write-Host "Trou noir: " $myBLACKHOLE_STATUS
    Write-Host
}

    $myDPS = fuGETSTATUS
    $myDPSNAMES = $myDPS.Names | sort
    fuGETSYS
    Write-Host "Nom" -ColumnWidth 15
    Write-Host "Statut" -ColumnWidth 15
    Write-Host "Ports" -ColumnWidth 20
    if ($myDPS -ne "") {
        Write-Host $myDPS
    }
    foreach ($i in $myCONTAINERS) {
        $myAVAIL = $myDPSNAMES | Where-Object { $_ -eq $i } | Measure-Object -Property Count
        if ($myAVAIL.Count -eq 0) {
            Write-Host $i -ForegroundColor Red -NoNewline
            Write-Host " EN BAS" -ForegroundColor White -NoNewline
        }
    }
