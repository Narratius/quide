//=========================================================================
// GameVision (tm) SDK, Tools and Tutorials
// Copyright (c) 1994-2003 Jarrod Davis Software
// All Rights Reserved.
//-------------------------------------------------------------------------
// You are hereby granted the right to use GameVision and it's
// tools to produce your own applications without paying us any
// money, subject to the following restrictions:
//
// 1. You may not reverse engineer, or claim GameVision or it's tools
//    as your own work.
//
// 2. We require that you acknowledge us in your application's credits
//    and/or documentation. An acceptable statement can be such as:
//
//    Created with the GameVision SDK developed by
//      Jarrod Davis Software.
//      http://www.jarroddavis.com
//
// 3. You may not create a library that uses this library as a main part
//    of the program and sell that library.
//
// 4. You may redistribute GameVision, provided that the archive remain
//    intact. All files of the original distribution must be present!
//
// 5. Media used in the demos, tutorials and tools are copyright
//    Jarrod Davis Software and may not be used for any purpose.
//
// 6. This notice may not be removed or altered from any distribution.
//
// This software is provided 'as-is', without any express or implied
// warranty. In no event will the authors be held liable for any damages
// arising from the use of this software.
//
// If you have further legal questions, please mail legal@jarroddavis.com
//-------------------------------------------------------------------------
// Website: http://www.jarroddavis.com          - Jarrod Davis Software
//          http://www.gamevisionsdk.com        - GameVision SDK
// Email  : support@jarroddavis.com             - Support
//          jarroddavis@jarroddavis.com         - General
//=========================================================================

program gvdirclean;

{$APPTYPE CONSOLE}

uses
  GVShareMem, GVDLL,
  SysUtils, Classes;

var
  ExtList : TStringList;
  FileList: TStringList;
  I,Cnt   : Integer;
  S       : string;
begin
  GV_Init;

  ExtList  := TStringList.Create;
  FileList := TStringList.Create;

  ExtList.Add('*.~*');
  ExtList.Add('*.exe*');
  ExtList.Add('*.log*');
  ExtList.Add('*.dcu*');
  ExtList.Add('*.cfg*');
  ExtList.Add('*.dof*');
  ExtList.Add('*.ini*');
  ExtList.Add('*.rsm*');
  ExtList.Add('*.rez*');
  ExtList.Add('*.dsk*');

  WriteLn('GVDirClean - Directory Cleaning Utility 1.0');
  WriteLn('Copyright (c) 2003 Jarrod Davis Software');
  WriteLn('All Rights Reserved.');
  WriteLn('[ www.jarroddavis.com | support@jarroddavis.com ]');
  WriteLn;

  WriteLn('Scanning directory...');
  WriteLn;

  // find all extensions
  for i := 0 to ExtList.Count-1 do
  begin
    GV_Dir_GetAllFiles('.', ExtList[I], FileList, nil);
  end;

  // remove all extensions
  Cnt := 0;
  for i := 0 to FileList.Count-1 do
  begin
    if FileExists(FileList[I]) then
    begin
      S := LowerCase(ExtractFileName(FileList[I]));
      if (S <> 'gvdirclean.exe') and (S <> 'gvdirclean.log') then
      begin
        WriteLn('Removing ' + FileList[I]);
        DeleteFile(FileList[I]);
        Inc(Cnt);
      end;
    end;
  end;

  S := Format('Removed %d file(s)', [Cnt]);

  FileList.Free;
  ExtList.Free;

  WriteLn;
  WriteLn(S);
  WriteLn;
  Write('Press ENTER to exit...');
  ReadLn;

  GV_Done;
end.
