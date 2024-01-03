Write-Host "データ変換"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl107_01.ps1

$arrDataOrg = @(
    ("col1", "col2", "col3"),
    ("a001", "b001", "あ００１"),
    ("a002", "b002", "あ００２"),
    ("a003", "b003", "あ００３")
)

Write-Host "配列からCSV"
$cnv = New-Object CComCnvData
$cnv.SetDelimiter(",")
$csvData = $cnv.DataToCsv($arrDataOrg)
Write-Host $csvData

Write-Host "配列からカスタムオブジェクト"
$objData = $cnv.DataToCustomObj($arrDataOrg)
Write-Host $objData

Write-Host "カスタムオブジェクトから配列"
$objData | ForEach-Object {$_.col2 = $_.col2.Replace("00", "xx")}
$arrData = $cnv.DataToArray($objData)
Write-Host $arrData

Write-Host "CSVから配列"
$csvData = $csvData.Replace("00", "yy")
$arrData = $cnv.DataToArray($csvData)
Write-Host $arrData

Write-Host "処理終了"
