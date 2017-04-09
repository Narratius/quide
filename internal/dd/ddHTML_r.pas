unit ddHTML_r;

{ Попытка создать читалку HMTL }
{ $Id: ddHTML_r.pas,v 1.94 2013/05/06 12:37:11 dinishev Exp $ }

// $Log: ddHTML_r.pas,v $
// Revision 1.94  2013/05/06 12:37:11  dinishev
// Откатываем костыли и "рефакторинг" - отъехало чтение таблиц.
//
// Revision 1.93  2013/05/06 08:08:55  dinishev
// Убрал еще одно свойство.
//
// Revision 1.92  2013/04/16 09:06:05  narry
// Обновление
//
// Revision 1.91  2013/04/11 16:46:27  lulin
// - отлаживаем под XE3.
//
// Revision 1.90  2013/01/24 06:55:32  narry
// Поддержка нумерованных абзацев (пока не работает)
//
// Revision 1.89  2013/01/22 12:33:15  narry
// Рефакторинг RTFReader
//
// Revision 1.88  2012/08/28 09:10:35  narry
// Обработка спецсимволов HTML (336662745)
//
// Revision 1.87  2012/08/27 13:51:26  narry
// Ошибочно обрабатывается html (385976288)
//
// Revision 1.86  2012/04/19 12:18:37  narry
// Обработка отрицательных сабов в ссылках на гарантовские документы (358359010)
//
// Revision 1.85  2012/02/17 07:39:24  narry
// Обработка ссылок на гарантовские документы в html (288786476)
//
// Revision 1.84  2012/02/17 07:04:31  narry
// Обработка спецсимволов HTML (336662745)
//
// Revision 1.83  2012/02/15 10:51:30  narry
// Обработка спецсимволов HTML (336662745)
//
// Revision 1.82  2012/02/15 09:31:05  narry
// Обработка спецсимволов HTML (336662745)
//
// Revision 1.81  2012/02/15 09:24:45  narry
// Обработка спецсимволов HTML (336662745)
//
// Revision 1.80  2012/02/07 08:11:43  narry
// Сохранение html-ответа из редактора в evd (330703558)
//
// Revision 1.79  2012/02/07 07:11:24  narry
// Сохранение html-ответа из редактора в evd (330703558)
//
// Revision 1.78  2012/02/06 10:16:33  narry
// Сохранение html-ответа из редактора в evd (330703558)
//
// Revision 1.77  2011/10/13 08:43:31  narry
// Накопившиеся изменения
//
// Revision 1.76  2011/10/07 07:51:52  narry
// Поддержа неизвестных ключевых слов
//
// Revision 1.75  2011/10/06 11:53:20  narry
// Виртуальный метод для обработки StartKeywordChar
//
// Revision 1.74  2011/10/05 08:31:02  narry
// Рефакторинг чтения HTML
//
// Revision 1.73  2011/10/04 12:21:17  narry
// Рефакторинг чтения HTML
//
// Revision 1.72  2011/09/29 15:08:49  lulin
// {RequestLink:288788279}.
//
// Revision 1.71  2011/09/01 08:05:24  narry
// 35. Стирается пробел перед ссылкой (внимание на между "от" и датой) (278839514)
//
// Revision 1.70  2011/08/12 07:19:53  narry
// 28. Игнорировать содержимое файла после окончания html (278839269)
//
// Revision 1.69  2011/08/09 13:08:56  narry
// 25. Соседние объединенные по вертикали ячейки портят таблицу  (278833307)
//
// Revision 1.68  2011/07/29 05:24:44  narry
// Таблицы со смешанными ширинами ячеек (276534804)
//
// Revision 1.67  2011/07/28 12:04:43  narry
// Таблицы со смешанными ширинами ячеек (276534804)
//
// Revision 1.66  2011/07/19 14:39:55  narry
// Снова заголовки 2 (274835821)
//
// Revision 1.65  2011/07/19 12:32:05  narry
// Оформление текста 2 (274835320)
//
// Revision 1.64  2011/07/18 12:11:23  narry
// Снова заголовки (274829372)
//
// Revision 1.63  2011/07/15 10:35:20  narry
// Кривые рамки у таблиц (274825384)
//
// Revision 1.62  2011/07/15 09:38:07  narry
// Ссылки съедают пробел (274825348)
//
// Revision 1.61  2011/07/14 11:05:13  narry
// Кривые таблицы (273589115)
//
// Revision 1.60  2011/07/12 09:25:57  narry
// Кривые таблицы (273589115)
//
// Revision 1.59  2011/02/07 08:40:43  narry
// K251341845. Сохранение ссылок
//
// Revision 1.58  2010/10/14 04:37:41  narry
// K235872650. AV при открытии справки к списку
//
// Revision 1.57  2010/10/12 06:51:23  narry
// K208701604. Утилита сборки постановлений из html
//
// Revision 1.56  2010/09/29 08:45:13  narry
// K208208004. Класс для чтения атрибутов постановления из HTML-карточки
//
// Revision 1.54  2010/02/24 18:16:27  lulin
// - избавляемся от ненужного и вредного параметра, доставшегося в наследство от ошибок молодости.
//
// Revision 1.53  2009/12/14 11:46:59  lulin
// - готовимся к возврату более простых строк.
//
// Revision 1.52  2009/07/21 15:10:20  lulin
// - bug fix: не собирался и не работал Архивариус в ветке.
//
// Revision 1.51  2009/03/04 13:33:06  lulin
// - <K>: 137470629. Генерируем идентификаторы типов с модели и убираем их из общей помойки.
//
// Revision 1.50  2008/10/13 12:39:27  narry
// - промежуточное обновление
//
// Revision 1.49  2008/06/20 14:49:11  lulin
// - используем префиксы элементов.
//
// Revision 1.48  2008/03/21 14:09:21  lulin
// - cleanup.
//
// Revision 1.47  2008/02/14 09:40:33  lulin
// - удалён ненужный класс.
//
// Revision 1.46  2008/02/13 20:20:06  lulin
// - <TDN>: 73.
//
// Revision 1.45  2008/02/06 15:37:00  lulin
// - каждому базовому объекту по собственному модулю.
//
// Revision 1.44  2008/02/05 18:20:36  lulin
// - удалено ненужное свойство строк.
//
// Revision 1.43  2008/02/05 12:49:12  lulin
// - упрощаем базовые объекты.
//
// Revision 1.42  2008/02/05 09:57:59  lulin
// - выделяем базовые объекты в отдельные файлы и переносим их на модель.
//
// Revision 1.41  2008/02/01 15:14:44  lulin
// - избавляемся от излишней универсальности списков.
//
// Revision 1.40  2006/12/01 15:51:01  lulin
// - cleanup.
//
// Revision 1.39  2006/11/03 11:00:39  lulin
// - объединил с веткой 6.4.
//
// Revision 1.38.36.1  2006/10/23 05:51:04  lulin
// - переход по ссылке переделан с обработки мыши на специально для этого выделенное событие.
//
// Revision 1.38  2005/05/26 15:35:07  lulin
// - базовая канва вывода теперь избавлена от знания о контролах управления.
//
// Revision 1.37  2004/12/23 08:40:38  lulin
// - вычищен ненужный модуль.
//
// Revision 1.36  2004/12/16 13:40:16  lulin
// - Print-preview списка полностью переведен на новый механизм.
//
// Revision 1.35  2004/09/21 12:21:04  lulin
// - Release заменил на Cleanup.
//
// Revision 1.34  2004/06/01 16:51:23  law
// - удален конструктор Tl3VList.MakePersistent - пользуйтесь _Tl3ObjectRefList.
//
// Revision 1.33  2004/05/26 10:26:55  narry
// - bug fix: &nbsp; интерпретировался как обычный пробел, а не как неразрывный
//
// Revision 1.32  2004/05/25 15:04:19  narry
// - bug fix: последствия перехода на "кошерную" функцию
//
// Revision 1.31  2004/05/25 14:54:40  law
// - прикрутил еще одну "кошерную" функцию разбора на слова - l3ParseWordsExF.
//
// Revision 1.30  2004/05/25 14:47:28  law
// - прикрутил "кошерную" функцию разбора на слова.
//
// Revision 1.29  2004/05/25 13:01:37  narry
// - update: поддержка чтения таблицы стилей из HTML
//
// Revision 1.28  2004/04/16 13:47:50  narry
// - update: игнорирование таблицы стилей
//
// Revision 1.27  2003/12/29 14:07:47  narry
// - new: чтения PRE-абзацев как Моноширинных
//
// Revision 1.26  2003/07/02 16:23:59  narry
// - bug fix: генерация пустых абзацев в "Немезисе".
//
// Revision 1.25  2003/06/30 12:37:30  narry
// - update: объединение с основной веткой
//
// Revision 1.24.2.1  2003/06/30 12:35:25  narry
// - bug fix: не распознавался тэг PRE; не работало шрифтовое выделение
//
// Revision 1.24  2003/06/04 11:55:16  narry
// no message
//
// Revision 1.23  2003/04/19 12:30:37  law
// - new file: ddDefine.inc.
//
// Revision 1.22  2002/07/09 12:02:17  law
// - rename unit: evUnits -> l3Units.
//
// Revision 1.21  2002/03/14 13:55:36  narry
// - update: добавление обработки тэга <STRONG>
//
// Revision 1.20  2002/02/19 12:55:06  narry
// - bug fix: присвоение формата шрифта до открытия абзаца
//
// Revision 1.19  2001/10/18 12:14:16  narry
// - update : замена объекта TCyrCoder на внутреннюю перекодировку
//
// Revision 1.18  2001/09/03 13:22:48  narry
// - bug fix: коррекция ширин таблиц
//
// Revision 1.17  2001/08/29 12:52:47  narry
// - bug fix
//
// Revision 1.16  2001/08/29 08:59:39  voba
// -bug fix
//
// Revision 1.15  2001/08/28 13:05:01  narry
// - bug fix: двухуровненвые списки приводили к ошибке чтения
//
// Revision 1.14  2001/08/28 12:21:31  narry
// - update: Разбор текста без тэгов HTML и BODY. Разбор полужирного,
//        курсива и подчеркнутого
//
// Revision 1.12  2001/05/10 14:21:38  narry
// Update - более корректное чтение параметро
//
// Revision 1.11  2001/05/07 14:03:41  narry
// Update - улучшенный алгоритм чтения таблиц
//
// Revision 1.10  2001/03/14 16:28:14  narry
// Update HTML_r
//
// Revision 1.9  2001/03/06 11:27:51  narry
// Исправлено - рамки у таблиц
// Добавлено - поддержка списко
//
// Revision 1.8  2001/03/02 14:17:50  narry
// First release
//
// Revision 1.7  2001/03/01 10:21:25  narry
// Fix wrong #5 segments
//
// Revision 1.6  2001/02/27 16:07:33  narry
// Correct cell width
//
// Revision 1.5  2001/02/26 16:54:39  narry
// Temporary upload
//
// Revision 1.4  2000/12/15 15:29:54  law
// - вставлены директивы Log и Id.
//

