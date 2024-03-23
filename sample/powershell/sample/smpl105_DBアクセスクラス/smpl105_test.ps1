$ErrorActionPreference = "Stop"
$Error.Clear()

try {
    Write-Host "DB�ڑ�"
    $DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
    Set-Location -Path ($DIR_PATH)
    
    . .\smpl105_01.ps1
    . .\smpl105_01mysql.ps1
    . ..\smpl107_�f�[�^�ϊ��N���X\smpl107_01.ps1

    $objDb = $null

    # DB�I�[�v��
    $objDb = New-Object CComDbMySql("sv-ubuntu", "test_db", "miya", "wfrog9442", "3306") 
    $objDb.Open()

    $objDb.SetSql("SELECT * FROM tbl001")
    $objDb.SetpDelimiter(",")

    # �f�[�^�擾�i������j
    Write-Host "�f�[�^�擾�i������j"
    $objDb.SetDataType("Str")
    $data = $objDb.ExecSelect()
    $data | ForEach-Object {Write-Host $_}

    # �f�[�^�擾�i�z��j
    Write-Host "�f�[�^�擾�i�z��j"
    $objDb.SetDataType("Array")
    $data = $objDb.ExecSelect()
    $data | ForEach-Object {Write-Host $_}

    # �f�[�^�擾�i�J�X�^���I�u�W�F�N�g�j
    Write-Host "�f�[�^�擾�i�J�X�^���I�u�W�F�N�g�j"
    $objDb.SetDataType("CustomObj")
    $data = $objDb.ExecSelect()
    $data | ForEach-Object {Write-Host $_}

    $objDb.BeginTran()

    # �f�[�^�폜
    Write-Host "�f�[�^�폜"
    $objDb.SetSql("DELETE FROM tbl001 WHERE col001 >= 101")
    $cnt = $objDb.ExecNonQuery()

    # �f�[�^�ǉ�
    Write-Host "�f�[�^�ǉ�"
    $objDb.SetSql("INSERT tbl001 (col001, col002) VALUES (101, 'TEST101')")
    $cnt = $objDb.ExecNonQuery()

    # �e�[�u���X�V
    Write-Host "�e�[�u���X�V"
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

    # DB�N���[�Y
    $objDb.Close()
    
    Write-Host "�����I��"
}
catch {
    if ($null -ne $objDb){
        # ���[���o�b�N
        $objDb.Rollback()

        # DB�N���[�Y
        $objDb.Close()
    }

    Write-Host ("�G���[���b�Z�[�W:" + $_.Exception.message)
    Write-Host ("LoaderExceptions:" + $_.Exception.LoaderExceptions)
    Write-Host ("�X�^�b�N�g���[�X:" + $_.ScriptStackTrace)
}