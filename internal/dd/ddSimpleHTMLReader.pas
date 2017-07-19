unit ddSimpleHTMLReader;
{ Базовый предок читалки HMTL }
{ $Id: ddSimpleHTMLReader.pas,v 1.13 2013/04/16 09:06:05 narry Exp $ }

// $Log: ddSimpleHTMLReader.pas,v $
// Revision 1.13  2013/04/16 09:06:05  narry
// Обновление
//
// Revision 1.12  2013/04/11 16:46:29  lulin
// - отлаживаем под XE3.
//
// Revision 1.11  2011/10/13 12:02:55  narry
// Сейчас при показе справки к списку срезаются начальные пробелы (290272742)
//
// Revision 1.10  2011/10/13 08:43:31  narry
// Накопившиеся изменения
//
// Revision 1.9  2011/10/07 07:51:52  narry
// Поддержа неизвестных ключевых слов
//
// Revision 1.8  2011/10/06 11:53:20  narry
// Виртуальный метод для обработки StartKeywordChar
//
// Revision 1.7  2011/10/04 12:21:17  narry
// Рефакторинг чтения HTML
//
// Revision 1.6  2011/09/01 08:05:24  narry
// 35. Стирается пробел перед ссылкой (внимание на между "от" и датой) (278839514)
//
// Revision 1.5  2011/08/12 07:19:53  narry
// 28. Игнорировать содержимое файла после окончания html (278839269)
//
// Revision 1.4  2011/07/15 09:38:07  narry
// Ссылки съедают пробел (274825348)
//
// Revision 1.3  2011/02/07 13:02:55  narry
// K253658756. Не собирается ddHTML_r 2
//

interface

uses
 k2Reader, k2TagGen,
 l3ObjectRefList, l3base, l3SimpleObject,
 Classes, l3SimpleObjectRefList;

type
  TddHTMLObjType = (dd_HTMLTag, dd_HTMLText);

  TddHTMLObj = class(Tl3SimpleObject)
  private
    f_ObjType: TddHTMLObjType;
  public
    property ObjType: TddHTMLObjType read f_ObjType;
  end;

  THTMLParam = class(Tl3SimpleObject)
  private
    fKey: AnsiString;
    fRaw: AnsiString;
    fValue: AnsiString;
    f_Values: TStrings;
    function GetIntValue: Integer;
    function GetIsPercent: Boolean;
    function GetValueCount: Integer;
    function GetValues(Index: Integer): AnsiString;
    procedure SetKey(Key: AnsiString);
  protected
    procedure Cleanup; override;
  public
    constructor Create; override;
    property IntValue: Integer read GetIntValue;
    property IsPercent: Boolean read GetIsPercent;
    property Key: AnsiString read fKey write SetKey;
    property Raw: AnsiString read fRaw;
    property Value: AnsiString read fValue;
    property ValueCount: Integer read GetValueCount;
    property Values[Index: Integer]: AnsiString read GetValues;
  end;

  THTMLTag = class(TddHTMLObj)
  private
    f_IsComment: Boolean;
    f_Params: Tl3SimpleObjectRefList;
    f_TagID: Integer;
    function pm_GetIsClosed: Boolean;
    function pm_GetParamCount: Integer;
    function pm_GetParams(Index: Integer): THtmlParam;
    function pm_GetTagID: Integer;
    procedure SetParams(const aParams: AnsiString);
  protected
    procedure Cleanup; override;
  public
    constructor Create; override;
    constructor Make(aTagId: Integer; const aParams: AnsiString);
    property IsClosed: Boolean read pm_GetIsClosed;
    property ParamCount: Integer read pm_GetParamCount;
    property Params[Index: Integer]: THtmlParam read pm_GetParams;
    property TagID: Integer read pm_GetTagID;
  published
    property IsComment: Boolean read f_IsComment write f_IsComment;
  end;

  THTMLText = class(TddHTMLObj)
  private
    fLine: AnsiString;
    fRawLine: AnsiString;
    f_IsPre: Boolean;
    procedure SetLine(aValue: AnsiString);
  protected
    procedure Cleanup; override;
  public
    constructor Create(aIsPre: Boolean); overload;
  published
    property Line: AnsiString read fLine write SetLine;
    property Raw: AnsiString read fRawLine;
  end;

  TddHTMLAnalyzeEvent = procedure (var theBreakAnalyze: Boolean) of object;
  TddSimpleHTMLReader = class(Tk2CustomFileParser)
  private
    f_BreakAnalyze: Boolean;
    f_isComment: Boolean;
    f_IsPre: Boolean;
    f_isTag: Boolean;
    f_OnAnalyze: TddHTMLAnalyzeEvent;
    f_Text: AnsiString;
    f_TokenReaded: Boolean;
    procedure AddText;
    procedure WorkupKeyword;
    procedure WorkupSymbol;
  protected
    procedure AnalyzeProc(var theBreakAnalyze: Boolean);
    procedure CreateParser; virtual;
    procedure WorkupTag(aTag: THTMLTag); virtual;
    procedure WorkupText(aText: THTMLText); virtual;
  public
    constructor Create(aOwner: Tk2TagGeneratorOwner = nil); override;
    procedure BreakAnalyze;
    procedure Read; override;
    property isComment: Boolean read f_isComment write f_isComment;
    property isTag: Boolean read f_isTag write f_isTag;
    property OnAnalyze: TddHTMLAnalyzeEvent read f_OnAnalyze write f_OnAnalyze;
  end;


