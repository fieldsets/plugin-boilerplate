#!/usr/bin/env pwsh

<###
 # Config Phase Scipt
 # This plugin will be run at the beginning every startup with the priority defined in plugin.json
 ###>

$plugin_path = (Get-Location).Path

Write-Output "## Fieldsets Plugin Boilerplate Config Phase ##"
Write-Output "$($plugin_path)"

$plugin = Get-Content -Raw -Path "$($plugin_path)/plugin.json" | ConvertFrom-Json -AsHashtable

# You can utilize a custom config.json file
if (Test-Path -Path "$($plugin_path)/config.json") {
    $config = Get-Content -Raw -Path "$($plugin_path)/config.json" | ConvertFrom-Json -AsHashtable
    <###
     # Add custom code
     ###>
}

Exit
