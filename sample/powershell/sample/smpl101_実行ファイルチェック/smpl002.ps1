$ret = Get-Command Winmergeu 2> $null
if ($null -eq $ret){
    Write-Host "WinmergeU���s�s��"
}
else {
    Write-Host "WinmergeU���s��"
}