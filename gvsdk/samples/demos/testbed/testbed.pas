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

{$R ..\..\samples.res}

program TestBed;

uses
  GVShareMem,
  GVDLL,
  Windows,
  SysUtils;

const
  { screen }
  SCREEN_CAPTION = 'Test Bed';
  SCREEN_WIDTH   = 640;
  SCREEN_HEIGHT  = 480;

  { viewport }
  VIEWPORT_X      = 120;
  VIEWPORT_Y      = 0;
  VIEWPORT_WIDTH  = 400;
  VIEWPORT_HEIGHT = 480;

type
  { TGVSprite }
  TGVSprite = record
    Handle: Integer;
    Page  : Cardinal;
    Group : Cardinal;
  end;

var
  { screen }
  Screen_Bpp     : Cardinal = 16;
  Screen_Windowed: Boolean  = True;

  { rezfile }
  RezFile        : Integer = -1;

  { audio }
  Sample         : array[0..3] of Integer;
  Chan           : array[0..3] of Integer;
  MusicVol       : Single = 1.0;
  SampleVol      : Single = 1.0;
  MusicPath      : string = '';
  SampleFreq        : Single = 1.0;
  AudioPause: Boolean = False;

  { textures }
  BossTex        : Integer = -1;
  FontTex        : Integer = -1;

  { fonts }
  Font           : Integer = -1;

  { sprites }
  Sprite         : TGVSprite;

  { images }
  Image          : Integer = -1;

  { polygon }
  Polygon        : Integer = -1;

  { entity }
  Entity: array[0..1] of Integer = (-1, -1);

  { misc }
  PY             : Single = 0;
  TexMem         : Cardinal;

{ === Demo  Routines ==================================================== }
procedure Demo_SaveCfg;
begin
  // save cfg info
  GV_Ini_WriteString ('AUDIO',  'MusicPath',       MusicPath);
  GV_Ini_WriteInteger('SCREEN', 'Bpp',      Screen_Bpp);
  GV_Ini_WriteBool   ('SCREEN', 'Windowed', Screen_Windowed);
  GV_Ini_Flush;
end;

procedure Demo_LoadCfg;
begin
  // check if ini exist by seeing of a value exist
  if not GV_Ini_ValueExists('SCREEN', 'Bpp') then
  begin
    Demo_SaveCfg;
  end;

  // load cfg info
  MusicPath       := GV_Ini_ReadString ('AUDIO',  'MusicPath', '');
  Screen_Bpp      := GV_Ini_ReadInteger('SCREEN', 'Bpp',       16);
  Screen_Windowed := GV_Ini_ReadBool   ('SCREEN', 'Windowed',  True);
end;

procedure Demo_Init;
var
  I: Integer;
