#==============================================================================
# DB�A�N�Z�X�N���X
#==============================================================================
class CComDbAccess {
    # �����o
    $serverName
    $dbName
    $user
    $password
    $sql
    $delimiter
    $dbCon
    $dbCmd
    $dbDataReader

    #============================================================
    # �R���X�g���N�^
    #------------------------------------------------------------
    # ���� : �Ȃ�
    #============================================================
    CComDbAccess($pServerName, $pDbName, $pUser, $pPassword){
        $this.serverName = $pServerName
        $this.dbName = $pDbName
        $this.user = $pUser
        $this.password = $pPassword
        $this.sqlCmd = ""
        $this.delimiter = " "
    }

    #============================================================
    # DB�I�[�v��
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

    #============================================================
    # DB�N���[�Y
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [void] Close(){
        $this.dbCon.Close()
    }

    #============================================================
    # SQL�Z�b�g
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [void] SetSql($pSql){
        $this.sql = $pSql
    }

    #============================================================
    # SQL���s(SELECT�������s���f�[�^�擾)
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �f�[�^���X�g
    #============================================================
    [object[]] ExecSelect(){
        # SELECT�������s�����ʂ��擾
        $this.dbCmd = New-Object System.Data.SQLClient.SQLCommand($this.sql, $this.dbCon)
        $this.dbDataReader = $this.dbCmd.ExecuteReader()

        #�񖼂����o��
        $colum = $this.dbDataReader.GetSchemaTable() | Select-Object ColumnName

        #�f�[�^�����o���Ȃ��Ȃ�܂Ń��[�v
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
    # SQL���s(SELECT�ȊO��INSERT,UPDATE,DELETE�Ȃǂ����s)
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : ��������
    #============================================================
    [int] ExecNonQuery(){
        # SQL�������s
        $this.dbCmd = New-Object System.Data.SQLClient.SQLCommand($this.sql, $this.dbCon)
        $rowCount = $this.dbCmd.ExecuteNonQuery()

        return $rowCount
    }
}
