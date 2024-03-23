. .\smpl105_01.ps1
#==============================================================================
# DB�A�N�Z�X�N���X(SQLServer�p)
#==============================================================================
class CComDbSqlServer : CComDbAccess{
    # �����o

    #============================================================
    # �R���X�g���N�^
    #------------------------------------------------------------
    # ���� : �Ȃ�
    #============================================================
    CComDbSqlServer($pServerName, $pDbName, $pUser, $pPassword, $pPort) : 
        base($pServerName, $pDbName, $pUser, $pPassword, $pPort) {

    }

    #============================================================
    # DB�I�[�v��(SQLServer)
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [void] Open(){
        # �ڑ����̐ݒ�
        $conStr = New-Object -TypeName System.Data.SqlClient.SqlConnectionStringBuilder
        $conStr['Data Source'] = $this.serverName # �T�[�o�[��
        $conStr['Initial Catalog'] = $this.dbName         # DB��
        $conStr['user id'] = $this.user                    # ���[�U�[��
        $conStr['password'] = $this.password                   # �p�X���[�h    

        # �ڑ�
        $this.dbCon = New-Object System.Data.SQLClient.SQLConnection($conStr)
        $this.dbCon.Open()
    }

}
