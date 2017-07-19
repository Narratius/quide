uses
  GVDLL;

procedure test1_run;
var
  s: string;
begin
  Point.x := 1;
  Point.y := 2;
  Point.z := 3;
  s := MyStdRoutine('this is a standard routine!', Point);
  GV_Dialog_ShowMessage('test1_run', s);
end;

procedure demo_run;
begin
  MusicPath := GV_Dialog_PickDir('Pick Music Path');
  if MusicPath = '' then MusicPath := 'C:/My Music';

  GV_Font_Init(256);
  GV_Texture_Init(256);

  GV_AppWindow_Open(SCREEN_CAPTION, 640, 480);
  GV_AppWindow_Show;

  GV_RenderDevice_SetMode(GV_AppWindow_GetHandle, 640, 480, 32, SCREEN_WINDOWED, GV_SwapEffect_Discard);

  Font := GV_Font_Load(RezFile, 'media/fonts/font0');

  GV_Audio_Open(GV_AppWindow_GetHandle());
  GV_MusicPlayer_InitSongList();
  GV_MusicPlayer_AddSongs(MusicPath);

  GV_Input_Open(GV_AppWindow_GetHandle, SCREEN_WINDOWED);

  Star := TStar.Create();

  Star.Init(250);

  GV_Timer_Init(35, 3);
  repeat
    GV_App_ProcessMessages;
    if not GV_RenderDevice_IsReady() then continue;
    GV_RenderDevice_ClearFrame(GV_ClearFrame_Default, GV_Black);
    if GV_RenderDevice_StartFrame then
    begin
      Star.Render();
      GV_Font_Print(Font, 0, 0, GV_Green, '%d fps', [GV_Timer_FrameRate]);
      GV_Font_Print(Font, 0,12,GV_Green, 'ESC - Quit', []);

      GV_Font_Center(Font, 0, GV_White, '3D Star Field Simulation', []);
      GV_Font_Center(Font, 12, GV_White, 'using GVScript', []);

      GV_Font_Center(Font, 456, GV_Yellow, 'GameVision (tm) SDK Copyright (c) 1994-2003 Jarrod Davis Software', []);
      GV_Font_Center(Font, 468, GV_Yellow, 'Visit the GameVision SDK site at: www.gamevisionsdk.com', []);

      GV_RenderDevice_EndFrame;
    end;
    GV_RenderDevice_ShowFrame;
    GV_Input_Update;
    GV_Timer_Update;
    Star.Update(5, GV_Timer_ElapsedTime());

    if not GV_MusicPlayer_SongPlaying() then
    begin
      GV_MusicPlayer_PlayRandomSong(False);
    end;

    if GV_Input_KeyHit(GV_KEY_M) then
    begin
      GV_MusicPlayer_PlayRandomSong(False);
    end;

    if GV_Input_KeyHit(GV_KEY_ESCAPE) then
    begin
      GV_App_Terminate();
    end;


  until GV_App_IsTerminated();

  Star.Free();

  GV_Input_Close;
  GV_Audio_StopMusic();
  GV_Audio_Close();
  
  GV_Font_Dispose(Font);

  GV_RenderDevice_RestoreMode;

  GV_AppWindow_Close;
  
  GV_Font_Done;
  GV_Texture_Done;

end;