begin
  // load config
  Demo_LoadCfg;

  // allow use to pick mp3 path
  if MusicPath = '' then
  begin
    MusicPath := GV_Dialog_PickDir(SCREEN_CAPTION);
  end;

  GV_Timer_Init(35, 3);

  // alloc resources
  GV_RezFile_Init(256);
  GV_Texture_Init(256);
  GV_Font_Init(256);
  GV_Sprite_Init(256);
  GV_Image_Init(256);
  GV_Polygon_Init(256);
  GV_Entity_Init(256);

  //Color := GV_Color_Make(64,64,64,64);

  // init rezfile
  RezFile := GV_RezFile_OpenArchive('../../samples.rez');

  // load icon
  GV_App_SetIcon(RezFile, 'media/icons/mainicon.ico');

  // init rezfile
  GV_AppWindow_Open(SCREEN_CAPTION, SCREEN_WIDTH, SCREEN_HEIGHT);
  GV_AppWindow_Show;

  // init graphic mode
  GV_RenderDevice_SetMode(GV_AppWindow_GetHandle, SCREEN_WIDTH, SCREEN_HEIGHT,
    SCREEN_BPP, Screen_Windowed, GV_SwapEffect_Discard);

  // init textures
  BossTex := GV_Texture_Load(RezFile, GV_ColorKey, 'media/sprites/boss1.png');

  // init fonts
  //Font := GV_Font_Build('Lucida Console', 12, GV_FontWeight_Heavy, True, 'font0');
  //Font := GV_Font_Load(GV_NIL, 'font0');
  Font := GV_Font_Load(RezFile, 'media/fonts/font0');
  FontTex := GV_Font_GetTexture(Font);

  // init sprites
  Sprite.Handle := GV_Sprite_Create;
  GV_Sprite_LoadPage(Sprite.Handle, RezFile, GV_ColorKey, 'media/sprites/boss1.png');
  Sprite.Group := GV_Sprite_AddGroup(Sprite.Handle);
  GV_Sprite_AddImageGrid(Sprite.Handle, Sprite.Page, Sprite.Group, 0, 0, 128, 128);
  GV_Sprite_AddImageGrid(Sprite.Handle, Sprite.Page, Sprite.Group, 1, 0, 128, 128);
  GV_Sprite_AddImageGrid(Sprite.Handle, Sprite.Page, Sprite.Group, 0, 1, 128, 128);

  // init entities
  Entity[0] := GV_Entity_Create(Sprite.Handle, Sprite.Page, Sprite.Group);
  GV_Entity_SetPos(Sprite.Handle, 150, 150);
  GV_Entity_SetFrameDelay(Sprite.Handle, 2);
  
  // init images
  Image := GV_Image_Load(RezFile, GV_ColorKey, 'media/images/gamevision.png', 256, 256);

  Polygon := GV_Polygon_Create;
  GV_Polygon_AddLocalPoint(Polygon, +1, -1, True);
  GV_Polygon_AddLocalPoint(Polygon, +1, +1, True);
  GV_Polygon_AddLocalPoint(Polygon, -1, +1, True);
  GV_Polygon_AddLocalPoint(Polygon, -1, -1, True);
  GV_Polygon_AddLocalPoint(Polygon, +1, -1, True);


  // init audio
  //GV_Audio_Open(-1, -1, 10, False);
  GV_Audio_Open(GV_AppWindow_GetHandle);
  GV_Audio_SetMasterSfxVol(MusicVol);
  //GV_Audio_SetMasterSampleVol(SampleVol);

  for I := 0 to 3 do
  begin
    Sample[I] := GV_Audio_LoadSample(RezFile, Format('media/sfx/samp%d.wav', [I]));
  end;

  GV_Audio_ReserveChannel(0, True);

  GV_MusicPlayer_InitSongList;
  GV_MusicPlayer_AddSongs('MUSIC');
  GV_MusicPlayer_AddSongs(MusicPath);

  // init input
  GV_Input_Open(GV_AppWindow_GetHandle, Screen_Windowed);
end;

procedure Demo_Done;
var
  I: Integer;
begin
  // shutdown input
  GV_Input_Close;

  for I := 0 to 3 do
  begin
    GV_Audio_FreeSample(Sample[I]);
  end;
  GV_Audio_StopMusic;
  GV_Audio_Close;

  // free polygons
  GV_Polygon_Dispose(Polygon);

  // free images
  GV_Image_Dispose(Image);

  // free entities
  GV_Entity_Dispose(Entity[0]);

  // free sprites
  GV_Sprite_Dispose(Sprite.Handle);

  // free fonts
  GV_Font_Dispose(Font);

  // free textures
  GV_Texture_Dispose(BossTex);

  // shutdown graphics
  GV_RenderDevice_RestoreMode;

  // shutdown app window
  GV_AppWindow_Close;

  // dispose resources
  GV_Entity_Done;
  GV_Polygon_Done;
  GV_Image_Done;
  GV_Font_Done;
  GV_Sprite_Done;
  GV_Texture_Done;
  GV_RezFile_Done;

  // save config
  Demo_SaveCfg;
end;

var Angle: Single = 0;
procedure Demo_Run;
var
  Pitch: Integer;
  ElapsedTime: Single;
  X,Y: Integer;
  Rect: TGVRect;
