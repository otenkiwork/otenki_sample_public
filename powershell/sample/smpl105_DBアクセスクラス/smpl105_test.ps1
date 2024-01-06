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

    $objDb.BeginTran()

    # データ削除
    Write-Host "データ削除"
    $objDb.SetSql("DELETE FROM tbl001 WHERE col001 >= 101")
    $cnt = $objDb.ExecNonQuery()

    # データ追加
    Write-Host "データ追加"
    $objDb.SetSql("INSERT tbl001 (col001, col002) VALUES (101, 'TEST101')")
    $cnt = $objDb.ExecNonQuery()

    # テーブル更新
    Write-Host "テーブル更新"
    $arrData = @(("col001", "col002"),
    (1, "TEST001X"),
    (2, "TEST002X"),
    (3, "TEST003X"),
    (4, "TEST004XX"),
    (5, "TEST005X")
    )
    $cnv = New-Object CComCnvData
    $objData = $cnv.DataToCustomObj($arrData)
    $cnt = $objDb.UpdateTable("tbl001", $objData, @("col001"))

    $objDb.Commit()

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