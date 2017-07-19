unit ddRTFObjects;

// $Id: ddRTFObjects.pas,v 1.32 2013/04/05 12:04:30 lulin Exp $ 

// $Log: ddRTFObjects.pas,v $
// Revision 1.32  2013/04/05 12:04:30  lulin
// - портируем.
//
// Revision 1.31  2013/01/22 12:34:19  narry
// Рефакторинг RTFReader
//
// Revision 1.30  2011/02/09 11:34:21  narry
// К253657673. Чтение картинок из RTF
//
// Revision 1.29  2010/11/30 11:47:16  lulin
// {RequestLink:228688602}.
// - борьба с предупреждениями.
//
// Revision 1.28  2010/02/24 18:16:27  lulin
// - избавляемся от ненужного и вредного параметра, доставшегося в наследство от ошибок молодости.
//
// Revision 1.27  2009/07/23 08:15:11  lulin
// - вычищаем ненужное использование процессора операций.
//
// Revision 1.26  2008/03/21 14:09:22  lulin
// - cleanup.
//
// Revision 1.25  2008/02/14 09:40:33  lulin
// - удалён ненужный класс.
//
// Revision 1.24  2008/02/13 20:20:06  lulin
// - <TDN>: 73.
//
// Revision 1.23  2008/02/12 12:53:15  lulin
// - избавляемся от излишнего метода на базовом классе.
//
// Revision 1.22  2008/02/06 15:37:00  lulin
// - каждому базовому объекту по собственному модулю.
//
// Revision 1.21  2008/02/05 09:58:00  lulin
// - выделяем базовые объекты в отдельные файлы и переносим их на модель.
//
// Revision 1.20  2008/02/01 15:14:44  lulin
// - избавляемся от излишней универсальности списков.
//
// Revision 1.19  2008/01/31 20:09:55  lulin
// - избавляемся от излишней универсальности списков.
//
// Revision 1.18  2006/06/06 11:03:38  oman
// warning fix + пара функций превращена в процедуры.
//
// Revision 1.17  2006/05/06 13:31:05  lulin
// - cleanup.
//
// Revision 1.16  2005/04/19 15:41:42  lulin
// - переходим на "правильный" ProcessMessages.
//
// Revision 1.15  2004/09/21 12:21:05  lulin
// - Release заменил на Cleanup.
//
// Revision 1.14  2004/06/01 16:51:23  law
// - удален конструктор Tl3VList.MakePersistent - пользуйтесь _Tl3ObjectRefList.
//
// Revision 1.13  2003/04/19 12:30:37  law
// - new file: ddDefine.inc.
//
// Revision 1.12  2000/12/15 15:29:55  law
// - вставлены директивы Log и Id.
//

{$I ddDefine.inc }

interface

Uses
  Classes,
  l3Base, l3Types,


  ddBase, RTFTypes,
  l3ObjectRefList
  , ddRTFKeywords;

