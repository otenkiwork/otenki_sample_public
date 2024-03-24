#実行中のファイルパス取得
#$START_FILE_PATH = $MyInvocation.MyCommand.Path
#$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$rootPath = "C:\Data\dep\Git\git_otenkiwork\otenki_sample_public"

# Gitコマンドが、日本語エスケープされないようにする設定
git config --local core.quotepath false

# powershellエンコーディング設定の変更
$tmpOrgCode = [console]::OutputEncoding
[console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

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

# powershellエンコーディング設定を元に戻す
[console]::OutputEncoding = $tmpOrgCode 

