# �p�����N���X���C�����Ă��A�ă��[�h����Ȃ�
# VSCODE�̃f�o�b�O���́Apowershell�̃Z�b�V�����𓯂����̂������Ǝg�p���Ă���
# �Z�b�V�������蓮�ň�U���Ȃ��ƌp�����N���X�i�ʃt�@�C���j���ă��[�h�ł��Ȃ�
# �p����N���X�͏C���������ɔ��f����
# ���̈Ⴂ�́A�p�������C�����Ă��A�p������C�����Ă��Ȃ��ƁA�p����N���X��
# �C���O�̌p�����N���X���g�p������Ԃ̂܂܂ɂȂ��Ă��邽�ߌp�����̏C�������f����Ȃ�
# �p�����A�p����ǂ�����C��������Ă���΁A�p�����̏C���͔ɉh�����
# �΍� VSCODE�̐ݒ�ŁA����ꎞ�I�ȃZ�b�V�����Ńf�o�b�O���s����悤�ɐݒ�
# �J�e�S�� �g���@�\ �� PowerShell Configuration �̒��ɂ���uPowerShell > Debugging: Create Temporary Integrated Console�v�̃`�F�b�N�{�b�N�X���I���ɂ���B
Write-Host "�N���X���[�h�e�X�g"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl108_base.ps1
. .\smpl108_01.ps1
. .\smpl108_02.ps1

#Write-Host "CTestBase.DispMsg()"
#$test = New-Object CTestBase
#$test.DispMsg()

Write-Host "CTest.DispMsg()"
$test = New-Object CTest
$test.DispMsg()

Write-Host "�����I��"
