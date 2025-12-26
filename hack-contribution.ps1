$file_name = "contribution.txt"
$date_file = "date.txt"

# Read all dates from date.txt
$dates = Get-Content $date_file

foreach ($date in $dates) {
    if ([string]::IsNullOrWhiteSpace($date)) { continue }

    $commit_date = "$date" + "T12:00:00"

    Write-Host "Processing commit for date: $commit_date"

    # Append a line to the file
    Add-Content -Path $file_name -Value "Commit on $commit_date"

    # Stage the file
    git add $file_name

    # Commit with specific date
    git commit --date="$commit_date" -m "Commit on $commit_date"

    # Push to GitHub
    git push

    # If push succeeded, remove the date from date.txt
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Success! Removing $date from $date_file"
        (Get-Content $date_file) | Where-Object { $_ -ne $date } | Set-Content $date_file
    } else {
        Write-Host "Push failed. Keeping $date for retry."
        break
    }
}

Write-Host "Script finished."
