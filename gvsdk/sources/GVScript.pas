//@@ Header to the GameVision.dll. All Script types and routines are exposed

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

unit GVScript;

interface

uses
  GVDLL,
  Classes;

type

  //@@ Standard script routine type
  TGVScriptRoutine = procedure (aProc: Pointer);

{$IFNDEF GV_EXPORTS}

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Registers common colors constants with the scripting system
procedure GV_Script_RegisterDefaultColors;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Prepares scripting system for use.
//   Remarks:
//     You must define any constants and class types with the
//     GV_Script_DefineXXX routines before calling this routine.
procedure GV_Script_Init; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Reset scripting system. All loaded source code and scripting
//     kernel is reset.
procedure GV_Script_Reset; external GV_SDK_DLL;

//@@ Parameters:
//     aName      - Name of new namespace
//     aNamespace - Existing namespace or -1
//   Returns:
//     Namespace handle
//   Description:
//     Defines a new namespace with the scripting system.
//   Remarks
//     A namespace acts like a unit in Delphi. In fact you can bring in the
//     namespace by adding it to the uses section of the script.
function  GV_Script_DefineNamespace(const aName: string; aNamespace: Integer = -1): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aPClass    - Class type
//     aNamespace - Namespace
//   Returns:
//     Namespace handle
//   Description:
//     Defines a class type with the scripting system.
function  GV_Script_DefineClassType(aPClass: TClass; aNamespace: Integer): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aPClass  - Class type
//     aHeader  - Class type method prototype
//     aAddress - Address of Clas type method
//     aFake    - True method type flag
//   Returns:
//     None
//   Description:
//     Defines a class method with the scriting system. Set aFake to TRUE if
//     the method routine is not a true method type.
procedure GV_Script_DefineClassTypeMethod(aPClass: TClass; const aHeader: string; aAddress: Pointer; aFake: Boolean = false); external GV_SDK_DLL;

//@@ Parameters:
//     aPClass  - Class type
//     aPropDef - Class type property prototype
//   Returns:
//     None
//   Description:
//     Defines a class property with the scripting system.
procedure GV_Script_DefineClassTypeProperty(aPClass: TClass; const aPropDef: String); external GV_SDK_DLL;

//@@ Parameters:
//     aName      - Variable name
//     aValue     - Value
//     aNamespace - Namespace
//   Returns:
//     None
//   Description:
//     Defines a Int64 value with the scripting system.
procedure GV_Script_DefineConstantInt64(const aName: string; aValue: Int64; aNamespace: Integer = -1); external GV_SDK_DLL;

//@@ Parameters:
//     aName      - Variable name
//     aValue     - Value
//     aNamespace - Namespace
//   Returns:
//     None
//   Description:
//     Defines a double value with the scripting system.
procedure GV_Script_DefineConstant(const aName: string; const aValue: Double; aNamespace: Integer = -1); overload;

//@@ Parameters:
//     aName      - Variable name
//     aValue     - Value
//     aNamespace - Namespace
//   Returns:
//     None
//   Description:
//     Defines a Integer value with the scripting system.
procedure GV_Script_DefineConstant(const aName: string; const aValue: Integer; aNamespace: Integer = -1); overload;

//@@ Parameters:
//     aName      - Variable name
//     aValue     - Value
//     aNamespace - Namespace
//   Returns:
//     None
//   Description:
//     Defines a extended value with the scripting system.
procedure GV_Script_DefineConstant(const aName: string; const aValue: Extended; aNamespace: Integer = -1); overload;

//@@ Parameters:
//     aName      - Variable name
//     aValue     - Value
//     aNamespace - Namespace
//   Returns:
//     None
//   Description:
//     Defines a variant value with the scripting system.
procedure GV_Script_DefineConstant(const aName: string; const aValue: Variant; aNamespace: Integer = -1); overload;

//@@ Parameters:
//     aHeader    -  Routine prototype
//     aAddress   -  Routine address
//     aNamespace -  Names
//   Returns:
//     None
//   Description:
//     Defines a routine with the scripting system
procedure GV_Script_DefineRoutine(const aHeader: String; aAddress: Pointer; aNamespace: Integer = -1); external GV_SDK_DLL;

