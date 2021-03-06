unit ddCharacterProperty;

interface

uses
  Classes, ddBase, k2Prim, l3Interfaces, RTfTypes, l3Types;

type
  TddCharacterProperty = class(TddPropertyObject)
  private
    f_FontName: AnsiString;
    f_LongProperties: Array[TddCharProperties] of Longint;
    function GetParam(Index: TddCharProperties): LongInt;
    procedure SetParam(Index: TddCharProperties; Value: LongInt);
  protected
    function GetAnime: TAnime;
    function GetBoolProperty(Index: TddCharProperties): Boolean;
    function GetByteProperty(Index: TddCharProperties): Byte;
    function GetCaps: TCharCapsType;
    function GetContour: TContourType;
    function GetFontName: AnsiString;
    function GetLongProperty(Index: TddCharProperties): LongInt;
    function GetPos: TCharPosition;
    function GetUnderline: TUnderline;
    procedure SetAnime(Value: TAnime);
    procedure SetBoolProperty(Index: TddCharProperties; Value: Boolean);
    procedure SetByteProperty(Index: TddCharProperties; Value: Byte);
    procedure SetCaps(Value: TCharCapsType);
    procedure SetContour(Value: TContourType);
    procedure SetFontName(Value: AnsiString);
    procedure SetLongProperty(Index: TddCharProperties; Value: Longint);
    procedure SetPos(Value: TCharPosition);
    procedure SetUnderline(Value: TUnderline);
    property Param[Index: TddCharProperties]: LongInt read GetParam write
            SetParam;
  public
    constructor Create(aOwner: TObject); override;
    procedure Assign(ACHP: TPersistent); override;
    procedure AssignToFont(const Font: Il3Font);
    procedure Clear; override;
    function OCompare(anObject: TObject): Long; override;
    function Diff(P: TddPropertyObject): TddPropertyObject; override;
    function JoinWith(P: TObject): Long; override;
    procedure MergeWith(P: TddPropertyObject); override;
    procedure InheriteFrom(P: TddPropertyObject); override;
    procedure Reset; override;
    procedure Write2Generator(const Generator: Ik2TagGenerator); override;
    property Anime: TAnime read GetAnime write SetAnime;
    property BColor: LongInt index ddBColor read GetLongProperty write
            SetLongProperty;
    property BIndexColor: LongInt index ddBackColor read GetLongProperty write
            SetLongProperty;
    property Bold: Boolean index ddBold read GetBoolProperty write
            SetBoolProperty;
    property Caps: TCharCapsType read GetCaps write SetCaps;
    property CharScale: LongInt index ddCharScale read GetLongProperty write
            SetLongProperty;
    property Contour: TContourType read GetContour write SetContour;
    property Deleted: Boolean index ddDeleted read GetBoolProperty write
            SetBoolProperty;
    property EvdStyle: LongInt index ddEvdStyle read GetLongProperty write
            SetLongProperty;
    property FColor: LongInt index ddFColor read GetLongProperty write
            SetLongProperty;
    property FIndexColor: LongInt index ddForeColor read GetLongProperty write
            SetLongProperty;
    property FontName: AnsiString read GetFontName write SetFontName;
    property FontNumber: LongInt index ddFontNumber read GetLongProperty write
            SetLongProperty;
    property FontCharSet: LongInt
      index ddFontCharSet
      read GetLongProperty
      write SetLongProperty;
    property FontSize: LongInt index ddFontSize read GetLongProperty write
            SetLongProperty;
    property PrintFontSize: LongInt index ddPrintFontSize read GetLongProperty write
            SetLongProperty;
    property Hidden: Boolean index ddHidden read GetBoolProperty write
            SetBoolProperty;
    property Highlight: LongInt index ddHighlight read GetLongProperty write
            SetLongProperty;
    property Italic: Boolean index ddItalic read GetBoolProperty write
            SetBoolProperty;
    property Language: LongInt index ddLanguage read GetLongProperty write
            SetLongProperty;
    property Pos: TCharPosition read GetPos write SetPos;
    property Strikeout: Boolean index ddStrikeout read GetBoolProperty write
            SetBoolProperty;
    property Style: LongInt index ddStyle read GetLongProperty write
            SetLongProperty;
    property Subpos: LongInt index ddSubPos read GetLongProperty write
            SetLongProperty;
    property Underline: TUnderline read GetUnderline write SetUnderline;
  end;

