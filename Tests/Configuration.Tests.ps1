BeforeAll {
    Remove-Module -Name PleasePwsh -ErrorAction SilentlyContinue
    Import-Module $PSScriptRoot/../PleasePwsh/PleasePwsh.psm1

    $env:OPENAI_API_KEY = "not-set"

    InModuleScope PleasePwsh {
        Mock Invoke-RestMethod { return @{ choices = @(@{ message = @{ content = "Hello, World!" } }) } }
        Mock Show-Menu { }
        Mock Invoke-Action { }
    }
}

AfterAll {
    $env:OPENAI_API_KEY = $null
    $env:OPENAI_API_BASE = $null
    $env:OPENAI_API_VERSION = $null
    $env:PLEASE_OPENAI_API_BASE = $null
    $env:PLEASE_OPENAI_API_VERSION = $null
    $env:PLEASE_OPENAI_CHAT_MODEL = $null
}

Describe 'OpenAI Configuration' {
    It 'Given no configuration, defaults are used' {
        InModuleScope PleasePwsh {
            Please "say hello"

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                return ($Body | ConvertFrom-Json).model -eq 'gpt-3.5-turbo' -and
                        $Uri -eq 'https://api.openai.com/v1/chat/completions' -and
                        $Method -eq 'Post' -and
                        $Headers["Content-Type"] -eq 'application/json'
            }
        }
    }

    It 'Given configuration from openai compatible environment variables are used' {
        InModuleScope PleasePwsh {
            $env:OPENAI_API_BASE = "openai-api-base"
            $env:OPENAI_API_VERSION = "openai-api-version"

            Please "say hello"

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                return ($Body | ConvertFrom-Json).model -eq 'gpt-3.5-turbo' -and
                        $Uri -eq 'openai-api-base/openai-api-version/chat/completions' -and
                        $Method -eq 'Post' -and
                        $Headers["Content-Type"] -eq 'application/json'
            }
        }
    }

    It 'Given configuration from please specific environment variables are preferred' {
        InModuleScope PleasePwsh {
            $env:OPENAI_API_BASE = "openai-api-base"
            $env:OPENAI_API_VERSION = "openai-api-version"

            $env:PLEASE_OPENAI_API_BASE = "please-api-base"
            $env:PLEASE_OPENAI_API_VERSION = "please-api-version"

            $env:PLEASE_OPENAI_CHAT_MODEL = "please-chat-model"

            Mock Invoke-RestMethod { return @{ choices = @(@{ message = @{ content = "Hello, World!" } }) } }
            Mock Show-Menu { }
            Mock Invoke-Action { }

            Please "say hello"

            Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter {
                return ($Body | ConvertFrom-Json).model -eq 'please-chat-model' -and
                        $Uri -eq 'please-api-base/please-api-version/chat/completions' -and
                        $Method -eq 'Post' -and
                        $Headers["Content-Type"] -eq 'application/json'
            }
        }
    }
}