implementation

uses
 StrUtils, SysUtils, l3String, l3ObjectRefList1, ddHTMLParser, l3Parser,
 TypInfo, ddHTMLTags, l3Chars, l3ParserInterfaces, l3CustomString,
  l3PrimString;

{$i latin1.pas}

{
***************************** TddSimpleHTMLReader ******************************
}
constructor TddSimpleHTMLReader.Create(aOwner: Tk2TagGeneratorOwner = nil);
begin
 inherited Create(nil);
 CreateParser;
end;

procedure TddSimpleHTMLReader.AddText;
var
 l_Text: ThtmlText;
begin
 //f_Text:= Trim(f_text);
 if f_Text <> '' then
 begin
  l_Text:= ThtmlText.Create(f_IsPre);
  try
   l_Text.Line:=f_Text;
   workupText(l_Text);
  finally
   FreeAndNil(l_Text);
  end; // try..Finally
 end; // CollectText
 f_Text:='';
end;

procedure TddSimpleHTMLReader.AnalyzeProc(var theBreakAnalyze: Boolean);
begin
 if Assigned(f_OnAnalyze) then f_OnAnalyze(theBreakAnalyze);
end;

procedure TddSimpleHTMLReader.BreakAnalyze;
begin
 f_BreakAnalyze:= True;
end;

procedure TddSimpleHTMLReader.CreateParser;
var
 l_Parser: TddHTMLParser;
begin
 l_Parser:= TddHTMLParser.Create;
 try
  Parser:= l_Parser;
 finally
  FreeAndNil(l_Parser);
 end;
end;

procedure TddSimpleHTMLReader.Read;
begin
 f_BreakAnalyze:= False;
 f_IsPre:= False;
 with Parser do
 begin
  f_TokenReaded:= False;
  while (not Parser.Filer.EOF) and (not f_BreakAnalyze) do
  begin
   if not f_TokenReaded then
    NextTokenSP
   else
    f_TokenReaded:= False;
   if TokenType = l3_ttKeyword then
    WorkupKeyword
   else
   if TokenType in [l3_ttSingleChar, l3_ttSymbol] then
    WorkupSymbol;
  end;
 end;
end;

procedure TddSimpleHTMLReader.WorkupKeyword;
var
 l_TempKey: ShortString;
 l_Params: AnsiString;
 l_TagID: Integer;
 l_Count: Integer;
 l_Tag: ThtmlTag;
