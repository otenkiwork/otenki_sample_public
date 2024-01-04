#==============================================================================
# データ変換クラス
#==============================================================================
class CComCnvData {
    # メンバ
    $arrHeader
    $delimiter

    #============================================================
    # コンストラクタ
    #------------------------------------------------------------
    # 引数 : なし
    #============================================================
    CComCnvData(){
        $this.arrHeader = @()
        $this.delimiter = " "
    }

    #============================================================
    # デリミタ設定
    #------------------------------------------------------------
    # 引数   : $pDelimiter : デリミタ
    # 戻り値 : なし
    #============================================================
    [void] SetDelimiter($pDelimiter){
        $this.delimiter = $pDelimiter
    }

    #============================================================
    # CSVに変換
    #------------------------------------------------------------
    # 引数   : $pData : 変換元データ
    # 戻り値 : CSVデータ
    #============================================================
    [object[]] DataToCsv($pData){
        $dataList = @()
        if ($pData.Length -le 0){
            return $dataList
        }

        # データが配列
        if ($pData[0].GetType().Name -eq "object[]"){
            $pData | ForEach-Object {
                $dataList += $_ -join $this.delimiter
            }
        }
        # データがカスタムオブジェクト
        elseif ($pData[0].GetType().Name -eq "PSCustomObject"){
            # 配列に変換後、CSVに変換
            $tmp = $this.DataToArray($pData)
            $dataList = $this.DataToCsv($tmp)
        }

        return $dataList
    }

    #============================================================
    # 配列に変換
    #------------------------------------------------------------
    # 引数   : $pData : 変換元データ
    # 戻り値 : 配列データ
    #============================================================
    [object[]] DataToArray($pData){
        $dataList = @()
        if ($pData.Length -le 0){
            return $dataList
        }

        # データが文字列(csv)
        if ($pData[0].GetType().Name -eq "string"){
            $pData | ForEach-Object {
                $arr = $_.Split($this.delimiter).Trim()
                if ($cnt -eq 0){
                    # １行目をヘッダとして項目名取得
                    # ※現状明細と処理が同じだが、ヘッダとは区別しておく
                    $dataList += ,$arr
                }
                else {
                    # 明細
                    $dataList += ,$arr
                }
            }
        }
        # データがカスタムオブジェクト
        elseif ($pData[0].GetType().Name -eq "PSCustomObject"){
            #列名を取り出す
            $colNames = $pData[0].psobject.properties.name
    
            # ヘッダ
            $dataList += ,$colNames
    
            # 明細
            $pData | ForEach-Object {
                $rec = $_
                $arr = @()
                $colNames | ForEach-Object {$arr += $rec.$_}
                $dataList += ,$arr
            }
        }
        return $dataList
    }

    #============================================================
    # カスタムオブジェクトに変換
    #------------------------------------------------------------
    # 引数   : $pData : 変換元データ
    # 戻り値 : カスタムオブジェクトデータ
    #============================================================
    [object[]] DataToCustomObj($pData){
        $dataList = @()
        if ($pData.Length -le 0){
            return $dataList
        }

        # データが配列
        if ($pData[0].GetType().Name -eq "object[]"){
            $cnt = 0
            $pData | ForEach-Object {
                if ($cnt -eq 0){
                    # １行目をヘッダとして項目名取得
                    $colNames = $_
                }
                else {
                    # ハッシュを作成
                    $hashData=[ordered]@{}    

                    $arr = $_             

                    for ($i = 0 ; $i -lt $colNames.Length ; $i++){
                        if ($arr.Length -gt $i){
                            $hashData += @{$colNames[$i] = $arr[$i]}
                        }
                        else {
                            $hashData += @{$colNames[$i] = ""}
                        }
                    }
                    # ハッシュからカスタムオブジェクトにキャスト
                    $dataList += [pscustomobject]$hashData
                }
                $cnt++
            }
        }
        # データが文字列(csv)
        elseif ($pData[0].GetType().Name -eq "string"){
            $tmp = $this.DataToArray($pData)
            $dataList = DataToCustomObj($tmp)
        }

        return $dataList
    }

}
