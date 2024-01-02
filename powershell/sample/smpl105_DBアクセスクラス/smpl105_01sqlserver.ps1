. .\smpl105_01.ps1
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
    # DBオープン(SQLServer)
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
