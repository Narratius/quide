unit ddTextParagraph;

interface

uses
  Classes, ddBase, ddCharacterProperty, ddDocumentAtom, ddParagraphProperty,
      ddTextSegment, k2Prim, l3CBaseRefList, l3ProtoPersistentRefList, l3Base,
      l3Types, rtfListTable;

type
  TddPicture = class;
  TddTextParagraph = class(TddDocumentAtom)
  private
    f_CharacterStyle: LongInt;
    f_CHP: TddCharacterProperty;
    f_ExpandTabs: Boolean;
    f_FirstStep: Boolean;
    f_ID: Integer;
    f_PAP: TddParagraphProperty;
    f_RTFString: Tl3String;
    f_Segments: Tl3ProtoPersistentRefList;
    f_SubList: Tl3CBaseRefList;
    f_Unicode: Boolean;
    f_Width: LongInt;
    f_Text: Tl3String;
    f_Inc: Integer;
    f_Offset: Integer;
    function CheckInTable(const Generator: Ik2TagGenerator; const LiteVersion: Boolean = False): Boolean;
    function GetSegmentCount: Integer;
    procedure SetCHP(Value: TddCharacterProperty);
    procedure SetPAP(Value: TddParagraphProperty);
    procedure WriteHyperlinks(const Generator: Ik2TagGenerator);
    function WritePAP(const Generator: Ik2TagGenerator; LiteVersion, aStyled: Boolean): Boolean;
    procedure WriteSegments(const Generator: Ik2TagGenerator);
    procedure WriteTabStops(const Generator: Ik2TagGenerator);
  protected
    function CheckSegments: Boolean;
    function GetEmpty: Boolean; override;
    function GetRTFString: Tl3String;
    function GetSegments(Index: Integer): TddTextSegment;
    function GetText: Tl3String;
    procedure Cleanup; override;
    procedure SetText(aTExt: Tl3String);
    procedure WriteSubs(const aGenerator: Ik2TagGenerator);
    property _Text: Tl3String read f_Text;
  public
    constructor Create(aOwner: TObject); override;
    procedure AddHyperlink(aText: AnsiString; aDocID, aSubID: Integer);
    procedure AddListIndex(aList: TrtfList; aLite: Boolean);
    procedure AddPicture(aPicture: TddPicture);
    procedure AddSegment(aCHP: TddCharacterProperty; const RelativeToText:
            Boolean = False); overload;
    procedure AddSegment(aSegment: TddTextSegment); overload;
    procedure AddSub(aSubID: Integer; aName: AnsiString; aIsRealName: Boolean = True);
    procedure AddText(aText: AnsiChar; const aCodePage: Long = CP_ANSI); overload;
    procedure AddText(aText: AnsiString; const aCodePage: Long = CP_ANSI); overload;
    procedure AddText(aText: Tl3String); overload;
    function AnySegmentByCharIndex(Index: Longint; const EndSegment: Boolean =
            False): TddTextSegment;
    procedure ApplyCHP(aCHP: TddCharacterProperty);
    procedure ApplyPAP(aPAP: TddParagraphProperty);
    procedure Assign(P: TPersistent); override;
    procedure Clear; override;
    procedure CorrectSegments(aPrevPara: TddTextParagraph);
    function DeleteLastSegment: Boolean;
    function HaveHyperlinks: Boolean;
    function HaveObjects: Boolean;
    function HaveSegments: Boolean;
    function HyperlinkByCharIndex(Index: Longint; const EndSegment: Boolean =
            False): TddTextSegment;
    function ObjectByCharIndex(Index: Longint; const EndSegment: Boolean = False): TddTextSegment;
    function JoinWith(P: TObject; aCorrectSegment: Boolean = False): Long;
            override;
    function LastSegment: TddTextSegment;
    procedure PackSegments;
    function PrevCHP(aCurSegment: TddTextSegment): TddCharacterProperty;
    function SegmentByCharIndex(Index: Longint; const EndSegment: Boolean = False; const StartIndex:
        Integer = -1): TddTextSegment;
    procedure Write2Generator(const Generator: Ik2TagGenerator; const LiteVersion:
            Boolean = False); override;
    property CharacterStyle: LongInt read f_CharacterStyle write
            f_CharacterStyle;
    property CHP: TddCharacterProperty read f_CHP write SetCHP;
    property Empty: Boolean read GetEmpty;
    property ExpandTabs: Boolean read f_ExpandTabs write f_ExpandTabs;
    property FirstStep: Boolean read f_FirstStep write f_FirstStep;
    property ID: Integer read f_ID write f_ID;
    property PAP: TddParagraphProperty read f_PAP write SetPAP;
    property RTFString: Tl3String read GetRTFString;
    property SegmentCount: Integer read GetSegmentCount;
    property SegmentList: Tl3ProtoPersistentRefList read f_Segments;
    property Segments[Index: Integer]: TddTextSegment read GetSegments;
    property SubList: Tl3CBaseRefList read f_SubList write f_SubList;
    property Text: Tl3String read GetText write SetText;
    property Unicode: Boolean read f_Unicode write f_Unicode;
    property Width: LongInt read f_Width write f_Width;
  end;

  TddPicture = class(TddTextParagraph)
  private
    f_Binary: Boolean;
    f_BPP: Integer;
    f_CropL: Integer;
    f_CropR: Integer;
    f_CropB: Integer;
    f_CropT: Integer;
    f_ExternalHandle: Integer;
    f_ExternalPath: AnsiString;
    f_Format: Integer;
    f_GoalX: Integer;
    f_GoalY: Integer;
    f_Height: LongInt;
    f_Picture: Tl3String;
    f_ScaleX: Integer;
    f_ScaleY: Integer;
    f_Stream: TStream;
    f_Width: LongInt;
    procedure CropPicture;
    procedure ScalePicture;
  protected
    procedure ConvertToBin;
    procedure ConvertToHex;
    function GetFormat: Integer;
    function GetStream: TStream;
    procedure Cleanup; override;
    procedure SetBinary(Value: Boolean);
    procedure SetStream(Value: TStream);
  public
    constructor Create(aOwner: TObject); override;
    procedure AddHexStream(Value: TStream);
    procedure Assign(P: TPersistent); override;
    procedure Clear; override;
    procedure Write2Generator(const Generator: Ik2TagGenerator; const LiteVersion:
            Boolean = False); override;
    property BPP: Integer read f_BPP write f_BPP;
    property CropL: Integer read f_CropL write f_CropL;
    property CropR: Integer read f_CropR write f_CropR;
    property CropB: Integer read f_CropB write f_CropB;
    property CropT: Integer read f_CropT write f_CropT;
    property ExternalHandle: Integer read f_ExternalHandle write f_ExternalHandle;
    property ExternalPath: AnsiString read f_ExternalPath write f_ExternalPath;
    property Format: Integer read GetFormat write f_Format;
    property GoalX: Integer read f_GoalX write f_GoalX;
    property GoalY: Integer read f_GoalY write f_GoalY;
    property Height: LongInt read f_Height write f_Height;
    property IsBinary: Boolean read f_Binary write SetBinary;
    property Picture: Tl3String read f_Picture;
    property ScaleX: Integer read f_ScaleX write f_ScaleX;
    property ScaleY: Integer read f_ScaleY write f_ScaleY;
    property Stream: TStream read GetStream write SetStream;
    property Width: LongInt read f_Width write f_Width;
  end;

implementation

uses
  evdTypes, SysUtils, l3String, k2Tags, evdStyles, RTfTypes, l3Chars, Math, ddRTFConst,
  l3FontManager, TextPara_Const, SegmentsLayer_Const, TextSegment_Const,
  Hyperlink_Const, Address_Const, Windows, l3Interfaces, SubLayer_Const,
  Sub_Const, Tabstop_Const, l3Memory, imageenio, imageenview, ddRTFUnits,
  BitmapPara_Const, l3Math, ObjectSegment_Const;

{ TddTextParagraph }

