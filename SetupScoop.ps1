# Based upon instructions here: 
# https://github.com/lukesampson/scoop/wiki/Quick-Start
set-executionpolicy remotesigned -scope currentuser
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# Get flag for work/personal
$setting = Read-Host -Prompt "Restrict to only work manifests? [Y/N]"
$all_apps = $setting -ne "Y"

# Add basic apps for scoop (Prerequisite for extras)
scoop install 7zip
scoop install git
scoop install hub
scoop install sudo

# Add extras bucket
scoop bucket add extras
scoop bucket add nerd-fonts
if ($all_apps) {
    scoop bucket add java
}

# Main bucket
## Install other basic system tools and command line
scoop install windows-terminal vim which
scoop install dark # To support WiX Toolset

## Install languages
scoop install R
scoop install python
scoop install ruby #Support jekyll and GitHub pages

# Java Bucket
if ($all_apps) {
    scoop install adopt8-hotspot-jre
}

# NerdFonts bucket
## Install fonts
scoop install firacode

# Extras Bucket
## Applications
scoop install googlechrome
if ($all_apps){
    scoop install pdfsam sumatrapdf
}
## Communication
scoop install slack
if ($all_apps) {
    scoop install discord 
}

## Development
scoop install anaconda3
scoop install vscode rstudio notepadplusplus
scoop install dbeaver azuredatastudio

## Multimedia
scoop install audacity gimp handbrake ffmpeg inkscape
if ($all_apps) {
    scoop install musicbee vlc youtube-dl picard
}

## System Utilities
### Hardware Stress
if ($all_apps) {
    scoop install prime95 furmark
}

### Hardware benchmark
if ($all_apps) {
    scoop install geekbench
}

### Hardware management
if ($all_apps) {
    scoop install crystaldiskinfo hwmonitor cpu-z gpu-z processhacker
}

## File Utilities
scoop install dupeguru bulk-rename-utility windirstat hashcheck everything

## Network Utilities
scoop install speedtest-cli ipscan tightvnc
