@{
    RootModule        = 'PleasePwsh.psm1'
    ModuleVersion     = '0.1'
    GUID              = 'd430aac3-8363-4321-a610-ff33a366a50b'
    Author            = 'Tobias Kasper'
    CompanyName       = 'TNG Technology Consulting GmbH'
    Copyright         = '2023 TNG Technology Consulting GmbH. All rights reserved.'
    Description       = 'Translates a prompt into a PowerShell command using OpenAI GPT.'
    PrivateData       = @{
        PSData = @{
            Tags       = @('PowerShell', 'GPT', 'OpenAI', 'ai', 'translate', 'bash', 'windows')
            ProjectUri = 'https://github.com/TNG/please-pwsh'
        }
    }
    PowerShellVersion = '7.0'
    FunctionsToExport = 'Please'
    AliasesToExport   = '*'
}
