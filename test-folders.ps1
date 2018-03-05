<#############################################
Script Name: test-folders.ps1
Author Name: Erik Arnesen
Date: 10/5/2017
Contact : 

.SYNOPSIS
This is a simple Powershell script to create a group of nested folders. The depth is decided by the number you add.

.DESCRIPTION
The script itself will only print 'Hello World'. But that's cool. It's main objective is to show off the cool help thingy anyway.

.EXAMPLE
./test-folders.ps1 2 

.NOTES
Put some notes here.

.LINK

C:Temp\
├───101
│   ├───TopLev-1
│   │   ├───NestFoldr-1-1
│   │   ├───NestFoldr-1-2
│   │   └───NestFoldr-1-3
│   ├───TopLev-2
│   │   ├───NestFoldr-2-1
│   │   ├───NestFoldr-2-2
│   │   └───NestFoldr-2-3
│   └───TopLev-3
│       ├───NestFoldr-3-1
│       ├───NestFoldr-3-2
│       └───NestFoldr-


function test-set {
    [CmdletBinding(DefaultParameterSetName = 3)]
    param(
        [parameter(mandatory=$true, parametersetname="FooSet")]
        [switch]$FldrDpth,[parameter(mandatory=$true,position=0,parametersetname="Folder Depth")]
        [string]$TargFldr,[parameter(mandatory=$true,position=1)]
        [io.fileinfo]$FilePath)
@"
  Parameterset is: {0}
  Bar is: '{1}'
  -TargFldr present: {2}
  FilePath: {3}
"@ -f $PSCmdlet.ParameterSetName, $FldrDpt, $TargFldr.IsPresent, $FilePath
}
#>

function global:ADD-TestFolders{

[CmdletBinding(
    DefaultParameterSetName = "TargetFolder", 
    SupportsShouldProcess = $True)]

param(
    [Int]$FolderDepth = 3,
    [STRING]$TargFldr = "c:\Temp\NestedFolders",
    [STRING]$tpLevFldr = "TopLev",
    [STRING]$NstFldr = "NestFoldr",
    [STRING]$TstFile = "TestFile"
    )

    WRITE-DEBUG "`$TargFldr: $TargFldr"
    WRITE-DEBUG "`$tpLevFldr: $tpLevFldr"
    WRITE-DEBUG "`$NstFldr: $NstFldr"


    <#
[CmdletBinding(DefaultParameterSetName = "C:\Temp\test-Folders")]
    param(
        [parameter(
            mandatory=$true, 
            parametersetname="FooSet")]
    [switch]$FolderDepth,
        [parameter(
            mandatory=$true,
            position=0,
            parametersetname="Folder Depth")]
    [string]$TargFldr,
        [parameter(
            mandatory=$true,
            position=1)]
    [io.fileinfo]$FilePath)
    #>

@"
  Parameterset is: {0}
  Bar is: '{1}'
  -TargFldr present: {2}
  FilePath: {3}
"@ -f $PSCmdlet.ParameterSetName, $FolderDepth, $TargFldr.IsPresent, $FilePath


# PowerShell Nested Folders
# Set Variables
#$FolderDepth = 3
#$TargFldr = "c:\Temp\1001"
#$tpLevFldr = "TopLev"
#$NstFldr = "NestFoldr"
#$TstFile = "TestFile"
$i = 0

if(!(Test-Path $TargFldr)){
    New-Item -ItemType Directory -Path $TargFldr -Force
    }

Set-Location $TargFldr

While ($i -le $FolderDepth) {
$i +=1
Set-Location $TargFldr
New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i -Force
#Set-Location .\$tpLevFldr"-"$i
$j=0
While ($j -le $FolderDepth) {
    $j +=1
    #Set-Location .\$tpLevFldr"-"$i
    New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j -Force
    #Set-Location .\$NstFldr"-"$i"-"$j
    $k=0
    While ($k -le $FolderDepth) {
        $k+=1
        New-Item -ItemType File -path $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j"\"$TstFile"-"$i"-"$j"-"$k".txt" -Force
        }
    }
}
}


function delfold (){
$limit = (Get-Date).AddDays(-0)
$path = "C:\Temp\foldtest"

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
}