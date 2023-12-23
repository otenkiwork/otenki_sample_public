# ���ԏ����N���X
class CComDateTime {
    $startTime = $null
    $endTime = $null

    # �R���X�g���N�^
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
        # �������Ԃ��Z�o��TimeSpan�I�u�W�F�N�g���擾
        [TimeSpan]$duration = $this.endTime - $this.startTime
        return $duration.Minutes.ToString("00") + ":" + $duration.Seconds.ToString("00")
    }

}