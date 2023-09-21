# Define the folder to search for duplicates (in this case, the C drive)
$folderPath = "C:\tmp\pwsh scripts"

# Create an empty dictionary to store file hashes and their paths
$hashes = @{}

# Function to calculate the SHA-256 hash of a file
function Get-FileHashSHA256($file) {
    $hasher = [System.Security.Cryptography.SHA256]::Create()
    $stream = [System.IO.File]::OpenRead($file)
    $hashBytes = $hasher.ComputeHash($stream)
    $stream.Close()
    return [BitConverter]::ToString($hashBytes) -replace '-'
}

# Define the output file path
$outputFilePath = "C:\tmp\DuplicateFiles.txt"


# Recursive function to scan and identify duplicate files
function Find-DuplicateFiles($folder) {
    $files = Get-ChildItem -File -Path $folder

    foreach ($file in $files) {
        $hash = Get-FileHashSHA256 $file.FullName

        if ($hashes.ContainsKey($hash)) {
            # Duplicate found, print the duplicate file paths
            Write-Host "Duplicate File:"
            Write-Host "  Original: $($hashes[$hash])"
            Write-Host "  Duplicate: $($file.FullName)"

            # Write the duplicate file information to the text file
            "Duplicate File:" | Out-File -Append -FilePath $outputFilePath
            "  Original: $($hashes[$hash])" | Out-File -Append -FilePath $outputFilePath
            "  Duplicate: $($file.FullName)" | Out-File -Append -FilePath $outputFilePath

            # Increment the duplicate file count
            $duplicateFileCount++

        } else {
            # Add the hash and file path to the dictionary
            $hashes[$hash] = $file.FullName
        }
    }

    $folders = Get-ChildItem -Directory -Path $folder
    foreach ($subfolder in $folders) {
        Find-DuplicateFiles $subfolder.FullName
    }



}

# Start the duplicate file search
Find-DuplicateFiles $folderPath

   



