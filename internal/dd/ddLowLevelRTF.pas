unit ddLowLevelRTF;

{ $Id: ddLowLevelRTF.pas,v 1.54 2013/04/11 16:46:27 lulin Exp $ }

// $Log: ddLowLevelRTF.pas,v $
// Revision 1.54  2013/04/11 16:46:27  lulin
// - отлаживаем под XE3.
//
// Revision 1.53  2013/04/05 12:04:29  lulin
// - портируем.
//
// Revision 1.52  2013/01/22 12:19:52  narry
// Рефакторинг RTFReader
//
// Revision 1.51  2011/09/21 12:30:06  narry
// Пропадают куски текста при форматировании (285510478)
//
// Revision 1.50  2011/05/10 17:14:47  lulin
// {RequestLink:236719181}.
// №24.
//
// Revision 1.49  2011/02/09 11:34:21  narry
// К253657673. Чтение картинок из RTF
//
// Revision 1.48  2010/03/15 18:08:41  lulin
// {RequestLink:196969151}.
//
// Revision 1.47  2010/02/24 18:16:27  lulin
// - избавляемся от ненужного и вредного параметра, доставшегося в наследство от ошибок молодости.
//
// Revision 1.46  2009/06/24 10:58:27  narry
// - русско-японские RTF от OpenOffice
//
// Revision 1.45  2008/10/20 07:52:45  narry
// - не накапливается картинка в режиме Lite
//
// Revision 1.44  2008/04/09 13:51:15  narry
// - рефакторинг
// - замена символов буллета на (*, о, #)
//
// Revision 1.43  2008/03/21 14:09:21  lulin
// - cleanup.
//
// Revision 1.42  2008/02/20 17:22:58  lulin
// - упрощаем строки.
//
// Revision 1.41  2008/02/14 09:40:33  lulin
// - удалён ненужный класс.
//
// Revision 1.40  2008/02/13 20:20:06  lulin
// - <TDN>: 73.
//
// Revision 1.39  2008/02/06 15:37:00  lulin
// - каждому базовому объекту по собственному модулю.
//
// Revision 1.38  2008/02/05 09:58:00  lulin
// - выделяем базовые объекты в отдельные файлы и переносим их на модель.
//
// Revision 1.37  2008/02/01 15:14:44  lulin
// - избавляемся от излишней универсальности списков.
//
// Revision 1.36  2007/02/12 16:40:34  lulin
// - переводим на строки с кодировкой.
//
// Revision 1.35  2007/01/19 14:35:22  oman
// - new: Локализация библиотек - dd (cq24078)
//
// Revision 1.34  2006/12/29 13:09:25  lulin
// - реализуем интерфейс расширенного списка строк.
//
// Revision 1.33  2006/04/24 12:58:41  lulin
// - выпиливаем из списков общую функциональность.
//
// Revision 1.32  2005/05/06 08:39:17  fireton
// - профайлинг и оптимизация по скорости
//
// Revision 1.31  2004/09/21 12:21:05  lulin
// - Release заменил на Cleanup.
//
// Revision 1.30  2004/06/01 16:51:23  law
// - удален конструктор Tl3VList.MakePersistent - пользуйтесь _Tl3ObjectRefList.
//
// Revision 1.29  2004/04/26 14:28:20  law
// - new behavior: Tl3Filer теперь при чтении посимвольно учитывает кодировку.
// - bug fix: в свойство TevMemo.Buffer теперь нормально присваиваются строки с кодировкой Unicode.
//
// Revision 1.28  2004/01/16 10:10:11  narry
// - update
//
// Revision 1.27  2003/04/19 12:30:37  law
// - new file: ddDefine.inc.
//
// Revision 1.26  2002/09/19 13:09:15  narry
// - remove unit: ddHTML.
//
// Revision 1.25  2002/09/09 15:36:23  law
// - bug fix: не вызывался метод NextToken*.
//
// Revision 1.24  2002/09/09 13:52:19  narry
// - cleanup
//
// Revision 1.23  2001/11/22 13:58:43  narry
// - update : начало реализации Групп доступа
//
// Revision 1.22  2001/06/28 15:02:42  law
// - cleanup: убраны связи с RX.
//
// Revision 1.21  2001/05/30 09:11:18  law
// - new behavior: пытаемся централизовать обработку ошибок чтения документов.
//
// Revision 1.20  2001/05/29 09:39:36  narry
// Bug fix - работа с текстом
//
// Revision 1.19  2001/05/28 15:35:39  narry
// Update - чтение уникодного текст
//
// Revision 1.18  2001/05/16 10:48:31  narry
// Update - установление Status в случае ошибки чтения
//
// Revision 1.17  2001/04/09 14:05:12  narry
// Bug Fix - исправление обработки уникодного текст
//
// Revision 1.16  2001/01/19 12:26:03  narry
// Fix trouble with broken documents
//
// Revision 1.15  2000/12/18 10:53:46  narry
// Fix Lost text and soft hyph
//
// Revision 1.14  2000/12/15 15:29:54  law
// - вставлены директивы Log и Id.
//

