Write-Host "�f�[�^�ϊ�"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl107_01.ps1

$arrDataOrg = @(
    ("col1", "col2", "col3"),
    ("a001", "b001", "���O�O�P"),
    ("a002", "b002", "���O�O�Q"),
    ("a003", "b003", "���O�O�R")
)

Write-Host "�z�񂩂�CSV"
$cnv = New-Object CComCnvData
$cnv.SetDelimiter(",")
$csvData = $cnv.DataToCsv($arrDataOrg)
Write-Host $csvData

Write-Host "�z�񂩂�J�X�^���I�u�W�F�N�g"
$objData = $cnv.DataToCustomObj($arrDataOrg)
Write-Host $objData

Write-Host "�J�X�^���I�u�W�F�N�g����z��"
$objData | ForEach-Object {$_.col2 = $_.col2.Replace("00", "xx")}
$arrData = $cnv.DataToArray($objData)
Write-Host $arrData

Write-Host "CSV����z��"
$csvData = $csvData.Replace("00", "yy")
$arrData = $cnv.DataToArray($csvData)
Write-Host $arrData

Write-Host "�����I��"
