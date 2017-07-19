//@@ Header to the GameVision.dll. GVScript import unit for GVDLL unit.

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
unit gvs_GVDLL;

interface

var
  
  //@@ GVScript GVDLL Namespace
  gvs_GVDLL_Namespace: Integer = -1;


//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Register GVDLL unit with the scripting system
procedure gvs_GVDLL_Register;

implementation

uses
  Classes,
  GVDLL, GVScript;

//procedure GV_Texture_Render(aTexture: Integer; aX: Single; aY: Single; aScale: Single; aAngle: Single; aColor: Cardinal; aRect: PGVRect; aRenderState: Cardinal);
procedure _GV_Texture_Render(aProc: Pointer);
var
  aVar        : Variant;
  aTexture    : Integer;
  aX          : Double;
  aY          : Double;
  aScale      : Double;
  aAngle      : Double;
  aColor      : Cardinal;
  aRect       : TGVRect;
  aRectP      : PGVRect;
  aRenderState: Cardinal;
begin
  // get params
  aTexture := GV_Script_GetStdRoutineParam(aProc, 0);
  aX       := GV_Script_GetStdRoutineParam(aProc, 1);
  aY       := GV_Script_GetStdRoutineParam(aProc, 2);
  aScale   := GV_Script_GetStdRoutineParam(aProc, 3);
  aAngle   := GV_Script_GetStdRoutineParam(aProc, 4);
  aColor   := GV_Script_GetStdRoutineParam(aProc, 5);

  // get rect pointer param
  aRectP   := nil;
  aVar     := GV_Script_GetStdRoutineParam(aProc, 6);
  if GV_Script_IsObject(aVar) then
  begin
    aRect.Left   := GV_Script_GetObjectPropertyByIndex(aVar, 0);
    aRect.Top    := GV_Script_GetObjectPropertyByIndex(aVar, 1);
    aRect.Right  := GV_Script_GetObjectPropertyByIndex(aVar, 2);
    aRect.Bottom := GV_Script_GetObjectPropertyByIndex(aVar, 3);
    aRectP       := @aRect;
  end;

  // get render state param
  aRenderState := GV_Script_GetStdRoutineParam(aProc, 7);

  // render texture
  GV_Texture_Render(aTexture, aX, aY, aScale, aAngle, aColor, aRectP, aRenderState);
end;

//function GV_Texture_Lock(aTexture: Integer; aRect: PGVRect; aPitch: PInteger): Pointer;
procedure _GV_Texture_Lock(aProc: Pointer);
var
  aVar    : Variant;
  aTexture: Integer;
  aRect   : TGVRect;
  aRectP  : PGVRect;
  aPitch  : Integer;
  aPitchP : PInteger;
  //aResult :
begin
  // get texture param
  aTexture := GV_Script_GetStdRoutineParam(aProc, 0);

  // get rect pointer param
  aRectP   := nil;
  aVar     := GV_Script_GetStdRoutineParam(aProc, 1);
  if GV_Script_IsObject(aVar) then
  begin
    aRect.Left   := GV_Script_GetObjectPropertyByIndex(aVar, 0);
    aRect.Top    := GV_Script_GetObjectPropertyByIndex(aVar, 1);
    aRect.Right  := GV_Script_GetObjectPropertyByIndex(aVar, 2);
    aRect.Bottom := GV_Script_GetObjectPropertyByIndex(aVar, 3);
    aRectP       := @aRect;
  end;

  // get pitch param
  aPitchP  := nil;
  aVar     := GV_Script_GetStdRoutineParam(aProc, 2);
  if aVar <> varNull then
  begin
    aPitch  := aVar;
    aPitchP := @aPitch;
  end;

  // lock texture
  GV_Texture_Lock(aTexture, aRectP, aPitchP);

  // return aPitchP pointer back to script
  if aPitchP <> nil then
  begin
    GV_Script_SetStdRoutineParam(aProc, 2, aPitch);
  end;

  // return pointer to texture back to script

end;


{ === Register Routine ================================================== }
procedure gvs_GVDLL_Register;
var
  H: Integer;
