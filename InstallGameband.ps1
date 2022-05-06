$GB_files_URL = "https://files.valtek.uk/Gameband-Files/gameband_sw.zip"
$GB_launcher_URL = "https://files.valtek.uk/Gameband-Files/GamebandLauncher.exe"
$JAVA_DOWNLOAD_URL = "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jre_x86-32_windows_hotspot_8u322b06.zip"

$GB_EXE_hash = "E2D62CEF222A6B35FC71EB87972752D324E51C6C3C451069FD8473C50728AAED"

$Linux_launch_script = @"
#!/bin/bash
if which java
then

else
    ./.javalin/
fi


"@

$files_to_hide = @(".lib","._.VolumeIcon.icns", "Gameband.app", "Gameband_linux.bat", ".javawin")
Add-Type -AssemblyName PresentationCore,PresentationFramework
Add-Type -AssemblyName System.IO;
if (-Not (Test-Path -Path "$PWD\.lib")) {
    [System.Windows.MessageBox]::Show('Gameband files not found, downloading', 'Gameband Error')
    Invoke-WebRequest -Uri "$GB_files_URL" -OutFile "$PWD\gameband_sw.zip"
    Expand-Archive "$PWD\gameband_sw.zip" -DestinationPath $PWD
    Remove-Item "$PWD\gameband_sw.zip"
    Remove-Item -LiteralPath "$PWD\Gameband.app" -Force -Recurse
}

if ((Get-FileHash "$PWD\Gameband.exe").Hash -eq $GB_EXE_hash) {
     Remove-Item -LiteralPath "$PWD\Gameband.exe" -Force
     Invoke-WebRequest -Uri "$GB_launcher_URL" -OutFile "$PWD\Gameband.exe"
}

if (-Not (Test-Path -Path "$PWD\.javawin")) {
    Invoke-WebRequest -Uri "$JAVA_DOWNLOAD_URL" -OutFile "$PWD\java.zip"
    Expand-Archive "$PWD\java.zip" -DestinationPath "$PWD"
    Remove-Item "$PWD\java.zip"
    Move-Item "$PWD\jdk8u322-b06-jre" "$PWD\.javawin"

}
foreach ($file in $files_to_hide) {
    $fileobj = Get-Item $file -Force
    $fileobj.Attributes += 'Hidden'
}
Pause