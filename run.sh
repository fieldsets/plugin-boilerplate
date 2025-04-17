#!/usr/bin/env pwsh

<###
 # Run Phase Scipt
 # This plugin will be at the end of every startup with the priority defined in plugin.json
 ###>

$plugin_path = (Get-Location).Path

Write-Output "## Fieldsets Plugin Boilerplate Run Phase ##"
Write-Output "$($plugin_path)"

$plugin = Get-Content -Raw -Path "$($plugin_path)/plugin.json" | ConvertFrom-Json -AsHashtable

<###
 # Add custom code
 ###>

Exit