//@@ Header to the GameVision.dll. All the core GV functionality, constants
// and types are exposed.

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

{$A8}

unit GVDLL;

interface

uses
  Classes;

const
  { Sdk }
  GV_SDK_VERSION               = '403.0';               //@@ SDK DLL version string
  GV_SDK_DLL                   = 'GameVision.dll';      //@@ SDK DLL name string

  { LogFile Priority }
  GV_LogFile_Priority_None     = 0; //@@ Log no messages
  GV_LogFile_Priority_All      = 1; //@@ Log all messages
  GV_LogFile_Priority_General  = 2; //@@ Log general messages
  GV_LogFile_Priority_Info     = 3; //@@ Log informative message
  GV_LogFile_Priority_Critical = 4; //@@ Log critical messages
  GV_LogFile_Priority_User     = 5; //@@ Log user define message (0-254)

  { Math }
  GV_PI                        = 3.1415926535897932385; //@@ PI constant
  GV_Rad2Deg                   = 180.0 / GV_PI;         //@@ Radians to Degree conversion constant
  GV_Deg2Rad                   = GV_PI / 180.0;         //@@ Degree to Radians conversion constant

  { ClearFrame }
  GV_ClearFrame_Target         = 1; //@@ Clear frame buffer
  GV_ClearFrame_ZBuffer        = 2; //@@ Clear zbuffer
  GV_ClearFrame_Default        = 3; //@@ Celar frame + zbuffer

  { SwapEffect }
  GV_SwapEffect_Discard        = 1; //@@ Discard keeping the backbuffers sync'ed (most efficent)
  GV_SwapEffect_Flip           = 2; //@@ Flip to along backbuffer chain
  GV_SwapEffect_Copy           = 3; //@@ Copy backbuffer to front buffer
  GV_SwapEffect_CopyVsync      = 4; //@@ Copy backbuffer to front buffer with vsync

  { RenderState }
  GV_RenderState_Default       = 1; //@@ Set needed states from sprinte rendering
  GV_RenderState_Normal        = 2; //@@ No Alpha blending, no transparency
  GV_RenderState_Blend         = 3; //@@ Alpha blending, Alpha transparency
  GV_RenderState_Transparent   = 4; //@@ 50% see-thru, no Alpha transparency
  GV_RenderState_TransBlend    = 5; //@@ 50% see-trhu, Alpha transparency
  GV_RenderState_Font          = 6; //@@ Render states for rendering textured fonts
  GV_RenderState_Image         = 7; //@@ Render statefor rendering whole textured images

  { SeekOrigin }
  GV_SeekOrigin_Start          = 0; //@@ Seek strating from start of stream
  GV_SeekOrigin_Current        = 1; //@@ Seek starting from current stream position
  GV_SeekOrigin_End            = 2; //@@ Seek starting from end of stream

  { LineIntersect }
  GV_LineInterSect_None        = 0; //@@ Lines don't intersect
  GV_LineInterSect_True        = 1; //@@ Lines do intersect
  GV_LineInterSect_Parallel    = 2; //@@ Lines are parallel to each other

  { Font Weight }
  GV_FontWeight_DontCare       = 0;   //@@ Let windows determina the font weight
  GV_FontWeight_Thin           = 100; //@@ Thin font
  GV_FontWeight_ExtraLight     = 200; //@@ Extra light font
  GV_FontWeight_Light          = 300; //@@ Light font
  GV_FontWeight_Normal         = 400; //@@ Normal font
  GV_FontWeight_Medium         = 500; //@@ Medium font
  GV_FontWeight_SemiBold       = 600; //@@ Semibold font
  GV_FontWeight_Bold           = 700; //@@ Bold font
  GV_FontWeight_ExtraBold      = 800; //@@ Extra bold font
  GV_FontWeight_Heavy          = 900; //@@ Heavy font

  { Misc }
  GV_NIL                       = -1; //@@ Represents a "not assigned" or general error condition in GV

  { Keyboard Constants }
  GV_KEY_ESCAPE                = $01; //@@ Escape Key
  GV_KEY_1                     = $02; //@@ #1 Key
  GV_KEY_2                     = $03; //@@ #2 Key
  GV_KEY_3                     = $04; //@@ #3 Key
  GV_KEY_4                     = $05; //@@ #4 Key
  GV_KEY_5                     = $06; //@@ #5 Key
  GV_KEY_6                     = $07; //@@ #6 Key
  GV_KEY_7                     = $08; //@@ #7 Key
  GV_KEY_8                     = $09; //@@ #8 Key
  GV_KEY_9                     = $0A; //@@ #9 Key
  GV_KEY_0                     = $0B; //@@ #0 Key
  GV_KEY_MINUS                 = $0C; //@@ MINUS  (-) Key on main keyboard
  GV_KEY_EQUALS                = $0D; //@@ EQUALS (=) Key
  GV_KEY_BACK                  = $0E; //@@ BACKSPACE
  GV_KEY_TAB                   = $0F; //@@ TABE Key
  GV_KEY_Q                     = $10; //@@ Q Key
  GV_KEY_W                     = $11; //@@ W Key
  GV_KEY_E                     = $12; //@@ E Key
  GV_KEY_R                     = $13; //@@ R Key
  GV_KEY_T                     = $14; //@@ T Key
  GV_KEY_Y                     = $15; //@@ Y Key
  GV_KEY_U                     = $16; //@@ U Key
  GV_KEY_I                     = $17; //@@ I Key
  GV_KEY_O                     = $18; //@@ O Key
  GV_KEY_P                     = $19; //@@ P Key
  GV_KEY_LBRACKET              = $1A; //@@ [ Key
  GV_KEY_RBRACKET              = $1B; //@@ ] Key
  GV_KEY_RETURN                = $1C; //@@ ENTER Key on main keyboard
  GV_KEY_LCONTROL              = $1D; //@@ LCTRL Key
  GV_KEY_A                     = $1E; //@@ A Key
  GV_KEY_S                     = $1F; //@@ S Key
  GV_KEY_D                     = $20; //@@ D Key
  GV_KEY_F                     = $21; //@@ F Key
  GV_KEY_G                     = $22; //@@ G Key
  GV_KEY_H                     = $23; //@@ H Key
  GV_KEY_J                     = $24; //@@ J Key
  GV_KEY_K                     = $25; //@@ K Key
  GV_KEY_L                     = $26; //@@ L Key
  GV_KEY_SEMICOLON             = $27; //@@ ; Key
  GV_KEY_APOSTROPHE            = $28; //@@ ` Key
  GV_KEY_GRAVE                 = $29; //@@ Accent grave Key
  GV_KEY_LSHIFT                = $2A; //@@ LSHFIT Key
  GV_KEY_BACKSLASH             = $2B; //@@ BACKSLASH Key
  GV_KEY_Z                     = $2C; //@@ Z Key
  GV_KEY_X                     = $2D; //@@ X Key
  GV_KEY_C                     = $2E; //@@ C Key
  GV_KEY_V                     = $2F; //@@ V Key
  GV_KEY_B                     = $30; //@@ B Key
  GV_KEY_N                     = $31; //@@ N Key
  GV_KEY_M                     = $32; //@@ M Key
  GV_KEY_COMMA                 = $33; //@@ " Key
  GV_KEY_PERIOD                = $34; //@@ . on main keyboard
  GV_KEY_SLASH                 = $35; //@@ / on main keyboard
  GV_KEY_RSHIFT                = $36; //@@ RSHIFT Key
  GV_KEY_MULTIPLY              = $37; //@@ * on numeric keypad
  GV_KEY_LMENU                 = $38; //@@ LALT Key
  GV_KEY_SPACE                 = $39; //@@ SPACE Key
  GV_KEY_CAPITAL               = $3A; //@@ CAPS LOCK Key
  GV_KEY_F1                    = $3B; //@@ F1 Key
  GV_KEY_F2                    = $3C; //@@ F2 Key
  GV_KEY_F3                    = $3D; //@@ F3 Key
  GV_KEY_F4                    = $3E; //@@ F4 Key
  GV_KEY_F5                    = $3F; //@@ F5 Key
  GV_KEY_F6                    = $40; //@@ F6 Key
  GV_KEY_F7                    = $41; //@@ F7 Key
  GV_KEY_F8                    = $42; //@@ F8 Key
  GV_KEY_F9                    = $43; //@@ F9 Key
  GV_KEY_F10                   = $44; //@@ F10 Key
  GV_KEY_NUMLOCK               = $45; //@@ NUMLOCK Key
  GV_KEY_SCROLL                = $46; //@@ SCROLL LOCK Key
  GV_KEY_NUMPAD7               = $47; //@@ NUMPAD7 Key
  GV_KEY_NUMPAD8               = $48; //@@ NUMPAD8 Key
  GV_KEY_NUMPAD9               = $49; //@@ NUMPAD0 Key
  GV_KEY_SUBTRACT              = $4A; //@@ - on numeric keypad
  GV_KEY_NUMPAD4               = $4B; //@@ NUMPAD4 Key
  GV_KEY_NUMPAD5               = $4C; //@@ NUMPAD5 Key
  GV_KEY_NUMPAD6               = $4D; //@@ NUMPAD6 Key
  GV_KEY_ADD                   = $4E; //@@ + on numeric keypad
  GV_KEY_NUMPAD1               = $4F; //@@ NUMPAD1 Key
  GV_KEY_NUMPAD2               = $50; //@@ NUMPAD2 Key
  GV_KEY_NUMPAD3               = $51; //@@ NUMPAD3 Key
  GV_KEY_NUMPAD0               = $52; //@@ NUMPAD0 Key
  GV_KEY_DECIMAL               = $53; //@@ . on numeric keypad
  GV_KEY_OEM_102               = $56; //@@ < > | on UK/Germany keyboards
  GV_KEY_F11                   = $57; //@@ F11 Key
  GV_KEY_F12                   = $58; //@@ F12 Key
  GV_KEY_F13                   = $64; //@@ F13 Key (NEC PC98)
  GV_KEY_F14                   = $65; //@@ F14 Key (NEC PC98)
  GV_KEY_F15                   = $66; //@@ F15 Key (NEC PC98)
  GV_KEY_KANA                  = $70; //@@ KANA Key(Japanese keyboard)
  GV_KEY_ABNT_C1               = $73; //@@ / ? on Portugese (Brazilian) keyboards
  GV_KEY_CONVERT               = $79; //@@ CONVERT Key (Japanese keyboard)
  GV_KEY_NOCONVERT             = $7B; //@@ NOCONVERT Key (Japanese keyboard)
  GV_KEY_YEN                   = $7D; //@@ YEN Key (Japanese keyboard)
  GV_KEY_ABNT_C2               = $7E; //@@ NUMPAD. on Portugese (Brazilian) keyboards
  GV_KEY_NUMPADEQUALS          = $8D; //@@ = on numeric keypad (NEC PC98)
  GV_KEY_PREVTRACK             = $90; //@@ Previous Track (GV_KEY_CIRCUMFLEX on Japanese keyboard)
  GV_KEY_AT                    = $91; //@@ AT Key (NEC PC98)
  GV_KEY_COLON                 = $92; //@@ : Key  (NEC PC98)
  GV_KEY_UNDERLINE             = $93; //@@ UNDERLINE Key  (NEC PC98)
  GV_KEY_KANJI                 = $94; //@@ KANJI Key (Japanese keyboard)
  GV_KEY_STOP                  = $95; //@@ STOP Key  (NEC PC98)
  GV_KEY_AX                    = $96; //@@ AX Key    (Japan AX)
  GV_KEY_UNLABELED             = $97; //@@ UNLABELED Key (J3100)
  GV_KEY_NEXTTRACK             = $99; //@@ Next Track
  GV_KEY_NUMPADENTER           = $9C; //@@ Enter on numeric keypad
  GV_KEY_RCONTROL              = $9D; //@@ RCTRL Key
  GV_KEY_MUTE                  = $A0; //@@ Mute
  GV_KEY_CALCULATOR            = $A1; //@@ Calculator
  GV_KEY_PLAYPAUSE             = $A2; //@@ Play / Pause
  GV_KEY_MEDIASTOP             = $A4; //@@ Media Stop
  GV_KEY_VOLUMEDOWN            = $AE; //@@ Volume -
  GV_KEY_VOLUMEUP              = $B0; //@@ Volume +
  GV_KEY_WEBHOME               = $B2; //@@ Web home
  GV_KEY_NUMPADCOMMA           = $B3; //@@ , on NUMPAD (NEC PC98)
  GV_KEY_DIVIDE                = $B5; //@@ / on NUMPAD
  GV_KEY_SYSRQ                 = $B7; //@@ SYSRQ Key
  GV_KEY_RMENU                 = $B8; //@@ RALT Key
  GV_KEY_PAUSE                 = $C5; //@@ PAUSE Key
  GV_KEY_HOME                  = $C7; //@@ HOME on arrow keypad
  GV_KEY_UP                    = $C8; //@@ UPARROW on arrow keypad
  GV_KEY_PRIOR                 = $C9; //@@ PGUP on arrow keypad
  GV_KEY_LEFT                  = $CB; //@@ LEFTARROW Key on arrow keypad
  GV_KEY_RIGHT                 = $CD; //@@ RightArrow on arrow keypad
  GV_KEY_END                   = $CF; //@@ End on arrow keypad
  GV_KEY_DOWN                  = $D0; //@@ DownArrow on arrow keypad
  GV_KEY_NEXT                  = $D1; //@@ PgDn on arrow keypad
  GV_KEY_INSERT                = $D2; //@@ Insert on arrow keypad
  GV_KEY_DELETE                = $D3; //@@ Delete on arrow keypad
  GV_KEY_LWIN                  = $DB; //@@ Left Windows Key
  GV_KEY_RWIN                  = $DC; //@@ Right Windows Key
  GV_KEY_APPS                  = $DD; //@@ AppMenu Key
  GV_KEY_POWER                 = $DE; //@@ System Power
  GV_KEY_SLEEP                 = $DF; //@@ System Sleep
  GV_KEY_WAKE                  = $E3; //@@ System Wake
  GV_KEY_WEBSEARCH             = $E5; //@@ Web Search
  GV_KEY_WEBFAVORITES          = $E6; //@@ Web Favorites
  GV_KEY_WEBREFRESH            = $E7; //@@ Web Refresh
  GV_KEY_WEBSTOP               = $E8; //@@ Web Stop
  GV_KEY_WEBFORWARD            = $E9; //@@ Web Forward
  GV_KEY_WEBBACK               = $EA; //@@ Web Back
  GV_KEY_MYCOMPUTER            = $EB; //@@ My Computer
  GV_KEY_MAIL                  = $EC; //@@ Mail
  GV_KEY_MEDIASELECT           = $ED; //@@ Media Select
  GV_KEY_BACKSPACE             = GV_KEY_BACK;      //@@ backspace
  GV_KEY_NUMPADSTAR            = GV_KEY_MULTIPLY;  //@@ * on numeric keypad
  GV_KEY_LALT                  = GV_KEY_LMENU;     //@@ left Alt
  GV_KEY_CAPSLOCK              = GV_KEY_CAPITAL;   //@@ CapsLock
  GV_KEY_NUMPADMINUS           = GV_KEY_SUBTRACT;  //@@ - on numeric keypad
  GV_KEY_NUMPADPLUS            = GV_KEY_ADD;       //@@ + on numeric keypad
  GV_KEY_NUMPADPERIOD          = GV_KEY_DECIMAL;   //@@ . on numeric keypad
  GV_KEY_NUMPADSLASH           = GV_KEY_DIVIDE;    //@@ / on numeric keypad
  GV_KEY_RALT                  = GV_KEY_RMENU;     //@@ right Alt
  GV_KEY_UPARROW               = GV_KEY_UP;        //@@ UpArrow on arrow keypad
  GV_KEY_PGUP                  = GV_KEY_PRIOR;     //@@ PgUp on arrow keypad
  GV_KEY_LEFTARROW             = GV_KEY_LEFT;      //@@ LeftArrow on arrow keypad
  GV_KEY_RIGHTARROW            = GV_KEY_RIGHT;     //@@ RightArrow on arrow keypad
  GV_KEY_DOWNARROW             = GV_KEY_DOWN;      //@@ DownArrow on arrow keypad
  GV_KEY_PGDN                  = GV_KEY_NEXT;      //@@ PgDn on arrow keypad
  GV_KEY_CIRCUMFLEX            = GV_KEY_PREVTRACK; //@@ Japanese keyboard

