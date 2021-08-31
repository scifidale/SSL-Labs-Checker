#### SSL Labs API reference ####
####"https://api.ssllabs.com/api/v3/". #### 


# Import URL Lists 

$CONTENT = GET-CONTENT -PATH .\$PSSCRIPTROOT\*.csv


# Preflight start new analysis 

FOREACH ($URi in $CONTENT) {

Invoke-restmethod -URi "https://api.ssllabs.com/api/v3/analyze?host=https://$URi&startnew=ON"
Write-host "SSLabs is updating $URi please wait" -ForegroundColor Green 
}



#### Wait period #### 


$COUNTDOWN = 30 
while ( $COUNTDOWN -NE 0 ) { write-host $COUNTDOWN seconds to go 
Sleep 1
$countdown--
}




while ( $READYCHECK -ne "READY" ) {
$READYCHECK = Invoke-restmethod -Uri "https://api.ssllabs.com/api/v3/analyze?host=https://$CONTENT[0]" | Select Status -ExpandProperty Status
Sleep 5
 }


#### Settle down timer ####


$COUNTDOWN = 10 
while ( $COUNTDOWN -NE 0 ) { write-host $COUNTDOWN seconds to go 
Sleep 1
$countdown--
}


#### Results ####

Start-Transcript -path $PSSCRIPTROOT\SSLLabs-report.csv
FOREACH ($URi IN $CONTENT) {
	
	Write-host $URi
	Invoke-restmethod -Uri "https://api.ssllabs.com/api/v3/analyze?host=https://$URi" | Select endpoints -ExpandProperty endpoints | Select ServerName,ipaddress,grade,hasWarnings
}

Stop-transcript