{$I ddDefine.inc }

{.$DEFINE SearchFor}
interface

uses
  SysUtils,
  Classes,
  Graphics,

  l3Types,
  l3Base,
  l3Chars,
  l3KeyWrd,
  l3Parser,

  l3Stream,

  k2TagGen,
  k2Reader,

  RTFTypes, ddRTFKeywords, ddRTFObjects,
  l3ObjectRefList
  ;
  
type

  ERTFException = class(Exception)
    Code: Integer;
    Descript: AnsiString;
  end;{ERTFException}


  TddRTFKeywordEvent = procedure (Sender: TObject; Keyword: Long; KeywordName: AnsiString; Param: Long; HasParam: Boolean) of object;
  TddRTFTextEvent    = procedure (Sender: TObject; Text: Tl3String) of object;
  TddRTFSymbolEvent  = procedure (Sender: TObject; Symbol: AnsiChar) of object;
  TddRTFGroupEvent   = procedure (Sender: TObject; OpenGroup: Boolean) of object;

  TddRTFParser = class(Tk2CustomFileParser)
    private
    {internal fields}
      FStatus      : TRTFErrorCode;
      f_Param      : Tl3String;
      f_Text       : Tl3String;
      f_Negative   : Boolean;
      f_HasParam   : Boolean;
      f_Content    : TddRTFAtom;
      f_Stack      : Tl3ObjectRefList;
      f_Hex        : Boolean;
      f_SkipUnknown: Boolean;
      f_LongParam  : Longint;
      f_MyParser_   : Tl3CustomParser;
      {------- Debug}
      f_OnKeyword   : TddRTFKeywordEvent;
      f_OnText      : TddRTFTextEvent;
      f_OnSymbol    : TddRTFSymbolEvent;
      f_LiteVersion: Boolean;
      f_SkipData: Boolean;
      function GetCurGroup: TddRTFAtom;
      procedure SetLiteVersion(Value: Boolean);
    private
    { первый проход }
      procedure SetGroupByKeyword(Keyword: Long; aAtom: TddRTFAtom);
      function  GetGroupByKeyword(Keyword: Long): TddRTFAtom;
      procedure SetParam(aParam: Tl3String);
    private
      function GetLongParam: Long;
      procedure _ReadData;

      property CurGroup : TddRTFAtom
        read GetCurGroup;
      property Param: Tl3String
        read f_Param write SetParam;
      property LongParam: Long
        read f_LongParam;

      property HasParam: Boolean
        read f_HasParam write f_HasParam;
      property Negative: Boolean
        read f_Negative write f_Negative;
    protected
    {internal fields}
     SkipNext : Boolean;
     ReadData : Boolean;
    protected
    {internal methods}
      procedure ParseKeyword; virtual;
      procedure ParseUnknownKeyword; virtual;
      procedure ReadParam; virtual;
      procedure ReadText; virtual;



      procedure PushState; virtual;
      procedure PopState; virtual;
      procedure AddKeyword(aKeyword: TSYM; aHasParam: Boolean; aParam: Long; aText: Tl3String = nil);
          virtual;
      procedure AddText(aText: Tl3String); overload;  virtual;
      procedure AddText(aText: AnsiChar); overload;  virtual;
      procedure AddText(aText: Word); overload;  virtual;

      procedure Cleanup; override;
    public
    { public methods }
      constructor Create(anOwner: Tk2TagGeneratorOwner);
        override;
      procedure AddData(aStream: TStream); virtual;
        {-}
      procedure Read; override;

    public
    {public properties}
        {-}
      property LiteVersion: Boolean read f_LiteVersion write SetLiteVersion;

      property Status : TRTFErrorCode
        read FStatus write FStatus;
      property Content: TddRTFAtom
        read f_Content write f_Content;
      property GroupByKeyword[Keyword: Long]: TddRTFAtom
        read GetGroupByKeyword write SetGroupByKeyword;
      property SkipData: Boolean read f_SkipData write f_SkipData;
      property SkipUnknown: Boolean
        read f_SkipUnknown write f_SkipUnknown;


      property OnKeywordFound : TddRTFKeywordEvent
        read f_OnKeyword write f_OnKeyword;
      property OnTextFound : TddRTFTextEvent
        read f_OnText write f_OnText;
      property OnSymbolFound : TddRTFSymbolEvent
        read f_OnSymbol write f_OnSymbol;

        {-}
  end;{TddRTFParser}


