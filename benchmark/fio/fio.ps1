# Get folder to test in
$folder = Read-Host -Prompt 'Which folder to benchmark in? (Default is UserProfile\Documents)'
if ([string]::IsNullOrWhiteSpace($folder))
{
    $folder = $env:USERPROFILE + '\Documents'
}

# Escape colon
$escaped_folder = $folder.Replace(":", "\:")

# Prepare for results file
$filename = Read-Host -Prompt 'What to name the results file'
$host_filename = $env:COMPUTERNAME + '\' + $filename

if (-not (Test-Path -LiteralPath $env:COMPUTERNAME)) 
{
    New-Item -Path $DirectoryToCreate -ItemType Directory
}

# Run Benchmark
fio .\benchmark.fio --directory=$escaped_folder --output-format=json --eta=always --output=$host_filename

# 
$results_json = Get-Content $host_filename | ConvertFrom-Json
$cell = @()
foreach($job in $results_json.jobs)
{
    if($job.'job options'.bs -eq '1024k' -and $job.'job options'.rw -eq 'read')
    {
        if($job.'job options'.iodepth -eq 8)
            {
            $cell += $job.read.bw/1000
            }
        if($job.'job options'.iodepth -eq 1)
            {
            $cell += $job.read.bw/1000
            }
        'Sequential Read (QD' + $job.'job options'.iodepth + '): ' + $job.read.bw/1000 + ' MiB/s'
    }
    if($job.'job options'.bs -eq '1024k' -and $job.'job options'.rw -eq 'write')
    {
        if($job.'job options'.iodepth -eq 8)
            {
            $cell += $job.write.bw/1000
            }
        if($job.'job options'.iodepth -eq 1)
            {
            $cell += $job.write.bw/1000
            }
        'Sequential Write (QD' + $job.'job options'.iodepth + '): ' + $job.write.bw/1000 + ' MiB/s'
    }
    if($job.'job options'.bs -eq '4k' -and $job.'job options'.rw -eq 'randread')
    {
        $cell += $job.read.bw/1000
        $cell += $job.read.iops
        $cell += $job.read.lat_ns.mean/1000
        'Random Read (4k): ' + $job.read.bw/1000 + ' MiB/s; ' + $job.read.iops + ' iops; ' + $job.read.lat_ns.mean/1000 + ' μs'
    }
    if($job.'job options'.bs -eq '4k' -and $job.'job options'.rw -eq 'randwrite')
    {
        $cell += $job.write.bw/1000
        $cell += $job.write.iops
        $cell += $job.write.lat_ns.mean/1000
        'Random Write (4k): ' + $job.write.bw/1000 + ' MiB/s; ' + $job.write.iops + ' iops; ' + $job.write.lat_ns.mean/1000 + ' μs'
    }
}
$tab_output = (-split $cell) -join "`t"
Set-Clipboard -Value $tab_output
Write-Output ("Values copied to clipboard for Excel, and saved in " + $host_filename + ".txt")
Set-Content -Path ($host_filename + ".txt") -Value $tab_output
