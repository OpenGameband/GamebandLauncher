$GB_files_URL = "https://files.valtek.uk/Gameband-Files/gameband_sw.zip"
$GB_launcher_URL
$JAVA_DOWNLOAD_URL = "https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jre_x86-32_windows_hotspot_8u322b06.zip"

$files_to_hide = @(".lib","._.VolumeIcon.icns", "Gameband.app", "Gameband_linux.bat", ".java")
Add-Type -AssemblyName PresentationCore,PresentationFramework
Add-Type -AssemblyName System.IO;
if (-Not (Test-Path -Path "$PWD\.lib")) {
    [System.Windows.MessageBox]::Show('Gameband files not found, downloading', 'Gameband Error')
    Invoke-WebRequest -Uri "$GB_files_URL" -OutFile "$PWD\gameband_sw.zip"
    Expand-Archive "$PWD\gameband_sw.zip" -DestinationPath $PWD
    Remove-Item "$PWD\gameband_sw.zip"
    Remove-Item -LiteralPath "$PWD\Gameband.app" -Force -Recurse
    Remove-Item -LiteralPath "$PWD\Gameband.exe" -Force

}

if (-Not (Test-Path -Path "$PWD\.javawin")) {
    Invoke-WebRequest -Uri "$JAVA_DOWNLOAD_URL" -OutFile "$PWD\java.zip"
    Expand-Archive "$PWD\java.zip" -DestinationPath "$PWD"
    Remove-Item "$PWD\java.zip"
    Move-Item "$PWD\jdk8u322-b06-jre" "$PWD\.javawin"

}
foreach ($file in $files_to_hide) {
    (get-item $file).Attributes += 'Hidden'
}
Pause