//@@ Parameters:
//     aName       - Standard Routine prototype
//     aProc       - Standard Routine address
//     aParamCount - Number of params
//     aNamespace  - Namespace
//   Returns:
//     None
//   Description:
//     Defines a standard routine with the scripting system
procedure GV_Script_DefineStdRoutine(const aName: String; aProc: TGVScriptRoutine; aParamCount: Integer; aNamespace: Integer = -1); external GV_SDK_DLL;

//@@ Parameters:
//     aName      - Variable name
//     aTypeName  - Type name
//     aNamespace - Namespace
//     aAddress   - Address of variable
//   Returns:
//     None
//   Description:
//     Registers a variable with the scripting system.
procedure GV_Script_RegisterVariable(const aName, aTypeName: string; aAddress: Pointer; aNamespace: Integer = -1); external GV_SDK_DLL;

//@@ Parameters:
//     aName      - Object name
//     aInstance  - Object instance
//     aNamespace - Namespace
//   Returns:
//     None
//   Description:
//     Registers a object with the scripting system.
procedure GV_Script_RegisterObject(const aName: string; aInstance: TObject; aNamespace: Integer = -1); external GV_SDK_DLL;

//@@ Parameters:
//     aObjectName - Object name
//     aObjectType - Object type
//     aFieldName  - Object field name
//     aFieldType  - Object field type
//     aAddress    - Object address
//   Returns:
//     None
//   Description:
//     Registers a object field with the scripting system
procedure GV_Script_RegisterObjectField(const aObjectName: string; aObjectType: string; aFieldName: string; aFieldType: string; aAddress: Pointer); external GV_SDK_DLL;

//@@ Parameters:
//     aModuleName - ModuleName
//     aCode       - Script code
//   Returns:
//     None
//   Description:
//     Adds script source code to the scripting system
procedure GV_Script_AddCode(aModuleName, aCode: string); external GV_SDK_DLL;

//@@ Parameters:
//     aModuleName - Module name
//     aRezFile    - RezFile handle
//     aPath       - Full path to script source file on disk or inside rezfile
//   Returns:
//     None
//   Description:
//     Adds script source code from a file to the scripting system
procedure GV_Script_AddCodeFromFile(aModuleName: string; aRezFile: Integer; aPath: string); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Compile currently loaded script source code
procedure GV_Script_Compile; external GV_SDK_DLL;

//@@ Parameters:
//     aModuleName - Module name
//     aLineNum    - Line number
//   Returns:
//     None
//   Description:
//     Runs compile script code
//   Remarks
//     If source has not been compiled, it will be compiled first.
procedure GV_Script_Run(aModuleName: string; aLineNumber: Integer=0); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     TRUE if there is an error, FALSE if not
//   Description:
//     Checks if an error condision occured.
function  GV_Script_IsError: Boolean; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     None
//   Description:
//     Discard last error condition
procedure GV_Script_DiscardError; external GV_SDK_DLL;

//@@ Parameters:
//     S - Stream
//   Returns:
//     None
//   Description:
//     Save compiled script to a stream
procedure GV_Script_SaveToStream(S: TStream); external GV_SDK_DLL;

//@@ Parameters:
//     S - Stream
//   Returns:
//     None
//   Description:
//     Load compiled script from a stream
procedure GV_Script_LoadFromStream(S: TStream); external GV_SDK_DLL;

//@@ Parameters:
//     aRezFile - RezFile handle
//     aPath    - Full path to file on disk or in rezfile
//   Returns:
//     None
//   Description:
//     Load compiled script from a file or rezfile
procedure GV_Script_LoadFromFile(aRezFile: Integer; aPath: string); external GV_SDK_DLL;

//@@ Parameters:
//     aPath - Full path to file on disk
//   Returns:
//     None
//   Description:
//     Save compiled script to a disk file
procedure GV_Script_SaveToFile(aPath: string); external GV_SDK_DLL;

//@@ Parameters:
//     aName - Variable name
//   Returns:
//     Variable Id
//   Description:
//     Returns the Id of a script variable
function  GV_Script_GetMemberID(const aName: string): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aID - Variable id
//   Returns:
//     Value of variable
//   Description:
//     Get the value of a script variable
function  GV_Script_GetValueByID(aID: Integer): Variant; external GV_SDK_DLL;

//@@ Parameters:
//     aID - Variable id
//   Returns:
//     None
//   Description:
//     Set the value of a script variable by Id
procedure GV_Script_SetValueByID(aID: Integer; const aValue: Variant); external GV_SDK_DLL;

