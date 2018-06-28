unit quideVersionInfo;

interface

Uses
 Windows, Classes, SysUtils;

// TFileVersionInfo
//
// Class that enables reading the version information stored in a PE file.

type
  TFileFlag = (ffDebug, ffInfoInferred, ffPatched, ffPreRelease, ffPrivateBuild, ffSpecialBuild);
  TFileFlags = set of TFileFlag;

  PLangIdRec = ^TLangIdRec;
  TLangIdRec = packed record
    case Integer of
    0: (
      LangId: Word;
      CodePage: Word);
    1: (
      Pair: LongWORD);
  end;

  EJclError = class(Exception);

 type
  TJclAddr32 = Cardinal;
  TJclAddr64 = Int64;
  TJclAddr = TJclAddr32;
  PJclAddr = ^TJclAddr;

  EJclAddr64Exception = class(EJclError);


  EJclFileVersionInfoError = class(EJclError);

  TJclFileVersionInfo = class(TObject)
  private
    FBuffer: AnsiString;
    FFixedInfo: PVSFixedFileInfo;
    FFileFlags: TFileFlags;
    FItemList: TStringList;
    FItems: TStringList;
    FLanguages: array of TLangIdRec;
    FLanguageIndex: Integer;
    FTranslations: array of TLangIdRec;
    function GetFixedInfo: TVSFixedFileInfo;
    function GetItems: TStrings;
    function GetLanguageCount: Integer;
    function GetLanguageIds(Index: Integer): string;
    function GetLanguageNames(Index: Integer): string;
    function GetLanguages(Index: Integer): TLangIdRec;
    function GetTranslationCount: Integer;
    function GetTranslations(Index: Integer): TLangIdRec;
    procedure SetLanguageIndex(const Value: Integer);
  protected
    procedure CreateItemsForLanguage;
    procedure CheckLanguageIndex(Value: Integer);
    procedure ExtractData;
    procedure ExtractFlags;
    function GetBinFileVersion: string;
    function GetBinProductVersion: string;
    function GetFileOS: DWORD;
    function GetFileSubType: DWORD;
    function GetFileType: DWORD;
    function GetFileVersionBuild: string;
    function GetFileVersionMajor: string;
    function GetFileVersionMinor: string;
    function GetFileVersionRelease: string;
    function GetProductVersionBuild: string;
    function GetProductVersionMajor: string;
    function GetProductVersionMinor: string;
    function GetProductVersionRelease: string;
    function GetVersionKeyValue(Index: Integer): string;
  public
    constructor Attach(VersionInfoData: Pointer; Size: Integer);
    constructor Create(const FileName: string); overload;
    {$IFDEF MSWINDOWS}
    {$IFDEF FPC}
    constructor Create(const Window: HWND; Dummy: Pointer = nil); overload;
    {$ELSE}
    constructor Create(const Window: HWND); overload;
    {$ENDIF}
    constructor Create(const Module: HMODULE); overload;
    {$ENDIF MSWINDOWS}
    destructor Destroy; override;
    function GetCustomFieldValue(const FieldName: string): string;
    class function VersionLanguageId(const LangIdRec: TLangIdRec): string;
    class function VersionLanguageName(const LangId: Word): string;
    class function FileHasVersionInfo(const FileName: string): boolean;
    function TranslationMatchesLanguages(Exact: Boolean = True): Boolean;
    property BinFileVersion: string read GetBinFileVersion;
    property BinProductVersion: string read GetBinProductVersion;
    property Comments: string index 1 read GetVersionKeyValue;
    property CompanyName: string index 2 read GetVersionKeyValue;
    property FileDescription: string index 3 read GetVersionKeyValue;
    property FixedInfo: TVSFixedFileInfo read GetFixedInfo;
    property FileFlags: TFileFlags read FFileFlags;
    property FileOS: DWORD read GetFileOS;
    property FileSubType: DWORD read GetFileSubType;
    property FileType: DWORD read GetFileType;
    property FileVersion: string index 4 read GetVersionKeyValue;
    property FileVersionBuild: string read GetFileVersionBuild;
    property FileVersionMajor: string read GetFileVersionMajor;
    property FileVersionMinor: string read GetFileVersionMinor;
    property FileVersionRelease: string read GetFileVersionRelease;
    property Items: TStrings read GetItems;
    property InternalName: string index 5 read GetVersionKeyValue;
    property LanguageCount: Integer read GetLanguageCount;
    property LanguageIds[Index: Integer]: string read GetLanguageIds;
    property LanguageIndex: Integer read FLanguageIndex write SetLanguageIndex;
    property Languages[Index: Integer]: TLangIdRec read GetLanguages;
    property LanguageNames[Index: Integer]: string read GetLanguageNames;
    property LegalCopyright: string index 6 read GetVersionKeyValue;
    property LegalTradeMarks: string index 7 read GetVersionKeyValue;
    property OriginalFilename: string index 8 read GetVersionKeyValue;
    property PrivateBuild: string index 12 read GetVersionKeyValue;
    property ProductName: string index 9 read GetVersionKeyValue;
    property ProductVersion: string index 10 read GetVersionKeyValue;
    property ProductVersionBuild: string read GetProductVersionBuild;
    property ProductVersionMajor: string read GetProductVersionMajor;
    property ProductVersionMinor: string read GetProductVersionMinor;
    property ProductVersionRelease: string read GetProductVersionRelease;
    property SpecialBuild: string index 11 read GetVersionKeyValue;
    property TranslationCount: Integer read GetTranslationCount;
    property Translations[Index: Integer]: TLangIdRec read GetTranslations;
  end;