implementation

uses
  Graphics, StrUtils, SysUtils, k2Tags, l3FontManager, ddRTFConst, l3String,
  Windows;

  { start class TddCharacterProperty }

{
***************************** TddCharacterProperty *****************************
}
constructor TddCharacterProperty.Create(aOwner: TObject);
begin
  inherited Create(aOwner);
  Clear;
end;

procedure TddCharacterProperty.Assign(ACHP: TPersistent);
var
  _CHP: TddCharacterProperty absolute aCHP;
  Index: TddCharProperties;
begin
  if (aCHP Is TddCharacterProperty) then
  begin
   for index:= Low(TddCharProperties) to High(TddCharProperties) do
     f_LongProperties[index]:= _CHP.Param[index];
  
   f_FontName:= _CHP.FontName;
   IsDefault:= _CHP.IsDefault;
  end else
   inherited Assign(aCHP);
end;

procedure TddCharacterProperty.AssignToFont(const Font: Il3Font);
var
  FS: TFontStyles;
begin
  Font.Name:= FontName;
  Font.Size:= FontSize div 2;
  FS:= [];
  if Bold = True then
    FS:= [fsBold];
  if Italic = True then
   FS:= FS +[fsItalic];
  if Underline <> utNone then
    FS:= FS + [fsUnderline];
  Font.Style:= FS;
  if Bcolor > 0 then
    Font.BackColor:= BColor;
  if FColor > 0 then
    Font.ForeColor:= FColor;
  if Highlight > 0 then
   Font.BackColor:= Highlight;
end;

procedure TddCharacterProperty.Clear;
var
  index: TddCharProperties;
begin
  inherited;
  for index:= Low(TddCharProperties) to High(TddCharProperties) do
   Param[index]:= propUndefined;
  
  //FontSize := 20;
  FontName := '';//'Arial Cyr';
  //Language := langRussian;
  //Style    := 0;
  IsDefault:= True;
end;

function TddCharacterProperty.OCompare(anObject: TObject): Long;
var
  index: TddCharProperties;
begin
 if (anObject Is TddCharacterProperty) then
 begin
  Result := 1;
  if not AnsiSameText(FontName, TddCharacterProperty(anObject).FontName) then
   exit;
  for index:= Low(TddCharProperties) to High(TDdCharProperties) do
  begin
   if TddCharacterProperty(anObject).Param[index] <> Param[Index] then
    exit;
  end;
  Result:= 0;
 end
 else
  Result := inherited OCompare(anObject);
end;

function TddCharacterProperty.Diff(P: TddPropertyObject): TddPropertyObject;
var
 aCHP: TddCharacterProperty absolute P;
 index: TddCharProperties;
 l_IsDefault: Boolean;
begin
  if P = nil then
   Result:= nil
  else
  if OCompare(p) = 0 then
    Result:= nil
  else
  begin
   l_isDefault:= True;
    Result:= TddCharacterProperty.Create(nil);
    try
     if (P Is TddCharacterProperty) then
     begin
       for index:= Low(TddCharProperties) to High(TddCharProperties) do
       begin
        if aCHP.Param[index] = Param[Index] then
         TddCharacterProperty(Result).Param[index]:= propUndefined
        else
        if Param[index] = propUndefined then
         TddCharacterProperty(Result).Param[index]:= aCHP.Param[index]
        else
        if aCHP.Param[index] <> propUndefined then
         TddCharacterProperty(Result).Param[index]:= aCHP.Param[index];
        // TddCharacterProperty(Result).Param[index]:= Param[index];
        if TddCharacterProperty(Result).Param[index] <> propUndefined then
         l_IsDefault:= False;
       end; // for index
       // ��� ������
       if aCHP.Param[ddFontNumber] = Param[ddFontNumber] then
        TddCharacterProperty(Result).FontName:= ''
       else
       if Param[ddFontNumber] = propUndefined then
        TddCharacterProperty(Result).FontName:= aCHP.FontName
       else
       if aCHP.Param[ddFontNumber] <> propUndefined then
        TddCharacterProperty(Result).FontName:= aCHP.FontName;
     end; // P Is TddCharacterProperty
     if l_IsDefault then
      FreeAndNil(Result)
     else
      Result.IsDefault:= False;
    except
     FreeAndNil(Result);
    end;
  end;
end;