type
  //@@ Application active status event type
  TGVAppActivateEvent = procedure(aActive: Boolean);

  //@@ General notification event type
  TGVNotifyEvent = procedure(Sender: TObject) of object;

  //@@ Vector type - Used to get and pass positional information in the sdk
  TGVVector = record
    X: Single; //@@ Horizontal value
    Y: Single; //@@ Vertical value
    Z: Single; //@@ Used for special purposes
  end;
  PGVVector = ^TGVVector; //@@ TGVVector pointer type

  //@@ Rect type - Used to get and set rectanglular information in the sdk
  TGVRect = record
    Left  : Integer; //@@ Upper left position
    Top   : Integer; //@@ Upper top position
    Right : Integer; //@@ Lower right position
    Bottom: Integer; //@@ Lower bottom position
  end;
  PGVRect = ^TGVRect; //@@ TGVRect pointer type

  //@@ Display adapter information type - Returns informatin about the display adapter
  TGVDisplayAdapterInfo = record
    Driver       : string; //@@ adapter driver name
    Description  : string; //@@ adapter driver discription
  end;
  PGVDisplayAdapterInfo = ^TGVDisplayAdapterInfo; //@@ TGVDisplayAdapterInfo pointer type

  //@@ Display device information type - Returns information about display device capablities
  TGVDisplayDeviceInfo = record
    MaxTextureWidth           : Cardinal; //@@ Maximum texture width
    MaxTextureHeight          : Cardinal; //@@ Maximum texture heigth
    TexturesPOW2              : Boolean;  //@@ Do textures must be power of two
    TexturesNonPOW2Conditional: Boolean;  //@@ Do textures must be power of two under special conditions
    TexturesSquareOnly        : Boolean;  //@@ Do textures must square only
  end;
  PGVDisplayDeviceInfo = ^TGVDisplayDeviceInfo; //@@ TGVDisplayDeviceInfo pointer type

  //@@ Display mode information type - Returns information about a display mode
  TGVDisplayModeInfo = record
    Width      : Cardinal; //@@ Display mode width
    Height     : Cardinal; //@@ Display mode height
    Bpp        : Cardinal; //@@ Display mode format
  end;
  PGVDisplayModeInfo = ^TGVDisplayModeInfo; //@@ TGVDisplayModeInfo pointer type

  //@@ Sprite Image type - use to define sprite
  TGVSpriteImage = record
    Handle: Integer;  //@@ Sprite handle
    Page  : Cardinal; //@@ Sprite image page
    Group : Cardinal; //@@ Sprite image group
  end;
  PTGVSpriteImage = ^TGVSpriteImage; //@@ TGVSpriteImage pointer type

{$IFNDEF GV_EXPORTS }
var
  { Common Colors }
  GV_Black    : Cardinal; //@@ Black Color constant
  GV_White    : Cardinal; //@@ White Color constant
  GV_LtGray   : Cardinal; //@@ Light Gray Color contant
  GV_DkGray   : Cardinal; //@@ Dark Gray Color constant
  GV_Red      : Cardinal; //@@ Red Color constant
  GV_Green    : Cardinal; //@@ Green Color constant
  GV_DkGreen  : Cardinal; //@@ Dark Green Color constant
  GV_Blue     : Cardinal; //@@ Blue Color constant
  GV_Yellow   : Cardinal; //@@ Yellow Color constant
  GV_Pink     : Cardinal; //@@ Pink Color constant
  GV_Orange   : Cardinal; //@@ Orange Color constant
  GV_Overlay1 : Cardinal; //@@ Overlay1 Color constant (menu background)
  GV_Overlay2 : Cardinal; //@@ Overlay2 Color constant (spash background)
  GV_ColorKey : Cardinal; //@@ ColorKey Color constant (sprites)
{$ENDIF}

{$IFNDEF GV_EXPORTS}
{ === Startup Routines ================================================== }

//@@ Parameters:
//     aLogFilePriority - System logfile priority
//   Returns:
//     None
//   Description:
//     Initialize all GV subsystems and sets the initial system logfile
//     priority. This allows you to control the level of log data in your
//     application.
procedure GV_Init(aLogFilePriority: Byte=GV_LogFile_Priority_All); 

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Shuts down GV subsystems. You will not to call GV_Init again before
//     any GV routines can be used.
procedure GV_Done;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Reset the GV subsystems so that execution can continue after
//     GV_App_Terminate all been called.
procedure GV_Reset; external GV_SDK_DLL;

{ === LogFile Routines ================================================== }
//@@ Parameters:
//     None
//   Returns:
//     String value to the fullpath of the system logfile
//   Description:
//     Returns the fullpath to system logfile
function  GV_LogFile_GetPath: string; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Erases the system logfile
procedure GV_LogFile_Erase; external GV_SDK_DLL;

//@@ Parameters:
//     aPriority - LogFile priority level
//   Returns:
//     None
//   Description:
//     Sets the system logfile priority level. Any logging with a
//     priority less will be ignoried.
procedure GV_LogFile_SetPriority(aPriority: Byte); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Priority level
//   Description:
//     Returns the current system logfile priority level
function  GV_LogFile_GetPriority: Byte; external GV_SDK_DLL;

//@@ Parameters:
//     aPriority - Priority level
//     aMsg      - Message format string to write to logfile
//     aArgs     - Array of constants defined in the format string aMsg
//     aLoc      - String that you can define the location of this message in your source
//   Returns:
//     None
//   Description:
//     Writes a message to the system logfile at a specified priority level.
//     If the current priority is higher than aPriority then the message will
//     be ignoried.
procedure GV_LogFile_Write(aPriority: Byte; const aMsg: string; const aArgs: array of const; const aLoc: string); external GV_SDK_DLL;


{ === Error Routines ==================================================== }
//@@ Parameters:
//     aMsg  - Message format string to write to logfile
//     aArgs - Array of constants defined in the format string aMsg
//     aLoc  - String that you can define the location of this message in your source
//   Returns:
//     None
//   Description:
//     Aborts your application with an exception and optionally writes a
//     message to the system logfile
procedure GV_Error_Abort(const aMsg: string; const aArgs: array of const; const aLoc: string); external GV_SDK_DLL;


{ === CmdLine Routines ================================================== }
//@@ Parameters:
//     None
//   Returns:
//     String to the full path of the application start path
//   Description:
//     Returns the full path of the application start path
function  GV_CmdLine_GetStartPath: string; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Changes the current directory to the application start path
procedure GV_CmdLine_GotoStartPath; external GV_SDK_DLL;


{ === Color Routines ==================================================== }
//@@ Parameters:
//     aRed   - Red color value (0-255)
//     aGreen - Green color value (0-255)
//     aBlue  - Blue color value (0-255)
//     aAlpha - Alphia color value (0-255).
//   Returns:
//     A 32-bit color values used by Direct3D.
//   Description:
//     Creates a 32-bit color value used in Direct3D. The Alpha values will
//     control transparency for blended render states.
function  GV_Color_Make(aRed, aGreen, aBlue, aAlpha: Byte): Cardinal; external GV_SDK_DLL;
//@@ Parameters:
//     aColor - 32-bit color value
//     aRed   - Red color value to change (0-255), nil if not used
//     aGreen - Green color value to change (0-255), nil if not used
//     aBlue  - Blue color value to change (0-255), nil if not used
//     aAlpha - Alpha color value to change (0-255), nil if not used
//   Returns:
//     aColor will be updated with the new values
//   Description:
//     Updates a color value with new red+green+blue+alpha values
procedure GV_Color_Set(var aColor: Cardinal; aRed, aGreen, aBlue, aAlpha: PByte); external GV_SDK_DLL;

//@@ Parameters:
//     aColor - 32-bit color value
//     aRed   - Red color value to change (0-255), nil if not used
//     aGreen - Green color value to change (0-255), nil if not used
//     aBlue  - Blue color value to change (0-255), nil if not used
//     aAlpha - Alpha color value to change (0-255), nil if not used
//   Returns:
//     Each non-nil color componet will be filled in
//   Description:
//     Return the individual color componet from a 32-bit color value
procedure GV_Color_Get(aColor: Cardinal; aRed, aGreen, aBlue, aAlpha: PByte); external GV_SDK_DLL;


{ === Timer Routines ==================================================== }
//@@ Parameters:
//     aDesiredFPS     - Desired simulate rate
//     aMaxElapsedTime - Maximum elased time to manage desired simulation rate
//   Returns:
//     None
//   Description:
//     Initialize timing to manage your application simulation rate. GV
//     Frame-Based timing to control the application simulation. GV will try
//     to first use the performance counter if available. If not it will then
//     fall back to Windows timeGetTime routine.
procedure GV_Timer_Init(aDesiredFPS, aMaxElapsedTime: Single); external GV_SDK_DLL;
//@@ Parameters:
//     None
//   Returns:
//     Tick count in milliseconds
//   Description:
//     Returns the tick count in milliseconds.
function  GV_Timer_GetTickCount: Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Updates the elased time values used for timing and calculates the
//     current framerate.
procedure GV_Timer_Update; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Elasped time since last frame.
//   Description:
//     Elasped time since last frame. This values when multiplied by
//     your object speeds, will keep them moving properly at your
//     desired simlation framerate.
function  GV_Timer_ElapsedTime: Single; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Current framerate
//   Description:
//     Returns the applications current framerate.
function  GV_Timer_FrameRate: Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aTimer       - Timer value
//     aFrames      - Number of frames to track
//     aElapsedTime - Elapsed time returned from GV_Timer_ElapsedTime
//   Returns:
//     TRUE if aFrames have elapsed, FALSE if not.
//   Description:
//     Allows you to do timing based on elapsed frames.
function  GV_Timer_FrameElapsed(var aTimer: Single; aFrames, aElapsedTime: Single): Boolean; external GV_SDK_DLL;