{$I ddDefine.inc }

interface

Uses
 Classes, Graphics,
 l3Types, l3Base,
 k2Reader, k2TagGen,
 ddBase, ddRTFProperties, ddDocument, ddSimpleHTMLReader,
 l3ObjectRefList
 , l3LongintList, l3RegEx, ddCharacterProperty, ddTableRow, ddParaList, ddTable;

type
  TddHTMLReader = class(TddSimpleHTMLReader)
  private
    f_Align: Tl3LongintList;
    f_AlignSearcher: Tl3RegularSearch;
    f_CHP: TddCharacterProperty;
    f_CodePage: LongInt;
    f_DocID: Integer;
    f_Document: TddDocument;
    f_EtalonRow: TddTableRow;
    f_HeaderStyle: Integer;
    f_IsBody: Boolean;
    f_IsHeader: Boolean;
    f_IsPara: Boolean;
    f_IsStyle: Boolean;
    f_IsTable: Boolean;
    f_LastMerged: Integer;
    f_List: TddParaList;
    f_Lite: Boolean;
    f_NeedInc: Boolean;
    f_NestedLevel: Integer;
    f_Pre: Boolean;
    f_RefStart: Integer;
    f_SaveIsBody: Boolean;
    f_ScaleCellWidth: Boolean;
    f_SpecText: Boolean;
    f_SubID: Integer;
    f_Table: TddTable;
    procedure AddTableRow;
    procedure CalculateCellsWidth;
    procedure CheckPercentCells(aRow: TddTableRow);
    procedure CheckSpanCells;
    procedure CloneCell(aRow: TddTableRow; aCellProp: TddCellProperty);
    procedure CloseCell;
    procedure CloseHyperlink;
    procedure CloseList;
    procedure CloseRow;
    procedure CloseSegment;
    procedure CloseTable;
    function ConvertColor(aParam: AnsiString): TColor;
    function ConvertFontSize(aParam: AnsiString): Integer;
    function ConvertMargin(aParam: AnsiString): Integer;
    procedure NormalizeCells;
    procedure OpenHyperlink(aTag: THTMLTag);
    procedure ParseCell(aObj: THTMLTag);
    procedure ParseFont(aObj: THTMLTag);
    procedure ParseParagraph(aObj: THTMLTag);
    procedure ParseRow(aObj: THTMLTag);
    procedure ParseSpan(aObj: THTMLTag);
    function ParseStyle(const aStyle: Tl3PCharLen; IsLast: Bool): Boolean;
    procedure ParseStyleTable(aStyleTable: AnsiString);
    procedure ParseTable(aObj: THTMLTag);
    function pm_GetDefAlign: Integer;
    procedure pm_SetDefAlign(const Value: Integer);
    procedure SetDefAlign(aParam: THTMLParam);
    procedure StartSegment;
    procedure TranslateParam(aParam: AnsiString; aStyle: TddStyleEntry);
    procedure WorkupB(aTag: THTMLTag);
    procedure workupBody(aTag: THTMLTag);
    procedure WorkupBR;
    procedure workupDiv(atag: ThtmlTag);
    procedure workupHTML(atag: ThtmlTag);
    procedure WorkupHN(aTag: THTMLTag);
    procedure WorkupA(aTag: THTMLTag);
    procedure WorkupI(atag: ThtmlTag);
    procedure WorkupLI(aTag: THTMLTag);
    procedure WorkupMeta(aTag: THTMLTag);
    procedure WorkupOL(aTag: THTMLTag);
    procedure WorkupP(aTag: THTMLTag);
    procedure WorkupSpan(aTag: THTMLTag);
    procedure WorkupStyle(aTag: THTMLTag);
    procedure WorkupTable(aTag: THTMLTag);
    procedure WorkupTD(aTag: THTMLTag);
    procedure WorkupTitle(aTag: THTMLTag);
    procedure workupTR(aTag: THTMLTag);
    procedure WorkupU(aTag: THTMLTag);
    procedure WorkupUL(aTag: THTMLTag);
  protected
    property DefAlign: Integer read pm_GetDefAlign write pm_SetDefAlign;

    procedure Cleanup; override;
    procedure Read; override;
    procedure BeforeCloseParagraph; virtual;
    procedure BeforeWrite; virtual;
    procedure CloseParagraph(const aText: Tl3String = nil); virtual;
    procedure OpenParagraph; virtual;
    procedure RestoreDefAlign;
    procedure WorkupTag(aTag: THTMLTag); override;
    procedure WorkupText(aText: THTMLText); override;
    property Document: TddDocument read f_Document write f_Document;
    property IsHeader: Boolean read f_IsHeader;
  public
    constructor Create(aOwner: Tk2TagGeneratorOwner = nil); override;
    property CodePage: Integer read f_CodePage write f_CodePage;
    property Lite: Boolean read f_Lite write f_Lite;
    property ScaleCellWidth: Boolean read f_ScaleCellWidth write f_ScaleCellWidth;
  end;

const
 cp_UTF8 = -255;


implementation

uses
  SysUtils, StrUtils,
  k2Tags,
  l3MinMAx, l3Chars, l3String,
  evdStyles, l3Units, evTypes,
  RTFTypes,

  Document_Const,
  JClStringConversions, l3Math, l3UnitsTools, Math, ddHTMLTags, evdTypes,
  ddTableCell, ddTextParagraph, ddTextSegment;


  function GetLineLen(aText: Tl3String): Integer;
  var
   l_Pos, l_PrevPos: Integer;
  begin
   l_PrevPos:= 1;
   Result:= 0;
   repeat
    l_Pos:= PosEx(#10, aText.AsString, l_PrevPos);
    if l_Pos = 0 then
     l_Pos:= aText.Len;
    Result:= Max(Result, l_Pos - l_PrevPos + 1);
    l_PrevPos:= Succ(l_pos);
   until l_Pos = atext.Len;
  end;

{
******************************** TddHTMLReader *********************************
}
constructor TddHTMLReader.Create(aOwner: Tk2TagGeneratorOwner = nil);
begin
  inherited Create(aOwner);
  f_CodePage:= cp_ANSI;
  f_Lite:= True;
 f_ScaleCellWidth := True;
 f_Align := Tl3LongintList.Create();
 f_AlignSearcher:= Tl3RegularSearch.Create;
 f_AlignSearcher.IgnoreCase := true;
 f_AlignSearcher.SearchPattern := '^text-align: {(left)|(center)|(right)|(justify)};?';
end;

procedure TddHTMLReader.AddTableRow;
var
 l_Row: TddTableRow;
begin
 l_Row:= TddTableRow.Create(nil);
 try
  f_Table.AddRow(l_Row);
 finally
  FreeAndNil(l_Row);
 end;
end;

procedure TddHTMLReader.Read;
begin
  f_IsPara:= False;
  f_IsHeader:= False;
  f_NestedLevel:= 0;
  DefAlign:= ord(justF);
  { TODO : Вынести отсюда создание и разрушение объектов }
  f_CHP:= TddCharacterProperty.Create(nil);
  try
   Generator.StartChild(k2_idDocument);
   try
     f_Document:= TddDocument.Create(nil);
     f_Document.AddFont('Arial');
     f_IsBody:= Lite;
     inherited;
     if f_IsPara then
       CloseParagraph;
     BeforeWrite;  
     f_Document.Write2Generator(Generator, Lite);
   finally
     Generator.Finish;
     FreeAndNil(f_Document);
     FreeAndNil(f_List);
   end;
  finally
   FreeAndNil(f_CHP);
  end; // l_CHP
end;

procedure TddHTMLReader.CalculateCellsWidth;         
var
 i: Integer;
 l_Row: TddTableRow;
 l_Cell: TddTableCell;
 RowIndex: Integer;
 CellIndex: Integer;
 l_CellWidth: LongInt;
 l_RowWidth: LongInt;
 l_P: TddTextParagraph;
 l_NeedAdjust: Boolean;
 l_TableWidth: Integer;
begin
 l_RowWidth:= 0;
 l_NeedAdjust:= False;
 for RowIndex:= 0 to f_Table.RowCount-1 do
 begin
   l_Row:= f_Table.Rows[RowIndex];

   CheckPercentCells(l_Row);

   l_RowWidth:= 0;
   for CellIndex:= 0 to l_Row.CellCount-1 do
   begin
    l_Cell:= l_Row.Cells[CellIndex];

    if RowIndex = 0 then // Заполняем эталонную строку ячейками
     for i:= 1 to l_Row.CellSpan[CellIndex] do
      f_EtalonRow.AddCellAndPara(True);

    if l_Row.CellWidth[CellIndex] = 0 then
    begin
     l_CellWidth:= 0;
     for i:= 0 to l_Cell.Hi do
     begin
      l_P:= TddTextParagraph(l_Cell.Items[i]);
      l_CellWidth:= Max(GetLineLen(l_P.Text), l_CellWidth);
     end; { for i }
     // Ширина ячейки в символах, переводим в дюймы
     l_Row.CellWidth[CellIndex]:= evChar2Inch(l_CellWidth)+2*108;
     l_NeedAdjust:= True;
    end
    else
    // Перерассчитываем в дюймы ;
    begin
     if l_Row.Cells[CellIndex].Props.IsPercent then
      l_Row.CellWidth[CellIndex]:= l3MulDiv(f_Table.Width, l_Row.CellWidth[CellIndex], 100)
     else // Пикселы
      l_Row.CellWidth[CellIndex]:= 96*(l_Row.CellWidth[CellIndex])* 144 div 100;
    end;
    inc(l_RowWidth, l_Row.CellWidth[CellIndex]);
   end; // for CellIndex
   l_Row.TAP.Width:= l_RowWidth;
 end; // Все ячейки имеют длину в шурадюймах

 // Корректируем ширины эталона по максимальной ширине ячеек
 f_EtalonRow.TAP.Width:= 0;
 for CellIndex:= 0 to Pred(f_EtalonRow.CellCount) do
 begin
   l_CellWidth:= 0;
   // Находим максимальную ширину
   for RowIndex:= 0 to Pred(f_Table.RowCount) do
   begin
    l_Row:= f_Table.Rows[RowIndex];
    //if (CellIndex < l_Row.CellCount){ and (l_Row.CellSpan[CellIndex] = 1)} then
    l_CellWidth:= Max(l_Row.CellWidthBySpan[CellIndex], l_CellWidth);
   end; { for RowIndex }
   if l_CellWidth = 0 then
    l_CellWidth:= 108+108;
   f_EtalonRow.CellWidth[CellIndex]:= l_CellWidth;
   f_EtalonRow.TAP.Width:= f_EtalonRow.TAP.Width + l_CellWidth;
 end; { for CellIndex };
end;

procedure TddHTMLReader.CheckPercentCells(aRow: TddTableRow);
var
 i: Integer;
 l_Percent: Integer;
 l_NonPercentCount: Integer;
begin
 l_Percent:= 0;
 l_NonPercentCount:= 0;
 for i:= 0 to Pred(aRow.CellCount) do
 begin
   if aRow.CellWidth[i] = 0 then
    Inc(l_NonPercentCount)
   else
   if aRow.Cells[i].Props.IsPercent then
    inc(l_Percent, aRow.CellWidth[i]);
 end; // for i
 if l_Percent > 0 then
  for i:= 0 to Pred(aRow.CellCount) do
  begin
    if aRow.CellWidth[i] = 0 then
    begin
     aRow.CellWidth[i]:= (100 - l_Percent) div l_NonPercentCount;
     aRow.Cells[i].Props.IsPercent:= True;
    end; // aRow.CellWidth[i] = 0
  end; // for i

end;

procedure TddHTMLReader.CheckSpanCells;
var
 i: Integer;
 k: Integer;
 l_Row: TddTableRow;
 RowIndex: Integer;
 CellIndex, l_EtalonCellIndex: Integer;
 l_Len: LongInt;
 l_Scale: Integer;
begin
 // Даже без масштаба нужно ограничивать ширину таблицы...
  l_Scale:= l3MulDiv(100, IfThen(ScaleCellWidth, Document.TextWidth, Document.TextWidth*2), f_EtalonRow.TAP.Width);
  l_Scale:= Min(100, l_Scale);
   for RowIndex:= 0 to f_Table.RowCount-1 do
   begin
    l_Row:= f_Table.Rows[RowIndex];
    l_EtalonCellIndex:= 0;
    for CellIndex:= 0 to Pred(l_Row.CellCount) do
    begin
     l_Len:= 0;
     for k:= 1 to l_Row.Cells[CellIndex].Props.CellSpan do
     begin
      // Найти соответствующую ячейку в эталонном столбце и прибавить ее ширину
      if f_EtalonRow.Cells[l_EtalonCellIndex] <> nil then
      begin
       Inc(l_Len, f_EtalonRow.CellWidth[l_EtalonCellIndex]);
       Inc(l_EtalonCellIndex);
      end
     end; // l_Row.TAP.CellsProps[CellIndex].CellSpan > 1
     if (l_Len <> 0)  then
      l_Row.CellWidth[CellIndex]:= l3MulDiv(l_Len, l_Scale, 100)+l_Row.CellSpan[CellIndex]*(108+108);
    end; // for CellIndex
   end; // for RowIndex;
end;

procedure TddHTMLReader.Cleanup;
begin
 inherited;
 FreeAndNil(f_Align);
 FreeAndNil(f_AlignSearcher);
end;

procedure TddHTMLReader.CloneCell(aRow: TddTableRow; aCellProp: TddCellProperty);
begin
 aRow.AddCellAndPara;
 aRow.LastCellProperty.RowSpan:= Pred(aCellProp.RowSpan);
 aRow.LastCellProperty.CellSpan:= aCellProp.CellSpan;
 aRow.LastCellProperty.Width:= aCellProp.Width;
 // Нельзя так присваивать рамки!
 aRow.LastCellProperty.Border.Assign(aCellProp.Border);
 aRow.LastCellProperty.VMerged:= True;
end;

procedure TddHTMLReader.CloseCell;
begin
 CloseParagraph;
 RestoreDefAlign;
end;

procedure TddHTMLReader.CloseList;
begin
 if f_List <> nil then
 begin
  if f_List.Multilevel then
   f_List.CloseLevel
  else
  begin
   f_List.Closed:= True;
   FreeAndNil(f_List);
  end;
 end;
end;

procedure TddHTMLReader.BeforeCloseParagraph;
begin
end;

procedure TddHTMLReader.BeforeWrite;
begin
 // TODO -cMM: TddHTMLReader.BeforeWrite default body inserted
end;

procedure TddHTMLReader.CloseHyperlink;
var
 l_Seg: TddTextSegment;
begin
 if (f_DocID > 0) then
 begin
  l_Seg:= TddTextSegment.Create;
  try
   l_Seg.AddTarget(f_DocID, f_SubID, CI_TOPIC);
   l_Seg.Start:= f_RefStart;
   l_Seg.Stop:= f_Document.LastPara.Text.Len;
   l_Seg.SegmentType := dd_segHLink;
   f_Document.LastPara.AddSegment(l_Seg);
  finally
   l3Free(l_Seg);
  end;
 end;
end;

procedure TddHTMLReader.CloseParagraph(const aText: Tl3String = nil);
begin
  if f_IsPara then
  begin
   f_IsPara:= False;
   f_SpecText:= False;
   if IsHeader then
    f_Document.LastPara.PAP.Style:= f_HeaderStyle;
   f_Document.LastPara.AddText(aText);
   f_Document.LastPara.Closed:= True;
   f_Document.LastPara.CorrectSegments(nil);
  end;
end;

procedure TddHTMLReader.CloseRow;
var
  l_PrevRow, l_Row: TddTableRow;
  l_PrevCellIndex: Integer;
begin
  if (f_Table <> nil) and (f_Table.RowCount > 1) then
  begin
   l_Row:= f_Table.LastRow;
   l_PrevRow:= f_Table.Rows[f_Table.RowCount-2]; // Предыдущий ряд
   if l_Row.CellCountBySpan < l_PrevRow.CellCountBySpan then { TODO : Нужно учитывать объединенные по горизонтали ячейки }
   begin
    l_PrevCellIndex:= l_Row.CellCountBySpan;
    while l_PrevCellIndex < l_PrevRow.CellCountBySpan do
    begin
     if l_PrevRow.CellPropBySpan[l_PrevCellIndex].RowSpan > 1 then
      CloneCell(l_Row, l_PrevRow.CellPropBySpan[l_PrevCellIndex]);
     Inc(l_PrevCellIndex, l_PrevRow.CellPropBySpan[l_PrevCellIndex].CellSpan);
    end; // f_Table.RowList.Count > 0
   end;
  end;
  RestoreDefAlign;
end;

procedure TddHTMLReader.CloseSegment;
begin
 if f_Document.LastPara.LastSegment <> nil then
  f_Document.LastPara.LastSegment.Stop:= f_Document.LastPara.Text.Len;
end;

procedure TddHTMLReader.CloseTable;
var
  i, k: Integer;
  Delta: Integer;
  l_Row: TddTableRow;
  l_Cell: TddTableCell;
  RowIndex, CellIndex: Integer;
  l_maxCellCount: Integer;
  l_CellWidth, l_Len, l_RowWidth: LongInt;
  l_BorderRule: TddBorderRules;
  l_EtalonRow: Integer;
  l_P: TddTextParagraph;
  l_Nested: Boolean;
  l_NeedAdjust: Boolean;
begin
 if f_Table <> nil then
 begin
  // Вычисление ширин ячеек
  f_EtalonRow:= TddTableRow.Create(nil);
  try
   CalculateCellsWidth;
   // Коррекция объединенных по горизонтали
   CheckSpanCells;

   // Приведение ширин к нормальному виду, расстановка рамок
   NormalizeCells;
   f_Table.Closed:= True;
   l_Nested:= f_Table.Nested;
   l3Free(f_Table);
   Dec(f_NestedLevel);
   if {l_Nested} f_NestedLevel > 0 then
   begin
    f_Table:= TddTable(f_Document.Paragraphs.Items[f_Document.Paragraphs.Hi-f_NestedLevel]); // !
   end;
   f_IsTable:= l_Nested;
  finally
   FreeAndNil(f_EtalonRow);
  end;
 end;
end;

function TddHTMLReader.ConvertColor(aParam: AnsiString): TColor;
begin
  if aParam[1] = '#' then
  begin
   aParam[1]:= '$';
   Result := StringToColor(aParam);
  end
  else
   Result:= clDefault;
end;

function TddHTMLReader.ConvertFontSize(aParam: AnsiString): Integer;
begin
  (*
  font-size
  Value: <absolute-size> | <relative-size> | <length> | <percentage>
  Initial: medium
  Applies to: all elements
  Inherited: yes
  Percentage values: relative to parent element's font size
  *)
  Result := 10;
  if Pos('pt', aParam) <> 0 then
  begin
   Result:= 2*StrToIntDef(Copy(aParam, 1, Pred(Pos('pt', aParam))), 10);
  end
end;

function TddHTMLReader.ConvertMargin(aParam: AnsiString): Integer;
begin
  if AnsiEndsText('px', aParam) then
   Result:= StrToIntDef(Copy(aParam, 1, Pred(Pos('px', aParam))), propUndefined)
  else
   Result := propUndefined;
end;

procedure TddHTMLReader.NormalizeCells;
var
 l_Row: TddTableRow;
 RowIndex: Integer;
 CellIndex: Integer;
 l_BorderRule: TddBorderRules;
begin
 for RowIndex:= 0 to f_Table.RowCount-1 do
 begin
   l_Row:= f_Table.Rows[RowIndex];
   for CellIndex:= 0 to Pred(l_Row.CellCount) do
   begin
    if CellIndex > 0 then
     l_Row.CellWidth[CellIndex]:= l_Row.CellWidth[CellIndex] + l_Row.CellWidth[Pred(CellIndex)];
     (*
     case l_BorderRule of
       brNone  : ;
       brBasic : ;
       brRows  :
         begin
           l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpTop]:= 10;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpBottom]:= 10;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpTop]:= btSingleThick;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpBottom]:= btSingleThick;
           if CellIndex = 0 then
           begin
             l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpLeft]:= 10;
             l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpLeft]:= btSingleThick;
           end;

           if CellIndex = l_Row.CellCount-1 then
           begin
             l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpRight]:= 10;
             l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpRight]:= btSingleThick;
           end;
         end;
       brCols  :
         begin
           l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpLeft]:= 10;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpRight]:= 10;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpLeft]:= btSingleThick;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpRight]:= btSingleThick;
           if CellIndex = 0 then
           begin
             l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpLeft]:= 10;
             l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpLeft]:= btSingleThick;
           end;

           if CellIndex = l_Row.CellCount-1 then
           begin
             l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpRight]:= 10;
             l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpRight]:= btSingleThick;
           end;
         end;
       brAll   :
         begin
           l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpTop]:= 10;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameWidth[bpBottom]:= 10;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpTop]:= btSingleThick;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpBottom]:= btSingleThick;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpLeft]:= btSingleThick;
           l_Row.TAP.CellsProps[CellIndex].Border.FrameType[bpRight]:= btSingleThick;
         end;
     end;
     *)
   end;
 end;
