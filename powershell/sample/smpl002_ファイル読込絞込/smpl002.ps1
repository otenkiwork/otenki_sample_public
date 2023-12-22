Write-Host "ファイル読込"
$DIR_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent
Set-Location -Path ($DIR_PATH)

function CheckHeader($pRec){
    if (($pRec[0] -eq "col1") -and ($pRec[1] -eq "col2")) {
        return $true
    }

    return $false
}

#ヘッダ以外を出力(関数で判定)
$recList = Get-Content "data.txt"
foreach($rec in $recList){
    $arr = -split $rec
    #ヘッダ以外を出力
    if (-not (CheckHeader($arr))){
        Write-Host $arr 
    }
}

class CFilterObjList {
    $headCol1 = "col1"
    $headCol2 = "col2"

    [bool]CheckHeader($pRec) {
        $arr = -split $pRec
        if (($arr[0] -eq "col1") -and ($arr[1] -eq "col2")) {
            return $true
        }
        return $false
    }

    [Object[]]FilterListr([Object[]]$pList) {
        return $pList | Where-Object {-not ($this.CheckHeader($_))}
    }

}

$filter = New-Object CFilterObjList 
$recList = Get-Content "data.txt"
foreach($rec in $filter.FilterListr($recList)){
    $arr = -split $rec
    Write-Host $arr 
}


Write-Host "処理終了"
