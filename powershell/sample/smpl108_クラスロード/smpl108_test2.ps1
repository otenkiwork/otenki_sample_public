# 継承元クラスを修正しても、再ロードされない件について
# 継承元クラスを別ファイルで定義している場合、再ロードできない
# 継承元クラスを同一ファイルで定義して確認
# 同一ファイル内であれば、継承元の修正は反映される
# 修正されたソースが反映される。
# 継承元が別ファイルの場合、継承元がロードされても、
# 継承先が修正されていないと、修正前の継承元を使用した継承先のままになるため、継承元がロードされていないように見える
Write-Host "クラスロードテスト２（継承元を同一ファイル内に定義）"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl108_03.ps1

Write-Host "CTest.DispMsg()"
$test = New-Object CTest
$test.DispMsg()

Write-Host "処理終了"
