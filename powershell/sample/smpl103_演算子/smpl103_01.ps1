#=====================================================
# ‰‰ZqƒTƒ“ƒvƒ‹
#=====================================================

# ğŒ”»’è
Write-Host ("¡¡¡ ğŒ”»’è ¡¡¡")
Write-Host ("¡ ”’l”äŠr")
[int]$val1 = 1

Write-Host ("`$val=" + $val1)
Write-Host ("`$val -eq 1 " + ($val1 -eq 1))
Write-Host ("`$val -eq 2 " + ($val1 -eq 2))
write-Host ("`$val -ne 1 " + ($val1 -ne 1))
write-Host ("`$val -ne 2 " + ($val1 -ne 2))
write-Host ("`$val -gt 1 " + ($val1 -gt 1))
write-Host ("`$val -gt 0 " + ($val1 -gt 0))
write-Host ("`$val -lt 1 " + ($val1 -lt 1))
write-Host ("`$val -lt 2 " + ($val1 -lt 2))
write-Host ("`$val -ge 1 " + ($val1 -ge 1))
write-Host ("`$val -ge 2 " + ($val1 -ge 2))
write-Host ("`$val -le 1 " + ($val1 -le 1))
write-Host ("`$val -le 0 " + ($val1 -le 0))

Write-Host ("¡ •¶š—ñ”äŠr")
[string]$strVal = "abc"

Write-Host ("`$strVal=" + $strVal)
Write-Host ("`$strVal -eq abc " + ($strVal -eq "abc"))
Write-Host ("`$strVal -eq abd " + ($strVal -eq "abd"))
Write-Host ("`$strVal -eq abC " + ($strVal -eq "abC"))
Write-Host ("`$strVal -ceq abC " + ($strVal -ceq "abC") + " ¦‰‰Zq‚Ìæ“ª c ‚Í‘å•¶š¬•¶š‹æ•Ê‚·‚é")

Write-Host ("¡ ”z—ñ”äŠr")
$arrVal = @("aaa", "bbb", "ccc")
Write-Host ("`$arrVal=" + $arrVal)
Write-Host ("`$arrVal -contains ""aaa"" " + ($arrVal -contains "aaa"))
Write-Host ("`$arrVal -contains ""aaa"" " + ($arrVal -contains "ddd"))

