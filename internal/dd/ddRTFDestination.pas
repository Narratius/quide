unit ddRTFdestination;
{ $Id: ddRTFDestination.pas,v 1.22 2013/05/06 12:37:11 dinishev Exp $ }

// $Log: ddRTFDestination.pas,v $
// Revision 1.22  2013/05/06 12:37:11  dinishev
// Откатываем костыли и "рефакторинг" - отъехало чтение таблиц.
//
// Revision 1.21  2013/05/06 08:33:20  dinishev
// Убрал еще одно свойство.
//
// Revision 1.20  2013/05/06 08:08:55  dinishev
// Убрал еще одно свойство.
//
// Revision 1.19  2013/05/06 07:28:14  dinishev
// Мысли автора понять не смог - сделал свою интерпретацию.
//
// Revision 1.18  2013/05/06 06:45:44  dinishev
// Reformat.
//
// Revision 1.17  2013/05/06 06:45:02  dinishev
// Убираем ненужную переменную.
//
// Revision 1.16  2013/04/11 16:46:28  lulin
// - отлаживаем под XE3.
//
// Revision 1.15  2013/04/05 12:04:30  lulin
// - портируем.
//
// Revision 1.14  2013/04/03 09:34:33  narry
// Не проходили тесты
//
// Revision 1.13  2013/03/20 11:37:28  narry
// * не читались многоуровневые списки
//
// Revision 1.12  2013/02/14 10:51:03  narry
// Добавление картинки в текст
//
// Revision 1.11  2013/02/06 13:39:24  narry
// "Съедались" объединенные ячейки
//
// Revision 1.10  2013/02/06 09:41:56  narry
// Поддержка команды \brdrtbl
//
// Revision 1.9  2013/01/31 12:14:56  narry
// Обновление
//
// Revision 1.8  2013/01/31 07:07:13  narry
// Обновление
//
// Revision 1.7  2013/01/30 11:51:57  narry
// исправление непрошедших тестов Арчи
//
// Revision 1.6  2013/01/29 09:31:52  narry
// Лишний раз сбрасывался номер в списке
//
// Revision 1.5  2013/01/25 13:13:36  narry
// Не устанавливается шрифт по имени (424386600)
//
// Revision 1.4  2013/01/25 05:38:51  narry
// Заменять автонумерацию на фиксированную (407745210)
//
// Revision 1.3  2013/01/24 12:59:15  narry
// Заменять автонумерацию на фиксированную (407745210)
//
// Revision 1.2  2013/01/24 06:55:32  narry
// Поддержка нумерованных абзацев (пока не работает)
//
// Revision 1.1  2013/01/22 12:19:52  narry
// Рефакторинг RTFReader
//

interface

uses
  ddBase,
  RTFtypes,
  k2Prim, l3Memory, l3ProtoPersistentRefList,
  l3ProtoObject, l3Base, l3Types, l3ProtoObjectRefList, ddRTFProperties,
  Classes, l3ObjectRefList, l3StringList, ddRTFState, Graphics, rTfListTable,
  ddTableCell, ddTableRow, ddCharacterProperty, ddParagraphProperty,
  ddDocumentAtom, ddTextParagraph;

type
  TddRTFDestination = class(Tl3ProtoObject)
  private
    f_LiteVersion  : Boolean;
    f_RDS           : TRDS;
    f_SkipSkipable  : Boolean;
  protected
    procedure Cleanup; override;
  public
    constructor Create;
    procedure AddAnsiChar(aText: AnsiChar; aState: TddRTFState); virtual;
    procedure AddString(aText: Tl3String; aState: TddRTFState); virtual;
    procedure AddUnicodeChar(aText: Word; aState: TddRTFState); virtual;
    procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
        aState: TddRTFState); virtual;
    procedure Clear; virtual;
    procedure ParseSymbol(Symbol: Long; propType: TPropType; aState: TddRTFState);
        virtual;
    procedure write(aGenerator: Ik2TagGenerator); virtual;
    procedure WriteText(aText: Tl3String; aState: TddRTFState); virtual;
    property LiteVersion: Boolean
      read f_LiteVersion write f_LiteVersion;
    property RDS: TRDS
      read f_RDS write f_RDS;
    property SkipSkipable  : Boolean
      read f_SkipSkipable write f_SkipSkipable;
  end;

 TdestStyleSheet = class(TddRTFDestination)
 private
  FItems: TList;
  f_Styles: Tl3StringList;
  function GetCount: Integer;
  function pm_GetCurStyle: TddStyleEntry;
  function pm_GetItems(Index: Integer): TddStyleEntry;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure AddAnsiChar(aText: AnsiChar; aState: TddRTFState); override;
  procedure AddString(aText: Tl3String; aState: TddRTFState); override;
  procedure AddStyle;
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  function StyleByNumber(aNumber: Integer): TddStyleEntry;
  property Count: Integer read GetCount;
  property CurStyle: TddStyleEntry read pm_GetCurStyle;
  property Items[Index: Integer]: TddStyleEntry read pm_GetItems; default;
 end;

 TdestGetColorEvent = function (ColorIndex: Integer): TColor of object;
 TdestGetListEvent = function (aListID: Integer): TrtfList of object;
 TdestGetStyleEvent = function (aStyleID: Integer): TddStyleEntry of object;
 TdestGetFontEvent = function (aFontID: Integer): TddFontEntry of object;
 TdestNorm = class(TddRTFDestination)
 private
  f_BorderOwner: TddBorderOwner;
  f_CurBorderPart: TddBorderParts;
  f_CurCell: Integer;
  f_EnablePictures: Boolean;
  f_IsPicture: Boolean;
  f_OnGetColor: TdestGetColorEvent;
  f_OnGetFontEvent: TdestGetFontEvent;
  f_OnGetList: TdestGetListEvent;
  f_OnGetStyle: TdestGetStyleEvent;
  f_Paragraphs    : Tl3ProtoPersistentRefList;
  f_TabEntry: TddTab;
  f_TextBuffer: Tl3String;
  f_UnicodeBuffer: Tl3MemoryStream;
  function AddCell: TddTableCell;
  function AddRow: TddTableRow;
  procedure ApplyToCell(What: Tiprop; Value: Longint; aCEP: TddCellProperty);
  procedure ApplyToCHP(What: Tiprop; Value: Longint; aCHP: TddCharacterProperty);
  procedure ApplyToFrame(What: Tiprop; Value: Longint; aState: TddRTFState);
  procedure ApplyToPAP(What: Tiprop; Value: Longint; aPAP: TddParagraphProperty);
  procedure ApplyToRow(What: Tiprop; Value: Longint; aState: TddRTFState);
  procedure ApplyToSep(What: Tiprop; Value: Longint);
  procedure ApplyToStyle(What: Tiprop; Value: Longint; aState: TddRTFState);
  procedure ApplyToTAB(What: Tiprop; Value: Longint; aPAP: TddParagraphProperty);
  procedure CloneRow;
  procedure AddEmptyRow;
  procedure CheckListItem(aPara: TddTextParagraph);
  procedure ConvertSymbolChar(var aChar: AnsiChar; aCHP: TddCharacterProperty);
  procedure OpenNestedTable;
  function pm_GetLastAtom: TddDocumentAtom;
  function pm_GetLastCell: TddTableCell;
  function pm_GetLastParagraph: TddTextParagraph;
  function pm_GetLastRow: TddTableRow;
  procedure ProcessTableRow(aRow, aPrevRow: TddTableRow);
  procedure ProcessTextParagraph(aPara: TddTextParagraph);
 protected
  procedure AddAnsiChar(aText: AnsiChar; aState: TddRTFState); override;
  procedure AddString(aText: Tl3String; aState: TddRTFState); override;
  function AddTextPara(aIntable: Boolean): TddTextParagraph;
  procedure AddUnicodeChar(aText: Word; aState: TddRTFState); override;
  procedure Cleanup; override;
  function GetColor(aColorIndex: Integer): TColor;
  function GetFontEvent(aFontID: Integer): TddFontEntry;
  function GetList(aListID: Integer): TrtfList;
  function GetStyle(aStyleID: Integer): TddStyleEntry;
 public
  constructor Create;
  procedure AddPicture(aPicture: TddPicture; aState: TddRTFState);
  procedure Append(aDest: TdestNorm; aInSamePara: Boolean = False);
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  function BufferEmpty: Boolean;
  procedure CheckLastParagraph(DestroyPara: Boolean = False);
  procedure Clear; override;
  procedure CorrectCharset(aCHP: TddCharacterProperty; aText: Tl3String);
  procedure FlushTextBuffer(aState: TddRTFState);
  procedure FlushUnicodeBuffer(aState: TddRTFState);
  procedure ParseSymbol(Symbol: Long; propType: TPropType; aState: TddRTFState);
      override;
  procedure Unicode2Text;
  procedure write(aGenerator: Ik2TagGenerator); override;
  procedure WriteText(aText: Tl3String; aState: TddRTFState); override;
  property EnablePictures: Boolean read f_EnablePictures write f_EnablePictures;
  property IsPicture: Boolean read f_IsPicture;
  property LastAtom: TddDocumentAtom read pm_GetLastAtom;
  property LastCell: TddTableCell read pm_GetLastCell;
  property LastParagraph: TddTextParagraph read pm_GetLastParagraph;
  property LastRow: TddTableRow read pm_GetLastRow;
  property Paragraphs: Tl3ProtoPersistentRefList read f_Paragraphs;
  property TextBuffer: Tl3String read f_TextBuffer write f_TextBuffer;
  property UnicodeBuffer: Tl3MemoryStream read f_UnicodeBuffer write
      f_UnicodeBuffer;
  property OnGetFontEvent: TdestGetFontEvent read f_OnGetFontEvent write
      f_OnGetFontEvent;
  property OnGetStyle: TdestGetStyleEvent read f_OnGetStyle write f_OnGetStyle;
 published
  property OnGetColor: TdestGetColorEvent read f_OnGetColor write f_OnGetColor;
  property OnGetList: TdestGetListEvent read f_OnGetList write f_OnGetList;
 end;

 TdestPicture = class(TdestNorm)
 private
  procedure ApplyToPicture(What: Tiprop; Value: Longint);
  function pm_GetPicture: TddPicture;
 protected
  procedure AddString(aText: Tl3String; aState: TddRTFState); override;
 public
  constructor Create;
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  procedure Clear; override;
  property Picture: TddPicture read pm_GetPicture;
 end;

 TdestFootnote = class(TdestNorm)
 public
  procedure ParseSymbol(Symbol: Long; propType: TPropType; aState: TddRTFState);
      override;
  procedure write(aGenerator: Ik2TagGenerator); override;
 end;

 TdestColorTable = class(TddRTFDestination)
 private
  f_colorEntry: TddColorEntry;
  f_Colors: Tl3ProtoObjectRefList;
  f_IsDefault: Boolean;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure AddAnsiChar(aText: AnsiChar; aState: TddRTFState); override;
  procedure AddDefaultColors;
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  procedure Clear; override;
  function ColorByIndex(aColorIndex: Integer): TColor;
 end;

 TdestListLevel = class(TddRTFDestination)
 private
  f_Level: TrtfListLevel;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  procedure Clear; override;
  property Level: TrtfListLevel read f_Level;
 end;


 TdestList = class(TddRTFDestination)
 private
  f_List: TrtfList;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure AddLevel(aLevel: TdestListLevel);
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  procedure Clear; override;
  property List: TrtfList read f_List;
 end;

 TdestListTable = class(TddRTFDestination)
 private
  f_Lists: TrtfListTable;
  function GetCount: Integer;
  function pm_GetItems(aID: Integer): TrtfList;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure AddList(aList: TdestList);
  property Count: Integer read GetCount;
  property Items[aID: Integer]: TrtfList read pm_GetItems; default;
 end;

 TdestListoverride = class;
 TdestListOverrideTable = class(TddRTFDestination)
 private
  f_ListOverrideTable: TrtfListOverrideTable;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure AddListOverride(aListOverride: TdestListoverride);
  function LS2ListID(aLS: Integer): Integer;
 end;

 TdestListoverride = class(TddRTFDestination)
 private
  f_ListOverride: TrtfListOverride;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  procedure Clear; override;
  property ListOverride: TrtfListOverride read f_ListOverride write
      f_ListOverride;
 end;

 TdestLevelText = class(TddRTFDestination)
 private
  f_Length: Integer;
  f_Numbers: AnsiString;
  f_Text: AnsiString;
 public
  procedure AddAnsiChar(aText: AnsiChar; aState: TddRTFState); override;
  procedure Clear; override;
  property Length: Integer read f_Length write f_Length;
  property Numbers: AnsiString read f_Numbers write f_Numbers;
  property Text: AnsiString read f_Text write f_Text;
 end;

 TdestSkip = class(TddRTFDestination)
 end;

 TdestFontTable = class(TddRTFDestination)
 private
  f_Fonts: Tl3StringList;
  function GetCount: Integer;
  function pm_GetCurFont: TddFontEntry;
  function pm_GetItems(Index: Integer): TddFontEntry;
 protected
  procedure Cleanup; override;
 public
  constructor Create;
  procedure AddAnsiChar(aText: AnsiChar; aState: TddRTFState); override;
  procedure AddString(aText: Tl3String; aState: TddRTFState); override;
  procedure AddFont;
  procedure ApplyProperty(propType: TPropType; What: Tiprop; Value: Longint;
      aState: TddRTFState); override;
  function FontByNumber(aNumber: Integer): TddFontEntry;
  property Count: Integer read GetCount;
  property CurFont: TddFontEntry read pm_GetCurFont;
  property Items[Index: Integer]: TddFontEntry read pm_GetItems; default;
 end;



