# Please CLI for PowerShell Core

An AI helper script to create PowerShell commands. It is a copy of [Please CLI](https://github.com/TNG/please-cli/).

The initial approach to `ChatGPT please convert the bash script to pwsh` did not work. So its a rewrite that still contains trace amounts of AI.

## Usage

Same as [Please CLI](https://github.com/TNG/please-cli/), it translates natural language into PowerShell commands with the help of GPT:

```
Please "Get all files in the current directory that are larger than 1 MB"

🔣 Command:
   Get-ChildItem -Path . -File | Where-Object { $_.Length -gt 1MB }
❓ What should I do?
[A] Abort  [C] Copy  [I] Invoke  [?] Help (default is "A"):
```

It can also explain commands:

```
Please -explain "Get-ChildItem -Path . -File | Where-Object { $_.Length -gt 1MB }"
☝ The command lists all the files in the current directory with a file size greater than 1MB.

🔣 Command:
   Get-ChildItem -Path . -File | Where-Object { .Length -gt 1MB }
❓ What should I do?
[A] Abort  [C] Copy  [I] Invoke  [?] Help (default is "A"):
```

## Help
For help and parameter explanation run `Get-Help Please`.

## Prerequisites

You need an [OpenAI API key](https://platform.openai.com/account/api-keys) and access to GPT 3.5 Turbo.

## Installation

From the [PowerShell Gallery](https://www.powershellgallery.com/packages/PleasePwsh) with
```
Install-Module -Name PleasePwsh
```

Set the OpenAI API key as environment variable.
- Open PowerShell profile: `Code $PROFILE`
- Add a line with your API key: `$ENV:OPENAI_API_KEY = <YOUR_API_KEY>`


## Configuration

You can use the following OpenAI compatible environment variables:
* `OPENAI_API_KEY` - Your OpenAI API key
* `OPENAI_API_BASE` - The base URL for the OpenAI API
* `OPENAI_API_VERSION` - The version of the OpenAI API

You can use the more specific environment variables if you do not want to change OpenAI settings globally:
* `PLEASE_OPENAI_API_KEY` - Your OpenAI API key
* `PLEASE_OPENAI_API_BASE` - The base URL for the OpenAI API
* `PLEASE_OPENAI_API_VERSION` - The version of the OpenAI API
* `PLEASE_OPENAI_CHAT_MODEL` - The chat model to use