type
  TddRTFAtomType = (dd_rtfGroup, dd_rtfKeyword, dd_rtfText);

  TddRTFAtom = class(Tl3Base)
  {Надеюсь, что Шура не обидится и не будет обвинять меня в плагиате}
  private
    f_Type: TddRTFAtomType;
    f_Text: Tl3String;
    f_Keyword: TSYM;
    f_HasParam: Boolean;
    f_Param: Long;
    f_Content: Tl3ObjectRefList;
    f_Parent: TddRTFAtom;
    f_FoundList: Tl3ObjectRefList;
  protected
    procedure Cleanup; override;
    function GetLastType: TddRTFAtomType;
    procedure SetGroupByID(ID: Long; aAtom: TddRTFAtom);
    function  GetGroupByID(ID: Long): TddRTFAtom;
    procedure SetGroupByValue(ID: Long; Value: Long; aAtom: TddRTFAtom);
    function  GetGroupByValue(ID: Long; Value: Long): TddRTFAtom;
    procedure SetAtomByID(ID: Long; aAtom: TddRTFAtom);
    function  GetAtomByID(ID: Long): TddRTFAtom;
    function GetRTFString: AnsiString;
    function GetUnicodeRTFString: AnsiString;
    function TranslateChar(C: AnsiChar): AnsiString;
    function TranslateString(aUnicode: Boolean = False): AnsiString;
  public
    constructor MakeGroup(aParent: TObject);
    constructor MakeKeyword(aParent: TObject; aKeyword: TSYM; aHasParam: Boolean; aParam: Long; aText:
        Tl3String = nil);
    constructor MakeText(aParent: TObject; aText: Tl3String);

    procedure Assign(P: TPersistent); override;

    procedure Clear; virtual;

    procedure PushState;
    procedure AddKeyword(aKeyword: TSYM; aHasParam: Boolean; aParam: Long; aText: Tl3String = nil);
    procedure AddText(aText: Tl3String); overload;
    procedure AddText(aText: AnsiChar); overload;

    procedure ConvertHex2Text;

    procedure InsertAfter(aKWID: Long; aAtom: TddRTFAtom);
    procedure InsertBefore(aKWID: Long; aAtom: TddRTFAtom);
    function SearchGroup(ID: Long): TddRTFAtom;
    function SearchAgain(ID: Long): TddRTFAtom;
    procedure StopSearch;
  public
    property Parent: TddRTFAtom
      read f_Parent write f_Parent;
    property AtomType: TddRTFAtomType
      read f_Type;
    property Content: Tl3ObjectRefList
      read f_Content;
    property LastType: TddRTFAtomType
      read GetLastType;
    property Text: Tl3String
      read f_Text write f_Text;
    property Keyword: TSYM read f_Keyword;
    property HasParam: Boolean
      read f_HasParam write f_HasParam;
    property Param: Long
      read f_Param write f_Param;
    property RTFString: AnsiString
      read GetRTFString;
    property UnicodeRTFString: AnsiString
      read GetUnicodeRTFString;



    property GroupByID[ID: Long]: TddRTFAtom
      read GetGroupByID write SetGroupByID;
    property GroupByvalue[ID: Long; Value: Long]: TddRTFAtom
      read GetGroupByValue write SetGroupByValue;
    property AtomByID[ID: Long]: TddRTFAtom
      read GetAtomByID write SetAtomByID;

  end;


implementation

Uses
  SysUtils, Windows, Forms,

  l3Chars,

  afwFacade,

  Unicode,
  ddRTFconst
  ;

constructor TddRTFAtom.MakeGroup(aParent: TObject);
begin
  inherited Create(aParent);
  f_Parent:= aParent as TddRTFAtom;
  f_Keyword:= nil;
  f_Type:= dd_rtfGroup;
  f_Content:= Tl3ObjectRefList.Make;
  f_FoundList:= Tl3ObjectRefList.Make;
end;

constructor TddRTFAtom.MakeKeyword(aParent: TObject; aKeyword: TSYM; aHasParam: Boolean; aParam:
    Long; aText: Tl3String = nil);
begin
  inherited Create(aParent);
  f_Parent:= aParent as TddRTFAtom;
  f_Type:= dd_rtfKeyword;
  f_Keyword:= aKeyword;
  f_HasParam:= aHasParam;
  f_Param:= aParam;
  if aKeyword = nil then
  begin
    f_Text:= Tl3String.Create;
    f_Text.Assign(aText);
  end;
end;

constructor TddRTFAtom.MakeText(aParent: TObject; aText: Tl3String);
begin
  inherited Create(aParent);
  f_Parent:= aParent as TddRTFAtom;
  f_Type:= dd_rtfText;
  f_Text:= Tl3String.Create;
  f_Text.Assign(aText);
end;

procedure TddRTFAtom.Cleanup;
begin
  l3Free(f_Text);
  l3Free(f_Content);
  l3Free(f_FoundList);
  inherited;
end;

procedure TddRTFAtom.Clear;
begin
  case f_Type of
    dd_rtfGroup  :
      begin
        f_Content.Clear;
        f_FoundList.Clear;
      end;
    dd_rtfKeyword: if f_Text <> nil then f_Text.Clear;
    dd_rtfText   : f_Text.Clear;
  end;
end;

procedure TddRTFAtom.PushState;
var
  A: TddRTFAtom;
begin
  if AtomType = dd_rtfGroup then
  begin
    A:= TddRTFAtom.MakeGroup(Self);
    try
      Content.Add(A);
    finally
      l3Free(A);
    end;
  end;
end;

procedure TddRTFAtom.AddKeyword(aKeyword: TSYM; aHasParam: Boolean; aParam: Long; aText: Tl3String
    = nil);
