unit dd_rtfFields;
{ Обработка полей и форм из RTF }

{ $Id: dd_rtfFields.pas,v 1.4 2013/04/11 16:46:29 lulin Exp $ }

// $Log: dd_rtfFields.pas,v $
// Revision 1.4  2013/04/11 16:46:29  lulin
// - отлаживаем под XE3.
//
// Revision 1.3  2013/04/05 12:04:30  lulin
// - портируем.
//
// Revision 1.2  2013/01/24 06:55:32  narry
// Поддержка нумерованных абзацев (пока не работает)
//
// Revision 1.1  2013/01/22 12:19:52  narry
// Рефакторинг RTFReader
//

interface

uses
  ddRTFDestination, ddRTFState, l3StringList, ddBase, k2Prim, l3Base,
  RTFTypes, ddDocumentAtom;

type
 TdestField = class(TddRTFDestination)
 end;

 TddFieldType = (dd_fieldUnknown, dd_fieldHyperlink, dd_fieldSymbol, dd_fieldForm);
 TdestFieldInstruction = class(TddRTFDestination)
 private
  f_FieldResult: AnsiString;
  f_Instruction: AnsiString;
 protected
  function GetFieldType: TddFieldType;
 public
  procedure AddAnsiChar(aText: AnsiChar; aState: TddRTFState); override;
  procedure AddString(aText: Tl3String; aState: TddRTFState); override;
  procedure Instruction2Result;
  property FieldResult: AnsiString read f_FieldResult;
  property FieldType: TddFieldType read GetFieldType;
 end;

 TdestFieldResult = class(TdestNorm)
 private
  function pm_GetFieldResult: AnsiString;
  procedure pm_SetFieldResult(const Value: AnsiString);
 public
  procedure Clear; override;
  property FieldResult: AnsiString read pm_GetFieldResult write pm_SetFieldResult;
 end;

 TdestFormField = class(TddRTFDestination)
 private
  f_DefaultResult: Integer;
  f_FormResult: Integer;
  f_FormSize: Integer;
  f_FormType: Integer;
  f_Items: Tl3StringList;
  f_TextType: Integer;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure AddItem(const aItem: AnsiString);
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  procedure Clear; override;
  function GetFormResult: AnsiString;
  property DefaultResult: Integer read f_DefaultResult write f_DefaultResult;
  property FormResult: Integer read f_FormResult write f_FormResult;
  property FormSize: Integer read f_FormSize write f_FormSize;
  property FormType: Integer read f_FormType write f_FormType;
  property TextType: Integer read f_TextType write f_TextType;
 end;

  TddField = class(TddDocumentAtom)
  private
    f_FormDefResult: Integer;
    f_FormItems: Tl3StringList;
    f_FormResult: Integer;
    f_FormType: Integer;
    f_Instruction: Tl3String;
    f_Result: Tl3String;
  protected
    function GetFieldType: TddFieldType;
    procedure Cleanup; override;
  public
    constructor Create(aOwner: TObject); override;
    procedure AddListItem(const aItem: AnsiString); overload;
    procedure AddListItem(aItem: Tl3String); overload;
    procedure Clear; override;
    procedure Instruction2Result;
    procedure Write2Generator(const Generator: Ik2TagGenerator; const LiteVersion:
            Boolean = False); override;
    property FieldResult: Tl3String read f_Result;
    property FieldType: TddFieldType read GetFieldType;
    property FormDefResult: Integer read f_FormDefResult write f_FormDefResult;
    property FormResult: Integer read f_FormResult write f_FormResult;
    property FormType: Integer read f_FormType write f_FormType;
    property Instruction: Tl3String read f_Instruction;
  end;

 TdestFormFieldItem = class(TddRTFDestination)
 private
  f_Item: AnsiString;
 public
  procedure AddAnsiChar(aText: AnsiChar; aState: TddRTFState); override;
  procedure AddString(aText: Tl3String; aState: TddRTFState); override;
  procedure AddUnicodeChar(aText: Word; aState: TddRTFState); override;
  property Item: AnsiString read f_Item write f_Item;
 end;

implementation

uses
  ddRTFConst, StrUtils, SysUtils, Math, l3PrimString;

procedure TdestFieldInstruction.AddAnsiChar(aText: AnsiChar; aState: TddRTFState);
begin
 f_Instruction:= f_Instruction + aText;
end;

