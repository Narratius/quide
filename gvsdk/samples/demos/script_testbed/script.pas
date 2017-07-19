//-----------------------------------------------------------------------
// GameScript SDK Demo
// Copyright (c) 2003 Jarrod Davis Software
// All Rights Reserved.
// http://gamescript.jarroddavis.com | support@jarroddavis.com
//-----------------------------------------------------------------------

uses
  SysUtils, GVDLL;

const
  Screen_Width   = 640;
  Screen_Height  = 480;
  Screen_Bpp     = 32;

var
  //screen
  Screen_Caption : string  = 'GVScript - TestBed';
  Screen_Windowed: boolean = True;

  // audio
  Music_Path      : string  = '';
  Sfx_Vol         : double  = 1.0;
  Music_Vol       : double  = 1.0;
  Sfx_Freq        : double  = 1.0;
  Audio_Pause     : boolean = False;
  Samp            = [-1, -1, -1, -1];
  Chan            = [-1, -1, -1, -1];
  Pan_Left        : double = -1.0;
  Pan_Center      : double = 0.0;
  Pan_Right       : double = 1.0;

  // texture
  BossTex         : integer = -1;

  // sprite
  Sprite_Handle   : integer = -1;
  Sprite_Page     : integer = -1;
  Sprite_Group    : integer = -1;

  // misc
  Font            : integer = -1;
  RezFile         : integer = -1;
  Entity          : integer = -1;
  I               : integer = 0;
  ElapsedTime     : double  = 0;
  Polygon         : integer = -1;
  Angle           : double  = 0.0;
  X               : integer = 0;
  Y               : integer = 0;
  Image           : integer = -1;
  py              : integer = 0;
  s               : string  = '';
  rect            : TGVRect;
  pitch           : Integer = 0;

procedure Demo_Init;
begin
  // get music path
  Music_Path := GV_Dialog_PickDir('Pick Music Path');
  if Music_Path = '' then Music_Path := GV_CmdLine_GetStartPath();

  // init timer
  GV_Timer_Init(35, 3);

  // alloc resources
  GV_RezFile_Init(256);
  GV_Texture_Init(256);
  GV_Font_Init(256);
  GV_Sprite_Init(256);
  GV_Image_Init(256);
  GV_Polygon_Init(256);
  GV_Entity_Init(256);

  // init rezfile
  RezFile := GV_RezFile_OpenArchive('..\..\samples.rez');

  // load icon
  GV_App_SetIcon(RezFile, 'media/icons/mainicon.ico');

  // init app window
  GV_AppWindow_Open(Screen_Caption, Screen_Width, Screen_Height);
  GV_AppWindow_Show();

  // init gfx mode
  GV_RenderDevice_SetMode(GV_AppWindow_GetHandle(), Screen_Width, Screen_Height,
    Screen_Bpp, Screen_Windowed, GV_SwapEffect_Discard);

  // init textures
  BossTex    := GV_Texture_Load(RezFile, GV_ColorKey, 'media/sprites/boss1.png');

  // init fonts
  Font := GV_Font_Load(RezFile, 'media/fonts/font0');

  // init sprites
  Sprite_Handle := GV_Sprite_Create();
  Sprite_Page   := GV_Sprite_LoadPage(Sprite_Handle, RezFile, GV_ColorKey, 'media/sprites/boss1.png');
  Sprite_Group  := GV_Sprite_AddGroup(Sprite_Handle);
  GV_Sprite_AddImageGrid(Sprite_Handle, Sprite_Page, Sprite_Group, 0, 0, 128, 128);
  GV_Sprite_AddImageGrid(Sprite_Handle, Sprite_Page, Sprite_Group, 1, 0, 128, 128);
  GV_Sprite_AddImageGrid(Sprite_Handle, Sprite_Page, Sprite_Group, 0, 1, 128, 128);

  // init entities
  Entity := GV_Entity_Create(Sprite_Handle, Sprite_Page, Sprite_Group);
  GV_Entity_SetPos(Sprite_Handle, 150, 150);
  GV_Entity_SetFrameDelay(Sprite_Handle, 2);

  // init images
  Image := GV_Image_Load(RezFile, GV_ColorKey, 'media/images/gamevision.png', 256, 256);

  // init polygons
  Polygon := GV_Polygon_Create();
  GV_Polygon_AddLocalPoint(Polygon, +1, -1, True);
  GV_Polygon_AddLocalPoint(Polygon, +1, +1, True);
  GV_Polygon_AddLocalPoint(Polygon, -1, +1, True);
  GV_Polygon_AddLocalPoint(Polygon, -1, -1, True);
  GV_Polygon_AddLocalPoint(Polygon, +1, -1, True);

  // init audio
  GV_Audio_Open(GV_AppWindow_GetHandle());
  GV_Audio_SetMasterSfxVol(Sfx_Vol);
  GV_Audio_ReserveChannel(0, True);

  // init samples
  for I := 0 to 3 do
  begin
    //S := 'media/sfx/samp' + IntToStr(I) + '.wav';
    S := Format('media/sfx/samp%d.wav', [I]);
    Samp[I] := GV_Audio_LoadSample(RezFile, S);
  end;

  // init muiscplayer
  GV_MusicPlayer_InitSongList();
  GV_MusicPlayer_AddSongs(Music_Path);
  GV_MusicPlayer_SetSongVol(Music_Vol);

  // init input
  GV_Input_Open(GV_AppWindow_GetHandle(), Screen_Windowed);
