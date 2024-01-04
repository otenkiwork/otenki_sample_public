$ErrorActionPreference = "Stop"
$Error.Clear()

try {
    Write-Host "DB接続"
    $DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
    Set-Location -Path ($DIR_PATH)
    
    . .\smpl105_01.ps1
    . .\smpl105_01mysql.ps1
    . ..\smpl107_データ変換クラス\smpl107_01.ps1

    # DBオープン
    $objDb = New-Object CComDbMySql("sv-ubuntu", "test_db", "miya", "wfrog9442", "3306") 
    $objDb.Open()

    $objDb.SetSql("SELECT * FROM tbl001")
    $objDb.SetpDelimiter(",")

    # データ取得（文字列）
    Write-Host "データ取得（文字列）"
    $objDb.SetDataType("Str")
    $data = $objDb.ExecSelect()
    $data | ForEach-Object {Write-Host $_}

    # データ取得（配列）
    Write-Host "データ取得（配列）"
    $objDb.SetDataType("Array")
    $data = $objDb.ExecSelect()
    $data | ForEach-Object {Write-Host $_}

    # データ取得（カスタムオブジェクト）
    Write-Host "データ取得（カスタムオブジェクト）"
    $objDb.SetDataType("CustomObj")
    $data = $objDb.ExecSelect()
    $data | ForEach-Object {Write-Host $_}

    # DBクローズ
    $objDb.Close()
    
    Write-Host "処理終了"
}
catch [Exception] {
    foreach ($err in $Error){
        Write-Host ("エラーメッセージ:" + $err.Exception.message)
        Write-Host ("LoaderExceptions:" + $err.Exception.LoaderExceptions)
        Write-Host ("スタックトレース:" + $err.ScriptStackTrace)
    }
}