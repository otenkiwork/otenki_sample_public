Set-StrictMode -Version Latest

Write-Host "STEP-000`$x="$x

[String] $x = "aaa"

function func1() {
    #�֐����ł́A�e�̃X�R�[�v�̓��e���Q�Ƃ͂ł��邪�A�X�V�ł��Ȃ�
    Write-Host "STEP-011  `$x="$x
    $x="bbb"
    Write-Host "STEP-012  `$x="$x
    func2
    Write-Host "STEP-013  `$x="$x
}

function func2() {
    #�֐����ł́A�e�̃X�R�[�v�̓��e���Q�Ƃ͂ł��邪�A�X�V�ł��Ȃ�
    Write-Host "STEP-021    `$x="$x
    $x="ccc"
    Write-Host "STEP-022    `$x="$x
    Write-Host "STEP-023���[�J�� `$x="(Get-Variable -Name x -Scope 0 -ValueOnly)
    Write-Host "STEP-024�e       `$x="(Get-Variable -Name x -Scope 1 -ValueOnly)
    Write-Host "STEP-025�e�e     `$x="(Get-Variable -Name x -Scope 2 -ValueOnly)
}
function func3() {
    #�֐����ł́A�X�N���v�g�X�R�[�v���w�肷�邱�ƂŁA�X�N���v�g�X�R�[�v�̓��e���Q�ƍX�V�ł���
    Write-Host "STEP-031    `$x="$script:x
    #$script:x="ddd"
    Write-Host "STEP-032    `$x="$script:x
}

Write-Host "STEP-001`$x="$x
func1
Write-Host "STEP-002`$x="$x
func3
Write-Host "STEP-003`$x="$x
$x = "eee"
Write-Host "STEP-004`$x="$x

$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
. ($DIR_PATH + "\test_scope_sub.ps1")

Write-Host "STEP-005`$x="$x
