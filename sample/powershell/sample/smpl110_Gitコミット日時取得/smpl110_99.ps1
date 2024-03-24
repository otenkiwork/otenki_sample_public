#実行中のファイルパス取得
#$START_FILE_PATH = $MyInvocation.MyCommand.Path
#$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$rootPath = "C:\Data\dep\Git\git_otenkiwork\otenki_sample_public"

git config --local core.quotepath false
git ls-files
$fileList = git -C $rootPath ls-files
foreach ($file in $fileList) {
    Write-Host $file
#    $array = $file.ToCharArray()
#    foreach ($char in $array){
#        Write-Host ([System.String]::Format("{0:X2}", [System.Convert]::ToUInt32($CHAR)))
#    }
}