function TddCharacterProperty.GetAnime: TAnime;
begin
  if f_LongProperties[ddAnime] <> propUndefined then
   Result:= TAnime(f_LongProperties[ddAnime])
  else
   Result:= atNone;
end;

function TddCharacterProperty.GetBoolProperty(Index: TddCharProperties):
        Boolean;
begin
  if f_LongProperties[Index] <> propUndefined then
   Result:= LongBool(f_LongProperties[Index])
  else
   Result:= False;
end;

function TddCharacterProperty.GetByteProperty(Index: TddCharProperties): Byte;
begin
  Result:= Byte(f_LongProperties[Index]);
end;

function TddCharacterProperty.GetCaps: TCharCapsType;
begin
  if f_LongProperties[ddCaps] <> propUndefined then
   Result:= TCharCapsType(f_LongProperties[ddCaps])
  else
   Result:= ccNone;
end;

function TddCharacterProperty.GetContour: TContourType;
begin
  if f_LongProperties[ddContour] <> propUndefined then
   Result:= TContourType(f_LongProperties[ddContour])
  else
   Result:= ctNone;
end;

function TddCharacterProperty.GetFontName: AnsiString;
begin
  Result:= f_FontName;
end;

function TddCharacterProperty.GetLongProperty(Index: TddCharProperties):
        LongInt;
begin
  Result:= f_LongProperties[Index];
end;

function TddCharacterProperty.GetParam(Index: TddCharProperties): LongInt;
begin
  Result:= f_LongProperties[Index];
end;

function TddCharacterProperty.GetPos: TCharPosition;
begin
  if f_LongProperties[ddCharPosition] <> propUndefined then
   Result:= TCharPosition(f_LongProperties[ddCharPosition])
  else
   Result:= cpNotDefined;
end;

function TddCharacterProperty.GetUnderline: TUnderline;
begin
  if f_LongProperties[ddUnderline] <> propUndefined then
   Result:= TUnderline(f_LongProperties[ddUnderline])
  else
   Result:= utNotDefined;
end;

function TddCharacterProperty.JoinWith(P: TObject): Long;
var
  aCHP: TddCharacterProperty absolute P;
  index: TddCharProperties;
begin
  if (P Is TddCharacterProperty) then
  begin
   Result := 0;
   IsDefault:= IsDefault and aCHP.IsDefault;
   if FontName = '' then
   begin
    FontName:= aCHP.FontName;
    //FontNumber:= aCHP.FontNumber;
   end;

   for index:= Low(TddCharProperties) to High(TddCharProperties) do
    if Param[Index] = propUndefined then // transparent
     Param[index]:= aCHP.Param[Index]
//    else
//    if aCHP.Param[Index] <> propUndefined then
//     Param[index]:= aCHP.Param[Index];
  end
  else
   Result := -1;
end;

procedure TddCharacterProperty.MergeWith(P: TddPropertyObject);
var
  aCHP: TddCharacterProperty absolute P;
  Index: TddCharProperties;
begin
  if (P Is TddCharacterProperty) then
  begin
   IsDefault:= False;
  for index:= Low(TddCharProperties) to High(TddCharProperties) do
   if (aCHP.Param[Index] <> propUndefined) and (Param[Index] = propUndefined) then  
    Param[index]:= aCHP.Param[Index];
  end;
end;

procedure TddCharacterProperty.InheriteFrom(P: TddPropertyObject);
var
  aCHP: TddCharacterProperty absolute P;
  Index: TddCharProperties;
begin
  if (P Is TddCharacterProperty) then
  begin
   IsDefault:= False;
  for index:= Low(TddCharProperties) to High(TddCharProperties) do
   if (aCHP.Param[Index] <> propUndefined) and (Param[Index] <> propUndefined) then
    Param[index]:= aCHP.Param[Index];
  end;
end;

procedure TddCharacterProperty.Reset;
begin
  Clear;
  f_FontName:= '';
end;

procedure TddCharacterProperty.SetAnime(Value: TAnime);
begin
  if Value <> Anime then
  begin
    f_LongProperties[ddAnime]:= Ord(Value);
    IsDefault:= False;
  end;
end;

procedure TddCharacterProperty.SetBoolProperty(Index: TddCharProperties; Value:
        Boolean);
begin
  if (f_LongProperties[Index] = propUndefined) or
     ((f_LongProperties[Index] <> propUndefined) and
       LongBool(f_LongProperties[Index]) <> Value) then
  begin
    f_LongProperties[Index]:= Ord(Value);
    IsDefault:= False;
  end;
