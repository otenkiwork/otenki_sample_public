Set-StrictMode -Version Latest

$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
$XML_PATH = $DIR_PATH + "\test_xpath.xml"
$xml = [XML](Get-Content $XML_PATH)
$xmlNav = $xml.CreateNavigator()

Write-Host "DB_ServerName="$xml.Config.Database.ServerName
Write-Host "DB_User="$xml.Config.Database.User
Write-Host "DB_Password="$xml.Config.Database.Password

$xmlRet = $xmlNav.Select("//Task")
$xmlRet.Value