function OSIdentToString(const OSIdent: DWORD): string;
function OSFileTypeToString(const OSFileType: DWORD; const OSFileSubType: DWORD = 0): string;

function VersionResourceAvailable(const FileName: string): Boolean; overload;
function VersionResourceAvailable(const Window: HWND): Boolean; overload;
function VersionResourceAvailable(const Module: HMODULE): Boolean; overload;

function WindowToModuleFileName(const Window: HWND): string;

resourcestring
  RsFileUtilsAttrUnavailable = 'Unable to retrieve attributes of %s';

  RsCannotCreateDir = 'Unable to create directory';
  RsDelTreePathIsEmpty = 'DelTree: Path is empty';
  RsFileSearchAttrInconsistency = 'Some file search attributes are required AND rejected!';
  RsEWindowsVersionNotSupported = 'This windows version is not supported';
  RsEWindowNotValid = 'The window with handle %d is not valid';
  RsEProcessNotValid = 'The process with ID %d is not valid';
  RsEModuleNotValid = 'The Module with handle %d is not valid';
  // TJclFileVersionInfo
  RsFileUtilsNoVersionInfo = 'File contains no version information';
  RsFileUtilsFileDoesNotExist = 'The file %s does not exist';
  RsFileUtilsLanguageIndex = 'Illegal language index';
  RsFileUtilsEmptyValue = 'No value was supplied';
  RsFileUtilsValueNotFound = 'The value %s was not found.';

function GetModulePath(const Module: HMODULE): string;

implementation


//=== { TJclFileVersionInfo } ================================================

constructor TJclFileVersionInfo.Attach(VersionInfoData: Pointer; Size: Integer);
begin
  SetLength(FBuffer, Size);
  CopyMemory(PAnsiChar(FBuffer), VersionInfoData, Size);
  ExtractData;
end;

constructor TJclFileVersionInfo.Create(const FileName: string);
var
  Handle: DWORD;
  Size: DWORD;
begin
  if not FileExists(FileName) then
    raise EJclFileVersionInfoError.CreateResFmt(@RsFileUtilsFileDoesNotExist, [FileName]);
  Handle := 0;
  Size := GetFileVersionInfoSize(PChar(FileName), Handle);
  if Size = 0 then
    raise EJclFileVersionInfoError.CreateRes(@RsFileUtilsNoVersionInfo);
  SetLength(FBuffer, Size);
  Win32Check(GetFileVersionInfo(PChar(FileName), Handle, Size, PAnsiChar(FBuffer)));
  ExtractData;
end;

