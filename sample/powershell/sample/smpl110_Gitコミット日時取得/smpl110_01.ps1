#���s���̃t�@�C���p�X�擾
#$START_FILE_PATH = $MyInvocation.MyCommand.Path
#$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$rootPath = "C:\Data\dep\Git\git_otenkiwork\otenki_sample_public"
$gitDirName = "doc"
$dirpath = Join-Path $rootPath $gitDirName

$fileList = Get-ChildItem $dirPath -File

# ��ƃf�B���N�g�����t�@�C���ꗗ�擾���āA�ŐV�̃R�~�b�g�������擾
foreach ($file in $fileList) {
    $gitFilePath = Join-Path $gitDirName $file.Name
    $timeStamp = (git log -1 --date=format:"%Y/%m/%d %H:%M:%S" --pretty=format:"%ad" $gitFilePath)
    if ($null -eq $timeStamp){
        Write-Host $gitFilePath "Git���o�^"
    }
    else {
        Write-Host $gitFilePath $timeStamp
    }
}

# �y�^�O�w��z��ƃf�B���N�g�����t�@�C���ꗗ�擾���āA�w��^�O�ȑO�ōŐV�̃R�~�b�g�������擾
foreach ($file in $fileList) {
    $gitFilePath = Join-Path $gitDirName $file.Name
    $timeStamp = (git log -1 --date=format:"%Y/%m/%d %H:%M:%S" --pretty=format:"%ad" v1.0.0 $gitFilePath)
    if ($null -eq $timeStamp){
        Write-Host $gitFilePath "Git���o�^"
    }
    else {
        Write-Host $gitFilePath $timeStamp
    }
}

git config --local core.quotepath false
$fileList = (git ls-files)
foreach ($file in $fileList) {
    $gitFilePath = $file
    $timeStamp = (git log -1 --date=format:"%Y/%m/%d %H:%M:%S" --pretty=format:"%ad" v1.0.0 $gitFilePath)
    if ($null -eq $timeStamp){
        Write-Host $gitFilePath "Git���o�^"
    }
    else {
        Write-Host $gitFilePath $timeStamp
    }
}

