$ErrorActionPreference = "Stop"
$Error.Clear()

try {
    Write-Host "DB�ڑ�"
    $DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
    Set-Location -Path ($DIR_PATH)
    
    . .\smpl105_01.ps1
    . .\smpl105_01mysql.ps1
    . ..\smpl107_�f�[�^�ϊ��N���X\smpl107_01.ps1

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

    # DB�N���[�Y
    $objDb.Close()
    
    Write-Host "�����I��"
}
catch [Exception] {
    foreach ($err in $Error){
        Write-Host ("�G���[���b�Z�[�W:" + $err.Exception.message)
        Write-Host ("LoaderExceptions:" + $err.Exception.LoaderExceptions)
        Write-Host ("�X�^�b�N�g���[�X:" + $err.ScriptStackTrace)
    }
}