begin

  H := GV_Script_DefineNamespace('GVDLL');
  gvs_GVDLL_Namespace := H;

  //GV_Script_AddCode('gvdll', 'type TGVRect = record Left: Integer; Top: Integer; Right: Integer; Bottom: Integer; end;');

  { global routines }

  GV_Script_DefineRoutine('procedure GV_Init(aLogFilePriority: Byte);', @GV_Init, H);
  GV_Script_DefineRoutine('procedure GV_Done;', @GV_Done, H);
  GV_Script_DefineRoutine('procedure GV_Reset;', @GV_Reset, H);
  GV_Script_DefineRoutine('function GV_LogFile_GetPath: string;', @GV_LogFile_GetPath, H);
  GV_Script_DefineRoutine('procedure GV_LogFile_Erase;', @GV_LogFile_Erase, H);
  GV_Script_DefineRoutine('procedure GV_LogFile_SetPriority(aPriority: Byte);', @GV_LogFile_SetPriority, H);
  GV_Script_DefineRoutine('function GV_LogFile_GetPriority: Byte;', @GV_LogFile_GetPriority, H);
  GV_Script_DefineRoutine('procedure GV_LogFile_Write(aPriority: Byte; const aMsg: string; const aArgs: array of Array of Const; const aLoc: string);', @GV_LogFile_Write, H);
  GV_Script_DefineRoutine('procedure GV_Error_Abort(const aMsg: string; const aArgs: array of Array of Const; const aLoc: string);', @GV_Error_Abort, H);
  GV_Script_DefineRoutine('function GV_CmdLine_GetStartPath: string;', @GV_CmdLine_GetStartPath, H);
  GV_Script_DefineRoutine('procedure GV_CmdLine_GotoStartPath;', @GV_CmdLine_GotoStartPath, H);
  GV_Script_DefineRoutine('function GV_Color_Make(aRed: Byte; aGreen: Byte; aBlue: Byte; aAlpha: Byte): Cardinal;', @GV_Color_Make, H);
  GV_Script_DefineRoutine('procedure GV_Color_Set(var aColor: Cardinal; aRed: PByte; aGreen: PByte; aBlue: PByte; aAlpha: PByte);', @GV_Color_Set, H);
  GV_Script_DefineRoutine('procedure GV_Color_Get(aColor: Cardinal; aRed: PByte; aGreen: PByte; aBlue: PByte; aAlpha: PByte);', @GV_Color_Get, H);
  GV_Script_DefineRoutine('procedure GV_Timer_Init(aDesiredFPS: Single; aMaxElapsedTime: Single);', @GV_Timer_Init, H);
  GV_Script_DefineRoutine('function GV_Timer_GetTickCount: Cardinal;', @GV_Timer_GetTickCount, H);
  GV_Script_DefineRoutine('procedure GV_Timer_Update;', @GV_Timer_Update, H);
  GV_Script_DefineRoutine('function GV_Timer_ElapsedTime: Single;', @GV_Timer_ElapsedTime, H);
  GV_Script_DefineRoutine('function GV_Timer_FrameRate: Cardinal;', @GV_Timer_FrameRate, H);
  GV_Script_DefineRoutine('function GV_Timer_FrameElapsed(var aTimer: Single; aFrames: Single; aElapsedTime: Single): Boolean;', @GV_Timer_FrameElapsed, H);
  GV_Script_DefineRoutine('procedure GV_RezFile_Init(aMaxCount: Cardinal);', @GV_RezFile_Init, H);
  GV_Script_DefineRoutine('procedure GV_RezFile_Done;', @GV_RezFile_Done, H);
  GV_Script_DefineRoutine('function GV_RezFile_OpenArchive(const aPath: string): Integer;', @GV_RezFile_OpenArchive, H);
  GV_Script_DefineRoutine('procedure GV_RezFile_CloseArchive(var aRezFile: Integer);', @GV_RezFile_CloseArchive, H);
  GV_Script_DefineRoutine('procedure GV_RezFile_OpenFile(aRezFile: Integer; const aPath: string);', @GV_RezFile_OpenFile, H);
  GV_Script_DefineRoutine('procedure GV_RezFile_CloseFile(aRezFile: Integer);', @GV_RezFile_CloseFile, H);
  GV_Script_DefineRoutine('function GV_RezFile_FileSize(aRezFile: Integer): Cardinal;', @GV_RezFile_FileSize, H);
  GV_Script_DefineRoutine('function GV_RezFile_ReadFile(aRezFile: Integer; aBuffer: Pointer; aLen: Cardinal): Cardinal;', @GV_RezFile_ReadFile, H);
  GV_Script_DefineRoutine('procedure GV_RezFile_SeekFile(aRezFile: Integer; aLen: Cardinal; aOrigin: Cardinal);', @GV_RezFile_SeekFile, H);
  GV_Script_DefineRoutine('function GV_RezFile_FilePos(aRezFile: Integer): Integer;', @GV_RezFile_FilePos, H);
  GV_Script_DefineRoutine('function GV_RezFile_EndOfFile(aRezFile: Integer): Boolean;', @GV_RezFile_EndOfFile, H);
  GV_Script_DefineRoutine('procedure GV_App_ProcessMessages;', @GV_App_ProcessMessages, H);
  GV_Script_DefineRoutine('procedure GV_App_Terminate;', @GV_App_Terminate, H);
  GV_Script_DefineRoutine('function GV_App_IsTerminated: Boolean;', @GV_App_IsTerminated, H);
  GV_Script_DefineRoutine('procedure GV_App_SetIcon(aRezFile: Integer; const aPath: string);', @GV_App_SetIcon, H);
  GV_Script_DefineRoutine('function GV_App_AlreadyRunning(aWindowCaption: string): Boolean;', @GV_App_AlreadyRunning, H);
  GV_Script_DefineRoutine('procedure GV_App_SetOnActivateEvent(aProc: TGVAppActivateEvent);', @GV_App_SetOnActivateEvent, H);
  GV_Script_DefineRoutine('function GV_App_GetOnActivateEvent: TGVAppActivateEvent;', @GV_App_GetOnActivateEvent, H);
  GV_Script_DefineRoutine('procedure GV_App_OnActivate(aActive: Boolean);', @GV_App_OnActivate, H);
  GV_Script_DefineRoutine('procedure GV_AppWindow_Open(const aCaption: string; aWidth: Cardinal; aHeight: Cardinal);', @GV_AppWindow_Open, H);
  GV_Script_DefineRoutine('procedure GV_AppWindow_Close;', @GV_AppWindow_Close, H);
  GV_Script_DefineRoutine('function GV_AppWindow_IsOpen: Boolean;', @GV_AppWindow_IsOpen, H);
  GV_Script_DefineRoutine('procedure GV_AppWindow_Show;', @GV_AppWindow_Show, H);
  GV_Script_DefineRoutine('procedure GV_AppWindow_GetSize(aWidth: PCardinal; aHeight: PCardinal);', @GV_AppWindow_GetSize, H);
  GV_Script_DefineRoutine('function GV_AppWindow_GetHandle: Cardinal;', @GV_AppWindow_GetHandle, H);
  GV_Script_DefineRoutine('procedure GV_AppWindow_ShowCursor(aShow: Boolean);', @GV_AppWindow_ShowCursor, H);
  GV_Script_DefineRoutine('procedure GV_AppWindow_GetMousePos(var aPos: TGVVector);', @GV_AppWindow_GetMousePos, H);
  GV_Script_DefineRoutine('procedure GV_Input_Open(aHandle: Cardinal; aWindowed: Boolean);', @GV_Input_Open, H);
  GV_Script_DefineRoutine('procedure GV_Input_Close;', @GV_Input_Close, H);
  GV_Script_DefineRoutine('function GV_Input_IsOpen: Boolean;', @GV_Input_IsOpen, H);
  GV_Script_DefineRoutine('procedure GV_Input_Update;', @GV_Input_Update, H);
  GV_Script_DefineRoutine('procedure GV_Input_Reset;', @GV_Input_Reset, H);
  GV_Script_DefineRoutine('procedure GV_Input_Acquire(aAcquire: Boolean);', @GV_Input_Acquire, H);
  GV_Script_DefineRoutine('function GV_Input_AscKey: Integer;', @GV_Input_AscKey, H);
  GV_Script_DefineRoutine('function GV_Input_ScanCodeToAsc(aCode: Byte): Integer;', @GV_Input_ScanCodeToAsc, H);
  GV_Script_DefineRoutine('function GV_Input_KeyPressed(aCode: Byte): Boolean;', @GV_Input_KeyPressed, H);
  GV_Script_DefineRoutine('function GV_Input_KeyReleased(aCode: Byte): Boolean;', @GV_Input_KeyReleased, H);
  GV_Script_DefineRoutine('function GV_Input_KeyHit(aCode: Byte): Boolean;', @GV_Input_KeyHit, H);
  GV_Script_DefineRoutine('function GV_Input_MousePressed(aButton: Byte): Boolean;', @GV_Input_MousePressed, H);
  GV_Script_DefineRoutine('function GV_Input_MouseReleased(aButton: Byte): Boolean;', @GV_Input_MouseReleased, H);
  GV_Script_DefineRoutine('function GV_Input_MouseHit(aButton: Byte): Boolean;', @GV_Input_MouseHit, H);
  GV_Script_DefineRoutine('procedure GV_Input_GetMousePosRel(var aPos: TGVVector);', @GV_Input_GetMousePosRel, H);
  GV_Script_DefineRoutine('procedure GV_Input_GetMousePosAbs(var aPos: TGVVector);', @GV_Input_GetMousePosAbs, H);
  GV_Script_DefineRoutine('procedure GV_Input_SetMousePos(aX: Integer; aY: Integer);', @GV_Input_SetMousePos, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_GetAdapterCount: Cardinal;', @GV_RenderDevice_GetAdapterCount, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_GetDeviceCount(aAdapterNum: Cardinal): Cardinal;', @GV_RenderDevice_GetDeviceCount, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_GetAdapterInfo(aNum: Cardinal; var aInfo: TGVDisplayAdapterInfo);', @GV_RenderDevice_GetAdapterInfo, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_GetDeviceInfo(aAdapter: Cardinal; aDevice: Cardinal; var aInfo: TGVDisplayDeviceInfo);', @GV_RenderDevice_GetDeviceInfo, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_GetModeCount(aAdapter: Cardinal; aDevice: Cardinal): Cardinal;', @GV_RenderDevice_GetModeCount, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_GetModeInfo(aAdapter: Cardinal; aDevice: Cardinal; aMode: Cardinal; var aInfo: TGVDisplayModeInfo);', @GV_RenderDevice_GetModeInfo, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_ValidMode(aWidth: Cardinal; aHeight: Cardinal; aBpp: Cardinal): Boolean;', @GV_RenderDevice_ValidMode, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_SetMode(aHandle: Cardinal; aWidth: Cardinal; aHeight: Cardinal; aBpp: Cardinal; aWindowed: Boolean; aSwapEffect: Cardinal);', @GV_RenderDevice_SetMode, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_ModeIsSet: Boolean;', @GV_RenderDevice_ModeIsSet, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_RestoreMode;', @GV_RenderDevice_RestoreMode, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_IsReady: Boolean;', @GV_RenderDevice_IsReady, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_GetHandle: Cardinal;', @GV_RenderDevice_GetHandle, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_IsWindowed: Boolean;', @GV_RenderDevice_IsWindowed, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_SetViewport(aX: Cardinal; aY: Cardinal; aWidth: Cardinal; aHeight: Cardinal);', @GV_RenderDevice_SetViewport, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_ResetViewport;', @GV_RenderDevice_ResetViewport, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_GetViewport(aX: PCardinal; aY: PCardinal; aWidth: PCardinal; aHeight: PCardinal);', @GV_RenderDevice_GetViewport, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_SetRenderState(aRenderState: Cardinal);', @GV_RenderDevice_SetRenderState, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_GetRenderState: Cardinal;', @GV_RenderDevice_GetRenderState, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_ClearFrame(aFlags: Cardinal; aColor: Cardinal);', @GV_RenderDevice_ClearFrame, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_StartFrame: Boolean;', @GV_RenderDevice_StartFrame, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_EndFrame;', @GV_RenderDevice_EndFrame, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_ShowFrame;', @GV_RenderDevice_ShowFrame, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_SaveFrame(const aPath: string);', @GV_RenderDevice_SaveFrame, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_DrawLine(aX0: Single; aY0: Single; aX1: Single; aY1: Single; aColor: Cardinal; aRenderState: Cardinal);', @GV_RenderDevice_DrawLine, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_DrawRect(aX: Single; aY: Single; aWidth: Single; aHeight: Single; aColor: Cardinal; aRenderState: Cardinal);', @GV_RenderDevice_DrawRect, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_DrawPixel(aX: Single; aY: Single; aColor: Cardinal; aRenderState: Cardinal);', @GV_RenderDevice_DrawPixel, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_DrawCircle(aX: Single; aY: Single; aRadius: Single; aColor: Cardinal; aRenderState: Cardinal; aFilled: Boolean);', @GV_RenderDevice_DrawCircle, H);
  GV_Script_DefineRoutine('function GV_RenderDevice_GetAvailableTextureMem: Cardinal;', @GV_RenderDevice_GetAvailableTextureMem, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_GetDirect3D(out aD3D: IInterface);', @GV_RenderDevice_GetDirect3D, H);
  GV_Script_DefineRoutine('procedure GV_RenderDevice_GetD3DDevice(out aD3DDevice: IInterface);', @GV_RenderDevice_GetD3DDevice, H);
  GV_Script_DefineRoutine('procedure GV_Points_Init(aTotal: Cardinal);', @GV_Points_Init, H);
  GV_Script_DefineRoutine('procedure GV_Points_Done;', @GV_Points_Done, H);
  GV_Script_DefineRoutine('procedure GV_Points_SetCount(aCount: Cardinal);', @GV_Points_SetCount, H);
  GV_Script_DefineRoutine('procedure GV_Points_GetSize(aTotal: PCardinal; aCount: PCardinal);', @GV_Points_GetSize, H);
  GV_Script_DefineRoutine('procedure GV_Points_SetPoint(aIndex: Cardinal; aX: PSingle; aY: PSingle; aColor: PCardinal);', @GV_Points_SetPoint, H);
  GV_Script_DefineRoutine('procedure GV_Points_GetPoint(aIndex: Cardinal; aX: PSingle; aY: PSingle; aColor: PCardinal);', @GV_Points_GetPoint, H);
  GV_Script_DefineRoutine('procedure GV_Points_Render(aRenderState: Cardinal);', @GV_Points_Render, H);
  GV_Script_DefineRoutine('procedure GV_Points_RenderRange(aFirst: Cardinal; aLast: Cardinal; aRenderState: Cardinal);', @GV_Points_RenderRange, H);
  GV_Script_DefineRoutine('procedure GV_Texture_Init(aMaxCount: Cardinal);', @GV_Texture_Init, H);
  GV_Script_DefineRoutine('procedure GV_Texture_Done;', @GV_Texture_Done, H);
  GV_Script_DefineRoutine('function GV_Texture_Load(aRezFile: Integer; aColorKey: Cardinal; const aPath: string): Integer;', @GV_Texture_Load, H);
  GV_Script_DefineRoutine('procedure GV_Texture_Dispose(var aTexture: Integer);', @GV_Texture_Dispose, H);
  GV_Script_DefineRoutine('procedure GV_Texture_DisposeAll;', @GV_Texture_DisposeAll, H);

  //GV_Script_DefineRoutine('procedure GV_Texture_Render(aTexture: Integer; aX: Single; aY: Single; aScale: Single; aAngle: Single; aColor: Cardinal; aRect: PGVRect; aRenderState: Cardinal);', @GV_Texture_Render, H);
  GV_Script_DefineStdRoutine('GV_Texture_Render', _GV_Texture_Render, 8, H);

  GV_Script_DefineRoutine('procedure GV_Texture_RenderSized(aTexture: Integer; aX: Single; aY: Single; aWidth: Single; aHeight: Single; aColor: Cardinal; aRenderState: Cardinal);', @GV_Texture_RenderSized, H);
  GV_Script_DefineRoutine('procedure GV_Texture_RenderRect(aTexture: Integer; aX: Single; aY: Single; aRect: PGVRect; aColor: Cardinal; aRenderState: Cardinal);', @GV_Texture_RenderRect, H);
  GV_Script_DefineRoutine('procedure GV_Texture_RenderRectScaled(aTexture: Integer; aX: Single; aY: Single; aRect: PGVRect; aXScale: Single; aYScale: Single; aColor: Cardinal; aRenderState: Cardinal);', @GV_Texture_RenderRectScaled, H);
  GV_Script_DefineRoutine('procedure GV_Texture_Save(aTexture: Integer; const aPath: string);', @GV_Texture_Save, H);

  //GV_Script_DefineRoutine('function GV_Texture_Lock(aTexture: Integer; aRect: PGVRect; aPitch: PInteger): Pointer;', @GV_Texture_Lock, H);
  GV_Script_DefineStdRoutine('GV_Texture_Lock', _GV_Texture_Lock, 3, H);

  GV_Script_DefineRoutine('procedure GV_Texture_Unlock(aTexture: Integer);', @GV_Texture_Unlock, H);
  GV_Script_DefineRoutine('procedure GV_Texture_GetSize(aTexture: Integer; aWidth: PCardinal; aHeight: PCardinal);', @GV_Texture_GetSize, H);
  GV_Script_DefineRoutine('procedure GV_Texture_SetPixel(aTexture: Integer; aX: Integer; aY: Integer; aColor: Cardinal);', @GV_Texture_SetPixel, H);
  GV_Script_DefineRoutine('function GV_Texture_GetPixel(aTexture: Integer; aX: Integer; aY: Integer): Cardinal;', @GV_Texture_GetPixel, H);
  GV_Script_DefineRoutine('procedure GV_Texture_GetD3DTexture(aTexture: Integer; out aD3DTexture: IInterface);', @GV_Texture_GetD3DTexture, H);
  GV_Script_DefineRoutine('function GV_Texture_Alloc(aWidth: Cardinal; aHeight: Cardinal): Integer;', @GV_Texture_Alloc, H);
  GV_Script_DefineRoutine('procedure GV_Font_Init(aMaxCount: Cardinal);', @GV_Font_Init, H);
  GV_Script_DefineRoutine('procedure GV_Font_Done;', @GV_Font_Done, H);
  GV_Script_DefineRoutine('procedure GV_Font_Dispose(var aFont: Integer);', @GV_Font_Dispose, H);
  GV_Script_DefineRoutine('procedure GV_Font_DisposeAll;', @GV_Font_DisposeAll, H);
  GV_Script_DefineRoutine('procedure GV_Font_Save(aFont: Integer; const aBaseName: string);', @GV_Font_Save, H);
  GV_Script_DefineRoutine('function GV_Font_Build(const aFontName: string; aHeight: Integer; aWeight: Integer; Italic: Boolean; const aSaveName: string): Integer;', @GV_Font_Build, H);
  GV_Script_DefineRoutine('function GV_Font_Load(aRezFile: Integer; const aBaseName: string): Integer;', @GV_Font_Load, H);
  GV_Script_DefineRoutine('procedure GV_Font_AdjustRect(aFont: Integer; aC: Char; aX1: Integer; aY1: Integer; ax2: Integer; ay2: Integer);', @GV_Font_AdjustRect, H);
  GV_Script_DefineRoutine('function GV_Font_StrWidth(aFont: Integer; const aMsg: string; const aArgs: array of Array of Const): Integer;', @GV_Font_StrWidth, H);
  GV_Script_DefineRoutine('function GV_Font_StrHeight(aFont: Integer; const aMsg: string; const aArgs: array of Array of Const): Integer;', @GV_Font_StrHeight, H);
  GV_Script_DefineRoutine('procedure GV_Font_Print(aFont: Integer; aX: Single; aY: Single; aColor: Cardinal; const aMsg: string; const aArgs: array of Array of Const);', @GV_Font_Print, H);
  GV_Script_DefineRoutine('procedure GV_Font_PrintY(aFont: Integer; aX: Single; var aY: Single; aHeight: Cardinal; aColor: Cardinal; const aMsg: string; const aArgs: array of Array of Const);', @GV_Font_PrintY, H);
  GV_Script_DefineRoutine('procedure GV_Font_Center(aFont: Integer; aY: Single; aColor: Cardinal; const aMsg: string; const aArgs: array of Array of Const);', @GV_Font_Center, H);
  GV_Script_DefineRoutine('function GV_Font_GetTexture(aFont: Integer): Integer;', @GV_Font_GetTexture, H);
  GV_Script_DefineRoutine('function GV_Font_LoadImage(aRezFile: Integer; aColorKey: Cardinal; const aPath: string): Integer;', @GV_Font_LoadImage, H);
  GV_Script_DefineRoutine('procedure GV_Font_GetRect(aFont: Integer; aC: Char; aLeft: PInteger; aTop: PInteger; aRight: PInteger; aBottom: PInteger);', @GV_Font_GetRect, H);
  GV_Script_DefineRoutine('procedure GV_Font_SetRect(aFont: Integer; aC: Char; aLeft: Integer; aTop: Integer; aRight: Integer; aBottom: Integer);', @GV_Font_SetRect, H);
  GV_Script_DefineRoutine('procedure GV_Sprite_Init(aMaxCount: Cardinal);', @GV_Sprite_Init, H);
  GV_Script_DefineRoutine('procedure GV_Sprite_Done;', @GV_Sprite_Done, H);
  GV_Script_DefineRoutine('procedure GV_Sprite_Dispose(var aSprite: Integer);', @GV_Sprite_Dispose, H);
  GV_Script_DefineRoutine('procedure GV_Sprite_DisposeAll;', @GV_Sprite_DisposeAll, H);
  GV_Script_DefineRoutine('function GV_Sprite_Create: Integer;', @GV_Sprite_Create, H);
  GV_Script_DefineRoutine('function GV_Sprite_LoadPage(aSprite: Integer; aRezFile: Integer; aColorKey: Cardinal; const aPath: string): Cardinal;', @GV_Sprite_LoadPage, H);
  GV_Script_DefineRoutine('function GV_Sprite_AddGroup(aSprite: Integer): Cardinal;', @GV_Sprite_AddGroup, H);
  GV_Script_DefineRoutine('function GV_Sprite_AddImageRect(aSprite: Integer; aPage: Cardinal; aGroup: Cardinal; aRect: PGVRect): Cardinal;', @GV_Sprite_AddImageRect, H);
  GV_Script_DefineRoutine('function GV_Sprite_AddImageGrid(aSprite: Integer; aPage: Cardinal; aGroup: Cardinal; aGridX: Cardinal; aGridY: Cardinal; aGridWidth: Cardinal; aGridHeight: Cardinal): Cardinal;', @GV_Sprite_AddImageGrid, H);
  GV_Script_DefineRoutine('function GV_Sprite_GetImageCount(aSprite: Integer; aGroup: Cardinal): Cardinal;', @GV_Sprite_GetImageCount, H);
  GV_Script_DefineRoutine('function GV_Sprite_GetImageWidth(aSprite: Integer; aNum: Cardinal; aGroup: Cardinal): Cardinal;', @GV_Sprite_GetImageWidth, H);
  GV_Script_DefineRoutine('function GV_Sprite_GetImageHeight(aSprite: Integer; aNum: Cardinal; aGroup: Cardinal): Cardinal;', @GV_Sprite_GetImageHeight, H);
  GV_Script_DefineRoutine('procedure GV_Sprite_RenderImage(aSprite: Integer; aNum: Cardinal; aGroup: Cardinal; aX: Single; aY: Single; aScale: Single; aAngle: Single; aColor: Cardinal; aRect: PGVRect; aRenderState: Cardinal);', @GV_Sprite_RenderImage, H);
  GV_Script_DefineRoutine('procedure GV_Sprite_RenderImageSized(aSprite: Integer; aNum: Cardinal; aGroup: Cardinal; aX: Single; aY: Single; aWidth: Single; aHeight: Single; aColor: Cardinal; aRenderState: Cardinal);', @GV_Sprite_RenderImageSized, H);
  GV_Script_DefineRoutine('procedure GV_Sprite_RenderImageRect(aSprite: Integer; aNum: Cardinal; aGroup: Cardinal; aX: Single; aY: Single; aRect: PGVRect; aColor: Cardinal; aRenderState: Cardinal);', @GV_Sprite_RenderImageRect, H);
  GV_Script_DefineRoutine('function GV_Sprite_GetTexture(aSprite: Integer; aNum: Cardinal; aGroup: Cardinal): Integer;', @GV_Sprite_GetTexture, H);
  GV_Script_DefineRoutine('procedure GV_Image_Init(aMaxCount: Cardinal);', @GV_Image_Init, H);
  GV_Script_DefineRoutine('procedure GV_Image_Done;', @GV_Image_Done, H);
  GV_Script_DefineRoutine('procedure GV_Image_Dispose(var aImage: Integer);', @GV_Image_Dispose, H);
  GV_Script_DefineRoutine('procedure GV_Image_DisposeAll;', @GV_Image_DisposeAll, H);
  GV_Script_DefineRoutine('function GV_Image_Load(aRezFile: Integer; aColorKey: Cardinal; const aPath: string; aTileWidth: Cardinal; aTileHeight: Cardinal): Integer;', @GV_Image_Load, H);
  GV_Script_DefineRoutine('function GV_Image_GrabFrame(aTileWidth: Cardinal; aTileHeight: Cardinal): Integer;', @GV_Image_GrabFrame, H);
  GV_Script_DefineRoutine('procedure GV_Image_Render(aImage: Integer; aX: Single; aY: Single; aColor: Cardinal; aRenderState: Cardinal);', @GV_Image_Render, H);
  GV_Script_DefineRoutine('function GV_Image_GetTextureCount(aImage: Integer): Cardinal;', @GV_Image_GetTextureCount, H);
  GV_Script_DefineRoutine('function GV_Image_GetTexture(aImage: Integer; aNum: Cardinal): Integer;', @GV_Image_GetTexture, H);
  GV_Script_DefineRoutine('procedure GV_Polygon_Init(aMaxCount: Cardinal);', @GV_Polygon_Init, H);
  GV_Script_DefineRoutine('procedure GV_Polygon_Done;', @GV_Polygon_Done, H);
  GV_Script_DefineRoutine('procedure GV_Polygon_Dispose(var aPolygon: Integer);', @GV_Polygon_Dispose, H);
  GV_Script_DefineRoutine('procedure GV_Polygon_DisposeAll;', @GV_Polygon_DisposeAll, H);
  GV_Script_DefineRoutine('function GV_Polygon_Create: Integer;', @GV_Polygon_Create, H);
  GV_Script_DefineRoutine('procedure GV_Polygon_AddLocalPoint(aPolygon: Integer; aX: Single; aY: Single; aVisible: Boolean);', @GV_Polygon_AddLocalPoint, H);
  GV_Script_DefineRoutine('procedure GV_Polygon_Render(aPolygon: Integer; aX: Single; aY: Single; aScale: Single; aAngle: Single; aColor: Cardinal; aRenderState: Cardinal);', @GV_Polygon_Render, H);
  GV_Script_DefineRoutine('function GV_Polygon_IsSegmentVisible(aPolygon: Integer; aIndex: Cardinal): Boolean;', @GV_Polygon_IsSegmentVisible, H);
  GV_Script_DefineRoutine('procedure GV_Polygon_SetSegmentVisible(aPolygon: Integer; aIndex: Cardinal; aVisible: Boolean);', @GV_Polygon_SetSegmentVisible, H);
  GV_Script_DefineRoutine('function GV_Polygon_GetWorldPoint(aPolygon: Integer; aIndex: Cardinal): PGVVector;', @GV_Polygon_GetWorldPoint, H);
  GV_Script_DefineRoutine('function GV_Polygon_GetPointCount(aPolygon: Integer): Cardinal;', @GV_Polygon_GetPointCount, H);
  GV_Script_DefineRoutine('function GV_Polygon_GetLocalPoint(aPolygon: Integer; aIndex: Cardinal): PGVVector;', @GV_Polygon_GetLocalPoint, H);
  GV_Script_DefineRoutine('procedure GV_Entity_Init(aMaxCount: Cardinal);', @GV_Entity_Init, H);
  GV_Script_DefineRoutine('procedure GV_Entity_Done;', @GV_Entity_Done, H);
  GV_Script_DefineRoutine('procedure GV_Entity_Dispose(var aEntity: Integer);', @GV_Entity_Dispose, H);
  GV_Script_DefineRoutine('procedure GV_Entity_DisposeAll;', @GV_Entity_DisposeAll, H);
  GV_Script_DefineRoutine('function GV_Entity_Create(aSprite: Integer; aPage: Cardinal; aGroup: Cardinal): Integer;', @GV_Entity_Create, H);
  GV_Script_DefineRoutine('procedure GV_Entity_GetSize(aEntity: Integer; aWidth: PSingle; aHeight: PSingle; aRadius: PSingle);', @GV_Entity_GetSize, H);
  GV_Script_DefineRoutine('function GV_Entity_GetFrameCount(aEntity: Integer): Cardinal;', @GV_Entity_GetFrameCount, H);
  GV_Script_DefineRoutine('procedure GV_Entity_SetFrame(aEntity: Integer; aFrame: Cardinal);', @GV_Entity_SetFrame, H);
  GV_Script_DefineRoutine('function GV_Entity_GetFrame(aEntity: Integer): Cardinal;', @GV_Entity_GetFrame, H);
  GV_Script_DefineRoutine('procedure GV_Entity_SetFrameDelay(aEntity: Integer; aFrameDelay: Single);', @GV_Entity_SetFrameDelay, H);
  GV_Script_DefineRoutine('function GV_Entity_GetFrameDelay(aEntity: Integer): Single;', @GV_Entity_GetFrameDelay, H);
  GV_Script_DefineRoutine('function GV_Entity_NextFrame(aEntity: Integer; aLoop: Boolean; aElapsedTime: Single): Boolean;', @GV_Entity_NextFrame, H);
  GV_Script_DefineRoutine('function GV_Entity_PrevFrame(aEntity: Integer; aLoop: Boolean; aElapsedTime: Single): Boolean;', @GV_Entity_PrevFrame, H);
  GV_Script_DefineRoutine('procedure GV_Entity_SetPos(aEntity: Integer; aX: Single; aY: Single);', @GV_Entity_SetPos, H);
  GV_Script_DefineRoutine('procedure GV_Entity_GetPos(aEntity: Integer; aX: PSingle; aY: PSingle);', @GV_Entity_GetPos, H);
  GV_Script_DefineRoutine('procedure GV_Entity_Move(aEntity: Integer; aX: Single; aY: Single);', @GV_Entity_Move, H);
  GV_Script_DefineRoutine('procedure GV_Entity_Thrust(aEntity: Integer; aSpeed: Single);', @GV_Entity_Thrust, H);
  GV_Script_DefineRoutine('procedure GV_Entity_SetRenderState(aEntity: Integer; aRenderState: Cardinal);', @GV_Entity_SetRenderState, H);
  GV_Script_DefineRoutine('function GV_Entity_GetRenderState(aEntity: Integer): Cardinal;', @GV_Entity_GetRenderState, H);
  GV_Script_DefineRoutine('procedure GV_Entity_SetColor(aEntity: Integer; aColor: Cardinal);', @GV_Entity_SetColor, H);
  GV_Script_DefineRoutine('function GV_Entity_GetColor(aEntity: Integer): Cardinal;', @GV_Entity_GetColor, H);
  GV_Script_DefineRoutine('procedure GV_Entity_SetScale(aEntity: Integer; aScale: Single);', @GV_Entity_SetScale, H);
  GV_Script_DefineRoutine('procedure GV_Entity_ScaleRel(aEntity: Integer; aScale: Single);', @GV_Entity_ScaleRel, H);
  GV_Script_DefineRoutine('function GV_Entity_GetScale(aEntity: Integer): Single;', @GV_Entity_GetScale, H);
  GV_Script_DefineRoutine('procedure GV_Entity_SetAngle(aEntity: Integer; aAngle: Single);', @GV_Entity_SetAngle, H);
  GV_Script_DefineRoutine('function GV_Entity_GetAngle(aEntity: Integer): Single;', @GV_Entity_GetAngle, H);
  GV_Script_DefineRoutine('procedure GV_Entity_RotateAbs(aEntity: Integer; aAngle: Single);', @GV_Entity_RotateAbs, H);
  GV_Script_DefineRoutine('procedure GV_Entity_RotateRel(aEntity: Integer; aAngle: Single);', @GV_Entity_RotateRel, H);
  GV_Script_DefineRoutine('function GV_Entity_RotateToAngle(aEntity: Integer; aAngle: Single; aSpeed: Single): Boolean;', @GV_Entity_RotateToAngle, H);
  GV_Script_DefineRoutine('function GV_Entity_RotateToPos(aEntity: Integer; aX: Single; aY: Single; aSpeed: Single): Boolean;', @GV_Entity_RotateToPos, H);
  GV_Script_DefineRoutine('function GV_Entity_IsVisible(aEntity: Integer): Boolean;', @GV_Entity_IsVisible, H);
  GV_Script_DefineRoutine('function GV_Entity_OverlapRadius(aEntity: Integer; aX: Single; aY: Single; aRadius: Single; aShrinkFactor: Single): Boolean;', @GV_Entity_OverlapRadius, H);
  GV_Script_DefineRoutine('procedure GV_Entity_Render(aEntity: Integer);', @GV_Entity_Render, H);
  GV_Script_DefineRoutine('procedure GV_Entity_AddPolyPoint(aEntity: Integer; aFrame: Cardinal; aX: Single; aY: Single);', @GV_Entity_AddPolyPoint, H);
  GV_Script_DefineRoutine('procedure GV_Entity_CopyPolyPoint(aEntity: Integer; aSrcFrame: Cardinal; aDstFrame: Cardinal);', @GV_Entity_CopyPolyPoint, H);
  GV_Script_DefineRoutine('procedure GV_Entity_RenderPolyPoint(aEntity: Integer; aColor: Cardinal; aRenderState: Cardinal);', @GV_Entity_RenderPolyPoint, H);
  GV_Script_DefineRoutine('procedure GV_Entity_TransformPolyPoint(aEntity: Integer);', @GV_Entity_TransformPolyPoint, H);
  GV_Script_DefineRoutine('function GV_Entity_GetPolyPointSegmentCount(aEntity: Integer): Cardinal;', @GV_Entity_GetPolyPointSegmentCount, H);
  GV_Script_DefineRoutine('function GV_Entity_GetPolyPointWorldPoint(aEntity: Integer; aIndex: Cardinal): PGVVector;', @GV_Entity_GetPolyPointWorldPoint, H);
  GV_Script_DefineRoutine('function GV_Entity_PolyPointCollide(aEntity1: Integer; aEntity2: Integer; aPos: PGVVector): Boolean;', @GV_Entity_PolyPointCollide, H);
  GV_Script_DefineRoutine('function GV_Entity_PolyPointCollideXY(aEntity: Integer; aX: Single; aY: Single; aPos: PGVVector): Boolean;', @GV_Entity_PolyPointCollideXY, H);
  GV_Script_DefineRoutine('procedure GV_Entity_PolyPointTrace(aEntity: Integer; aMju: Extended; aMaxStepBack: Integer; aAlphaThreshold: Byte);', @GV_Entity_PolyPointTrace, H);
  GV_Script_DefineRoutine('function GV_Audio_Open(aHandle: Integer): Boolean;', @GV_Audio_Open, H);
  GV_Script_DefineRoutine('procedure GV_Audio_Close;', @GV_Audio_Close, H);
  GV_Script_DefineRoutine('function GV_Audio_LoadSample(aRezFile: Integer; const aPath: string): Integer;', @GV_Audio_LoadSample, H);
  GV_Script_DefineRoutine('procedure GV_Audio_FreeSample(var aNum: Integer);', @GV_Audio_FreeSample, H);
  GV_Script_DefineRoutine('function GV_Audio_PlaySample(aNum: Integer; aChan: Integer; aVol: Single; aPan: Single; aFreq: Single; aLoop: Boolean): Integer;', @GV_Audio_PlaySample, H);
  GV_Script_DefineRoutine('procedure GV_Audio_ReserveChannel(aChan: Integer; aReserve: Boolean);', @GV_Audio_ReserveChannel, H);
  GV_Script_DefineRoutine('procedure GV_Audio_SetChannelVol(aChan: Integer; aVol: Single);', @GV_Audio_SetChannelVol, H);
  GV_Script_DefineRoutine('function GV_Audio_GetChannelVol(aChan: Integer): Single;', @GV_Audio_GetChannelVol, H);
  GV_Script_DefineRoutine('procedure GV_Audio_SetChannelPan(aChan: Integer; aPan: Single);', @GV_Audio_SetChannelPan, H);
  GV_Script_DefineRoutine('function GV_Audio_GetChannelPan(aChan: Integer): Single;', @GV_Audio_GetChannelPan, H);
  GV_Script_DefineRoutine('procedure GV_Audio_SetChannelFreq(aChan: Integer; aFreq: Single);', @GV_Audio_SetChannelFreq, H);
  GV_Script_DefineRoutine('function GV_Audio_GetChannelFreq(aChan: Integer): Single;', @GV_Audio_GetChannelFreq, H);
  GV_Script_DefineRoutine('function GV_Audio_ChannelPlaying(aChan: Integer): Boolean;', @GV_Audio_ChannelPlaying, H);
  GV_Script_DefineRoutine('procedure GV_Audio_StopChannel(aChan: Integer);', @GV_Audio_StopChannel, H);
  GV_Script_DefineRoutine('procedure GV_Audio_StopAllChannels;', @GV_Audio_StopAllChannels, H);
  GV_Script_DefineRoutine('procedure GV_Audio_SetMasterSfxVol(aVol: Single);', @GV_Audio_SetMasterSfxVol, H);
  GV_Script_DefineRoutine('function GV_Audio_GetMasterSfxVol: Single;', @GV_Audio_GetMasterSfxVol, H);
  GV_Script_DefineRoutine('function GV_Audio_PlayMusic(aRezFile: Integer; const aPath: string; aVol: Single; aLoop: Boolean): Boolean;', @GV_Audio_PlayMusic, H);
  GV_Script_DefineRoutine('procedure GV_Audio_PauseMusic(aPause: Boolean);', @GV_Audio_PauseMusic, H);
  GV_Script_DefineRoutine('procedure GV_Audio_StopMusic;', @GV_Audio_StopMusic, H);
  GV_Script_DefineRoutine('procedure GV_Audio_SetMusicVol(aVol: Single);', @GV_Audio_SetMusicVol, H);
  GV_Script_DefineRoutine('function GV_Audio_MusicPlaying: Boolean;', @GV_Audio_MusicPlaying, H);
  GV_Script_DefineRoutine('procedure GV_MusicPlayer_InitSongList;', @GV_MusicPlayer_InitSongList, H);
  GV_Script_DefineRoutine('procedure GV_MusicPlayer_AddSongs(const aPath: string);', @GV_MusicPlayer_AddSongs, H);
  GV_Script_DefineRoutine('function GV_MusicPlayer_GetSongListCount: Cardinal;', @GV_MusicPlayer_GetSongListCount, H);
  GV_Script_DefineRoutine('function GV_MusicPlayer_GetSongNum: Cardinal;', @GV_MusicPlayer_GetSongNum, H);
  GV_Script_DefineRoutine('function GV_MusicPlayer_PlayNextSong(aLoop: Boolean): Integer;', @GV_MusicPlayer_PlayNextSong, H);
  GV_Script_DefineRoutine('function GV_MusicPlayer_PlayPrevSong(aLoop: Boolean): Integer;', @GV_MusicPlayer_PlayPrevSong, H);
  GV_Script_DefineRoutine('function GV_MusicPlayer_PlayRandomSong(aLoop: Boolean): Integer;', @GV_MusicPlayer_PlayRandomSong, H);
  GV_Script_DefineRoutine('procedure GV_MusicPlayer_StopSong;', @GV_MusicPlayer_StopSong, H);
  GV_Script_DefineRoutine('procedure GV_MusicPlayer_PauseSong(aPause: Boolean);', @GV_MusicPlayer_PauseSong, H);
  GV_Script_DefineRoutine('function GV_MusicPlayer_SongPlaying: Boolean;', @GV_MusicPlayer_SongPlaying, H);
  GV_Script_DefineRoutine('procedure GV_MusicPlayer_SetSongVol(aVol: Single);', @GV_MusicPlayer_SetSongVol, H);
  GV_Script_DefineRoutine('function GV_MusicPlayer_GetSongPath: string;', @GV_MusicPlayer_GetSongPath, H);
  GV_Script_DefineRoutine('procedure GV_Vector_Clear(aSelf: PGVVector);', @GV_Vector_Clear, H);
  GV_Script_DefineRoutine('procedure GV_Vector_Assign(aSelf: PGVVector; aV: PGVVector);', @GV_Vector_Assign, H);
  GV_Script_DefineRoutine('procedure GV_Vector_Add(aSelf: PGVVector; aV: PGVVector);', @GV_Vector_Add, H);
  GV_Script_DefineRoutine('procedure GV_Vector_Sub(aSelf: PGVVector; aV: PGVVector);', @GV_Vector_Sub, H);
  GV_Script_DefineRoutine('procedure GV_Vector_Mul(aSelf: PGVVector; aV: PGVVector);', @GV_Vector_Mul, H);
  GV_Script_DefineRoutine('function GV_Vector_Mag(aSelf: PGVVector): Single;', @GV_Vector_Mag, H);
  GV_Script_DefineRoutine('function GV_Vector_Dist(aSelf: PGVVector; aV: PGVVector): Single;', @GV_Vector_Dist, H);
  GV_Script_DefineRoutine('procedure GV_Vector_Norm(aSelf: PGVVector);', @GV_Vector_Norm, H);
  GV_Script_DefineRoutine('function GV_Vector_Angle(aSelf: PGVVector; aV: PGVVector): Single;', @GV_Vector_Angle, H);
  GV_Script_DefineRoutine('procedure GV_Vector_Thrust(aSelf: PGVVector; aAngle: Single; aSpeed: Single);', @GV_Vector_Thrust, H);
  GV_Script_DefineRoutine('function GV_Angle_ClipAbs(aAngle: Single): Single;', @GV_Angle_ClipAbs, H);
  GV_Script_DefineRoutine('function GV_Angle_ClipRel(aAngle: Single): Single;', @GV_Angle_ClipRel, H);
  GV_Script_DefineRoutine('function GV_Angle_Diff(aA: Single; aB: Single): Single;', @GV_Angle_Diff, H);
  GV_Script_DefineRoutine('procedure GV_Angle_RotateXY(aAngle: Single; var aX: Single; var aY: Single);', @GV_Angle_RotateXY, H);
  GV_Script_DefineRoutine('function GV_Angle_Sin(aAngle: Cardinal): Single;', @GV_Angle_Sin, H);
  GV_Script_DefineRoutine('function GV_Angle_Cos(aAngle: Cardinal): Single;', @GV_Angle_Cos, H);
  GV_Script_DefineRoutine('function GV_RandomNum_RangeInteger(aMin: Integer; aMax: Integer): Integer;', @GV_RandomNum_RangeInteger, H);
  GV_Script_DefineRoutine('function GV_RandomNum_RangeSingle(aMin: Single; aMax: Single): Single;', @GV_RandomNum_RangeSingle, H);
  GV_Script_DefineRoutine('procedure GV_ClampValueSingle(var aValue: Single; aMin: Single; aMax: Single);', @GV_ClampValueSingle, H);
  GV_Script_DefineRoutine('procedure GV_ClampValueInteger(var aValue: Integer; aMin: Integer; aMax: Integer);', @GV_ClampValueInteger, H);
  GV_Script_DefineRoutine('procedure GV_ClampValueCardinal(var aValue: Cardinal; aMin: Cardinal; aMax: Cardinal);', @GV_ClampValueCardinal, H);
  GV_Script_DefineRoutine('function GV_LineIntersect(aX1: Integer; aY1: Integer; ax2: Integer; ay2: Integer; aX3: Integer; aY3: Integer; aX4: Integer; aY4: Integer; var aX: Integer; var aY: Integer): Cardinal;', @GV_LineIntersect, H);
  GV_Script_DefineRoutine('function GV_SameSignInteger(aValue1: Integer; aValue2: Integer): Boolean;', @GV_SameSignInteger, H);
  GV_Script_DefineRoutine('procedure GV_WrapNumberSingle(var aV: Single; aMin: Single; aMax: Single);', @GV_WrapNumberSingle, H);
  GV_Script_DefineRoutine('procedure GV_Dialog_ShowMessage(const aCaption: string; const aMsg: string);', @GV_Dialog_ShowMessage, H);
  GV_Script_DefineRoutine('function GV_Dialog_PickDir(const aCaption: string): string;', @GV_Dialog_PickDir, H);
  GV_Script_DefineRoutine('procedure GV_Ini_Flush;', @GV_Ini_Flush, H);
  GV_Script_DefineRoutine('function GV_Ini_ReadString(const aSection: string; const aName: string; const aDefault: string): string;', @GV_Ini_ReadString, H);
  GV_Script_DefineRoutine('procedure GV_Ini_WriteString(const aSection: string; const aName: string; const aValue: string);', @GV_Ini_WriteString, H);
  GV_Script_DefineRoutine('function GV_Ini_ReadInteger(const aSection: string; const aName: string; aDefault: Longint): Cardinal;', @GV_Ini_ReadInteger, H);
  GV_Script_DefineRoutine('procedure GV_Ini_WriteInteger(const aSection: string; const aName: string; aValue: Longint);', @GV_Ini_WriteInteger, H);
  GV_Script_DefineRoutine('function GV_Ini_ReadBool(const aSection: string; const aName: string; aDefault: Boolean): Boolean;', @GV_Ini_ReadBool, H);
  GV_Script_DefineRoutine('procedure GV_Ini_WriteBool(const aSection: string; const aName: string; aValue: Boolean);', @GV_Ini_WriteBool, H);
  GV_Script_DefineRoutine('function GV_Ini_ReadFloat(const aSection: string; const aName: string; aDefault: Double): Double;', @GV_Ini_ReadFloat, H);
  GV_Script_DefineRoutine('procedure GV_Ini_WriteFloat(const aSection: string; const aName: string; aValue: Double);', @GV_Ini_WriteFloat, H);
  GV_Script_DefineRoutine('function GV_Ini_ValueExists(const aSection: string; const aName: string): Boolean;', @GV_Ini_ValueExists, H);
  GV_Script_DefineRoutine('procedure GV_Dir_Read(const aDirStr: string; var aStrList: TStringList; aNotify: TGVNotifyEvent);', @GV_Dir_Read, H);
  GV_Script_DefineRoutine('procedure GV_Dir_GetFiles(const aDirStr: string; const aFileStr: string; var aStrList: TStringList; aNotify: TNotifyEvent);', @GV_Dir_GetFiles, H);
  GV_Script_DefineRoutine('procedure GV_Dir_GetAllFiles(const aDirStr: string; const aFileStr: string; var aStrList: TStringList; aNotify: TGVNotifyEvent);', @GV_Dir_GetAllFiles, H);
  GV_Script_DefineRoutine('procedure GV_GZFile_Init(aMaxCount: Cardinal);', @GV_GZFile_Init, H);
  GV_Script_DefineRoutine('procedure GV_GZFile_Done;', @GV_GZFile_Done, H);
  GV_Script_DefineRoutine('function GV_GZFile_OpenRead(aPath: string): Integer;', @GV_GZFile_OpenRead, H);
  GV_Script_DefineRoutine('function GV_GZFile_OpenWrite(aPath: string): Integer;', @GV_GZFile_OpenWrite, H);
  GV_Script_DefineRoutine('function GV_GZFile_Close(var aGZFile: Integer): Integer;', @GV_GZFile_Close, H);
  GV_Script_DefineRoutine('procedure GV_GZFile_CloseAll;', @GV_GZFile_CloseAll, H);
  GV_Script_DefineRoutine('function GV_GZFile_Read(aGZFile: Integer; aBuffer: Pointer; aLen: Cardinal): Integer;', @GV_GZFile_Read, H);
  GV_Script_DefineRoutine('function GV_GZFile_Write(aGZFile: Integer; aBuffer: Pointer; aLen: Cardinal): Integer;', @GV_GZFile_Write, H);
  GV_Script_DefineRoutine('function GV_GZFile_Seek(aGZFile: Integer; aLen: Cardinal; aOrigin: Cardinal): Integer;', @GV_GZFile_Seek, H);
  GV_Script_DefineRoutine('function GV_GZFile_Tell(aGZFile: Integer): Integer;', @GV_GZFile_Tell, H);
  GV_Script_DefineRoutine('function GV_GZFile_Eof(aGZFile: Integer): Boolean;', @GV_GZFile_Eof, H);
  GV_Script_DefineRoutine('function GV_DirectXInstalled: Boolean;', @GV_DirectXInstalled, H);
  GV_Script_DefineRoutine('procedure GV_SmoothMove(var aValue: Single; aAmount: Single; aMax: Single; aDrag: Single; aElapsedTime: Single);', @GV_SmoothMove, H);
  GV_Script_DefineRoutine('function GV_Version: string;', @GV_Version, H);
  GV_Script_DefineRoutine('procedure GV_ObjectClass_FreeNil;', @GV_ObjectClass_FreeNil, H);

  { consts }

  GV_Script_DefineConstant('GV_SDK_VERSION', GV_SDK_VERSION, H);
  GV_Script_DefineConstant('GV_SDK_DLL', GV_SDK_DLL, H);
  GV_Script_DefineConstant('GV_LogFile_Priority_None', GV_LogFile_Priority_None, H);
  GV_Script_DefineConstant('GV_LogFile_Priority_All', GV_LogFile_Priority_All, H);
  GV_Script_DefineConstant('GV_LogFile_Priority_General', GV_LogFile_Priority_General, H);
  GV_Script_DefineConstant('GV_LogFile_Priority_Info', GV_LogFile_Priority_Info, H);
  GV_Script_DefineConstant('GV_LogFile_Priority_Critical', GV_LogFile_Priority_Critical, H);
  GV_Script_DefineConstant('GV_LogFile_Priority_User', GV_LogFile_Priority_User, H);
  GV_Script_DefineConstant('GV_PI', GV_PI, H);
  GV_Script_DefineConstant('GV_Rad2Deg', GV_Rad2Deg, H);
  GV_Script_DefineConstant('GV_Deg2Rad', GV_Deg2Rad, H);
  GV_Script_DefineConstant('GV_ClearFrame_Target', GV_ClearFrame_Target, H);
  GV_Script_DefineConstant('GV_ClearFrame_ZBuffer', GV_ClearFrame_ZBuffer, H);
  GV_Script_DefineConstant('GV_ClearFrame_Default', GV_ClearFrame_Default, H);
  GV_Script_DefineConstant('GV_SwapEffect_Discard', GV_SwapEffect_Discard, H);
  GV_Script_DefineConstant('GV_SwapEffect_Flip', GV_SwapEffect_Flip, H);
  GV_Script_DefineConstant('GV_SwapEffect_Copy', GV_SwapEffect_Copy, H);
  GV_Script_DefineConstant('GV_SwapEffect_CopyVsync', GV_SwapEffect_CopyVsync, H);
  GV_Script_DefineConstant('GV_RenderState_Default', GV_RenderState_Default, H);
  GV_Script_DefineConstant('GV_RenderState_Normal', GV_RenderState_Normal, H);
  GV_Script_DefineConstant('GV_RenderState_Blend', GV_RenderState_Blend, H);
  GV_Script_DefineConstant('GV_RenderState_Transparent', GV_RenderState_Transparent, H);
  GV_Script_DefineConstant('GV_RenderState_TransBlend', GV_RenderState_TransBlend, H);
  GV_Script_DefineConstant('GV_RenderState_Font', GV_RenderState_Font, H);
  GV_Script_DefineConstant('GV_RenderState_Image', GV_RenderState_Image, H);
  GV_Script_DefineConstant('GV_SeekOrigin_Start', GV_SeekOrigin_Start, H);
  GV_Script_DefineConstant('GV_SeekOrigin_Current', GV_SeekOrigin_Current, H);
  GV_Script_DefineConstant('GV_SeekOrigin_End', GV_SeekOrigin_End, H);
  GV_Script_DefineConstant('GV_LineInterSect_None', GV_LineInterSect_None, H);
  GV_Script_DefineConstant('GV_LineInterSect_True', GV_LineInterSect_True, H);
  GV_Script_DefineConstant('GV_LineInterSect_Parallel', GV_LineInterSect_Parallel, H);
  GV_Script_DefineConstant('GV_FontWeight_DontCare', GV_FontWeight_DontCare, H);
  GV_Script_DefineConstant('GV_FontWeight_Thin', GV_FontWeight_Thin, H);
  GV_Script_DefineConstant('GV_FontWeight_ExtraLight', GV_FontWeight_ExtraLight, H);
  GV_Script_DefineConstant('GV_FontWeight_Light', GV_FontWeight_Light, H);
  GV_Script_DefineConstant('GV_FontWeight_Normal', GV_FontWeight_Normal, H);
  GV_Script_DefineConstant('GV_FontWeight_Medium', GV_FontWeight_Medium, H);
  GV_Script_DefineConstant('GV_FontWeight_SemiBold', GV_FontWeight_SemiBold, H);
  GV_Script_DefineConstant('GV_FontWeight_Bold', GV_FontWeight_Bold, H);
  GV_Script_DefineConstant('GV_FontWeight_ExtraBold', GV_FontWeight_ExtraBold, H);
  GV_Script_DefineConstant('GV_FontWeight_Heavy', GV_FontWeight_Heavy, H);
  GV_Script_DefineConstant('GV_NIL', GV_NIL, H);
  GV_Script_DefineConstant('GV_KEY_ESCAPE', GV_KEY_ESCAPE, H);
  GV_Script_DefineConstant('GV_KEY_1', GV_KEY_1, H);
  GV_Script_DefineConstant('GV_KEY_2', GV_KEY_2, H);
  GV_Script_DefineConstant('GV_KEY_3', GV_KEY_3, H);
  GV_Script_DefineConstant('GV_KEY_4', GV_KEY_4, H);
  GV_Script_DefineConstant('GV_KEY_5', GV_KEY_5, H);
  GV_Script_DefineConstant('GV_KEY_6', GV_KEY_6, H);
  GV_Script_DefineConstant('GV_KEY_7', GV_KEY_7, H);
  GV_Script_DefineConstant('GV_KEY_8', GV_KEY_8, H);
  GV_Script_DefineConstant('GV_KEY_9', GV_KEY_9, H);
  GV_Script_DefineConstant('GV_KEY_0', GV_KEY_0, H);
  GV_Script_DefineConstant('GV_KEY_MINUS', GV_KEY_MINUS, H);
  GV_Script_DefineConstant('GV_KEY_EQUALS', GV_KEY_EQUALS, H);
  GV_Script_DefineConstant('GV_KEY_BACK', GV_KEY_BACK, H);
  GV_Script_DefineConstant('GV_KEY_TAB', GV_KEY_TAB, H);
  GV_Script_DefineConstant('GV_KEY_Q', GV_KEY_Q, H);
  GV_Script_DefineConstant('GV_KEY_W', GV_KEY_W, H);
  GV_Script_DefineConstant('GV_KEY_E', GV_KEY_E, H);
  GV_Script_DefineConstant('GV_KEY_R', GV_KEY_R, H);
  GV_Script_DefineConstant('GV_KEY_T', GV_KEY_T, H);
  GV_Script_DefineConstant('GV_KEY_Y', GV_KEY_Y, H);
  GV_Script_DefineConstant('GV_KEY_U', GV_KEY_U, H);
  GV_Script_DefineConstant('GV_KEY_I', GV_KEY_I, H);
  GV_Script_DefineConstant('GV_KEY_O', GV_KEY_O, H);
  GV_Script_DefineConstant('GV_KEY_P', GV_KEY_P, H);
  GV_Script_DefineConstant('GV_KEY_LBRACKET', GV_KEY_LBRACKET, H);
  GV_Script_DefineConstant('GV_KEY_RBRACKET', GV_KEY_RBRACKET, H);
  GV_Script_DefineConstant('GV_KEY_RETURN', GV_KEY_RETURN, H);
  GV_Script_DefineConstant('GV_KEY_LCONTROL', GV_KEY_LCONTROL, H);
  GV_Script_DefineConstant('GV_KEY_A', GV_KEY_A, H);
  GV_Script_DefineConstant('GV_KEY_S', GV_KEY_S, H);
  GV_Script_DefineConstant('GV_KEY_D', GV_KEY_D, H);
  GV_Script_DefineConstant('GV_KEY_F', GV_KEY_F, H);
  GV_Script_DefineConstant('GV_KEY_G', GV_KEY_G, H);
  GV_Script_DefineConstant('GV_KEY_H', GV_KEY_H, H);
  GV_Script_DefineConstant('GV_KEY_J', GV_KEY_J, H);
  GV_Script_DefineConstant('GV_KEY_K', GV_KEY_K, H);
  GV_Script_DefineConstant('GV_KEY_L', GV_KEY_L, H);
  GV_Script_DefineConstant('GV_KEY_SEMICOLON', GV_KEY_SEMICOLON, H);
  GV_Script_DefineConstant('GV_KEY_APOSTROPHE', GV_KEY_APOSTROPHE, H);
  GV_Script_DefineConstant('GV_KEY_GRAVE', GV_KEY_GRAVE, H);
  GV_Script_DefineConstant('GV_KEY_LSHIFT', GV_KEY_LSHIFT, H);
  GV_Script_DefineConstant('GV_KEY_BACKSLASH', GV_KEY_BACKSLASH, H);
  GV_Script_DefineConstant('GV_KEY_Z', GV_KEY_Z, H);
  GV_Script_DefineConstant('GV_KEY_X', GV_KEY_X, H);
  GV_Script_DefineConstant('GV_KEY_C', GV_KEY_C, H);
  GV_Script_DefineConstant('GV_KEY_V', GV_KEY_V, H);
  GV_Script_DefineConstant('GV_KEY_B', GV_KEY_B, H);
  GV_Script_DefineConstant('GV_KEY_N', GV_KEY_N, H);
  GV_Script_DefineConstant('GV_KEY_M', GV_KEY_M, H);
  GV_Script_DefineConstant('GV_KEY_COMMA', GV_KEY_COMMA, H);
  GV_Script_DefineConstant('GV_KEY_PERIOD', GV_KEY_PERIOD, H);
  GV_Script_DefineConstant('GV_KEY_SLASH', GV_KEY_SLASH, H);
  GV_Script_DefineConstant('GV_KEY_RSHIFT', GV_KEY_RSHIFT, H);
  GV_Script_DefineConstant('GV_KEY_MULTIPLY', GV_KEY_MULTIPLY, H);
  GV_Script_DefineConstant('GV_KEY_LMENU', GV_KEY_LMENU, H);
  GV_Script_DefineConstant('GV_KEY_SPACE', GV_KEY_SPACE, H);
  GV_Script_DefineConstant('GV_KEY_CAPITAL', GV_KEY_CAPITAL, H);
  GV_Script_DefineConstant('GV_KEY_F1', GV_KEY_F1, H);
  GV_Script_DefineConstant('GV_KEY_F2', GV_KEY_F2, H);
  GV_Script_DefineConstant('GV_KEY_F3', GV_KEY_F3, H);
  GV_Script_DefineConstant('GV_KEY_F4', GV_KEY_F4, H);
  GV_Script_DefineConstant('GV_KEY_F5', GV_KEY_F5, H);
  GV_Script_DefineConstant('GV_KEY_F6', GV_KEY_F6, H);
  GV_Script_DefineConstant('GV_KEY_F7', GV_KEY_F7, H);
  GV_Script_DefineConstant('GV_KEY_F8', GV_KEY_F8, H);
  GV_Script_DefineConstant('GV_KEY_F9', GV_KEY_F9, H);
  GV_Script_DefineConstant('GV_KEY_F10', GV_KEY_F10, H);
  GV_Script_DefineConstant('GV_KEY_NUMLOCK', GV_KEY_NUMLOCK, H);
  GV_Script_DefineConstant('GV_KEY_SCROLL', GV_KEY_SCROLL, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD7', GV_KEY_NUMPAD7, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD8', GV_KEY_NUMPAD8, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD9', GV_KEY_NUMPAD9, H);
  GV_Script_DefineConstant('GV_KEY_SUBTRACT', GV_KEY_SUBTRACT, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD4', GV_KEY_NUMPAD4, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD5', GV_KEY_NUMPAD5, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD6', GV_KEY_NUMPAD6, H);
  GV_Script_DefineConstant('GV_KEY_ADD', GV_KEY_ADD, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD1', GV_KEY_NUMPAD1, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD2', GV_KEY_NUMPAD2, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD3', GV_KEY_NUMPAD3, H);
  GV_Script_DefineConstant('GV_KEY_NUMPAD0', GV_KEY_NUMPAD0, H);
  GV_Script_DefineConstant('GV_KEY_DECIMAL', GV_KEY_DECIMAL, H);
  GV_Script_DefineConstant('GV_KEY_OEM_102', GV_KEY_OEM_102, H);
  GV_Script_DefineConstant('GV_KEY_F11', GV_KEY_F11, H);
  GV_Script_DefineConstant('GV_KEY_F12', GV_KEY_F12, H);
  GV_Script_DefineConstant('GV_KEY_F13', GV_KEY_F13, H);
  GV_Script_DefineConstant('GV_KEY_F14', GV_KEY_F14, H);
  GV_Script_DefineConstant('GV_KEY_F15', GV_KEY_F15, H);
  GV_Script_DefineConstant('GV_KEY_KANA', GV_KEY_KANA, H);
  GV_Script_DefineConstant('GV_KEY_ABNT_C1', GV_KEY_ABNT_C1, H);
  GV_Script_DefineConstant('GV_KEY_CONVERT', GV_KEY_CONVERT, H);
  GV_Script_DefineConstant('GV_KEY_NOCONVERT', GV_KEY_NOCONVERT, H);
  GV_Script_DefineConstant('GV_KEY_YEN', GV_KEY_YEN, H);
  GV_Script_DefineConstant('GV_KEY_ABNT_C2', GV_KEY_ABNT_C2, H);
  GV_Script_DefineConstant('GV_KEY_NUMPADEQUALS', GV_KEY_NUMPADEQUALS, H);
  GV_Script_DefineConstant('GV_KEY_PREVTRACK', GV_KEY_PREVTRACK, H);
  GV_Script_DefineConstant('GV_KEY_AT', GV_KEY_AT, H);
  GV_Script_DefineConstant('GV_KEY_COLON', GV_KEY_COLON, H);
  GV_Script_DefineConstant('GV_KEY_UNDERLINE', GV_KEY_UNDERLINE, H);
  GV_Script_DefineConstant('GV_KEY_KANJI', GV_KEY_KANJI, H);
  GV_Script_DefineConstant('GV_KEY_STOP', GV_KEY_STOP, H);
  GV_Script_DefineConstant('GV_KEY_AX', GV_KEY_AX, H);
  GV_Script_DefineConstant('GV_KEY_UNLABELED', GV_KEY_UNLABELED, H);
  GV_Script_DefineConstant('GV_KEY_NEXTTRACK', GV_KEY_NEXTTRACK, H);
  GV_Script_DefineConstant('GV_KEY_NUMPADENTER', GV_KEY_NUMPADENTER, H);
  GV_Script_DefineConstant('GV_KEY_RCONTROL', GV_KEY_RCONTROL, H);
  GV_Script_DefineConstant('GV_KEY_MUTE', GV_KEY_MUTE, H);
  GV_Script_DefineConstant('GV_KEY_CALCULATOR', GV_KEY_CALCULATOR, H);
  GV_Script_DefineConstant('GV_KEY_PLAYPAUSE', GV_KEY_PLAYPAUSE, H);
  GV_Script_DefineConstant('GV_KEY_MEDIASTOP', GV_KEY_MEDIASTOP, H);
  GV_Script_DefineConstant('GV_KEY_VOLUMEDOWN', GV_KEY_VOLUMEDOWN, H);
  GV_Script_DefineConstant('GV_KEY_VOLUMEUP', GV_KEY_VOLUMEUP, H);
  GV_Script_DefineConstant('GV_KEY_WEBHOME', GV_KEY_WEBHOME, H);
  GV_Script_DefineConstant('GV_KEY_NUMPADCOMMA', GV_KEY_NUMPADCOMMA, H);
  GV_Script_DefineConstant('GV_KEY_DIVIDE', GV_KEY_DIVIDE, H);
  GV_Script_DefineConstant('GV_KEY_SYSRQ', GV_KEY_SYSRQ, H);
  GV_Script_DefineConstant('GV_KEY_RMENU', GV_KEY_RMENU, H);
  GV_Script_DefineConstant('GV_KEY_PAUSE', GV_KEY_PAUSE, H);
  GV_Script_DefineConstant('GV_KEY_HOME', GV_KEY_HOME, H);
  GV_Script_DefineConstant('GV_KEY_UP', GV_KEY_UP, H);
  GV_Script_DefineConstant('GV_KEY_PRIOR', GV_KEY_PRIOR, H);
  GV_Script_DefineConstant('GV_KEY_LEFT', GV_KEY_LEFT, H);
  GV_Script_DefineConstant('GV_KEY_RIGHT', GV_KEY_RIGHT, H);
  GV_Script_DefineConstant('GV_KEY_END', GV_KEY_END, H);
  GV_Script_DefineConstant('GV_KEY_DOWN', GV_KEY_DOWN, H);
  GV_Script_DefineConstant('GV_KEY_NEXT', GV_KEY_NEXT, H);
  GV_Script_DefineConstant('GV_KEY_INSERT', GV_KEY_INSERT, H);
  GV_Script_DefineConstant('GV_KEY_DELETE', GV_KEY_DELETE, H);
  GV_Script_DefineConstant('GV_KEY_LWIN', GV_KEY_LWIN, H);
  GV_Script_DefineConstant('GV_KEY_RWIN', GV_KEY_RWIN, H);
  GV_Script_DefineConstant('GV_KEY_APPS', GV_KEY_APPS, H);
  GV_Script_DefineConstant('GV_KEY_POWER', GV_KEY_POWER, H);
  GV_Script_DefineConstant('GV_KEY_SLEEP', GV_KEY_SLEEP, H);
  GV_Script_DefineConstant('GV_KEY_WAKE', GV_KEY_WAKE, H);
  GV_Script_DefineConstant('GV_KEY_WEBSEARCH', GV_KEY_WEBSEARCH, H);
  GV_Script_DefineConstant('GV_KEY_WEBFAVORITES', GV_KEY_WEBFAVORITES, H);
  GV_Script_DefineConstant('GV_KEY_WEBREFRESH', GV_KEY_WEBREFRESH, H);
  GV_Script_DefineConstant('GV_KEY_WEBSTOP', GV_KEY_WEBSTOP, H);
  GV_Script_DefineConstant('GV_KEY_WEBFORWARD', GV_KEY_WEBFORWARD, H);
  GV_Script_DefineConstant('GV_KEY_WEBBACK', GV_KEY_WEBBACK, H);
  GV_Script_DefineConstant('GV_KEY_MYCOMPUTER', GV_KEY_MYCOMPUTER, H);
  GV_Script_DefineConstant('GV_KEY_MAIL', GV_KEY_MAIL, H);
  GV_Script_DefineConstant('GV_KEY_MEDIASELECT', GV_KEY_MEDIASELECT, H);
  GV_Script_DefineConstant('GV_KEY_BACKSPACE', GV_KEY_BACKSPACE, H);
  GV_Script_DefineConstant('GV_KEY_NUMPADSTAR', GV_KEY_NUMPADSTAR, H);
  GV_Script_DefineConstant('GV_KEY_LALT', GV_KEY_LALT, H);
  GV_Script_DefineConstant('GV_KEY_CAPSLOCK', GV_KEY_CAPSLOCK, H);
  GV_Script_DefineConstant('GV_KEY_NUMPADMINUS', GV_KEY_NUMPADMINUS, H);
  GV_Script_DefineConstant('GV_KEY_NUMPADPLUS', GV_KEY_NUMPADPLUS, H);
  GV_Script_DefineConstant('GV_KEY_NUMPADPERIOD', GV_KEY_NUMPADPERIOD, H);
  GV_Script_DefineConstant('GV_KEY_NUMPADSLASH', GV_KEY_NUMPADSLASH, H);
  GV_Script_DefineConstant('GV_KEY_RALT', GV_KEY_RALT, H);
  GV_Script_DefineConstant('GV_KEY_UPARROW', GV_KEY_UPARROW, H);
  GV_Script_DefineConstant('GV_KEY_PGUP', GV_KEY_PGUP, H);
  GV_Script_DefineConstant('GV_KEY_LEFTARROW', GV_KEY_LEFTARROW, H);
  GV_Script_DefineConstant('GV_KEY_RIGHTARROW', GV_KEY_RIGHTARROW, H);
  GV_Script_DefineConstant('GV_KEY_DOWNARROW', GV_KEY_DOWNARROW, H);
  GV_Script_DefineConstant('GV_KEY_PGDN', GV_KEY_PGDN, H);
  GV_Script_DefineConstant('GV_KEY_CIRCUMFLEX', GV_KEY_CIRCUMFLEX, H);
end;

end.
