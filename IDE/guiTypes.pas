unit guiTypes;
{ Вспомогательные типы для Quide }

interface

uses Classes;

type
 TGeneratorInfo = class(TCollectionItem)
 private
  f_Caption: String;
  f_Generator: string;
 public
  function Generate(aSourceFile: String): Boolean;
  property Caption: String read f_Caption write f_Caption;
  property Generator: string read f_Generator write f_Generator;
 end;

 TGeneratorCollection = class(TCollection)
 end;

function WinExec32AndWait(const Cmd: string; const CmdShow: Integer): Cardinal;

implementation
Uses
 Windows;

function TGeneratorInfo.Generate(aSourceFile: String): Boolean;
begin
 Result:= False;
end;

function WinExec32AndWait(const Cmd: string; const CmdShow: Integer): Cardinal;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  Result := Cardinal($FFFFFFFF);
  FillChar(StartupInfo, SizeOf(TStartupInfo), #0);
  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := CmdShow;
  if CreateProcess(nil, PChar(Cmd), nil, nil, False, NORMAL_PRIORITY_CLASS,
    nil, nil, StartupInfo, ProcessInfo) then
  begin
    WaitForInputIdle(ProcessInfo.hProcess, INFINITE);
    if WaitForSingleObject(ProcessInfo.hProcess, INFINITE) = WAIT_OBJECT_0 then
    begin
      if not GetExitCodeProcess(ProcessInfo.hProcess, Result) then
        Result := Cardinal($FFFFFFFF);
    end;
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;
end;
end.
