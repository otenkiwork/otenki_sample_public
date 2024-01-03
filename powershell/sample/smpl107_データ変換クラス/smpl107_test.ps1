Write-Host "�t�@�C���Ǎ�"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl104_01.ps1

$objFile = New-Object CComFileAccess 
$objFile.ReadFile("data.txt")

Write-Host "�J�X�^���I�u�W�F�N�g�Ŏ擾"
$objFile.SetStrHeader(@("col1"))
$objFile.SetDelimiter(" ")
$dataList = $objFile.GetDataCustomObj()

# ���ڒl�ϊ�
foreach($rec in $dataList){
    $rec.col2 = $rec.col2.replace("00", "11")
}

# �t�@�C����������(�J�X�^���I�u�W�F�N�g�w��)(�J���}��؂�ɕύX)
$objFile.SetFilePath("data2.txt")
$objFile.SetDelimiter(",")
$objFile.WriteCsvFileCustomObj($dataList)

Write-Host "�����I��"
