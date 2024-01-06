#==================================================
# SELECT パラメータあり
#==================================================
$ErrorActionPreference = "Stop"
$Error.Clear()

try {
    Write-Host "DB接続"
    $DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
    Set-Location -Path ($DIR_PATH)
    
    . .\smpl105_01.ps1
    . .\smpl105_01mysql.ps1
    . ..\smpl107_データ変換クラス\smpl107_01.ps1

    $objDb = $null

    # DBオープン
    $objDb = New-Object CComDbMySql("sv-ubuntu", "test_db", "miya", "wfrog9442", "3306") 
    $objDb.Open()


    # データ取得（パラメータ指定）
    Write-Host "データ取得（パラメータ指定）"
    $objDb.SetSql("SELECT * FROM tbl001 WHERE col001 = @searchValue")
    $objDb.SetpDelimiter(",")
    $objDb.SetDataType("CustomObj")
    $data = $objDb.ExecSelectByParam(@(,("@searchValue", "1")))
    $data | ForEach-Object {Write-Host $_}

    # データ取得（パラメータ範囲指定）
    Write-Host "データ取得（パラメータ範囲指定）"
    $objDb.SetSql("SELECT * FROM tbl001 WHERE col001 BETWEEN  @fromValue AND @toValue")
    $objDb.SetpDelimiter(",")
    $objDb.SetDataType("CustomObj")
    $arrParams = @(
        ("@fromValue", "2"),
        ("@toValue", "4")
    )
    $data = $objDb.ExecSelectByParam($arrParams)
    $data | ForEach-Object {Write-Host $_}

    # DBクローズ
    $objDb.Close()
    
    Write-Host "処理終了"
}
catch {
    if ($null -ne $objDb){
        # ロールバック
        $objDb.Rollback()

        # DBクローズ
        $objDb.Close()
    }

    Write-Host ("エラーメッセージ:" + $_.Exception.message)
    Write-Host ("LoaderExceptions:" + $_.Exception.LoaderExceptions)
    Write-Host ("スタックトレース:" + $_.ScriptStackTrace)
}