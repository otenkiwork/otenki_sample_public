Write-Host "�t�@�C���㏑���A�ǋL"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl104_01.ps1
. ..\smpl107_�f�[�^�ϊ��N���X\smpl107_01.ps1

$objFile = New-Object CComFileAccess 

$dataList = @(
    ,("col1","col2","col3")
    ,("a001","b001","���O�O�P")
    ,("a002","b002","���O�O�Q")
    ,("a003","b003","���O�O�R")
)
for ($i = 0 ; $i -lt 10000 ; $i++){
    $dataList += ,("a00X","b00X","���O�O�w")
}

# CSV�t�@�C����������(�J���}��؂�ŏo��)
$objFile.SetFilePath("data5.txt")
$objFile.SetDelimiter(",")
$objFile.SetWriteMode([ComWriteFileMode]::OverWrite)
$objFile.WriteFileData($dataList)

for ($i = 0 ; $i -lt 10 ; $i++){
    # CSV�t�@�C����������(�J���}��؂�ŏo��)(�ǋL)
    $objFile.SetFilePath("data5.txt")
    $objFile.SetDelimiter(",")
    $objFile.SetWriteMode([ComWriteFileMode]::Append)
    $objFile.WriteFileData($dataList)
}

Write-Host "�����I��"
