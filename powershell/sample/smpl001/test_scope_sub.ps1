Set-StrictMode -Version Latest

function func1() {
    #�֐����ł́A�e�̃X�R�[�v�̓��e���Q�Ƃ͂ł��邪�A�X�V�ł��Ȃ�
    Write-Host "STEP-111  `$x="$x
    $x="bbb"
    Write-Host "STEP-112  `$x="$x
    func2
    Write-Host "STEP-113  `$x="$x
}

Write-Host "STEP-101`$x="$x
func1
Write-Host "STEP-102`$x="$x
func3
Write-Host "STEP-103`$x="$x
