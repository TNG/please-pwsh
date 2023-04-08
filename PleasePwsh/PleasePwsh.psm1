using namespace System.Management.Automation.Host

if ($PSVersionTable.PSEdition -ne 'Core' -or $PSVersionTable.PSVersion.Major -lt 7) {
    throw "This script requires PowerShell Core version 7 or higher."
}

Set-PSDebug -Strict
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

<#
.SYNOPSIS
Translates a prompt into a PowerShell command using OpenAI GPT.

.DESCRIPTION
The main function, 'Please', takes a PowerShell command as input and prompts the user with a list of actions to perform on that command: abort, copy, explain and invoke.

.PARAMETER Prompt
Specifies the prompt in natural language that gets translated into a PowerShell command.

.PARAMETER Explain
If this switch is provided, the script will return a brief explanation of the specified command.

.EXAMPLE
PS> Please "Get all files in current directory that are larger than 1 MB"

PS> Please -Explain "Get-ChildItem -Path 'C:\'"
#>
function Please {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$Prompt,
        [Alias("e")][switch]$Explain

    )

    Test-ApiKey

    if ($Explain) {
        $Explanation = Get-CommandExplanation $Prompt
        Write-Output "`u{261D} $Explanation"
        $Command = $Prompt
    }
    else {
        $Command = Get-PwshCommand $Prompt
        if ($Command.contains("I do not know")) {
            Write-Output $Command
            Return
        }
    }
    $Action = Show-Menu $Command
    Invoke-Action $Action
}

function Test-ApiKey {
    if ($null -eq $env:OPENAI_API_KEY) {
        Write-Output "`u{1F50E} Api key missing. See https://help.openai.com/en/articles/4936850-where-do-i-find-my-secret-api-key"
        $Key = Read-Host "Please provide the api key"

        if ([string]::IsNullOrWhiteSpace($Key)) {
            throw "`u{1F937} Api key still missing. Aborting."
        }
        $env:OPENAI_API_KEY = $Key
    }
}

function Get-PwshCommand([string]$Prompt) {
    $Role = "You translate the input given into PowerShell command. You may not use natural language, but only a PowerShell commands as answer. Do not use markdown. Do not quote the whole output. If you do not know the answer, answer only with 'I do not know'"

    $Payload = @{
        'model'    = "gpt-3.5-turbo"
        'messages' = @(
            @{ 'role' = 'system'; 'content' = $Role },
            @{ 'role' = 'user'; 'content' = $Prompt }
        )
    }

    Return Invoke-OpenAIRequest $Payload
}

function Show-Menu($Command) {
    $Title = "`u{1F523} Command:`n   $Command"

    $Question = "`u{2753} What should I do?"

    $OptionAbort = [ChoiceDescription]::new('&Abort')
    $OptionCopy = [ChoiceDescription]::new('&Copy')
    $OptionInvoke = [ChoiceDescription]::new('&Invoke')
    $Options = [ChoiceDescription[]]($OptionAbort, $OptionCopy, $OptionInvoke)

    Return $Host.UI.PromptForChoice($Title, $Question, $Options, 0)
}

function Invoke-Action ($Action) {
    switch ($Action) {
        0 {
            Write-Output "`u{274C} Aborting"
        }
        1 {
            Write-Output "`u{00A9} Copying to clipboard"
            Set-Clipboard -Value $Command
        }
        2 {
            Write-Output "`u{25B6} Invoking command"
            Invoke-Expression $Command
        }
        Default {
            Write-Output "Invalid action"
        }
    }
}

function Get-CommandExplanation([string]$Command) {
    $Prompt = "Explain what the command $Command does. Don't be too verbose."

    $Payload = @{
        'max_tokens' = 100
        'model'      = "gpt-3.5-turbo"
        'messages'   = @(
            @{ 'role' = 'user'; 'content' = $Prompt }
        )
    }

    Return Invoke-OpenAIRequest $Payload
}

function Invoke-OpenAIRequest($Payload) {
    $Uri = "https://api.openai.com/v1/chat/completions"

    $Headers = @{
        'Content-Type'  = 'application/json'
        'Authorization' = "Bearer $env:OPENAI_API_KEY"
    }

    try {
        $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body ($Payload | ConvertTo-Json)
    }
    catch {
        Write-Error "Received $($_.Exception.Response.ReasonPhrase): $($_.Exception.Response.Content | ConvertTo-Json)"
    }

    Return $Response.choices[0].message.content
}

Export-ModuleMember -Function "Please"
