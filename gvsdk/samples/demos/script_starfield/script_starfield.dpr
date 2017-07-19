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

{$R '..\..\samples.res'}

program gvsdk_demo;

uses
  GVShareMem,
  GVDLL, gvs_GVDLL,
  GVScript,
  SysUtils;

const
  MAX_STARS         = 250;

  SCREEN_WIDTH      = 640;
  SCREEN_HEIGHT     = 480;

  MIN_X             = -1000;
  MIN_Y             = -1000;
  MIN_Z             =    10;
  MAX_X             =  1000;
  MAX_Y             =  1000;
  MAX_Z             =  1000;

  VIEW_SCALE_RATIO  = SCREEN_WIDTH / SCREEN_HEIGHT;
  VIEW_SCALE        = 80;


type
  TGVPoint = record
    x,y,z: double;
  end;
  
  TStarItem = record
    x,y,z: single;
  end;
  PStarItem = ^TStarItem;

  TStar = class(TObject)
  public
    FItem: array of TStarItem;
    FCount: Integer;
    procedure TransformDrawPoint(aX, aY, aZ: Single);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init(aNum: Integer);
    procedure Update(aSpeed: Integer; aElapsedTime: Single);
    procedure Render;
  end;

var
  RezFile: Integer = -1;

{ === TStar ============================================================= }
procedure TStar.TransformDrawPoint(aX, aY, aZ: Single);
var
  x,y: double;
  sw,sh: double;
  ooz  : double;
  cv : integer;
  color: cardinal;
begin
  ooz := ((1.0 / aZ) * VIEW_SCALE);
  x := 320 - (ax * ooz)*VIEW_SCALE_RATIO;
  y := 240 + (ay * ooz)*VIEW_SCALE_RATIO;
  sw := (1.0 * ooz);
  if sw < 1 then sw := 1;
  sh := (1.0 * ooz);
  if sh < 1 then sh := 1;
  cv := round( 255.0-(((1.0 / MAX_Z) / (1.0 / az)) * 255.0) );
  color := GV_Color_Make(cv, cv, cv, cv);
  GV_RenderDevice_DrawRect(x, y, sw, sh, color, GV_RenderState_TransBlend);
end;

constructor TStar.Create;
begin
  inherited Create;
  FItem := nil;
  FCount := 0;
end;

destructor TStar.Destroy;
begin
  FItem := nil;
  inherited Destroy;
end;

procedure TStar.Init(aNum: Integer);
var
  i: integer;
begin
  FCount := aNum;
  SetLength(FItem, FCount);

  for I := 0 to FCount-1 do
  begin
    FItem[I].x := GV_RandomNum_RangeInteger(MIN_X, MAX_X);
    FItem[I].y := GV_RandomNum_RangeInteger(MIN_Y, MAX_Y);
    FItem[I].z := GV_RandomNum_RangeInteger(MIN_Z, MAX_Z);
  end;

end;

procedure TStar.Update(aSpeed: Integer; aElapsedTime: Single);
var
  I: Integer;
begin
  for I := 0 to FCount-1 do
  begin
    FItem[I].z := FItem[I].z - (aSpeed * aElapsedTime);
    if FItem[I].z < MIN_Z then
    begin
      FItem[I].x := GV_RandomNum_RangeInteger(MIN_X, MAX_X);
      FItem[I].y := GV_RandomNum_RangeInteger(MIN_Y, MAX_Y);
      FItem[I].z := MAX_Z - FItem[I].z;
      //Star[I].z := GV_RandomNum_RangeInteger(MIN_Z, MAX_Z);
    end;
  end;

end;

procedure TStar.Render;
var
  I: Integer;
begin
  for I := 0 to FCount-1 do
  begin
    with FItem[I] do
    begin
      TransformDrawPoint(x, y, z);
    end;
  end;
end;


procedure _MyStdRoutine(aProc: Pointer);
var
  v: variant;
  s: string;
begin
  s := GV_Script_GetStdRoutineParam(aProc, 0);
  GV_Dialog_ShowMessage('param1', s);

  v := GV_Script_GetStdRoutineParam(aProc, 1);
  s := GV_Script_GetObjectClassName(v);
  GV_Dialog_ShowMessage('param2', s);

  GV_Script_SetStdRoutineResult(aProc, 'this works');
end;

procedure test1_run;
begin
  GV_Script_CallFunction('test1_run', [], '');
end;

procedure demo2_run;
begin
  GV_Script_SetVariable('SCREEN_WINDOWED', False);
  GV_Script_CallFunction('demo_run', [], '');

  GV_Reset;

  GV_Script_SetVariable('SCREEN_WINDOWED', True);
  GV_Script_SetVariable('SCREEN_CAPTION', 'Now running in Windowed Mode');

  GV_Script_CallFunction('demo_run', [], '');
end;

procedure demo1_run;
begin
  GV_Script_SetVariable('SCREEN_WINDOWED', True);
  GV_Script_CallFunction('demo_run', [], '');
end;

procedure demo3_run;
begin
  //GV_Script_AddCodeFromFile('globals.pas', -1, '../../media/scripts/starfield/globals.pas');
  //GV_Script_AddCodeFromFile('main.pas', -1, '../../media/scripts/starfield/main.pas');

  GV_Script_AddCodeFromFile('globals.pas', RezFile, 'media/scripts/starfield/globals.pas');
  GV_Script_AddCodeFromFile('main.pas', RezFile, 'media/scripts/starfield/main.pas');
  GV_Script_Run('main.pas');

  if not GV_Script_IsError then
  begin
    GV_Script_SaveToFile('starfield.bin');
    //demo1_run;
    demo2_run;
  end;
end;

procedure demo4_run;
begin
  GV_Script_Reset;
  GV_Script_LoadFromFile(-1, 'starfield.bin');
  demo1_run;
end;

{$DEFINE LOAD_COMPILED}

begin
  try
    GV_Init;

    GV_RezFile_Init(256);

    RezFile := GV_RezFile_OpenArchive('..\..\samples.rez');

    GV_App_SetIcon(RezFile, 'media/icons/mainicon.ico');

    gvs_GVDLL_Register;
    GV_Script_RegisterDefaultColors;

    GV_Script_DefineStdRoutine('MyStdRoutine', _MyStdRoutine, 2, -1);

    GV_Script_DefineClassType(TStar, gvs_GVDLL_Namespace);
    GV_Script_DefineClassTypeMethod(TStar, 'constructor Create;', @TStar.Create, False);
    GV_Script_DefineClassTypeMethod(TStar, 'procedure Free;', @TStar.Free);
    GV_Script_DefineClassTypeMethod(TStar, 'procedure Init(aNum: Integer);', @TStar.Init, False);
    GV_Script_DefineClassTypeMethod(TStar, 'procedure Update(aSpeed: Integer; aElapsedTime: Single);', @TStar.Update, False);
    GV_Script_DefineClassTypeMethod(TStar, 'procedure Render;', @TStar.Render, False);

    GV_Script_Init;
    GV_Script_RegisterVariable('RezFile', 'Integer', @RezFile, -1);
    GV_Script_AddCode('main', 'type TGVRect = record Left: Integer; Top: Integer; Right: Integer; Bottom: Integer; end;');


    {$IFNDEF LOAD_COMPILED}
      demo3_run; // load code from rezfile and save compiled script to disk
    {$ELSE}
      demo4_run; // load and run compiled script from disk
    {$ENDIF}


    GV_RezFile_CloseArchive(RezFile);

    GV_RezFile_Done;
    GV_Done;
  except
  end;

end.