{
******************************* TddTextParagraph *******************************
}
constructor TddTextParagraph.Create(aOwner: TObject);
begin
 inherited;
 f_CHP:= TddCharacterProperty.Create(nil);
 f_PAP:= TddParagraphProperty.Create(nil);
 f_Segments:= Tl3ProtoPersistentRefList.Make;
 f_SubList:= Tl3CBaseRefList.Make;
 f_RTFString:= Tl3String.Create;
 f_Text:= Tl3String.Create;
 {$IFDEF ExpandTabs}
 f_ExpandTabs:= True;
 f_FirstStep:= True;
 {$ELSE}
 f_ExpandTabs:= False;
 {$ENDIF}
 f_Inc := 0;
 f_Offset := 0;
end;

procedure TddTextParagraph.AddHyperlink(aText: AnsiString; aDocID, aSubID: Integer);
var
 l_Seg: TddTextSegment;
begin
 l_Seg:= TddTextSegment.Create;
 try
  l_Seg.AddTarget(aDocID, aSubID, CI_TOPIC);
  l_Seg.Start:= Succ(Text.Len);
  AddText(aText);
  l_Seg.Stop:= Succ(Text.Len);//l_Seg.Start + Pred(Length(aText));
  l_Seg.SegmentType := dd_segHLink;
  AddSegment(l_Seg);
 finally
  FreeAndNil(l_Seg);
 end;
end;

procedure TddTextParagraph.AddListIndex(aList: TrtfList; aLite: Boolean);
var
 i, l_CurLevel, l_Count: Integer;
 l_Seg: TddTextSegment;
 l_LevelText: AnsiString;
 l_LevelIndexStr: array[0..8] of String;
 l_Index: Integer;
begin
 if aList <> nil then
 begin
  for i:= 0 to 8 do
   l_LevelIndexStr[i]:= '';
  l_Count:= 0;

  for i:= 1 to Length(aList.Levels[PAP.iLvl].Numbers) do
  begin
   if aList.Levels[PAP.iLvl].Numbers[i] < #9 then
   begin
    l_CurLevel:= ord(aList.Levels[PAP.iLvl].Numbers[i]);
    if l_CurLevel <> PAP.iLvl then
     l_Index:= aList.Levels[l_CurLevel].CurNumber
    else
     l_Index:= aList.Levels[l_CurLevel].NextNumber;

    case aList.Levels[l_CurLevel].levelnfc of
     0:	l_LevelIndexStr[l_Count]:= IntToStr(l_Index); //Arabic (1, 2, 3)
     1:	l_LevelIndexStr[l_Count]:= l3IntToRoman(l_Index);//Uppercase Roman numeral (I, II, III)
     2:	l_LevelIndexStr[l_Count]:= LowerCase(l3IntToRoman(l_Index));//Lowercase Roman numeral (i, ii, iii)
     3:	l_LevelIndexStr[l_Count]:= Chr(Pred(Ord('A'))+l_Index);//Uppercase letter (A, B, C)
     4:	l_LevelIndexStr[l_Count]:= Chr(Pred(Ord('a'))+l_Index);//Lowercase letter (a, b, c)
     5:	l_LevelIndexStr[l_Count]:= Format('%d-й', [l_Index]);//Ordinal number (1st, 2nd, 3rd)
     6:	l_LevelIndexStr[l_Count]:= IntToStr(l_Index);//Cardinal text number (One, Two Three)
     7:	l_LevelIndexStr[l_Count]:= IntToStr(l_Index);//Ordinal text number (First, Second, Third)
    (*
     10	Kanji numbering without the digit character (DBNUM1)
     11	Kanji numbering with the digit character (DBNUM2)
     12	46 phonetic katakana characters in "aiueo" order (AIUEO) (newer form - "????????" based on phonem matrix)
     13	46 phonetic katakana characters in "iroha" order (IROHA) (old form - "???????????????" based on haiku from long ago)
     14	Double-byte character
     15	Single-byte character
     16	Kanji numbering 3 (DBNUM3)
     17	Kanji numbering 4 (DBNUM4)
     18	Circle numbering (CIRCLENUM)
     19	Double-byte Arabic numbering
     20	46 phonetic double-byte katakana characters (AIUEO DBCHAR)
     21	46 phonetic double-byte katakana characters (IROHA DBCHAR)
     *)
     22:	l_LevelIndexStr[l_Count]:= Format('%.2d', [l_Index]); //Arabic with leading zero (01, 02, 03, ..., 10, 11)
     23: l_LevelIndexStr[l_Count]:= '-'; //	Bullet (no number at all)
     (*
     24	Korean numbering 2 (GANADA)
     25	Korean numbering 1 (CHOSUNG)
     26	Chinese numbering 1 (GB1)
     27	Chinese numbering 2 (GB2)
     28	Chinese numbering 3 (GB3)
     29	Chinese numbering 4 (GB4)
     30	Chinese Zodiac numbering 1 (ZODIAC1)
     31	Chinese Zodiac numbering 2 (ZODIAC2)
     32	Chinese Zodiac numbering 3 (ZODIAC3)
     33	Taiwanese double-byte numbering 1
     34	Taiwanese double-byte numbering 2
     35	Taiwanese double-byte numbering 3
     36	Taiwanese double-byte numbering 4
     37	Chinese double-byte numbering 1
     38	Chinese double-byte numbering 2
     39	Chinese double-byte numbering 3
     40	Chinese double-byte numbering 4
     41	Korean double-byte numbering 1
     42	Korean double-byte numbering 2
     43	Korean double-byte numbering 3
     44	Korean double-byte numbering 4
     45	Hebrew non-standard decimal
     46	Arabic Alif Ba Tah
     47	Hebrew Biblical standard
     48	Arabic Abjad style
     49	Hindi vowels
     50	Hindi consonants
     51	Hindi numbers
     52	Hindi descriptive (cardinals)
     53	Thai letters
     54	Thai numbers
     55	Thai descriptive (cardinals)
     56	Vietnamese descriptive (cardinals)
     57	Page number format - # -
     *)
     58: l_LevelIndexStr[l_Count]:= Chr(Pred(Ord('а'))+l_Index);//Lower case Russian alphabet
     59: l_LevelIndexStr[l_Count]:= Chr(Pred(Ord('А'))+l_Index);//Upper case Russian alphabet
     (*
     60	Lower case Greek numerals (alphabet based)
     61	Upper case Greek numerals (alphabet based)
     *)
     62:	l_LevelIndexStr[l_Count]:= Format('%.3d', [l_Index]);// 2 leading zeros: 001, 002, ..., 100, ...
     63:	l_LevelIndexStr[l_Count]:= Format('%.4d', [l_Index]);//3 leading zeros: 0001, 0002, ..., 1000, ...
     64:	l_LevelIndexStr[l_Count]:= Format('%.5d', [l_Index]);//4 leading zeros: 00001, 00002, ..., 10000, ...
     (*
     65	Lower case Turkish alphabet
     66	Upper case Turkish alphabet
     67	Lower case Bulgarian alphabet
     68	Upper case Bulgarian alphabet
     *)
     255:	l_LevelIndexStr[l_Count]:= '';
    end; // case
    Inc(l_Count);
   end; // AnsiChar < #9
  end; // for i

  case l_Count of
   0:
   if aList.Levels[0].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0]])
   else
    l_LevelText:= l_LevelIndexStr[0];
   1:
   if aList.Levels[PAP.ilvl].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0], l_LevelIndexStr[1]])
   else
    l_LevelText:= l_LevelIndexStr[1];
   2:
   if aList.Levels[PAP.ilvl].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0], l_LevelIndexStr[1], l_LevelIndexStr[2]])
   else
    l_LevelText:= l_LevelIndexStr[2];
   3:
   if aList.Levels[PAP.ilvl].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0], l_LevelIndexStr[1], l_LevelIndexStr[2]])
   else
    l_LevelText:= l_LevelIndexStr[3];
   4:
   if aList.Levels[PAP.ilvl].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0], l_LevelIndexStr[1], l_LevelIndexStr[2]])
   else
    l_LevelText:= l_LevelIndexStr[4];
   5:
   if aList.Levels[PAP.ilvl].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0], l_LevelIndexStr[1], l_LevelIndexStr[2]])
   else
    l_LevelText:= l_LevelIndexStr[5];
   6:
   if aList.Levels[PAP.ilvl].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0], l_LevelIndexStr[1], l_LevelIndexStr[2]])
   else
    l_LevelText:= l_LevelIndexStr[6];
   7:
   if aList.Levels[PAP.ilvl].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0], l_LevelIndexStr[1], l_LevelIndexStr[2]])
   else
    l_LevelText:= l_LevelIndexStr[7];
   8:
   if aList.Levels[PAP.ilvl].Text <> '' then
    l_LevelText:= Format(aList.Levels[PAP.ilvl].Text, [l_LevelIndexStr[0], l_LevelIndexStr[1], l_LevelIndexStr[2]])
   else
    l_LevelText:= l_LevelIndexStr[8];
  end;

   if aLite then
    l_LevelText:= l_LevelText + cc_HardSpace
   else
    case aList.Levels[PAP.ilvl].Follow of
     0: l_LevelText:= l_LevelText + cc_Tab;
     1: l_LevelText:= l_LevelText + cc_HardSpace;
    end;
   Text.AsString:= l_LevelText + Text.AsString;
  l_Seg:= TddTextSegment.Create;
  try
   l_Seg.CHP.Assign(aList.Levels[PAP.ilvl].CHP);
   l_Seg.Start:= 1;
   l_Seg.Stop:= Length(l_LevelText);
   SegmentList.Insert(0, l_Seg);
   for i:= 1 to SegmentList.Hi do
   begin
    Segments[i].Start:= Segments[i].Start + l_Seg.Stop;
    Segments[i].Stop:= Segments[i].Stop + l_Seg.Stop;
   end; // for i
  finally
   FreeAndNil(l_Seg);
  end;
 end; // List <> nil;
