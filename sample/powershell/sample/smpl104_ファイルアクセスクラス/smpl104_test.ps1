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

Write-Host "ヘッダ以外取得１"
$objFile.SetStrHeader(@("col1"))
foreach($rec in $objFile.GetDataNotHeader()){
    Write-Host $rec 
}

Write-Host "ヘッダ以外取得２"
$objFile.SetStrHeader(@("col1", "a001"))
$objFile.SetRecProc({
    Write-Host ("recProc:" + $_) 
})
$objFile.ExecRecProc()

Write-Host "カスタムオブジェクトで取得"
$objFile.SetStrHeader(@("col1"))
foreach($rec in $objFile.GetDataCustomObj()){
    Write-Host $rec 
}

Write-Host "抽出値指定１"
$whereList = @{0 = "a002"}
foreach($rec in $objFile.GetDataWhere($whereList)){
    Write-Host $rec 
}

Write-Host "抽出値指定２"
$whereList = @{0 = "a00*"}
foreach($rec in $objFile.GetDataWhere($whereList)){
    Write-Host $rec 
}

Write-Host "処理終了"