//@@ Parameters:
//     aSubID      - Script object
//     aParamIndex - Script object property
//   Returns:
//     Id of a script object property
//   Description:
//     Returns the ID of a script object property
function  GV_Script_GetParamID(aSubID, aParamIndex: Integer): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aName       - Script routine name
//     aParams     - Function params
//     aObjectName - Object name
//   Returns:
//     Function result value
//   Description:
//     Calls a script function with params. You can also pass a object name that
//     becomes the current object.
function  GV_Script_CallFunction(const aName: string; const aParams: array of const; aObjectName: string = ''): Variant; external GV_SDK_DLL;

//@@ Parameters:
//     aSubID    - Function id
//     aParams   - function params
//     aObjectID - Object Id
//   Returns:
//     Functin result value
//   Description:
//     Same as GV_Script_CallFunction except you use more efficent IDs.
function  GV_Script_CallFunctionByID(aSubID: Integer; const aParams: array of const; aObjectID: Integer = 0): Variant; external GV_SDK_DLL;

//@@ Parameters:
//     aName - Variable name
//   Returns:
//     Script variable value
//   Description:
//     Returns the value of a script variable
function  GV_Script_GetVarible(aName: string): Variant; external GV_SDK_DLL;

//@@ Parameters:
//     aName  - Variable name
//     aValue - Value
//   Returns:
//     None
//   Description:
//     Set the value of script variable
procedure GV_Script_SetVariable(aName: string; aValue: Variant); external GV_SDK_DLL;

//@@ Parameters:
//     aParamName - Param name
//   Returns:
//     Program param value
//   Description:
//     None
function  GV_Script_GetParams(aParamName: string): Variant; external GV_SDK_DLL;

//@@ Parameters:
//     aParamName - Param name
//     aValue     - Param value
//   Returns:
//     None
//   Description:
//     Set the value of a program param
procedure GV_Script_SetParams(aParamName: string; aValue: Variant); external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Object reference
//   Description:
//     Returns the current object reference
function  GV_Script_GetCurrentObject: TObject; external GV_SDK_DLL;

//@@ Parameters:
//     aProc - Standard routine pointer
//   Returns:
//     Param count
//   Description:
//     Returns a standar routine param count
function  GV_Script_GetStdRoutineParamCount(aProc: Pointer): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aProc  - Standard routine pointer
//     aIndex - Param index
//   Returns:
//     Value of param
//   Description:
//     Get the value of a standard routine stack param
function  GV_Script_GetStdRoutineParam(aProc: Pointer; aIndex: Integer): Variant; external GV_SDK_DLL;

//@@ Parameters:
//     aProc  - Standard routine pointer
//     aIndex - Param index
//     aValue - Value
//   Returns:
//     None
//   Description:
//     Set the value of a standard routine stack param
procedure GV_Script_SetStdRoutineParam(aProc: Pointer; aIndex: Integer; aValue: Variant); external GV_SDK_DLL;

//@@ Parameters:
//     aProc  - Standard routine pointer
//     aValue - Param value
//   Returns:
//     None
//   Description:
//     Set the result value of a standard routine
procedure GV_Script_SetStdRoutineResult(aProc: Pointer; aValue: Variant); external GV_SDK_DLL;

//@@ Parameters:
//     aO - Script object
//   Returns:
//     Property count
//   Description:
//     Returns the number of properties of a script object
function  GV_Script_GetObjectPropertyCount(const aO: Variant): Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aO     - Script object
//     aIndex - Index of script object property
//     aValue - Property value
//   Returns:
//     None
//   Description:
//     Set the script object property
procedure GV_Script_PutObjectPropertyByIndex(const aO: Variant; aIndex: Integer; const aValue: Variant); external GV_SDK_DLL;

//@@ Parameters:
//     aO     - Script object
//     aIndex - Index of script object property
//   Returns:
//     Object property value
//   Description:
//     Returns the value of an script object propery
function  GV_Script_GetObjectPropertyByIndex(const aO: Variant; aIndex: Integer): Variant; external GV_SDK_DLL;

//@@ Parameters:
//     aV - Script object
//   Returns:
//     TRUE if a object, FALSE if not
//   Description:
//     Check if a value is a valid script object
function  GV_Script_IsObject(const aV: Variant): boolean; external GV_SDK_DLL;