var
  A: TddRTFAtom;
begin
  if AtomType = dd_rtfGroup then
  begin
    A:= TddRTFAtom.MakeKeyword(Self, aKeyword, aHasParam, aParam, aText);
    try
      Content.Add(A);
    finally
      l3Free(A);
    end;
  end;
end;

procedure TddRTFAtom.AddText(aText: Tl3String);
var
  A: TddRTFAtom;
begin
  if AtomType = dd_rtfGroup then
  begin
    A:= TddRTFAtom.MakeText(Self, aText);
    try
      Content.Add(A);
    finally
      l3Free(A);
    end;
  end;
end;

procedure TddRTFAtom.AddText(aText: AnsiChar);
var
  A: TddRTFAtom;
  l_Text: Tl3String;
begin
  if AtomType = dd_rtfGroup then
  begin
   l_Text:= Tl3String.Create;
   try
    l_Text.Append(aText);
    A:= TddRTFAtom.MakeText(Self, l_Text);
    try
      Content.Add(A);
    finally
      l3Free(A);
    end;
   finally
    l3Free(l_Text);
   end;
  end;
end;


function TddRTFAtom.GetLastType: TddRTFAtomType;
begin
  if AtomType = dd_rtfGroup then
    Result:= TddRTFAtom(Content.Items[Content.Count-1]).AtomType
  else
    Result:= AtomType;
end;

procedure TddRTFAtom.Assign(P: TPersistent);
begin
(*
  if P is TddRTFAtom then
  begin
    f_Type:= TddRTFAtom(P).AtomType;
    if TddRTFAtom(P).Text <> nil then
     f_Text:= Tl3String.;
    f_Keyword: Long;
    f_HasParam: Boolean;
    f_Param: Long;
    f_Content: Tl3VList;
    end;
  end
  else
*)
  inherited;
end;

procedure TddRTFAtom.ConvertHex2Text;

procedure H2T(Atom: TddRTFAtom);
var
  i: Long;
  l_A, l_NewA, A: TddRTFAtom;
  l_Sym: TSym;
begin
  if Atom.AtomType = dd_rtfGroup then
  begin
    i:= 0;
    while i < Atom.Content.Count do
    begin
      afw.ProcessMessages;
      l_A:= TddRTFAtom(Atom.Content.Items[i]);
      case l_A.AtomType of
        dd_rtfGroup:
          begin
            H2T(l_A);
            if (l_A.Content.Count = 2) then
            begin
              l_NewA:= TddRTFAtom(l_A.Content.Items[0]);
              A:= TddRTFAtom(l_A.Content.Items[1]);
              if (l_NewA.AtomType = dd_rtfKeyword) and (l_NewA.Keyword.StringID = valu_uc) and (A.AtomType = dd_rtfText) then
              begin
                A.Parent:= Atom;
                Atom.Content.Insert(i, A);
                Atom.Content.Delete(i+1);
              end;
            end;
          end;
        dd_rtfKeyword:
          begin
           l_Sym := nil;
           // l_SYm:= TSYM(RTFKeywords.DRbyID[l_A.Keyword]);
            if (L_A.Keyword.StringID = valu_Hex) or (l_A.Keyword.StringID = valu_u) then
            begin
              if (i = 0) or (TddRTFAtom(Atom.Content.Items[Pred(i)]).AtomType <> dd_rtfText) then
              begin
                l_NewA:= TddRTFAtom.MakeText(Atom, nil);
                try
                  if L_A.Keyword.StringID = valu_Hex then
                    l_NewA.Text.Append(AnsiChar(l_A.Param))
                  else
                  if l_A.Keyword.StringID = valu_u then
                    l_NewA.Text.Append(Unicode2Ansi(Word(SmallInt(l_A.Param))))
                  else
                    l_NewA.Text.Append(AnsiChar(l_Sym.Value));
                  Atom.Content.Remove(l_A);
                  Atom.Content.Insert(i, l_NewA);
                  if (l_A.Keyword.StringID = valu_u){ or (l_Symbol)} then
                    Atom.Content.Delete(i+1);
                finally
                  l3Free(l_NewA);
                end;
              end
              else
              if TddRTFAtom(Atom.Content.Items[Pred(i)]).AtomType = dd_rtfText then
              begin

                l_NewA:= TddRTFAtom(Atom.Content.Items[Pred(i)]);
                if L_A.Keyword.StringID = valu_Hex then
                begin
                  l_NewA.Text.Append(AnsiChar(l_A.Param));
                  Atom.Content.Delete(i);
                end
                else
                if l_A.Keyword.StringID = valu_u then
                begin
                  l_NewA.Text.Append(Unicode2Ansi(Word(SmallInt(l_A.Param))));
                  Atom.Content.Remove(l_A);
                  A:= TddRTFAtom(Atom.Content.Items[i]);
                  if A.AtomType = dd_rtfText then
                  begin
                    A.Text.Delete(0, 1);
                    if A.Text.Empty then
                      Atom.Content.Delete(i);
                  end
                  else
                    Atom.Content.Delete(i);
                end;
                Dec(i);

              end;
            end;
          end;
        dd_rtfText :
          begin
            if (i > 0) and (TddRTFAtom(Atom.Content.Items[Pred(i)]).AtomType = dd_rtfText) then
            begin
              TddRTFAtom(Atom.Content.Items[Pred(i)]).Text.JoinWith(l_A.Text);
              Atom.Content.Delete(i);
              Dec(i);
            end
          end
      end; { case}
      Inc(i);
    end; { while }
  end;
