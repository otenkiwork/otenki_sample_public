# �p�����N���X���C�����Ă��A�ă��[�h����Ȃ����ɂ���
# �p�����N���X��ʃt�@�C���Œ�`���Ă���ꍇ�A�ă��[�h�ł��Ȃ�
# �p�����N���X�𓯈�t�@�C���Œ�`���Ċm�F
# ����t�@�C�����ł���΁A�p�����̏C���͔��f�����
# �C�����ꂽ�\�[�X�����f�����B
# �p�������ʃt�@�C���̏ꍇ�A�p���������[�h����Ă��A
# �p���悪�C������Ă��Ȃ��ƁA�C���O�̌p�������g�p�����p����̂܂܂ɂȂ邽�߁A�p���������[�h����Ă��Ȃ��悤�Ɍ�����
Write-Host "�N���X���[�h�e�X�g�Q�i�p�����𓯈�t�@�C�����ɒ�`�j"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl108_03.ps1

Write-Host "CTest.DispMsg()"
$test = New-Object CTest
$test.DispMsg()

Write-Host "�����I��"
