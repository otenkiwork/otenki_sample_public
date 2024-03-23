# 継承元クラスを修正しても、再ロードされない
# VSCODEのデバッグ環境は、powershellのセッションを同じものをずっと使用している
# セッションを手動で一旦閉じないと継承元クラス（別ファイル）が再ロードできない
# 継承先クラスは修正がすぐに反映する
# この違いは、継承元を修正しても、継承先を修正していないと、継承先クラスが
# 修正前の継承元クラスを使用した状態のままになっているため継承元の修正が反映されない
# 継承元、継承先どちらも修正がされていれば、継承元の修正は繁栄される
# 対策 VSCODEの設定で、毎回一時的なセッションでデバッグ実行するように設定
# カテゴリ 拡張機能 → PowerShell Configuration の中にある「PowerShell > Debugging: Create Temporary Integrated Console」のチェックボックスをオンにする。
Write-Host "クラスロードテスト"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

. .\smpl108_base.ps1
. .\smpl108_01.ps1
. .\smpl108_02.ps1

#Write-Host "CTestBase.DispMsg()"
#$test = New-Object CTestBase
#$test.DispMsg()

Write-Host "CTest.DispMsg()"
$test = New-Object CTest
$test.DispMsg()

Write-Host "処理終了"
