#requires -Version 3.0
$mypath = $PSScriptRoot
$PSScriptRoot
New-Item -Path $mypath -Name ('test-{0}' -f (Get-Date -UFormat %j%H%M%S)) -ItemType File

