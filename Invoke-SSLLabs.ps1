#### SSL Labs API reference ####
####"https://api.ssllabs.com/api/v3/". #### 


#### Import URL Lists #### 

$CONTENT = GET-CONTENT -PATH $PSSCRIPTROOT\*.csv
$CONTENTEX = $CONTENT[-1]

#### Variables #### 
$Date = Get-Date -Format "ddMMyyyy"


#### Preflight start new analysis #### 

FOREACH ($URi in $CONTENT) {

Write-host "SSLabs is updating $URi please wait" -ForegroundColor Green 
Sleep 5
Invoke-restmethod -URi "https://api.ssllabs.com/api/v3/analyze?host=https://$URi&startnew=ON&maxAge=1"
}



#### Wait period #### 


$COUNTDOWN = 30 
while ( $COUNTDOWN -NE 0 ) { write-host $COUNTDOWN seconds to go 
Sleep 1
$countdown--
}
CLS

#### Wait for last item in array to READY ####

Write-Host "Waiting for SSLLabs report readiness - Please Wait" 
while ( $READYCHECK -ne "READY" ) {
$READYCHECK = Invoke-restmethod -Uri "https://api.ssllabs.com/api/v3/analyze?host=https://$CONTENTEX" | Select Status -ExpandProperty Status
Sleep 5
 }


#### Settle down timer ####

Write-host "Waiting for settle down" -foregroundcolor Yellow
$COUNTDOWN = 10 
while ( $COUNTDOWN -NE 0 ) { write-host $COUNTDOWN seconds to go 
Sleep 1
$countdown--
}

CLS


#### Results ####

#### TXT File Generation ####

Write-host "Generating Text Report"
FOREACH ($URi IN $CONTENT) {
	
	Invoke-restmethod -Uri "https://api.ssllabs.com/api/v3/analyze?host=https://$URi" | Select-object host,endpoints -ExpandProperty endpoints | Select host,serverName,ipaddress,grade,hasWarnings | Out-file -FilePath $PSScriptRoot\$Date.txt -Append
Sleep 5
}

#### Windows Notification Generation ####

$PopUp = Get-Content -Path $PSScriptroot\$Date.txt

$wshell = New-Object -ComObject Wscript.Shell 
$Output = $wshell.Popup("$PopUp")

Exit