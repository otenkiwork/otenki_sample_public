#==============================================================================
# テストクラス
#==============================================================================
class CTest : CTestBase{
    # メンバ

    #============================================================
    # コンストラクタ
    #------------------------------------------------------------
    # 引数 : なし
    #============================================================
    CTest(){
    }

    #============================================================
    # セットメッセージ
    #------------------------------------------------------------
    # 引数   : なし
    # 戻り値 : なし
    #============================================================
    [void] SetMsg(){
        $this.msg = "Test01"
    }

}
