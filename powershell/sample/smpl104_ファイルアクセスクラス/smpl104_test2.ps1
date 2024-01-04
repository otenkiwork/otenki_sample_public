Write-Host "ファイル読込"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl104_01.ps1
. ..\smpl107_データ変換クラス\smpl107_01.ps1

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

# CSVファイル書き込み(カスタムオブジェクト指定)(カンマ区切りで出力)
$objFile.SetFilePath("data2.txt")
$objFile.SetDelimiter(",")
$objFile.WriteFileData($dataList)

$cnv = New-Object CComCnvData
$dataList = $cnv.DataToArray($dataList)
# CSVファイル書き込み(配列指定)
$objFile.SetFilePath("data3.txt")
$objFile.WriteFileData($dataList)

$cnv.SetDelimiter("`t")
$dataList = $cnv.DataToCsv($dataList)
# CSVファイル書き込み(文字列指定)
$objFile.SetFilePath("data4.txt")
$objFile.WriteFileData($dataList)

Write-Host "処理終了"
