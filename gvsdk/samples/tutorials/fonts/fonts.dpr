//=========================================================================
// GameVision ® SDK, Tools and Tutorials
// Copyright © 1994-2003 Jarrod Davis Software
// All Rights Reserved.
//-------------------------------------------------------------------------
// You are hereby granted the right to use GameVision and it's
// tools to produce your own applications without paying us any
// money, subject to the following restrictions:
//
// 1. You may not reverse engineer, or claim GameVision or it's tools
//    and tutorials as your own work.
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

// GVShareMem must be the first unit in your projects uses statement. GV now
// uses a shared memory manager which means memory can be shared between
// the GV DLL and the host application. If GVShareMem is not first, then an
// exception error will occur.

program gvsdk_demo;

uses
  GVShareMem, GVDLL,
  Windows,
  SysUtils,
  common in '..\..\common\common.pas';

const
  SCREEN_CAPTION = 'Fonts'; //@@ screen caption

var
  BuildFont  : Integer = -1;
  CustomFont : Integer = -1;


//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Save demo configuration
procedure Demo_SaveCfg;
begin
  // save cfg info
  GV_Ini_WriteString ('AUDIO',  'MusicPath', Music_Path);
  GV_Ini_WriteInteger('SCREEN', 'Bpp',        Screen_Bpp);
  GV_Ini_WriteBool   ('SCREEN', 'Windowed',   Screen_Windowed);
  GV_Ini_Flush;
end;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Load demo configuration
procedure Demo_LoadCfg;
begin
  // check if ini exist by seeing of a value exist
  if not GV_Ini_ValueExists('SCREEN', 'Bpp') then
  begin
    Demo_SaveCfg;
  end;

  // load cfg info
  Music_Path      := GV_Ini_ReadString ('AUDIO',  'MusicPath', '');
  Screen_Bpp      := GV_Ini_ReadInteger('SCREEN', 'Bpp',       16);
  Screen_Windowed := GV_Ini_ReadBool   ('SCREEN', 'Windowed',  True);
end;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Initialize demo
procedure Demo_Init;
begin
  // call preinit first thing
  if not Demo_PreInit(SCREEN_CAPTION) then
  begin
    MessageBox(0, 'Fatal Error', 'Failed to pre-init demo', MB_OK);
    Halt;
  end;

  // Load configuration
  Demo_LoadCfg;

  // Open a standard ZIP rezfile. You can use any of the zip managers
  // such as WinZip to manage your zip archives.
  RezFile := GV_RezFile_OpenArchive(REZFILE_PATH);

  // Set application icon. Since we are now using a rezfile, lets
  // grab the icon from it now. Just pass in the handle to rezfile.
  GV_App_SetIcon(RezFile, 'media/icons/mainicon.ico');

  // Create a fully qualified application window.
  // window attributes are:
  //  - client area set to specified width and height
  //  - single border, non-resizable, viewable on taskbar
  //  - system menu, minimize and restore
  GV_AppWindow_Open(SCREEN_CAPTION, SCREEN_WIDTH, SCREEN_HEIGHT);

  // Make application window visible.
  GV_AppWindow_Show;

  // Initalize graphics mode. _SetMode allows you to use any valid windows
  // handle so that if you need to render to a VCL based form you can. This
  // is good for making tools where you can pass the handle to your view panel
  // for example. In this case we will use the handle from our appwindow.
  // At startup GameVision as already enumrated your display modes so _SetMode
  // will attemp to find a mode that matches the params you have specified or
  // will find the closes match, else will generate an exception.
  // Bpp and refresh should be valid DirectX values.
  // Bpp should be 16 or 32.
  GV_RenderDevice_SetMode(
    GV_AppWindow_GetHandle, // window handle
    SCREEN_WIDTH,           // screen width
    SCREEN_HEIGHT,          // screen height
    SCREEN_BPP,             // screen bits per pixel
    Screen_Windowed,        // screen windowed flag
    GV_SwapEffect_Discard); // swap effect

  // Load rendered texture mapped fonts. GV fonts are made up of
  // a 256x256 texture that has the fonts characters and a .GVF file
  // that containes the rect data. When specifying a font name, be
  // sure the use the basename such as 'font0' rather than font0.png.
  Font[0] := GV_Font_Load(RezFile, 'media/fonts/font0');
  Font[1] := GV_Font_Load(RezFile, 'media/fonts/font1');
  Font[2] := GV_Font_Load(-1,      '../../media/fonts/font2');

 // Build a font on the fly. By default _Build will try and create an
  // antialised font. This will only work only on Window NT, 2000 and XP.
  // You have to make sure font smoothing is enabled in the control panel.
  // Windows ME may generate antialias font, but it has not been tested on
  // that OS. _Build will create a 256x256 texture to save the font pixels
  // on. If the specified font size is too large to contain all the chars,
  // an exception error will occure. The texture is save to a windows bitmap
  // file. You can use any paint program to enhance the image to suite your
  // needs. The final image must be saved as a PNG image. The.GVF file
  // contains the charactor rects and sizes. The base name of
  // the generated data must remain the same. (font.png, font.gvf).
  BuildFont := GV_Font_Build(
    'Arial',        // windows TrueType font name
    24,                  // font size
    GV_FontWeight_Normal,// font attribute (FW_NORMAL, FW_BOLD)
    False,               // make italic
    'buildfont');        // base name of saved font data

  // Lets Build a custom font. _LoadImage allows you to load in your texture
  // into the font object. It initially set the font rects to zero. You then
  // use _SetRect to define the top, left, right and bottom coords for each
  // character in texture space. Make sure the size of the texture can be
  // loaded by your video card. Its common to use a max texture size of 256x256
  // Printable characters range from 32-127.
  CustomFont := GV_Font_LoadImage(RezFile, GV_ColorKey, 'media/fonts/custom');

  // define the rects for each char
  GV_Font_SetRect(CustomFont, 'G',  0,  0,  15, 15);
  GV_Font_SetRect(CustomFont, 'A', 16,  0,  31, 15);
  GV_Font_SetRect(CustomFont, 'M', 32,  0,  47, 15);
  GV_Font_SetRect(CustomFont, 'E', 48,  0,  63, 15);
  GV_Font_SetRect(CustomFont, 'V', 64,  0,  79, 15);
  GV_Font_SetRect(CustomFont, 'I', 80,  0,  95, 15);
  GV_Font_SetRect(CustomFont, 'S', 96,  0, 111, 15);
  GV_Font_SetRect(CustomFont, 'I', 112, 0, 127, 15);
  GV_Font_SetRect(CustomFont, 'O', 128, 0, 143, 15);
  GV_Font_SetRect(CustomFont, 'N', 144, 0, 160, 15);

  // save this font along with the font rect data that can now be loaded and
  // used via the normal GV_Font_Load routine.
  GV_Font_Save(CustomFont, 'customfont');

