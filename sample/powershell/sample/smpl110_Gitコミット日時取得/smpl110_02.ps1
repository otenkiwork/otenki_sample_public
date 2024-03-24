#���s���̃t�@�C���p�X�擾
#$START_FILE_PATH = $MyInvocation.MyCommand.Path
#$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$rootPath = "C:\Data\dep\Git\git_otenkiwork\otenki_sample_public"

# Git�R�}���h���A���{��G�X�P�[�v����Ȃ��悤�ɂ���ݒ�
git config --local core.quotepath false

# powershell�G���R�[�f�B���O�ݒ�̕ύX
$tmpOrgCode = [console]::OutputEncoding
[console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

$fileList = (git -C $rootPath ls-files)
foreach ($file in $fileList) {
    $gitFilePath = $file
    $timeStamp = (git -C $rootPath log -1 --date=format:"%Y/%m/%d %H:%M:%S" --pretty=format:"%ad" v1.0.0 $gitFilePath)
    if ($null -eq $timeStamp){
        Write-Host $gitFilePath "Git���o�^"
    }
    else {
        Write-Host $gitFilePath $timeStamp
    }
}

# powershell�G���R�[�f�B���O�ݒ�����ɖ߂�
[console]::OutputEncoding = $tmpOrgCode 

