try {
    Add-Type -Path 'C:\Program Files (x86)\MySQL\MySQL Connector NET 8.2.0\MySQL.Data.dll'
}
catch {
    Write-Host "��O�������Ă��邪���̂܂ܑ��s"
    Write-Host $Error.Exception.message
}

. .\smpl105_01.ps1
#==============================================================================
# DB�A�N�Z�X�N���X(�x�[�X�N���X)
#==============================================================================
class CComDbAccess {
    # �����o
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
    $dbDataReader

    #============================================================
    # �R���X�g���N�^
    #------------------------------------------------------------
    # ���� : �Ȃ�
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
    # DB�I�[�v��
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [void] Open(){
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
    # ����   : $pSql : SQL������
    # �߂�l : �Ȃ�
    #============================================================
    [void] SetSql($pSql){
        $this.sql = $pSql
    }

    #============================================================
    # �f�[�^�^�C�v�Z�b�g
    #------------------------------------------------------------
    # ����   : $pDataType : SELECT���ʎ擾���̃f�[�^�^�C�v
    # �߂�l : �Ȃ�
    #============================================================
    [void] SetDataType($pDataType){
        $this.dataType = $pDataType
    }

    #============================================================
    # �f���~�^�Z�b�g
    #------------------------------------------------------------
    # ����   : $pDelimiter : �f���~�^
    # �߂�l : �Ȃ�
    #============================================================
    [void] SetpDelimiter($pDelimiter){
        $this.delimiter = $pDelimiter
    }

    #============================================================
    # SQL���s(SELECT�������s���f�[�^�擾)
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �f�[�^���X�g
    #============================================================
    [object] ExecSelect(){
        # SELECT�������s�����ʂ��擾
        #$this.dbCmd = New-Object System.Data.SQLClient.SQLCommand($this.sql, $this.dbCon)
        $this.dbCmd = $this.dbCon.CreateCommand()
        $this.dbCmd.CommandText = $this.sql        
        $this.dbDataReader = $this.dbCmd.ExecuteReader()

        $objData = @()
        switch ($this.dataType) {
            "CustomObj" { $objData = $this.GetDataCustomObj() }
            "Str" { $objData = $this.GetDataStr() }
            Default { $objData = $this.GetDataStr() }
        }

        $this.dbDataReader.Close()
        
        return $objData
    }

    #============================================================
    # �f�[�^�擾(�J�X�^���I�u�W�F�N�g)
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �f�[�^
    #============================================================
    [object] GetDataCustomObj(){
        #�񖼂����o��
        $colNames = $this.dbDataReader.GetSchemaTable() | Select-Object ColumnName

        #�f�[�^�����o���Ȃ��Ȃ�܂Ń��[�v
        $objData = while ($this.dbDataReader.read()){
             $colNames | ForEach-Object -Begin {
                # �n�b�V�����쐬
                $hashData=[ordered]@{}    
            } -Process {
                $hashData += @{$_.ColumnName = $this.dbDataReader[$_.ColumnName].tostring()}               
            } -End {
                # �n�b�V������J�X�^���I�u�W�F�N�g�ɃL���X�g
                [pscustomobject]$hashData     
            }

        }

        return $objData
    }

    #============================================================
    # �f�[�^�擾(������)
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �f�[�^
    #============================================================
    [object] GetDataStr(){
        $objData = @()

        #�񖼂����o��
        $colNames = $this.dbDataReader.GetSchemaTable() | Select-Object ColumnName

        #�w�b�_
        $line = ""    
        $colNames | ForEach-Object {
            if ($line -ne ""){
                $line += $this.delimiter
            }
            $line += $_.ColumnName               
        }
        $objData += $line

        #�f�[�^�����o���Ȃ��Ȃ�܂Ń��[�v
        while ($this.dbDataReader.read()){
            $line = ""    
            $colNames | ForEach-Object {
                if ($line -ne ""){
                    $line += $this.delimiter
                }
                $line += $this.dbDataReader[$_.ColumnName].tostring()               
            }
            $objData += $line
        }

        return $objData
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

}