implementation

uses
  SysUtils, ddRTfConst, l3Chars, Windows, l3String, l3StringEx,
  Table_Const, TextPara_Const, k2Tags, EvdStyles, Math, StrUtils,
  ddTextSegment, ddTable;

constructor TddRTFDestination.Create;
begin
  inherited;
  f_SkipSkipable:= False{True};
end;

procedure TddRTFDestination.AddAnsiChar(aText: AnsiChar; aState: TddRTFState);
begin
 {$IFDEF Write2Log}
 l3System.Str2Log('Reader.AddAnsiChar: %s', [aText]);
 {$ENDIF}
end;

procedure TddRTFDestination.AddString(aText: Tl3String; aState: TddRTFState);
begin
 {$IFDEF Write2Log}
 l3System.Str2Log('Reader.AddString: %s', [aText.AsString]);
 {$ENDIF}
end;

procedure TddRTFDestination.AddUnicodeChar(aText: Word; aState: TddRTFState);
begin
 {$IFDEF Write2Log}
 l3System.Str2Log('Reader.AddWord: %d', [aText]);
 {$ENDIF}
end;

procedure TddRTFDestination.ApplyProperty(propType: TPropType; What: Tiprop;
    Value: Longint; aState: TddRTFState);
begin
end;

procedure TddRTFDestination.ParseSymbol(Symbol: Long; propType: TPropType;
    aState: TddRTFState);
begin
end;

procedure TddRTFDestination.Cleanup;
begin
  inherited;
end;

procedure TddRTFDestination.Clear;
begin
end;

procedure TddRTFDestination.write(aGenerator: Ik2TagGenerator);
begin
end;

procedure TddRTFDestination.WriteText(aText: Tl3String; aState: TddRTFState);
begin
 {$IFDEF Write2Log}
 l3system.Str2Log(atext.St);
 {$ENDIF}
end;

constructor TdestStyleSheet.Create;
begin
 inherited Create;
 f_Styles := Tl3StringList.Create;
end;

procedure TdestStyleSheet.AddAnsiChar(aText: AnsiChar; aState: TddRTFState);
begin
 if (CurStyle <> nil) and (aText <> ';') then
  CurStyle.Append(aText);
end;

procedure TdestStyleSheet.AddString(aText: Tl3String; aState: TddRTFState);
begin
 if CurStyle <> nil then
  CurStyle.JoinWith(aText);
end;

procedure TdestStyleSheet.AddStyle;
var
 l_Style: TddStyleEntry;
begin
 l_Style:= TddStyleEntry.Create;
 try
  f_Styles.Add(l_Style);
 finally
  FreeAndNil(l_Style);
 end;
end;

procedure TdestStyleSheet.ApplyProperty(propType: TPropType; What: Tiprop;
    Value: Longint; aState: TddRTFState);
begin
 with CurStyle do
 begin
   case What of
    ipropParaStyle :
      begin
        StyleDef:= sdParagraph;
        Number:= Value;
      end;
    iproPAnsiCharStyle :
      begin
        StyleDef:= sdCharacter;
        Number:= Value;
      end;
    ipropsectStyle :
      begin
        StyleDef:= sdSection;
        Number:= Value;
      end;
    ipropLang:
     CHP.Language:= Value;
    ipropkeycode : ;
    ipropkeys : ;
    ipropkey : ;
    ipropadditive : ;
    ipropbased : ;
    ipropnext : ;
    ipropautoupd : ;
    iprophidden : ;
    iproppersonal : ;
    ipropcompose : ;
    ipropreply : ;

   end; {case What}
 end; { if };
end;

procedure TdestStyleSheet.Cleanup;
begin
 FreeAndNil(f_Styles);
 inherited Cleanup;
