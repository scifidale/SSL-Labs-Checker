#### SSL Labs API reference ####
####"https://api.ssllabs.com/api/v3/". #### 


# Import URL Lists 

$CONTENT = GET-CONTENT -PATH .\$PSSCRIPTROOT\*.csv
$CONTENTEX = $CONTENT[0]


# Preflight start new analysis 

FOREACH ($URi in $CONTENT) {

Write-host "SSLabs is updating $URi please wait" -ForegroundColor Green 
Sleep 5
Invoke-restmethod -URi "https://api.ssllabs.com/api/v3/analyze?host=https://$URi&startnew=ON"
}



#### Wait period #### 


$COUNTDOWN = 30 
while ( $COUNTDOWN -NE 0 ) { write-host $COUNTDOWN seconds to go 
Sleep 1
$countdown--
}




while ( $READYCHECK -ne "READY" ) {
$READYCHECK = Invoke-restmethod -Uri "https://api.ssllabs.com/api/v3/analyze?host=https://$CONTENTEX" | Select Status -ExpandProperty Status
Sleep 5
 }


#### Settle down timer ####


$COUNTDOWN = 10 
while ( $COUNTDOWN -NE 0 ) { write-host $COUNTDOWN seconds to go 
Sleep 1
$countdown--
}


#### Results ####


FOREACH ($URi IN $CONTENT) {
	

	Invoke-restmethod -Uri "https://api.ssllabs.com/api/v3/analyze?host=https://$URi" | Select endpoints -ExpandProperty endpoints | Select serverName,ipaddress,grade,hasWarnings
Sleep 5
}