{$IFDEF MSWINDOWS}
{$IFDEF FPC}
constructor TJclFileVersionInfo.Create(const Window: HWND; Dummy: Pointer = nil);
{$ELSE}
constructor TJclFileVersionInfo.Create(const Window: HWND);
{$ENDIF}
begin
  Create(WindowToModuleFileName(Window));
end;

constructor TJclFileVersionInfo.Create(const Module: HMODULE);
begin
  if Module <> 0 then
    Create(GetModulePath(Module))
  else
    raise EJclError.CreateResFmt(@RsEModuleNotValid, [Module]);
end;
{$ENDIF MSWINDOWS}

destructor TJclFileVersionInfo.Destroy;
begin
  FreeAndNil(FItemList);
  FreeAndNil(FItems);
  inherited Destroy;
end;

class function TJclFileVersionInfo.FileHasVersionInfo(const FileName: string): boolean;
var
  Dummy: DWord;
begin
  Result := GetFileVersionInfoSize(PChar(FileName), Dummy) <> 0;
end;

procedure TJclFileVersionInfo.CheckLanguageIndex(Value: Integer);
begin
  if (Value < 0) or (Value >= LanguageCount) then
    raise EJclFileVersionInfoError.CreateRes(@RsFileUtilsLanguageIndex);
end;

procedure TJclFileVersionInfo.CreateItemsForLanguage;
var
  I: Integer;
begin
  Items.Clear;
  for I := 0 to FItemList.Count - 1 do
    if Integer(FItemList.Objects[I]) = FLanguageIndex then
      Items.AddObject(FItemList[I], Pointer(FLanguages[FLanguageIndex].Pair));
end;

procedure TJclFileVersionInfo.ExtractData;
var
  Data, EndOfData: PAnsiChar;
  Len, ValueLen, DataType: Word;
  HeaderSize: Integer;
  Key: string;
  Error, IsUnicode: Boolean;

  procedure Padding(var DataPtr: PAnsiChar);
  begin
    while TJclAddr(DataPtr) and 3 <> 0 do
      Inc(DataPtr);
  end;

  procedure GetHeader;
  var
    P: PAnsiChar;
    TempKey: PWideChar;
  begin
    Key := '';
    P := Data;
    Len := PWord(P)^;
    if Len = 0 then
    begin
      // do not raise error in the case of resources padded with 0
      while P < EndOfData do
      begin
        Error := P^ <> #0;
        if Error then
          Break;
        Inc(P);
      end;
      Exit;
    end;
    Inc(P, SizeOf(Word));
    ValueLen := PWord(P)^;
    Inc(P, SizeOf(Word));
    if IsUnicode then
    begin
      DataType := PWord(P)^;
      Inc(P, SizeOf(Word));
      TempKey := PWideChar(P);
      Inc(P, (lstrlenW(TempKey) + 1) * SizeOf(WideChar)); // length + #0#0
      Key := TempKey;
    end
    else
    begin
      DataType := 1;
      Key := string(PAnsiChar(P));
      Inc(P, lstrlenA(PAnsiChar(P)) + 1);
    end;
    Padding(P);
    HeaderSize := P - Data;
    Data := P;
  end;

  procedure FixKeyValue;
  const
    HexNumberCPrefix = '0x';
  var
    I: Integer;
  begin // GAPI32.DLL version 5.5.2803.1 contanins '04050x04E2' value
    repeat
      I := Pos(HexNumberCPrefix, Key);
      if I > 0 then
        Delete(Key, I, Length(HexNumberCPrefix));
    until I = 0;
    I := 1;
    while I <= Length(Key) do
      if CharIsHexDigit(Key[I]) then
        Inc(I)
      else
        Delete(Key, I, 1);
  end;

  procedure ProcessStringInfo(Size: Integer);
  var
    EndPtr, EndStringPtr: PAnsiChar;
    LangIndex: Integer;
    LangIdRec: TLangIdRec;
    Value: string;
  begin
    EndPtr := Data + Size;
    LangIndex := 0;
    while not Error and (Data < EndPtr) do
    begin
      GetHeader; // StringTable
      FixKeyValue;
      if (ValueLen <> 0) or (Length(Key) <> 8) then
      begin
        Error := True;
        Break;
      end;
      Padding(Data);
      LangIdRec.LangId := StrToIntDef('$' + Copy(Key, 1, 4), 0);
      LangIdRec.CodePage := StrToIntDef('$' + Copy(Key, 5, 4), 0);
      SetLength(FLanguages, LangIndex + 1);
      FLanguages[LangIndex] := LangIdRec;
      EndStringPtr := Data + Len - HeaderSize;
      while not Error and (Data < EndStringPtr) do
      begin
        GetHeader; // string
        case DataType of
          0:
            if ValueLen in [1..4] then
              Value := Format('$%.*x', [ValueLen * 2, PInteger(Data)^])
            else
            begin
              if (ValueLen > 0) and IsUnicode then
                Value:=PWideChar(Data)
              else
                Value := '';
            end;
          1:
            if ValueLen = 0 then
              Value := ''
            else
            if IsUnicode then
            begin
              Value := WideCharLenToString(PWideChar(Data), ValueLen);
              StrResetLength(Value);
            end
            else
              Value := string(PAnsiChar(Data));
        else
          Error := True;
          Break;
        end;
        Inc(Data, Len - HeaderSize);
        Padding(Data); // String.Padding
        FItemList.AddObject(Format('%s=%s', [Key, Value]), Pointer(LangIndex));
      end;
      Inc(LangIndex);
    end;
  end;

  procedure ProcessVarInfo;
  var
    TranslationIndex: Integer;
  begin
    GetHeader; // Var
    if SameText(Key, 'Translation') then
    begin
      SetLength(FTranslations, ValueLen div SizeOf(TLangIdRec));
      for TranslationIndex := 0 to Length(FTranslations) - 1 do
      begin
        FTranslations[TranslationIndex] := PLangIdRec(Data)^;
        Inc(Data, SizeOf(TLangIdRec));
      end;
    end;
  end;

