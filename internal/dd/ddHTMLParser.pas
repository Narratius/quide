unit ddHTMLParser;
{* ��������� HTML �� ���� }

{ $Id: ddHTMLParser.pas,v 1.10 2013/04/16 09:07:28 narry Exp $ }

// $Log: ddHTMLParser.pas,v $
// Revision 1.10  2013/04/16 09:07:28  narry
// ����������
//
// Revision 1.9  2013/04/05 12:04:29  lulin
// - ���������.
//
// Revision 1.8  2012/02/20 19:11:18  lulin
// - ������ ��� � ������������� ������ ����������� � ������.
//
// Revision 1.7  2012/02/20 16:14:31  lulin
// - ����� ���������� ��������� ������.
//
// Revision 1.6  2012/02/17 07:39:24  narry
// ��������� ������ �� ������������ ��������� � html (288786476)
//
// Revision 1.5  2011/10/07 07:51:52  narry
// �������� ����������� �������� ����
//
// Revision 1.4  2011/10/06 12:36:05  narry
// ������ ����������������� ���������� StartKeywordChar
//
// Revision 1.3  2011/10/06 11:53:20  narry
// ����������� ����� ��� ��������� StartKeywordChar
//
// Revision 1.2  2011/10/05 15:13:09  lulin
// - ���������� ��������� �����.
//
// Revision 1.1  2011/10/04 12:21:18  narry
// ����������� ������ HTML
//


interface

uses
  l3Parser, l3Keywrd, l3Base,

  l3Filer
  ;

type
 TddHTMLParser = class(Tl3CustomParser)
 private
  f_KeywordStartChar: AnsiChar;
  f_UnknownKeyword: Tl3KeyWord;
 protected
        {-}
  procedure CheckKeyWord; override;
  function CheckSingleChar(aChar: AnsiChar; aString: Tl3String; aNTF: Tl3NextTokenFlags): Tl3TokenType; override;
  procedure Cleanup; override;
  procedure FillKeywords; virtual;
 public
    {public methods}
  constructor Create;
  property KeywordStartChar: AnsiChar read f_KeywordStartChar write
      f_KeywordStartChar;
 end;

const
 cUnknownKeyword = MaxInt;

implementation

uses
  SysUtils, ddHTMLTags, l3Types, l3Chars;

{ start class TddHTMLParser }

constructor TddHTMLParser.Create;
  {override;}
  {-}
begin
 inherited Create;
 LineComment := '';//'//';
 OpenComment := '<!--';
 CloseComment := '-->';
 WhiteSpace := htmlWhiteSpace;
 WordChars := htmlWordChars;

 CheckFloat := False;
 CheckInt := False;
 CheckHex := False;
 AddDigits2WordChars := True;
 (*
 f_TokenType := l3_ttBOF;
 f_SourceLine := 1;
 CheckKeyWords := true;
 CheckStringBracket := true;
 *)
 KeywordStartChar:= '<';
 FillKeywords;
 f_UnknownKeyword := Tl3KeyWord.Create('unknown', cUnknownKeyword);
end;

procedure TddHTMLParser.CheckKeyWord;
  {-}
begin
 if (TokenType = l3_ttSymbol) OR
    ((TokenType = l3_ttDoubleQuotedString) AND
     (cc_DoubleQuote in WordChars)) then
 begin
  if (KeyWords <> nil) then
  begin
   KeyWord := KeyWords.KeyWordByName[TokenLongString.AsString] As Tl3KeyWord;
   if (KeyWord <> nil) or (KeywordStartChar <> #0) then
   begin
    f_TokenType := l3_ttKeyWord;
    if (Keyword = nil) then // ����������� �������� �����
     Keyword:= f_UnknownKeyword;
   end;  
  end;//KW <> nil
 end;//TokenType = l3_ttSymbol
end;

function TddHTMLParser.CheckSingleChar(aChar: AnsiChar; aString: Tl3String; aNTF: Tl3NextTokenFlags): Tl3TokenType;
var
 l_C: AnsiChar;
 l_EnableKeyword: Boolean;
begin//CheckSingleChar
 l_EnableKeyword:= KeywordStartChar = #0;
 l_C:= aChar;
 if (l_C in WordChars) then
 begin
  if not CheckKeywords or (CheckKeywords and (l_C <> KeywordStartChar)) then
   aString.Append(l_C, 1, Filer.CodePage)
  else
  if l_C = KeywordStartChar then
   l_EnableKeyword:= True;
  while not Filer.EOF do
  begin
   l_C := Filer.GetC.rAC;
   if CheckKeywords and (l_C = KeywordStartChar) then
   begin
     Filer.UngetC;
     break;
   end
   else
    if (l_C in WordChars) then
     aString.Append(l_C, 1, Filer.CodePage)
    else
    if AddDigits2WordChars AND (l_C in cc_Digits) then
     aString.Append(l_C, 1, Filer.CodePage)
    else
    begin
     Filer.UngetC;
     break;
    end;//AddDigits2WordChars AND (l_C in cc_Digits)
  end;//while true
  Result := l3_ttSymbol;
  f_TokenType := Result;
  if CheckKeyWords and l_EnableKeyword then
  begin
   CheckKeyWord;
   Result := f_TokenType;
  end;//CheckKeyWords
 end//l_C in Word Chars
 else
 begin
  aString.AsChar := l_C;
  Result := l3_ttSingleChar;
 end;//l_C in Word Chars
end;//CheckSingleChar

procedure TddHTMLParser.Cleanup;
begin
 inherited;
 FreeAndNil(f_UnknownKeyword);
end;

procedure TddHTMLParser.FillKeywords;
var
 l_Keywords: Tl3Keywords;
 i: Integer;
begin
 l_Keywords:= Tl3Keywords.Create;
 try
  with l_KeyWords do
  begin
   //SortIndex:= l3_siCaseUnsensitive;
   for i:= 0 to cMaxHTMLTag do
   begin
    AddKeyword({'<'+}cHTMLTags[i].TagName, cHTMLTags[i].TagID);
    AddKeyword({'</'}'/'+cHTMLTags[i].TagName, -cHTMLTags[i].TagID);
   end;
  end;
  Keywords:= l_Keywords;
 finally
  FreeAndNil(l_Keywords);
 end;
end;

end.
