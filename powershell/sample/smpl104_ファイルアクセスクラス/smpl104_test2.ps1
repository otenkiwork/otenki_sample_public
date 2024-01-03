Write-Host "ファイル読込"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl104_01.ps1

$objFile = New-Object CComFileAccess 
$objFile.ReadFile("data.txt")

Write-Host "カスタムオブジェクトで取得"
$objFile.SetStrHeader(@("col1"))
$objFile.SetDelimiter(" ")
$dataList = $objFile.GetDataCustomObj()

# 項目値変換
foreach($rec in $dataList){
    $rec.col2 = $rec.col2.replace("00", "11")
}

# ファイル書き込み(カスタムオブジェクト指定)(カンマ区切りに変更)
$objFile.SetFilePath("data2.txt")
$objFile.SetDelimiter(",")
$objFile.WriteCsvFileCustomObj($dataList)

Write-Host "処理終了"
