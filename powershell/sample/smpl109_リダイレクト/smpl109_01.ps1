#
# ・Powershell の標準出力は、WindowsのコマンドプロンプトやLinuxのシェルとは異なる
# ・WindowsのコマンドプロンプトやLinuxのシェルは、標準出力、エラー出力とコンソール出力は同一
# ・Powershell は標準出力、エラー出力に相当するストリームに出力
#     標準出力  ：Standard output stream(1>)
#     エラー出力：Error output stream(2>)
#     コマンドがパイプラインの最後のコマンドの場合、コンソールに出力される
#
# ・Write-Host　：コンソールへの直接出力（パイプラインには出力されない）
# ・Write-Output：Standard output stream(1>)へ出力
#
# ・関数の戻り値はStandard output stream(1>)に出力される
# ・return に指定した以外の関数内でパイプ出力したものも戻り値に含まれる
#

#実行中のファイルパス取得
$START_FILE_PATH = $MyInvocation.MyCommand.Path
$START_DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

$outFilePath = Join-Path $START_DIR_PATH "test.txt"

function Func001() {
    # コンソールへ直接出力
    Write-Host "Func001_Write-Host"

    # パイプ（戻り値になる）
    Write-Output  "Func001_Write-Output"

    return $tr
}

function Func002() {
    $dt = Get-Date
    $list = $dt.ToString("yyyy/MM/dd hh:mm:ss")  2>&1 
    $list > $outFilePath
}

Write-Host "Func001実行(1) 単純に関数実行"
Write-Host "               Write-Host、Write-Output(パイプ)が標準出力に出力される"
Write-Host "               return の値も標準出力に出力される"
Func001

Write-Host "Func001実行(2) `$null にリダイレクト"
Write-Host "               Write-Output(パイプ)とreturnの値が`$nullに捨てられる"
Func001 > $null

Write-Host "Func001実行(3) 戻り値を変数に代入した場合"
Write-Host "               Write-Output(パイプ)とreturnの値が変数に代入され標準出力には出力されない"
$ret = Func001

Write-Host "Func001戻り値 "
Write-Host $ret

Write-Host "Func002実行"
$ret = Func002

Write-Host "Func002戻り値"
Write-Host $ret