end;

begin
  H2T(Self);
end;

function TddRTFAtom.GetRTFString: AnsiString;
begin
  case AtomType of
    dd_rtfGroup: Result:= '{';
    dd_rtfKeyword:
      begin
        if Keyword <> nil then
        begin
          case Keyword.KWD of
            kwdFlag,
            kwdDest,
            kwdSymb :
              begin
                Result:= Format('\%s', [Keyword.AsString]);
                if Keyword.StringID = dest_rtf then
                  Result:= Result + '1'
                else
                if Keyword.StringID = valu_Hex then
                  Result:= Format('%s%x', [Result, f_Param]);
              end;
            kwdTogg : if f_HasParam then
                        Result:= Format('\%s%d', [Keyword.AsString, f_Param])
                      else
                        Result:= Format('\%s', [Keyword.AsString]);
            kwdValu : Result:= Format('\%s%d', [Keyword.AsString, f_Param]);
          end; { case l_S.KWD }
        end
        else
        begin
          if HasParam then
            Result:= Format('\%s%d', [f_Text.AsString, f_Param])
          else
            Result:= Format('\%s ', [f_Text.AsString]);
        end;
      end;
    dd_rtfText: Result:= TranslateString(False);
  end; {  case AtomType}
end;

function TddRTFAtom.GetUnicodeRTFString: AnsiString;
begin
  if AtomType = dd_rtfText then
  begin
    Result:= TranslateString(True);
  end
  else
    Result:= '';
end;



function TddRTFAtom.TranslateChar(C: AnsiChar): AnsiString;
var
  S: AnsiString;