begin
  Rect.Left  := 128;
  Rect.Top   := 0;
  Rect.Right := 255;
  Rect.Bottom:= 128;

  repeat
    GV_App_ProcessMessages;
    if not GV_RenderDevice_IsReady then continue;

    GV_RenderDevice_ClearFrame(GV_ClearFrame_Default, GV_Black);

    if GV_RenderDevice_StartFrame then
    begin
      GV_Image_Render(Image, 0, 0, GV_White, GV_RenderState_Image);

      GV_RenderDevice_DrawCircle(300, 300, 50, GV_Red, GV_RenderState_Normal, True);

      GV_Polygon_Render(Polygon, 320, 240, 128, Angle, GV_Blue, GV_RenderState_Blend);
      GV_Polygon_Render(Polygon, 320, 240, 128, -Angle, GV_Green, GV_RenderState_Blend);

      GV_Texture_Render(BossTex, 320, 240, 1.0, Angle, GV_White, nil, GV_RenderState_Blend);
      GV_Texture_RenderRectScaled(BossTex, 320, 240, @rect, 2.0, 2.0, GV_White, GV_RenderState_Blend);

      GV_Texture_Lock(BossTex, @Rect, @Pitch);
      X := GV_RandomNum_RangeInteger(0, 127);
      Y := GV_RandomNum_RangeInteger(0, 127);
      if (GV_Texture_GetPixel(BossTex,X, Y) <> 0) then
      begin
      GV_Texture_SetPixel(BossTex, X, Y,
        GV_Color_Make(GV_RandomNum_RangeInteger(64, 255),
                      GV_RandomNum_RangeInteger(64, 255),
                      GV_RandomNum_RangeInteger(64, 255),
                      255));
      end;
      GV_Texture_Unlock(BossTex);

      GV_Sprite_RenderImage(Sprite.Handle, 0, Sprite.Group, 128, 128, 1.0, 0, GV_White, nil, GV_RenderState_Blend);

      GV_Entity_Render(Entity[0]);

      GV_RenderDevice_DrawLine(0, 0, 639,479,$FFFFFFFF,GV_RenderState_Blend);

      GV_RenderDevice_DrawCircle(320, 240, 200, GV_Yellow, GV_RenderState_Normal, False);

      PY := 0;
      GV_Font_PrintY(Font, 0, py, 12, GV_White, 'fps         - %d', [GV_Timer_FrameRate]);
      TexMem := GV_RenderDevice_GetAvailableTextureMem div (1024*1000);
      GV_Font_PrintY(Font, 0, py, 24, GV_White, 'Texture Mem - %dMB', [TexMem]);

      GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'Sfx         - 1-4,0', []);
      GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'Sfx #1 Freq - Left/Right', []);
      GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'M           - Random MP3', []);
      GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'MP3 Vol     - Home/End ', []);
      GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'Sfx vol     - PgUp/PgDn', []);
      GV_Font_PrintY(Font, 0, py, 24, GV_Green, 'Exit        - Esc', []);

      GV_Font_PrintY(Font, 0, py, 12, GV_Yellow, 'MP3 Vol     - %1.1f', [MusicVol]);
      GV_Font_PrintY(Font, 0, py, 12, GV_Yellow, 'Sfx Vol     - %1.1f', [SampleVol]);
      GV_Font_PrintY(Font, 0, py, 24, GV_Yellow, 'Sfx #1 Freq - %1.1f', [SampleFreq]);

      GV_Font_Center(Font, 456, GV_Yellow, 'GameVision (tm) SDK Copyright (c) 1994-2003 Jarrod Davis Software', []);
      GV_Font_Center(Font, 468, GV_Yellow, 'Visit the GameVision SDK site at: www.gamevisionsdk.com', []);

      GV_RenderDevice_EndFrame;
    end;
    GV_RenderDevice_ShowFrame;

    GV_Timer_Update;
    GV_Input_Update;
    ElapsedTIme := GV_Timer_ElapsedTime;
    Angle := Angle + 1.0*ElapsedTime;
    if Angle > 360 then Angle := 0;

    GV_Entity_NextFrame(Entity[0], True, ElapsedTime);
    GV_Entity_RotateRel(Entity[0], 2.0*ElapsedTime);
    GV_Entity_Thrust(Entity[0], 7.0*ElapsedTime);

    if not GV_MusicPlayer_SongPlaying then
    begin
      GV_MusicPlayer_PlayRandomSong(False);
    end;

    if GV_Input_KeyHit(GV_KEY_ESCAPE) then
    begin
      GV_App_Terminate;
    end;

    if GV_Input_KeyHit(GV_KEY_S) then
    begin
      GV_RenderDevice_SaveFrame('frame.png');
    end;

    if GV_Input_KeyHit(GV_KEY_1) then
    begin
      Chan[0] := GV_Audio_PlaySample(Sample[0], 0, 1.0, 0.0, SampleFreq, True);
    end;

    if GV_Input_KeyHit(GV_KEY_LEFT) then
    begin
      SampleFreq := SampleFreq - 0.02;
      if SampleFreq  < -1.0 then
        SampleFreq := -1.0;
      GV_Audio_SetChannelFreq(Chan[0], SampleFreq);
    end;

    if GV_Input_KeyHit(GV_KEY_RIGHT) then
    begin
      SampleFreq := SampleFreq + 0.02;
      if SampleFreq  > 1.0 then
        SampleFreq := 1.0;
      GV_Audio_SetChannelFreq(Chan[0], SampleFreq);
    end;

    if GV_Input_KeyHit(GV_KEY_M) then
    begin
      GV_MusicPlayer_PlayRandomSong(False);
    end;

    if GV_Input_KeyHit(GV_KEY_P) then
    begin
      AudioPause := not AudioPause;
      GV_MusicPlayer_PauseSong(AudioPause);
    end;

    if GV_Input_KeyHit(GV_KEY_2) then
    begin
      GV_Audio_PlaySample(Sample[1], -1, 1.0, -1.0, 1.0, False);
    end;

    if GV_Input_KeyHit(GV_KEY_3) then
    begin
      GV_Audio_PlaySample(Sample[2], -1, 1.0, 1.0, 1.0, False);
    end;

    if GV_Input_KeyHit(GV_KEY_4) then
    begin
      GV_Audio_PlaySample(Sample[3], -1, 1.0, 0.0, 1.0, False);
    end;

    if GV_Input_KeyHit(GV_KEY_0) then
    begin
      GV_Audio_StopChannel(0);
    end;

    if GV_Input_KeyHit(GV_KEY_F12) then
    begin
      GVDLL.GV_Error_Abort('Runtime error', [], '');
    end;

    if GV_Input_KeyHit(GV_KEY_HOME) then
    begin
      MusicVol := MusicVol + 0.02;
      if MusicVol > 1.0 then MusicVol := 1.0;
      GV_Audio_SetMusicVol(MusicVol);
    end;

    if GV_Input_KeyHit(GV_KEY_END) then
    begin
      MusicVol := MusicVol - 0.02;
      if MusicVol < 0.0 then MusicVol := 0.0;
      GV_Audio_SetMusicVol(MusicVol);
    end;

    if GV_Input_KeyHit(GV_KEY_PGUP) then
    begin
      SampleVol := SampleVol + 0.02;
      if SampleVol > 1.0 then SampleVol := 1.0;
      GV_Audio_SetMasterSfxVol(SampleVol);
    end;

    if GV_Input_KeyHit(GV_KEY_PGDN) then
    begin
      SampleVol := SampleVol - 0.02;
      if SampleVol < 0.0 then SampleVol := 0.0;
      GV_Audio_SetMasterSfxVol(SampleVol);
    end;

  until GV_App_IsTerminated;
end;

procedure UnhandledException(aMsg: string);
begin
  Demo_Done;
end;

begin
  if not GV_DirectXInstalled then
  begin
    Exit;
  end;

  if GV_App_AlreadyRunning(SCREEN_CAPTION) then
  begin
    Halt;
  end;
  
  // check if vid mode valid
  if not GV_RenderDevice_ValidMode(SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP) then
  begin
    GV_Dialog_ShowMessage('Fatal Error', 'Display mode not supported!');
    Exit;
  end;

  try
    Demo_Init;
    Demo_Run;
    Demo_Done;
  except
    on E: Exception do UnhandledException(E.Message);
  end;
end.
