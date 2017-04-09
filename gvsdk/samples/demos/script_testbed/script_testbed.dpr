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
begin
  try
    GV_Init;
    try
      gvs_GVDLL_Register;
      GV_Script_RegisterDefaultColors;
                                            
      GV_Script_Init;
      GV_Script_AddCode('main', 'type TGVRect = record Left: Integer; Top: Integer; Right: Integer; Bottom: Integer; end;');
      GV_Script_AddCodeFromFile('script.pas', -1, 'script.pas');

      GV_Script_Compile;
      GV_Script_Run('script.pas');
    finally
      GV_Done;
    end;
  except
  end;
end.