begin
  FItemList := TStringList.Create;
  FItems := TStringList.Create;
  Data := Pointer(FBuffer);
  Assert(TJclAddr(Data) mod 4 = 0);
  IsUnicode := (PWord(Data + 4)^ in [0, 1]);
  Error := True;
  GetHeader;
  EndOfData := Data + Len - HeaderSize;
  if SameText(Key, 'VS_VERSION_INFO') and (ValueLen = SizeOf(TVSFixedFileInfo)) then
  begin
    FFixedInfo := PVSFixedFileInfo(Data);
    Error := FFixedInfo.dwSignature <> $FEEF04BD;
    Inc(Data, ValueLen); // VS_FIXEDFILEINFO
    Padding(Data);       // VS_VERSIONINFO.Padding2
    while not Error and (Data < EndOfData) do
    begin
      GetHeader;
      Inc(Data, ValueLen); // some files (VREDIR.VXD 4.00.1111) has non zero value of ValueLen
      Dec(Len, HeaderSize + ValueLen);
      if SameText(Key, 'StringFileInfo') then
        ProcessStringInfo(Len)
      else
      if SameText(Key, 'VarFileInfo') then
        ProcessVarInfo
      else
        Break;
    end;
    ExtractFlags;
    CreateItemsForLanguage;
  end;
  if Error then
    raise EJclFileVersionInfoError.CreateRes(@RsFileUtilsNoVersionInfo);
end;

procedure TJclFileVersionInfo.ExtractFlags;
var
  Masked: DWORD;
begin
  FFileFlags := [];
  Masked := FFixedInfo^.dwFileFlags and FFixedInfo^.dwFileFlagsMask;
  if (Masked and VS_FF_DEBUG) <> 0 then
    Include(FFileFlags, ffDebug);
  if (Masked and VS_FF_INFOINFERRED) <> 0 then
    Include(FFileFlags, ffInfoInferred);
  if (Masked and VS_FF_PATCHED) <> 0 then
    Include(FFileFlags, ffPatched);
  if (Masked and VS_FF_PRERELEASE) <> 0 then
    Include(FFileFlags, ffPreRelease);
  if (Masked and VS_FF_PRIVATEBUILD) <> 0 then
    Include(FFileFlags, ffPrivateBuild);
  if (Masked and VS_FF_SPECIALBUILD) <> 0 then
    Include(FFileFlags, ffSpecialBuild);
