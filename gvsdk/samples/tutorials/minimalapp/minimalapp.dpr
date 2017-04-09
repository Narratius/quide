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
  SysUtils,
  common in '..\..\common\common.pas';

const
  SCREEN_CAPTION = 'Minimal App'; //@@ screen caption

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Initialize demo
procedure Demo_Init;
begin
  // call preinit first thing
  Demo_PreInit(SCREEN_CAPTION);

end;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Shutdown demo
procedure Demo_Done;
begin

  // call postdone last thing
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
