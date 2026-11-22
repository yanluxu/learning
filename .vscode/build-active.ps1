param([Parameter(Mandatory=$true)][string]$Source,[string]$OutputFile)
$ErrorActionPreference = 'Stop'
$sourceFile = Get-Item -LiteralPath $Source
$extension = $sourceFile.Extension
if ($extension -ceq '.c') {
    $compiler = 'D:\ucrt64\bin\gcc.exe'; $standard = '-std=c17'
} elseif ($extension.ToLowerInvariant() -in @('.cpp','.cc','.cxx') -or $extension -ceq '.C') {
    $compiler = 'D:\ucrt64\bin\g++.exe'; $standard = '-std=c++17'
} else { throw 'Open a C or C++ source file before building.' }
if ($sourceFile.Length -eq 0) { throw 'The source file is empty. Write and save a main function first.' }
if (!$OutputFile) { $OutputFile = [IO.Path]::ChangeExtension($sourceFile.FullName,'.exe') }
$env:Path = 'D:\ucrt64\bin;' + $env:Path
Write-Host ("Compiler: " + $compiler)
& $compiler $standard -Wall -Wextra -g -O0 $sourceFile.FullName -o $OutputFile
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host ("Built: " + $OutputFile)