end;

function TJclFileVersionInfo.GetBinFileVersion: string;
begin
  Result := Format('%u.%u.%u.%u', [HiWord(FFixedInfo^.dwFileVersionMS),
    LoWord(FFixedInfo^.dwFileVersionMS), HiWord(FFixedInfo^.dwFileVersionLS),
    LoWord(FFixedInfo^.dwFileVersionLS)]);
end;

function TJclFileVersionInfo.GetBinProductVersion: string;
begin
  Result := Format('%u.%u.%u.%u', [HiWord(FFixedInfo^.dwProductVersionMS),
    LoWord(FFixedInfo^.dwProductVersionMS), HiWord(FFixedInfo^.dwProductVersionLS),
    LoWord(FFixedInfo^.dwProductVersionLS)]);
end;

function TJclFileVersionInfo.GetCustomFieldValue(const FieldName: string): string;
var
  ItemIndex: Integer;
begin
  if FieldName <> '' then
  begin
    ItemIndex := FItems.IndexOfName(FieldName);
    if ItemIndex <> -1 then
      //Return the required value, the value the user passed in was found.
      Result := FItems.Values[FieldName]
    else
      raise EJclFileVersionInfoError.CreateResFmt(@RsFileUtilsValueNotFound, [FieldName]);
  end
  else
    raise EJclFileVersionInfoError.CreateRes(@RsFileUtilsEmptyValue);
end;

function TJclFileVersionInfo.GetFileOS: DWORD;
begin
  Result := FFixedInfo^.dwFileOS;
end;

function TJclFileVersionInfo.GetFileSubType: DWORD;
begin
  Result := FFixedInfo^.dwFileSubtype;
end;

function TJclFileVersionInfo.GetFileType: DWORD;
begin
  Result := FFixedInfo^.dwFileType;
end;

function TJclFileVersionInfo.GetFileVersionBuild: string;
var
  Left: Integer;
begin
  Result := FileVersion;
  StrReplaceChar(Result, ',', '.');
  Left := CharLastPos(Result, '.') + 1;
  Result := StrMid(Result, Left, Length(Result) - Left + 1);
  Result := Trim(Result);
end;

function TJclFileVersionInfo.GetFileVersionMajor: string;
begin
  Result := FileVersion;
  StrReplaceChar(Result, ',', '.');
  Result := StrBefore('.', Result);
  Result := Trim(Result);
end;

function TJclFileVersionInfo.GetFileVersionMinor: string;
var
  Left, Right: integer;
begin
  Result := FileVersion;
  StrReplaceChar(Result, ',', '.');
  Left := CharPos(Result, '.') + 1;           // skip major
  Right := CharPos(Result, '.', Left) {-1};
  Result := StrMid(Result, Left, Right - Left {+1});
  Result := Trim(Result);
end;

function TJclFileVersionInfo.GetFileVersionRelease: string;
var
  Left, Right: Integer;
begin
  Result := FileVersion;
  StrReplaceChar(Result, ',', '.');
  Left := CharPos(Result, '.') + 1;           // skip major
  Left := CharPos(Result, '.', Left) + 1;     // skip minor
  Right := CharPos(Result, '.', Left) {-1};
  Result := StrMid(Result, Left, Right - Left {+1});
  Result := Trim(Result);
end;

function TJclFileVersionInfo.GetFixedInfo: TVSFixedFileInfo;
begin
  Result := FFixedInfo^;
end;

function TJclFileVersionInfo.GetItems: TStrings;
begin
  Result := FItems;
end;

function TJclFileVersionInfo.GetLanguageCount: Integer;
begin
  Result := Length(FLanguages);
end;

function TJclFileVersionInfo.GetLanguageIds(Index: Integer): string;
begin
  CheckLanguageIndex(Index);
  Result := VersionLanguageId(FLanguages[Index]);
end;

function TJclFileVersionInfo.GetLanguages(Index: Integer): TLangIdRec;
begin
  CheckLanguageIndex(Index);
  Result := FLanguages[Index];
end;

