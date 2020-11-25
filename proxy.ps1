#you should pass in a command line argument of on or off to set proxy to on or off
param (
	[parameter(valuefrompipeline = $true)]
	[string]$state,
	[string]$proxy
)

#counter for asking for user input
$n = 1

#if a proxy wasn't passed in use this. set your proxy url and port here so you don't have to pass it in.
if (!$proxy) {
	$proxy="http://proxy.example.com:80"
}

do {

if (!$state -and $n -le "1") {
	echo "You can pass in on or off as an argument."
	$state = read-host -prompt "Enable proxy?  On or Off"
	$n++
	if ($n -ge "4") {break}
}

if ($state -eq "on") {
	echo "Setting $proxy as your PowerShell proxy."
  #this uses your existing corporate AD session to authenticate to a NTLM proxy
	[system.net.webrequest]::defaultwebproxy = new-object system.net.webproxy($proxy)
	[system.net.webrequest]::defaultwebproxy.credentials = [System.Net.CredentialCache]::DefaultNetworkCredentials
	[system.net.webrequest]::defaultwebproxy.BypassProxyOnLocal = $true
	break
}

elseif ($state -eq "off") {
	$prev = $([System.Net.WebRequest]::DefaultWebProxy.address)
	echo "Removing $prev.host from your proxy config."
	[System.Net.WebRequest]::DefaultWebProxy = [System.Net.WebRequest]::GetSystemWebProxy()
	break
}

else {
	echo "Sorry, we could not understand your input.  Please type ON to use the proxy or OFF to use no proxy."
	$state = read-host -prompt "Enable proxy?  On or Off"
	$n++
}

}
#tries to get user input 3 times, then quits to avoid an infinite loop
while ($n -le "3")
