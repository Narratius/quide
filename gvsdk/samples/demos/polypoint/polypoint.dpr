program demo;

uses
  GVShareMem,
  GVDLL,
  SysUtils,
  common in '..\..\common\common.pas';

var
  RezFile   : Integer;
  Sprite    : Integer;
  BossEntity: array[0..1] of Integer = (-1, -1);
  BossSprite: TGVSpriteImage;
  ElapsedTime: Single;
  MousePos   : TGVVector;
  Screen_Windowed: Boolean = True;
  Collided: Boolean = False;
  CollidePos: TGVVector;
  Font: Integer = -1;
  MusicPath: string;
  Screen_Bpp: Cardinal = 32;
  Screen_Caption: string = 'PolyPoint Demo';

procedure SaveCfg;
begin
  // save cfg info
  GV_Ini_WriteString ('AUDIO',  'MusicPath',       MusicPath);
  GV_Ini_WriteInteger('SCREEN', 'Bpp',      Screen_Bpp);
  GV_Ini_WriteBool   ('SCREEN', 'Windowed', Screen_Windowed);
  GV_Ini_Flush;
end;

procedure LoadCfg;
begin
  // check if ini exist by seeing of a value exist
  if not GV_Ini_ValueExists('SCREEN', 'Bpp') then
  begin
    SaveCfg;
  end;

  // load cfg info
  MusicPath       := GV_Ini_ReadString ('AUDIO',  'MusicPath', '');
  Screen_Bpp      := GV_Ini_ReadInteger('SCREEN', 'Bpp',       32);
  Screen_Windowed := GV_Ini_ReadBool   ('SCREEN', 'Windowed',  True);
end;