procedure TdestFieldInstruction.AddString(aText: Tl3String; aState:
    TddRTFState);
begin
 f_Instruction:= f_Instruction + aText.AsString;
end;

function TdestFieldInstruction.GetFieldType: TddFieldType;
{
'CREATEDATE' | 'DATE' | 'EDITTIME' | 'PRINTDATE' | 'SAVEDATE' | 'TIME'
'COMPARE' | 'DOCVARIABLE' | 'GOTOBUTTON' | 'IF' | 'MACROBUTTON' | 'PRINT'
'AUTHOR' | 'COMMENTS' | 'DOCPROPERTY' | 'FILENAME' | 'FILESIZE' | 'INFO' | 'KEYWORDS' | 'LASTSAVEDBY' | 'NUMCHARS' | 'NUMPAGES' | 'NUMWORDS' | 'SUBJECT' | 'TEMPLATE' | 'TITLE'
'FORMTEXT' | 'FORMCHECKBOX' | 'FORMDROPDOWN'
('=' <formula>) | 'ADVANCE' | 'EQ' | 'SYMBOL'
'INDEX' | 'RD' | 'TA' | 'TC' | 'TOA' | 'TOC' | 'XE'
'AUTOTEXT' | 'AUTOTEXTLIST' | 'HYPERLINK' | 'INCLUDEPICTURE' | 'INCLUDETEXT' | 'LINK' | 'NOTEREF' | 'PAGEREF' | 'QUOTE' | 'REF' | 'STYLEREF'
'ADDRESSBLOCK' | 'ASK' | 'COMPARE' | 'DATABASE' | 'FILLIN' | 'GREETINGLINE' | 'IF' | 'MERGEFIELD' | 'MERGEREC' | 'MERGESEQ' | 'NEXT' | 'NEXTIF' | 'SET' | 'SKIPIF'
'AUTONUM' | 'AUTONUMLGL' | 'AUTONUMOUT' | 'BARCODE' | 'LISTNUM' | 'PAGE' | 'REVNUM' | 'SECTION' | 'SECTIONPAGES' | 'SEQ'
'USERADDRESS' | 'USERINITIALS' | 'USERNAME'
}

begin
  if AnsiContainsText(f_Instruction, 'HYPERLINK') or AnsiContainsText('REF', f_Instruction) then
    Result:= dd_fieldHyperlink
  else
  if AnsiContainsText(f_Instruction, 'SYMBOL') then
   Result:= dd_fieldSymbol
  else
  if AnsiContainsText(f_Instruction, 'FORMDROPDOWN') then
   Result:= dd_fieldForm
  else
   Result:= dd_fieldUnknown;
end;

procedure TdestFieldInstruction.Instruction2Result;
var
  S: AnsiString;
begin
 case FieldType of
  dd_fieldUnknown: ;
  dd_fieldHyperlink: ;
  dd_fieldSymbol:
   begin
    // Оформление символа пока игнорируем
    S:=  Copy(f_Instruction, Pos('SYMBOL', f_Instruction) + Length('SYMBOL')+1, Length(f_Instruction));
    S:= Copy(S, 1, Pos(' ', S)-1);
    f_FieldResult:= Chr(StrToIntDef(S, 32));
   end;
  dd_fieldForm:
   (*
    if (FormType = 2) and (InRange(FormResult, 0, f_FormItems.Hi) or
                          (InRange(FormDefResult, 0, f_FormItems.Hi))) then
    begin
     if InRange(FormResult, 0, f_FormItems.Hi) then
      f_Result.Assign(f_FormItems.Items[FormResult])
     else
      f_Result.Assign(f_FormItems.Items[FormDefResult]);
    end*); // InRange
 end;
end;

procedure TdestFieldResult.Clear;
begin
 inherited;
end;

function TdestFieldResult.pm_GetFieldResult: AnsiString;
begin
 if LastParagraph = nil then
  Result:= ''
 else
  Result := LastParagraph.Text.AsString;
end;

procedure TdestFieldResult.pm_SetFieldResult(const Value: AnsiString);
begin
 if LastParagraph = nil then
  AddTextPara(False);
 LastParagraph.Text.AsString:= Value;
end;

constructor TdestFormField.Create;
begin
 inherited Create;
 f_Items := Tl3StringList.Create();
end;

procedure TdestFormField.AddItem(const aItem: AnsiString);
begin
 f_Items.Add(aItem);
