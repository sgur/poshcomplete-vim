if (($args.Count -gt 1) -and ($args[1] -ne $null)) {
    $code = (Get-Content $args[0]) -join "`n"
    $index = $args[1]

    $ret = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput([String] $code, [Int] $index)
    $completeWords = [System.Management.Automation.CommandCompletion]::CompleteInput($ret.Item1, $ret.Item2, $ret.Item3, $null).CompletionMatches | Select-Object CompletionText, ResultType, ToolTip

    foreach ($completeWord in $completeWords)
    {
        Write-Host "{" `
            ("`"word`": `"{0}`"," -f ($completeWord.CompletionText -replace "\\","\\")) `
            ("`"kind`": `"[{0}]`"," -f $completeWord.ResultType) `
            ("`"menu`": `"{0}`"" -f ((($completeWord.ToolTip -replace "\\","\\") -replace "^`r`n","") -replace "`r`n"," ")) `
            "}"
    }
}

# vim:set et ts=4 sts=0 sw=4 ff=dos:

