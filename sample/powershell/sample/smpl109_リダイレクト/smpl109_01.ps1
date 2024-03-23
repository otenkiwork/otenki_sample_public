#
# �EPowershell �̕W���o�͂́AWindows�̃R�}���h�v�����v�g��Linux�̃V�F���Ƃ͈قȂ�
# �EWindows�̃R�}���h�v�����v�g��Linux�̃V�F���́A�W���o�́A�G���[�o�͂ƃR���\�[���o�͓͂���
# �EPowershell �͕W���o�́A�G���[�o�͂ɑ�������X�g���[���ɏo��
#     �W���o��  �FStandard output stream(1>)
#     �G���[�o�́FError output stream(2>)
#     �R�}���h���p�C�v���C���̍Ō�̃R�}���h�̏ꍇ�A�R���\�[���ɏo�͂����
#
# �EWrite-Host�@�F�R���\�[���ւ̒��ڏo�́i�p�C�v���C���ɂ͏o�͂���Ȃ��j
# �EWrite-Output�FStandard output stream(1>)�֏o��
#
# �E�֐��̖߂�l��Standard output stream(1>)�ɏo�͂����
# �Ereturn �Ɏw�肵���ȊO�̊֐����Ńp�C�v�o�͂������̂��߂�l�Ɋ܂܂��
#

#���s���̃t�@�C���p�X�擾
$START_FILE_PATH = $MyInvocation.MyCommand.Path
$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$outFilePath = Join-Path $START_DIR_PATH "test.txt"

function Func001() {
    # �R���\�[���֒��ڏo��
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