end;

procedure TdestFormField.ApplyProperty(propType: TPropType; What: Tiprop;
    Value: Longint; aState: TddRTFState);
begin
 case What of
  ipropfftype: FormType:= Value;
  //ipropffsize: FormSize:= Value;
  ipropffdefres: DefaultResult:= Value;
  //ipropfftypetxt: TextType:= Value;
  ipropffres: FormResult:= Value;
 end;
end;

procedure TdestFormField.Cleanup;
begin
 inherited;
 FreeAndNil(f_Items);
end;

procedure TdestFormField.Clear;
begin
 FormType:= -1;
 FormSize:= -1;
 DefaultResult:= -1;
 TextType:= -1;
 f_Items.Clear;
end;

function TdestFormField.GetFormResult: AnsiString;
begin
 Result:= '';
 if (FormType = 2) and (InRange(FormResult, 0, f_Items.Hi) or
                       (InRange(DefaultResult, 0, f_Items.Hi))) then
 begin
  if InRange(FormResult, 0, f_Items.Hi) then
   Result:= f_Items.Items[FormResult].AsString
  else
   Result:= f_Items.Items[DefaultResult].AsString;
 end; // InRange
end;

{  TddField }

{
*********************************** TddField ***********************************
}
constructor TddField.Create(aOwner: TObject);
begin
 inherited;
 AtomType:= dd_docField;
 f_Instruction:= Tl3String.Create;
 f_Result     := Tl3String.Create;
 f_FormItems := Tl3StringList.Create();
 f_FormResult:= -1;
 f_FormDefResult:= -1;
 f_FormType:= 0;
end;

procedure TddField.AddListItem(const aItem: AnsiString);
begin
 f_FormItems.Add(aItem);
end;

procedure TddField.AddListItem(aItem: Tl3String);
begin
 f_FormItems.Add(aItem.AsString);
end;

procedure TddField.Clear;
begin
 inherited;
 f_Instruction.Clear;
 f_Result.Clear;
 f_FormItems.Clear;
end;

function TddField.GetFieldType: TddFieldType;
begin
  if AnsiContainsText(Instruction.AsString, 'HYPERLINK') or AnsiContainsText('REF', Instruction.AsString) then
    Result:= dd_fieldHyperlink
  else
  if AnsiContainsText(Instruction.AsString, 'SYMBOL') then
   Result:= dd_fieldSymbol
  else
  if AnsiContainsText(Instruction.AsString, 'FORMDROPDOWN') then
   Result:= dd_fieldForm
  else
   Result:= dd_fieldUnknown;
end;

procedure TddField.Cleanup;
begin
 FreeAndNil(f_FormItems);
 FreeAndNil(f_Instruction);
 FreeAndNil(f_Result);
 inherited
end;

procedure TddField.Instruction2Result;
var
  S: AnsiString;
begin
 case FieldType of
  dd_fieldUnknown: ;
  dd_fieldHyperlink: ;
  dd_fieldSymbol:
   begin
    // Оформление символа пока игнорируем
    S:=  Copy(Instruction.AsString, Pos('SYMBOL', Instruction.AsString) + Length('SYMBOL')+1, Instruction.Len);
    S:= Copy(S, 1, Pos(' ', S)-1);
    f_Result.AsString:= Chr(StrToIntDef(S, 32));
   end;
  dd_fieldForm:
    if (FormType = 2) and (InRange(FormResult, 0, f_FormItems.Hi) or
                          (InRange(FormDefResult, 0, f_FormItems.Hi))) then
    begin
     if InRange(FormResult, 0, f_FormItems.Hi) then
      f_Result.Assign(f_FormItems.Items[FormResult])
     else
      f_Result.Assign(f_FormItems.Items[FormDefResult]);
    end; // InRange
 end;
end;

procedure TddField.Write2Generator(const Generator: Ik2TagGenerator; const
        LiteVersion: Boolean = False);
begin
  {}
end;

procedure TdestFormFieldItem.AddAnsiChar(aText: AnsiChar; aState: TddRTFState);
begin
 f_Item:= f_Item + aText;
end;

procedure TdestFormFieldItem.AddString(aText: Tl3String; aState: TddRTFState);
begin
 f_Item:= aText.AsString;
end;

procedure TdestFormFieldItem.AddUnicodeChar(aText: Word; aState: TddRTFState);
begin
end;

end.
