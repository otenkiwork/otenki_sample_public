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
    $dbTran

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
    # DB�I�[�v��(�p�����ăI�[�o�[���C�h����)
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
        if ($null -ne $this.dbCon){
            $this.dbCon.Close()
            $this.dbCon = $null
        }
    }

    #============================================================
    # �g�����U�N�V�����J�n
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [void] BeginTran(){
        $this.dbTran = $this.dbCon.BeginTransaction()
    }

    #============================================================
    # �g�����U�N�V�����R�~�b�g
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [void] Commit(){
        $this.dbTran.Commit()
        $this.dbTran = $null
    }

    #============================================================
    # �g�����U�N�V�������[���o�b�N
    #------------------------------------------------------------
    # ����   : �Ȃ�
    # �߂�l : �Ȃ�
    #============================================================
    [void] Rollback(){
        if ($null -ne $this.dbTran){
            $this.dbTran.Rollback()
            $this.dbTran = $null
        }
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
    # �f�[�^�擾(�J�X�^���I�u�W�F�N�g)
    #------------------------------------------------------------
    # ����   : $pDataTable : �f�[�^�e�[�u��
    # �߂�l : �f�[�^
    #============================================================
    [object[]] GetDataCustomObj($pDataTable){
        #�񖼂����o��
        $colNames = $pDataTable.Columns

        $objData = $pDataTable | ForEach-Object {
            $rec = $_
            $colNames | ForEach-Object -Begin {
                # �n�b�V�����쐬
                $hashData=[ordered]@{}    
            } -Process {
                # �n�b�V����(���ږ�=���ڒl)��ǉ�
                $hashData += @{$_.ColumnName = $rec[$_.ColumnName].tostring()}               
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
    # ����   : $pDataTable : �f�[�^�e�[�u��
    # �߂�l : �f�[�^
    #============================================================
    [object[]] GetDataStr($pDataTable){
        $objData = $this.GetDataCustomObj($pDataTable)

        # CSV������ɕϊ�
        $cnv = New-Object CComCnvData
        $objData = $cnv.DataToCsv($objData)
        return $objData
    }

    #============================================================
    # �f�[�^�擾(�z��)
    #------------------------------------------------------------
    # ����   : $pReader : �f�[�^���[�_�[
    # �߂�l : �f�[�^
    #============================================================
    [object[]] GetDataArray($pDataTable){
        $objData = $this.GetDataCustomObj($pDataTable)

        # �z��ɕϊ�
        $cnv = New-Object CComCnvData
        $objData = $cnv.DataToArray($objData)
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
        $this.dbCmd = $this.dbCon.CreateCommand()
        $this.dbCmd.CommandText = $this.sql        
        $rowCount = $this.dbCmd.ExecuteNonQuery()

        return $rowCount
    }

    #============================================================
    # �e�[�u���X�V
    #------------------------------------------------------------
    # ����   : $pTableName : �e�[�u����
    # ����   : $pData      : �o�^�f�[�^
    # ����   : $pKeyCols   : �L�[����(�z��Ŏw��)
    # �߂�l : ��������
    #============================================================
    [int] UpdateTable($pTableName, $pData, $pKeyCols){
        $updateCount = 0

        # SQL�������s
        $this.dbCmd = $this.dbCon.CreateCommand()

        $pData | ForEach-Object {
            $rec = $_

            # �Ώۂ���U�폜
            $strWhere = " WHERE "
            $pKeyCols | ForEach-Object {
                $strWhere += ($pKeyCols + " = '" + $rec.$_ + "'")
            }

            $sql = "DELETE FROM " + $pTableName + $strWhere
            $this.dbCmd.CommandText = $sql        
            $rowCount = $this.dbCmd.ExecuteNonQuery()

            # �Ώۂ�o�^
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

