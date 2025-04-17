#!/usr/bin/env pwsh

<###
 # Init Phase Scipt
 # This plugin will be run on the first startup with the priority defined in plugin.json
 ###>

$plugin_path = (Get-Location).Path

Write-Output "## Fieldsets Plugin Boilerplate Init Phase ##"
Write-Output "$($plugin_path)"

$plugin = Get-Content -Raw -Path "$($plugin_path)/plugin.json" | ConvertFrom-Json -AsHashtable

$plugin_schema = 'fieldsets'
$plugin_db = 'fieldsets'
$plugin_token = $null
if ($plugin.ContainsKey('schema') -and ($null -ne $plugin['schema'])) {
    $plugin_schema = $plugin['schema']
}
if ($plugin.ContainsKey('db') -and ($null -ne $plugin['db'])) {
    $plugin_db = $plugin['db']
}

if ($plugin.ContainsKey('token') -and ($null -ne $plugin['token'])) {
    $plugin_token = $plugin['token']
}

<###
 # Add custom code
 # The below code makes sure that a log file for this plugin exists.
 ###>
$log_path = "/usr/local/fieldsets/data/logs/plugins"
# Create our path if it does not exist
if (!(Test-Path -Path "$($log_path)/$($plugin_token)/")) {
    New-Item -Path "$($log_path)" -Name "$($plugin_token)" -ItemType Directory | Out-Null
}
if (!(Test-Path -Path "$($log_path)/$($plugin_token)/$($plugin_token).log")) {
    New-Item -Path "$($log_path)/$($plugin_token)" -Name "$($plugin_token).log" -ItemType File | Out-Null
}

Exit
