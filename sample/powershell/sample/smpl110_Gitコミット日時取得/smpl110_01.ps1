#実行中のファイルパス取得
#$START_FILE_PATH = $MyInvocation.MyCommand.Path
#$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$rootPath = "C:\Data\dep\Git\git_otenkiwork\otenki_sample_public"
$gitDirName = "doc"
$dirpath = Join-Path $rootPath $gitDirName

$fileList = Get-ChildItem $dirPath -File

foreach ($file in $fileList) {
    $gitFilePath = Join-Path $gitDirName $file.Name
    $timeStamp = (git log -1 --date=format:"%Y/%m/%d %H:%M:%S" --pretty=format:"%ad" $gitFilePath)
    if ($null -eq $timeStamp){
        Write-Host $gitFilePath "Git未登録"
    }
    else {
        Write-Host $gitFilePath $timeStamp
    }
}