#==================================================
# SELECT �p�����[�^����
#==================================================
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


    # �f�[�^�擾�i�p�����[�^�w��j
    Write-Host "�f�[�^�擾�i�p�����[�^�w��j"
    $objDb.SetSql("SELECT * FROM tbl001 WHERE col001 = @searchValue")
    $objDb.SetpDelimiter(",")
    $objDb.SetDataType("CustomObj")
    $data = $objDb.ExecSelectByParam(@(,("@searchValue", "1")))
    $data | ForEach-Object {Write-Host $_}

    # �f�[�^�擾�i�p�����[�^�͈͎w��j
    Write-Host "�f�[�^�擾�i�p�����[�^�͈͎w��j"
    $objDb.SetSql("SELECT * FROM tbl001 WHERE col001 BETWEEN  @fromValue AND @toValue")
    $objDb.SetpDelimiter(",")
    $objDb.SetDataType("CustomObj")
    $arrParams = @(
        ("@fromValue", "2"),
        ("@toValue", "4")
    )
    $data = $objDb.ExecSelectByParam($arrParams)
    $data | ForEach-Object {Write-Host $_}

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