begin
  Demo_PreInit(Screen_Caption);
  LoadCfg;

  // allow use to pick mp3 path
  if MusicPath = '' then
  begin
    MusicPath := GV_Dialog_PickDir(Screen_Caption);
  end;

  GV_Timer_Init(35, 3);

  RezFile := GV_RezFile_OpenArchive('..\..\samples.rez');
  //RezFile := GV_RezFile_OpenArchive('samples.rez');

  GV_App_SetIcon(RezFile, 'media/icons/mainicon.ico');

  GV_AppWindow_Open(Screen_Caption, 640, 480);
  GV_AppWindow_Show;

  GV_RenderDevice_SetMode(GV_AppWindow_GetHandle, 640, 480, Screen_Bpp, Screen_Windowed, GV_SwapEffect_Discard);

  Font := GV_Font_Load(RezFile, 'media/fonts/font0');

  Sprite := GV_Sprite_Create;
  BossSprite.Handle := Sprite;
  BossSprite.Page  := GV_Sprite_LoadPage(Sprite, RezFile, GV_ColorKey, 'media/sprites/boss1.png');
  BossSprite.Group := GV_Sprite_AddGroup(Sprite);
  GV_Sprite_AddImageGrid(Sprite, BossSprite.Page, BossSprite.Group, 0, 0, 128, 128);
  GV_Sprite_AddImageGrid(Sprite, BossSprite.Page, BossSprite.Group, 1, 0, 128, 128);
  GV_Sprite_AddImageGrid(Sprite, BossSprite.Page, BossSprite.Group, 0, 1, 128, 128);

  BossEntity[0] := GV_Entity_Create(Sprite, BossSprite.Page, BossSprite.Group);
  GV_Entity_SetFrameDelay(BossEntity[0], 3);
  GV_Entity_SetPos(BossEntity[0], 320, 240);
  GV_Entity_PolyPointTrace(BossEntity[0], 6, 11, 70);

  BossEntity[1] := GV_Entity_Create(Sprite, BossSprite.Page, BossSprite.Group);
  GV_Entity_SetFrameDelay(BossEntity[1], 3);
  GV_Entity_SetPos(BossEntity[1], 320, 240);
  GV_Entity_ScaleRel(BossEntity[1], -0.60);
  GV_Entity_PolyPointTrace(BossEntity[1], 6, 11, 70);

  GV_Audio_Open(GV_AppWindow_GetHandle);
  GV_Audio_SetMasterSfxVol(1.0);

  GV_MusicPlayer_InitSongList;
  GV_MusicPlayer_AddSongs('MUSIC');
  GV_MusicPlayer_AddSongs(MusicPath);

  GV_Input_Open(GV_AppWindow_GetHandle, Screen_Windowed);
  GV_Input_SetMousePos(320, 240);

  repeat
    GV_App_ProcessMessages;
    if not GV_RenderDevice_IsReady then continue;
    GV_RenderDevice_ClearFrame(GV_ClearFrame_Default, GV_Black);
    if GV_RenderDevice_StartFrame then
    begin

      GV_Font_Print(Font, 0, 0, GV_Green, '%d fps', [GV_Timer_FrameRate]);
      GV_Font_Print(Font, 0,12, GV_Green, 'Esc - Quit', []);

      GV_Entity_Render(BossEntity[0]);
      GV_Entity_RenderPolyPoint(BossEntity[0], GV_Blue, GV_RenderState_Blend);

      GV_Entity_Render(BossEntity[1]);
      GV_Entity_RenderPolyPoint(BossEntity[1], GV_Red, GV_RenderState_Blend);

      if Collided then
      begin
        GV_Font_Center(Font, 0, GV_Green, 'Polypoint Collision', []);
        GV_Font_Center(Font, 12, GV_Yellow, '[ X:%3.f, Y:%3.f ]', [CollidePos.X, CollidePos.Y]);
        GV_RenderDevice_DrawRect(CollidePos.X, CollidePos.Y, 10, 10, GV_White, GV_RenderState_Blend);
      end;

      GV_Font_Center(Font, 456, GV_Green, 'GameVision (tm) SDK Copyright (c) 1994-2003 Jarrod Davis Software', []);
      GV_Font_Center(Font, 468, GV_Green, 'Visit the GameVision SDK site at: www.gamevisionsdk.com', []);

      GV_RenderDevice_EndFrame;
    end;
    GV_RenderDevice_ShowFrame;

    GV_Input_Update;
    GV_Input_GetMousePosAbs(MousePos);
    //GV_Input_GetMousePosRel(MousePos);

    GV_Timer_Update;
    ElapsedTime := GV_Timer_ElapsedTime;

    GV_Entity_NextFrame(BossEntity[0], True, ElapsedTime);
    GV_Entity_Thrust(BossEntity[0], (2.0*ElapsedTime));
    GV_Entity_RotateRel(BossEntity[0], (1.5*ElapsedTime));

    GV_Entity_NextFrame(BossEntity[1], True, ElapsedTime);
    GV_Entity_SetPos(BossEntity[1], MousePos.X, MousePos.Y);
    GV_Entity_RotateRel(BossEntity[1], (-1.5*ElapsedTime));

    if GV_Entity_PolyPointCollide(BossEntity[0], BossEntity[1], @CollidePos) then
      begin
        Collided := True;
      end
    else
      begin
        Collided := False;
      end;

    if not GV_MusicPlayer_SongPlaying then
    begin
      GV_MusicPlayer_PlayRandomSong(False);
    end;

    if GV_Input_KeyHit(GV_KEY_M) then
    begin
      GV_MusicPlayer_PlayRandomSong(False);
    end;

    if GV_Input_KeyHit(GV_KEY_ESCAPE) then
    begin
      GV_App_Terminate;
    end;
    
  until GV_App_IsTerminated;

  GV_Input_Close;

  GV_Audio_Close;

  GV_Entity_Dispose(BossEntity[1]);
  GV_Entity_Dispose(BossEntity[0]);

  GV_Sprite_Dispose(Sprite);

  GV_Font_Dispose(Font);

  GV_RenderDevice_RestoreMode;

  GV_AppWindow_Close;

  GV_RezFile_CloseArchive(RezFile);

  SaveCfg;
  Demo_PostDone;
end.
