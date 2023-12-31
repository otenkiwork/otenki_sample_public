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
    $dbCon
    $dbCmd
    $dbDataReader

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
    # DBオープン
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
        $this.dbCon.Close()
    }

    #============================================================
    # SQLセット
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] SetSql($pSql){
        $this.sql = $pSql
    }

    #============================================================
    # SQL実行(SELECT文を実行しデータ取得)
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : データリスト
    #============================================================
    [object[]] ExecSelect(){
        # SELECT文を実行し結果を取得
        #$this.dbCmd = New-Object System.Data.SQLClient.SQLCommand($this.sql, $this.dbCon)
        $this.dbCmd = $this.dbCon.CreateCommand()
        $this.dbCmd.CommandText = $this.sql        
        $this.dbDataReader = $this.dbCmd.ExecuteReader()

        #列名を取り出す
        $colum = $this.dbDataReader.GetSchemaTable() | Select-Object ColumnName

        #データが取り出せなくなるまでループ
        $objs = while ($this.dbDataReader.read()){
                    $colum | ForEach-Object -Begin {
                        $obj=[ordered]@{}    
                    } -Process {
                        $obj += @{$_.ColumnName = $this.dbDataReader[$_.ColumnName].tostring()}               
                    } -End {
                        [pscustomobject]$obj     
                    }
                }

        $this.dbDataReader.Close()
        
        return $objs
    }

    #============================================================
    # SQL実行(SELECT以外のINSERT,UPDATE,DELETEなどを実行)
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : 処理件数
    #============================================================
    [int] ExecNonQuery(){
        # SQL文を実行
        $this.dbCmd = New-Object System.Data.SQLClient.SQLCommand($this.sql, $this.dbCon)
        $rowCount = $this.dbCmd.ExecuteNonQuery()

        return $rowCount
    }
}

#==============================================================================
# DBアクセスクラス(SQLServer用)
#==============================================================================
class CComDbSqlServer : CComDbAccess{
    # メンバ

    #============================================================
    # コンストラクタ
    #------------------------------------------------------------
    # 引数 : なし
    #============================================================
    CComDbSqlServer($pServerName, $pDbName, $pUser, $pPassword, $pPort) : 
    base($pServerName, $pDbName, $pUser, $pPassword, $pPort) {

    }

    #============================================================
    # DBオープン
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] Open(){
        # 接続情報の設定
        $conStr = New-Object -TypeName System.Data.SqlClient.SqlConnectionStringBuilder
        $conStr['Data Source'] = $this.serverName # サーバー名
        $conStr['Initial Catalog'] = $this.dbName         # DB名
        $conStr['user id'] = $this.user                    # ユーザー名
        $conStr['password'] = $this.password                   # パスワード    

        # 接続
        $this.dbCon = New-Object System.Data.SQLClient.SQLConnection($conStr)
        $this.dbCon.Open()
    }

}
#==============================================================================
# DBアクセスクラス(MySQL用)
#==============================================================================
class CComDbMySql : CComDbAccess {
    # メンバ

    #============================================================
    # コンストラクタ
    #------------------------------------------------------------
    # 引数 : なし
    #============================================================
    CComDbMySql($pServerName, $pDbName, $pUser, $pPassword, $pPort) : 
        base($pServerName, $pDbName, $pUser, $pPassword, $pPort){
    }

    #============================================================
    # DBオープン
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] Open(){
        # 接続情報の設定
        [string]$mySQLHost             = $this.serverName
        [string]$mySQLPort             = $this.port
        [string]$mySQLUserName         = $this.user
        [string]$mySQLPassword         = $this.password
        [string]$mySQLDB               = $this.dbName
        [string]$conStr = "server='$mySQLHost';port='$mySQLPort';uid='$mySQLUserName';pwd=$mySQLPassword;database=$mySQLDB"

        # 接続
        $this.dbCon = New-Object MySql.Data.MySqlClient.MySqlConnection($conStr)
        $this.dbCon.Open()
    }

}