end;

procedure TddTextParagraph.AddPicture(aPicture: TddPicture);
var
 l_Seg: TddTextSegment;
begin
 l_Seg:= TddTextSegment.Create;
 try
  l_Seg.SegmentType:= dd_segObject;
  l_Seg.ObjectType:= dd_sotPicture;
  l_Seg.Data:= aPicture;
  Text.Append('*');
  l_Seg.Start:= Text.Len;
  l_Seg.Stop:= Text.Len;
  AddSegment(l_Seg);
 finally
  FreeAndNil(l_Seg);
 end;
end;

procedure TddTextParagraph.AddSegment(aCHP: TddCharacterProperty; const
        RelativeToText: Boolean = False);
var
 l_S, l_S2: TddTextSegment;
 l_Diff: TddCharacterProperty;
begin
  if aCHP <> nil then
  begin
   l_Diff:= TddCharacterProperty(CHP.Diff(aCHP));
   try
    if (l_Diff <> nil){ and not l_Diff.IsDefault} then
    begin
     (*
     if RelativeToText and (Text.Len > 0) and (f_Segments.Count = 0) then
     begin
      l_S:= TddTextSegment.Create;
      try
       l_S.CHP:= CHP;
       l_S.Start:= 1;
       l_S.Stop:= Text.Len - l_S.Start;
       AddSegment(l_S);
      finally
       FreeAndNil(l_S);
      end;
     end; // RelativeToText and (Text.Len > 0) and (f_Segments.Count = 0)
     *)
     l_S:= TddTextSegment.Create;
     try
      l_S.CHP:= aCHP;
      l_S.Start:= Text.Len+1;
      if HaveSegments then
      begin
       l_S2:= LastSegment;
       if (l_S2.CHP.OCompare(aCHP) <> 0) and (l_S2.Stop = 0) then
       begin
        l_S2.Stop:= Text.Len;
        AddSegment(l_S);
       end // l_S2.CHP.Compare(aCHP) <> 0
       else
        AddSegment(l_S);
      end
      else
       AddSegment(l_S);
     finally
      FreeAndNil(l_S);
     end; // l_S
    end; 
   finally
    FreeAndNil(l_Diff);
   end;
 end;  // aCHP <> nil
end;

procedure TddTextParagraph.AddSegment(aSegment: TddTextSegment);
begin
 aSegment.Index:= SegmentList.Add(aSegment);
end;

procedure TddTextParagraph.AddSub(aSubID: Integer; aName: AnsiString; aIsRealName: Boolean = True);
var
 l_Sub: TddSub;
begin
 l_Sub:= TddSub.Create(nil);
 try
  l_Sub.ID:= aSubID;
  l_Sub.Name.AsString:= aName;
  l_Sub.IsRealName:= aIsRealName;
  f_SubList.Add(l_Sub);
 finally
  FreeAndNil(l_SuB);
 end;
end;

procedure TddTextParagraph.AddText(aText: AnsiChar; const aCodePage: Long =
        CP_ANSI);
begin
  f_Text.Append(aText, 1, aCodePage);
end;

procedure TddTextParagraph.AddText(aText: AnsiString; const aCodePage: Long =
        CP_ANSI);
begin
  if aText <> '' then
   f_Text.Append(l3PCharLen(aText, aCodePage));
end;

function TddTextParagraph.GetEmpty: Boolean;
begin
 Result:= not l3CharSetPresent(Text.st, Text.Len, [#0..#255]-[#32]);
end;

procedure TddTextParagraph.AddText(aText: Tl3String);
begin
  if not aText.Empty then
  begin
   f_Text.JoinWith(aText);
   if HaveSegments and (LastSegment.Stop = 0) then
    LastSegment.Stop:= Text.Len;
  end;
end;

function TddTextParagraph.AnySegmentByCharIndex(Index: Longint; const
        EndSegment: Boolean = False): TddTextSegment;
var
  Seg: TddTextSegment;
  i: Integer;
begin
  Result:= nil;
  for i:= 0 to Pred(SegmentList.Count) do
  begin
   Seg:= Segments[i];
   if EndSegment then
   begin
    if Seg.Stop = Index then
    begin
     Result:= Seg;
     break;
    end
   end
   else
   begin
    if (Seg.Start = Index) and (Seg.Stop >= Seg.Start)
      {and (Seg.Stop <= Text.Len)} then
     begin
      Result:= Seg;
      break;
     end;
   end
  end; // for i
end;

procedure TddTextParagraph.ApplyCHP(aCHP: TddCharacterProperty);
var
 l_Seg: TddTextSegment;
begin
 if aCHP <> nil then
 begin
  if CHP.IsDefault and not aCHP.IsDefault then
  begin
     if HaveSegments then
      begin
       l_Seg:= TddTextSegment(f_Segments.Items[f_Segments.Hi]);
       l_Seg.CHP.JoinWith(aCHP);
      end
     else
      if CHP.IsDefault then
       CHP.Assign{JoinWith}(aCHP);
  end; // CHP.IsDefault and not aCHP.IsDefault
 end; // aCHP <> nil
end;

procedure TddTextParagraph.ApplyPAP(aPAP: TddParagraphProperty);
begin
 if aPAP <> nil then
 begin
  if PAP.IsDefault and not aPAP.IsDefault then
   PAP:= aPAP;
 end;
end;

procedure TddTextParagraph.Assign(P: TPersistent);
var
  l_Par: TddTextParagraph absolute P;
begin
  if P is TddTextParagraph then
  begin
   f_CHP.Assign(l_Par.CHP);
   f_PAP.Assign(l_Par.PAP);
   f_ID:= l_Par.ID;
   f_Segments.Assign(l_par.SegmentList);
   f_SubList.Assign(l_Par.SubList);
   f_Text.Assign(l_Par._Text);
   f_RTFString.Assign(l_Par.RTFString);
  end
  else
   inherited;
end;

function TddTextParagraph.CheckInTable(const Generator: Ik2TagGenerator; const LiteVersion: Boolean = False): Boolean;
begin
 Result:= False;
 if PAP.InTable then
 begin
  Generator.AddIntegerAtom(k2_tiStyle, ev_saNormalTable);
  if LiteVersion then
   case PAP.Just of
    justR: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itRight));
    justC: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itCenter));
    justF: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itWidth));
   else
    Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itLeft));
   end; { case Just}
  Result:= True;
 end // InTable
 else // Проверяем наличие псевдографики в тексте абзаца
 begin
  if ((Text.CodePage = cp_OEM) or (Text.CodePage = cp_OEMLite)) and
     l3CharSetPresent(Text.st, Text.Len, cc_Graph_Criteria) then
  begin
   Generator.AddIntegerAtom(k2_tiStyle, ev_saTxtNormalOEM);
   Result:= True;
  end; // if...
 end; // not InTable;
