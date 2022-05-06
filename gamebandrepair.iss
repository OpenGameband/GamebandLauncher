; Gameband updater installer thingy

#define MyAppName "Gameband Repair/Update"
#define MyAppVersion "1.0"
#define MyAppPublisher "Henry Asbridge <Zaprit>"
#define MyAppURL "https://gameband.valtek.uk"
#define MyAppExeName "Gameband.exe"

[Setup]
AppId={{64849B10-FFC2-48E6-AC32-09571DF0A910}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
CreateAppDir=no
Uninstallable=no
InfoBeforeFile=D:\Documents\Gameband Pre Installation.rtf
PrivilegesRequired=admin
;OutputDir=C:\Users\Henry Asbridge\Desktop
OutputBaseFilename=gamebandrepair
Compression=lzma
SolidCompression=yes
WizardStyle=modern
;DefaultDirName={code:GetGamebandDrive}


[Files]
Source: "{tmp}\gameband_sw.zip"; DestDir: "{app}"; Flags: external
Source: "{tmp}\java.zip"; DestDir: "{app}"; Flags: external

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Code]
var
  DownloadPage: TDownloadWizardPage;

function GetGamebandDrive(Value: string): String;
var
  ResultCode: Integer;
  FileString: AnsiString;
begin

  Log('"(Get-Partition -DiskNumber (Get-Disk -FriendlyName "SMI USB DISK").Number).DriveLetter | Out-File -encoding ASCII '+ ExpandConstant('{tmp}') + '\drive.txt'+ '"')
  if Exec('C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe', '-ExecutionPolicy Bypass -Command "(Get-Partition -DiskNumber (Get-Disk -FriendlyName \"SMI USB DISK\").Number).DriveLetter | Out-File -encoding ASCII \"'+ExpandConstant('{tmp}\drive.txt')+'\""', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
  begin
    LoadStringFromFile(String(ExpandConstant('{tmp}'))+'\drive.txt',FileString);
    
    Result:=String(FileString)+':\';
  end;
end;

function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
  if Progress = ProgressMax then
    Log(Format('Successfully downloaded file to {tmp}: %s', [FileName]));
  Result := True;
end;

procedure InitializeWizard;
begin
  DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = wpReady then begin
    DownloadPage.Clear;
    DownloadPage.Add('https://files.gameband.valtek.uk/gameband_sw.zip', 'gameband_sw.zip', '62c1e38cf78a218ad0bc4f1c165666a7c34627d4e910c8e5d76a888f81aa6ea5');
    DownloadPage.Add('https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jre_x86-32_windows_hotspot_8u322b06.zip', 'java.zip', '');
    DownloadPage.Show;
    try
      try
        DownloadPage.Download;
        Result := True;
      except
        SuppressibleMsgBox(AddPeriod(GetExceptionMessage), mbCriticalError, MB_OK, IDOK);
        Result := False;
      end;
    finally
      DownloadPage.Hide;
    end;
  end else
    Result := True;
end;