begin
 AddText;
 // нужно искать параметры тэга
 l_Params:= '';
 l_TagID:= Parser.Keyword.StringID;
 if Abs(l_TagID) = tidH then
  l_TempKey:= Parser.Keyword.AsString
 else
  if Abs(l_TagID) = tidPre then
 f_IsPre := l_TagID > 0;
 Parser.WhiteSpace:= l3_DefaultParserWhiteSpace-[#13, #10, #32];
 Parser.WordChars:= l3_DefaultParserWordChars + cc_ANSIRussian +cc_Digits + [#13,#10] + ['[',']'];
 Parser.CheckKeyWords:= False;
 try
  l_Count:= 1;
  parser.NextTokenSP;
  while (l_Count > 0) and (Parser.TokenType <> l3_ttEOF) do
  begin
   if (Parser.TokenType = l3_ttSingleChar) then
   begin
    if (Parser.TokenChar = '>') then
     Dec(l_Count)
    else
    if (Parser.TokenChar = '<') then
     Inc(l_Count)
    else
    if (Abs(l_TagID) = tidH) and (Parser.TokenChar in cc_Digits) then
    begin
     l_TagID:= Parser.Keywords.KeywordByName[l_TempKey+Parser.TokenChar].StringID;
     continue;
    end
   end;
   if l_Count > 0 then
   begin
    if Parser.TokenType = l3_ttEOL then
     l_Params:= l_Params + cc_EOL
    else
     l_Params:= l_Params + Parser.TokenString;
    parser.NextTokenSP;
   end; // l_Count > 0
  end;
 finally
  Parser.WhiteSpace:= htmlWhiteSpace;
  Parser.WordChars:= htmlWordChars;
  Parser.CheckKeyWords:= True;
 end;
 if l_TagID <> cUnknownKeyword then
 begin
  l_Tag:= ThtmlTag.Make(l_TagID, l_params);
  try
   WorkupTag(l_Tag);
  finally
   FreeAndNil(l_Tag);
  end;
 end; // l_TagID <> cUnknownKeyword
end;

procedure TddSimpleHTMLReader.WorkupTag(aTag: THTMLTag);
begin
end;

procedure TddSimpleHTMLReader.WorkupText(aText: THTMLText);
begin
end;

procedure TddSimpleHTMLReader.WorkupSymbol;
begin
 f_text:= f_text + Parser.TokenString;
end;

{
********************************** THTMLParam **********************************
}
constructor THTMLParam.Create;
begin
  inherited Create;
  f_Values:= TStringList.Create;
end;

procedure THTMLParam.Cleanup;
begin
  l3Free(f_Values);
  inherited;
end;

function THTMLParam.GetIntValue: Integer;
var
  S: AnsiString;
begin
  S:= Value;
  try
    if S[Length(S)] = '%' then
      Delete(S, Length(S), 1);
    Result:= StrToInt(S);
  except
    Result:= -1;
  end;
end;

function THTMLParam.GetIsPercent: Boolean;
begin
  Result:= (Value <> '') and (Value[Length(Value)] = '%');
end;

function THTMLParam.GetValueCount: Integer;
begin
  Result:= f_Values.Count;
end;

function THTMLParam.GetValues(Index: Integer): AnsiString;
begin
  Result:= f_Values.Strings[Index];
end;

procedure THTMLParam.SetKey(Key: AnsiString);
var
  l_S: AnsiString;
begin
  fValue:='';
  fRaw:=Key;
  if pos('=',key)<>0 then
   begin
    fValue:=Key;
    delete(fValue,1,pos('=',key));
    key:=copy(Key,1,pos('=',key)-1);

    if Length(fValue)>1 then
     if (fValue[1]='"') and (fValue[Length(fValue)]='"') then
      begin

       delete(fValue,1,1);
       delete(fValue,Length(fValue),1);
       l_S:= fValue;
       while Pos(';', l_S) <> 0 do // В строке несколько значений через ;
       begin
         f_Values.Add(Copy(l_S, 1, Pos(';', l_S)));
         Delete(l_S, 1, Pos(';', l_S));
         TrimLeft(l_S);
       end;
       f_Values.Add(l_S);
      end
      else
        f_Values.Add(fValue);
   end;
  fKey:=uppercase(key);
end;

{
*********************************** THTMLTag ***********************************
}
constructor THTMLTag.Create;
begin
  inherited;
  f_ObjType:= dd_htmlTag;
  f_Params:=Tl3SimpleObjectReflist.Make;
end;

constructor THTMLTag.Make(aTagId: Integer; const aParams: AnsiString);
begin
 Create;
 f_TagID:= aTagID;
 SetParams(aParams);
end;

procedure THTMLTag.Cleanup;
begin
  l3Free(f_Params);
  inherited;
end;

function THTMLTag.pm_GetIsClosed: Boolean;
begin
 Result := f_TagID < 0;
end;

function THTMLTag.pm_GetParamCount: Integer;
begin
 Result := f_Params.Count;
end;

function THTMLTag.pm_GetParams(Index: Integer): THtmlParam;
begin
 Result := THTMLParam(f_Params[index]);
end;

function THTMLTag.pm_GetTagID: Integer;
begin
 // TODO -cMM: THTMLTag.pm_GetTagID default body inserted
 Result := abs(f_TagID);
end;

procedure THTMLTag.SetParams(const aParams: AnsiString);
var
 param: AnsiString;
 l_Params: AnsiString;
 HTMLParam: THTMLParam;
 isQuote: Boolean;
 l_QuoteChar: AnsiChar;
begin
{ TODO : Нужен рефакторинг }
  f_Params.clear;
  if not IsComment then
  begin
    // Теперь разбираем параметры
    //   1. Находим '='
    //   2. Первый пробел после '=' является концом параметра
    l_Params:= aParams;
    while (Length(l_Params)>0) do
    begin
     param:='';
     isQuote:=false;
     //while (Length(aParams)>0) do
     begin
       l_Params:= TrimLeft(l_Params);
       if l_Params <> '' then
       begin
        if Pos('=', l_Params) <> 0 then  // как минимум одна пара параметров
        begin
          param:= Copy(l_Params, 1, Pos('=', l_Params));
          Delete(l_Params, 1, Pos('=', l_Params));

          l_Params:= TrimLeft(l_Params);
          if l_params <> '' then
          begin
           isQuote:= (l_Params[1] in ['"', '''']);
           if isQuote then
            l_QuoteChar:= l_Params[1]
           else
            l_QuoteChar:= #0;
           param:= param + l_Params[1];
           Delete(l_Params, 1, 1);

           while (Length(l_Params) > 0) and (not ((l_Params[1]=' ') and (isQuote=false))) do
           begin
            if l_Params[1] = l_QuoteChar then
              IsQuote:= not (IsQuote);
            param:=param+l_Params[1];
            Delete(l_Params,1,1);
           end; // while (Length(l_Params) > 0) and (not ((l_Params[1]=' ') and (isQuote=false)))
           if param<>'' then
           begin
            HTMLParam:=THTMLParam.Create;
            try
              HTMLParam.key:=param;
              f_params.add(HTMLParam);
            finally
              l3Free(HTMLParam);
            end;
           end; // Param <> ''
          end; // l_params <> ''
        end  // Pos(=) <> 0
        else
          break;
       end; // l_params <> ''
     end; // while Length(l_Params) > 0
    end; // while Length(l_Params) > 0
  end;
end;

{
********************************** THTMLText ***********************************
}
constructor THTMLText.Create(aIsPre: Boolean);
begin
  inherited Create;
  f_ObjType:= dd_htmlText;
  f_IsPre:= aIsPre;
end;

procedure THTMLText.Cleanup;
begin
  inherited;
end;

procedure THTMLText.SetLine(aValue: AnsiString);
var
  j, i: Integer;
  isEntity: Boolean;
  Entity: AnsiString;
  EnLen, EnPos: Integer;
  d, c: Integer;
begin
 { TODO : Нужно провести рефакторинг }
  fRawLine:= aValue;
  (*
  while pos(#10,aValue)>0 do aValue[Pos(#10,aValue)]:=' ';
  // while pos('  ',aValue)>0 do delete(aValue,pos('  ',aValue),1);
  *)
  if not f_IsPre then
   aValue:= l3DeleteDoubleSpace(aValue);
  //aValue:= TrimLeft(aValue);
  i:=1;
  isEntity:=false;
  EnPos:=0;
  while (i<=Length(aValue)) do
   begin
    if aValue[i]=#9 then aValue[i]:= ' ';
    if aValue[i]='&' then
    begin
     EnPos:=i;
     isEntity:=true;
     Entity:='';
    end;
    if isEntity then Entity:=Entity+aValue[i];
    if isEntity then
    if (aValue[i]=';') or (aValue[i]=' ') then
    begin
      EnLen:=Length(Entity);

       // charset encoded entity
      if (EnLen>2) and (Entity[2]='#') then
       begin
        delete(Entity,EnLen,1); //delete the ;
        delete(Entity,1,2); // delete the &#
        if uppercase(Entity[1])='X' then Entity[1]:='$'; // it's hex (but not supported!!!)
        if (Length(Entity)<=3) then // we cant convert e.g. cyrillic/chinise capitals
         begin
          val(Entity,d,c);
          if c=0 then // conversion successful
           begin
            delete(aValue,EnPos,EnLen);
            insert(Charset[d],aValue,EnPos);
            i:=EnPos; // set new start
           end;
         end;
       end
       else
       begin // its an entity
        Entity[Length(Entity)]:= ';';
        j:=1;
        while (j<=100) do
         begin
          if Entity=(Entities[j,1]) then
           begin
            delete(aValue,EnPos,EnLen);
            insert(Entities[j,2],aValue,Enpos);
            j:=102; // stop searching
           end;
          j:=j+1;
         end;
        // reset aValue
       if j=103 then i:=EnPos-1
                else i:=EnPos;
       end;

      IsEntity:=false;
    end;
    i:=i+1;
   end;

  fLine:=aValue;
end;

end.