end;

procedure TddCharacterProperty.SetByteProperty(Index: TddCharProperties; Value:
        Byte);
begin
  if f_LongProperties[Index] <> Value then
  begin
    f_LongProperties[Index]:= Value;
    IsDefault:= False;
  end;
end;

procedure TddCharacterProperty.SetCaps(Value: TCharCapsType);
begin
  if Value <> Caps then
  begin
    IsDefault:= False;
    f_LongProperties[ddCaps]:= Ord(Value);
  end;
end;

procedure TddCharacterProperty.SetContour(Value: TContourType);
begin
  if Value <> Contour then
  begin
    IsDefault:= False;
    f_LongProperties[ddContour]:= Ord(Value);
  end;
end;

procedure TddCharacterProperty.SetFontName(Value: AnsiString);
begin
  if f_FontName <> Value then
  begin
    f_FontName:= Value;
    IsDefault:= False;
  end;
end;

procedure TddCharacterProperty.SetLongProperty(Index: TddCharProperties; Value:
        Longint);
begin
  if f_LongProperties[Index] <> Value then
  begin
   f_LongProperties[Index]:= Value;
   if Index <> ddStyle then
    IsDefault:= False;
  end;
end;

procedure TddCharacterProperty.SetParam(Index: TddCharProperties; Value:
        LongInt);
begin
  f_LongProperties[Index]:= Value;
end;

procedure TddCharacterProperty.SetPos(Value: TCharPosition);
begin
  if Value <> Pos then
  begin
    f_LongProperties[ddCharPosition]:= Ord(Value);
    IsDefault:= False;
  end;
end;

procedure TddCharacterProperty.SetUnderline(Value: TUnderline);
begin
  if Value <> Underline then
  begin
    IsDefault:= False;
    f_LongProperties[ddUnderline]:= Ord(Value);
  end;
end;

procedure TddCharacterProperty.Write2Generator(const Generator: Ik2TagGenerator);
var
  l_CharSet: Long;
  l_LogFont: Tl3LogFont;
begin
  // ���� �� ����������� ���������� ����������
 if Hidden then
  Generator.AddBoolAtom(k2_tiVisible, ByteBool(False));
  Generator.StartTag(k2_tiFont);
  try
   if Bold then
    Generator.AddBoolAtom(k2_tiBold, ByteBool(Bold));
   if Italic then
    Generator.AddBoolAtom(k2_tiItalic, ByteBool(Italic));
   if StrikeOut then
    Generator.AddBoolAtom(k2_tiStrikeout, ByteBool(Strikeout));
   if (Language = langRussian) and (FontName <> '') and
       ((Length(FontName) < 4) OR (l3Compare(PAnsiChar(FontName)+Length(FontName)-4,
                                             ' CYR', l3_siCaseUnsensitive) <> 0)) then
    begin
     l_LogFont := Tl3LogFont(l3FontManager.Fonts.DRByName[FontName]);
     if (l_LogFont <> nil) then
      l_CharSet := l_LogFont.LogFont.elfLogFont.lfCharSet
     else
      l_CharSet := DEFAULT_CHARSET;
     if not (l_CharSet in [SYMBOL_CHARSET, RUSSIAN_CHARSET]) then
  
     FontName := FontName + ' CYR';
    end;
   if FontName <> '' then
    Generator.AddStringAtom(k2_tiName, FontName);

   if (FontSize <> propUndefined) then
    Generator.AddIntegerAtom(k2_tiSize, FontSize div 2);
   if fColor <> propUndefined then
    Generator.AddIntegerAtom(k2_tiForeColor, FColor);
   if bColor <> propUndefined then
    Generator.AddIntegerAtom(k2_tiBackColor, BColor);
   if Highlight <> propUndefined then
    Generator.AddIntegerAtom(k2_tiBackColor, Highlight);

   case Pos of
    cpSuperScript: Generator.AddIntegerAtom(k2_tiIndex, ord(l3_fiSuper));
    cpSubScript: Generator.AddIntegerAtom(k2_tiIndex, ord(l3_fiSub));
   end; // pos
   if (Underline <> utNotDefined) then
    Generator.AddBoolAtom(k2_tiUnderline, (Underline <> utNone) and (Underline <> utNotDefined));
  finally
    Generator.Finish;
  end;
end;

end.
