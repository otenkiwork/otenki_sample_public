#実行中のファイルパス取得
#$START_FILE_PATH = $MyInvocation.MyCommand.Path
#$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$rootPath = "C:\Data\dep\Git\git_otenkiwork\otenki_sample_public"
$gitDirName = "doc"
$dirpath = Join-Path $rootPath $gitDirName

$fileList = Get-ChildItem $dirPath -File

# 作業ディレクトリ内ファイル一覧取得して、最新のコミット日時を取得
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

# 【タグ指定】作業ディレクトリ内ファイル一覧取得して、指定タグ以前で最新のコミット日時を取得
foreach ($file in $fileList) {
    $gitFilePath = Join-Path $gitDirName $file.Name
    $timeStamp = (git log -1 --date=format:"%Y/%m/%d %H:%M:%S" --pretty=format:"%ad" v1.0.0 $gitFilePath)
    if ($null -eq $timeStamp){
        Write-Host $gitFilePath "Git未登録"
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
        Write-Host $gitFilePath "Git未登録"
    }
    else {
        Write-Host $gitFilePath $timeStamp
    }
}