{ === RezFile Routines ================================================== }
//@@ Parameters:
//     aMaxCount - Maximum number of rezfile you want GV to manage
//   Returns:
//     None
//   Description:
//     Allocate resources necessary to manage aMaxCount number of rezfile
//     during this session. This routine must be called before any rezfile
//     routines can be used. All rezfile resources will be disposed on
//     application exit.
procedure GV_RezFile_Init(aMaxCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Free all resourced used by the RezFile system. You muse call
//     GV_RezFile_Init after this call.
procedure GV_RezFile_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aPath - Full path to ZIP archive on disk
//   Returns:
//     Handle to open ZIP rezfile
//   Description:
//     Opens and returns an handle to a ZIP archive rezfile
function  GV_RezFile_OpenArchive(const aPath: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//   Returns:
//     None
//   Description:
//     Closes an open ZIP archive rezfile
procedure GV_RezFile_CloseArchive(var aRezFile: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//     aPath    - Full path to file inside a ZIP archive rezfile
//   Returns:
//     None
//   Description:
//     Opens a file inside the ZIP archive for reading.
procedure GV_RezFile_OpenFile(aRezFile: Integer; const aPath: string); external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//   Returns:
//     None
//   Description:
//     Closes a an open file inside a ZIP archive rezfile
procedure GV_RezFile_CloseFile(aRezFile: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//   Returns:
//     Size of the an open file inside a ZIP archive rezfile
//   Description:
//     Returns the size of an open file inside a ZIP archive rezfile
function  GV_RezFile_FileSize(aRezFile: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//     aBuffer  - Buffer to write file data to
//     aLen     - Size of data to write to aBuffer
//   Returns:
//     Number of bytes read
//   Description:
//     Reads a aLen amount of data of an open file into aBuffer
function  GV_RezFile_ReadFile(aRezFile: Integer; aBuffer: Pointer; aLen: Cardinal): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//     aLen     - How much to move the file pointer
//     aOrigin  - Location to start search from inside the file
//   Returns:
//     None
//   Description:
//     Moves the file point aLen bytes from origin aOrigin.
//   Remarks
//     Seeking from the end of file is not currently supported.
procedure GV_RezFile_SeekFile(aRezFile: Integer; aLen: Cardinal; aOrigin: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//   Returns:
//     Current file pointer position
//   Description:
//     Returns the file pointer position of an open file inside a ZIP archive
//     rezfile
function  GV_RezFile_FilePos(aRezFile: Integer): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//   Returns:
//     TRUE if end of file, FALSE if not
//   Description:
//     Returns the status if the file pointer of an open file inside a ZIP
//     archive has reached the end
function  GV_RezFile_EndOfFile(aRezFile: Integer): Boolean; external GV_SDK_DLL;


{ === App Routines ====================================================== }
//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Allows Windows to process messages
procedure GV_App_ProcessMessages; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Sets the application termination flag to true. You can use
//     GV_App_ItTerminated to check if you need to terminated the game
//     loop.
procedure GV_App_Terminate; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE if application termination flag is set, FALSE if not
//   Description:
//     Checks to see if the application termination flag has been set.
//     You can safely exit the application gameloop.
function  GV_App_IsTerminated: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - Handle to an open ZIP archive rezfile
//     aPath    - Full path to icon inside the rezfile
//   Returns:
//     None
//   Description:
//     Sets the global icon used by GV windows and dialogs. If you aRezFile
//     is less than 0 (-1 or GV_NIL), all routines in GV that can load from
//     a rezfile will try to load the resource from disk instead.
procedure GV_App_SetIcon(aRezFile: Integer; const aPath: string); external GV_SDK_DLL;

//@@ Parameters:
//     aWindowCaption - Window caption string
//   Returns:
//     TRUE is application is already running, FALSE if not.
//   Description:
//     Checks to see if an instance of the application is already running. If
//     it is, will bring the first window with aWindowCaption to the front,
//     return its state to normal if its minimized.
//   Remarks
//     This routine can only bring the application to the forground based on
//     the caption. If you have a dialog that is not named aWindowCaption, it
//     will still return true, but will fail to bring it to front and change
//     the window state to normal.
function  GV_App_AlreadyRunning(aWindowCaption: string): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aProc - Pointer to an applicatoin activate status procedure, NIL to
//     disable
//   Returns:
//     None
//   Description:
//     Sets an procedure to be called when the application become active or
//     inactive
procedure GV_App_SetOnActivateEvent(aProc: TGVAppActivateEvent); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Pointer to current app activate status procedure, NIL if not set
//   Description:
//     Returns a pointer to the current app activate status routine.
function  GV_App_GetOnActivateEvent: TGVAppActivateEvent; external GV_SDK_DLL;

//@@ Parameters:
//     aActive - Application active status (TRUE if active, FALSE if not)
//   Description:
//     Calls the currently defined application activate status routine
//     with a status of active or inactive.
procedure GV_App_OnActivate(aActive: Boolean); external GV_SDK_DLL;


{ === AppWindow Routines ================================================ }
//@@ Parameters:
//     aCaption - Window caption
//     aWidth   - Window client width
//     aHeight  - Window client height
//   Returns:
//     None
//   Description:
//     Opens a application window suitable for rendering.
procedure GV_AppWindow_Open(const aCaption: string; aWidth, aHeight: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Closes an application window
procedure GV_AppWindow_Close; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE is application window is open, FALSE if not.
//   Description:
//     Checks if an application window is open
function  GV_AppWindow_IsOpen: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Makes an open application window visible and brings it to the front.
procedure GV_AppWindow_Show; external GV_SDK_DLL;

//@@ Parameters:
//     aWidth  - Window client width
//     aHeight - Window client height
//   Returns:
//     if a parameter is not nil, it will be filled with its perspective value
//   Description:
//     Get the size of an application window
procedure GV_AppWindow_GetSize(aWidth, aHeight: PCardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Handle of open application window
//   Description:
//     Returns the handle (HWND) to an open application window
function  GV_AppWindow_GetHandle: Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aShow - TRUE to show cursor, FALSE to hide cursor
//   Returns:
//     None
//   Description:
//     Toggle applicatino window cursor on/off
procedure GV_AppWindow_ShowCursor(aShow: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     aPos - Mouse cursor position vector
//   Returns:
//     aPos will be filled in with the current mouse XY position
//   Description:
//     Returns the posiion of the mouse cursor within the application window
procedure GV_AppWindow_GetMousePos(var aPos: TGVVector); external GV_SDK_DLL;


{ === Input Routines ==================================================== }
//@@ Parameters:
//     aHandle   - Handle (HWND) to a window
//     aWindowed - TRUE if windowed mode, FALSE if fullscreen
//   Returns:
//     None
//   Description:
//     Initializes input system for keyboard and mouse input.
procedure GV_Input_Open(aHandle: Cardinal; aWindowed: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Closes input system
procedure GV_Input_Close; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE if input is open, FALSE if not
//   Description:
//     None
function  GV_Input_IsOpen: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Update the input system and gathers input data for keyboard and mouse
procedure GV_Input_Update; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Resets the input system
procedure GV_Input_Reset; external GV_SDK_DLL;

//@@ Parameters:
//     aAcquire - TRUE to acquire, FALSE to unacquire
//   Returns:
//     None
//   Description:
//     Acquires/Unacquires the input system
procedure GV_Input_Acquire(aAcquire: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     ASCII key value
//   Description:
//     Returns an ASCII value for a pressed key
function  GV_Input_AscKey: Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aCode - Scan code (0-255)
//   Returns:
//     ASCII key value of scan code
//   Description:
//     Returns an ASCII value for a specified scan code
function  GV_Input_ScanCodeToAsc(aCode: Byte): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aCode - Key code
//   Returns:
//     TRUE, if pressed, FALSE if not
//   Description:
//     Checks if a key is currently being pressed.
function  GV_Input_KeyPressed(aCode: Byte): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aCode - Key code
//   Returns:
//     TRUE if was released, FALSE if not
//   Description:
//     Checks if a pressed key was released.
function  GV_Input_KeyReleased(aCode: Byte): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aCode - Key code
//   Returns:
//     TRUE is hit, FALSE if not
//   Description:
//     Checks if a key was pressed
function  GV_Input_KeyHit(aCode: Byte): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aButton - Mouse button (0-3)
//   Returns:
//     TRUE if pressed, FALSE if not
//   Description:
//     Checks if a mouse button is currently being pressed
function  GV_Input_MousePressed(aButton: Byte): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aButton - Mouse button (0-3)
//   Returns:
//     TRUE is released, FALSE if not
//   Description:
//     Check is a pressed mouse button was released.
function  GV_Input_MouseReleased(aButton: Byte): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aButton - Mouse button (0-3)
//   Returns:
//     TRUE is hit, FALSE if not
//   Description:
//     Check if a mouse button was pressed
function  GV_Input_MouseHit(aButton: Byte): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aPos - Mouse position vector
//   Returns:
//     XY position of mouse cursor
//   Description:
//     Returns the relative position of the mouse cursor. Properly handles
//     mouse in both window/full and within an established viewport
procedure GV_Input_GetMousePosRel(var aPos: TGVVector); external GV_SDK_DLL;

//@@ Parameters:
//     aPos - Mouse position vector
//   Returns:
//     XY position of mouse cursor
//   Description:
//     Returns the absolute position of the mouse cursor. Properly handles
//     mouse in both window/full and within an established viewport
procedure GV_Input_GetMousePosAbs(var aPos: TGVVector); external GV_SDK_DLL;

//@@ Parameters:
//     aX - Mouse horizontal position
//     aY - Mouse vertical position
//   Returns:
//     None
//   Description:
//     Sets the absolute position of the mouse cursor
procedure GV_Input_SetMousePos(aX, aY: Integer); external GV_SDK_DLL;


{ === RenderDevice ====================================================== }
//@@ Parameters:
//     None
//   Returns:
//     Adapter count
//   Description:
//     Returns the number of adapters on host machine
function  GV_RenderDevice_GetAdapterCount: Cardinal;  external GV_SDK_DLL;

//@@ Parameters:
//     aAdapterNum - Adapter number
//   Returns:
//     Device count
//   Description:
//     Returns the number of devices attached to adapter
function  GV_RenderDevice_GetDeviceCount(aAdapterNum: Cardinal): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aNum  - Adapter number
//     aInfo - DisplayAdapterInfo record
//   Returns:
//     Fills in aInfo with adapter information
//   Description:
//     Returns information about an adapter
procedure GV_RenderDevice_GetAdapterInfo(aNum: Cardinal; var aInfo: TGVDisplayAdapterInfo); external GV_SDK_DLL;

//@@ Parameters:
//     aAdapter - Adapter number
//     aDevice  - Device number
//     aInfo    - DeviceInfo record
//   Returns:
//     Fills in aInfo with device information
//   Description:
//     Returns information about a device
procedure GV_RenderDevice_GetDeviceInfo(aAdapter, aDevice: Cardinal; var aInfo: TGVDisplayDeviceInfo); external GV_SDK_DLL;

//@@ Parameters:
//     aAdapter - Adapter number
//     aDevice  - Device number
//   Returns:
//     Mode count
//   Description:
//     Returns the number of video modes for a device
function  GV_RenderDevice_GetModeCount(aAdapter, aDevice: Cardinal): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aAdapter - Adapter number
//     aDevice  - Device number
//     aMode    - Mode number
//     aInfo    - Information
//   Returns:
//     Fill in aInfo with device mode information
//   Description:
//     Returns mode information for a device
procedure GV_RenderDevice_GetModeInfo(aAdapter, aDevice, aMode: Cardinal; var aInfo: TGVDisplayModeInfo); external GV_SDK_DLL;

//@@ Parameters:
//     aWidth  - Screen width
//     aHeight - Screen height
//     aBpp    - Screen bits per pixel
//   Returns:
//     TRUE if mode can be set, FALSE if not
//   Description:
//     Checks if a video mode can be set
function  GV_RenderDevice_ValidMode(aWidth, aHeight, aBpp: Cardinal): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aHandle     - Window handle
//     aWidth      - Screen width
//     aHeight     - Screen height
//     aBpp        - Screen bits per pixel
//     aWindowed   - TRUE if windowed mode, FALSE if fullscreen
//     aSwapEffect - Direct3D swap effect
//   Returns:
//     None
//   Description:
//     Sets video mode to windowed or fullscreen mode.
procedure GV_RenderDevice_SetMode(aHandle, aWidth, aHeight, aBpp: Cardinal; aWindowed: Boolean; aSwapEffect: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE if mode is set, FALSE if not
//   Description:
//     Checks if a graphics mode has been set
function  GV_RenderDevice_ModeIsSet: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Restore the video mode back to the old desktop resolution
procedure GV_RenderDevice_RestoreMode; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE if device is ready, FALSE if not
//   Description:
//     Checks to see the rendering device is ready for rendering.
function  GV_RenderDevice_IsReady: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Handle of rendering window
//   Description:
//     Returns the handle to the window used for rendering
function  GV_RenderDevice_GetHandle: Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE if windowed mode, FALSE if not
//   Description:
//     Check if render to window or fullscreen
function  GV_RenderDevice_IsWindowed: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aX      - Horizontal position
//     aY      - Vertical position
//     aWidth  - Width of viewport
//     aHeight - Width of viewport
//   Returns:
//     None
//   Description:
//     Establishes a viewport for rendering device
procedure GV_RenderDevice_SetViewport(aX, aY, aWidth, aHeight: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Resets the viewport to full area of established graphics mode
procedure GV_RenderDevice_ResetViewport; external GV_SDK_DLL;

//@@ Parameters:
//     aX      - Horizontal position
//     aY      - Vertical position
//     aWidth  - Width of viewport
//     aHeight - Height of viewport
//   Returns:
//     Fills in the parameters with the appropreiate values if not nill
//   Description:
//     None
procedure GV_RenderDevice_GetViewport(aX, aY, aWidth, aHeight: PCardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aRenderState - Render state
//   Returns:
//     None
//   Description:
//     Sets a new render
procedure GV_RenderDevice_SetRenderState(aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Current render state
//   Description:
//     Returns the current render state
function  GV_RenderDevice_GetRenderState: Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aFlags - Clear frame flag
//     aColor - Clear color
//   Returns:
//     None
//   Description:
//     Clears the frame buffer to specified color. You can set special options
//     via the aFlags parameter
procedure GV_RenderDevice_ClearFrame(aFlags: Cardinal; aColor: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE if can start rendering, FALSE if not
//   Description:
//     Tell render devicde to start accepting polygons
function  GV_RenderDevice_StartFrame: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Tell render device to stop accepting polygons
procedure GV_RenderDevice_EndFrame; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Makes the current framebuffer visible
procedure GV_RenderDevice_ShowFrame; external GV_SDK_DLL;

//@@ Parameters:
//     aPath - Full path to a file on disk
//   Returns:
//     None
//   Description:
//     Save the current frame buffer to a PNG file on disk
procedure GV_RenderDevice_SaveFrame(const aPath: string); external GV_SDK_DLL;

//@@ Parameters:
//     aX0          - Starting X position
//     aY0          - Starting Y position
//     aX1          - Ending X position
//     aY1          - Endign y position
//     aColor       - Color of line
//     aRenderState - Renderstate
//   Returns:
//     None
//   Description:
//     Renders a line via the hardware
procedure GV_RenderDevice_DrawLine(aX0, aY0, aX1, aY1: Single; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aX           - Rectable X position
//     aY           - Rectagle Y position
//     aWidth       - Rectangle Width
//     aHeight      - Rectangle Height
//     aColor       - Rectangle color
//     aRenderState - Render state
//   Returns:
//     None
//   Description:
//     Render a filled rectangle via the video hardware
procedure GV_RenderDevice_DrawRect(aX, aY, aWidth, aHeight: Single; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aX           -  Pixel X pos
//     aY           -  Pixel Y pos
//     aColor       -  Pixel Color
//     aRenderState - Render state
//   Returns:
//     None
//   Description:
//     Renders a single pixel via the video hardware
procedure GV_RenderDevice_DrawPixel(aX, aY: Single; aColor, aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aX           - Circle X position
//     aY           - Circle Y position
//     aRadius      - Circle radius
//     aColor       - Circle color
//     aRenderState - Render state
//     aFilled      - TRUE for filled, FALSE for outlined
//   Returns:
//     None
//   Description:
//     Renders a circle via the video hardware
procedure GV_RenderDevice_DrawCircle(aX, aY, aRadius: Single; aColor, aRenderState: Cardinal; aFilled: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Texture memory amount
//   Description:
//     Returns the avaible texture memory rounded to the nearest MB.
function  GV_RenderDevice_GetAvailableTextureMem: Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aDirect3D - IDirect3D8 object
//   Returns:
//     Interface to IDirect3D8 object
//   Description:
//     Returns GVs IDirect3D8 object.
//   Remarks:
//     You must typecase to IDirect3D8 yourself (DirectX 8.1) and be sure to
//     release the device after uses by setting it to nil as its reference count
//     is increased after this call.
procedure GV_RenderDevice_GetDirect3D(out aD3D: IInterface); external GV_SDK_DLL;

//@@ Parameters:
//     aDD3DDevice - IDirect3DDevice8 object
//   Returns:
//     Interface to IDirect3DDevice8 object
//   Description:
//     Returns GVs IDirect3DDevice8 object.
//   Remarks:
//     You must typecase to IDirect3DDevice8 yourself (DirectX 8.1) and be sure to
//     release the device after uses by setting it to nil as its reference count
//     is increased after this call.
procedure GV_RenderDevice_GetD3DDevice(out aD3DDevice: IInterface); external GV_SDK_DLL;


{ === Points Routines =================================================== }

//@@ Parameters:
//     aTotal - Total number of points to manage
//   Returns:
//     None
//   Description:
//     Allocate resources to manage aTotal number of hardware rendered
//     points.
procedure GV_Points_Init(aTotal: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Free resources used to render hardware points
procedure GV_Points_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aCount - Number of hardware points to render
//   Returns:
//     None
//   Description:
//     Sets the number of points out of the total to render
procedure GV_Points_SetCount(aCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aTotal - Total number of points allocated (if not nil)
//     aCount - Number of points currently rendered (if not nil)
//   Returns:
//     None
//   Description:
//     Return the maxinum number of points and the number of points currently
//     being rendered.
procedure GV_Points_GetSize(aTotal: PCardinal; aCount: PCardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aIndex - Point index (0 - aTotal-1)
//     aX     - Point X position
//     aY     - Point Y position
//     aColor - Point Color
//   Returns:
//     None
//   Description:
//     Set a point position and color
procedure GV_Points_SetPoint(aIndex: Cardinal; aX: PSingle; aY: PSingle; aColor: PCardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aIndex - Point index (0 - aTotal-1)
//     aX     - Point X position
//     aY     - Point Y position
//     aColor - Point Color
//   Returns:
//     None
//   Description:
//     Get a point position and color
procedure GV_Points_GetPoint(aIndex: Cardinal; aX: PSingle; aY: PSingle; aColor: PCardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aRenderState - A GV render state
//   Returns:
//     None
//   Description:
//     Renders all the points via the 3D hardware
procedure GV_Points_Render(aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aFirst       - First point index to render
//     aLast        - last point index to render
//     aRenderState - A GV render state
//   Returns:
//     None
//   Description:
//     Render points between aFirst and aLast
procedure GV_Points_RenderRange(aFirst, aLast, aRenderState: Cardinal); external GV_SDK_DLL;


{ === Texture Routines ================================================== }

//@@ Parameters:
//     aMaxCount - Maximum number of textures to manage
//   Returns:
//     None
//   Description:
//     Allocate aMaxCount texture that GV will manage for all texture usage
procedure GV_Texture_Init(aMaxCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Free all texture resourced allocated with GV_Texture_Init.
procedure GV_Texture_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile  - RezFile handle
//     aColorKey - Texture colorkey, set to zero if image has an alpha channel
//     aPath     - Path to texture on disk or in rezfile
//   Returns:
//     Handle to loaded texture
//   Description:
//     Loads a texture from disk or rezfile.
//   Remarks
//     If you image has an alpha channel, set colorkey to zero to use it.
function  GV_Texture_Load(aRezFile: Integer; aColorKey: Cardinal; const aPath: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aTexture -
//   Returns:
//     aTexture will be set to GV_NILL (-1)
//   Description:
//     Releases allocated texture resources.
//   Remarks
//     All texture resources will be released upon program exit.
procedure GV_Texture_Dispose(var aTexture: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Releases all loaded texture resources.
procedure GV_Texture_DisposeAll; external GV_SDK_DLL;

//@@ Parameters:
//     aTexture     - Texture handle
//     aX           - Horizontal postion
//     aY           - Vertical positoin
//     aScale       - Scale factor
//     aAngle       - Angle (0-360)
//     aColor       - Texture render color
//     aRect        - Rectangle portion of texture to render
//     aRenderState - Renderstate to apply to texture
//   Returns:
//     None
//   Description:
//     Renders a rectangle portions of a texture at specified postion, applying
//     scaling, angle and color
//   Remarks
//      X,Y   - Texture will be cenered at position XY.
//      Scale - Negative values will scale down, positive values will scale up
//      Rect  - If rect is nil, the whole texture will be rendered
procedure GV_Texture_Render(aTexture: Integer; aX, aY, aScale, aAngle: Single; aColor: Cardinal; aRect: PGVRect; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aTexture     - Texture handle
//     aX           - Horizontal postion
//     aY           - Vertical positoin
//     aWidth       - Width
//     aHeight      - Height
//     aColor       - Color
//     aRenderState - Renderstate to apply to texture
//   Returns:
//     None
//   Description:
//     Renders a texture at XY with aWidth and aHeight size in aColor
//   Remarks
//     X,Y - Texture will be rendered at upper-left corner started at XY
procedure GV_Texture_RenderSized(aTexture: Integer; aX, aY, aWidth, aHeight: Single; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aTexture     - Texture handle
//     aX           - Horizontal postion
//     aY           - Vertical positoin
//     aRect        - Rectangle portion of texture to render
//     aColor       - Texture render color
//     aRenderState - Renderstate to apply to texture
//   Returns:
//     None
//   Description:
//     Renders a rectangle portion of texture.
//   Remarks
//     X,Y - Texture will be rendered at upper-left corner started at XY
procedure GV_Texture_RenderRect(aTexture: Integer; aX, aY: Single; aRect: PGVRect; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aTexture     - Texture handle
//     aX           - Horizontal postion
//     aY           - Vertical positoin
//     aRect        - Rectangle portion of texture to render
//     aXScale      - Horizontal scale
//     aYScale      - Vertical scale
//     aColor       - Texture render color
//     aRenderState - Renderstand to apply to texture
//   Returns:
//     None
//   Description:
//     Renders a rectangle portion of texture at XY that is scaled by aXScale
//     and aYScale
//   Remarks
//     X,Y - Texture will be rendered at upper-left corner started at XY
procedure GV_Texture_RenderRectScaled(aTexture: Integer; aX, aY: Single; aRect: PGVRect; aXScale, aYScale: Single; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aTexture - Texture handle
//     aPath    - Full filename path on disk
//   Returns:
//     None
//   Description:
//     Saves texture to disk
procedure GV_Texture_Save(aTexture: Integer; const aPath: string); external GV_SDK_DLL;

//@@ Parameters:
//     aTexture - Texture handle
//     aRect    - Rectangle portion to lock
//     aPitch   - Pitch of locked texture
//   Returns:
//     aPitch and pointer to locked texture bits
//   Description:
//     Locks a rectangle portion of a texture and returns a poitner to the
//     texture bits.
//   Remarks
//     Rect  - if aRect is not nil, will lock aRect portion of texture
//     Pitch - If aPitch is not nil, will return the pitch of locked texture
function  GV_Texture_Lock(aTexture: Integer; aRect: PGVRect; aPitch: PInteger): Pointer; external GV_SDK_DLL;

//@@ Parameters:
//     aTexture - Texture handle
//   Returns:
//     None
//   Description:
//     Unlockes a texture previousely locked with GV_Texture_Lock
//   Remarks
//     Its important to not keep texture locked for an extermally long period
//     of time. You should lock, perform your task and unlock as quickly as
//     possible.
procedure GV_Texture_Unlock(aTexture: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     aTexture - Texture handle
//     aWidth   - Texture width
//     aHeight  - Texture height
//   Returns:
//     Width in aWidth if not nil
//     Height in aHeight if not nil
//   Description:
//     Get the width and height a texture
procedure GV_Texture_GetSize(aTexture: Integer; aWidth, aHeight: PCardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aTexture - Texture Handle
//     aX       - Horizontal position in texture space
//     aY       - Vertical position in texture space
//     aColor   - Pixel color (ARGB format)
//   Returns:
//     None
//   Description:
//     Sets a pixel color on texture at XY position.
//   Remarks
//     Texture must be locked before this routine can be used.
procedure GV_Texture_SetPixel(aTexture, aX, aY: Integer; aColor: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aTexture - Texture Handle
//     aX       - Horizontal position in texture space
//     aY       - Vertical position in texture space
//     aColor   - Pixel color (ARGB format)
//   Returns:
//     None
//   Description:
//     Gets a pixel color on texture at XY position.
//   Remarks
//     Texture must be locked before this routine can be used.
function  GV_Texture_GetPixel(aTexture, aX, aY: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aTexture     - Texture Handle
//     aDD3DTexture - IDirect3DTexture8 object
//   Returns:
//     Interface to IDirect3DTexture8 object
//   Description:
//     Returns GVs IDirect3DTexture8 object.
//   Remarks:
//     You must typecase to IDirect3DTexture8 yourself (DirectX 8.1) and be
//     sure to release the device after uses by setting it to nil as its
//     reference count is increased after this call.
procedure GV_Texture_GetD3DTexture(aTexture: Integer; out aD3DTexture: IInterface); external GV_SDK_DLL;

//@@ Parameters:
//     aWidth   - Width of new texture
//     aHeight  - Height of new texture
//   Returns:
//     Handle to texture
//   Description:
//     Creates a new texture in ARGB format. This texture can be used just like
//     a texture created with GV_Texture_Load
function  GV_Texture_Alloc(aWidth, aHeight: Cardinal): Integer; external GV_SDK_DLL;


{ === Font Routines ===================================================== }

//@@ Parameters:
//     aMaxCount - Maximum fonts to manage
//   Returns:
//     None
//   Description:
//     Tell GV the maximum number of fonts it should be responsable for.
procedure GV_Font_Init(aMaxCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Releases all allocated font resources managed by GV
procedure GV_Font_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aFont - Font handle
//   Returns:
//     aFont will be nil afterwards
//   Description:
//     Releases a allocated font
procedure GV_Font_Dispose(var aFont: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Releases all allocated fonts
procedure GV_Font_DisposeAll; external GV_SDK_DLL;

//@@ Parameters:
//     aFont     - Font handle
//     aBaseName - Base name of font excluding any file extension
//   Returns:
//     Saves the font texture out to disk along with the rectangle data.
//   Description:
//     Saves a allocated font resource to disk
procedure GV_Font_Save(aFont: Integer; const aBaseName: string); external GV_SDK_DLL;

//@@ Parameters:
//     aFontName  - Name of a valid TrueType font on your system
//     aSize      - Font Size of font
//     aAttribute - Font Attribute
//     aItalic    - Italic flags
//     aSaveName  - Base name of font excluding any file extension
//   Returns:
//     None
//   Description:
//     Builds a GV Font resource from TrueType fonts on your machine.
function  GV_Font_Build(const aFontName: string; aSize, aAttribute: Integer; aItalic: Boolean; const aSaveName: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile  - RezFile handle
//     aBaseName - Base name of font to load from disk or rezfile
//   Returns:
//     Font handle
//   Description:
//     Loads a font resource from a rezfile or disk
function  GV_Font_Load(aRezFile: Integer; const aBaseName: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aFont - Font handle
//     aC    - Font charactor code
//     aX1   - Rect upper right
//     aY1   - Rect upper left
//     aX2   - Rect lower right
//     aY2   - Rect lower bottom
//   Returns:
//     None
//   Description:
//     Adjusts the display rectange for a font.
//   Remarks
//     You can use the routine to make adjustments to the display rectangle for
//     a font character.
procedure GV_Font_AdjustRect(aFont: Integer; aC: char; ax1, ay1, ax2, ay2: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     aFont - Font handle
//     aMsg  - Texture message format
//     aArgs - Message arguments
//   Returns:
//     Lenght of formatted string
//   Description:
//     Returns the length of a formated message for a font.
function  GV_Font_StrWidth(aFont: Integer; const aMsg: string; const aArgs: array of const): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aFont - Font handle
//     aMsg  - Texture message format
//     aArgs - Message arguments
//   Returns:
//     Height
//   Description:
//     Returns the height of a formated message for the tallest character in
//     string.
function  GV_Font_StrHeight(aFont: Integer; const aMsg: string; const aArgs: array of const): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aFont  - Font handle
//     aX     - Horizontal position
//     aY     - Vertical position
//     aColor - Font color
//     aMsg   - Format message
//     aArgs  - Message arguments
//   Returns:
//     None
//   Description:
//     Renders a formated message in aFont at XY in color aColor
procedure GV_Font_Print(aFont: Integer; aX, aY: Single; aColor: Cardinal; const aMsg: string; const aArgs: array of const); external GV_SDK_DLL;

//@@ Parameters:
//     aFont   - Font handle
//     aX      - Horizontal position
//     aY      - Vertical position
//     aHeight - Height to update aY by
//     aColor  - Font color
//     aMsg    - Format message
//     aArgs   - Message arguments
//   Returns:
//     aY will be incremented by aHeight
//   Description:
//     Same as GV_Font_Print except that the horizontal position variable will
//     be update by aHeight on each call.
//   Remarks
//     Since the Y position will be updated after each call, makes it eaiser to
//     display many lines of text without having to calculate each successive
//     vertical position.
procedure GV_Font_PrintY(aFont: Integer; aX: Single; var aY: Single; aHeight: Cardinal; aColor: Cardinal; const aMsg: string; const aArgs: array of const); external GV_SDK_DLL;

//@@ Parameters:
//     aFont  - Font handle
//     aY     - Vertical position
//     aColor - Font color
//     aMsg   - Format message
//     aArgs  - Message arguments
//   Returns:
//     None
//   Description:
//     Centers a formated message in aFont at XY in color aColor
procedure GV_Font_Center(aFont: Integer; aY: Single; aColor: Cardinal; const aMsg: string; const aArgs: array of const); external GV_SDK_DLL;

//@@ Parameters:
//     aFont - Font handle
//   Returns:
//     Texture handle
//   Description:
//     Returns the texture handle of loaded font
function  GV_Font_GetTexture(aFont: Integer): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile  - RezFile handle
//     aColorKey - Texture colorkey
//     aPath     - Full path of texture on disk or insize rezfile
//   Returns:
//     Font handle
//   Description:
//     Creates a font resource from a texture.
//   Remarks
//     You can use this routine along with GV_Font_GetRect and GV_Font_SetRect
//     to create custom fonts.
function  GV_Font_LoadImage(aRezFile: Integer; aColorKey: Cardinal; const aPath: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aFont   - Font handle
//     aC      - Charactor code
//     aLeft   - Upper left position of char rectangle in texture space
//     aTop    - Upper top position of char rectangle in texture space
//     aRight  - Lower right position of char rectangle in texture space
//     aBottom - Lower bottom positio of char rectangele in texture space
//   Returns:
//     None
//   Description:
//     Get the display rectangle of a font character.
procedure GV_Font_GetRect(aFont: Integer; aC: Char; aLeft, aTop, aRight, aBottom: PInteger); external GV_SDK_DLL;

//@@ Parameters:
//     aFont   - Font handle
//     aC      - Charactor code
//     aLeft   - Upper left position of char rectangle in texture space
//     aTop    - Upper top position of char rectangle in texture space
//     aRight  - Lower right position of char rectangle in texture space
//     aBottom - Lower bottom positio of char rectangele in texture space
//   Returns:
//     None
//   Description:
//     Set the display rectangle of a font character.
procedure GV_Font_SetRect(aFont: Integer; aC: Char;  aLeft, aTop, aRight, aBottom: Integer); external GV_SDK_DLL;


{ === Sprite Routines =================================================== }

//@@ Parameters:
//     aMaxCount - Maximum Number of Sprite objects to reserve in Memory.
//   Returns:
//     None.
//   Description:
//     Creates a fixed number of sprite objects in memory.  These objects
//     are indexed.  This represents the maximum number of active sprite
//     objects that may be in use by your program at the same time.
//     This command will destroy any existing GV_Sprite objects.
procedure GV_Sprite_Init(aMaxCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Use this to clean up the GV_Sprite objects from memory.  You should call this before
//     exiting your code to ensure proper memory release. 
//   Remarks:
//     This routine will be called at program exit to cleanup all sprite resources.
procedure GV_Sprite_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite - Index to a GV_Sprite object.
//   Returns:
//     None
//   Description:
//     Clears the sprite at index aSprite.  Treated as NIL for your code's purposes.
procedure GV_Sprite_Dispose(var aSprite: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Use this command to dispose of all GV_Sprite objects.
procedure GV_Sprite_DisposeAll; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Index to the sprite object created or -1 if error.
//   Description:
//     Before using a sprite, you must call GV_Sprite_Create.  This command
//     will alloct a new sprite object in GV_Sprite memory for you.  If
//     you have no open sprites (set when you called GV_Sprite_Init) then
//     this function returns -1.
function  GV_Sprite_Create: Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite   - Index to the sprite object.
//     aRezFile  - Index to the open rez file.
//     aColorKey - Masking color, usually 255,0,255,255.
//     aPath     - Path in the rez structure to the texture.
//   Returns:
//     Page Index the texture was loaded into or -1 if error.
//   Description:
//     This command loads a texture in a sprite's texture memory.  A sprite keeps 0-N pages of
//     textures.  This command returns the index of the page consumed by this load command.
function  GV_Sprite_LoadPage(aSprite: Integer; aRezFile: Integer; aColorKey: Cardinal; const aPath: string): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite - Index to sprite.
//   Returns:
//     Group Index or -1 if error.
//   Description:
//     A sprite keeps 0-N groups of images.  A sprite must have at least one group before loading.
//     This command will create a new group for the sprite and return it's index.
function  GV_Sprite_AddGroup(aSprite: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite - Sprite Index
//     aPage   - Texture Page Index
//     aGroup  - Texture Group Index
//     aRect   - Rectangle defining the slice of texture to use.
//   Returns:
//     Index to the image rectangle defined or -1 if an error.
//   Description:
//     Use this command to add a custom (non-grid) rectangular shape to the sprite's animation sequence.
//     This is usefull when you have odd-shaped frames of animation within a texture.
function  GV_Sprite_AddImageRect(aSprite: Integer; aPage, aGroup: Cardinal; aRect: PGVRect): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite     - Sprite Index
//     aPage       - Texture Page Index
//     aGroup      - Texture Group Index
//     aGridX      - Starting Left Point of the Grid Cell
//     aGridY      - Starting Top Point of the Grid Cell
//     aGridWidth  - Width of one grid cell
//     aGridHeight - Height of one grid cell
//   Returns:
//     Index to the image grid cell defined or -1 if an error.
//   Description:
//     If your texture's animation sequence takes the form of a grid then
//     you can use this command to add animation frames.
function  GV_Sprite_AddImageGrid(aSprite: Integer; aPage, aGroup: Cardinal; aGridX, aGridY, aGridWidth, aGridHeight: Cardinal): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite - Sprite Index.
//     aGroup  - Group Index.
//   Returns:
//     Count of Images that have been defined in the specified group.
//   Description:
//     Returns a count of the number of images defined for a group associated with a sprite.
function  GV_Sprite_GetImageCount(aSprite: Integer; aGroup: Cardinal): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite - Sprite Index
//     aNum    - Image Index
//     aGroup  - Group Index
//   Returns:
//     The width of the image or -1 if an error.
//   Description:
//     Returns the width of an image associated with the sprite, group and index number.
function  GV_Sprite_GetImageWidth(aSprite: Integer; aNum, aGroup: Cardinal): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite - Sprite Index
//     aNum    - Image Index
//     aGroup  - Group Index
//   Returns:
//     The height of the image or -1 if an error.
//   Description:
//     Returns the height of an image associated with the sprite, group and index number.
function  GV_Sprite_GetImageHeight(aSprite: Integer; aNum, aGroup: Cardinal): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite      - Sprite Index
//     aNum         - Image Index
//     aGroup       - Group Index
//     aX           - Left destination point
//     aY           - Top destination point
//     aScale       - Scaling factor
//     aAngle       - Rotation Angle
//     aColor       - Masking Color (Usually 255,0,255,255)
//     aRect        - Rectangle to copy from source image
//     aRenderState - GV_Renderstate (ie: Blending mode).
//   Returns:
//     None
//   Description:
//     Renders a rectangular section of a sprite image from a defined group via the 3D hardware. 
//   Remarks:
//     Images rendered with this function will be centered on screen.
procedure GV_Sprite_RenderImage(aSprite: Integer; aNum, aGroup: Cardinal; aX, aY, aScale, aAngle: Single; aColor: Cardinal; aRect: PGVRect; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aSprite      - Sprite Index
//     aNum         - Image Index
//     aGroup       - Group Index
//     aX           - Left destination point
//     aY           - Top destination point
//     aWidth       - Width of image
//     aHeight      - Height of image
//     aColor       - Masking Color (Usually 255,255,255,255 - white)
//     aRenderState - GV_RenderState (ie: Blending mode).
//   Returns:
//     None
//   Description:
//     Renders a sprite image from a defined group via the 3D hardware. The image can be sized based on a new
//     width and height.
//   Remarks:
//     Images rendered with this function will be positioned at its upper-left corner.
procedure GV_Sprite_RenderImageSized(aSprite: Integer; aNum, aGroup: Cardinal; aX, aY, aWidth, aHeight: Single; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aSprite      - Sprite Index
//     aNum         - Image Index
//     aGroup       - Group Index
//     aX           - Left destination point
//     aY           - Top destination point
//     aColor       - Masking Color (Usually 255,255,255,255 - white)
//     aRect        - Rectangle to copy from source image
//     aRenderState - GV_RenderState (ie: Blending mode).
//   Returns:
//     None
//   Description:
//     Allows you to copy a rectangular section of a sprite image onto the drawing surface.  This allows you to blit
//     ad-hoc rectangles without defining them as an ImageRect or ImageGrid.  Unlike TGV_Sprite_RenderImage it does not
//     support scaling or rotation.
procedure GV_Sprite_RenderImageRect(aSprite: Integer; aNum, aGroup: Cardinal; aX, aY: Single; aRect: PGVRect; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aSprite - Sprite Index
//     aNum    - Image frame
//     aGroup  - Image group
//   Returns:
//     Index to a texture
//   Description:
//     Returns the handle to the texture where image aNum is located in aGroup.
function  GV_Sprite_GetTexture(aSprite: Integer; aNum, aGroup: Cardinal): Integer; external GV_SDK_DLL;


{ === Image Routines ==================================================== }

//@@ Parameters:
//     aMaxCount - Maxiumum images count
//   Returns:
//     None
//   Description:
//     Tells GV to maximum number of image resources to manage
procedure GV_Image_Init(aMaxCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Release all managed image resources
procedure GV_Image_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aImage - Image handle
//   Returns:
//     None
//   Description:
//     Release a image resource
procedure GV_Image_Dispose(var aImage: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Releses all image resources
procedure GV_Image_DisposeAll; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile    - RezFile handle
//     aColorKey   - Image colorkey
//     aPath       - Full path of image file on disk or inside rezfile
//     aTileWidth  - Tile width
//     aTileHeight - Tile height
//   Returns:
//     Image handle
//   Description:
//     Loads a full screen image into memory and breaks it into renderable tiles
//     so that it can be displayed via the 3D hardware.
function  GV_Image_Load(aRezFile: Integer; aColorKey: Cardinal; const aPath: string; aTileWidth, aTileHeight: Cardinal): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aTileWidth  - Tile width
//     aTileHeight - Tile height
//   Returns:
//     Image handle
//   Description:
//     Creates an image from the current frame buffer
//   Remarks
//     This routine is not meant to be used on a per-frame bases but in those
//     cases where you need to take a snap shot of the current framebuffer and
//     redisplay it at a later time.
function  GV_Image_GrabFrame(aTileWidth, aTileHeight: Cardinal): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aImage       - Image handle
//     aX           - Horizontal position in screen space
//     aY           - Vertical position in screen space
//     aColor       - Image color
//     aRenderState - Render state
//   Returns:
//     None
//   Description:
//     Renders an image resource to screen
procedure GV_Image_Render(aImage: Integer; aX, aY: Single; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aImage - Image handle
//   Returns:
//     Texture count
//   Description:
//     Returns the number of textures that make up an image
function  GV_Image_GetTextureCount(aImage: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aImage - Image handle
//     aNum   - Texture number (0-n)
//   Returns:
//     Texture handle
//   Description:
//     Returns the texture handle to a texture of an image resource
function  GV_Image_GetTexture(aImage: Integer; aNum: Cardinal): Integer; external GV_SDK_DLL;


{ === Polygon Routines ================================================== }

//@@ Parameters:
//     aMaxCount - Total polygons to manage
//   Returns:
//     None
//   Description:
//     Tells GV the maximum number of polygons to manage
procedure GV_Polygon_Init(aMaxCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Releases all polygon resources
procedure GV_Polygon_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aPolygon - Polygon handle
//   Returns:
//     aPolygon will be set to GV_NIL (-1)
//   Description:
//     Release a polygon resources and shuts down the polygon interface
procedure GV_Polygon_Dispose(var aPolygon: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Release all allocated polygon resources
procedure GV_Polygon_DisposeAll; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Handle to a polygon resource
//   Description:
//     Create a new polygon resource
function  GV_Polygon_Create: Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aPolygon - Polygon handle
//     aX       - Horizontal postion in local space
//     aY       - Vertical position in local space
//     aVisible - Visibility flag
//   Returns:
//     None
//   Description:
//     Add a new point to the polygon
procedure GV_Polygon_AddLocalPoint(aPolygon: Integer; aX, aY: Single; aVisible: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     aPolygon     - Polygon handle
//     aX           - Horizontal position in screen space
//     aY           - Vertical position in screen space
//     aScale       - Scale
//     aAngle       - Angle (0-360)
//     aColor       - Color
//     aRenderState - Renderstate
//   Returns:
//     None
//   Description:
//     Renders a polygon at XY, scaled, at an angle in specified color use a
//     renderstate
procedure GV_Polygon_Render(aPolygon: Integer; aX, aY, aScale, aAngle: Single; aColor: Cardinal; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aPolygon - Polygon handle
//     aIndex   - Index of point
//   Returns:
//     TRUE if visible, FALSE if not
//   Description:
//     Checks if a polygon point is visible or not
function  GV_Polygon_IsSegmentVisible(aPolygon: Integer; aIndex: Cardinal): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aPolygon - Polygon handle
//     aIndex   - Index of point
//     aVisible - Visibility
//   Returns:
//     None
//   Description:
//     Sets the visibity of a polygon point
procedure GV_Polygon_SetSegmentVisible(aPolygon: Integer; aIndex: Cardinal; aVisible: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     aPolygon - Polygon handle
//     aIndex   - Index of point
//   Returns:
//     Pointer to a polygon point
//   Description:
//     Returns a pointer to a polygon point in world space
function  GV_Polygon_GetWorldPoint(aPolygon: Integer; aIndex: Cardinal): PGVVector; external GV_SDK_DLL;

//@@ Parameters:
//     aPolygon - Polygon handle
//   Returns:
//     Point count
//   Description:
//     Returns the total number of points that make up a polygon
function  GV_Polygon_GetPointCount(aPolygon: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aPolygon - Polygon handle
//     aIndex   - Index of point
//   Returns:
//     Pointer to a polygon point
//   Description:
//     Returns a pointer to a polygon point in local space
function  GV_Polygon_GetLocalPoint(aPolygon: Integer; aIndex: Cardinal): PGVVector; external GV_SDK_DLL;


{ === Entity Routines =================================================== }

//@@ Parameters:
//     aMaxCount - Maxumum number of entities to alloct.
//   Returns:
//     None
//   Description:
//     Reserves room for aMaxCount GV_Entity objects.  You must call this
//     method in order to reserve memory for GV_Entity objects.  aMaxCount is
//     the maximum number of entities your program can have active at any one
//     point in time.  Entities are indexed and are referenced via their index
//     number.
procedure GV_Entity_Init(aMaxCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Use this command to release memory reserved with the GV_Entity_Init
//     command.
procedure GV_Entity_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index.
//   Returns:
//     None
//   Description:
//     Dispose of an entity at Index aEntity.  This index may now flagged as
//     available for reuse.
procedure GV_Entity_Dispose(var aEntity: Integer);external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Use this command to clear all entity objects currently in use.
procedure GV_Entity_DisposeAll; external GV_SDK_DLL;

//@@ Parameters:
//     aSprite - Sprite Index
//     aPage   - Page Index
//     aGroup  - Group index
//   Returns:
//     Index to entity or -1 if there is an error.
//   Description:
//     Creates a GV_Entity using the first available open index reserved under
//     GV_Entity_Init. The entity will use the aSprite, aPage, aGroup indexes
//     to determine which animation (image) data it will use to draw itself.
function  GV_Entity_Create(aSprite: Integer; aPage, aGroup: Cardinal): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aWidth  - Width of Entity's current image
//     aHeight - Height of Entity's current image
//     aRadius - Radius of Entity's current image
//   Returns:
//     aWidth, aHeight and aRadius or -1 in all values to indicate an error.
//   Description:
//     Use this call to determine the current size of the image the entity is
//     currently using to draw itself.
procedure GV_Entity_GetSize(aEntity: Integer; aWidth, aHeight, aRadius: PSingle); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     Frame Count
//   Description:
//     Returns the number of frames for entity
function  GV_Entity_GetFrameCount(aEntity: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aFrame  - Frame of Animation
//   Returns:
//     None
//   Description:
//     Sets the entity's current drawing image to aFrame.  If aFrame references
//     an illegal index then this command will NOT change the entity's frame.
procedure GV_Entity_SetFrame(aEntity: Integer; aFrame: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     The current frame the entity is using or -1 if there is an error.
//   Description:
//     This method will return the current frame of animation for an entity.
function  GV_Entity_GetFrame(aEntity: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity     - Entity Index
//     aFrameDelay - Frames to delay between animation updates.
//   Returns:
//     None
//   Description:
//     Sets the frame delay for an entity.  That is, how may frames will the
//     entity draw itself with the same image before advancing to the next
//     frame of animation.
procedure GV_Entity_SetFrameDelay(aEntity: Integer; aFrameDelay: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     Frame delay or -1 if there is an error.
//   Description:
//     Returns the current frame delay for entity aEntity.
function  GV_Entity_GetFrameDelay(aEntity: Integer): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity      - Entity Index
//     aLoop        - Enable Looping
//     aElapsedTime - Time elapsed since last call to NextFrame
//   Returns:
//     True if a frame is advanced, false if no frame is advanced.
//   Description:
//     Advances the animation for the entity 0-N frames depending on
//     aElapsedTime. If looping is true then the animation will automatically
//     loop.
function  GV_Entity_NextFrame(aEntity: Integer; aLoop: Boolean; aElapsedTime: Single): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity      - Entity Index
//     aLoop        - Enable Looping
//     aElapsedTime - Time elapsed since last call to PrevFrame
//   Returns:
//     True if frame is advanced, false if no frame is advanced.
//   Description:
//     Steps back the animation 0-N frames depending on aElapsedTime.  If
//     looping is true then the animation will automatically loop.
function  GV_Entity_PrevFrame(aEntity: Integer; aLoop: Boolean; aElapsedTime: Single): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aX      - Center X position
//     aY      - Center Y Position
//   Returns:
//     None
//   Description:
//     Set's the entity's center cordinates to aX, aY.
procedure GV_Entity_SetPos(aEntity: Integer; aX, aY: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aX      - Center X position
//     aY      - Center Y position
//   Returns:
//     aX, aY will have the current Entity position or -1 if error.
//   Description:
//     Use this method to retrieve the current X,Y position of an entity.
procedure GV_Entity_GetPos(aEntity: Integer; aX, aY: PSingle); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aX      - Center X position
//     aY      - Center Y position
//   Returns:
//     None
//   Description:
//     Moves an entity to aX, aY.
procedure GV_Entity_Move(aEntity: Integer; aX, aY: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aSpeed  - Thrust speed
//   Returns:
//     None
//   Description:
//     Applies a constant thrust to an entity in the direction it is facing,
//     causing the entity to move.
procedure GV_Entity_Thrust(aEntity: Integer; aSpeed: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity      - Entity Index
//     aRenderState - GV_Renderstate
//   Returns:
//     None
//   Description:
//     Sets an entity's render state.  See GV_Renderstate for more information.
procedure GV_Entity_SetRenderState(aEntity: Integer; aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     GV_Renderstate of the entity or -1 if an error.
//   Description:
//     Retreives an entity's current render state.
function  GV_Entity_GetRenderState(aEntity: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aColor  - New Masking Color
//   Returns:
//     None
//   Description:
//     Set's an entity's masking color.
procedure GV_Entity_SetColor(aEntity: Integer; aColor: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     Entity's current masking color or -1 if error.
//   Description:
//     Use this method to get an entity's current masking color.
function  GV_Entity_GetColor(aEntity: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aScale  - Scale
//   Returns:
//     None
//   Description:
//     Sets an entity's scale.  1.0 = No Scaling.
procedure GV_Entity_SetScale(aEntity: Integer; aScale: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aScale  - Amount to modify current scale
//   Returns:
//     None
//   Description:
//     Modifies the current scale of an entity by aScale amount.
procedure GV_Entity_ScaleRel(aEntity: Integer; aScale: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     Current scale or -1 if error
//   Description:
//     Use this method to get an entity's current scale.
function  GV_Entity_GetScale(aEntity: Integer): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aAngle  - Angle to rotate entity
//   Returns:
//     None
//   Description:
//     Rotates an entity to a specific angle.
procedure GV_Entity_SetAngle(aEntity: Integer; aAngle: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     Entity's current angle or -1 if error
//   Description:
//     Use this method to get an entity's current angle of rotation.
function  GV_Entity_GetAngle(aEntity: Integer): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aAngle  - Angle to rotate entity
//   Returns:
//     None
//   Description:
//     Rotates an entity to an angle.

procedure GV_Entity_RotateAbs(aEntity: Integer; aAngle: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aAngle  - Angle modifier
//   Returns:
//     None
//   Description:
//     Modifies an entity's current rotation by aAngle.
procedure GV_Entity_RotateRel(aEntity: Integer; aAngle: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aAngle  - Finale angle to face
//     aSpeed  - Rotation amount per frame
//   Returns:
//     True if aAngle has been reached
//   Description:
//     Rotates an entity to aAngle by aSpeed amount.
function  GV_Entity_RotateToAngle(aEntity: Integer; aAngle, aSpeed: Single): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aX      - Horizontal position
//     aY      - Vertical position
//     aSpeed  - Rotate amount per frame
//   Returns:
//     TRUE if aAngle has been reached, FALSE if not.
//   Description:
//     Rotate an entity to aAngle between aEntity pos and pos aX,aY by aSpeed amount.
function  GV_Entity_RotateToPos(aEntity: Integer; aX, aY: Single; aSpeed: Single): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     Visibility state
//   Description:
//     Use this method to get an entity's current visibility.
function  GV_Entity_IsVisible(aEntity: Integer): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity       - Entity Index
//     aX            - X center of radius
//     aY            - Y center of radius
//     aRadius       - Radius of area to test
//     aShrinkFactor - Shrink factor to apply to collision
//   Returns:
//     True if entity region overlaps radius
//   Description:
//     Tests an entity's boundries against a circular area.  Will return true
//     if the entity overlaps on any point of the circle.  The shrink factor
//     scales down the entity's size for comparing overlap.
function  GV_Entity_OverlapRadius(aEntity: Integer; aX, aY, aRadius, aShrinkFactor: Single): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     None
//   Description:
//     Renders the entity to the drawing canvas.
procedure GV_Entity_Render(aEntity: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aFrame  - Frame of Animation index
//     aX      - Point X
//     aY      - Point Y
//   Returns:
//     None
//   Description:
//     Adds a polypoint to the entity's collision polygon for animation frame
//     aFrame.
procedure GV_Entity_AddPolyPoint(aEntity: Integer; aFrame: Cardinal; aX, aY: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity   - Entity Index
//     aSrcFrame - Source Frame Index
//     aDstFrame - Destination Frame Index
//   Returns:
//     None
//   Description:
//     Copys a collision polygon from one frame to the next.
procedure GV_Entity_CopyPolyPoint(aEntity: Integer; aSrcFrame, aDstFrame: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity      - Entity Index
//     aColor       - GV_Color
//     aRenderState - GV_Renderstate
//   Returns:
//     None
//   Description:
//     Drawns the entity's collision polygon for the entity's current frame of
//     animation.
procedure GV_Entity_RenderPolyPoint(aEntity: Integer; aColor, aRenderState: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     None
//   Description:
//     Transforms the polygon from relative cordinates based on texture to
//     real-world game cordinates.
procedure GV_Entity_TransformPolyPoint(aEntity: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//   Returns:
//     Count or -1 if error
//   Description:
//     Use this method to get an entity's current to get the entity's current
//     frame polygon segment count.
function  GV_Entity_GetPolyPointSegmentCount(aEntity: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity - Entity Index
//     aIndex  - Polygon Segment Index
//   Returns:
//     None
//   Description:
//     Use this method to get an entity's current world point.
function  GV_Entity_GetPolyPointWorldPoint(aEntity: Integer; aIndex: Cardinal): PGVVector; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity1 - 1st Entity Index
//     aEntity2 - 2nd Entity Index
//     aPos     - Positional vector record
//   Returns:
//     True (and valid values in aPOS) if entity's collide, otherwise FALSE.
//   Description:
//     Test for collision between two entities.  If there is an overlap then
//     TRUE is returned and aPOS will contain the vector information of where
//     the collision occurred.
function  GV_Entity_PolyPointCollide(aEntity1, aEntity2: Integer; aPos: PGVVector): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity  - Entity Index
//     aX       - Horizontal position to check
//     aY       - Vertical position to check
//     aPos     - Positional vector record
//   Returns:
//     True (and valid values in aPOS) if point XY and entity collide,
//     otherwise FALSE.
//   Description:
//     Test for collision between point XY and a entity. If there is an overlap
//     then TRUE is returned and aPOS will contain the vector information of
//     where the collision occurred.
function  GV_Entity_PolyPointCollideXY(aEntity: Integer; aX, aY: Single; aPos: PGVVector): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aEntity         - Entity Handle
//     aMju            - Defines "roughness" of result polylines or the
//                       power of polyline approximation. If you want very
//                       smooth polyline, set it to zero (but it will probably
//                       noticeably slow down the collision detection). You can
//                       set it to about 15 for roundish sprites (especially
//                       with alpha chanel) and to about 6 or 7 for angular
//                       sprites if you need all angles to be traced precisely.
//                       Anyway, play with it to find value suitable for your
//                       sprites.
//     aMaxStepBack    - Defines maximum value for tracer to "step back" in the
//                       trace process. 10 should be enough for most images but
//                       set it higher if you have sprites with long and thin
//                       (1-2 pixels)parts.
//     aAlphaThreshold - Defines alpha value for tracer to consider empty space.
//                       If you have sprites with sharp edges you can set it to
//                       about 200 but if your sprite with no clear edges (some
//                       clouds of smoke for example) you can set to 70 of less
//                       to trace edges more precise.
//   Returns:
//     None
//   Description:
//     Autotrace all the frames of entity and add a polypoint collision mask.
procedure GV_Entity_PolyPointTrace(aEntity: Integer; aMju: Extended=6; aMaxStepBack: Integer=10; aAlphaThreshold: Byte=70); external GV_SDK_DLL;


{ === Audio Routines ==================================================== }

//@@ Parameters:
//     aHandle - Handle to a valid window (HWND)
//   Returns:
//     TRUE if success, FALSE if not
//   Description:
//     Opens the audio subsystem
function  GV_Audio_Open(aHandle: Integer): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Shuts donw the audio subsystem
procedure GV_Audio_Close; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - RezFile handle
//     aPath    - Full path to a WAV sample on disk or inside rezfile
//   Returns:
//     Handle to sample
//   Description:
//     Loads a 16bit, uncompressed WAV sample.
function  GV_Audio_LoadSample(aRezFile: Integer; const aPath: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aNum - Sample handle
//   Returns:
//     None
//   Description:
//     Releases a sample resource
procedure GV_Audio_FreeSample(var aNum: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     aNum  - Sample handle
//     aChan - Channel to play sample on (0-255, -1 for any free channel)
//     aVol  - Volume (0-1)
//     aPan  - Pannel (-1 thru +1, where -1 is full left, 0 is center and 1 or full right)
//     aFreq - Frequency (0-1)
//     aLoop - Loop sample
//   Returns:
//     Channel number of playing sample
//   Description:
//     Playback a loaded sample resource
function  GV_Audio_PlaySample(aNum, aChan: Integer; aVol, aPan, aFreq: Single; aLoop: Boolean): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aChan    - Channel number
//     aReserve - Reserve flag
//   Returns:
//     None
//   Description:
//     Reserve or unreserves a channel to prevent it from being used by
//     GV_Audio_PlaySample looking for a unused channel to play on.
procedure GV_Audio_ReserveChannel(aChan: Integer; aReserve: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     aChan - Channel
//     aVol  - Volume (0-1)
//   Returns:
//     None
//   Description:
//     Sets the volume of a playing channel
procedure GV_Audio_SetChannelVol(aChan: Integer; aVol: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aChan - Channel
//   Returns:
//     Channel volume
//   Description:
//     Gets the volume of a playing channel
function  GV_Audio_GetChannelVol(aChan: Integer): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aChan - Channel
//     aPan  - Panning
//   Returns:
//     None
//   Description:
//     Sets the panning of a playing channel
procedure GV_Audio_SetChannelPan(aChan: Integer; aPan: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aChan - Channel
//   Returns:
//     Channel Panning
//   Description:
//     Gets the panning of a playing channel
function  GV_Audio_GetChannelPan(aChan: Integer): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aChan - Channel
//     aFreq - Freqency
//   Returns:
//     None
//   Description:
//     Sets the frequency of a playing channel
procedure GV_Audio_SetChannelFreq(aChan: Integer; aFreq: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aChan - Channel
//   Returns:
//     None
//   Description:
//     Gets the fequency of a playing channel
function  GV_Audio_GetChannelFreq(aChan: Integer): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aChan - Channel
//   Returns:
//     TRUE if playing, FALSE if not
//   Description:
//     Checks if a channel is playing
function  GV_Audio_ChannelPlaying(aChan: Integer): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aChan - Channel
//   Returns:
//     None
//   Description:
//     Stops a playin channel
procedure GV_Audio_StopChannel(aChan: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Stop all playing channels
procedure GV_Audio_StopAllChannels; external GV_SDK_DLL;

//@@ Parameters:
//     aVol - Volume (0-1)
//   Returns:
//     None
//   Description:
//     Sets the master volume for sound effects
procedure GV_Audio_SetMasterSfxVol(aVol: Single); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Gets the master volume for sound effects
function  GV_Audio_GetMasterSfxVol: Single; external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - RezFile handle
//     aPath    - Path to music file on disk or in rezfile
//     aVol     - Music volume (0-1)
//     aLoop    - Loop flag, TRUE to loop, FALSE to play only once
//   Returns:
//     TRUE if music was loaded and playing, FALSE if not
//   Description:
//     Loads and plays a music file. Valid music formats include:
//       .IT  - Inpulse Tracker
//       .MOD - Variouse MOD formats
//       .S3M - Scream Tracker
//       .XM  - Fast Tracker
//       .MP3 - Mpeg3
//   Remarks
//     All formats except .MP3 can be loaded from a RezFile. If you pass a
//     valid RezFile handle and a .MP3 file is detected, it will try to load
//     it from disk instead.
function  GV_Audio_PlayMusic(aRezFile: Integer; const aPath: string; aVol: Single; aLoop: Boolean): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aPause - Pause status
//   Returns:
//     None
//   Description:
//     Pause musci playback
procedure GV_Audio_PauseMusic(aPause: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Stops music playback
procedure GV_Audio_StopMusic; external GV_SDK_DLL;

//@@ Parameters:
//     aVol - Volume
//   Returns:
//     None
//   Description:
//     Set volume for music playback
procedure GV_Audio_SetMusicVol(aVol : Single); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Checks if music is currently playing
function  GV_Audio_MusicPlaying: Boolean; external GV_SDK_DLL;


{ === MusicPlayer Routines ============================================== }

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Initialize song list
procedure GV_MusicPlayer_InitSongList; external GV_SDK_DLL;

//@@ Parameters:
//     aPath - Full path to music files on disk
//   Returns:
//     None
//   Description:
//     Add a new music search path
procedure GV_MusicPlayer_AddSongs(const aPath: string); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     SongList count
//   Description:
//     Returns the number of songs in the songlist
function  GV_MusicPlayer_GetSongListCount: Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Song number
//   Description:
//     Get the number of the current song
function  GV_MusicPlayer_GetSongNum: Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aLoop - Loop
//   Returns:
//     Song number
//   Description:
//     Play the next song in the songlist
function  GV_MusicPlayer_PlayNextSong(aLoop: Boolean): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aLoop - Loop
//   Returns:
//     Song number
//   Description:
//     Play the previous song in the songlist
function  GV_MusicPlayer_PlayPrevSong(aLoop: Boolean): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aLoop - Loop
//   Returns:
//     Song number
//   Description:
//     Play a random song in the songlist
function  GV_MusicPlayer_PlayRandomSong(aLoop: Boolean): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Stop current song
procedure GV_MusicPlayer_StopSong; external GV_SDK_DLL;

//@@ Parameters:
//     aPause - Pause
//   Returns:
//     None
//   Description:
//     Sets the pause status for current song
procedure GV_MusicPlayer_PauseSong(aPause: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE if playing, FALSE if not
//   Description:
//     Check if song is currently playing
function  GV_MusicPlayer_SongPlaying: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aVol - Volume
//   Returns:
//     None
//   Description:
//     Set songlist volume
procedure GV_MusicPlayer_SetSongVol(aVol: Single); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Song path
//   Description:
//     Returns the full path of current song
function  GV_MusicPlayer_GetSongPath: string; external GV_SDK_DLL;


{ === Math Routines ===================================================== }

//@@ Parameters:
//     aSelf - Vector pointer
//   Returns:
//     None
//   Description:
//     Clear vector
procedure GV_Vector_Clear(aSelf: PGVVector); external GV_SDK_DLL;

//@@ Parameters:
//     aSelf - Vector pointer 1
//     aV    - Vector pointer 2
//   Returns:
//     Vector 1 now equals vector 2
//   Description:
//     Assigns one vector to another
procedure GV_Vector_Assign(aSelf, aV: PGVVector); external GV_SDK_DLL;

//@@ Parameters:
//     aSelf - Vector pointer 1
//     aV    - Vector pointer 2
//   Returns:
//     Vector 2 will be added to vector 1
//   Description:
//     Adds two vectors
procedure GV_Vector_Add(aSelf, aV: PGVVector); external GV_SDK_DLL;

//@@ Parameters:
//     aSelf - Vector pointer 1
//     aV    - Vector pointer 2
//   Returns:
//     Vector 2 will be subtracted from vector 1
//   Description:
//     Subtract two vectors
procedure GV_Vector_Sub(aSelf, aV: PGVVector); external GV_SDK_DLL;

//@@ Parameters:
//     aSelf - Vector pointer 1
//     aV    - Vector pointer 2
//   Returns:
//     Vector 1 will be multiplied by vector 2
//   Description:
//     Multiply two vectors
procedure GV_Vector_Mul(aSelf, aV: PGVVector); external GV_SDK_DLL;

//@@ Parameters:
//     aSelf - Vector pointer
//   Returns:
//     Magnatude of vector
//   Description:
//     Returns the magnatude of vector
function  GV_Vector_Mag(aSelf: PGVVector): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aSelf - Vector pointer 1
//     aV    - Vector pointer 2
//   Returns:
//     Distance
//   Description:
//     Returns the distance between two vectors
function  GV_Vector_Dist(aSelf, aV: PGVVector): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aSelf - Vector pointer
//   Returns:
//     Vector will be normalized
//   Description:
//     Normalizes a vector
procedure GV_Vector_Norm(aSelf: PGVVector); external GV_SDK_DLL;

//@@ Parameters:
//     aSelf - Vector pointer 1
//     aV    - Vector pointer 2
//   Returns:
//     Relative Angle
//   Description:
//     Returns the relative angle between two vectors (-+360)
function  GV_Vector_Angle(aSelf, aV: PGVVector): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aSelf  - Vector pointer
//     aAngle - Angle (0-360)
//     aSpeed - Speed
//   Returns:
//     A new directional vector
//   Description:
//     Creats a directional vector that will move along angle aAngle at
//     aSpeed
procedure GV_Vector_Thrust(aSelf: PGVVector; aAngle, aSpeed: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aAngle - Angle (0-360)
//   Returns:
//     Clipped angle
//   Description:
//     Clip angle between 0-360
function  GV_Angle_ClipAbs(aAngle: Single): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aAngle - Angle (0-360)
//   Returns:
//     Clipped angle
//   Description:
//     Clip angle between +-360
function  GV_Angle_ClipRel(aAngle: Single): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aA - Angle a
//     aB - Angle b
//   Returns:
//     Angle difference
//   Description:
//     Returns the angle between two angle
function  GV_Angle_Diff(aA, aB: Single): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aAngle - Angle (0-360)
//     aX     - Horizontal position
//     aY     - Vertical position
//   Returns:
//     Rotated aX and aY values
//   Description:
//     Returns new rotated values for x and y
procedure GV_Angle_RotateXY(aAngle: Single; var aX: Single; var aY: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aAngle - Angle (0-360)
//   Returns:
//     Sin of ange
//   Description:
//     Returns the sin of an angle using a fast lookup table
function  GV_Angle_Sin(aAngle: Cardinal): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aAngle - Angle (0-360)
//   Returns:
//     Cosine of angle
//   Description:
//     Returns the cosine of angle using a fast lookup table
function  GV_Angle_Cos(aAngle: Cardinal): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aMin - Minimum range
//     aMax - Maximum range
//   Returns:
//     Randum number
//   Description:
//     Returns a randum number between aMin and aMax
function  GV_RandomNum_RangeInteger(aMin, aMax: Integer): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aMin - Minimum range
//     aMax - Maximum range
//   Returns:
//     Randum number
//   Description:
//     Returns a randum floating point number between aMin and aMax
function  GV_RandomNum_RangeSingle(aMin, aMax: Single): Single; external GV_SDK_DLL;

//@@ Parameters:
//     aValue - Floating point number
//     aMin   - Minimum range
//     aMax   - Maximum range
//   Returns:
//     Clamp floating point number
//   Description:
//     Clamps a floating point number between aMin and aMax
procedure GV_ClampValueSingle(var aValue: Single; aMin, aMax: Single); external GV_SDK_DLL;

//@@ Parameters:
//     aValue - Integer number
//     aMin   - Minimum range
//     aMax   - Maximum range
//   Returns:
//     Clamp integer number
//   Description:
//     Clamps a integer number between aMin and aMax
procedure GV_ClampValueInteger(var aValue: Integer; aMin, aMax: Integer); external GV_SDK_DLL;

//@@ Parameters:
//     aValue - Integer cardinal
//     aMin   - Minimum range
//     aMax   - Maximum range
//   Returns:
//     Clamp cardinal number
//   Description:
//     Clamps a cardinal number between aMin and aMax
procedure GV_ClampValueCardinal(var aValue: Cardinal; aMin, aMax: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     aX1 - Line 1 start x
//     aY1 - Line 1 start y
//     aX2 - Line 1 end x
//     aY2 - Line 1 end y
//     aX3 - Line 2 start x
//     aY3 - Line 2 start y
//     aX4 - Line 2 end x
//     aY4 - Line 2 end y
//     aX  - Intersection x position
//     aY  - Intersection y position
//   Returns:
//     Line intersection status and position
//   Description:
//     Checks if two line intersect.
function  GV_LineIntersect(aX1, aY1, aX2, aY2, aX3, aY3, aX4, aY4: Integer; var aX, aY: Integer): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aValue1 - Integer value 1
//     aValue2 - Integer value 2
//   Returns:
//     TRUE if yes, FALSE if not
//   Description:
//     Checks if two integer values have the same sign
function  GV_SameSignInteger(aValue1, aValue2: Integer): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aV   - Floating point value
//     aMin - Minimum value
//     aMax - Maximum value
//   Returns:
//     aV will be wrapped between min and max
//   Description:
//     Wraps a floating point number between aMin and aMax
procedure GV_WrapNumberSingle(var aV: Single; aMin, aMax: Single); external GV_SDK_DLL;


{ === Dialog Routines =================================================== }

//@@ Parameters:
//     aCaption - Window captoin
//     aMsg     - Window message
//   Returns:
//     None
//   Description:
//     Displays a message box with an <OK> button
procedure GV_Dialog_ShowMessage(const aCaption, aMsg: string); external GV_SDK_DLL;

//@@ Parameters:
//     aCaption - Window caption
//   Returns:
//     Directory path
//   Description:
//     Allows you to pick a folder list of directories on the selected path
function  GV_Dialog_PickDir(const aCaption: string): string; external GV_SDK_DLL;


{ === Ini Routines ====================================================== }

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Write unsave INI contents to disk
procedure GV_Ini_Flush; external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//     aDefault - Default value
//   Returns:
//     String value
//   Description:
//     Reads a string from INI file
function  GV_Ini_ReadString(const aSection, aName, aDefault: string): string; external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//     aValue   - Value
//   Returns:
//     None
//   Description:
//     Write a string value to INI file
procedure GV_Ini_WriteString(const aSection, aName, aValue: string); external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//     aDefault - Default value
//   Returns:
//     Integer value
//   Description:
//     Read a integer value from INI file
function  GV_Ini_ReadInteger(const aSection, aName: string; aDefault: Longint): Cardinal; external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//     aValue   - Value
//   Returns:
//     None
//   Description:
//     Writes a integer value to INI file
procedure GV_Ini_WriteInteger(const aSection, aName: string; aValue: Longint); external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//     aDefault - Default value
//   Returns:
//     Boolean value
//   Description:
//     Reads a boolean value from INI file
function  GV_Ini_ReadBool(const aSection, aName: string; aDefault: Boolean): Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//     aValue   - Value
//   Returns:
//     None
//   Description:
//     Writes a boolean value to INI file
procedure GV_Ini_WriteBool(const aSection, aName: string; aValue: Boolean); external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//     aDefault - Defalutl value
//   Returns:
//     Floating point value
//   Description:
//     Reads a floating point value from INI file
function  GV_Ini_ReadFloat(const aSection, aName: string; aDefault: Double): Double; external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//     aValue   - Value
//   Returns:
//     None
//   Description:
//     Writes a floating point value to INI file
procedure GV_Ini_WriteFloat(const aSection, aName: string; aValue: Double); external GV_SDK_DLL;

//@@ Parameters:
//     aSection - Section
//     aName    - Name
//   Returns:
//     TRUE if yes, FALSE if no
//   Description:
//     Checks if a value exits in INI file
function  GV_Ini_ValueExists(const aSection, aName: string): Boolean; external GV_SDK_DLL;


{ === Dir Routines ====================================================== }

//@@ Parameters:
//     aDirStr  - Directory path
//     aStrList - Result string list
//     aNotify  - Notify event
//   Returns:
//     aStrList will contain all the folders found
//   Description:
//     Return all the folders found in aDirStr path
procedure GV_Dir_Read(const aDirStr: string; var aStrList: TStringList; aNotify: TGVNotifyEvent); external GV_SDK_DLL;

//@@ Parameters:
//     aDirStr  - Directory path
//     aFileStr - File mask
//     aStrList - Result string list
//     aNotify  - Notify event
//   Returns:
//     aStrList will contain all files found
//   Description:
//     Return all the files in aDirStr path tha matches file mask
procedure GV_Dir_GetFiles(const aDirStr, aFileStr: string; var aStrList: TStringList; aNotify: TNotifyEvent); external GV_SDK_DLL;

//@@ Parameters:
//     aDirStr  - Directory path
//     aFileStr - File mask
//     aStrList - Result string list
//     aNotify  - Notify event
//   Returns:
//     aStrList will contain all files found
//   Description:
//     Combines GV_Dir_Read and GV_Dir_GetFile and returns every directory and
//     every file in those directory that matchs file mask
procedure GV_Dir_GetAllFiles(const aDirStr, aFileStr: string; var aStrList: TStringList; aNotify: TGVNotifyEvent); external GV_SDK_DLL;


{ === GZFile Routines =================================================== }

//@@ Parameters:
//     aMaxCount - Maximum number of GZFiles for GV to manage
//   Returns:
//     None
//   Description:
//     Allocates resources to manage aMaxCount number of GZFiles. A GZFile
//     is a special file compressed with ZLib. Thrue the GZFile interface
//     You can can perform then standard File I/O operation on the
//     compressed file. If you open a non-compressed file, it will read
//     in the uncompressed data as normal.
procedure GV_GZFile_Init(aMaxCount: Cardinal); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Shuts down the GZFile interface and releases all managed resources.
procedure GV_GZFile_Done; external GV_SDK_DLL;

//@@ Parameters:
//     aPath - Full path to file on disk
//   Returns:
//     GV_NIL if can not be opened
//   Description:
//     Opens a GZ/Normal file for reading only.
function  GV_GZFile_OpenRead(aPath: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aPath - Full path to file on disk
//   Returns:
//     GV_NIL if can not be opened
//   Description:
//     Opens a GZ/Normal file for writing only.
function  GV_GZFile_OpenWrite(aPath: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aGZFile - Handle to an opened GZ File
//   Returns:
//     GV_NIL if there is a problem with closing the file
//   Description:
//     Closes an open GZfile. Resets the handle to GV_NIL (-1)
function  GV_GZFile_Close(var aGZFile: Integer): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Closes all open GZFiles.
procedure GV_GZFile_CloseAll; external GV_SDK_DLL;

//@@ Parameters:
//     aGZFile - Handle to a opend GZ file
//     aBuffer - Pointer to an already allocated buffer to recieve uncompressed data
//     aLen    - The size of data to write to buffer
//   Returns:
//     a) Number of uncompressed bytes actually read
//     b) ZERO for end-of-file
//     c) GV_NIL if error
//   Description:
//     None
function  GV_GZFile_Read(aGZFile: Integer; aBuffer: Pointer; aLen: Cardinal): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aGZFile - Handle to an opened GZ file
//     aBuffer - Pointer to buffer that will be compressed and written to file
//     aLen    - The size of data in the buffer
//   Returns:
//     a) Number of uncompressed bytes actually written
//     b) GV_NIL if error
//   Description:
//     None
function  GV_GZFile_Write(aGZFile: Integer; aBuffer: Pointer; aLen: Cardinal): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aGZFile - Handle to an opened GZ file
//     aLen    - Number of bytes from the beginning of the uncompressed file
//     aOrigin - Where to start seeking within the file. Note GV_SeekOrigin_End
//               is not currently implemented.
//   Returns:
//     Resulting offset
//   Description:
//     Sets the starting position for the next read or write on the given
//     compressed file.
function  GV_GZFile_Seek(aGZFile: Integer; aLen, aOrigin: Cardinal): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aGZFile - Handle to an opened GZ file
//   Returns:
//     Current file position in uncompressed bytes
//   Description:
//     Returns the starting position for the next read or write on the
//     given compressed file.
function  GV_GZFile_Tell(aGZFile: Integer): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aGZFile -
//   Returns:
//     TRUE if end-of-file, FALSE if not
//   Description:
//     Checks the end-of-file status
function  GV_GZFile_Eof(aGZFile: Integer): Boolean; external GV_SDK_DLL;


{ === Network Routines ================================================== }

//@@ Parameters:
//     aUserName - Username
//     aPassword - Password
//     aUrl      - URL
//   Returns:
//     String data sent back from URL
//   Description:
//     Returns the data from a URL. If its protected you can pass a username
//     and password.
function  GV_Network_GetHttp(aUserName, aPassword, aUrl: string): string; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Response code text
//   Description:
//     Response code text from the most recent HTTP get request
function  GV_Network_GetHttpResponseText: string; external GV_SDK_DLL;


//@@ Parameters:
//     None
//   Returns:
//     Reponse code
//   Description:
//     Response code from the most recent HTTP get request
function  GV_Network_GetHttpResponseCode: Integer; external GV_SDK_DLL;


//@@ Parameters:
//     aMailAgent - Mail agent
//     aUserName  - Server username
//     aPassword  - Server password
//     aUserHost  - Server hostname
//     aSubject   - Subject of mail
//     aTo        - Recipent of mail
//     aFrom      - Sender of mail
//     aText      - Mail body
//   Returns:
//     None
//   Description:
//     Allows you to send a mail message to a user.
procedure GV_Network_SendMail(aMailAgent, aUserName, aPassword, aUserHost, aSubject, aTo, aFrom, aText: string); external GV_SDK_DLL;


{ === Misc Routines ===================================================== }

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Checks if DirectX is installed.
function  GV_DirectXInstalled: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aValue       - Value
//     aAmount      - Amount
//     aMax         - Maximum
//     aDrag        - Drag
//     aElapsedTime - ElapsedTime
//   Returns:
//     aValue will be updated
//   Description:
//     Allows you to smoothly update aValue upto aMax value. If aAmount is zero
//     then aDrag will be applied to bring aValue down to zero.
procedure GV_SmoothMove(var aValue: Single; aAmount, aMax, aDrag, aElapsedTime: Single); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Return the GVDLL version string
function  GV_Version: string; external GV_SDK_DLL;

//@@ Parameters:
//     aObject - TObject type
//   Returns:
//     aObject will be free and set to nil
//   Description:
//     Frees an TObject decendent and sets the value to nil
procedure GV_ObjectClass_FreeNil(var aObject); external GV_SDK_DLL;

{$ENDIF}

implementation

{$IFNDEF GV_EXPORTS}

uses
  Windows;

{ === Startup Routines ================================================== }
procedure _GV_Init(aLogFilePriority: Byte); external GV_SDK_DLL;
procedure _GV_Done; external GV_SDK_DLL;

procedure DLL_Init;
var
  S: string;
begin
  if GV_SDK_VERSION <> GV_Version then
  begin
    S := 'Header version: '         + GV_SDK_VERSION + #13 +
         'DLL version      : '      + GV_Version    + #13 +
         'Make sure GV DLL build #' + GV_SDK_VERSION + ' is the current path.' + #13#13 +
         'Visit http://www.gamevisionsdk.com for the lastest build.';
    MessageBox(0, PChar(S), 'GV Header/DLL Mismatch', MB_OK);
    Halt;
  end;
end;

procedure DLL_Done;
begin
end;

procedure Color_Init;
begin
  // define color constants
  GV_Black    := GV_Color_Make(000, 000, 000, 255);
  GV_White    := GV_Color_Make(255, 255, 255, 255);
  GV_LtGray   := GV_Color_Make(192, 192, 192, 255);
  GV_DkGray   := GV_Color_Make(064, 064, 064, 255);
  GV_Red      := GV_Color_Make(255, 000, 000, 255);
  GV_Green    := GV_Color_Make(000, 255, 000, 255);
  GV_DkGreen  := GV_Color_Make(000, 128, 000, 255);
  GV_Blue     := GV_Color_Make(000, 000, 255, 255);
  GV_Yellow   := GV_Color_Make(255, 255, 000, 255);
  GV_Pink     := GV_Color_Make(255, 000, 255, 255);
  GV_Orange   := GV_Color_Make(251, 174, 009, 255);
  GV_Overlay1 := GV_Color_Make(000, 032, 041, 180);
  GV_Overlay2 := GV_Color_Make(001, 027, 001, 255);
  GV_ColorKey := GV_Color_Make(255, 000, 255, 255);
end;

procedure Color_Done;
begin
end;

procedure GV_Init(aLogFilePriority: Byte=GV_LogFile_Priority_All);
begin
  _GV_Init(aLogFilePriority);
  Color_Init;
end;

procedure GV_Done;
begin
  Color_Done;
  _GV_Done;
end;

{ === Unit Initialization =============================================== }
initialization
begin
  DLL_Init;
end;

finalization
begin
  DLL_Done;
end;

{$ENDIF}

end.