end;

function TddTextParagraph.CheckSegments: Boolean;
var
  l_CHP: TddCharacterProperty;
  l_Seg: TddTextSegment;
  j: Integer;
begin
  Result:= False;
  for j:= 0 to SegmentList.Hi do
  begin
   l_Seg:= Segments[j];
   begin
    if l_Seg.IsHyperLink or (l_Seg.SegmentType = dd_segObject) then
    begin
     Result:= True;
     break;
    end // l_Seg.IsHyperLink
    else
    begin
     l_CHP:= TddCharacterProperty(CHP.Diff(l_SeG.CHP));
     try
      if ((l_CHP <> nil) or (l_Seg.CHP.Style < 0)) then
      begin
       FreeAndNil(l_CHP);
       Result:= True;
       break;
      end; // ((l_CHP <> nil) or (l_Seg.CHP.Style < 0)) and not L_S.Empty
     finally
      FreeAndNil(l_CHP);
     end; // l_CHP
    end; // not l_Seg.IsHyperLink
   end; // l_Seg.SegmentType <> dd_segObject
  end; // for j
end;

procedure TddTextParagraph.CorrectSegments(aPrevPara: TddTextParagraph);
var
  i, j: Integer;
  l_HL, l_Seg: TddTextSegment;
begin
  if (Text.Len > 0) and (SegmentList.Count > 0) then
  begin
   i:= 0;
   while i < SegmentCount do
   begin
    l_Seg:= Segments[i];
    if (l_Seg.Start > l_Seg.Stop) then
     SegmentList.Delete(i)
    else
    begin
     if (l_Seg.CHP.Style = ev_saHyperLinkCont) and (aPrevPara <> nil) then
     begin
      for j:= 0 to aPrevPara.SegmentList.Hi do
      begin
       l_HL := TddTextSegment(aPrevPara.SegmentList.Items[j]);
       if l_HL.IsHyperlink and InRange(l_Seg.Start, l_HL.Start, l_HL.Stop) then
       begin
        if (l_HL <> nil) and (l_HL.TargetList.Count > 0) then
        begin
         l_Seg.Style := ev_saTxtNormalANSI;
         l_Seg.TargetList.Assign(l_HL.TargetList);
         l_Seg.IsHyperlink := True;
         l_Seg.stop := Min(Pred(Text.Len), l_Seg.stop);
        end
        else
        begin
         SegmentList.Delete(i);
         if i < SegmentCount then
          continue
         else
          break;
        end;
       end; // l_HL.IsHyperlink and InRange(l_Seg.Start, l_HL.Start, l_HL.Stop)
      end; // for j
     end;
     (* ???
     else
      if l_Seg.Stop > Pred(Text.Len) then
       l_Seg.Stop:= Pred(Text.Len);
     //if l_Seg.CHP.
     *)
     Inc(i);
    end;
   end; // while i
  end; // (Text.Len > 0) and (SegmentList.Count > 0)
end;

function TddTextParagraph.DeleteLastSegment: Boolean;
begin
  try
   f_Segments.Remove(LastSegment);
   Result:= True;
  except
   Result:= False;
  end;
end;

function TddTextParagraph.GetRTFString: Tl3String;
begin
  Result:= f_RTFString;
end;

function TddTextParagraph.GetSegmentCount: Integer;
begin
  Result:= SegmentList.Count;
end;

function TddTextParagraph.GetSegments(Index: Integer): TddTextSegment;
begin
  if (Index >=0) and (Index < f_Segments.Count) then
   Result:= TddTextSegment(f_Segments.Items[Index])
  else
   Result:= nil;
end;

function TddTextParagraph.GetText: Tl3String;
begin
  Result:= f_Text;
end;

function TddTextParagraph.HaveHyperlinks: Boolean;
var
  i: Integer;
begin
  Result:= False;
  for i:= 0 to SegmentList.Hi do
   if Segments[i].IsHyperlink then
   begin
    Result:= True;
    break;
   end; // Segments[i].IsHyperlink
end;

function TddTextParagraph.HaveSegments: Boolean;
var
  i: Integer;
begin
  Result:= False;
  for i:= 0 to SegmentList.Hi do
   if not Segments[i].IsHyperlink then
   begin
    Result:= True;
    break;
   end; // not Segments[i].IsHyperlink
end;

function TddTextParagraph.HyperlinkByCharIndex(Index: Longint; const
        EndSegment: Boolean = False): TddTextSegment;
var
  Seg: TddTextSegment;
  i: Integer;
begin
  Result:= nil;
  for i:= 0 to Pred(SegmentList.Count) do
  begin
   Seg:= Segments[i];
   if Seg.IsHyperLink then
   begin
    if EndSegment then
    begin
     if Seg.Stop = Index then
     begin
      Result:= Seg;
      break;
     end
    end
    else
    begin
     if (Seg.Start = Index) and (Seg.Stop >= Seg.Start)
       {and (Seg.Stop <= Text.Len)} then
      begin
       Result:= Seg;
       break;
      end;
    end
   end;
  end; // for i
end;

function TddTextParagraph.JoinWith(P: TObject; aCorrectSegment: Boolean = False): Long;
var
 i      : Integer;
 l_Prev : Integer;
 l_Seg  : TddTextSegment;
 l_Para : TddTextParagraph absolute P;
begin
 Result := 0;
 l_Prev := f_Inc;
 if P is TddTextParagraph then
 begin
  if not l_Para.Text.Empty then
   if (Text.Ch[Text.Len - 1] = '-') and (Text.Ch[Text.Len - 2] <> ' ') then
    Text.Delete(Text.Len - 1, 1)
   else
   if not Text.Empty and (Text.Last <> ' ') then
   begin
    Text.Append(' ');
    Inc(f_Inc);
   end;

  if l_Para.SegmentList.Count > 0 then
  begin
   for i := 0 to l_Para.SegmentList.Hi do
   begin
    l_Seg := l_Para.Segments[i];
    l_Seg.Start := l_Seg.Start + Text.Len;
    l_Seg.Stop := l_Seg.Stop + Text.Len;
    if aCorrectSegment then
    begin
     if f_Offset <= l_Seg.Start then
      l_Seg.Start := l_Seg.Start + l_Prev;
     if f_Offset <= l_Seg.Stop then
      l_Seg.Stop := l_Seg.Stop + l_Prev;
    end; // if aCorrectSegment then
    AddSegment(l_Seg);
   end; // for i
  end; // l_Para.SegmentList.Count > 0
  SubList.JoinWith(l_Para.SubList);
  Inc(f_Offset, l_Para.Text.Len);
  AddText(l_Para.Text);
 end; //P is TddTextParagraph
end;

function TddTextParagraph.LastSegment: TddTextSegment;
var
  i: Integer;
begin
  Result:= nil;
  i:= f_Segments.Hi;
  while (i <= f_Segments.Hi) and (i >= 0) do
  begin
   if Segments[i].IsHyperlink then
    Dec(i)
   else
   begin
    Result:= Segments[i];
    exit;
   end;
  end;
end;

procedure TddTextParagraph.PackSegments;
var
 i      : long;
 l_List : Tl3ProtoPersistentRefList;
 l_Seg, l_Last: TddTextsegment;
