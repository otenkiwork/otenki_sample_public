#
# �E�֐��̖߂�l�͕W���o�͂ɏo�͂����
# �Ereturn �Ɏw�肵���ȊO�̊֐����Ńp�C�v�o�͂������̂��߂�l�Ɋ܂܂��
#

#���s���̃t�@�C���p�X�擾
$START_FILE_PATH = $MyInvocation.MyCommand.Path
$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$outFilePath = Join-Path $START_DIR_PATH "test.txt"

function Func001() {
    # �W���o��
    Write-Host "Func001_Write-Host"

    # �p�C�v�i�߂�l�ɂȂ�j
    Write-Output  "Func001_Write-Output"

    return $tr
}

function Func002() {
    $dt = Get-Date
    $list = $dt.ToString("yyyy/MM/dd hh:mm:ss")  2>&1 
    $list > $outFilePath
}

Write-Host "Func001���s(1) �P���Ɋ֐����s"
Write-Host "               Write-Host�AWrite-Output(�p�C�v)���W���o�͂ɏo�͂����"
Write-Host "               return �̒l���W���o�͂ɏo�͂����"
Func001

Write-Host "Func001���s(2) `$null �Ƀ��_�C���N�g"
Write-Host "               Write-Output(�p�C�v)��return�̒l��`$null�Ɏ̂Ă���"
Func001 > $null

Write-Host "Func001���s(3) �߂�l��ϐ��ɑ�������ꍇ"
Write-Host "               Write-Output(�p�C�v)��return�̒l���ϐ��ɑ������W���o�͂ɂ͏o�͂���Ȃ�"
$ret = Func001

Write-Host "Func001�߂�l "
Write-Host $ret

Write-Host "Func002���s"
$ret = Func002

Write-Host "Func002�߂�l"
Write-Host $ret