begin
  if (C > #128) or ((C < #32) and (C <> #9)) then
  { // not printable and not tab}
  begin
    case C of
      #10 : S:= TSYM(RTFKeywords.DRByID[symb_line]).AsString + ' ';
      #145: S:= TSYM(RTFKeywords.DRByID[Symb_lquote]).AsString + ' ';
      #146: S:= TSYM(RTFKeywords.DRByID[Symb_lquote]).AsString + ' ';
      #132, {                                //„//«}
      #171: S:= TSYM(RTFKeywords.DRByID[Symb_ldblquote]).AsString + ' ';
      #147: S:= TSYM(RTFKeywords.DRByID[Symb_ldblquote]).AsString + ' ';
      #187, {/ for ruSSian document               //»}
      #148: S:= TSYM(RTFKeywords.DRByID[Symb_rdblquote]).AsString + ' ';
      #149: S:= TSYM(RTFKeywords.DRByID[Symb_bullet]).AsString + ' ';
      #150: S:= TSYM(RTFKeywords.DRByID[Symb_endaSh]).AsString + ' ';
      #151: S:= TSYM(RTFKeywords.DRByID[Symb_emdaSh]).AsString + ' ';
      #160: S:= TSYM(RTFKeywords.DRByID[symb_tilda]).AsString + ' ';{  soft space}
      #1: ;
      #2: ;
    else
      {$IFDEF DontTranslate}
      S:= C;
      {$ELSE}
      S:= Format('\''%2x', [Ord(C)]);
      {$ENDIF}
    end; { case }
  end
  else
  begin
    case C of
      #9 : S:= TSYM(RTFKeywords.DRByID[symb_tab]).AsString;
      '{': S:= '\{';
      '}': S:= '\}';
      '\': S:= '\\';
      else
        S:= C;
    end;
  end;
  Result:= S;
end;

function TddRTFAtom.TranslateString(aUnicode: Boolean = False): AnsiString;
  {-}
var
 i          : Long;
 MemUnicode : Tl3String;
 l_St       : PWideChar;

begin
  Result := '';
  if aUnicode then
  begin
    MemUnicode := Tl3String.Create;
    try
     MemUnicode.Assign(f_Text);
     MemUnicode.CodePage:= cp_Unicode;
     Result:= '';
     l_St := PWideChar(MemUnicode.St);
     for i := 0 to Pred(MemUnicode.Len) do
     begin
      AppendStr(Result, Format('\u%d ?', [Word(l_St^)]));
      Inc(l_St);
     end;
    finally
     l3Free(MemUnicode);
    end;{try..finally}
  end
  else {not aUnicode }
  begin
    if TddRTFAtom(Parent.Content.Items[0]).Keyword.StringID = dest_pict then
    begin
      Result:= f_Text.AsString
    end
    else
    for i := 0 to Pred(f_Text.Len) do
      AppendStr(Result, TranslateChar(f_Text.Ch[i]));
  end;
end;

procedure TddRTFAtom.SetGroupByID(ID: Long; aAtom: TddRTFAtom);
var
  A, ParentA: TddRTFAtom;
  Index: Long;
begin
  A:= GroupByID[ID];
  if (A <> nil) and (A.f_Parent <> nil) then
  begin
    ParentA:= A.f_Parent as TddRTFAtom;
    with ParentA.Content do
    begin
      Index:= IndexOf(A);
      Delete(Index);
      aAtom.f_Parent{Owner}:= Self;
      Insert(Index, aAtom);
    end;
  end;
end;



function TddRTFAtom.GetGroupByID(ID: Long): TddRTFAtom;
function Get(A: TddRTFAtom): TddRTFAtom;
var
  i: Long;
  l_A: TddRTFAtom;
begin
  if A.AtomType  = dd_rtfGroup then
  begin
    i:= 0;
    Result := nil;
    while i < A.Content.Count do
    begin
      l_A:= TddRTFAtom(A.Content.Items[i]);
      Result:= Get(l_A);
      if Result <> nil then exit;
      Inc(i);
    end;
  end
  else
  if A.AtomType  = dd_rtfKeyword then
  begin
    if A.Keyword.StringID = ID then
    begin
      Result:= A.f_Parent{Owner} as TddRTFAtom;
      exit;
    end
    else
    Result:= nil;
  end
  else
    Result:= nil;
end;
begin
  Result:= Get(Self);
end;


procedure TddRTFAtom.SetAtomByID(ID: Long; aAtom: TddRTFAtom);
var
  A, ParentA: TddRTFAtom;
  Index: Integer;
begin
  A:= AtomByID[ID];
  if (A <> nil) and (A.f_Parent <> nil) then
  begin
    ParentA:= A.f_Parent as TddRTFAtom;
    with ParentA.Content do
    begin
      Index:= IndexOf(A);
      Delete(Index);
      aAtom.f_Parent{Owner}:= Self;
      Insert(Index, aAtom);
    end;
  end;
end;



function TddRTFAtom.GetAtomByID(ID: Long): TddRTFAtom;
function Get(A: TddRTFAtom): TddRTFAtom;
var
  i: Long;
  l_A: TddRTFAtom;
begin
  if A.AtomType  = dd_rtfGroup then
  begin
    i:= 0;
    Result := nil;
    while i < A.Content.Count do
    begin
      l_A:= TddRTFAtom(A.Content.Items[i]);
      Result:= Get(l_A);
      if Result <> nil then exit;
      Inc(i);
    end;
  end
  else
  if A.AtomType  = dd_rtfKeyword then
  begin
    if A.Keyword.StringID = ID then
    begin
      Result:= A;
      exit;
    end
    else
    Result:= nil;
  end
  else
    Result:= nil;
end;
begin
  Result:= Get(Self);
end;

procedure TddRTFAtom.InsertAfter(aKWID: Long; aAtom: TddRTFAtom);
var
  l_G: TddRTFAtom;
  Index: Integer;
begin
  l_G:= GroupByID[aKWID];
  if l_G <> nil then
  begin
    if l_G.Parent <> nil then
    begin
      Index:= l_G.Parent.Content.IndexOf(l_G);
      l_G.Parent.Content.Insert(Index+1, aAtom);
    end
    else
    begin
      Index:= l_G.Content.IndexOf(l_G.AtomByID[aKWID]);
      l_G.Content.Insert(Index+1, aAtom);
    end
  end;
end;

procedure TddRTFAtom.InsertBefore(aKWID: Long; aAtom: TddRTFAtom);
var
  l_G: TddRTFAtom;
  Index: Integer;
begin
  l_G:= GroupByID[aKWID];
  if l_G <> nil then
  begin
    if l_G.Parent <> nil then
    begin
      Index:= l_G.Parent.Content.IndexOf(l_G);
      l_G.Parent.Content.Insert(Index, aAtom);
    end
    else
    begin
      Index:= l_G.Content.IndexOf(l_G.AtomByID[aKWID]);
      l_G.Content.Insert(Index, aAtom);
    end
  end;
end;

procedure TddRTFAtom.SetGroupByValue(ID: Long; Value: Long; aAtom: TddRTFAtom);
var
  A, ParentA: TddRTFAtom;
  Index: Long;
begin
  A:= GroupByValue[ID, Value];
  if (A <> nil) and (A.f_Parent <> nil) then
  begin
    ParentA:= A.f_Parent as TddRTFAtom;
    with ParentA.Content do
    begin
      Index:= IndexOf(A);
      Delete(Index);
      aAtom.f_Parent{Owner}:= Self;
      Insert(Index, aAtom);
    end;
  end;
end;



function TddRTFAtom.GetGroupByValue(ID: Long; Value: Long): TddRTFAtom;
function Get(A: TddRTFAtom; Value: Long): TddRTFAtom;
var
  i: Long;
  l_A: TddRTFAtom;
begin
  if A.AtomType  = dd_rtfGroup then
  begin
    i:= 0;
    Result := nil;
    while i < A.Content.Count do
    begin
      l_A:= TddRTFAtom(A.Content.Items[i]);
      Result:= Get(l_A, Value);
      if Result <> nil then exit;
      Inc(i);
    end;
  end
  else
  if A.AtomType  = dd_rtfKeyword then
  begin
    if (A.Keyword.StringID = ID) and (A.Param = Value) then
    begin
      Result:= A.f_Parent{Owner} as TddRTFAtom;
      exit;
    end
    else
    Result:= nil;
  end
  else
    Result:= nil;
end;
begin
  Result:= Get(Self, Value);
end;

function TddRTFAtom.SearchGroup(ID: Long): TddRTFAtom;
begin
  f_FoundList.Clear;
  if AtomType = dd_rtfGroup then
  begin
    Result:= GetGroupByID(ID);
    if Result <> nil then
      f_FoundList.Add(Result);
  end
  else
    Result:= nil;
end;

function TddRTFAtom.SearchAgain(ID: Long): TddRTFAtom;
  function Get(A: TddRTFAtom): TddRTFAtom;
  var
    i: Long;
    l_A: TddRTFAtom;
  begin
    if A.AtomType  = dd_rtfGroup then
    begin
      i:= 0;
      Result := nil;
      while i < A.Content.Count do
      begin
        l_A:= TddRTFAtom(A.Content.Items[i]);
        Result:= Get(l_A);
        if (Result <> nil) and (f_FoundList.IndexOf(Result) = -1) then exit;
        Inc(i);
      end;
    end
    else
    if A.AtomType  = dd_rtfKeyword then
    begin
      if A.Keyword.StringID = ID then
      begin
        Result:= A.f_Parent{Owner} as TddRTFAtom;
        exit;
      end
      else
      Result:= nil;
    end
    else
      Result:= nil;
  end;
begin
  if AtomType = dd_rtfGroup then
  begin
    Result:= Get(Self);
    if Result <> nil then
      f_FoundList.Add(Result);
  end
  else
    Result:= nil;
end;


procedure TddRTFAtom.StopSearch;
begin
  if AtomType = dd_rtfGroup then
    f_FoundList.Clear;
end;

end.