function TJclFileVersionInfo.GetLanguageNames(Index: Integer): string;
begin
  CheckLanguageIndex(Index);
  Result := VersionLanguageName(FLanguages[Index].LangId);
end;

function TJclFileVersionInfo.GetTranslationCount: Integer;
begin
  Result := Length(FTranslations);
end;

function TJclFileVersionInfo.GetTranslations(Index: Integer): TLangIdRec;
begin
  Result := FTranslations[Index];
end;

function TJclFileVersionInfo.GetProductVersionBuild: string;
var
  Left: Integer;
begin
  Result := ProductVersion;
  StrReplaceChar(Result, ',', '.');
  Left := CharLastPos(Result, '.') + 1;
  Result := StrMid(Result, Left, Length(Result) - Left + 1);
  Result := Trim(Result);
end;

function TJclFileVersionInfo.GetProductVersionMajor: string;
begin
  Result := ProductVersion;
  StrReplaceChar(Result, ',', '.');
  Result := StrBefore('.', Result);
  Result := Trim(Result);
end;

function TJclFileVersionInfo.GetProductVersionMinor: string;
var
  Left, Right: integer;
begin
  Result := ProductVersion;
  StrReplaceChar(Result, ',', '.');
  Left := CharPos(Result, '.') + 1;           // skip major
  Right := CharPos(Result, '.', Left) {-1};
  Result := StrMid(Result, Left, Right - Left {+1});
  Result := Trim(Result);
end;

function TJclFileVersionInfo.GetProductVersionRelease: string;
var
  Left, Right: Integer;
begin
  Result := ProductVersion;
  StrReplaceChar(Result, ',', '.');
  Left := CharPos(Result, '.') + 1;           // skip major
  Left := CharPos(Result, '.', Left) + 1;     // skip minor
  Right := CharPos(Result, '.', Left) {-1};
  Result := StrMid(Result, Left, Right - Left {+1});
  Result := Trim(Result);
end;

function TJclFileVersionInfo.GetVersionKeyValue(Index: Integer): string;
begin
  Result := Items.Values[VerKeyNames[Index]];
end;

procedure TJclFileVersionInfo.SetLanguageIndex(const Value: Integer);
begin
  CheckLanguageIndex(Value);
  if FLanguageIndex <> Value then
  begin
    FLanguageIndex := Value;
    CreateItemsForLanguage;
  end;
end;

function TJclFileVersionInfo.TranslationMatchesLanguages(Exact: Boolean): Boolean;
var
  TransIndex, LangIndex: Integer;
  TranslationPair: DWORD;
begin
  Result := (LanguageCount = TranslationCount) or (not Exact and (TranslationCount > 0));
  if Result then
    for TransIndex := 0 to TranslationCount - 1 do
    begin
      TranslationPair := FTranslations[TransIndex].Pair;
      LangIndex := LanguageCount - 1;
      while (LangIndex >= 0) and (TranslationPair <> FLanguages[LangIndex].Pair) do
        Dec(LangIndex);
      if LangIndex < 0 then
      begin
        Result := False;
        Break;
      end;
    end;
end;

class function TJclFileVersionInfo.VersionLanguageId(const LangIdRec: TLangIdRec): string;
begin
  with LangIdRec do
    Result := Format('%.4x%.4x', [LangId, CodePage]);
end;

class function TJclFileVersionInfo.VersionLanguageName(const LangId: Word): string;
var
  R: DWORD;
begin
  SetLength(Result, MAX_PATH);
  R := VerLanguageName(LangId, PChar(Result), MAX_PATH);
  SetLength(Result, R);
end;


function GetModulePath(const Module: HMODULE): string;
var
  L: Integer;
begin
  L := MAX_PATH + 1;
  SetLength(Result, L);
  {$IFDEF MSWINDOWS}
  L := {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows.GetModuleFileName(Module, Pointer(Result), L);
  {$ENDIF MSWINDOWS}
  {$IFDEF UNIX}
  {$IFDEF FPC}
  L := 0; // FIXME
  {$ELSE ~FPC}
  L := GetModuleFileName(Module, Pointer(Result), L);
  {$ENDIF ~FPC}
  {$ENDIF UNIX}
  SetLength(Result, L);
end;


end.
