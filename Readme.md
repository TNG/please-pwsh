# Please CLI for PowerShell Core

An AI helper script to create PowerShell commands. It is a copy of [Please CLI](https://github.com/TNG/please-cli/). 

The initial approach to `ChatGPT please convert the bash script to pwsh` did not work. So its a rewrite that still contains trace amounts of AI.

## Usage

Same as [Please CLI](https://github.com/TNG/please-cli/), it translates natural language into PowerShell commands with the help of GPT:

```
Please "Get all files in current directory that are larger than 1 MB"

🔣 Command:
   Get-ChildItem -Path . -File | Where-Object { $_.Length -gt 1MB }
❓ What should I do?
[A] Abort  [C] Copy  [I] Invoke  [?] Help (default is "A"):
```

It can also explain commands:

```
Please -e "Get-ChildItem -Path . -File | Where-Object { $_.Length -gt 1MB }"
☝ The command lists all the files in the current directory with a file size greater than 1MB.

🔣 Command:
   Get-ChildItem -Path . -File | Where-Object { .Length -gt 1MB }
❓ What should I do?
[A] Abort  [C] Copy  [I] Invoke  [?] Help (default is "A"):
```

## Help
For help and parameter explanation run `Get-Help Please`.

## Prerequisites

You need an [OpenAI Api Key](https://platform.openai.com/account/api-keys).

## Installation

For now copy the module `PleasePwsh` in one of your module folders and set the OpenAI Api Key as environment variable.
- Find module folders with `$ENV:PSModulePath -Split ';'`
- Set environment variable in PowerShell profile
  - Open profile `Code $PROFILE`
  - Set `$ENV:OPENAI_API_KEY = <YOUR_API_KEY>`
