Set-StrictMode -Version Latest

Write-Host "STEP-000`$x="$x

[String] $x = "aaa"

function func1() {
    #関数内では、親のスコープの内容を参照はできるが、更新できない
    Write-Host "STEP-011  `$x="$x
    $x="bbb"
    Write-Host "STEP-012  `$x="$x
    func2
    Write-Host "STEP-013  `$x="$x
}

function func2() {
    #関数内では、親のスコープの内容を参照はできるが、更新できない
    Write-Host "STEP-021    `$x="$x
    $x="ccc"
    Write-Host "STEP-022    `$x="$x
    Write-Host "STEP-023ローカル `$x="(Get-Variable -Name x -Scope 0 -ValueOnly)
    Write-Host "STEP-024親       `$x="(Get-Variable -Name x -Scope 1 -ValueOnly)
    Write-Host "STEP-025親親     `$x="(Get-Variable -Name x -Scope 2 -ValueOnly)
}
function func3() {
    #関数内では、スクリプトスコープを指定することで、スクリプトスコープの内容を参照更新できる
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