end;

function TdestStyleSheet.GetCount: Integer;
begin
  Result := f_Styles.Count;
end;

function TdestStyleSheet.pm_GetCurStyle: TddStyleEntry;
begin
 Result := TddStyleEntry(f_Styles.Last);
end;

function TdestStyleSheet.pm_GetItems(Index: Integer): TddStyleEntry;
begin
 Result := TddStyleEntry(f_Styles[Index]);
end;

function TdestStyleSheet.StyleByNumber(aNumber: Integer): TddStyleEntry;
var
 i: Integer;
begin
 Result:= nil;
 for i:= 0 to Pred(Count) do
 begin
  if Items[i].Number = aNumber then
  begin
   Result:= Items[i];
   break;
  end;
  end;
end;

constructor TdestNorm.Create;
begin
 inherited;
 f_TextBuffer:= Tl3String.Create;
 f_UnicodeBuffer:= Tl3MemoryStream.Create;
 f_Paragraphs:= Tl3ProtoPersistentRefList.Make;
 f_CurCell:= -1; 
end;

function TdestNorm.AddCell: TddTableCell;
var
 l_Cell: TddTableCell;
begin
 Result := nil;
 if LastAtom.AtomType = dd_docTableRow then
 begin
  l_Cell:= TddTableCell.Create(nil);
  try
   LastRow.AddCell(l_Cell);
  finally
   FreeAndNil(l_Cell);
  end;
  Result:= LastRow.LastCell;
 end;
end;

procedure TdestNorm.AddPicture(aPicture: TddPicture; aState: TddRTFState);
var
 l_P: TddPicture;
 l_Cell: TddTableCell;
begin
 l_P:= TddPicture.Create(nil);
 try
  l_P.Assign(aPicture);
  l_P.PAP:= aState.PAP;
  if LastAtom <> nil then
  begin
   if LastAtom.AtomType = dd_docTextParagraph then
   begin
    if LastAtom.Closed then
     f_Paragraphs.Add(l_P)
    else
     LastParagraph.AddPicture(l_P);
   end
   else
   if LastAtom.AtomType = dd_docTableRow then
   begin
    if LastRow = nil then
     CloneRow;

    if LastRow <> nil then // иначе строка уже закончилась
    begin
     l_Cell:= LastRow[Succ(f_CurCell)];
     if l_Cell <> nil then
     begin
      l_Cell.Add(l_P);
     end; // l_Cell <> nil
    end; // LastRow <> nil
   end; // LastAtom.AtomType = dd_docTableRow
  end // LastAtom <> nil
  else
   f_Paragraphs.Add(l_P);
 finally
  FreeAndNil(l_P);
 end;
end;

function TdestNorm.AddRow: TddTableRow;
var
 l_R: TddTableRow;
begin
 l_R:= TddTableRow.Create(nil);
 try
  f_Paragraphs.Add(l_R);
 finally
  FreeAndNil(l_R);
 end;
 f_CurCell:= -1;
end;

function TdestNorm.AddTextPara(aIntable: Boolean): TddTextParagraph;
var
 l_P : TddTextParagraph;

begin
 // Абзац может добавляться в документ или таблицу. Причем таблицы может и не быть
 l_P:= TddTextParagraph.Create(nil);
 try
  if aInTable then
  begin
   if not f_Paragraphs.Empty then // Должна быть таблица
   begin
    // проверить не таблица ли сейчас
    if (LastAtom.AtomType = dd_docTableRow) then
    begin
     if LastRow = nil then
      CloneRow;
     if (LastCell = nil) or ((LastCell <> nil) and (LastCell.Closed)) then
      LastRow.AddEmptyCell;
    end
    else // Не таблица
    begin
     AddEmptyRow;
    end
   end
   else // Ничего нет, добавляем таблицу
   begin
    AddEmptyRow;
   end; // f_Paragraphs.Empty
   Result:= {LastCell}LastRow[Succ(f_CurCell)].AddParagraph;
  end // aInTable
  else
  begin
   f_Paragraphs.Add(l_P);
   Result:= TddTextParagraph(LastAtom);
  end;
 finally
  FreeAndNil(l_P);
 end;
end;

procedure TdestNorm.Append(aDest: TdestNorm; aInSamePara: Boolean = False);
var
 i: Integer;
 l_NewPara,
 l_Para: TddTextParagraph;
begin
 if aDest <> nil then
 begin
  for i:= 0 to aDest.Paragraphs.Hi do
  begin
   // Может приехать что угодно
   if aDest.Paragraphs[i] is TddTextParagraph then
    l_Para:= aDest.Paragraphs[i] as TddTextParagraph
   else
   if (aDest.Paragraphs[i] is TddTableRow) then
    l_Para:= TddTableRow(aDest.Paragraphs[i]).LastCell.LastPara
   else
    l_Para:= nil;

   if l_para <> nil then
   begin
    if aInSamePara then
    begin
     if LastParagraph = nil then
     begin
      AddTextPara(l_para.PAP.InTable);
      LastParagraph.PAP:= l_para.PAP;
     end; // LastParagraph = nil
     LastParagraph.AddSegment(l_Para.CHP, False);
     LastParagraph.AddText(l_Para.Text);
    end // aInSamePara
    else
    begin
     l_NewPara:= TddTextParagraph.Make(l_para);
     try
      f_Paragraphs.Add(l_NewPara);
     finally
      FreeAndNil(l_NewPara);
     end;
    end; // not aInSamePara
   end; // l_para <> nil
  end; // for i
 end; // aDest <> nil
end;

procedure TdestNorm.ApplyProperty(propType: TPropType; What: Tiprop; Value:
    Longint; aState: TddRTFState);
begin
 case propType of
   propStyle: ApplyToStyle(What, Value, aState);
   propCHP  : ApplyToCHP(What, Value, aState.CHP);
   propTAB  : ApplyToTAB(What, Value, aState.PAP);
   propPAP  : ApplyToPAP(What, Value, aState.PAP);
   propSep  : ApplyToSep(What, Value);
   propRow  : ApplyToRow(What, Value, aState);
   propCell : ApplyToCell(What, Value, aState.CEP);
   propFrame: ApplyToFrame(What, Value, aState);
 end; // case PropType;
end;

procedure TdestNorm.ApplyToCell(What: Tiprop; Value: Longint; aCEP:
    TddCellProperty);
var
 l_CellClosed: Boolean;
 l_RowClosed: Boolean;
begin
 begin

  case What of
   ipropWidth :
       begin
         aCEP.Width := Value;
         if LastRow = nil then
          AddRow;
         if (f_CurCell <> -1) then
         begin
          LastRow.ClearTableDef;
          f_CurCell:= -1;
         end;
         LastRow.AddCellDef(aCEP);
         aCep.Clear;
       end;{ipropWidth}
   ipropJust  :
         aCEP.Just:= TddCellJust(Value);
   ipropTop   :
      begin
        f_CurBorderPart:= bpTop;
        f_BorderOwner:= boCell;
      end;{ipropTop}
   ipropLeft  :
    begin
     f_CurBorderPart:= bpLeft;
     f_BorderOwner:= boCell;
    end;{ipropLeft}
   ipropBottom:
    begin
     f_CurBorderPart:= bpBottom;
     f_BorderOwner:= boCell;
    end;{ipropBottom}
   ipropRight :
    begin
     f_CurBorderPart:= bpRight;
     f_BorderOwner:= boCell;
    end;{ipropRight}
   ipropVMerged :
    if not aCEP.VMergeFirst then
     aCEP.VMerged := True;
   ipropVMergeFirst :
    begin
     aCEP.VMergeFirst := True;
    end;
   ipropMerged :
    if not aCEP.MergeFirst then
     aCEP.Merged := True;
   ipropMergedFirst : aCEP.MergeFirst := True;
   ipropColorB: aCEP.PatternBackColor:= GetColor(Value-1);
   ipropColorF: aCEP.PatternForeColor:= GetColor(Value-1);
  end;{case What}

 end;{propCell};
end;

procedure TdestNorm.ApplyToCHP(What: Tiprop; Value: Longint; aCHP:
    TddCharacterProperty);
var
 l_Font: TddFontEntry;