begin
   { Упаковка пустых сегментов }
  {$IFNDEF ExpandTabs}
  if f_Segments.Count > 0 then
  begin
   l_List:= Tl3ProtoPersistentRefList.Make;
   try
    for i:=0 to f_Segments.Hi do
    begin
     l_Seg:= Segments[i];
     if (l_Seg.SegmentType = dd_segText) and ((l_Seg.CHP.OCompare(CHP) <> 0) or not l_Seg.Empty) then
     begin
      if l_List.Empty then
       l_List.Add(l_Seg)
      else
      begin
       l_Last:= TddTextSegment(l_list.Last);
       if (l_Last.CHP.OCompare(l_Seg.CHP) = 0) and (l_Last.Stop = l_Seg.Start) then
        l_Last.Stop:= l_Seg.Stop
       else
        l_List.Add(l_Seg);
      end;
     end
     else
      l_List.Add(l_Seg);
    end;// for i
    f_Segments.Clear;
    if (l_List.Count = 1) and (TddTextSegment(l_List.First).Start = 1) then
    begin
     CHP.Assign(TddTextSegment(l_List.Items[0]).CHP);
    end
    else
    begin
     f_Segments.JoinWith(l_List);
    end;
   finally
    FreeAndNil(l_List);
   end; // l_List
  end;
  {$ENDIF}
end;

procedure TddTextParagraph.Cleanup;
begin
  FreeAndNil(f_Text);
  FreeAndNil(f_RTFString);
  FreeAndNil(f_CHP);
  FreeAndNil(f_PAP);
  FreeAndNil(f_segments);
  FreeAndNil(f_SubList);
  f_Inc := 0;
  f_Offset := 0;
  inherited;
end;

procedure TddTextParagraph.Clear;
begin
 f_text.Clear;
 f_CHP.Clear;
 f_PAP.Clear;
 f_Segments.Clear;
 f_SubList.Clear;
 f_Inc := 0;
 f_Offset := 0;
end;

function TddTextParagraph.HaveObjects: Boolean;
var
  i: Integer;
begin
  Result:= False;
  for i:= 0 to SegmentList.Hi do
   if Segments[i].SegmentType = dd_segObject then
   begin
    Result:= True;
    break;
   end; // Segments[i].IsHyperlink
end;

function TddTextParagraph.ObjectByCharIndex(Index: Longint; const EndSegment: Boolean = False): TddTextSegment;
var
  Seg: TddTextSegment;
  i: Integer;
begin
  Result:= nil;
  for i:= 0 to Pred(SegmentList.Count) do
  begin
   Seg:= Segments[i];
   if Seg.SegmentType = dd_segObject then
   begin
    if EndSegment then
    begin
     if Seg.Stop = Index then
     begin
      Result:= Seg;
      break;
     end
    end
    else
    begin
     if (Seg.Start = Index) and (Seg.Stop >= Seg.Start)
       {and (Seg.Stop <= Text.Len)} then
      begin
       Result:= Seg;
       break;
      end;
    end
   end;
  end; // for i
end;

function TddTextParagraph.PrevCHP(aCurSegment: TddTextSegment): TddCharacterProperty;
var
 l_Index: Integer;
begin
 l_Index:= SegmentList.IndexOf(aCurSegment);
 if l_Index > 0 then
  Result:= Segments[Pred(l_Index)].CHP
 else
  Result:= CHP;
end;

function TddTextParagraph.SegmentByCharIndex(Index: Longint; const EndSegment: Boolean = False;
    const StartIndex: Integer = -1): TddTextSegment;
var
  Seg: TddTextSegment;
  i: Integer;
begin
  Result:= nil;
  for i:= Succ(StartIndex) to Pred(SegmentList.Count) do
  begin
   Seg:= Segments[i];
   if (Seg.SegmentType <> dd_segObject) and not Seg.IsHyperLink then
   begin
    if EndSegment then
    begin
     if Seg.Stop = Index then
     begin
      Result:= Seg;
      break;
     end
    end
    else
    begin
     if (IfThen(Seg.Start < 0, 0, Seg.Start) = Index) and (Seg.Stop >= Seg.Start) then
      begin
       Result:= Seg;
       break;
      end;
    end
   end;
  end; // for i
end;

procedure TddTextParagraph.SetCHP(Value: TddCharacterProperty);
begin
  f_CHP.Assign(Value);
end;

procedure TddTextParagraph.SetPAP(Value: TddParagraphProperty);
begin
  f_PAP.Assign(Value);
end;

procedure TddTextParagraph.SetText(aTExt: Tl3String);
begin
  f_Text.Assign(aText);
end;

procedure TddTextParagraph.Write2Generator(const Generator: Ik2TagGenerator; const
        LiteVersion: Boolean = False);
var
  j, i: Integer;
  l_Seg: TddTextSegment;
  l_FontSize: Integer;
  l_CHP: TddCharacterProperty;
  l_Styled      : Boolean;
  l_NeedSegments: Boolean;
  l_CharSet     : Long;
  l_LogFont     : Tl3LogFont;
  l_W           : WideString;
