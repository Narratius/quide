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

{$R ..\..\samples.res} // resource file used by all samples

unit common;

interface

const
  // screen
  SCREEN_WIDTH    = 640; //@@ screen width
  SCREEN_HEIGHT   = 480; //@@ screen height

  // viewport
  VIEWPORT_X      = 120; //@@ viewport x
  VIEWPORT_Y      = 0;   //@@ viewport y
  VIEWPORT_WIDTH  = 400; //@@ viewport width
  VIEWPORT_HEIGHT = 480; //@@ viewport hegith

  // rezfile
  REZFILE_PATH    = '../../samples.rez'; //@@ rezfile relative path


var
  // screen
  Screen_Bpp     : Cardinal = 16;  //@@ screen bits per pixel
  Screen_Windowed: Boolean = True; //@@ screen windowed flag

  // rezfile
  RezFile        : Integer = -1;   //@@ rezfile handle

  // fonts
  Font           : array[0..2] of Integer = (-1,-1,-1);   //@@ font handles

  // textures
  Boss_Texture   : Integer = -1;   //@@ boss ship texture handle

  // audio
  Music_Path     : string;          //@@ music path


//@@ Parameters:
//     aCaption  - Timer value
//   Returns:
//     TRUE if preinit succeeds, FALSE if not
//   Description:
//     Performs demo pre initialization
function  Demo_PreInit(aCaption: string): Boolean;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Performs demo post shutdown
procedure Demo_PostDone;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Display demo copyright notice
procedure Demo_PrintCopyrightNotice;

implementation

uses
  Windows,
  GVDLL;

function Demo_PreInit(aCaption: string): Boolean;
var
  S: string;
begin
  // Assume PreInit will fail
  Result := False;

  // Lets check to see if this app is already running. If so, bring the
  // previous app to the forground and exit the current one. This function
  // will ONLY be able to bring the previous app to the front if it can
  // find the window with a caption equal to aCaption. This means that
  // currently all your windows and dialogs need to have the same caption.
  // This limitation will be removed in the future.
  if GV_App_AlreadyRunning(aCaption) then
  begin
    Exit; // exit if already running
  end;

  // GV needs DirectX 8.1 or higher runtime installed to operate. This
  // routine checks for specific DX 8.1 files so it's accurate.
  if not GV_DirectXInstalled then
  begin
    S := 'DirectX 8.1 or higher runtime is required for this application to operate' + #13 +
         'It will now terminate.' + #13#13         +
         'You can download the lastest runtimes at: www.microsoft.com/directx';
    MessageBox(0, PChar(S), PChar(aCaption), MB_OK);
    Exit; // exit if not found
  end;

  // You must call GV_Init now before using any GV command except:
  //   GV_App_AlreadyRunning and GV_DirectXInstalled
  // otherwise you will get an exception error. By calling allowing the
  // developer to manually call init, you now have more control over the
  // process. You can tell gv the level of logging perfered as well as being
  // able to have more flexablity for initialization in your applications.
  GV_Init(GV_LogFile_Priority_All);

  // GV manages all allocated resources and returns to you a handle for that
  // resource. So, we must tell GV to allocate space for them before any
  // resources are used. Remeber for textures, all interfaces that use them
  // will pull from the allocated texture pool (fonts, sprites, images) so
  // muse sure you set it high enough for your application needs. THe sprite
  // manager is able to define and handle all sprites in an application so
  // in general you will usally only have one in your application.
  GV_RezFile_Init(256);  // reserve space for rezfiles
  GV_Texture_Init(1024); // reserve space for textures
  GV_Font_Init(256);     // reserve space for fonts
  GV_Sprite_Init(256);   // reserve space for sprites
  GV_Image_Init(256);    // reserve space for images
  GV_Polygon_Init(256);  // reserve space for polygons
  GV_Entity_Init(256);   // reserve space for entities
  GV_GZFile_Init(256);   // reserve space for gzfiles

  // Init Timing. GV uses frame-based timing. It works by calculating
  // the elapsed time from frame to frame and they you can multiply the
  // elapsedtime value by the speed of your object to keep them moving
  // at the desired simulation rate. GV will try and maintain the
  // simulation up to aMaxElapsedTime. Note that timing in GV is totally
  // independend of the rest of the system so you are free to implement
  // any timing scheme that you desire. JDS has choose to implement
  // frame-base timing as a default timing scheme.
  GV_Timer_Init(35.0, 3.0);

  // PreInit was successfull
  Result := True;
end;

procedure Demo_PostDone;
begin
  // Release all managed allocated resources. Note the order of release.
  // Dependent resources must be free'ed first. Fonts, Sprites and Images
  // all depended on the texture interface so make sure you release
  // those before texture. Entity depends on sprite for example.
  GV_Entity_Done;
  GV_Font_Done;
  GV_Sprite_Done;
  GV_Image_Done;
  GV_Texture_Done;
  GV_Polygon_Done;
  GV_RezFile_Done;
  GV_GZFile_Done;

  // Totally Shutdown GV and shut down all resources. You would need to
  // call GV_Init again before calling any GV routines.
  GV_Done;
end;

procedure Demo_PrintCopyrightNotice;
begin
  GV_Font_Center(Font[0], 444, GV_Yellow, 'GameVision (tm) SDK', []);
  GV_Font_Center(Font[0], 456, GV_Yellow, '(c) 1994-2003 Jarrod Davis Software', []);
  GV_Font_Center(Font[0], 468, GV_Yellow, 'www.gamevisionsdk.com', []);
end;

end.
