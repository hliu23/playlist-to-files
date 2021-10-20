# Playlist to Files
This powershell script will copy the mp3 files used in local m3u8 playlists to a new folder.

## To Use
Run the script in powershell  

Params: 
- -path &lt;String> : Pass in the directory containing the m3u8 files (*required)
- -destination &lt;String> : Pass in the target directory (defaults to the subdirectory "files" within the directory containing the m3u8 files)


> **_NOTE:_**  Newly copied files will overwrite existing files of the same name in the directory  

### Version 2 (playlist-to-files-2.ps1)
Version 2 adds: 
- a default path 
- an extra function: if a file in the playlist is not mp3, the script will attempt to find a mp3 file of the same name in a folder named "mp3" in the same directory
