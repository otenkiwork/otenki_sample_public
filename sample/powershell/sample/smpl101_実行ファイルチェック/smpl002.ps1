$ret = Get-Command Winmergeu 2> $null
if ($null -eq $ret){
    Write-Host "WinmergeU実行不可"
}
else {
    Write-Host "WinmergeU実行可"
}