end;

procedure Demo_Done;
begin
  // shutdown input
  GV_Input_Close();

  // free samples
  for I := 0 to 3 do
  begin
    GV_Audio_FreeSample(Samp[I]);
  end;

  // shutdown audio
  GV_Audio_Close();

  // free polygons
  GV_Polygon_Dispose(Polygon);

  // free images
  GV_Image_Dispose(Image);

  // free entities
  GV_Entity_Dispose(Entity);

  // free sprites
  GV_Sprite_Dispose(Sprite_Handle);

  // free fonts
  GV_Font_Dispose(Font);

  // free textures
  GV_Texture_Dispose(BossTex);

  // restore gfx mode
  GV_RenderDevice_RestoreMode();

  // close app window
  GV_AppWindow_Close();

  // close rezfile
  GV_RezFile_CloseArchive(RezFile);

  // free resources
  GV_RezFile_Done();
  GV_Texture_Done();
  GV_Font_Done();
  GV_Sprite_Done();
  GV_Image_Done();
  GV_Polygon_Done();
  GV_Entity_Done();
end;


procedure Demo_Run;
begin
  repeat
    // let windows do its thing
    GV_App_ProcessMessages();

    // check if appwindow/render context is ready
    if GV_RenderDevice_IsReady() = True then
    begin
      // clear frame buffer
      GV_RenderDevice_ClearFrame(GV_ClearFrame_Default, GV_Black);

      // start rendering
      if GV_RenderDevice_StartFrame() then
      begin
        GV_Image_Render(Image, 0, 0, GV_White, GV_RenderState_Image);

        // draw entity
        GV_Entity_Render(Entity);

        // draw circles
        GV_RenderDevice_DrawCircle(320, 240, 200, GV_Yellow, GV_RenderState_Normal, False);
        GV_RenderDevice_DrawCircle(100, 300, 50, GV_Red, GV_RenderState_Normal, True);

        // draw polygons
        GV_Polygon_Render(Polygon, 320, 240, 128, Angle, GV_Blue, GV_RenderState_Blend);
        GV_Polygon_Render(Polygon, 320, 240, 128, Angle-(Angle*2), GV_Green, GV_RenderState_Blend);

        // draw textures
        rect.Left := 0;
        rect.Top  := 128;
        rect.Right := 127;
        rect.Bottom := 255;
        GV_Texture_Render(BossTex, 320, 240, 1.0, Angle, GV_White, nil, GV_RenderState_Blend);

        GV_Texture_Lock(BossTex, nil, pitch);

        X := GV_RandomNum_RangeInteger(0,255);
        Y := GV_RandomNum_RangeInteger(0, 255);
        if (GV_Texture_GetPixel(BossTex,X, Y) <> 0) then
        begin
        GV_Texture_SetPixel(BossTex, X, Y,
          GV_Color_Make(GV_RandomNum_RangeInteger(64, 255),
                        GV_RandomNum_RangeInteger(64, 255),
                        GV_RandomNum_RangeInteger(64, 255),
                        255));
        end;
        GV_Texture_Unlock(BossTex);

        // display help
        py := 0;
        GV_Font_PrintY(Font, 0, py, 24, GV_White, '%d fps', [GV_Timer_FrameRate()]);
        GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'Sfx         - 1-4', []);
        GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'Sfx #1 Freq - Left/Right', []);
        GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'M           - Random MP3', []);
        GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'MP3 Vol     - Home/End ', []);
        GV_Font_PrintY(Font, 0, py, 12, GV_Green, 'Sfx vol     - PgUp/PgDn', []);
        GV_Font_PrintY(Font, 0, py, 24, GV_Green, 'Exit        - Esc', []);

        GV_Font_PrintY(Font, 0, py, 12, GV_Yellow, 'MP3 Vol     - %1.1f', [Music_Vol]);
        GV_Font_PrintY(Font, 0, py, 12, GV_Yellow, 'Sfx Vol     - %1.1f', [Sfx_Vol]);
        GV_Font_PrintY(Font, 0, py, 12, GV_Yellow, 'Sfx #1 Freq - %1.1f', [Sfx_Freq]);

        //GV_Font_PrintY(Font, 0, py, 12, GV_Yellow, 'pitch: %d', [pitch]);
        GV_Font_PrintY(Font, 0, py, 12, GV_Yellow, format('pitch: %d', [pitch]), []);

        // display footer
        GV_Font_Center(Font, 456, GV_Yellow, 'GameVision (tm) SDK Copyright (c) 1994-2003 Jarrod Davis Software', []);
        GV_Font_Center(Font, 468, GV_Yellow, 'Visit the GameVision SDK site at: www.gamevisionsdk.com', []);

        // stop rendering
        GV_RenderDevice_EndFrame();
      end;

      // show frame
      GV_RenderDevice_ShowFrame();

      // do updates
      GV_Input_Update();
      GV_Timer_Update();
      ElapsedTIme := GV_Timer_ElapsedTime();

      // update angle
      Angle := Angle + 1.0*ElapsedTime;
      if Angle > 360 then Angle := 0;

      // update timeing
      ElapsedTime := GV_Timer_ElapsedTime();

      // update musicplayer
      if GV_MusicPlayer_SongPlaying() = False then
      begin
        GV_MusicPlayer_PlayRandomSong(False);
      end;

      // update entity
      GV_Entity_NextFrame(Entity, True, ElapsedTime);
      GV_Entity_RotateRel(Entity, 2.0*ElapsedTime);
      GV_Entity_Thrust(Entity, 7.0*ElapsedTime);

      // process input
      if GV_Input_KeyHit(GV_KEY_ESCAPE) = True then
      begin
        GV_App_Terminate();
      end;

      if GV_Input_KeyHit(GV_KEY_0) = True then
      begin
        GV_Audio_StopChannel(Chan[0]);
      end;

      if GV_Input_KeyHit(GV_KEY_1) = True then
      begin
        Chan[0] := GV_Audio_PlaySample(Samp[0], 0, 1.0, 0.0, Sfx_Freq, True);
      end;

      if GV_Input_KeyHit(GV_KEY_2) = True then
      begin
        Chan[1] := GV_Audio_PlaySample(Samp[1], -1, 1.0, -1.0, 1.0, False);
      end;

      if GV_Input_KeyHit(GV_KEY_3) = True then
      begin
        Chan[2] := GV_Audio_PlaySample(Samp[2], -1, 1.0, 1.0, 1.0, False);
      end;

      if GV_Input_KeyHit(GV_KEY_4) = True then
      begin
        Chan[3] := GV_Audio_PlaySample(Samp[3], -1, 1.0, 0.0, 1.0, False);
      end;

      if GV_Input_KeyHit(GV_KEY_LEFT) then
      begin
        Sfx_Freq := Sfx_Freq - 0.02;
        if Sfx_Freq  < -1.0 then
          Sfx_Freq := -1.0;
        GV_Audio_SetChannelFreq(Chan[0], Sfx_Freq);
      end;

      if GV_Input_KeyHit(GV_KEY_RIGHT) then
      begin
        Sfx_Freq := Sfx_Freq + 0.02;
        if Sfx_Freq  > 1.0 then
          Sfx_Freq := 1.0;
        GV_Audio_SetChannelFreq(Chan[0], Sfx_Freq);
      end;

      if GV_Input_KeyHit(GV_KEY_HOME) then
      begin
        Music_Vol := Music_Vol + 0.02;
        if Music_Vol > 1.0 then Music_Vol := 1.0;
        GV_Audio_SetMusicVol(Music_Vol);
        GV_MusicPlayer_SetSongVol(Music_Vol);
      end;

      if GV_Input_KeyHit(GV_KEY_END) then
      begin
        Music_Vol := Music_Vol - 0.02;
        if Music_Vol < 0.0 then Music_Vol := 0.0;
        GV_Audio_SetMusicVol(Music_Vol);
        GV_MusicPlayer_SetSongVol(Music_Vol);
      end;

      if GV_Input_KeyHit(GV_KEY_PGUP) then
      begin
        Sfx_Vol := Sfx_Vol + 0.02;
        if Sfx_Vol > 1.0 then Sfx_Vol := 1.0;
        GV_Audio_SetMasterSfxVol(Sfx_Vol);
      end;

      if GV_Input_KeyHit(GV_KEY_PGDN) then
      begin
        Sfx_Vol := Sfx_Vol - 0.02;
        if Sfx_Vol < 0.0 then Sfx_Vol := 0.0;
        GV_Audio_SetMasterSfxVol(Sfx_Vol);
      end;

      if GV_Input_KeyHit(GV_KEY_M) then
      begin
        GV_MusicPlayer_PlayRandomSong(False);
      end;

    end;
  until GV_App_IsTerminated();
end;

// --- start ---
try
  begin
    Demo_Init();
    Demo_Run();
  end;
finally
  begin
    Demo_Done();
  end;
end;