begin
 with aCHP do
 begin
  case What of
    ipropAnime : ;
    ipropPos   : Pos:= TCharPosition(Value);
    ipropHighlight : Highlight:= GetColor(Value-1);
    ipropBold: Bold:= ByteBool(Value);
    ipropItalic: Italic:= ByteBool(Value);
    ipropUnderline : if not LongBool(Value) then
                       Underline:= utNone
                     else
                       Underline:= TUnderline(Value);
    iproPAnsiCharCaps : Caps:= TCharCapsType(Value);
    ipropHidden  : Hidden:= ByteBool(Value);
    ipropDeleted : ;
    iproPAnsiCharScale : ;
    iproPAnsiCharpos: ;
    ipropNumber:
     begin
      FontNumber:= Value;
      l_Font:= GetFontEvent(FontNumber);
      if l_Font <> nil then
      begin
       FontName:= l_Font.AsString;
       FontCharSet:= l_Font.CharSet;
      end; // l_Font <> nil
     end; // ipropNumber
    ipropHeight: FontSize:= Value;
    ipropLang: Language:= Value;
    ipropColorF: FColor:= GetColor(Value-1);
    ipropColorB: BColor:= GetColor(Value-1);
    ipropStrikeout: Strikeout:= ByteBool(Value);
    ipropDefault:
       begin
         Clear{Reset};
         (*
         if RDS in CollectibleRDS then
          if Destination[RDS].LastParagraph.Empty then
           Destination[RDS].LastParagraph.CHP.Clear
          else
           Destination[RDS].LastParagraph.AddSegment(CHP);
         *)
       end;
  end;
 end;
end;

procedure TdestNorm.ApplyToFrame(What: Tiprop; Value: Longint; aState:
    TddRTFState);
var
 tmpBorder: TddBorder;
begin
 { TODO : Нужно починить }
  case f_BorderOwner of
   boPara: tmpBorder:= aState.PAP.Border;
   boRow : tmpBorder:= aState.TAP.Border;
   boCell: tmpBorder:= aState.CEP.Border
  else
   tmpBorder:= nil;
  end;{case BorderOwner}
 if tmpBorder <> nil then
  case What of
   ipropWidth: tmpBorder.FrameWidth[f_CurBorderPart]:= Value;
   ipropColorF: tmpBorder.FrameColor[f_CurBorderPart]:= Value;
   ipropLineType: tmpBorder.FrameType[f_CurBorderPart]:= TddBorderType(Value);
   ipropBrdrTbl: tmpBorder.isFramed:= False;
  end;{case What}
end;

procedure TdestNorm.ApplyToPAP(What: Tiprop; Value: Longint; aPAP:
    TddParagraphProperty);
var
 i: Long;
begin
 with aPAP do
 begin
   case What of
     ipropLeft  : XaLeft:= Value;
     ipropFirst : XaFirst:= Value;
     ipropRight : XaRight:= Value;
     ipropBottom: After:= Value;
     ipropTop   : Before:= Value;
     ipropJust: Just:= TJust(Value);
     ipropInTable: InTable:= True;
     ipropBorderWhere:
       begin
         f_BorderOwner:= boPara;

         case TddBorderWhere(Value) of
          bwTop: begin
                   f_CurBorderPart:= bpTop;
                   Border.Frames[bpTop].Enable:= True;
                 end;
          bwRight: begin
                     Border.Frames[bpRight].Enable:= True;
                     f_CurBorderPart:= bpRight;
                   end;
          bwBottom: begin
                      Border.Frames[bpBottom].Enable:= True;
                      f_CurBorderPart:= bpBottom;
                    end;
          bwLeft: begin
                    Border.Frames[bpLeft].Enable:= True;
                    f_CurBorderPart:= bpLeft;
                  end;
          bwHorizontal: Border.Frames[bpHorizontal].Enable:= True;
          bwVertical: Border.Frames[bpVertical].Enable:= True;
          bwBox:
            for i:= ord(bpTop) to ord(bpRight) do
            begin
              Border.Frames[TddBorderParts(i)].Enable:= True;
              Border.FrameWidth[TddBorderParts(i)]:= 10;
              {Border.FrameColor[TddBorderPart(i)]:= ;}
              Border.FrameType[TddBorderParts(i)]:= btSingleThick;
            end;
         end;

       end;
     ipropDefault: Clear;
     ipropLs: ListItem:= Value;
     ipropilvl: ilvl:= Value;
     ipropitap: itap:= Value;
   end; { case}
 end;
end;

procedure TdestNorm.ApplyToRow(What: Tiprop; Value: Longint; aState:
    TddRTFState);
begin
 begin
  case What of
   ipropFirst: aState.TAP.Gaph:= Value;
   ipropBorderWhere:
       begin
        f_CurBorderPart:= TddBorderparts(Value-1);
        (*
         case TddBorderWhere(Value) of
           bwTop: f_CurBorderPart:= bpTop;
           bwLeft: f_CurBorderPart:= bpLeft;
           bwBottom: f_CurBorderPart:= bpBottom;
           bwRight: f_CurBorderPart:= bpRight;
           bwHorizontal: f_CurBorderPart:= bpHorizontal;
           bwVertical: f_CurBorderPart:= bpVertical;
         end;

         f_BorderOwner:= boRow;
        *) 
       end;{ipropBorderWhere}
   ipropLeft: aState.TAP.Left:= Value;
   ipropDefault:
    begin
     aState.TAP.Clear;
     if LastRow <> nil then
     begin
      LastRow.Clear;
      f_CurCell:= Pred(LastRow.CellCount);//-1;
     end
     else
      f_CurCell:= -1;
    end;
  end;{case What}
 end;{propRow};
end;

procedure TdestNorm.ApplyToSep(What: Tiprop; Value: Longint);
var
 l_A: TddDocumentAtom;
begin
   l_A:= LastAtom;
   if (l_A <> nil) and (l_A.AtomType = dd_DocBreak) then
   begin
    with TddBreak(l_A).SEP do
     case What of
       ipropLandscape: fLandscape:= True;
       ipropWidth: xaPage:= Value;
       ipropHeight: YaPage:= Value;
       ipropLeft: xaLeft:= Value;
       ipropRight: xaRight:= Value;
       ipropTop: yaTop:= Value;
       ipropBottom: yaBottom:= Value;
     end;
   end;
end;

procedure TdestNorm.ApplyToStyle(What: Tiprop; Value: Longint; aState:
    TddRTFState);
begin
 if What = ipropParaStyle then
   aState.PAP.Style:= Value
 else
 if What = iproPAnsiCharStyle then
 begin
  aState.CHP.Style:= Value;
  //StopSkipGroup; { TODO : Восстановить (перенести в TdestNorm) }
 end;
end;

procedure TdestNorm.ApplyToTAB(What: Tiprop; Value: Longint; aPAP:
    TddParagraphProperty);
begin
 begin
   if f_TabEntry = nil then f_TabEntry:= TddTab.Create(nil);
   case What of
    ipropJust : f_TabEntry.Kind:= TTabKind(Value);
    ipropWidth:
     begin
      f_TabEntry.TabPos:= Value;
      aPAP.TabList.Add(f_TabEntry);
      FreeAndNil(f_TabEntry);
     end;
    ipropTabBar:
     begin
      f_TabEntry.TabBar:= Value;
      f_TabEntry.Kind:= tkNotDefined;
      aPAP.TabList.Add(f_TabEntry);
      FreeAndNil(f_TabEntry);
     end;
    ipropTabLead: f_TabEntry.TabLead:= TTabLead(Value);
   end;
 end;
end;

procedure TdestNorm.CheckLastParagraph;
begin
  if not f_TextBuffer.Empty then
   LastParagraph.AddText(f_TextBuffer);
 (*
  f_TextBuffer.Clear;
  // Что это?
  if not LastParagraph.Empty and (f_Paragraphs.IndexOf(Para) = -1) then
  begin
    if LastParagraph.PAP.InTable = True then
      f_Cell.Add(Para)
    else
      f_Paragraphs.Add(Para);
    if DestroyPara then
    begin
      FreeAndNil(f_Para);
      f_Para:= TddTextParagraph.Create(nil);
    end;
  end;
 *)
end;

procedure TdestNorm.Cleanup;
begin
 FreeAndNil(f_UnicodeBuffer);
 FreeAndNil(f_TextBuffer);
 FreeAndNil(f_Paragraphs);
 inherited;
end;

procedure TdestNorm.CloneRow;
var
 l_Row: TddTableRow;
 i: Integer;
begin
 if LastAtom <> nil then
 begin
  if LastAtom.AtomType = dd_docTableRow then
  begin
   l_Row:= TddTableRow.Create(nil);
   try
    l_Row.Assign(TddTableRow(f_Paragraphs.Last));
    l_Row.Closed:= False;
    for i:= 0 to Pred(l_Row.CellCount) do
     l_Row[i].Clear;
    f_Paragraphs.Add(l_Row);
    f_CurCell:= -1;
   finally
    FreeAndNil(l_Row);
   end;
  end
  else
   AddEmptyRow;
 end
 else // Нет ни абзаца, ни таблицы...
 begin
  addEmptyRow;
 end;
end;

function TdestNorm.GetColor(aColorIndex: Integer): TColor;
begin
 if Assigned(f_OnGetColor) then
  Result:= f_OnGetColor(aColorIndex);
