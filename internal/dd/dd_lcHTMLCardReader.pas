unit dd_lcHTMLCardReader;
{ Читатель заголовка постановлелений ААС }

interface

uses
 ddHTML_r, k2TagGen, Classes, dt_Types, ddSimpleHTMLReader, evNestedDocumentEliminator, l3Filer;


type
 TlcPartType = (lcNone, lcPlaintiff, lcDefendant, lcOthers, lcCourt, lcNumbers, lcDate);

 Tdd_lcHTMLCardReader = class(TddSimpleHTMLReader)
 private
  f_BodyFile: AnsiString;
  f_BodyFiler: TevDOSFiler;
  f_BodyReader: TddHTMLReader;
  f_CodePage: Integer;
  f_Court: AnsiString;
  f_CurType: TlcPartType;
  f_Date: Integer;
  f_DateCount: Integer;
  f_Filter: TevNestedDocumentEliminator;
  f_LawCaseNumber: AnsiString;
  f_Number: AnsiString;
  f_PartNames: TStrings;
  f_PartTypes: TStrings;
  f_Sources: TStrings;
  procedure AddDateNumbers;
  procedure AddSource;
  procedure AddType;
  procedure AddParticipants;
  function ConvertCourt2Source(aName: AnsiString): AnsiString;
  function GetPartType(aParticipant: AnsiString): TlcParticipantType;
  procedure WorkupMeta(aTag: THTMLTag);
  procedure WorkupTD(aTag: THTMLTag);
  procedure WorkupDIV(aTag: THTMLTag);
  procedure WorkupSPAN(atag: ThtmlTag);
  procedure WorkupUL(atag: ThtmlTag);
  procedure WorkupTagClose(atag: ThtmlTag);
  procedure WorkupTDClosed(atag: ThtmlTag);
  procedure WriteAttributes;
  procedure WriteBody;
 protected
  procedure Read; override;
  procedure Cleanup; override;
  procedure WorkupTag(aTag: THTMLTag); override;
  procedure WorkupText(aText: THTMLText); override;
 public
  constructor Create(aOwner: Tk2TagGeneratorOwner = nil); override;
  property BodyFile: AnsiString read f_BodyFile write f_BodyFile;
  property Sources: TStrings read f_Sources write f_Sources;
 end;

implementation

uses Textpara_Const, k2Tags, DocUment_Const, L3Chars, SysUtils, L3Base,
 JClStringConversions, TypInfo, NumAndDate_Const, DictItem_Const, participant_Const, l3Date,
 l3String, ddHTMLTags;

{
***************************** TddSimpleHTMLReader ******************************
}
constructor Tdd_lcHTMLCardReader.Create(aOwner: Tk2TagGeneratorOwner = nil);
begin
 inherited;
 f_PartNames:= TStringList.Create;
 f_PartTypes:= TStringList.Create;
 f_BodyReader := TddHTMLReader.Create();
 f_BodyReader.Lite:= True;
 f_BodyReader.CodePage:= cp_UTF8;
 f_BodyFiler := TevDOSFiler.Create();
 f_BodyReader.Filer:= f_BodyFiler;
 f_Filter:= TevNestedDocumentEliminator.Create;
 f_BodyReader.Generator:= f_Filter;
end;

procedure Tdd_lcHTMLCardReader.AddDateNumbers;
begin
 if (f_Date <> 0) or (f_Number <> '') or (f_LawCaseNumber <> '') then
 begin
  StartTag(k2_tiNumAndDates);
  try
   StartChild(k2_idNumAndDate);
   try
    AddIntegerAtom(k2_tiType, ord(dnLawCaseNum));
    if f_LawCaseNumber <> '' then
     AddStringAtom(k2_tiNumber, f_LawCaseNumber);
   finally
    Finish;
   end;
   StartChild(k2_idNumAndDate);
   try
    AddIntegerAtom(k2_tiType, ord(dnPublish));
    if f_Date <> 0 then
     AddIntegerAtom(k2_tiStart, f_Date);
    if f_Number <> '' then
     AddStringAtom(k2_tiNumber, f_Number);
   finally
    Finish;
   end;
  finally
   Finish;
  end;
 end;
end;

procedure Tdd_lcHTMLCardReader.AddSource;
begin
 StartTag(k2_tiSources);
 try
  StartChild(k2_idDictItem);
  try
   AddStringAtom(k2_tiName, ConvertCourt2Source(f_Court));
  finally
   Finish;
  end;
 finally
  Finish;
 end;
end;

procedure Tdd_lcHTMLCardReader.AddType;
begin
 StartTag(k2_tiTypes);
 try
  StartChild(k2_idDictItem);
  try
   AddStringAtom(k2_tiName, 'Постановление');
  finally
   Finish;
  end;
 finally
  Finish;
 end;
end;

procedure Tdd_lcHTMLCardReader.Read;
begin
 f_CurType:= lcNone;
 f_PartNames.Clear;
 f_PartTypes.Clear;
 f_Court:= '';
 f_Date:= 0;
 f_DateCount:= 0;
 f_LawCaseNumber:= '';
 f_Number:= '';
 Generator.StartChild(k2_idDocument);
 try
  inherited;
  WriteAttributes;
  WriteBody;
 finally
  Generator.Finish;
 end;
end;

procedure Tdd_lcHTMLCardReader.Cleanup;
begin
 l3Free(f_PartNames);
 l3Free(f_PartTypes);
 FreeAndNil(f_Filter);
 FreeAndNil(f_BodyFiler);
 FreeAndNil(f_BodyReader);
 inherited;
end;

procedure Tdd_lcHTMLCardReader.AddParticipants;
var
 i: Integer;
begin
 StartTag(k2_tiCaseDocParticipants);
 try
  for i:= 0 to Pred(f_PartNames.Count) do
  begin
   StartChild(k2_idParticipant);
   try
    AddStringAtom(k2_tiName, f_PartNames.ValueFromIndex[i]);
    AddIntegerAtom(k2_tiType, Ord(GetPartType(f_PartNames.Names[i])));
   finally
    Finish;
   end;
  end;
 finally
  Finish;
 end;
end;

function Tdd_lcHTMLCardReader.ConvertCourt2Source(aName: AnsiString): AnsiString;
begin
 // Преобразование внешнего имени источника в арчевое
 Result:= '';
 if f_Sources <> nil then
  Result:= f_Sources.Values[aName];
 if Result = '' then
  Result:= aName;
end;

function Tdd_lcHTMLCardReader.GetPartType(aParticipant: AnsiString): TlcParticipantType;
begin
 case TlcPartType(GetEnumValue(TypeInfo(TlcPartType), aParticipant)) of
  lcPlaintiff: Result:= ptPlaintiff;
  lcDefendant: Result:= ptDefendant;
 else
  Result:= ptThirdSide;
 end;
end;

procedure Tdd_lcHTMLCardReader.WorkupMeta(aTag: THTMLTag);
var
 j: Integer;
 k: Integer;
 l_Int: Integer;
 l_Param: ThtmlParam;
 l_S: AnsiString;
begin
 for j:= 0 to Pred(aTag.ParamCount) do
 begin
   l_Param:= aTag.Params[j];
   for k:= 0 to Pred(l_Param.ValueCount) do
   begin
     l_Int:= Pos('CHARSET', UpperCase(l_Param.Values[k]));
     if l_Int <> 0 then
     begin
       l_S:= UpperCase(Copy(l_Param.Values[k], l_int+8, Length(l_Param.Values[k])));
       if l_S = 'WINDOWS-1251' then
         f_CodePage:= cp_Ansi
       else
       if l_S = 'KOI8-R' then
         f_CodePage:= cp_koi8
       else
       if l_S = 'UTF-8' then
        f_CodePage:= CP_UTF8;
     end; // Pos
   end; // for k
 end; // for j;
end;

procedure Tdd_lcHTMLCardReader.WorkupTD(aTag: THTMLTag);
var
 j: Integer;
 k: Integer;
 l_Int: Integer;
 l_Param: ThtmlParam;
 l_S: AnsiString;
begin
 for j:= 0 to Pred(aTag.ParamCount) do
 begin
  l_Param:= aTag.Params[j];
  if AnsiSameText(l_param.Key, 'class') then
   if AnsiSameText(l_Param.Value, 'plaintiffs first') then
    f_CurType:= lcPlaintiff
   else
   if AnsiSameText(l_Param.Value, 'defendants') then
    f_CurType:= lcDefendant
   else
   if AnsiSameText(l_Param.Value, 'others') then
    f_CurType:= lcOthers
   else
   if AnsiSameText(l_Param.Value, 'appeal') then
    f_CurType:= lcCourt
 end; // for j;
end;

procedure Tdd_lcHTMLCardReader.WorkupTag(aTag: THTMLTag);
var
 j, k, l_Int: Integer;
 l_Param: ThtmlParam;
 l_S: AnsiString;
begin
  if aTag.TagID = tidMETA then
   WorkupMeta(aTag)
  else // Tag = META
  if aTag.TagID = tidTD then
   if aTag.IsClosed then
    WorkupTagClose(aTag)
   else
    WorkupTD(aTag)
  else
  if aTag.TagID = tidDIV then
   WorkupDIV(aTag)
  else
  if aTag.TagID = tidUL then
   if aTag.IsClosed then
    WorkupTagClose(aTag)
   else
    WorkupUL(aTag)
end;

procedure Tdd_lcHTMLCardReader.WorkupDIV(aTag: THTMLTag);
var
 j: Integer;
 k: Integer;
 l_Int: Integer;
 l_Param: ThtmlParam;
 l_S: AnsiString;
begin
 for j:= 0 to Pred(aTag.ParamCount) do
 begin
  l_Param:= aTag.Params[j];
  if AnsiSameText(l_param.Key, 'class') then
   if AnsiSameText(l_Param.Value, 'b-chrono-cols g-ec') then
   begin
    f_CurType:= lcDate;
    break;
   end
 end; // for j;
end;

procedure Tdd_lcHTMLCardReader.WorkupSPAN(atag: ThtmlTag);
var
 j: Integer;
 l_Param: ThtmlParam;
begin
 for j:= 0 to Pred(aTag.ParamCount) do
 begin
  l_Param:= aTag.Params[j];
  if AnsiSameText(l_param.Key, 'class') then
   if AnsiSameText(l_Param.Value, 'b-reg-date') then
   begin
    f_CurType:= lcDate;
    break;
   end;
 end; // for j;
end;

procedure Tdd_lcHTMLCardReader.WorkupTDClosed(atag: ThtmlTag);
begin
 f_CurType:= lcNone;
end;

procedure Tdd_lcHTMLCardReader.WorkupText(aText: THTMLText);
var
 l_Text: Tl3String;
 l_S: AnsiString;
begin
 l_Text:= Tl3String.Make(f_CodePage);
 try
   if f_CodePage = cp_UTF8 then
   begin
    l_Text.CodePage:= cp_ANSI;
    if TryUTF8ToString(aText.Line, l_S) then
     l_Text.AsString:= l_S
    else
     l_Text.AsString:= aText.Line;
   end
   else
   begin
    l_Text.AsString:= aText.Line;
    l_Text.CodePage:= cp_ANSI;
   end;
   case f_CurType of
    lcPlaintiff,
    lcDefendant,
    lcOthers: f_partNames.Add(format('%s=%s',[GetEnumName(TypeInfo(TlcPartType), Ord(f_CurType)), l_text.AsString]));
    lcCourt: f_Court:= l_Text.AsString;
    lcNumbers:
     begin
      if l3Starts('А', l_Text.AsPAnsiCharLen, True) then
       f_LawCaseNumber:= l_Text.AsString
      else
      if Pos('АП', l_Text.AsString) > 0 then
       f_Number:= l_Text.AsString;
     end; // lcNumbers
    lcDate:
     begin

      Inc(f_DateCount);
      if f_DateCount = 2 then
       f_Date:= DateTimeTostDate(StrToDateFmtDef('dd.mm.yyyy', Copy(l_Text.AsString, 1, 10), 0));
       
     end; // lcDate
   end;
 finally
   l3Free(l_Text);
 end; // try..finally
end;

procedure Tdd_lcHTMLCardReader.WorkupUL(atag: ThtmlTag);
var
 j: Integer;
 l_Param: ThtmlParam;
begin
 for j:= 0 to Pred(aTag.ParamCount) do
 begin
  l_Param:= aTag.Params[j];
  if AnsiSameText(l_param.Key, 'class') then
   if AnsiSameText(l_Param.Value, 'crumb g-ec') then
   begin
    f_CurType:= lcNumbers;
    break;
   end;
 end; // for j;
end;

procedure Tdd_lcHTMLCardReader.WorkupTagClose(atag: ThtmlTag);
begin
 f_CurType:= lcNone;
end;

procedure Tdd_lcHTMLCardReader.WriteAttributes;
begin
 AddType;
 AddSource;
 AddDateNumbers;
 AddParticipants;
end;

procedure Tdd_lcHTMLCardReader.WriteBody;
begin
 f_BodyFiler.FileName:= f_BodyFile;
 f_Filter.Generator:= Generator;
 f_BodyReader.Execute;
end;

end.
