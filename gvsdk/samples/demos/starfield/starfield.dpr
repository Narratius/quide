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

program starfield;

uses
  GVShareMem,GVDLL,
  Windows, Math;

const
  MAX_STARS         = 250;

  SCREEN_WIDTH      = 640;
  SCREEN_HEIGHT     = 480;
  SCREEN_BPP        = 32;
  SCREEN_WINDOWED   = False;
  SCREEN_CAPTION    = 'StarField';

  MIN_X             = -1000;
  MIN_Y             = -1000;
  MIN_Z             =    10;
  MAX_X             =  1000;
  MAX_Y             =  1000;
  MAX_Z             =  1000;

  VIEW_SCALE_RATIO  = SCREEN_WIDTH / SCREEN_HEIGHT;
  VIEW_SCALE        = 80;


type
  { TStar }
  TStar = record
    x,y,z: single;
    speed: single;
  end;

var
  RezFile: Integer = -1;
  Font   : Integer = -1;
  Star: array[0..MAX_STARS-1] of TStar;

procedure Star_Init;
var
  I: Integer;
begin
  for I := 0 to MAX_STARS-1 do
  begin
    Star[I].x := GV_RandomNum_RangeInteger(MIN_X, MAX_X);
    Star[I].y := GV_RandomNum_RangeInteger(MIN_Y, MAX_Y);
    Star[I].z := GV_RandomNum_RangeInteger(MIN_Z, MAX_Z);
    STar[I].speed := GV_RandomNum_RangeInteger(1, 5);
  end;
end;

procedure Star_Update(aElapsedTime: Single);
var
  I: Integer;
begin
  for I := 0 to MAX_STARS-1 do
  begin
    Star[I].z := Star[I].z - (Star[I].speed * aElapsedTime);
    if Star[I].z < MIN_Z then
    begin
      Star[I].x := GV_RandomNum_RangeInteger(MIN_X, MAX_X);
      Star[I].y := GV_RandomNum_RangeInteger(MIN_Y, MAX_Y);
      Star[I].z := MAX_Z - Star[I].z;
      //Star[I].z := GV_RandomNum_RangeInteger(MIN_Z, MAX_Z);
      STar[I].speed := GV_RandomNum_RangeInteger(1, 5);
    end;
  end;

end;

procedure TransformDrawPoint(aX, aY, aZ, aWidth, aHeight: Single);
var
  x,y: single;
  sw,sh: single;
  ooz  : single;
  cv : byte;
  color: cardinal;
begin
  ooz := ((1.0 / aZ) * VIEW_SCALE);
  x := 320 - (ax * ooz)*VIEW_SCALE_RATIO;
  y := 240 + (ay * ooz)*VIEW_SCALE_RATIO;
  sw := (aWidth * ooz);
  if sw < 1 then sw := 1;
  sh := (aHeight * ooz);
  if sh < 1 then sh := 1;
  cv := round( 255.0-(((1.0 / MAX_Z) / (1.0 / az)) * 255.0) );
  color := GV_Color_Make(cv, cv, cv, cv);
  GV_RenderDevice_DrawRect(x, y, sw, sh, color, GV_RenderState_TransBlend);
end;

procedure Star_Render;
var
  I: Integer;
begin
  for I := 0 to MAX_STARS-1 do
  begin
    TransformDrawPoint(Star[I].x, Star[I].y, Star[I].z, 1, 1);
  end;
end;

begin
  GV_Init;

  GV_RezFile_Init(1);
  GV_Font_Init(1);
  GV_Texture_Init(256);

  RezFile := GV_RezFile_OpenArchive('..\..\samples.rez');

  GV_AppWindow_Open(SCREEN_CAPTION, 640, 480);
  GV_AppWindow_Show;

  GV_RenderDevice_SetMode(GV_AppWindow_GetHandle, 640, 480, 32, SCREEN_WINDOWED, GV_SwapEffect_Discard);

  Font := GV_Font_Load(RezFile, 'media/fonts/font0');

  GV_Input_Open(GV_AppWindow_GetHandle, SCREEN_WINDOWED);

  Star_Init;
  GV_Timer_Init(35, 3);
  repeat
    GV_App_ProcessMessages;
    GV_RenderDevice_ClearFrame(GV_ClearFrame_Default, GV_Black);
    if GV_RenderDevice_StartFrame then
    begin
      Star_Render;
      GV_Font_Print(Font, 0, 0, GV_Green, '%d fps', [GV_Timer_FrameRate]);
      GV_Font_Print(Font, 0,12,GV_Green, 'ESC - Quit', []);

      GV_Font_Center(Font, 0, GV_White, '3D Star Field Simulation', []);

      GV_Font_Center(Font, 456, GV_Yellow, 'GameVision (tm) SDK Copyright (c) 1994-2003 Jarrod Davis Software', []);
      GV_Font_Center(Font, 468, GV_Yellow, 'Visit the GameVision SDK site at: www.gamevisionsdk.com', []);

      GV_RenderDevice_EndFrame;
    end;
    GV_RenderDevice_ShowFrame;
    GV_Input_Update;
    GV_Timer_Update;
    Star_Update(GV_Timer_ElapsedTime);

    if GV_Input_KeyHit(GV_KEY_ESCAPE) then
    begin
      GV_App_Terminate;
    end;


  until GV_App_IsTerminated;

  GV_Input_Close;
  GV_Font_Dispose(Font);

  GV_RenderDevice_RestoreMode;

  GV_AppWindow_Close;
  gV_RezFile_CloseArchive(RezFile);

  GV_Font_Done;
  GV_Texture_Done;
  GV_RezFile_Done;

  GV_Done;
end.
