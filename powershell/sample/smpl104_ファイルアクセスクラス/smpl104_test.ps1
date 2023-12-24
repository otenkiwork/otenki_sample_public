Write-Host "�t�@�C���Ǎ�"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl104_01.ps1

$objFile = New-Object CComFileAccess 
$objFile.ReadFile("data.txt")

Write-Host "�S�f�[�^�擾"
foreach($rec in $objFile.GetData()){
    Write-Host $rec 
}

Write-Host "�w�b�_�ȊO�擾�P"
$objFile.SetStrHeader(@("col1"))
foreach($rec in $objFile.GetDataNotHeader()){
    Write-Host $rec 
}

Write-Host "�w�b�_�ȊO�擾�Q"
$objFile.SetStrHeader(@("col1", "a001"))
$objFile.SetRecProc({
    Write-Host ("recProc:" + $_) 
})
$objFile.ExecRecProc()

Write-Host "�����I��"
