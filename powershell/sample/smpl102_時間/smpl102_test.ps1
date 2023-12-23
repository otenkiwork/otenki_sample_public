#実行中のファイルパス取得
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path $DIR_PATH

. .\smpl102_01.ps1

$objTime = New-Object CComDateTime 

$objTime.SetStartTime((Get-Date))
Start-Sleep -Seconds 3
$objTime.SetEndTime((Get-Date))

Write-Host $objTime.GetStrStartTime()
Write-Host $objTime.GetStrEndTime()
Write-Host $objTime.GetStrDurationMS()