begin
  l_Styled:= False;
  begin
   Generator.StartChild(k2_idTextPara);
   try
    if not LiteVersion then
     WriteTabStops(Generator);
    with PAP do
    begin
     l_Styled:= CheckInTable(Generator, LiteVersion);
     l_Styled:= WritePAP(Generator, LiteVersion, l_Styled);
     l_FontSize:= 1000;
     if not ExpandTabs then
     begin
      for j:= 0 to TabList.Hi do
      begin
      end // for j
     end
     else
     for j:= 0 to SegmentList.Hi do
     begin
      l_Seg:= Segments[j];
      if (l_SEg.CHP.FontSize <> propUndefined) and (l_Seg.CHP.FontSize < l_FontSize) then
       l_FontSize:= l_Seg.CHP.FontSize;
     end; // for j
     if not LiteVersion then
      Border.Write2Generator(Generator);
    end; //  with PAP

    { Выливка оформления }
    if not l_Styled and not LiteVersion and not CHP.IsDefault then
     CHP.Write2Generator(Generator)
    (*else
     if (CHP.FontCharSet <> RUSSIAN_CHARSET) {and not l3AllCharsInCharSet(Text.AsWStr, [#32..'z'])} then
     begin
      j:= 0;
      for i:= 0 to Text.Len-1 do
       if Text.Ch[i] in [#$00..#$7F] then
        Inc(j);
      SetLength(l_W, (Text.Len-j) div 2+j);
      MultiByteToWideChar(932, 0, Text.St, Text.Len, PWideChar(l_W), Length(l_W));
      Text.Len:= Length(l_W);
      WideCharToMultiByte(CP_RussianWin, 0, PWideChar(l_W), Length(l_W), Text.St, Text.Len, nil, nil);
     end*);

    WriteSubs(Generator);

    if CheckSegments then
    begin
     if HaveHyperlinks or (not LiteVersion and not ((CHP.Style <0) and (SegmentList.Count > 0))) then
     begin
      WriteHyperlinks(Generator);
      WriteSegments(Generator);
     end
     else // Lite
     begin
      l_NeedSegments:= False;
      for j:= 0 to SegmentList.Hi do
      begin
       if ((Segments[j].CHP.Style <> 0) and (Segments[j].CHP.Style <> propUndefined)) or (Segments[j].SegmentType = dd_segObject) then
       begin
        l_NeedSegments:= True;
        break;
       end;
      end;

      if l_NeedSegments then
      begin
       Generator.StartTag(k2_tiSegments);
       try
        Generator.StartChild(k2_idSegmentsLayer);
        try
         Generator.AddIntegerAtom(k2_tiHandle, ev_slView);
         for j:= 0 to SegmentList.Hi do
         begin
          l_Seg:= Segments[j];
          if not l_Seg.CHP.Hidden then
          begin
           if ((l_Seg.CHP.Style <> 0) and (l_Seg.CHP.Style <> propUndefined)) or (l_Seg.SegmentType = dd_segObject) then
           begin
            if l_Seg.SegmentType = dd_segObject then
             Generator.StartChild(k2_idObjectSegment)
            else
             Generator.StartChild(k2_idTextSegment);
            try
             Generator.AddIntegerAtom(k2_tiStart, l_Seg.Start);
             Generator.AddIntegerAtom(k2_tiFinish, l_Seg.Stop);
             if (l_Seg.CHP.Style <> 0) and (l_Seg.CHP.Style <> propUndefined) then
              Generator.AddIntegerAtom(k2_tiStyle, l_Seg.CHP.Style);
             if (l_Seg.SegmentType = dd_segObject) then
              l_Seg.Data.Write2Generator(Generator, LiteVersion);
            finally
             Generator.Finish;
            end; // k2_idTextSegment
           end; // l_Seg.CHP.Style <> 0
          end; // not l_Seg.CHP.Hidden
         end; // for j
        finally
         Generator.Finish;
        end; // k2_idSegmentsLayer
       finally
        Generator.Finish;
       end; // k2_tiSegments
      end // l_NeedSegments
      else
       for j:= SegmentList.Hi downto 0 do
       begin
        if Segments[j].CHP.Hidden then
        begin
         { Видимо, вырезать скрытый текст }
         Text.Delete(Pred(Segments[j].Start), Succ(Segments[j].Stop-Segments[j].Start));
        end; // not Segments[j].CHP.Hidden
       end; // for j
      end;
      Generator.AddStringAtom(k2_tiText, Text);
     end
     else  // not CheckSegments
     begin
       if (CHP.Style < 0) and not Text.Empty then
       begin
        Generator.StartTag(k2_tiSegments);
        try
         Generator.StartChild(k2_idSegmentsLayer);
         try
          Generator.AddIntegerAtom(k2_tiHandle, ev_slView);
          Generator.StartChild(k2_idTextSegment);
          try
           Generator.AddIntegerAtom(k2_tiStart, 0);
           Generator.AddIntegerAtom(k2_tiFinish, Text.Len);
           Generator.AddIntegerAtom(k2_tiStyle, CHP.Style);
          finally
           Generator.Finish;
          end; // k2_idTextSegment
         finally
           Generator.Finish;
         end; // k2_idSegmentsLayer
        finally
         Generator.Finish;
        end; // k2_tiSegments
       end; // CHP.Style < 0
        Generator.AddStringAtom(k2_tiText, Text);
      end;
   finally
     Generator.Finish;
   end;
  end;
end;

procedure TddTextParagraph.WriteHyperlinks(const Generator: Ik2TagGenerator);
var
 j: Integer;
 i: Integer;
 l_Seg: TddTextSegment;
begin
 if HaveHyperlinks then
 begin
  Generator.StartTag(k2_tiSegments);
  try
   Generator.StartChild(k2_idSegmentsLayer);
   try
    Generator.AddIntegerAtom(k2_tiHandle, ev_slHyperlinks);
    for i:= 0 to SegmentList.Hi do
    begin
     l_Seg:= Segments[i];
     if l_Seg.IsHyperlink then
     begin
      Generator.StartChild(k2_idHyperlink);
      try
       Generator.AddIntegerAtom(k2_tiStart, l_Seg.Start);
       Generator.AddIntegerAtom(k2_tiFinish, Min(l_Seg.Stop, Text.Len));
       if l_Seg.HLHandle <> -1 then
        Generator.AddIntegerAtom(k2_tiHandle, l_Seg.HLHandle);
       for j:= 0 to l_Seg.TargetList.Hi do
       begin
        Generator.StartChild(k2_idAddress);
        try
         Generator.AddIntegerAtom(k2_tiDocID,
                      TddHyperlinkTarget(l_Seg.TargetList.Items[j]).DocID);
         if TddHyperlinkTarget(l_Seg.TargetList.Items[j]).SubID <> 0 then
          Generator.AddIntegerAtom(k2_tiSubID,
                       TddHyperlinkTarget(l_Seg.TargetList.Items[j]).SubID);
        finally
         Generator.Finish;
        end; // idAddress
       end; // for j
      finally
       Generator.Finish;
      end; // idHyperlink
     end; // l_Seg.IsHyperlink
    end; // for i
   finally
    Generator.Finish;
   end; // k2_idSegmentsLayer
  finally
   Generator.Finish;
  end; //k2_tiSegments
 end; // HaveHyperlinks;
end;

function TddTextParagraph.WritePAP(const Generator: Ik2TagGenerator; LiteVersion, aStyled: Boolean): Boolean;
begin
 Result:= False;
 with PAP do
 begin
  if not aStyled and (Style < 0) then
  begin
   if Style < -1 then
    Generator.AddIntegerAtom(k2_tiStyle, Style);
   Result:= True;
  end(*
  else
  if (SegmentList.Count = 0) and (System.Pos('Courier', CHP.FontName) <> 0) and not Empty then
  begin
   Generator.AddIntegerAtom(k2_tiStyle, ev_saANSIDOS);
   Result:= True;
  end *)
  else
  if (ListItem <> propUndefined) or (not LiteVersion and not PAP.IsDefault) then
  begin
   if xaLeft <> propUndefined then
    Generator.AddIntegerAtom(k2_tiLeftIndent, xaLeft);
   if (xaFirst <> propUndefined) and (xaLeft <> propUndefined) then
    Generator.AddIntegerAtom(k2_tiFirstIndent, xaFirst + xaLeft);
   if xaFirst <> propUndefined then
    Generator.AddIntegerAtom(k2_tiFirstLineIndent, xaFirst);
   if xaRight <> propUndefined then
    Generator.AddIntegerAtom(k2_tiRightIndent, xaRight);
   if Before <> propUndefined then
    Generator.AddIntegerAtom(k2_tiSpaceBefore, Before);
   if After <> propUndefined then
    Generator.AddIntegerAtom(k2_tiSpaceAfter, After);
   case Just of
    justR: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itRight));
    justC: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itCenter));
    justF: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itWidth));
   else
    Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itLeft));
   end; { case Just}
  end; // not LiteVersion and not IsDefault;
 end;
end;

procedure TddTextParagraph.WriteSegments(const Generator: Ik2TagGenerator);
var
 j: Integer;
 l_Seg: TddTextSegment;
 l_CHP: TddCharacterProperty;
 l_CharSet: Long;
 l_LogFont: Tl3LogFont;
