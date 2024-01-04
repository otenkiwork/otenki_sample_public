
try {
    Add-Type -Path 'C:\Program Files (x86)\MySQL\MySQL Connector NET 8.2.0\MySQL.Data.dll'
}
catch {
    Write-Host "��O�������Ă��邪���̂܂ܑ��s"
    Write-Host $Error.Exception.message
    $Error.Clear()
}

#==============================================================================
# DB�A�N�Z�X�N���X(MySQL�p)
#==============================================================================
class CComDbMySql : CComDbAccess {
    # �����o

    #============================================================
    # �R���X�g���N�^
    #------------------------------------------------------------
    # ���� : �Ȃ�
    #============================================================
    CComDbMySql($pServerName, $pDbName, $pUser, $pPassword, $pPort) : 
        base($pServerName, $pDbName, $pUser, $pPassword, $pPort){
    }

    #============================================================
    # DB�I�[�v��(MySql)
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [void] Open(){
        # �ڑ����̐ݒ�
        [string]$mySQLHost             = $this.serverName
        [string]$mySQLPort             = $this.port
        [string]$mySQLUserName         = $this.user
        [string]$mySQLPassword         = $this.password
        [string]$mySQLDB               = $this.dbName
        [string]$conStr = "server='$mySQLHost';port='$mySQLPort';uid='$mySQLUserName';pwd=$mySQLPassword;database=$mySQLDB"

        # �ڑ�
        $this.dbCon = New-Object MySql.Data.MySqlClient.MySqlConnection($conStr)
        $this.dbCon.Open()
    }

    #============================================================
    # DbDataAdapter�쐬(MySql)
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [object] NewDbDataAdapter(){
        $adapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter
        return $adapter
    }

}
