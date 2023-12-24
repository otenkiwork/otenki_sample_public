Write-Host "ファイル読込"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl104_01.ps1

$objFile = New-Object CComFileAccess 
$objFile.ReadFile("data.txt")

Write-Host "全データ取得"
foreach($rec in $objFile.GetData()){
    Write-Host $rec 
}

Write-Host "ヘッダ以外取得"
$objFile.SetStrHeader(@("col1"))
foreach($rec in $objFile.GetDataNotHeader()){
    Write-Host $rec 
}



Write-Host "処理終了"
