﻿$ErrorActionPreference = 'Stop'

$fileName  = 'AutoHotkey_2.0-a136-feda41f4.zip'
$toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$zip_path = "$toolsPath\$fileName"
Remove-Item $toolsPath\* -Recurse -Force -Exclude $fileName

$packageArgs = @{
    PackageName  = 'autohotkey.portable'
    FileFullPath = $zip_path
    Destination  = $toolsPath
}
Get-ChocolateyUnzip @packageArgs
Remove-Item $zip_path -ErrorAction 0

Write-Host "Removing ANSI-32 version"
Remove-Item "$toolsPath/AutoHotkeyA32.exe" -ErrorAction 0
if ((Get-OSArchitectureWidth 64) -and ($Env:chocolateyForceX86 -ne 'true')) {
    Write-Verbose "Removing UNICODE-32 version"
    Remove-Item "$toolsPath/AutoHotkeyU32.exe" -ErrorAction 0
    Move-Item "$toolsPath/AutoHotkeyU64.exe" "$toolsPath/AutoHotkey.exe" -Force -ErrorAction 0
    Remove-Item "$toolsPath/AutoHotkey32.exe" -ErrorAction 0
    Move-Item "$toolsPath/AutoHotkey64.exe" "$toolsPath/AutoHotkey.exe" -Force -ErrorAction 0
} else {
    Write-Verbose "Removing UNICODE-64 version"
    Remove-Item "$toolsPath/AutoHotkeyU64.exe" -ErrorAction 0
    Move-Item "$toolsPath/AutoHotkeyU32.exe" "$toolsPath/AutoHotkey.exe" -Force -ErrorAction 0
    Remove-Item "$toolsPath/AutoHotkey64.exe" -ErrorAction 0
    Move-Item "$toolsPath/AutoHotkey32.exe" "$toolsPath/AutoHotkey.exe" -Force -ErrorAction 0
}
