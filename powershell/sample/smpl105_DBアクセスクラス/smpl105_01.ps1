#==============================================================================
# DBアクセスクラス(ベースクラス)
#==============================================================================
class CComDbAccess {
    # メンバ
    $dbType
    $serverName
    $dbName
    $user
    $password
    $port
    $sql
    $delimiter
    $dataType
    $dbCon
    $dbCmd
    $dbTran

    #============================================================
    # コンストラクタ
    #------------------------------------------------------------
    # 引数 : なし
    #============================================================
    CComDbAccess($pServerName, $pDbName, $pUser, $pPassword, $pPort){
        $this.serverName = $pServerName
        $this.dbName = $pDbName
        $this.user = $pUser
        $this.password = $pPassword
        $this.port = $pPort
        $this.sql = ""
        $this.delimiter = " "
    }

    #============================================================
    # DBオープン(継承してオーバーライドする)
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] Open(){
    }

    #============================================================
    # DBクローズ
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] Close(){
        if ($null -ne $this.dbCon){
            $this.dbCon.Close()
            $this.dbCon = $null
        }
    }

    #============================================================
    # トランザクション開始
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] BeginTran(){
        $this.dbTran = $this.dbCon.BeginTransaction()
    }

    #============================================================
    # トランザクションコミット
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] Commit(){
        $this.dbTran.Commit()
        $this.dbTran = $null
    }

    #============================================================
    # トランザクションロールバック
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] Rollback(){
        if ($null -ne $this.dbTran){
            $this.dbTran.Rollback()
            $this.dbTran = $null
        }
    }

    #============================================================
    # SQLセット
    #------------------------------------------------------------
    # 引数   : $pSql : SQL文字列
    # 戻り値 : なし
    #============================================================
    [void] SetSql($pSql){
        $this.sql = $pSql
    }

    #============================================================
    # データタイプセット
    #------------------------------------------------------------
    # 引数   : $pDataType : SELECT結果取得時のデータタイプ
    # 戻り値 : なし
    #============================================================
    [void] SetDataType($pDataType){
        $this.dataType = $pDataType
    }

    #============================================================
    # デリミタセット
    #------------------------------------------------------------
    # 引数   : $pDelimiter : デリミタ
    # 戻り値 : なし
    #============================================================
    [void] SetpDelimiter($pDelimiter){
        $this.delimiter = $pDelimiter
    }

    #============================================================
    # SQL実行(SELECT文を実行しデータ取得)
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : データリスト
    #============================================================
    [object] ExecSelect(){
        # SELECT文を実行し結果を取得
        $this.dbCmd = $this.dbCon.CreateCommand()
        $this.dbCmd.CommandText = $this.sql        
        $adapter = $this.NewDbDataAdapter()
        $adapter.SelectCommand = $this.dbCmd
        $dataset = New-Object System.Data.DataSet
        $adapter.Fill($dataSet)
        $dt = $dataset.Tables[0];

        $objData = @()
        switch ($this.dataType) {
            "CustomObj" { $objData = $this.GetDataCustomObj($dt) }
            "Array" { $objData = $this.GetDataArray($dt) }
            "Str" { $objData = $this.GetDataStr($dt) }
            Default { $objData = $this.GetDataStr($dt) }
        }

        return $objData
    }

    #============================================================
    # データ取得(カスタムオブジェクト)
    #------------------------------------------------------------
    # 引数   : $pDataTable : データテーブル
    # 戻り値 : データ
    #============================================================
    [object[]] GetDataCustomObj($pDataTable){
        #列名を取り出す
        $colNames = $pDataTable.Columns

        $objData = $pDataTable | ForEach-Object {
            $rec = $_
            $colNames | ForEach-Object -Begin {
                # ハッシュを作成
                $hashData=[ordered]@{}    
            } -Process {
                # ハッシュに(項目名=項目値)を追加
                $hashData += @{$_.ColumnName = $rec[$_.ColumnName].tostring()}               
            } -End {
                # ハッシュからカスタムオブジェクトにキャスト
                [pscustomobject]$hashData     
            }

        }

        return $objData
    }

    #============================================================
    # データ取得(文字列)
    #------------------------------------------------------------
    # 引数   : $pDataTable : データテーブル
    # 戻り値 : データ
    #============================================================
    [object[]] GetDataStr($pDataTable){
        $objData = $this.GetDataCustomObj($pDataTable)

        # CSV文字列に変換
        $cnv = New-Object CComCnvData
        $objData = $cnv.DataToCsv($objData)
        return $objData
    }

    #============================================================
    # データ取得(配列)
    #------------------------------------------------------------
    # 引数   : $pReader : データリーダー
    # 戻り値 : データ
    #============================================================
    [object[]] GetDataArray($pDataTable){
        $objData = $this.GetDataCustomObj($pDataTable)

        # 配列に変換
        $cnv = New-Object CComCnvData
        $objData = $cnv.DataToArray($objData)
        return $objData
    }

    #============================================================
    # SQL実行(SELECT以外のINSERT,UPDATE,DELETEなどを実行)
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : 処理件数
    #============================================================
    [int] ExecNonQuery(){
        # SQL文を実行
        $this.dbCmd = $this.dbCon.CreateCommand()
        $this.dbCmd.CommandText = $this.sql        
        $rowCount = $this.dbCmd.ExecuteNonQuery()

        return $rowCount
    }

    #============================================================
    # テーブル更新
    #------------------------------------------------------------
    # 引数   : $pTableName : テーブル名
    # 引数   : $pData      : 登録データ
    # 引数   : $pKeyCols   : キー項目(配列で指定)
    # 戻り値 : 処理件数
    #============================================================
    [int] UpdateTable($pTableName, $pData, $pKeyCols){
        $updateCount = 0

        # SQL文を実行
        $this.dbCmd = $this.dbCon.CreateCommand()

        $pData | ForEach-Object {
            $rec = $_

            # 対象を一旦削除
            $strWhere = " WHERE "
            $pKeyCols | ForEach-Object {
                $strWhere += ($pKeyCols + " = '" + $rec.$_ + "'")
            }

            $sql = "DELETE FROM " + $pTableName + $strWhere
            $this.dbCmd.CommandText = $sql        
            $rowCount = $this.dbCmd.ExecuteNonQuery()

            # 対象を登録
            $strColList = " ( "
            $strColList += ($rec.psobject.properties.name -Join ",")
            $strColList += " ) "
            $strValList = " ( "
            $strValList += (($rec.psobject.properties.value | ForEach-Object {"'" + $_ + "'"}) -Join ",")
            $strValList += " ) "

            $sql = "INSERT " + $pTableName + $strColList + " VALUES " + $strValList
            $this.dbCmd.CommandText = $sql        
            $rowCount = $this.dbCmd.ExecuteNonQuery()
            $updateCount += $rowCount
        }

        return $updateCount
    }
}

