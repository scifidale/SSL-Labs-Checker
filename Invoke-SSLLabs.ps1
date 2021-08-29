##"https://api.ssllabs.com/api/v3/". 


# Import URL Lists 

$CONTENT = GET-CONTENT -PATH .\*.csv


# Preflight start new analysis 

FOREACH ($URi in $CONTENT) {

Invoke-restmethod -URi "https://api.ssllabs.com/api/v3/analyze?host=https://$URi&startnew=ON"
Write-host "SSLabs is updating $URi please wait" -ForegroundColor Green 
}

# Wait period 


$COUNTDOWN = 30 
while ( $COUNTDOWN -NE 0 ) { write-host $COUNTDOWN seconds to go 
Sleep 1
$countdown--
}



# Ready check
$Complete = Invoke-restmethod -Uri "https://api.ssllabs.com/api/v3/analyze?host=https://vhorizon.co.uk&maxAge=12" | Select Status -ExpandProperty Status
If ($Complete -contains "READY")
{Echo 'Test is ready'}




while ( $READYCHECK -neq READY ) {
$READYCHECK = Invoke-restmethod -Uri "https://api.ssllabs.com/api/v3/analyze?host=https://vhorizon.co.uk&maxAge=12" | Select Status -ExpandProperty Status }

