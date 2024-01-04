
try {
    Add-Type -Path 'C:\Program Files (x86)\MySQL\MySQL Connector NET 8.2.0\MySQL.Data.dll'
}
catch {
    Write-Host "例外発生しているがそのまま続行"
    Write-Host $Error.Exception.message
    $Error.Clear()
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
    # DBオープン(MySql)
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

    #============================================================
    # DbDataAdapter作成(MySql)
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [object] NewDbDataAdapter(){
        $adapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter
        return $adapter
    }

}