end;

procedure TddHTMLReader.OpenHyperlink(aTag: THTMLTag);
var
 l_Param: THTMLParam;
 j: integer;
 l_RegRef: Tl3RegularSearch;
 lREPosition: Tl3MatchPosition;
begin
 f_DocID := -1;

 for j:= 0 to Pred(aTag.ParamCount) do
 begin
   l_Param:= aTag.Params[j];

   // ГАРАНТовская ссылка
   if (AnsiSameText(l_Param.Key, 'HREF') and (l_Param.ValueCount = 1)) then
   begin
     // 'garantf1://106411.13/'
     l_RegRef := Tl3RegularSearch.Create;
     l_RegRef.IgnoreCase := true;
     l_RegRef.SearchPattern := '^garantf1:\/\/{\d+}\.{\-?\d+}\/$';

     try
       if ((l_RegRef.SearchInString(PAnsiChar(l_Param.Values[0]), 0, Length(l_Param.Values[0]), lREPosition)) and
           (l_RegRef.TagParts.Count = 2)
         ) then
       begin
         f_DocID := StrToInt(l_RegRef.TagParts[0].AsString);
         f_SubID := StrToInt(l_RegRef.TagParts[1].AsString);
         f_RefStart := Succ(f_Document.LastPara.Text.Len);
       end;
     finally
       l3Free(l_RegRef);
     end;

     Break;
   end;
 end;
end;

procedure TddHTMLReader.OpenParagraph;
var
  l_Style: TddStyleEntry;
begin
 f_IsBody:= True;
 //if f_IsBody then
 begin
  CloseParagraph;
  if not f_IsPara then
  begin
   if f_Document.Table <> nil then
    f_Document.Table.LastRow.LastCell.AddParagraph
   else
    f_Document.AddParagraph;
   begin
    f_Document.LastPara.Closed:= False;
    f_SpecText:= False;  // ?
    f_IsPara:= True;
    l_Style:= f_Document.StyleByName('P');
    if l_Style <> nil then
    begin
     f_Document.LastPara.PAP:= l_Style.PAP;
     f_Document.LastPara.CHP:= l_Style.CHP;
    end; // l_Style
    if f_Table <> nil then
     f_Document.LastPara.PAP.JUST:= TJust(DefAlign);
   end;
  end;
 end;
end;

procedure TddHTMLReader.ParseCell(aObj: THTMLTag);
var
  l_Row,
  l_PrevRow: TddTableRow;
  j, l_PrevCellIndex: Integer;
  l_Param: ThtmlParam;
  l_NeedFakeAlign: Boolean;
begin
  //  CloseParagraph;
  if f_Table <> nil then
  begin
   { Проверяем предыдущий ряд на наличие объединенных по вертикали ячеек }
   l_Row:= f_Table.LastRow;
   if l_Row = nil then
    AddTableRow;
   if (f_Table.RowCount > 1) then
   begin
    l_PrevCellIndex:= l_Row.CellCountBySpan;
    l_PrevRow:= f_Table.Rows[f_Table.RowCount-2]; // Предыдущий ряд
    while (l_PrevRow.CellPropBySpan[l_PrevCellIndex] <> nil) and
          (l_PrevRow.CellPropBySpan[l_PrevCellIndex].RowSpan > 1) do
    begin
     CloneCell(l_Row, l_PrevRow.CellPropBySpan[l_PrevCellIndex]);
     Inc(l_PrevCellIndex, l_PrevRow.CellPropBySpan[l_PrevCellIndex].CellSpan);
    end; // while
   end; // f_Table.RowList.Count > 1
   l_Row.AddCellAndPara(True);
   l_Row.LastCell.Props.Border.isFramed:= False;
   l_NeedFakeAlign:= True;
    { Вылить параметры ячейки таблицы, если они есть }
   for j:= 0 to Pred(aObj.ParamCount) do
   begin
     l_Param:= aObj.Params[j];
     // Умолчательное выравнивание для абзацев
     (* ALIGN="left|center|right"
      This attribute controls whether text inside the table cell(s) is aligned to the left, right or centred within the cell.
      *)
     if AnsiSameText(l_Param.Key, 'ALIGN') then
     begin
      SetDefAlign(l_Param);
      l_NeedFakeAlign:= False;
     end
     else
     if AnsiSameText(l_Param.Key, 'VALIGN') then
      //The VALIGN attribute controls whether text inside the table cell(s) is aligned to the top, bottom, or vertically centred within the cell. It can also specify that all the cells in the row should be vertically aligned to the same baseline.
     begin
       if AnsiSameText(l_Param.Value, 'TOP') then
         l_Row.LastCell.Props.Just:= cellTop
       else
       if AnsiSameText(l_Param.Value, 'MIDDLE') or AnsiSameText(l_Param.Value, 'center') then
         l_Row.LastCell.Props.Just:= cellCenter
       else
       if AnsiSameText(l_Param.Value, 'BOTTOM') then
         l_Row.LastCell.Props.Just:= cellBottom
  //   else
  //   if AnsiSameText(l_Param.Value, 'BASELINE') then
  //    f_Row.LastCell.Props..CellJust:= cellTop;
     end
     else
     if AnsiSameText(l_Param.Key, 'WIDTH') then
      //WIDTH="value_or_percent"
      //If used, this attribute can specify either the exact width of the data cell in pixels,
      //or the width of the data cell as a percentage of the table being displayed.
      //Only one data cell can set the width for an entire column,
      //so it is good practice to specify all data cells in the same column as having the same width,
      //if the attribute is set at all.
     begin