end;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Shutdown demo
procedure Demo_Done;
begin
  // Free fonts
  GV_Font_Dispose(CustomFont);
  GV_Font_Dispose(BuildFont);
  GV_Font_Dispose(Font[2]);
  GV_Font_Dispose(Font[1]);
  GV_Font_Dispose(Font[0]);

  // Restore previouse desktop resolution
  GV_RenderDevice_RestoreMode;

  // Close application window
  GV_AppWindow_Close;

  // Close rezfile
  GV_RezFile_CloseArchive(RezFile);

  // Save configuration
  Demo_SaveCfg;

  // Call postdone last thing
  Demo_PostDone;
end;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Run demo
procedure Demo_Run;
begin
  repeat
    // Let windows update messages and run background tasks. Use this
    // function if your not using a VCL form based application.
    GV_App_ProcessMessages;

    // Check if display window and/or render device is ready. If not
    // continue to process windows messages.
    if not GV_RenderDevice_IsReady then continue;

    // Clear the current viewport area. In this case the whole screen
    // with a BLUE color. Here we clear both the Frame buffer and ZBuffer.
    GV_RenderDevice_ClearFrame(GV_ClearFrame_Default, GV_Black);

    // Tell GV to start accepting polygon data
    if GV_RenderDevice_StartFrame then
    begin
      // Display the frame rate in frames-per-second.
      GV_Font_Print(Font[0], 0, 0,  GV_Green, '%d fps', [GV_Timer_FrameRate]);
      GV_Font_Print(Font[0], 0, 12, GV_Green, 'Exit - ALT-F4', []);

      // Display different fonts
      GV_Font_Print(Font[0], 40, 50, GV_Yellow, 'GameVision supports textured fonts. You can generate any TrueType', []);
      GV_Font_Print(Font[0], 40, 62, GV_Yellow, 'Font on your computer to a texture which later can be loaded from', []);
      GV_Font_Print(Font[0], 40, 74, GV_Yellow, 'disk or from a RezFile. You can also create custom fonts.', []);

      GV_Font_Center(Font[0],   150, GV_Red, 'Font #1 (rezfile)', []);
      GV_Font_Center(Font[1],   160, GV_Yellow, 'Font #2 (rezfile)', []);
      GV_Font_Center(Font[2],   180, GV_Blue, 'Font #3 (disk)', []);
      GV_Font_Center(BuildFont, 215, GV_LtGray, 'Font #4 (built)', []);
      GV_Font_Center(CustomFont, 260, GV_Orange, 'GAMEVISION', []);
      GV_Font_Print(Font[0], 390, 260, GV_Orange, '[custom]', []);

      // Display footer
      GV_Font_Center(Font[0], SCREEN_HEIGHT-26, GV_Yellow, 'GameVision SDK (tm)  Copyright (c) 1994-2003 Jarrod Davis Software', []);
      GV_Font_Center(Font[0], SCREEN_HEIGHT-14, GV_Yellow, 'Visit the GameVision webite site at: www.gamevisionsdk.com', []);

      // Tell GV to stop accepting polygon data
      GV_RenderDevice_EndFrame;
    end;

    // Make current frame buffer visible
    GV_RenderDevice_ShowFrame;

    // Calculate the elapsed time since last frame and the current
    // framerate
    GV_Timer_Update;

    // loop until application has terminated either by closing an
    // AppWindow or calling GV_App_Terminate.
  until GV_App_IsTerminated;
end;

begin { --- program start ---- }
  // GV takes advantage of exception handling and this is the
  // most basic exception handling block for a GV application.
  try
    Demo_Init; // init
    try
      Demo_Run;  // run
    finally
      Demo_Done; // done
    end;
  except
  end;
end.
