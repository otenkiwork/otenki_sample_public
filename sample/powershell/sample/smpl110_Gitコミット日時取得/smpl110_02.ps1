#実行中のファイルパス取得
#$START_FILE_PATH = $MyInvocation.MyCommand.Path
#$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$rootPath = "C:\Data\dep\Git\git_otenkiwork\otenki_sample_public"

git config --local core.quotepath false
$fileList = (git -C $rootPath ls-files)
foreach ($file in $fileList) {
    $gitFilePath = $file
    $timeStamp = (git -C $rootPath log -1 --date=format:"%Y/%m/%d %H:%M:%S" --pretty=format:"%ad" v1.0.0 $gitFilePath)
    if ($null -eq $timeStamp){
        Write-Host $gitFilePath "Git未登録"
    }
    else {
        Write-Host $gitFilePath $timeStamp
    }
}

