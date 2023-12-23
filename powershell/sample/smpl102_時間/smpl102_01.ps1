# 時間処理クラス
class CComDateTime {
    $startTime = $null
    $endTime = $null

    # コンストラクタ
    CComDateTime() {

    }

    SetStartTime([DateTime]$pDateTime){
        $this.startTime = $pDateTime
    }

    SetEndTime([DateTime]$pDateTime){
        $this.endTime = $pDateTime
    }

    [string] GetStrStartTime(){
        return $this.startTime.ToString("yyyyMMddhhmmss")
    }

    [string] GetStrEndTime(){
        return $this.endTime.ToString("yyyyMMddhhmmss")
    }

    [string] GetStrDurationMS(){
        # 処理時間を算出しTimeSpanオブジェクトを取得
        [TimeSpan]$duration = $this.endTime - $this.startTime
        return $duration.Minutes.ToString("00") + ":" + $duration.Seconds.ToString("00")
    }

}