implementation

uses
  l3String,
  ddRTFConst
  {$IfNDef l3ConsoleApp}
  , Dialogs
  {$ENDIF}
  , l3Memory;

const
  ParamDelims = ['{', '}', '\'];
  AdditionalWords = [cc_SingleQuote, cc_Austerisk, cc_Minus, cc_Colon, cc_Slash, cc_Underline, '{', '|', '}', '~'];

{ start class TddRTFParser }

constructor TddRTFParser.Create(anOwner: Tk2TagGeneratorOwner);
begin
 inherited Create(anOwner);
 FStatus:= ecOk;

 with Parser do
 begin
   //KeyWords:= RTFKeywords;
   WordChars:= ['A'..'Z','a'..'z'] {+ AdditionalWords} ;
   LineComment := '';
   OpenComment := '';
   CloseComment := '';
   WhiteSpace:= [cc_Null .. Pred(cc_HardSpace)]-[#10,#13];
   CheckFloat:= False;
   CheckInt:= False;
   CheckHex:= False;
   AddDigits2WordChars:= False;
 end;
 f_LiteVersion:= False;
 //Parser:= Parser;
 f_Param:= Tl3String.Create;
 f_Text:= Tl3String.Create;
 f_Stack:= Tl3ObjectRefList.Make;
 f_SkipUnknown:= {False}True;
end;

procedure TddRTFParser.AddData(aStream: TStream);
begin
end;

procedure TddRTFParser.SetLiteVersion(Value: Boolean);
begin
  if Value <> f_LiteVersion then
  begin
    f_LiteVersion:= Value;
    if Parser.Keywords <> nil then
    begin
      if f_LiteVersion then
        Parser.Keywords:= RTFKeywordsLite
      else
        Parser.Keywords:= RTFKeywords;
      //f_MyParser:= Parser;
    end;
  end;
end;

procedure TddRTFParser.Cleanup;
begin
  l3Free(f_Stack);
  l3Free(f_Content);
  l3Free(f_Param);
  l3Free(f_Text);
  inherited;
end;

procedure TddRTFParser.Read;
var
 l_C: AnsiChar;
 l_Buffer: Tl3String;
 l_BlockLen: Integer;
begin  { Read }
  if Parser.Keywords = nil then
  begin
   if f_LiteVersion then
    Parser.Keywords:= RTFKeywordsLite
   else
    Parser.Keywords:= RTFKeywords;
   //f_MyParser:= Parser;
  end;
  ReadData:= False;
  Parser.CheckKeywords:= False;
  //try
    Parser.NextTokenSp;
    while (Parser.TokenType <> l3_ttEOF) do
    begin
     if ReadData and (Parser.TokenChar in [#10,#13,'0'..'9', 'a'..'f']) then
      _ReadData
     else // ReadData
     begin
      case Parser.TokenType of
        l3_ttEOL       : ;
        l3_ttSingleChar: ReadText; {-единичный (управляющий) символ}
        l3_ttSymbol    : ReadText;     {-идентификатор}
        l3_ttKeyWord   : ParseKeyWord;     {-ключевое слово}
        l3_ttString    : ;     {-строка (в кавычках)}
        l3_ttInteger   : ;    {-целое число}
        l3_ttFloat     : ;     {-вещественное число}
      end;
      Parser.NextTokenSp;
     end; // not ReadData
    end; { while not Filer.EOF }
  //except
  // on E: Exception do
  // begin
  //  l3System.Exception2Log(E);
  //  Error('Error reading file', false);
  // end;
  //end; { try..except }
end; { Read }

procedure TddRTFParser.ReadText;
var
 l_TokenChar: AnsiChar;
  KW: TSYM;
begin
  if Parser.TokenType = l3_ttSingleChar then
  begin
    l_TokenChar := Parser.TokenChar;
    if (l_TokenChar in ParamDelims) and not Parser.CheckKeywords then
    begin
      if not f_Text.Empty then
      begin
        AddText(f_Text);

        if Assigned(f_OnText) then
          f_OnText(Self, f_Text);
      end;
      case l_TokenChar of
       '\':
           begin
             Parser.CheckKeywords:= True;
             f_Hex:= False;
           end;
       '{': begin
             PushState;
             if Assigned(f_OnKeyword) then
              f_OnKeyword(Self, MaxInt, '{', 0, False);
            end;
       '}': begin
             PopState;
             if Assigned(f_OnKeyword) then
              f_OnKeyword(Self, MaxInt, '}', 0, False);
            end;
      end; // case
      f_Text.Clear;
    end
    else
    if Parser.CheckKeywords and (l_TokenChar in AdditionalWords) then
    begin
        begin
          KW:= TSYM(Parser.Keywords.KeyWordByName[l_TokenChar]);
          if KW <> nil then
          begin
            f_Hex:= KW.StringID = valu_Hex;
            if KW.Kwd = kwdValu then ReadParam;
            if Assigned(f_OnKeyword) then
             f_OnKeyword(Self, KW.StringID, KW.AsString, LongParam, HasParam);
            AddKeyword(KW, HasParam, LongParam);
          end;
          Parser.CheckKeywords:= False;
        end
    end
    else
    if not (l_TokenChar in [#10,#13]) then
    begin
     if SkipNext then
       SkipNext:= False
     else
       //f_Text.Append(l_TokenChar);
       AddText(l_TokenChar);
    end
  end
  else { l3_ttSingleChar }
  if Parser.TokenType = l3_ttSymbol then
  begin
    if Parser.CheckKeywords then
    begin { Насколько я понимаю, сюда мы попадаем лишь в случае неизвестного ключевого слова }
      {ReadParam;
      Parser.CheckKeywords:= False;}
      ParseUnknownKeyword;
    end
    else
    begin
      if not SkipNext then
        //f_Text.JoinWith(Parser.TokenLongString)
        AddText(Parser.TokenLongString)
      else
        SkipNext:= False;
    end;
  end;
end;

procedure TddRTFParser.ReadParam;
var
  Ch: AnsiChar;
  HexCount: Byte;
  l_S: String[255];
  I : Integer;

  // процедура добавления символа в строку
  // нужна для ускорения процесса
  procedure _AddChar(C: AnsiChar);
  begin
   Inc(Byte(l_S[0]));
   l_S[Byte(l_S[0])] := C;
  end;

begin
  //Param.Clear;

  l_S:= '';

  Ch:= Filer.GetC.rAC;
  if (ch = cc_Minus) then
  begin
   Negative  := True;
   _AddChar(Ch);
   ch := Filer.getC.rAC;
   if Filer.EOF then
   begin
    FStatus:= ecEndOfFile;
    exit;
   end;{EndOfFile}
  end {ch = cc_Minus}
  else
    Negative:= False;

  HexCount:= 0;
  if ch in (cc_Digits+['A'..'F','a'..'f']) then
  begin
   HasParam := True; { a digit after the control means we have a parameter }
   while Ch in (cc_Digits+['A'..'F','a'..'f']) do
   begin
    _AddChar(Ch);
    Inc(HexCount);
    if (HexCount = 2) and f_Hex then break;


    Ch:= Filer.GetC.rAC;
    if Filer.EOF then
    begin
     FStatus:= ecEndOfFile;
     exit;
    end;{EndOfFile}
   end;{while isdigit(Ch)}
  end{isdigit(ch)}
  else
    HasParam:= False;

  if not f_Hex then
    if (ch <> cc_HardSpace) then
      Filer.Ungetc;

 try
  if HasParam then
  begin
    if f_Hex then
    begin
     for I := 1 to 2 do
     begin
      l_S[I] := UpCase(l_S[I]);
      Byte(l_S[I]) := Byte(l_S[I]) - $30;
      if Byte(l_S[I]) > 9 then
       Byte(l_S[I]) := Byte(l_S[I]) - 7;
     end;
     f_LongParam := (Byte(l_S[1]) shl 4) or Byte(l_S[2]);
    end
    else
      f_LongParam:= StrToInt(l_S)
  end
  else
    f_LongParam:= 0;
 except
  f_LongParam:= 0;
 end;
end;

procedure TddRTFParser.SetParam(aParam: Tl3String);
begin
  f_Param.Assign(aParam);
  f_LongParam:= GetLongParam;
end;

function TddRTFParser.GetLongParam: Long;
begin
 try
  if HasParam then
    Result:= StrToInt(Param.AsString)
  else
    Result:= 0;
 except
  on EConvertError do
    try
      Result:= l3Hex2Dec(Param.AsString);
    except
      Result:= 0;
    end;
 end;
end;

procedure TddRTFParser.ParseUnknownKeyword;
var
  l_Text: Tl3String;
begin
  l_text:= Tl3String.Create;
  try
    l_Text.Assign(Parser.TokenLongString);
    ReadParam;
    Parser.CheckKeywords:= False;

    if Assigned(f_OnKeyword) then
      f_OnKeyword(Self, key_Unknown, l_Text.AsString, LongParam, HasParam);
    (* Зачем?
    if not SkipUnknown then
     {CurGroup.}AddKeyword(key_Unknown, HasParam, LongParam, l_Text);
    *)
  finally
    l3Free(l_Text);
  end;
end;

procedure TddRTFParser.ParseKeyword;
  {-}
begin
  ReadParam;
  Parser.CheckKeywords:= False;

  if Assigned(f_OnKeyword) then
    f_OnKeyword(Self, TSYM(Parser.Keyword).StringID, TSYM(Parser.Keyword).AsString, LongParam, HasParam);

  AddKeyword(TSYM(Parser.Keyword), HasParam, LongParam);
end;

procedure TddRTFParser.PushState;
begin
  if f_Content = nil then
  begin
    f_Content:= TddRTFAtom.MakeGroup(nil);
    f_Stack.Add(f_Content);
  end
  else
  begin
    CurGroup.PushState;
    f_Stack.Add(CurGroup.Content.Items[Pred(CurGroup.Content.Count)]);
  end;
end;

procedure TddRTFParser.AddKeyword(aKeyword: TSYM; aHasParam: Boolean; aParam: Long; aText:
    Tl3String = nil);
begin
  CurGroup.AddKeyword(aKeyword, aHasParam, aParam, aText);
end;

procedure TddRTFParser.AddText(aText: Tl3String);
begin
  CurGroup.AddText(aText);
end;

procedure TddRTFParser.AddText(aText: AnsiChar);
begin
  CurGroup.AddText(aText);
end;

procedure TddRTFParser.AddText(aText: Word);
begin
end;

procedure TddRTFParser.PopState;
begin
 f_Stack.DeleteLast;
end;

function TddRTFParser.GetCurGroup: TddRTFAtom;
begin
  Result:= TddRTFAtom(f_Stack.Items[Pred(f_Stack.Count)]);
end;

procedure TddRTFParser.SetGroupByKeyword(Keyword: Long; aAtom: TddRTFAtom);
begin
  f_Content.GroupByID[Keyword]:= aAtom;
end;

function TddRTFParser.GetGroupByKeyword(Keyword: Long): TddRTFAtom;
begin
  Result:= f_Content.GroupByID[Keyword];
end;

procedure TddRTFParser._ReadData;
var
 l_C: AnsiChar;
 l_Buffer: Tl3StringStream;
 l_BinBuf: PAnsiChar;
 l_Stream: TStream;
 l_Size: Int64;
begin
 if ReadData and (Parser.TokenChar in [#10,#13,'0'..'9', 'a'..'f']) then
 begin
  l_Stream:= Tl3MemoryStream.Create;
  try
   l_C:= Parser.TokenChar;
   l_Stream.Write(l_C, 1);
   with Parser.Filer do
    while not EOF do
    begin
     l_C:= GetC.rAC;
     if not (l_C in [#10,#13,'0'..'9', 'a'..'f']) then
     begin
      ReadData:= False;
      UngetC;
      Parser.NextTokenSp;
      break;
     end
     else
     if (l_C in ['0'..'9', 'a'..'f']) and not SkipData then
      l_Stream.Write(l_C, 1);
    end; // while not EOF

   if not SkipData then
   begin
     (* Кому нужно было здесь преобразовывать данные?
     l_Size:= l_Stream.Size div 2;
     l3System.GetLocalMem(l_BinBuf, l_Size);
     try
      HexToBin(Tl3MemoryStream(l_Stream).MemoryPool.AsPointer, l_BinBuf, l_Size);
      l_Stream.Seek(0, 0);
      l_Stream.Size:= l_Size;
      l_Stream.Write(l_BinBuf^, l_Size);
     finally
      l3System.FreeLocalMem(l_BinBuf);
     end;
     *)
     AddData(l_Stream);
   end; // not SkipData
  finally
   l3Free(l_Stream);
  end;
 end;
end;

end.