end;

procedure TdestNorm.AddEmptyRow;
var
 l_Row: TddTableRow;
begin
 l_Row:= TddTableRow.Create(nil);
 try
  f_Paragraphs.Add(l_Row);
  l_Row.AddCellAndPara(True);
  f_CurCell:= -1;
 finally
  FreeAndNil(l_Row);
 end;
end;

procedure TdestNorm.AddAnsiChar(aText: AnsiChar; aState: TddRTFState);
begin
 if UnicodeBuffer.Position > 0 then
  FlushUnicodeBuffer(aState);
 //ConvertSymbolChar(aText, aState.CHP);
 TextBuffer.Append(aText);
end;

procedure TdestNorm.AddString(aText: Tl3String; aState: TddRTFState);
begin
 if UnicodeBuffer.Position > 0 then
  FlushUnicodeBuffer(aState);

 TextBuffer.JoinWith(aText);
end;

procedure TdestNorm.AddUnicodeChar(aText: Word; aState: TddRTFState);
begin
 if not TextBuffer.Empty then
  FlushTextBuffer(aState);
 UnicodeBuffer.write(aText, SizeOf(aText));
end;

function TdestNorm.BufferEmpty: Boolean;
begin
  Result:= f_TextBuffer.Empty and (f_UnicodeBuffer.Position = 0);
end;

procedure TdestNorm.CheckListItem(aPara: TddTextParagraph);
begin
 aPara.AddListIndex(GetList(aPara.PAP.ListItem), LiteVersion);
end;

procedure TdestNorm.Clear;
begin
 inherited;
 TextBuffer.clear;
end;

procedure TdestNorm.ConvertSymbolChar(var aChar: AnsiChar; aCHP:
    TddCharacterProperty);
var
 l_Font: TddFontEntry;
begin
 if LiteVersion then
 begin
  l_Font:= GetFontEvent(aCHP.FontNumber);
  if (l_Font <> nil) and (l_Font.CharSet = fCharsetSymbol) then
   aChar := '-';
 end; // LiteVersion
  case aChar of
   #$B7: aChar:= #$2A;
   #$A7: aChar:= #$23;
  else
   aChar:= '-'
  end;
end;

procedure TdestNorm.CorrectCharset(aCHP: TddCharacterProperty; aText:
    Tl3String);
type
  TCharsetEntry = record
    CodePage: Word;
    Charset: Byte;
  end;
const
  CharsetTable: array [1..10] of TCharsetEntry =
   (
    (CodePage: CP_WesternWin; Charset: ANSI_CHARSET),
    (CodePage: 1250; Charset: EASTEUROPE_CHARSET),
    (CodePage: CP_RussianWin; Charset: RUSSIAN_CHARSET),
    (CodePage: 1253; Charset: GREEK_CHARSET),
    (CodePage: 1254; Charset: TURKISH_CHARSET),
    (CodePage: 1255; Charset: HEBREW_CHARSET),
    (CodePage: 1256; Charset: ARABIC_CHARSET),
    (CodePage: 1257; Charset: BALTIC_CHARSET),
    (CodePage:  874; Charset: THAI_CHARSET),
    (CodePage:  932; Charset: SHIFTJIS_CHARSET)
   );

var
 i,j: Integer;
 l_W: WideString;
 l_S: TL3String;
 l_C: AnsiString;
 l_CodePage: Integer;