//       if l_Row.TAP.CellCount > 1 then
//         l_Row.LastCell.Props..Width:= l_Param.IntValue+ l_Row.TAP.CellsProps[f_Table.LastRow.TAP.CellCount-2].Width
//       else
       l_Row.LastCell.Props.Width:= l_Param.IntValue;
       l_Row.LastCell.Props.IsPercent:= l_Param.IsPercent;
     end
     else
      (*
      HEIGHT="value_or_percent"
      If used, this attribute can specify either the exact height of the data cell in pixels,
      or the height of the data cell as a percentage of the browser display window.
      Only one data cell can set the height for an entire row.

      NOTE : Netscape supports use of the WIDTH="value%" and "pixel_value" for this element
      (it only supports the HEIGHT="%value" attribute for the main <TABLE> element).
      Internet Explorer supports both percentage and pixel values for both the HEIGHT and WIDTH
      attributes.
      For WIDTH="%value" settings, the WIDTH="%value" also needs to be set in
      the main <TABLE> element and the cell/header columns (affected by any cell
      with a WIDTH="%value" setting) will be scaled as a percentage of the table width
      (which would be scaled as a percentage of the browser window). Also, for WIDTH="value"
      settings, the table will only be sized to the maximum extent of the browser window width
      (with cells/headers being scaled accordingly), unless the WIDTH="value" setting is used in the main <TABLE> element, set to the combined size of the cells/headers.
      For HEIGHT="%value" settings, the cell (and any rows it is part of) will be rendered as the percentage of the browser window, regardless of any HEIGHT settings in the main <TABLE>. If only one cell has a WIDTH or HEIGHT attribute set, then that setting is used for all the columns/rows of the table that the cell is part of. If more than one cell in a row or column have WIDTH or HEIGHT attributes set, then the largest setting of all the constituent data cells will be used for the entire row/column of the table.

      NOWRAP
      If this attribute appears in any table cell (<TH> or <TD>) it means the lines within this cell cannot be broken to fit the width of the cell. Be cautious in use of this attribute as it can result in excessively wide cells.
      *)

     if AnsiSameText(l_Param.Key, 'COLSPAN') then
      //This attribute can appear in any table cell (<TH> or <TD>)
      //and it specifies how many columns of the table this cell should span.
      //The default COLSPAN for any cell is 1.
     begin
       f_Table.LastRow.LastCell.Props.CellSpan:= l_Param.IntValue;
     end
     else
     if AnsiSameText(l_Param.Key, 'ROWSPAN') then
      //This attribute can appear in any table cell (<TH> or <TD>) and
      //it specifies how many rows of the table this cell should span.
      //The default ROWSPAN for any cell is 1. A span that extends into rows
      //that were never specified with a <TR> will be truncated.
     begin
       f_Table.LastRow.LastCell.Props.RowSpan:= l_Param.IntValue;
       f_Table.LastRow.LastCell.Props.VMergeFirst:= True;
     end
     else
     if AnsiSameText(l_Param.Key, 'frame') then
     (*
      frame = void|above|below|hsides|lhs|rhs|vsides|box|border
      This attribute specifies which sides of the frame surrounding a table will be visible. Possible values:
      void: No sides. This is the default value.
      above: The top side only.
      below: The bottom side only.
      hsides: The top and bottom sides only.
      vsides: The right and left sides only.
      lhs: The left-hand side only.
      rhs: The right-hand side only.
      box: All four sides.
      border: All four sides.
     *)
     begin
      if AnsiSameText(l_Param.Value, 'void') then
       f_Table.LastRow.LastCell.Props.Border.isFramed:= False
      else if AnsiSameText(l_Param.Value, 'above') then
       f_Table.LastRow.LastCell.Props.Border.FrameWidth[bpTop]:= 10
      else if AnsiSameText(l_Param.Value, 'below') then
       f_Table.LastRow.LastCell.Props.Border.FrameWidth[bpBottom]:= 10
      else if AnsiSameText(l_Param.Value, 'hsides') then
      begin
       f_Table.LastRow.LastCell.Props.Border.FrameWidth[bpTop]:= 10;
       f_Table.LastRow.LastCell.Props.Border.FrameWidth[bpBottom]:= 10;
      end
      else if AnsiSameText(l_Param.Value, 'lhs') then
       f_Table.LastRow.LastCell.Props.Border.FrameWidth[bpLeft]:= 10
      else if AnsiSameText(l_Param.Value, 'rhs') then
       f_Table.LastRow.LastCell.Props.Border.FrameWidth[bpRight]:= 10
      else if AnsiSameText(l_Param.Value, 'vsides') then
      begin
       f_Table.LastRow.LastCell.Props.Border.FrameWidth[bpLeft]:= 10;
       f_Table.LastRow.LastCell.Props.Border.FrameWidth[bpRight]:= 10;
      end
      else if AnsiSameText(l_Param.Value, 'box') or
              AnsiSameText(l_Param.Value, 'border') then
       f_Table.LastRow.LastCell.Props.Border.IsFramed:= True
      else
     end;
     //border = pixels [CN]

      (*
      BGCOLOR="#rrggbb|colour name"
      //Internet Explorer and Netscape support use of this attribute
      //(also supported in the <BODY> element). It allows the background
      //colour of the data cell to be specified, using either the specified
      //colour names, or a rrggbb hex triplet.
      (*
      BORDERCOLOR="#rrggbb|colour name"
      Internet Explorer includes support for this attribute which sets
      the border colour of the data cell. Any of the pre-defined colour names
      can be used, as well as any colour defined by a rrggbb hex triplet.
      It is necessary for the BORDER attribute to be present in
      the main <TABLE> element for border colouring to work.
      *)
      (*
      rules = none|groups|rows|cols|all [CI]
      This attribute specifies which rules will appear between cells within a table. The rendering of rules is user agent dependent. Possible values:
      none: No rules. This is the default value.
      groups: Rules will appear between row groups (see THEAD, TFOOT, and TBODY) and column groups (see COLGROUP and COL) only.
      rows: Rules will appear between rows only.
      cols: Rules will appear between columns only.
      all: Rules will appear between all rows and columns.
      *)
   end; // for
   if l_NeedFakeAlign then
    DefAlign:= Ord(justL)
  end; // f_Table <> nil


end;

procedure TddHTMLReader.ParseFont(aObj: THTMLTag);
var
  j: Integer;
  l_Param: ThtmlParam;
begin

            { При разборе параметров оформления щрифта нужно учитывать наличие
              текста (оформление сегментов) и таблицу }
  for j:= 0 to Pred(aObj.ParamCount) do
  begin

    l_Param:= aObj.Params[j];
    if AnsiSameText(l_Param.Key, 'COLOR') then
              //COLOR = #rrggbb or COLOR = color
              //The colour attribute sets the colour which text will appear in on the screen.
              //#rrggbb is a hexadecimal colour denoting a RGB colour value.
              //Alternately, the colour can be set to one the available pre-defined colours (see <BODY BGCOLOR=..>).
              //These colour names can be used for the BGCOLOR, TEXT, LINK, and VLINK attributes
              //of the <BODY> element as well. NOTE : The use of names for colouring text is currently
              //only supported by the Internet Explorer and Netscape. Also, it should be noted that
              //HTML attributes of this kind (that format the presentation of the content)
              //can also be controlled via the use of style sheets.
              //
              //Example:
              //
              //<FONT COLOR="#FF0000">This text is red.</FONT>
              //or
              //<FONT COLOR="Red">This text is also red.</FONT>
              //would render as :
              //
              //
              //This text is red
    begin
      if l_Param.Value[1] = '#' then
      begin

      end
    end
  end;

  //FACE=name [,name] [,name]
  //The FACE attribute sets the typeface that will be used to display the text on the screen. The type face displayed must already be installed on the users computer. Substitute type faces can be specified in case the chosen type face is not installed on the customers computer. If no match is found, the text will be displayed in the default type that the browser uses for displaying 'normal' text.
  //
  //Example:
  //
  //<FONT FACE="Courier New, Comic Sans MS"> This text will be displayed in either Courier New, or Comic Sans MS, depending on which fonts are installed on the browsers system. </FONT>
  //NOTE : When using this element, care should be taken to try to use font types that will be installed on the users computer if you want the text to appear as desired. Changing the font face is only supported by Netscape and Internet Explorer, while Internet Explorer can also set font sizes/colours/faces within a style sheet. Also note that in a document whose layout/colouring etc., is defined in a style sheet, using the <FONT> element will have no effect.
  //
  //TITLE="informational ToolTip"
  //The Internet Explorer 4.0 (and above) specific TITLE attribute is used for informational purposes. If present, the value of the TITLE attribute is presented as a ToolTip when the users mouse hovers over the <FONT> section.
  //
  //LANG="language setting"
  //The LANG attribute can be used to specify what language the <FONT> element is using. It accepts any valid ISO standard language abbreviation (for example "en" for English, "de" for German etc.) For more details, see the Document Localisation section for more details.
  //
  //LANGUAGE="Scripting language"
  //The LANGUAGE attribute can be used to expressly specify which scripting language Internet Explorer 4.0 uses to interpret any scripting information used in the <FONT> element. It can accept values of vbscript, vbs, javascript or jscript. The first two specify the scripting language as Visual Basic Script, the latter two specify it as using Javascript (the default scripting language used if no LANGUAGE attribute is set.
  //
  //CLASS="Style Sheet class name"
  //The CLASS attribute is used to specify the <FONT> element as using a particular style sheet class. See the Style Sheets topic for details.
  //
  //STYLE="In line style setting"
  //As well as using previously defined style sheet settings, the <FONT> element can have in-line stylings attached to it. See the Style Sheets topic for details.
  //
  //ID="Unique element identifier"
  //The ID attribute can be used to either reference a unique style sheet identifier, or to provide a unique name for the <FONT> element for scripting purposes. Any <FONT> element with an ID attribute can be directly manipulated in script by referencing its ID attribute, rather than working through the All collection to determine the element. See the Scripting introduction topic for more information.
  //
  //POINT-SIZE="Font pt. size"
  //The POINT-SIZE attribute is Netscape specific and allows total sizing control over the contents of the element. For example:
  //
  //<FONT POINT-SIZE="24">This is 24pt. font</FONT>
  //Note that Internet Explorer supports font sizings primarily through Style Sheets (as does Netscape 4.0).
  //


  if f_IsPara then // Это абзац или его сегмент
  begin
  end
  else  // Текст в целом
  begin
  end;

end;

procedure TddHTMLReader.ParseParagraph(aObj: THTMLTag);
  procedure lp_SetAlign(const csKey: AnsiString);
  begin
   if AnsiSameText(csKey, 'LEFT') then
     f_Document.LastPara.PAP.Just := JustL
   else
   if AnsiSameText(csKey, 'CENTER') then
     f_Document.LastPara.PAP.Just := justC
   else
   if AnsiSameText(csKey, 'RIGHT') then
     f_Document.LastPara.PAP.Just := justR
   else
   if AnsiSameText(csKey, 'JUSTIFY') then
     f_Document.LastPara.PAP.Just := justF;
  end;

var
 j: Integer;
 l_Param: THTMLParam;
 lREPosition: Tl3MatchPosition;
begin
  OpenParagraph;
  if aObj.TagID = tidPRE then
   f_Document.LastPara.PAP.Style:= ev_saANSIDOS;

  for j:= 0 to Pred(aObj.ParamCount) do
  begin
    l_Param:= aObj.Params[j];

    if AnsiSameText(l_Param.Key, 'ALIGN') then  //ALIGN=left|center|right
      lp_SetAlign(l_Param.Value)
    else
    if (AnsiSameText(l_Param.Key, 'STYLE') and (l_Param.ValueCount > 0)) then // style="text-align: right;"
    begin
      l_Param:= aObj.Params[j];
      // text-align: right;
      if ((f_AlignSearcher.SearchInString(PAnsiChar(l_Param.Values[0]), 0, Length(l_Param.Values[0]), lREPosition)) and
           (f_AlignSearcher.TagParts.Count = 1)) then
       lp_SetAlign(f_AlignSearcher.TagParts[0].AsString);
    end;
  end;
end;

procedure TddHTMLReader.ParseRow(aObj: THTMLTag);
var
 l_Row: TddTableRow;
 l_Param: THTMLParam;
 i: Integer;
 l_NeedFakeAlign: Boolean;
begin
 if f_Table <> nil then
 begin
  AddTableRow;
  f_Table.LastRow.TAP.Width:= 10206;
  { Вылить параметры строки таблицы, если они есть }
  l_NeedFakeAlign:= true;
  for i:= 0 to Pred(aObj.ParamCount) do
  begin
    l_Param:= aObj.Params[i];

    // ALIGN="left|center|right"
    // This controls whether text inside the table cell(s) is aligned
    // to the left, right or centre of the cell.
    if AnsiSameText(l_Param.Key, 'ALIGN') then
    begin
     SetDefAlign(l_Param);
     l_NeedFakeAlign:= False;
    end;
  (*
  VALIGN="top|middle|bottom|baseline"
  This attribute controls whether text inside the table cell(s)
  is aligned to the top, bottom, or vertically centred within the cell.
  It can also specify that all the cells in the row should be
  vertically aligned to the same baseline.

  BGCOLOR="#rrggbb|colour name"
  Internet Explorer and Netscape support use of this attribute
  (also supported in the <BODY> element). It allows the background
  colour of the table to be specified, using either the specified
  colour names, or a rrggbb hex triplet.

  BORDERCOLOR="#rrggbb|colour name"
  Internet Explorer includes support for this attribute which sets
  the border colour of the row. Any of the pre-defined colour names
  can be used, as well as any colour defined by a rrggbb hex triplet.
  It is necessary for the BORDER attribute to be present
  in the main <TABLE> element for border colouring to work.

  *)
  end; // for i
  if l_NeedFakeAlign then
   DefAlign:= DefAlign

 end;
end;

procedure TddHTMLReader.ParseSpan(aObj: THTMLTag);
var
  i: Integer;
  l_Param: ThtmlParam;
  l_StyleName: AnsiString;
  l_Style: TddStyleEntry;
begin
  // Style - оформление в одну строку
  // class - присвоение оформления сегменту
  for i:= 0 to Pred(aObj.ParamCount) do
  begin
   l_Param:= aObj.Params[i];
   if l_Param.Key = 'CLASS' then
   begin
    l_StyleName:= l_Param.Value;
    l_Style:= f_Document.StyleByName(l_StyleName);
    if l_Style <> nil then
    begin
     if not f_IsPara then
      OpenParagraph;
     f_Document.LastPara.PAP.MergeWith(l_Style.PAP);
     f_Document.LastPara.AddSegment(l_Style.CHP);
     if l_Style.PAP.xaLeft <> propUndefined then
      f_Document.LastPara.AddText(DupeString(' ', l_Style.PAP.xaLeft div 10));
    end; // l_Style <> nil
   end; // l_Param.Key = 'CLASS'
  end; // for i
end;

function TddHTMLReader.ParseStyle(const aStyle: Tl3PCharLen; IsLast: Bool):
    Boolean;
var
  l_StyleEntry: TddStyleEntry;

   function l_TranslateParam(const aStr : Tl3PCharLen;
                             IsLast     : Bool): Bool;
   begin//l_TranslateParam
    Result := true;
    TranslateParam(l3PCharLen2String(aStr), l_StyleEntry);
   end;//l_TranslateParam

  var
   l_Style     : AnsiString;
   l_StyleName : AnsiString;

begin
 Result := true;
 l_Style := Trim(l3PCharLen2String(aStyle));
 if l_Style <> '' then
 begin
  l_StyleName := Trim(Copy(l_Style, 1, Pred(Pos('{', l_Style))));
  l_StyleEntry := f_Document.StyleByName(l_StyleName).Use;

  if l_StyleEntry = nil then
  begin
   l_StyleEntry := TddStyleEntry.Create;
   l_StyleEntry.AsString:= l_StyleName;
   if l_StyleEntry.AsWStr.S[0] = '.' then
    (l_StyleEntry As Tl3CustomString).Delete(0, 1);
  end
  else
   l_StyleEntry.Clear;
  try
   Delete(l_Style, 1, Pos('{', l_Style));
   l3ParseWordsExF(l3PCharLen(l_Style), l3L2WA(@l_TranslateParam), [';']);
   f_Document.AddStyle(l_StyleEntry);
  finally
   l3Free(l_StyleEntry);
  end;//try.finally
 end; 
end;

procedure TddHTMLReader.ParseStyleTable(aStyleTable: AnsiString);
begin
  (* таблица стилей приходит в следующем виде
    имя_стиля{формат_стиля}..
    формат_стиля - параметр:значение;..
   *)
  if aStyleTable <> '' then
   l3ParseWordsEx(l3PCharLen(aStyleTable), ParseStyle, ['}']);
end;

procedure TddHTMLReader.ParseTable(aObj: THTMLTag);
var
  l_TableWidth: LongInt;
  l_TableWidthPerc: Boolean;
  l_Bordered: Boolean;
  l_BorderRule: TddBorderRules;
  j: Integer;
  l_Param: THTMLParam;
  l_Nested: Boolean;
begin
  CloseParagraph;
  Inc(f_NestedLevel);
  l_Nested:= f_Table <> nil;
  l3Free(f_Table);
  f_Table:= TddTable.Create(nil);
  f_Table.Nested:= l_Nested;
  f_Document.Paragraphs.Add(f_Table);
  f_Document.TableOpen:= True;
  l_TableWidth:= f_Document.TextWidth;
  l_TableWidthPerc:= False;
  l_Bordered:= False;
  f_IsTable:= True;
  l_BorderRule:= brUnknown;
  { Вылить параметры таблицы, если они есть }
  for j:= 0 to Pred(aObj.ParamCount) do
  begin

    l_Param:= aObj.Params[j];
    if l_Param.Key = 'BORDER' then
    //This attribute can be used to both control and set the borders
    //to be displayed for the table. If present, then a border will be
    //drawn around all data cells. The exact thickness and display
    //of this default border is at the discretion of individual browsers.
    //If the attribute isn't present, then the border is not displayed,
    //but the table is rendered in the same position as if there were
    //a border (i.e. allowing room for the border). It can also be given
    //a value, i.e. BORDER=<value> which specifies the thickness that
    //the table border should be displayed with. The border value can
    //be set to 0, which regains all the space that the browser has set
    //aside for any borders (as in the case where no border has been
    //set described above)
    begin
      if (l_Param.IntValue <> 0) and (l_BorderRule = brUnknown) then
        l_BorderRule:= brAll;
    end
    else
    if AnsiSameText(l_Param.Key, 'RULES') then
    //none this removes all the internal rules
    //basic this displays horizontal borders between the <THEAD>, <TBODY> and <TFOOT> sections.
    //rows this displays horizontal borders between all rows
    //cols this displays horizontal borders between all columns
    //all this displays all the internal rules.

    begin
      if AnsiSameText(l_Param.Value, 'NONE') then
      begin
        l_BorderRule:= brNone;
      end
      else
      if AnsiSameText(l_Param.Value, 'BASIC') then
      begin
        l_BorderRule:= brBasic;
      end
      else
      if AnsiSameText(l_Param.Value, 'ROWS') then
      begin
        l_BorderRule:= brRows;
      end
      else
      if AnsiSameText(l_Param.Value, 'COLS') then
      begin
        l_BorderRule:= brCols;
      end
      else
      if AnsiSameText(l_Param.Value, 'ALL') then
      begin
        l_BorderRule:= brAll;
      end
    end
    else
    if AnsiSameText(l_Param.Key,'CELLPADDING') then
    //The CELLPADDING is the amount of white space between the borders
    //of the table cell and the actual cell data (whatever is to be
    //displayed in the cell). It defaults to an effective value of 1
    begin
    end
    else
    if AnsiSameText(l_Param.Key,'CELLSPACING') then
    //The CELLSPACING is the amount of space inserted between individual
    //table data cells. It defaults to an effective value of 2.
    begin
    end
    else
    if AnsiSameText(l_Param.Key, 'WIDTH') then
    //If used, this attribute can specify either the exact width
    //of the table in pixels, or the width of the table as a percentage
    //of the browser display window.
    begin
      l_TableWidth:= l_Param.IntValue;
      l_TableWidthPerc:= l_Param.IsPercent;
    end;
    (*
    HEIGHT="value or percent"
    If used, this attribute can specify either the exact height of the table in pixels, or the height of the table as a percentage of the browser display window.

    ALIGN="left|right"
    Some browsers (Internet Explorer and Netscape) support
    the ALIGN attribute to the <TABLE> element. Like that used for
    floating images, it allows a table to be aligned to the left or
    right of the page, allowing text to flow around the table. Also,
    as with floating images, it is necessary to have knowledge of
    the <BR CLEAR= ..> element, to be able to organise the text
    display so as to minimise poor formatting.

    VALIGN="top|bottom|center"
    The Internet Explorer and Netscape support this attribute
    that specifies the vertical alignment of the text displayed in
    the table cells. The default (which is also used if the attribute
    is not set is centre-aligned.)

    BGCOLOR="#rrggbb|colour name"
    Internet Explorer and Netscape support use of this attribute (
    also supported in the <BODY> element). It allows the background
    colour of the table to be specified, using either the specified
    colour names, or a rrggbb hex triplet.

    BORDERCOLOR="#rrggbb|colour name"
    Internet Explorer includes support for this attribute which
    sets the border colour of the table. Any of the pre-defined colour
    names can be used, as well as any colour defined by
    a rrggbb hex triplet. It is necessary for the BORDER attribute
    to be present in the main <TABLE> element for border colouring to work.

    *)
  end;
  if l_TableWidthPerc then
   f_Table.Width:= l3MulDiv(f_Document.TextWidth, l_tableWidth, 100)
  else
   f_Table.Width:= l_TableWidth;
end;

function TddHTMLReader.pm_GetDefAlign: Integer;
begin
 Result := f_Align.Last;
end;

procedure TddHTMLReader.pm_SetDefAlign(const Value: Integer);
begin
 f_Align.Add(Value);
end;

procedure TddHTMLReader.RestoreDefAlign;
begin
 f_Align.DeleteLast;
end;

procedure TddHTMLReader.SetDefAlign(aParam: THTMLParam);
var
 i: Integer;
begin
 for i:= 0 to Pred(aParam.ValueCount) do
  if AnsiSameText('left', aParam.Values[i]) then
   DefAlign:= ord(justL)
  else
  if AnsiSameText('right', aParam.Values[i]) then
   DefAlign:= ord(justR)
  else
  if AnsiSameText('center', aParam.Values[i]) then
   DefAlign:= ord(justC)
  else
  if AnsiSameText('justify', aParam.Values[i]) then
   DefAlign:= ord(justF)
end;

procedure TddHTMLReader.StartSegment;
begin
 if not f_IsPara then
  OpenParagraph;
 f_Document.LastPara.AddSegment(f_CHP, True);
end;

procedure TddHTMLReader.TranslateParam(aParam: AnsiString; aStyle: TddStyleEntry);
var
  l_ParamName, l_ParamValue: AnsiString;
  l: Integer;
  l_Margin: Integer;
begin
   {параметр:значение;}
  l:= Pos(':', aParam);
  l_ParamName:= Copy(aParam, 1, Pred(l));
  l_ParamValue:= Copy(aParam, Succ(l), Length(aParam)-l);
  if l_ParamName = 'font-size' then
   aStyle.CHP.FontSize:= ConvertFontSize(l_ParamValue)
  else
  if l_ParamName = 'font-family' then
   (*
   font-family
   Value: [[<family-name> | <generic-family>],]* [<family-name> | <generic-family>]
   Initial: UA specific
   Applies to: all elements
   Inherited: yes
   Percentage values: N/A
   *)
  begin
   aStyle.CHP.FontNumber:= f_Document.AddFont(l_ParamValue);
   aStyle.CHP.FontName:= l_ParamValue;
  end
  else
  if l_ParamName = 'font-weight' then
   (*
   font-weight
   Value: normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900
   Initial: normal
   Applies to: all elements
   Inherited: yes
   Percentage values: N/A
   *)
  begin
   aStyle.CHP.Bold:= l_ParamValue <> 'normal';
  end
  else
  if l_ParamName = 'font-style' then
   (*
   font-style
   Value: normal | italic | oblique
   Initial: normal
   Applies to: all elements
   Inherited: yes
   Percentage values: N/A
   *)
   aStyle.CHP.Italic:= l_ParamValue <> 'normal'
  else
  if l_ParamName = 'color' then
   (*
   color
   Value: <color>
   Initial: UA specific
   Applies to: all elements
   Inherited: yes
   Percentage values: N/A
   *)
   aStyle.CHP.FColor:= ConvertColor(l_ParamValue)
  else
  if l_ParamName = 'background-color' then
   (*
   background-color
   Value: <color> | transparent
   Initial: transparent
   Applies to: all elements
   Inherited: no
   Percentage values: N/A
   *)
   aStyle.CHP.BColor:= ConvertColor(l_ParamValue)
  (*
  text-decoration
  Value: none | [ underline || overline || line-through || blink ]
  Initial: none
  Applies to: all elements
  Inherited: no, but see clarification below
  Percentage values: N/A
  *)
  else
  if Pos('margin', l_ParamName) <> 0 then
   (*
   margin-left, margin-right, margin-top, margin-bottom, margin
   Value: [ <length> | <percentage> | auto ]{1,4} (for 'margin' property)
   Initial: 0
   Applies to: all elements
   Inherited: no
   Percentage values: refer to parent's width
   *)
  begin
   l_Margin:= ConvertMargin(l_ParamValue);
   if l_ParamName = 'margin-left' then
    aStyle.PAP.xaLeft:= l_Margin
   else
   if l_ParamName = 'margin-right' then
    aStyle.PAP.xaRight:= l_Margin
   else
   if l_ParamName = 'margin-top' then
    aStyle.PAP.Before:= l_Margin
   else
   if l_ParamName = 'margin-bottom' then
    aStyle.PAP.After:= l_Margin
   else
   if l_ParamName = 'margin' then
   begin
    aStyle.PAP.xaLeft:= l_Margin;
    aStyle.PAP.xaRight:= l_Margin;
    aStyle.PAP.Before:= l_Margin;
    aStyle.PAP.After:= l_Margin;
   end;
  end;
end;

procedure TddHTMLReader.WorkupB(aTag: THTMLTag);
begin
 if aTag.IsClosed then
 begin
  CloseSegment;
  f_CHP.Bold:= False;
 end
 else
 begin
  f_CHP.Bold:= True;
  StartSegment;
 end;
end;

procedure TddHTMLReader.workupBody(aTag: THTMLTag);
begin
 f_IsBody:= not aTag.isClosed;
end;

procedure TddHTMLReader.WorkupBR;
begin
 if f_Document.LastPara <> nil then
  f_Document.LastPara.Text.Append(cc_SoftEnter);
end;

procedure TddHTMLReader.workupDiv(atag: ThtmlTag);
var
 j, k: Integer;
 l_Param: ThtmlParam;
begin
 OpenParagraph;
 CloseParagraph;
 (*
 if aTag.IsClosed then
 begin
  // Сбросить параметры
  RestoreDefAlign;
 end
 else
 begin
  // Нужно выставить умолчательные значения на основании параметров тэга
  for j:= 0 to Pred(aTag.ParamCount) do
  begin
   l_Param:= aTag.Params[j];
   if AnsiSameText(l_Param.Key, 'align') then
    SetDefAlign(l_Param);
  end; // for j
 end;
 *) 
end;

procedure TddHTMLReader.workupHTML(atag: ThtmlTag);
begin
 if aTag.IsClosed then
 begin
  f_IsBody:= False;
  BreakAnalyze;
 end;
end;

procedure TddHTMLReader.WorkupHN(aTag: THTMLTag);
begin
 if aTag.IsClosed then
 begin
  f_IsHeader:= False;
  f_Document.LastPara.PAP.Style:= f_HeaderStyle;
  f_HeaderStyle:= ev_saEmpty;
 end
 else
 begin
  case aTag.TagID of
   tidH1: f_HeaderStyle:= ev_saTxtHeader1;
   tidH2: f_HeaderStyle:= ev_saTxtHeader2;
   tidH3: f_HeaderStyle:= ev_saTxtHeader3;
  else
   f_HeaderStyle:= ev_saTxtHeader4;
  end;
  f_IsHeader:= True;
 end;
end;

procedure TddHTMLReader.WorkupI(atag: ThtmlTag);
begin
 if aTag.IsClosed then
 begin
  CloseSegment;
  f_CHP.Italic:= False;
 end
 else
 begin
  f_CHP.Italic:= True;
  StartSegment;
 end;
end;

procedure TddHTMLReader.WorkupLI(aTag: THTMLTag);
begin
 if not aTag.IsClosed then
  OpenParagraph;
end;

procedure TddHTMLReader.WorkupMeta(aTag: THTMLTag);
var
 j: Integer;
 l_Int: Integer;
 k: Integer;
 l_S: AnsiString;
 l_Param: ThtmlParam;
begin
 if not aTag.IsClosed then
  for j:= 0 to Pred(aTag.ParamCount) do
  begin
    l_Param:= aTag.Params[j];
    for k:= 0 to Pred(l_Param.ValueCount) do
    begin
      l_Int:= Pos('CHARSET', UpperCase(l_Param.Values[k]));
      if l_Int <> 0 then
      begin
        l_S:= Copy(l_Param.Values[k], l_int+8, Length(l_Param.Values[k]));
        if AnsiSameText(l_S, 'WINDOWS-1251') then
          f_CodePage:= cp_Ansi
        else
        if AnsiSameText(l_S, 'KOI8-R') then
          f_CodePage:= cp_koi8
        else
        if AnsiSameText(l_S, 'UTF-8') then
         f_CodePage:= CP_UTF8;
      end; // Pos
    end; // for k
  end; // for j;
end;

procedure TddHTMLReader.WorkupOL(aTag: THTMLTag);
var
 j: Integer;
 l_Param: ThtmlParam;
 l_List2: TddParaList;
begin
 if aTag.IsClosed then
  CloseList
 else
 begin
  if f_List <> nil then
  begin
    CloseParagraph;
    l_List2:= TddParaList.Create(nil);
    try
      l_List2.ListType:= ltUnordered;
      for j:= 0 to Pred(aTag.ParamCount) do
      begin
        l_Param:= aTag.Params[j];
        if l_Param.Key = 'TYPE' then
        begin
        end
        else
        if l_Param.Key = 'START' then
        begin
        end;
      end;
      f_List.AddList(l_List2);
    finally
      l3Free(l_List2);
    end;
  end
  else
  begin
    f_List:= TddParaList.Create(nil);
    f_List.ListType:= ltOrdered;
    f_Document.Paragraphs.Add(f_List);
  end;
  for j:= 0 to Pred(aTag.ParamCount) do
  begin
    l_Param:= aTag.Params[j];
    if l_Param.Key = 'TYPE' then
    begin
    end
    else
    if l_Param.Key = 'START' then
    begin
    end;
  end;
 end;
end;

procedure TddHTMLReader.WorkupP(aTag: THTMLTag);
begin
 if aTag.IsClosed then
 begin
  if f_IsPara then
  begin
   BeforeCloseParagraph;
   CloseParagraph;
   f_Pre:= False;
  end
 end
 else
 begin
  ParseParagraph(aTag);
  f_Pre:= aTag.TagID = tidPRE;
 end;
end;

procedure TddHTMLReader.WorkupSpan(aTag: THTMLTag);
begin
 if aTag.IsClosed then
  ParseSpan(aTag)
 else
 begin
  if not f_IsPara then
   OpenParagraph;
  f_Document.LastPara.AddSegment(f_CHP, True);
 end;
end;

procedure TddHTMLReader.WorkupStyle(aTag: THTMLTag);
begin
 if aTag.IsClosed then
 begin
  f_IsBody:= f_SaveIsBody;
  f_IsStyle:= False;
 end
 else
 begin
  f_SaveIsBody:= f_IsBody;
  f_IsBody:= False;
  f_IsStyle:= True;
 end;
end;

procedure TddHTMLReader.WorkupTable(aTag: THTMLTag);
begin
 if aTag.IsClosed then
  CloseTable
 else
  ParseTable(aTag);
end;

procedure TddHTMLReader.WorkupA(aTag: THTMLTag);


var
 l_Param: THTMLParam;
 j: integer;
 iPos: integer;
 sTemp: AnsiString;
 l_RegRef: Tl3RegularSearch;
 lREPosition: Tl3MatchPosition;


begin
 if aTag.IsClosed then
  CloseHyperlink
 else
 begin
  OpenHyperlink(aTag);
 end;

end;

procedure TddHTMLReader.WorkupTag(aTag: THTMLTag);
var
  l_IsStyle: Boolean;
  j: Integer;
  l_Int: Integer;
  k: Integer;
  l_S: AnsiString;
  l_Param: ThtmlParam;
  l_SaveIsBody: Boolean;
  l_List2: TddParaList;
 l_IsBody: Boolean;
begin
 case aTag.TagID of
  tidP, tidPRE: WorkupP(aTag);
  tidB, tidSTRONG: WorkupB(aTag);
  tidI: WorkupI(aTag);
  tidU: WorkupU(aTag);
  tidSPAN: WorkupSpan(aTag);
  tidFONT: if not Lite then ParseFont(aTag);
  tidH1, tidH2, tidH3, tidH4: WorkupHN(aTag);
  tidTABLE: WorkupTable(aTag);
  tidTR: WorkupTR(aTag);
  tidTD: WorkupTD(aTag);
  tidBR: WorkupBR;
  tidUL: WorkupUL(aTag);
  tidOL: WorkupOL(aTag);
  tidLI: WorkupLI(aTag);
  tidBODY: WorkupBody(aTag);
  tidMETA: WorkupMeta(aTag);
  tidTITLE: WorkupTitle(aTag);
  tidDIV: workupDiv(atag);
  tidSTYLE: WorkupStyle(aTag);
  tidHTML: WorkupHTML(aTag);
  tidA: WorkupA(aTag);
 end;
end;

procedure TddHTMLReader.WorkupTD(aTag: THTMLTag);
begin
 if atag.IsClosed then
  CloseCell
 else
  ParseCell(aTag);
end;

procedure TddHTMLReader.WorkupText(aText: THTMLText);
var
  l_IsStyle: Boolean;
  l_S  : String;
  l_S1 : AnsiString;
  l_Text: Tl3String;
  l_CloseAfter: Boolean;
begin
{ TODO : Нужно провести рефакторинг }
  if f_IsBody then
  begin
   if not f_IsPara and (aText.Line <> ' ') and
      ((f_Table = nil) and ((not f_SpecText) or f_IsHeader) or
      ((f_Table <> nil) and (f_Table.LastRow.CellCount > 0))) then
   begin
    OpenParagraph;
    //l_CloseAfter:= True;
   end;

   {!!! Предусмотреть перекодировку русского текста }
   if f_IsPara then
   begin
     if not f_SpecText then
     begin

       if (f_CodePage <> cp_Ansi) then
       begin
         if f_CodePage = cp_UTF8 then
         begin
          L_S1:= AnsiReplaceText(aText.Raw, #13#10, ' ');
(*          TryUTF8ToString(aText.Raw,L_S1);
          L_S1:= AnsiReplaceText(L_S1, #13#10, ' ');*)
          l_S1:= AnsiReplaceText(l_S1, '&nbsp;', AnsiToUtf8(cc_SoftSpace){#$c2#$a0});
          l_S1:= AnsiReplaceText(l_S1, '&quot;', AnsiToUtf8(cc_DoubleQuote));
          l_S1:= AnsiReplaceText(l_S1, '&apos;',  AnsiToUtf8(cc_SingleQuote));
          l_S1:= AnsiReplaceText(l_S1, '&amp;', AnsiToUtf8(cc_Ampersand));
          l_S1:= AnsiReplaceText(l_S1, '&lt;', '<');
          l_S1:= AnsiReplaceText(l_S1, '&gt;', '>');
          l_S1:= AnsiReplaceText(l_S1, '&iexcl;', AnsiToUtf8(cc_IExclMark)); //  inverted exclamation mark
          l_S1:= AnsiReplaceText(l_S1, '&cent;', AnsiToUtf8(cc_CentSign)); //  cent
          l_S1:= AnsiReplaceText(l_S1, '&pound;', AnsiToUtf8(cc_PoundSing)); //  pound
          l_S1:= AnsiReplaceText(l_S1, '&curren;', AnsiToUtf8(cc_CurrencySign));
          l_S1:= AnsiReplaceText(l_S1, '&yen;', AnsiToUtf8(cc_YenSign)); //  yen
          l_S1:= AnsiReplaceText(l_S1, '&brvbar;', AnsiToUtf8(cc_BrokenBar));
          l_S1:= AnsiReplaceText(l_S1, '&sect;', AnsiToUtf8(cc_Section));
          l_S1:= AnsiReplaceText(l_S1, '&uml;', AnsiToUtf8(cc_Uml)); //  spacing diaeresis
          l_S1:= AnsiReplaceText(l_S1, '&copy;', AnsiToUtf8(cc_Copyright));
          l_S1:= AnsiReplaceText(l_S1, '&ordf;', AnsiToUtf8(cc_OrdF)); //  feminine ordinal indicator
          l_S1:= AnsiReplaceText(l_S1, '&laquo;', AnsiToUtf8(cc_LDoubleQuote));
          l_S1:= AnsiReplaceText(l_S1, '&not;', AnsiToUtf8(cc_NotSign));
          l_S1:= AnsiReplaceText(l_S1, '&shy;', AnsiToUtf8(cc_SoftHyphen));
          l_S1:= AnsiReplaceText(l_S1, '&reg;', AnsiToUtf8(cc_Registered));
          l_S1:= AnsiReplaceText(l_S1, '&macr;', AnsiToUtf8(cc_Macron)); //  spacing macron
          l_S1:= AnsiReplaceText(l_S1, '&deg;', AnsiToUtf8(cc_Degree));
          l_S1:= AnsiReplaceText(l_S1, '&plusmn;', AnsiToUtf8(cc_PlusMinus));
          l_S1:= AnsiReplaceText(l_S1, '&sup2;', AnsiToUtf8(cc_Sup2)); //  superscript 2
          l_S1:= AnsiReplaceText(l_S1, '&sup3;', AnsiToUtf8(cc_Sup3)); //  superscript 3
          l_S1:= AnsiReplaceText(l_S1, '&acute;', AnsiToUtf8(cc_Acute)); //  spacing acute
          l_S1:= AnsiReplaceText(l_S1, '&micro;', AnsiToUtf8(cc_Micro));
          l_S1:= AnsiReplaceText(l_S1, '&para;', AnsiToUtf8(cc_Para));
          l_S1:= AnsiReplaceText(l_S1, '&middot;', AnsiToUtf8(cc_MidDot));
          l_S1:= AnsiReplaceText(l_S1, '&cedil;', AnsiToUtf8(cc_Cedil)); //  spacing cedilla
          l_S1:= AnsiReplaceText(l_S1, '&sup1;', AnsiToUtf8(cc_Sup1)); //  superscript 1
          l_S1:= AnsiReplaceText(l_S1, '&ordm;', AnsiToUtf8(cc_ordM)); //  masculine ordinal indicator
          l_S1:= AnsiReplaceText(l_S1, '&raquo;', AnsiToUtf8(cc_RDoubleQuote));
          l_S1:= AnsiReplaceText(l_S1, '&frac14;', AnsiToUtf8(cc_Frac14)); //  fraction 1/4
          l_S1:= AnsiReplaceText(l_S1, '&frac12;', AnsiToUtf8(cc_Frac12)); //  fraction 1/2
          l_S1:= AnsiReplaceText(l_S1, '&frac34;', AnsiToUtf8(cc_Frac34)); //  fraction 3/4
          l_S1:= AnsiReplaceText(l_S1, '&iquest;', AnsiToUtf8(cc_IQuest)); //  inverted question mark
          l_S1:= AnsiReplaceText(l_S1, '&divide;', AnsiToUtf8(cc_Divide)); //  division
          l_S1:= AnsiReplaceText(l_S1, '&mdash;', AnsiToUtf8('—')); //
          l_S1:= AnsiReplaceText(l_S1, '&ndash;', AnsiToUtf8('–')); //

          l_S1:= AnsiReplaceText(l_S1, '&lsaquo;', AnsiToUtf8('‹')); //
          l_S1:= AnsiReplaceText(l_S1, '&rsaquo;', AnsiToUtf8('›')); //
          l_S1:= AnsiReplaceText(l_S1, '&lsquo;', AnsiToUtf8('‘')); //
          l_S1:= AnsiReplaceText(l_S1, '&rsquo;', AnsiToUtf8('’')); //

          l_S1:= AnsiReplaceText(l_S1, '&ldquo;', AnsiToUtf8('“')); //
          l_S1:= AnsiReplaceText(l_S1, '&rdquo;', AnsiToUtf8('”')); //

          // Пока удаляем
          l_S1:= AnsiReplaceText(l_S1, '&times;', ''); //  multiplication

          if TryUTF8ToString(l_S1, l_S) then
           f_Document.LastPara.AddText(l_S)
          else
           f_Document.LastPara.AddText(aText.Line)
         end
         else
         begin
          l_Text:= Tl3String.Make(f_CodePage);
          try
            l_Text.AsString:= aText.Line;
            l_Text.CodePage:= cp_ANSI;
            f_Document.LastPara.AddText(l_Text);
          finally
            l3Free(l_Text);
          end; // try.finally
         end;
       end
       else

       begin
        if not f_Pre then
        begin
         l_S:= aText.Line;
         l_S:= AnsiReplaceStr(l_S, cc_HardSpace+cc_HardSpace, cc_HardSpace);
         f_Document.LastPara.AddText(l_S);
        end
        else
         f_Document.LastPara.AddText(aText.Line)
       end;
     end; // SpecText
   end; // OpenPara
  end // IsBody
  else
  if f_IsStyle then
   ParseStyleTable(aText.Line);
end;

procedure TddHTMLReader.WorkupTitle(aTag: THTMLTag);
begin
 if aTag.IsClosed then
  f_SpecText:= False
 else
  f_SpecText:= True;
end;

procedure TddHTMLReader.workupTR(aTag: THTMLTag);
begin
 if aTag.IsClosed then
  CloseRow
 else
  ParseRow(aTag);
end;

procedure TddHTMLReader.WorkupU(aTag: THTMLTag);
begin
 if atag.IsClosed then
  f_CHP.Underline:= utNone
 else
  f_CHP.Underline:= utThick;
 if aTag.IsClosed then
  CloseSegment
 else
  StartSegment;
end;

procedure TddHTMLReader.WorkupUL(aTag: THTMLTag);
var
 j: Integer;
 l_Param: ThtmlParam;
 l_List2: TddParaList;
begin
 if aTag.IsClosed then
  CloseList
 else
 begin
   if f_List <> nil then
   begin
     CloseParagraph;
     l_List2:= TddParaList.Create(nil);
     try
       l_List2.ListType:= ltUnordered;
       f_List.AddList(l_List2);
     finally
       l3Free(l_List2);
     end;
   end
   else
   begin
     f_List:= TddParaList.Create(nil);
     f_List.ListType:= ltUnordered;
     f_Document.Paragraphs.Add(f_List);
   end;
 end;
end;

end.
