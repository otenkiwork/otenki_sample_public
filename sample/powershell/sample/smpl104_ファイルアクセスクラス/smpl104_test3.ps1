Write-Host "ファイル上書き、追記"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl104_01.ps1
. ..\smpl107_データ変換クラス\smpl107_01.ps1

$objFile = New-Object CComFileAccess 

$dataList = @(
    ,("col1","col2","col3")
    ,("a001","b001","い００１")
    ,("a002","b002","い００２")
    ,("a003","b003","い００３")
)
for ($i = 0 ; $i -lt 10000 ; $i++){
    $dataList += ,("a00X","b00X","い００Ｘ")
}

# CSVファイル書き込み(カンマ区切りで出力)
$objFile.SetFilePath("data5.txt")
$objFile.SetDelimiter(",")
$objFile.SetWriteMode([ComWriteFileMode]::OverWrite)
$objFile.WriteFileData($dataList)

for ($i = 0 ; $i -lt 10 ; $i++){
    # CSVファイル書き込み(カンマ区切りで出力)(追記)
    $objFile.SetFilePath("data5.txt")
    $objFile.SetDelimiter(",")
    $objFile.SetWriteMode([ComWriteFileMode]::Append)
    $objFile.WriteFileData($dataList)
}

Write-Host "処理終了"