begin
  if (aCHP <> nil) and (aCHP.FontCharSet in [THAI_CHARSET, SHIFTJIS_CHARSET]) {and not l3AllCharsInCharSet(Text.AsWStr, [#32..'z'])} then
  begin
   l_CodePage := CP_RussianWin;
   for i:= Low(CharsetTable) to High(CharsetTable) do
    if CharsetTable[I].CharSet = aCHP.FontCharSet then
    begin
      l_CodePage:= CharsetTable[I].CodePage;
      Break;
    end;

   l_S:= Tl3String.Create();
   try
    i:= 0;
    while i < aText.Len do
    begin
     if (aText.Ch[i] > #$80) and not (aText.Ch[i] in [cc_SoftSpace]) then
     begin
      while aText.Ch[i] > #$80 do
      begin
       l_C:= l_C + aText.Ch[i] + aText.Ch[i+1];
       Inc(i, 2);
      end;
      SetLength(l_W, Length(l_C) div 2);
      MultiByteToWideChar(l_CodePage, 0, PAnsiChar(l_C), Length(l_C), PWideChar(l_W), Length(l_W));
      SetLength(l_C, Length(l_W));
      WideCharToMultiByte(CP_RussianWin, 0, PWideChar(l_W), Length(l_W), PAnsiChar(l_C), Length(l_C), nil, nil);
      l_S.AsString:= l_S.AsString +l_C;
      l_C:= '';
     end
     else
     begin
      l_S.Append(aText.Ch[i]);
      Inc(i);
     end;
    end;
    aText.Assign(l_S);
   finally
    FreeAndNil(l_S);
   end;
  end;
end;

procedure TdestNorm.FlushTextBuffer(aState: TddRTFState);
begin
 WriteText(TextBuffer, aState);
 {$IFDEF Debug}
 if RDS = rdsShpTxt then
  l3System.Msg2Log('Shape Text');
 {$ENDIF}
end;

procedure TdestNorm.FlushUnicodeBuffer(aState: TddRTFState);
begin
  Unicode2Text;
  WriteText(TextBuffer, aState);
  f_TextBuffer.Clear;
end;

function TdestNorm.GetFontEvent(aFontID: Integer): TddFontEntry;
begin
 if Assigned(f_OnGetFontEvent) then
  Result := f_OnGetFontEvent(aFontID)
 else
  Result := nil; // TODO: provide default value
end;

function TdestNorm.GetList(aListID: Integer): TrtfList;
begin
 if Assigned(f_OnGetList) then
  Result := f_OnGetList(aListID)
 else
  Result := nil; 
end;

function TdestNorm.GetStyle(aStyleID: Integer): TddStyleEntry;
begin
 if Assigned(f_OnGetStyle) then
  Result := f_OnGetStyle(aStyleID)
 else
  Result := nil;
end;

procedure TdestNorm.OpenNestedTable;
var
 l_Table: TddTable;
 l_Row: TddTableRow;
begin
 l_Table:= TddTable.Create(nil);
 try
  l_Row:= TddTableRow.Create(nil);
  try
   l_Table.AddRow(l_Row);
  finally
   FreeAndNil(l_Row);
  end;
 finally
  FreeAndNil(l_Table);
 end;
end;

procedure TdestNorm.ParseSymbol(Symbol: Long; propType: TPropType; aState:
    TddRTFState);
var
 l_FN: AnsiString;
 l_Atom: TddDocumentAtom;
 l_Para: TddTextParagraph;
begin
 case propType of
  propPAP :
   begin
    l_Para:= LastParagraph;
    if l_Para = nil then
     l_Para:= AddTextPara(aState.PAP.InTable);
    if l_Para.PAP.IsDefault and (l_Para.PAP.OCompare(aState.PAP) <> 0) then
     l_Para.PAP.JoinWith(aState.PAP);
         (*
         if not (l_Para.Empty and IsPicture) then
         begin
           if l_Para.PAP.InTable = True then
             f_Cell.Add(Para)
           else
           {$IFDEF OnePass}
             if RDS = rdsNorm then
               LastParagraph.Write2Generator(Generator, LiteVersion)
             else
           {$ENDIF}
               f_Paragraphs.Add(Para);
         end;
         *)
     l_Para.Closed:= True;
     f_IsPicture:= False;
   end; // propPAP
  propCell:
   begin
    (*
    if LastRow.CellCount > 1 then
    begin
     if lastRow[LastRow.CellCount-2].LastPara.PAP.itap < LastParagraph.PAP.itap then
     // Вложенная таблица
      OpenNestedTable;
    end;
    *)
    if LastRow = nil then // наследуем оформление от предыдущей строки
     CloneRow
    else // Ячейчка без текста                                                                   
    if Succ(f_CurCell) = LastRow.CellCount then
     LastRow.AddCellAndPara(true);
    Inc(f_CurCell);
    LastRow[f_CurCell].Closed:= True;
   end; // propCell
  propRow: // конец строки таблицы
    begin
     LastRow.TAP := aState.TAP;
     LastRow.ApplyTableDef;
     LastRow.Closed := True;
     f_CurCell := -1; // Может перенести это на Row?
     {$IFDEF OnePass}
     if RDS = rdsNorm then
       f_Row.Write2Generator(Generator, LiteVersion)
     else
     {$ENDIF}
    end;
    propCHP:
      begin
        if UnicodeBuffer.Position > 0 then
          FlushUnicodeBuffer(aState);
        if Symbol = symbolFootnote then
        begin
          Inc(gNextFootnoteNumber);
          l_FN:= Format('*(%d)', [gNextFootnoteNumber]);
          LastParagraph.AddHyperLink(l_FN, 0, gNextFootnoteNumber{+10000});
        end
        else
         TextBuffer.Append(AnsiChar(Symbol));
      end; // propCHP
    propDOP:
      begin
         l_Atom:= TddBreak.Create(nil);
         try
           TddBreak(l_Atom).BreakType:= TddBreakType(Symbol);
           Paragraphs.Add(l_Atom);
         finally
           FreeAndNil(l_Atom);
         end;
      end;
  end; { case propType }
end;

function TdestNorm.pm_GetLastAtom: TddDocumentAtom;
begin
 if f_Paragraphs.Empty then
  Result:= nil
 else
  Result := TddDocumentAtom(f_Paragraphs.Last);
end;

function TdestNorm.pm_GetLastCell: TddTableCell;
begin
 Result := nil;
 if LastAtom <> nil then
 begin
  if LastAtom.AtomType = dd_docTableRow then
  begin
   Result:= TddtableRow(LastAtom).LastCell;
   //if Result.Closed then
   // Result:= AddCell;
  end;
 end;
end;

function TdestNorm.pm_GetLastParagraph: TddTextParagraph;
var
 l_Cell: TddTableCell;
begin
 Result := nil;
 if LastAtom <> nil then
 begin
  if LastAtom.AtomType = dd_docTextParagraph then
   Result:= TddTextParagraph(LastAtom)
  else
  if LastAtom.AtomType = dd_docTableRow then
  begin
   if LastRow <> nil then // иначе строка уже закончилась
   begin
    l_Cell:= LastRow[Succ(f_CurCell)];
    if l_Cell <> nil then
    begin
     if not l_Cell.Empty then
      Result:= l_Cell.LastPara;
    end; // l_Cell <> nil
   end; // LastRow <> nil
  end; // LastAtom.AtomType = dd_docTableRow
  if (Result <> nil) and Result.Closed then
   Result:= nil;
 end; // LastAtom <> nil
end;

function TdestNorm.pm_GetLastRow: TddTableRow;
begin
 Result := nil;
 if LastAtom <> nil then
 begin
  if LastAtom.AtomType = dd_docTableRow then
  begin
   Result:= TddTableRow(LastAtom);
   if Result.Closed then
    Result:= nil;                                
  end
  else
  if (LastAtom.AtomType = dd_docTableCell) and (TddTableCell(LastAtom).Items[TddTableCell(LastAtom).Hi].AtomType = dd_docTable) then
   Result:= TddTable(TddTableCell(LastAtom).Items[TddTableCell(LastAtom).Hi]).LastRow;
 end;
end;

procedure TdestNorm.ProcessTableRow(aRow, aPrevRow: TddTableRow);
var
 k: Long;
 l: Long;
 i: Integer;
 l_P: TddDocumentAtom;
 l_Table: Boolean;
 l_NullWidth: Boolean;
begin
 l := -2;
 // - чтобы упало, если не инициализировано
 if aRow.CellCount > 0 then
 begin
  // Коррекция флага "объединение по вертикали"
  if aPrevRow <> nil then
   for i:= 0 to Pred(aRow.CellCount) do
   begin
    if aRow[i].Props.VMergeFirst and (i < aPrevRow.CellCount) then
     if (aRow[i].Props.Width = aPrevRow[i].Props.Width) then
      if (aPrevRow[i].Props.VMergeFirst) or (aPrevRow[i].Props.VMerged and aRow[i].Empty) then
     begin
      aRow[i].Props.VMergeFirst:= False;
      aRow[i].Props.VMerged:= True;
      // Добавить свои абзацы в верхнюю (самую?) ячейку
     end;
   end; // for i
(*
  // Выравнивание ширин?
  if aRow.CellCount > 1 then
  begin
   k:= 0;
   while (k < aRow.CellCount) and (k < aRow.CellCount)  do
   begin
    if (aRow.Cells[k].Count > 0) then
    begin
     if k = 0 then
      l_NullWidth:= (aRow.Cells[k].Props.Width = 0)
     else
     try
      l_NullWidth:= (aRow.Cells[k].Props.Width = aRow.Cells[Pred(k)].Props.Width);
     except
      l_NullWidth:= (aRow.Cells[k].Props.Width = aRow.Cells[Pred(k)].Props.Width);

     end;
     if l_NullWidth then
     begin
      l:= Succ(k);
      while (l < aRow.CellCount) and (aRow.Cells[l].Props.Width = aRow.Cells[Pred(l)].Props.Width) do
       Inc(l);
      aRow.Cells[l].JoinWith(aRow.Cells[k]);
      aRow.Cells[k].Clear;
      k:= Pred(l);
     end; //
    end;
    Inc(k);
   end; // while k
  end;
*)
 // Ищем и объединяем ячейки
  k := 0;
  while k < aRow.CellCount do
  begin
   if aRow.Cells[k].Props.MergeFirst then
   begin
    l:= k;
    Inc(k);
   end
   else
   if aRow.Cells[k].Props.Merged then
   begin
    aRow.Cells[l].Props.Width := aRow.Cells[k].Props.Width;
    aRow.DeleteCell(k);
   end
   else
    Inc(k);
  end; // for k
 end;// aRow.CellCount > 0
end;

procedure TdestNorm.ProcessTextParagraph(aPara: TddTextParagraph);
var
 j: Long;
 l_P: TddDocumentAtom;
 l_Style: TddStyleEntry;
 l_Seg: TddTextSegment;
begin
 // Обрабатываем списки
 CheckListItem(aPara);
 // Проверяем сегменты
 aPara.PackSegments;

 { Поверяем легальность стилей }
 l_Style:= GetStyle(aPara.PAP.Style);

 if (l_Style <> nil) and l_Style.IsEvdStyle then
 begin
   if l_Style.EvdStyle <> -1 then
     aPara.PAP.Style:= l_Style.EvdStyle
 end
 else
 if aPara.PAP.Style in [1..4] then
 begin
   // какая-то хрень...

   if (Uppercase(l_Style.AsString) <> Format('HEADING %d', [l_Style.Number]))
      and (Uppercase(l_Style.AsString) <> Format('ЗАГОЛОВОК %d', [l_Style.Number])) then
     aPara.PAP.Style:= aPara.PAP.Style + 16;
 end;

 if aPara.CHP.Style <> 0 then
 begin
   l_Style:= GetStyle(aPara.CHP.Style);

   if (l_Style <> nil) and l_Style.IsEvdStyle then
     aPara.CHP.Style:= l_Style.EvdStyle
   else
     aPara.CHP.Style:= 0;
 end;

 for j:= 0 to aPara.SegmentList.Hi do
 begin
   l_Seg:= aPara.Segments[j];

   if l_Seg.CHP.Style <> 0 then
   begin
     l_Style:= GetStyle(l_Seg.CHP.Style);

     if (l_Style <> nil) and l_Style.IsEvdStyle then
       l_Seg.CHP.Style:= l_Style.EvdStyle
     else
       l_Seg.CHP.Style:= 0;
   end;

   if LiteVersion then
     if l_Seg.CHP.Pos = cpSuperScript then
       //l_Seg.Insert('.', 0);
      aPara.Text.Append('.');
 end;
end;

procedure TdestNorm.Unicode2Text;
var
 l_Str : Tl3Str;
 aSt   : Tl3PCharLen;
 l_Ansi: Boolean;
begin
  l_Ansi:= False;
  aSt:= l3PCharLen(f_UnicodeBuffer.MemoryPool.AsPointer, f_UnicodeBuffer.Position div 2, cp_Unicode);
  l_Str.Init(aSt, CP_OEM); // - здесь CP_то что надо
  try
   if l3CharSetPresent(l_Str.S, l_Str.SLen, cc_Graph_Criteria) then
   // Преобразовываем в строку
     f_TextBuffer.AsPCharLen := l_Str
   else
     l_Ansi:= True;
  finally
   l_Str.Clear;
  end;{try..finally}
  if l_Ansi then
  begin
   try
    {$IFDEF HasTatar}
    if not l3HasTatar(PWideChar(aSt.S)) then
    //if not l3HasTatar(PWideChar(f_UnicodeBuffer.MemoryPool.AsPointer)) then
    {$ENDIF}
    begin
     l_Str.Init(aSt, CP_ANSI); // - здесь CP_то что надо
     try
      f_TextBuffer.AsPCharLen := l_Str;
     finally
      l_Str.Clear;
     end;{try..finally}
    end
    {$IFDEF HasTatar}
    else
     f_TextBuffer.AsPCharLen := aSt;
    {$ENDIF} 
   except
    f_TextBuffer.AsString := 'unknown';
   end;
  end;
  f_UnicodeBuffer.Size := 0;
  f_UnicodeBuffer.Position:= 0;
end;

procedure TdestNorm.write(aGenerator: Ik2TagGenerator);
var
  i, j, k, l: Long;
  l_P: TddDocumentAtom;
  l_Table: Boolean;
  l_Style: TddStyleEntry;
  l_Seg: TddTextSegment;
  l_NullWidth: Boolean;
 l_PrevRow: TddTableRow;
begin
   l_Table:= False;
   for i:= 0 to Paragraphs.Hi do
   begin
     l_P:= TddDocumentAtom(Paragraphs.Items[i]);

     if (l_P.AtomType = dd_docTableRow) and not l_Table then
     begin
       l_Table:= True;
       aGenerator.StartChild(k2_idTable);
       {$IFDEF Border4Table}
       aRow.TAP.Border.Write2Generator(aGenerator);
       {$ENDIF}
     end
     else
     if l_Table and (l_P.AtomType <> dd_docTableRow) then
     begin
       l_Table:= False;
       aGenerator.Finish;
     end;

     if l_P.AtomType = dd_DocTextParagraph then
      ProcessTextParagraph(TddTextParagraph(l_P))
     else
     if l_P.AtomType =  dd_docTableRow then
     begin
      if (i > 0) and (TddDocumentAtom(Paragraphs.Items[Pred(i)]).AtomType =  dd_docTableRow) then
       l_PrevRow:= TddTableRow(Paragraphs.Items[Pred(i)])
      else
       l_PrevRow:= nil;
      ProcessTableRow(TddTableRow(l_P), l_PrevRow);
     end;
     l_P.Write2Generator(aGenerator, LiteVersion);
   end; { for Paragraphs.Count }
end;

procedure TdestNorm.WriteText(aText: Tl3String; aState: TddRTFState);
var
 l_CHP: TddCharacterProperty;
 l_Add: Boolean;
 l_Para: TddTextParagraph;
begin
 l_Para:= LastParagraph;
 if l_Para = nil then
  l_Para:= AddTextPara(aState.PAP.InTable);
 if l_Para <> nil then
 begin
  if L_Para.Empty then
  begin
   l_Para.ApplyPAP(aState.PAP);
   l_Para.ApplyCHP(aState.CHP);
  end; // LastParagraph.Empty
  l_CHP:= TddCharacterProperty(l_Para.CHP.Diff(aState.CHP));
  try
   if not LiteVersion then
   begin
    if (l_CHP <> nil) then
    begin
     if l_Para.HaveSegments then
      l_Add:= (l_CHP.OCompare(l_Para.LastSegment.CHP) <> 0)
     else
      l_Add:= True;
     if l_Add then
      l_Para.AddSegment(l_CHP)
     else
      l_Para.LastSegment.Stop:= l_Para.LastSegment.Stop + aText.Len;
    end; // aCHP <> nil
   end // not LiteVersion
   else
     if (l_Para.HaveSegments) and (l_CHP <> nil) then
     begin
       if l_Para.LastSegment.CHP.Style <> l_CHP.Style then
         l_Para.AddSegment(l_CHP);
     end; // (LastParagraph.SegmentList.Count > 0) and (aCHP <> nil)
//   if l_CHP <> nil then
//    CorrectCharset(aState.CHP, aText);
  finally
   FreeAndNil(l_CHP);
  end;
  l_Para.AddText(aText);
 end;
 f_TextBuffer.Clear;
end;

constructor TdestPicture.Create;
var
 l_P: TddPicture;
begin
 inherited Create;
 l_P:= TddPicture.Create(nil);
 try
  f_Paragraphs.add(l_P);
 finally
  FreeAndNil(l_P);
 end;
end;

procedure TdestPicture.AddString(aText: Tl3String; aState: TddRTFState);
begin
 Picture.AddText(aText);
end;

procedure TdestPicture.ApplyProperty(propType: TPropType; What: Tiprop; Value:
    Longint; aState: TddRTFState);
begin
 if propType = propPict then
  ApplyToPicture(What, Value)
 else
  inherited;
end;

procedure TdestPicture.ApplyToPicture(What: Tiprop; Value: Longint);
begin
 case What of
  ipropHeight  : Picture.Height:= Value;
  ipropWidth   : Picture.Width:= Value;
  ipropScaleX  : Picture.ScaleX:= Value;
  ipropScaleY  : Picture.ScaleY:= Value;
  ipropPicCropL: Picture.CropL:= Value;
  ipropPicCropR: Picture.CropR:= Value;
  ipropPicCropT: Picture.CropT:= Value;
  ipropPicCropB: Picture.CropB:= Value;
 end;
end;

procedure TdestPicture.Clear;
begin
 inherited;
 Picture.Clear;
end;

function TdestPicture.pm_GetPicture: TddPicture;
begin
 Result := TddPicture(LastAtom);
end;

procedure TdestFootnote.ParseSymbol(Symbol: Long; propType: TPropType; aState:
    TddRTFState);
var
 l_FN: AnsiString;
begin
 if (propType = propCHP) and (Symbol = symbolFootnote) then
 begin
  AddTextPara(False);
  l_FN:= Format('*(%d)', [gNextFootnoteNumber]);
  with LastParagraph do
  begin
   AddSub(gNextFootnoteNumber{+10000}, Format('Сноска %d', [gNextFootnoteNumber]));
   AddText(l_FN);
  end; // with Lastparagraph
 end
 else
  inherited
end;

procedure TdestFootnote.write(aGenerator: Ik2TagGenerator);
var
  i, j, k, l: Long;
  l_P: TddDocumentAtom;
  l_Table: Boolean;
  l_Seg: TddTextSegment;
  l_NullWidth: Boolean;
begin
 aGenerator.StartChild(k2_idTextPara);
 try
  aGenerator.AddIntegerAtom(k2_tiStyle, ev_saTxtNormalOEM);
  aGenerator.AddStringAtom(k2_tiText, 'ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД', CP_OEM);
 finally
  aGenerator.Finish;
 end; { TextPara }

 l_Table:= False;
 for i:= 0 to Paragraphs.Hi do
 begin
  l_P:= TddDocumentAtom(Paragraphs.Items[i]);
  if (l_P.AtomType = dd_docTableRow) and not l_Table then
  begin
   l_Table:= True;
   aGenerator.StartChild(k2_idTable);
  end
  else
  if l_Table and (l_P.AtomType <> dd_docTableRow) then
  begin
   l_Table:= False;
   aGenerator.Finish;
  end;
  l_P.Write2Generator(aGenerator, LiteVersion);
 end; { for Paragraphs.Count }
end;

constructor TdestColorTable.Create;
begin
 inherited;
 f_Colors := Tl3ProtoObjectRefList.Create();
 
end;

procedure TdestColorTable.AddAnsiChar(aText: AnsiChar; aState: TddRTFState);
begin
 if f_ColorEntry <> nil then
 begin
  f_Colors.Add(f_ColorEntry);
  FreeAndNil(f_ColorEntry);
 end; // f_ColorEntry <> nil
end;

procedure TdestColorTable.AddDefaultColors;
begin
 f_IsDefault:= True;
end;

procedure TdestColorTable.ApplyProperty(propType: TPropType; What: Tiprop;
    Value: Longint; aState: TddRTFState);
begin
 if f_ColorEntry = nil then
  f_colorEntry:= TddColorEntry.Create;
 case What of
  ipropRed: f_ColorEntry.Red:= Value;
  ipropGreen: f_ColorEntry.Green:= Value;
  ipropBlue: f_ColorEntry.Blue:= Value;
 end;
end;

procedure TdestColorTable.Cleanup;
begin
  FreeAndNil(f_Colors);
  FreeAndNil(f_ColorEntry);
  inherited;
end;

procedure TdestColorTable.Clear;
begin
 f_Colors.Clear;
end;

function TdestColorTable.ColorByIndex(aColorIndex: Integer): TColor;
begin
 Result:= propUndefined;
 if InRange(aColorIndex, 0, f_Colors.Hi) then
  Result:= TddColorEntry(f_Colors[aColorIndex]).Color;
end;

constructor TdestListTable.Create;
begin
 inherited Create;
 f_Lists := TrtfListTable.Make;
end;

procedure TdestListTable.AddList(aList: TdestList);
begin
 f_Lists.AddList(aList.List);
end;

procedure TdestListTable.Cleanup;
begin
 inherited Cleanup;
 FreeAndNil(f_Lists);
end;

function TdestListTable.GetCount: Integer;
begin
  Result := f_Lists.Count;
end;

function TdestListTable.pm_GetItems(aID: Integer): TrtfList;
var
 i: Integer;
begin
 Result := nil;
 for i:= 0 to f_Lists.Hi do
  if TrtfList(f_Lists[i]).ID = aID then
  begin
   Result:= TrtfList(f_Lists[i]);
   break;
  end;
end;

constructor TdestList.Create;
begin
 inherited Create;
 f_List := TrtfList.Create();
end;

procedure TdestList.AddLevel(aLevel: TdestListLevel);
begin
 List.AddLevel(aLevel.Level);
end;

procedure TdestList.ApplyProperty(propType: TPropType; What: Tiprop; Value:
    Longint; aState: TddRTFState);
begin
 case What of
  //iproplisthybrid: List.ListHybrid:= True;
  iproplistid: List.ID:= Value;
  //AddValue('listoverridecount', valu_listoverridecount, propList, iproplistoverridecount);
  //AddValue('listoverrideformat', valu_listoverrideformat, propList, ipropListOverrideFormat);
  //iproplistoverridestartat: List.;
  //AddValue('listrestarthdn', valu_listrestarthdn, propList, iproplistrestarthdn);
  //iproplistsimple: List.ListSimple:= Value;
  //AddValue('liststyleid', valu_liststyleid, propList, ipropliststyleid);
  iproplistTemplateID: List.TemplateID:= Value;
 end;
end;

procedure TdestList.Cleanup;
begin
 inherited Cleanup;
 FreeAndNil(f_List);
end;

procedure TdestList.Clear;
begin
 f_List.Clear;
 f_List.ID:= 0;
 f_List.ListName:= '';
 f_LIst.TemplateID:= 0;
end;

constructor TdestListLevel.Create;
begin
 inherited Create;
 f_Level := TrtfListLevel.Create();
end;

procedure TdestListLevel.ApplyProperty(propType: TPropType; What: Tiprop;
    Value: Longint; aState: TddRTFState);
begin
 case What of
  iproplevelfollow: Level.Follow:= Value;
  //AddValue('levelindent', valu_levelindent, propLevel, iproplevelindent);
  ipropLeveljc: Level.LevelJC:= Value;
  ipropleveljcn: Level.LevelJcn:= Value;
  //AddValue('levellegal', valu_levellegal, propLevel, ipropLevelLegal);
  iproplevelnfc: Level.LevelNFC:= Value;
  iproplevelnfcn: Level.LevelNFCN:= Value;
  //AddValue('levelnorestart',  valu_levelnorestart, propLevel, iproplevelnorestart);
  //AddDestination('levelnumbers', dest_levelnumbers, ord(rdsLevelNumbers));
  //AddValue('levelold', valu_levelold, propLevel, iproplevelold);
  //Addvalue('levelpicture', valu_levelpicture, propLevel, ipropLevelpicture);
  //AddFlag('levelpicturenosize', valu_levelpicturenosize, propLevel, ipropLevelpicturenosize);
  //AddKeyword2('levelprev', kwdValu, valu_levelprev, propNone, 0, 0);
  //AddKeyword2('levelprevspace', kwdValu, valu_levelprevspace, propNone, 0, 0);
  //AddKeyword2('levelspace', kwdValu, valu_levelspace, propNone, 0, 0);
  iproplevelstartat: Level.StartAt:= Value;
  //AddDestination('leveltext', dest_leveltext, ord(rdsSkip));
 end;
end;

procedure TdestListLevel.Cleanup;
begin
 inherited Cleanup;
 FreeAndNil(f_Level);
end;

procedure TdestListLevel.Clear;
begin
 with f_Level do
 begin
  CHP.Clear;
  Follow:= 0;
  Justify:= 0;
  LevelJC:= 0;
  LevelJCN:= 0;
  LevelNFC:= 0;
  LevelNFCN:= 0;
  Numbers:= '';
  NumberType:= 0;
  StartAt:= 1;
  Text:= '';
 end;
end;

constructor TdestListOverrideTable.Create;
begin
 inherited Create;
 f_ListOverrideTable := TrtfListOverrideTable.Create();
end;

procedure TdestListOverrideTable.AddListOverride(aListOverride:
    TdestListoverride);
var
 l_LO: TrtfListOverride;
begin
 l_LO:= TrtfListOverride.Create;
 try
  l_LO.ListID:= aListOverride.ListOverride.ListID;
  l_LO.ListOverrideCount:= aListOverride.ListOverride.ListOverrideCount;
  l_LO.LS:= aListOverride.ListOverride.LS;
  f_ListOverrideTable.Add(l_LO);
 finally
  FreeAndNil(l_LO);
 end;
end;

procedure TdestListOverrideTable.Cleanup;
begin
 inherited;
 FreeAndNil(f_ListOverrideTable);
end;

function TdestListOverrideTable.LS2ListID(aLS: Integer): Integer;
var
 i: Integer;
begin
 Result := propUndefined;
 for i:= 0 to f_ListOverrideTable.Hi do
 begin
  if TrtfListOverride(f_ListOverrideTable[i]).LS = aLS then
  begin
   Result:= TrtfListOverride(f_ListOverrideTable[i]).ListID;
   break;
  end;
 end;
end;

constructor TdestListoverride.Create;
begin
 inherited Create;
 f_ListOverride := TrtfListOverride.Create();
end;

procedure TdestListoverride.ApplyProperty(propType: TPropType; What: Tiprop;
    Value: Longint; aState: TddRTFState);
begin
 case What of
  ipropLS: ListOverride.LS:= Value;
  iproplistid: ListOverride.ListID:= Value;
  iproplistoverridecount: ListOverride.ListOverrideCount:= Value;
 end;
end;

procedure TdestListoverride.Cleanup;
begin
 inherited;
 FreeAndNil(f_ListOverride);
end;

procedure TdestListoverride.Clear;
begin
 with f_ListOverride do
 begin
  ListID:= 0;
  ListOverrideCount:= 0;
  LS:= -1;
 end; // with f_ListOverride
end;

procedure TdestLevelText.AddAnsiChar(aText: AnsiChar; aState: TddRTFState);
begin
 if Length = 0 then
  Length:= Ord(aText)
 else
 begin
  if aText <> ';' then
   f_Numbers:= f_Numbers + aText;
  if atext < #9 then
   f_Text:= f_Text + '%s'
  else
  if aText <> ';' then
   f_Text:= f_Text + aText;
 end;
end;

procedure TdestLevelText.Clear;
begin
 f_Length:= 0;
 f_Text:= '';
 f_Numbers:= '';
end;

constructor TdestFontTable.Create;
begin
 inherited Create;
 f_Fonts := Tl3StringList.Create;
end;

procedure TdestFontTable.AddAnsiChar(aText: AnsiChar; aState: TddRTFState);
begin
 if (CurFont <> nil) and (aText <> ';') then
  CurFont.Append(aText);
end;

procedure TdestFontTable.AddString(aText: Tl3String; aState: TddRTFState);
begin
 if CurFont <> nil then
  CurFont.JoinWith(aText);
end;

procedure TdestFontTable.AddFont;
var
 l_F: TddFontEntry;
begin
 l_F:= TddFontEntry.Create;
 try
  f_Fonts.Add(l_F);
 finally
  FreeAndNil(l_F);
 end;
end;

procedure TdestFontTable.ApplyProperty(propType: TPropType; What: Tiprop;
    Value: Longint; aState: TddRTFState);
begin
 case What of
   ipropNumber:
     begin
      AddFont;
      CurFont.Number:= Value;
     end;{ipropNumber}

   iproPAnsiCharSet:
     begin
       if CurFont <> nil then
         CurFont.CharSet:= Value;
     end;{ipropNumber}
   ipropFontFamily:
     begin
       if CurFont <> nil then
         CurFont.Family:= TFontFamily(Value);
     end;
   ipropFprq :
     begin
       if CurFont <> nil then
         CurFont.Pitch:= Value;
     end;
 end;{case What};
end;

procedure TdestFontTable.Cleanup;
begin
 FreeAndNil(f_Fonts);
 inherited Cleanup;
end;

function TdestFontTable.GetCount: Integer;
begin
  Result := f_Fonts.Count;
end;

function TdestFontTable.pm_GetCurFont: TddFontEntry;
begin
 Result := TddFontEntry(f_Fonts.Last);
end;

function TdestFontTable.pm_GetItems(Index: Integer): TddFontEntry;
begin
 Result := TddFontEntry(f_Fonts[Index]);
end;

function TdestFontTable.FontByNumber(aNumber: Integer): TddFontEntry;
var
 i: Integer;
begin
 Result:= nil;
 for i:= 0 to Pred(Count) do
 begin
  if Items[i].Number = aNumber then
  begin
   Result:= Items[i];
   break;
  end;
  end;
end;

end.