//@@ Parameters:
//     aO - Script object
//   Returns:
//     Name of script object type
//   Description:
//     Returns the name of a script object
function  GV_Script_GetObjectClassName(const aO: Variant): string; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Error string
//   Description:
//     Returns the text of the most recent error condition
function  GV_Script_GetErrorDescription: string; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Module name
//   Description:
//     Returns of name of the module where the most recent error occured.
function  GV_Script_GetErrorModuleName: string; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Error text position
//   Description:
//     Returns the text position on the line where the error occured.
function  GV_Script_GetErrorTextPos: Integer; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Error posion
//   Description:
//     Returns the position in script where the error occured.
function  GV_Script_GetErrorPos: Integer; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Error line number
//   Description:
//     Returns the line number where the error occured.
function  GV_Script_GetErrorLine: Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aModuleName - Module name
//     aLineNumber - Line number
//   Returns:
//     Source line
//   Description:
//     Returns the source line given a module and line number
function  GV_Script_GetSourceLine(const aModuleName: string; aLineNumber: Integer): string; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     List of script modules
//   Description:
//     Returns a list of all the modules currently loaded.
function  GV_Script_GetModules: TStringList; external GV_SDK_DLL;

//@@ Parameters:
//     None
//   Returns:
//     Total line count
//   Description:
//     Returns the total number of lines of all loaded modules
function  GV_Script_GetTotalLineCount: Integer; external GV_SDK_DLL;

//@@ Parameters:
//     aExpression - Expression to evaluate
//     aRes        - Expression result
//   Returns:
//     TRUE if successful, FALSE if not
//     aRes will contain the result of expression evaluation
//   Description:
//     Evaluate a value script expression return the results
function  GV_Script_Eval(const aExpression: string; var aRes: Variant): Boolean; external GV_SDK_DLL;

{$ENDIF}

implementation

{$IFNDEF GV_EXPORTS}

procedure _GV_Script_DefineConstant(const aName: string; const aValue: Variant; aNamespace: Integer = -1); external GV_SDK_DLL name 'GV_Script_DefineConstant';


procedure GV_Script_DefineConstant(const aName: string; const aValue: Double; aNamespace: Integer = -1);
begin
  _GV_Script_DefineConstant(aName, aValue, aNamespace);
end;

procedure GV_Script_DefineConstant(const aName: string; const aValue: Integer; aNamespace: Integer = -1);
begin
  _GV_Script_DefineConstant(aName, aValue, aNamespace);
end;

procedure GV_Script_DefineConstant(const aName: string; const aValue: Extended; aNamespace: Integer = -1);
begin
  _GV_Script_DefineConstant(aName, aValue, aNamespace);
end;

procedure GV_Script_DefineConstant(const aName: string; const aValue: Variant; aNamespace: Integer = -1);
begin
  _GV_Script_DefineConstant(aName, aValue, aNamespace);
end;

procedure GV_Script_RegisterDefaultColors;
begin
  // register color constants with gvscript
  GV_Script_DefineConstantInt64('GV_Black',    GV_Black);
  GV_Script_DefineConstantInt64('GV_White',    GV_White);
  GV_Script_DefineConstantInt64('GV_LtGray',   GV_LtGray);
  GV_Script_DefineConstantInt64('GV_DkGray',   GV_DkGray);
  GV_Script_DefineConstantInt64('GV_Red',      GV_Red);
  GV_Script_DefineConstantInt64('GV_Green',    GV_Green);
  GV_Script_DefineConstantInt64('GV_DkGreen',  GV_DkGreen);
  GV_Script_DefineConstantInt64('GV_Blue',     GV_Blue);
  GV_Script_DefineConstantInt64('GV_Yellow',   GV_Yellow);
  GV_Script_DefineConstantInt64('GV_Pink',     GV_Pink);
  GV_Script_DefineConstantInt64('GV_Orange',   GV_Orange);
  GV_Script_DefineConstantInt64('GV_Overlay1', GV_Overlay1);
  GV_Script_DefineConstantInt64('GV_Overlay2', GV_Overlay2);
  GV_Script_DefineConstantInt64('GV_ColorKey', GV_ColorKey);
end;

{$ENDIF}

initialization
begin
end;

finalization
begin
end;

end.
