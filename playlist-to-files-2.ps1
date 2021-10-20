param([string]$path="D:\Music\Playlists\new", [string]$destination="$path\files")

try {
    Add-Type -AssemblyName System.Web
    if (Test-Path $path) {
        $playlists = @(Get-ChildItem -Path $path -Filter "*.m3u8")
        if ($playlists.length -eq 0) {
            Write-Host "No playlists found"
        }

        foreach ($playlist in $playlists) {
            $endIndex = $playlist.Name.LastIndexOf(".m3u8")
            $name = $playlist.Name.Substring(0, $endIndex)
             
            $newPath = "$destination\$name"
            if (!(Test-Path $newPath)) {
                New-Item -Path "$destination" -Name $name -ItemType "directory"            
            }

            $content = $playlist | Get-Content -Encoding utf8
            $pattern = "^file:\/\/\/(?<location>[A-Z]:\/.+)"
    
            $notEmpty = $false
            $missingFiles = 0
            foreach($line in $content) {
                $requests = $line -match $pattern
                if ($requests) {
                    $notEmpty = $true
                    $file = [System.Web.HTTPUtility]::UrlDecode($Matches.location)
                    $file
                    $ext = $file.Substring($file.LastIndexOf(".")+1, $file.length-$file.LastIndexOf(".")-1)
                    $ext
   
                    if (!($ext -eq "mp3")) {
                        $folder = $file.Substring(0, $file.LastIndexOf("/"))
                        $folder
                        $fileName = $file.Substring($file.LastIndexOf("/"), $file.LastIndexOf(".")-$file.LastIndexOf("/"))
                        $fileName
                        if (Test-Path "$folder\mp3\$fileName.mp3") {
                            $file = "$folder\mp3\$fileName.mp3"
                        }
                    }
                    if (Test-Path $file) {
                        Copy-Item -Path $file -Destination $newPath
                    } else {
                        $missingFiles++
                    }
                }
            }
            if (!($notEmpty)) {
                Write-Host "Playlist $name : Empty playlist"
            } else {
                if ($missingFiles -eq 0) {
                    Write-Host "Playlist $name : Success"
                    # previous files will be overwritten
                } else {
                    Write-Host "Playlist $name : $missingFiles files cannot be found"
                }
            }
        }
    } else {
        Write-Host "No such path found"
    }
}
catch {
  Write-Host "An error occurred:"
  Write-Host $_
}