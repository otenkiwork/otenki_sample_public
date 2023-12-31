$ErrorActionPreference = "Stop"
$Error.Clear()

try {
    Write-Host "DB接続"
    $DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
    Set-Location -Path ($DIR_PATH)
    
    . .\smpl105_01.ps1
    
    $objDb = New-Object CComDbMySql("sv-ubuntu", "test_db", "miya", "wfrog9442", "3306") 
    $objDb.Open()

    $objDb.SetSql("SELECT * FROM tbl001")
    $data = $objDb.ExecSelect()
    Write-Host $data
    $objDb.Close()
    
    Write-Host "処理終了"
}
catch [Exception] {
    Write-Host "【例外発生】"
    foreach ($err in $Error){
        Write-Host ("エラーメッセージ:" + $err.Exception.message)
        Write-Host ("LoaderExceptions:" + $err.Exception.LoaderExceptions)
        Write-Host ("スタックトレース:" + $err.ScriptStackTrace)
    }
}