begin
 if HaveSegments then
 begin
  Generator.StartTag(k2_tiSegments);
  try
   Generator.StartChild(k2_idSegmentsLayer);
   try
    Generator.AddIntegerAtom(k2_tiHandle, ev_slView);
    for j:= 0 to SegmentList.Hi do
    begin { Выливка оформления сегментов }
     l_Seg:= Segments[j];
     if not l_Seg.IsHyperlink then
     begin
      l_CHP:= TddCharacterProperty(CHP.Diff(l_SeG.CHP));
      if ((l_Seg.CHP.Style <> 0) and (l_Seg.CHP.Style <> propUndefined)) or (l_CHP <> nil) then
      begin
       Generator.StartChild(k2_idTextSegment);
       try
        Generator.AddIntegerAtom(k2_tiStart, l_Seg.Start);
        Generator.AddIntegerAtom(k2_tiFinish, Min(l_Seg.Stop, Text.Len));
        if ((l_Seg.CHP.Style <> 0) and (l_Seg.CHP.Style <> propUndefined))  then
         Generator.AddIntegerAtom(k2_tiStyle, l_Seg.CHP.Style)
        else
        begin
         if l_CHP <> nil then
         begin
          if l_CHP.Hidden then
           Generator.AddBoolAtom(k2_tiVisible, ByteBool(False));
          Generator.StartTag(k2_tiFont);
          try
           { here font properties }
           with l_CHP do
           begin { Вываливаем шрифтовое оформление }
            if Bold then
             Generator.AddBoolAtom(k2_tiBold, ByteBool(Bold))
            else
             if Self.CHP.Bold then
              Generator.AddBoolAtom(k2_tiBold, ByteBool(Bold));
            if Italic then
             Generator.AddBoolAtom(k2_tiItalic, ByteBool(Italic))
            else
             if Self.CHP.Italic then
              Generator.AddBoolAtom(k2_tiItalic, ByteBool(Italic));
            if Strikeout then
             Generator.AddBoolAtom(k2_tiStrikeout, ByteBool(Strikeout))
            else
             if Self.CHP.Strikeout then
              Generator.AddBoolAtom(k2_tiStrikeout, ByteBool(Strikeout));
            if (FontName <> '') and (FontNumber > -1) then
            begin
             if (Language = langRussian) and
                ((Length(FontName) < 4) OR
                 (l3Compare(PAnsiChar(FontName)+Length(FontName)-4,
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
             Generator.AddStringAtom(k2_tiName, FontName);
            end; // FontNumber > -1
            if (FontSize <> propUndefined) and (FontSize <> CHP.FontSize) then
             Generator.AddIntegerAtom(k2_tiSize, FontSize div 2);
            if (fColor <> propUndefined) and (CHP.fColor <> fColor) then
             Generator.AddIntegerAtom(k2_tiForeColor, FColor);
            if (bColor <> propUndefined) and (CHP.bColor <> bColor) then
             Generator.AddIntegerAtom(k2_tiBackColor, BColor);
            if (Highlight <> propUndefined) and (CHP.Highlight <> Highlight) then
             Generator.AddIntegerAtom(k2_tiBackColor, Highlight);
            case Pos of
             cpSuperScript: Generator.AddIntegerAtom(k2_tiIndex,
                                                     ord(l3_fiSuper));
             cpSubScript: Generator.AddIntegerAtom(k2_tiIndex,
                                                   ord(l3_fiSub));
            end;
            if (Underline <> CHP.Underline) then
             Generator.AddBoolAtom(k2_tiUnderline,
                                   (Underline <> utNone) and
                                   (Underline <> utNotDefined));
           end; // with l_CHP
          finally
           Generator.Finish; { font }
          end; // k2_tiFont
         end; // l_CHP <> nil
        end; { Style = 0}
       finally
        Generator.Finish; { Segment }
       end; // k2_idTextSegment
      end; // (l_Seg.CHP.Style <> 0) or (l_CHP <> nil)
      FreeAndNil(l_CHP);
     end; // not l_Seg.IsHyperlink and l_Seg.Len > 0
    end; // for j
   finally
    Generator.Finish;
   end; // k2_idSegmentsLayer
  finally
   Generator.Finish;
  end; // k2_tiSegments
 end; // HaveSegments;
end;

procedure TddTextParagraph.WriteSubs(const aGenerator: Ik2TagGenerator);
var
  l_Sub: TddSub;
  i: Integer;
begin
  if SubList.Count > 0 then
  begin
   aGenerator.StartTag(k2_tiSubs);
   try
     aGenerator.StartChild(k2_idSubLayer);
     try
       aGenerator.AddIntegerAtom(k2_tiHandle, ev_sbtSub);
  
       for i:= 0 to SubList.Hi do
       begin
        l_Sub:= TddSub(SubList.Items[i]);

        aGenerator.StartChild(k2_idSub);
        try
         aGenerator.AddIntegerAtom(k2_tiHandle, l_Sub.ID);
  
         if not l_Sub.Name.Empty then
         begin
           if l_Sub.IsRealName then
             aGenerator.AddStringAtom(k2_tiShortName, l_Sub.Name)
           else
             aGenerator.AddStringAtom(k2_tiName, l_Sub.Name)
         end; // not l_Sub.Name.Empty
        finally
         aGenerator.Finish;
        end; { SUB }
       end; { for i }
     finally
      aGenerator.Finish;
     end; { SubLayer }
   finally
     aGenerator.Finish;
   end; { Subs }
  end; // SubList.Count > 0
end;

procedure TddTextParagraph.WriteTabStops(const Generator: Ik2TagGenerator);
var
 i: Integer;
begin
 with PAP do
 begin
  if TabList.Count > 0 then
  begin
   Generator.StartTag(k2_tiTabStops);
   try
    for i:= 0 to Pred(TabList.Count) do
    begin
     Generator.StartChild(k2_idTabStop);
     try
     // перерасчитать размеры позиции
      if TddTab(Tablist.Items[i]).TabBar <> 0 then
       Generator.AddIntegerAtom(k2_tiStart, TddTab(Tablist.Items[i]).TabBar)
      else
       Generator.AddIntegerAtom(k2_tiStart, TddTab(Tablist.Items[i]).TabPos);
      case TddTab(Tablist.Items[i]).Kind of
       tkLeft: Generator.AddIntegerAtom(k2_tiType, Ord(l3_tssLeft));
       tkRight: Generator.AddIntegerAtom(k2_tiType, Ord(l3_tssRight));
       tkCentered: Generator.AddIntegerAtom(k2_tiType, Ord(l3_tssCenter));
       tkDecimal: Generator.AddIntegerAtom(k2_tiType, Ord(l3_tssDecimal));
      else
       Generator.AddIntegerAtom(k2_tiType, Ord(l3_tssLine));
      end;
      case TddTab(Tablist.Items[i]).TabLead of
       tlDots: Generator.AddStringAtom(k2_tiText, '.');
       tlMiddleDots : Generator.AddStringAtom(k2_tiText, cc_HardSpaceSymbol);
       tlHyphens    : Generator.AddStringAtom(k2_tiText, '-');
       tlUnderline  : Generator.AddStringAtom(k2_tiText, '_');
       tlThickLine  : Generator.AddStringAtom(k2_tiText, '_');
       tlEqualSign  : Generator.AddStringAtom(k2_tiText, '=');
      end;
     finally
      Generator.Finish;
     end;
    end;
   finally
    Generator.Finish;
   end;
  end; // TabList.Count > 0;
 end;
end;

{
********************************** TddPicture **********************************
}
constructor TddPicture.Create(aOwner: TObject);
begin
  inherited;
  AtomType:= dd_docPicture;
  f_Picture:= Tl3String.Create;
  f_Format:= -1;
  f_Stream:= Tl3MemoryStream.Make;
  f_Binary:= False;
  f_ScaleX:= 100;
  f_ScaleY:= 100;
end;

procedure TddPicture.Assign(P: TPersistent);
var
 l_Count: Integer;
begin
  if P is TddPicture then
  begin
   if TddPicture(P).Picture.Empty then
   begin
    l_Count:= f_Stream.CopyFrom(TddPicture(P).Stream, 0);
    f_Stream.Seek(0, 0);
   end
   else
    f_Picture.Assign(TddPicture(P).Picture);
   f_Format  := TddPicture(P).Format;
   f_Height  := TddPicture(P).Height;
   f_Width   := TddPicture(P).Width;
   f_ScaleX  := TddPicture(P).ScaleX;
   f_ScaleY  := TddPicture(P).ScaleY;
   f_GoalX   := TddPicture(P).GoalX;
   f_GoalY   := TddPicture(P).GoalY;
   f_BPP     := TddPicture(P).BPP;
   f_CropL   := TddPicture(P).CropL;
   f_CropR   := TddPicture(P).CropR;
   f_CropT   := TddPicture(P).CropT;
   f_CropB   := TddPicture(P).CropB;
  end
  else
   inherited;
end;

procedure TddPicture.ConvertToBin;
var
  l_Buf: PAnsiChar;
begin
 if not f_Picture.Empty then
 begin
  l3System.GetLocalMem(l_Buf, f_Picture.Len*2+1);
  try
   l3FillChar(l_Buf^, f_Picture.Len*2+1, 0);
   HexToBin(f_Picture.St, l_Buf, f_Picture.Len*2+1);
   f_Stream.Write(l_Buf^, f_Picture.Len*2+1);
   f_Stream.Seek(0, soBeginning);
  finally
   l3System.FreeLocalMem(l_Buf);
  end;
  f_Picture.Clear;
 end;
 f_Binary:= True;
end;

procedure TddPicture.ConvertToHex;
  
  const
    l_EOL : PAnsiChar = cc_EOL;
  var
    l_Bin       : array [0..8 * 1024 - 1] of AnsiChar;
    l_Hex       : array [0..8 * 1024 * 2 - 1] of AnsiChar;
    l_BinStream : TStream;
    l_HexStream : Tl3StringStream;
    Count       : Longint;
  
begin
 if f_Stream.Size > 0 then
 begin
  l_HexStream := Tl3StringStream.Create(f_Picture);
  try
   f_Stream.Seek(0, 0);
   l_BinStream := f_Stream;
   while true do begin
    Count := l_BinStream.Read(l_Bin, SizeOf(l_Bin));
    if (Count = 0) then break;
    BinToHex(l_Bin, l_Hex, Count);
    l_HexStream.Write(l_Hex, Count * 2);
   end;//while true
  finally
   FreeAndNil(l_HexStream);
  end;//try..finally
 end;
 f_Binary:= False;
end;

function TddPicture.GetFormat: Integer;
var
 l_Format: Integer;
 l_Detector: TImageEnIO;
begin
  if f_Format = -1 then
  begin
   if f_Stream.Size > 1 then
   begin
    f_Stream.Seek(0, 0);
    l_Detector:= TImageEnIO.Create(nil);
    try
     l_Detector.LoadFromStream(Stream);
     f_Format:= l_Detector.Params.FileType;
     if f_Format <> ioUnknown then
     begin
      { нужно выставить значения ширины, высоты, цветности и т.д. }
      if f_Height = 0 then
       f_Height:= l_Detector.Params.Height;
      if f_Width = 0 then
       f_Width:= l_Detector.Params.Width;
      f_BPP:= l_Detector.Params.BitsPerSample;
     end; // l_Format <> ioUnknown
    finally
     FreeAndNil(l_Detector);
    end;
   end; // f_Stream.Size > 1
   f_Stream.Seek(0, 0);
  end;
  Result:= f_Format;
end;

function TddPicture.GetStream: TStream;
begin
  if not f_Binary then
   ConvertToBin;
  Result:= f_Stream;
end;

procedure TddPicture.Cleanup;
begin
  FreeAndNil(f_Picture);
  FreeAndNil(f_Stream);
  inherited;
end;

procedure TddPicture.SetBinary(Value: Boolean);
begin
  if Value <> f_Binary then
  begin
   f_Binary:= Value;
   if f_Binary then
    ConvertToBin
   else
    ConvertToHex;
  end;
end;

procedure TddPicture.AddHexStream(Value: TStream);
var
 l_Buffer: PAnsiChar;
 l_BinBuf: PAnsiChar;
 l_Size: Int64;
begin
 if not Text.Empty then
 begin
  l_Buffer:= Text.St;
  f_Stream.WriteBuffer(l_Buffer^, Text.Len);
  Text.Clear;
 end;
 Value.Seek(0, 0);
 f_Stream.CopyFrom(value, Value.Size);
 f_Stream.Seek(0 ,0);
 l_Size:= f_Stream.Size div 2;
 l3System.GetLocalMem(l_BinBuf, l_Size);
 try
  HexToBin(Tl3MemoryStream(f_Stream).MemoryPool.AsPointer, l_BinBuf, l_Size);
  f_Stream.Seek(0, 0);
  f_Stream.Size:= 0;
  f_Stream.Write(l_BinBuf^, l_Size);
 finally
  l3System.FreeLocalMem(l_BinBuf);
 end;
 f_Binary:= True;
end;

procedure TddPicture.Clear;
begin
 inherited;
 f_Picture.Clear;
 f_Stream.Seek(0, 0);
 f_Stream.Size:= 0;
 f_Format  := -1;
 f_Height  := 0;
 f_Width   := 0;
 f_ScaleX  := 100;
 f_ScaleY  := 100;
 f_GoalX   := 0;
 f_GoalY   := 0;
 f_BPP     := 0;
 f_CropL   := 0;
 f_CropR   := 0;
 f_CropT   := 0;
 f_CropB   := 0;
end;

procedure TddPicture.CropPicture;
var
 l_Pic: TImageEnView;
 x1, x2, y1, y2: Integer;
 l_DPIX, l_DPIY: Integer;
begin
 if (CropL <> 0) or (CropR <> 0) or (CropT <> 0) or (CropB <> 0) then
 begin
  l_Pic:= TImageEnView.Create(nil);
  try
   l_pic.IO.LoadFromStream(f_Stream);
   l_DPIX:= l_Pic.DpiX; l_DPIY:= l_Pic.DpiY;
   if l_Pic.DpiX > 96 then
    l_Pic.DpiX:= 96;
   if l_Pic.DpiY > 96 then
    l_Pic.DpiY:= 96;
   x1:= Twip2Pixel(CropL, l_PIC.DpiX);
   x2:= Twip2Pixel(CropR, l_PIC.DpiX);
   y1:= Twip2Pixel(CropT, l_PIC.DpiY);
   y2:= Twip2Pixel(CropB, l_PIC.DpiY);
   Height:= 0;
   Width:= 0;
   l_Pic.SelectionBase:= iesbBitmap;
   l_Pic.Select(x1, y1, l_Pic.IO.Params.Width-x2, l_Pic.IO.Params.Height-y2,iespReplace);
   l_Pic.Proc.CropSel;
   if l_Pic.IO.Params.DPI > 96 then
    l_Pic.IO.Params.DPI:= 96;
   f_Stream.Seek(0, 0);
   f_Stream.Size:= 0;
   l_Pic.IO.SaveToStreamPNG(f_Stream);
   f_Stream.Seek(0, 0);
  finally
   FreeAndNil(l_pic);
  end;
 end; // (CropL <> 0) or (CropR <> 0) or (CropT <> 0) or (CropB <> 0)
end;

procedure TddPicture.ScalePicture;
var
 l_Pic: TImageEnView;
 x1, x2, y1, y2: Integer;
 l_DPIX, l_DPIY: Integer;
begin
 if (ScaleX <> 100) or (ScaleY <> 100) then
 begin
  l_Pic:= TImageEnView.Create(nil);
  try
   l_pic.IO.LoadFromStream(f_Stream);
   l_DPIX:= l_Pic.DpiX; l_DPIY:= l_Pic.DpiY;
   (*
   if l_Pic.DpiX > 96 then
    l_Pic.DpiX:= 96;
   if l_Pic.DpiY > 96 then
    l_Pic.DpiY:= 96;
   *)
   l_Pic.ScaleBy(ScaleX, ScaleY);

   //Width:= l_Pic.Width;
   //Height:= l_Pic.Height;
   ScaleX:= 100; ScaleY:= 100;
   (*
   if l_Pic.IO.Params.DPI > 96 then
    l_Pic.IO.Params.DPI:= 96;
   *)
   f_Stream.Seek(0, 0);
   f_Stream.Size:= 0;
   l_Pic.IO.SaveToStreamPNG(f_Stream);
   f_Stream.Seek(0, 0);
  finally
   FreeAndNil(l_pic);
  end;
 end; // Scale X <> 100 or ScaleY <> 100
end;

procedure TddPicture.SetStream(Value: TStream);
begin
 f_Binary:= True;
 Value.Seek(0, 0);
 f_Stream.CopyFrom(value, Value.Size);
  f_Stream.Position:= 0;
end;

procedure TddPicture.Write2Generator(const Generator: Ik2TagGenerator; const
        LiteVersion: Boolean = False);
begin
 Generator.StartChild(k2_idBitmapPara);
 try
  Generator.AddIntegerAtom(k2_tiExternalHandle, ExternalHandle);
  Generator.AddStringAtom(k2_tiExternalpath, ExternalPath);

  CropPicture;

  //ScalePicture; 

  if Width <> 0 then
   Generator.AddIntegerAtom(k2_tiWidth, l3MulDiv(Width, ScaleX, 100));
  if Height <> 0 then
   Generator.AddIntegerAtom(k2_tiHeight, l3MulDiv(Height, ScaleY, 100));
  with PAP do
  begin
   case Just of
    justR: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itRight));
    justC: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itCenter));
    justF: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itWidth));
   else
    Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itLeft));
   end; { case Just}
   Border.Write2Generator(Generator);
  end; {  with }
  if not f_Binary then
   ConvertToBin;
  Generator.AddStreamAtom(k2_tiData, Stream);
 finally
  Generator.Finish;
 end;
end;

end.
