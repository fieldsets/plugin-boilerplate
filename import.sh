#!/usr/bin/env pwsh

<###
 # Import Phase Scipt
 # This plugin will be run on every startup with the priority defined in plugin.json
 # To prevent data from being re-imported after the inital startup create a lockfile.
 ###>


$plugin_path = (Get-Location).Path

Write-Output "## Fieldsets Plugin Boilerplate Import Phase ##"
Write-Output "$($plugin_path)"

$plugin = Get-Content -Raw -Path "$($plugin_path)/plugin.json" | ConvertFrom-Json -AsHashtable

Param(
    [Parameter(Mandatory=$false)][Switch]$preimport
)

$plugin_schema = 'fieldsets'
$plugin_db = 'fieldsets'
if ($plugin.ContainsKey('schema') -and ($null -ne $plugin['schema'])) {
    $plugin_schema = $plugin['schema']
}
if ($plugin.ContainsKey('db') -and ($null -ne $plugin['db'])) {
    $plugin_db = $plugin['db']
}

if ($preimport) {
    # Load schemas before import and add lockfile
    $schemas = Get-ChildItem "$($plugin_path)/config/schemas/*.json"

    foreach ($schema in $schemas) {
        $schema_object = Get-Content -Raw -Path "$($schema)" | ConvertFrom-Json -NoEnumerate -AsHashtable
        if ($null -ne $schema_object) {
            $schemaJSON = ConvertTo-Json -Compress -InputObject $schemaObject -Depth 10
            $split_name = ($schema.BaseName).split("-",2)
            $priority = $split_name[0]
            $token = $split_name[1]

            & "/usr/local/fieldsets/bin/import-json.sh" -token "$($token)" -source "$($plugin_schema)" -json "$($schemaJSON)" -type 'schema' -priority $($priority) -database "$($plugin_db)"
        }
    }

}else {
    # Load data at end of import phase
    $data_files = Get-ChildItem "$($plugin_path)/data/*.json"
    foreach ($data_file in $data_files) {
        $data_object = Get-Content -Raw -Path "$($data_file)" | ConvertFrom-Json -NoEnumerate -AsHashtable
        if ($null -ne $data_object) {
            $dataJSON = ConvertTo-Json -Compress -InputObject $data_object -Depth 10
            $split_name = ($data_file.BaseName).split("-",2)
            $priority = $split_name[0]
            $token = $split_name[1]

            & "/usr/local/fieldsets/bin/import-json.sh" -token "$($token)" -source "$($plugin_schema)" -json "$($dataJSON)" -type 'schema' -priority $($priority) -database "$($plugin_db)"
        }
    }
}

Exit
