#==============================================================================
# �f�[�^�ϊ��N���X
#==============================================================================
class CComCnvData {
    # �����o
    $arrHeader
    $addHeaderFlg
    $addHeaderDone
    $delimiter

    #============================================================
    # �R���X�g���N�^
    #------------------------------------------------------------
    # ���� : �Ȃ�
    #============================================================
    CComCnvData(){
        $this.arrHeader = @()
        $this.addHeaderFlg = $false
        $this.addHeaderDone = $false
        $this.delimiter = ""
    }

    #============================================================
    # �f���~�^�ݒ�
    #------------------------------------------------------------
    # ����   : $pDelimiter : �f���~�^
    # �߂�l : �Ȃ�
    #============================================================
    [void] SetDelimiter($pDelimiter){
        $this.delimiter = $pDelimiter
    }

    #============================================================
    # CSV�ɕϊ�
    #------------------------------------------------------------
    # ����   : $pData : �ϊ����f�[�^
    # �߂�l : CSV�f�[�^
    #============================================================
    [object[]] DataToCsv($pData){
        $this.addHeaderDone = $false

        $dataList = @()
        if ($pData.Length -le 0){
            return $dataList
        }

        # �f�[�^���z��
        if ($pData[0].GetType().Name -eq "object[]"){
            if ($this.addHeaderFlg -and ($this.arrHeader.Length -gt 0) -and (-not $this.addHeaderDone)){
                # �w�b�_�ǉ�
                $dataList += $this.arrHeader -join $this.delimiter
                $this.addHeaderDone = $true
            }

            $pData | ForEach-Object {
                $dataList += $_ -join $this.delimiter
            }
        }
        # �f�[�^���J�X�^���I�u�W�F�N�g
        elseif ($pData[0].GetType().Name -eq "PSCustomObject"){
            # �z��ɕϊ���ACSV�ɕϊ�
            $tmp = $this.DataToArray($pData)
            $dataList = $this.DataToCsv($tmp)
        }

        return $dataList
    }

    #============================================================
    # �z��ɕϊ�
    #------------------------------------------------------------
    # ����   : $pData : �ϊ����f�[�^
    # �߂�l : �z��f�[�^
    #============================================================
    [object[]] DataToArray($pData){
        $this.addHeaderDone = $false

        $dataList = @()
        if ($pData.Length -le 0){
            return $dataList
        }

        # �f�[�^��������(csv)
        if ($pData[0].GetType().Name -eq "string"){
            if ($this.addHeaderFlg -and ($this.arrHeader.Length -gt 0) -and (-not $this.addHeaderDone)){
                # �w�b�_�ǉ�
                $dataList += ,$this.arrHeader
                $this.addHeaderDone = $true
            }

            $pData | ForEach-Object {
                $arr = $_.Split($this.delimiter).Trim()
                if ($cnt -eq 0){
                    # �P�s�ڂ��w�b�_�Ƃ��č��ږ��擾
                    # �����󖾍ׂƏ��������������A�w�b�_�Ƃ͋�ʂ��Ă���
                    $dataList += ,$arr
                }
                else {
                    # ����
                    $dataList += ,$arr
                }
            }
        }
        # �f�[�^���J�X�^���I�u�W�F�N�g
        elseif ($pData[0].GetType().Name -eq "PSCustomObject"){
            #�񖼂����o��
            $colNames = $pData[0].psobject.properties.name
    
            # �w�b�_
            $dataList += ,$colNames
    
            # ����
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
    # �J�X�^���I�u�W�F�N�g�ɕϊ�
    #------------------------------------------------------------
    # ����   : $pData : �ϊ����f�[�^
    # �߂�l : �J�X�^���I�u�W�F�N�g�f�[�^
    #============================================================
    [object[]] DataToCustomObj($pData){
        $this.addHeaderDone = $false

        $dataList = @()
        if ($pData.Length -le 0){
            return $dataList
        }

        # �f�[�^���z��
        if ($pData[0].GetType().Name -eq "object[]"){
            $dataStartCnt = 0
            $cnt = 0
            $pData | ForEach-Object {
                if ($cnt -eq 0){
                    if ($this.addHeaderFlg -and ($this.arrHeader.Length -gt 0) -and (-not $this.addHeaderDone)){
                        # �w�b�_�ǉ�
                        $colNames = $this.arrHeader
                        $this.addHeaderDone = $true
                    }
                    else {
                        # �P�s�ڂ��w�b�_�Ƃ��č��ږ��擾
                        $colNames = $_
                        # �f�[�^�J�n�s���{�P
                        $dataStartCnt++
                    }
                }

                # �f�[�^�J�n�s�ȏ�ł���΃n�b�V���ǉ�
                if ($cnt -ge $dataStartCnt){
                    # �n�b�V�����쐬
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
                    # �n�b�V������J�X�^���I�u�W�F�N�g�ɃL���X�g
                    $dataList += [pscustomobject]$hashData
                }
                $cnt++
            }
        }
        # �f�[�^��������(csv)
        elseif ($pData[0].GetType().Name -eq "string"){
            $tmp = $this.DataToArray($pData)
            $dataList = DataToCustomObj($tmp)
        }

        return $dataList
    }

}
