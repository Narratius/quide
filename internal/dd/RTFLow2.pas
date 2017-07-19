//..........................................................................................................................................................................................................................................................
unit RtfLow2;

{ Очередная попытка начать все с нуля.
  10 июня 1998 года }
{ $Id: RTFLow2.pas,v 1.10 2013/04/11 16:46:26 lulin Exp $ }

// $Log: RTFLow2.pas,v $
// Revision 1.10  2013/04/11 16:46:26  lulin
// - отлаживаем под XE3.
//
// Revision 1.9  2007/08/14 14:30:05  lulin
// - оптимизируем перемещение блоков памяти.
//
// Revision 1.8  2005/02/16 17:10:41  narry
// - update: Delphi 2005
//
// Revision 1.7  2004/09/21 12:21:04  lulin
// - Release заменил на Cleanup.
//
// Revision 1.6  2003/04/19 12:30:36  law
// - new file: ddDefine.inc.
//
// Revision 1.5  2000/12/15 15:29:53  law
// - вставлены директивы Log и Id.
//

{$I ddDefine.inc }

interface

uses
  Classes,

  _RTF,
  RTFTypes,

  l3Types,
  l3Base,
  
  evFiler,
  evTypes
  ;

{$DEFINE SaveTableProperty}

type
  TPropertyObject = class(Tl3Base)
  private
    FKernel: TRTFKernel;
    FIsDefault: Boolean;
  protected
  public
    constructor Create(aKernel: TObject);
      override;
      {-}
    procedure Merge(Value: TPropertyObject); virtual; abstract;
    function RTFToken: AnsiString; virtual; abstract;
    procedure Reset; virtual; abstract;

    property IsDefault: Boolean
      read FIsDefault write FIsDefault;
    property Kernel: TRTFKernel
      read FKernel write FKernel;
  end;

  TCHP = class(TPropertyObject)
  private
    FAnime: TAnime;
    FBold: TRTFBool;
    FUnderline: TUnderline;
    FItalic: TRTFBool;
    FCaps: TCharCapsType;
    FHidden: TRTFBool;
    FDeleted: TRTFBool;
    FCharScale: Integer;
    FSubpos: Integer;
    FContour: TContourType;    {\embo приподнятый \impro  утопленный }
    FFontNumber: Integer; {\fN}
    FFontSize: Integer; {\fsN}
    FLanguage: Integer; {\langN}
    FFColor: Longint;
    FForeColor: Longint;
    FBColor: Longint;
    FBackColor: Longint;
    FPos : TCharPosition;
    FHighlight: Longint;
  protected
    procedure SetAnime(Value : TAnime);
    procedure SetBold(Value : TRTFBool);
    procedure SetUnderline(Value : TUnderline);
    procedure SetItalic(Value : TRTFBool);
    procedure SetCaps(Value : TCharCapsType);
    procedure SetHidden(Value : TRTFBool);
    procedure SetDeleted(Value : TRTFBool);
    procedure SetCharScale(Value : Integer);
    procedure SetSubpos(Value : Integer);
    procedure SetContour(Value : TContourType);
    procedure SetFontNumber(Value : Integer);
    procedure SetFontSize(Value : Integer);
    procedure SetLanguage(Value : Integer);
    procedure SetFColor(Value : Longint);
    function GetFColor: Longint;
    procedure SetBColor(Value : Longint);
    function GetBColor: Longint;
    function GetFontName: AnsiString;
    procedure SetFontName(Value: AnsiString);
    procedure SetPos(Value: TCharPosition);
    procedure SetHighlight(Value: Longint);
    function GetHighlight: Longint;
    {
    procedure SetProperty(Index: Integer; Value: Longint);
    function GetProperty(Index: Integer): Longint;
    }
  public
    constructor Create(aReader: TObject);
      override;
      {-}
    procedure Assign(ACHP: TPersistent);
      override;
      {-}
    procedure Merge(aCHP: TCHP);
    procedure Clear;
      override;
      {-}
    function  Compare(Value: Tl3Base): Long;
      override;
      {-}
    procedure Reset; override;
    function RTFToken: AnsiString; override;

    property Anime: TAnime
      read FAnime write SetAnime;
    property Bold: TRTFBool
      read FBold write SetBold;
    property Underline: TUnderline

      read FUnderline write SetUnderline;
    property Italic: TRTFBool
      read FItalic write SetItalic;
    property Caps: TCharCapsType
      read FCaps write SetCaps;
    property Hidden: TRTFBool
      read FHidden write SetHidden;
    property Highlight : Longint
      read GetHighlight write SetHighlight;
    property Deleted: TRTFBool
      read FDeleted write SetDeleted;
    property CharScale: Integer
      read FCharScale write SetCharScale;
    property Subpos: Integer
      read FSubpos write SetSubPos;
    property Contour: TContourType
      read FContour write SetContour;
    property FontName : AnsiString
      read GetFontName write SetFontName;
    property FontNumber: Integer
      read FFontNumber write SetFontNumber;
    property FontSize: Integer
      read FFontSize write SetFontSize;
    property Language: Integer
      read FLanguage write SetLanguage;
    property FColor: Longint
      read GetFColor write SetFColor;
    property BColor: Longint
      read GetBColor write SetBColor;
    property Pos: TCharPosition
      read FPos write SetPos;
    property FIndexColor: Longint
      read FFColor;
    property BIndexColor: LOngint
      read FBColor;
  end;                  { CHaracter Properties }

  TBorderPart = class(Tl3Base)
    private
    {internal fields}
      FType: TBorderType;
      FWidth: Byte;  {<= 75 (in twips) }
      FColor: Byte;  { index in RTFReader color table }
      FSpace: Integer;
      Enable: TRTFBool;
    public
    {public methods}
      procedure Clear;
        override;
        {-}
      procedure Assign(BP: TPersistent);
        override;
        {-}
  end;{TBorderPart}

  TBorderParts = (bpTop, bpLeft, bpBottom, bpRight, bpHorizontal, bpVertical, bpBox);

  TBorder = class(TPropertyObject)  { Border properties }
    private
    {property fields}
      FTOP,
      FBottom,
      FLeft,
      FRight,
      FHorizontal,
      FVertical: TBorderPart;
    protected
    {property methods}
      function GetFrameColor(Index: TBorderParts): Longint;
      function GetFrameWidth(Index: TBorderParts): Longint;
      function GetFrameType(Index: TBorderParts): TBorderType;
      procedure SetFrameColor(Index: TBorderParts; Value: Longint);
      procedure SetFrameWidth(Index: TBorderParts; Value: Longint);
      procedure SetFrameType(Index: TBorderParts; Value: TBorderType);
      function GetFrames(Index: TBorderParts): TBorderPart;
      procedure SetFrames(Index: TBorderParts; Value: TBorderPart);
      function GetFrameSpace(Index: TBorderParts): Integer;
      procedure SetFrameSpace(Index: TBorderParts; Value: Integer);
      function GetIsFramed: Boolean;
    public
    {public methods}
      constructor Create(AReader: TObject);
        override;
        {-}
      destructor Destroy;
        override;
        {-}
      procedure Clear;
        override;
        {-}
      procedure Assign(aBorder: TPersistent);
        override;
        {-}
    public
    {public properties}
      property Frames[Index: TBorderParts]: TBorderPart
        read GetFrames write SetFrames;
      property FrameColor[Index: TBorderParts]: Longint
        read GetFrameColor write SetFrameColor;
      property FrameWidth[Index: TBorderParts]: Longint
        read GetFrameWIdth write SetFrameWidth;
      property FrameType[Index: TBorderParts]: TBorderType
        read GetFrameType write SetFrameType;
      property FrameSpace[Index: TBorderParts]: Integer
        read GetFrameSpace write SetFrameSpace;
      property isFramed: Boolean
        read GetIsFramed;
  end;{TBorder}

  TShading = class
    FShadingType: TShadingType;
    FSHading: Byte;
    FForeColor: Longint;
    FBackColor: Longint;
  end;{TShading}

  TTab = class
    FKind : TTabKind;   {\tqr\tqc\tqdec}
    FTabLead : TTabLead;{\tldot\tlhyph\tlul\tleq}
    FTabPos: Longint;   {\tx}
    FTabBar: Longint;   {\tb}
  end;{TTab}

  TPAP = class(TPropertyObject)
  private
    Saving: TRTFBool;
    FxaLeft: Longint;                 { left indent in twips }
    FxaRight: Longint;                { right indent in twips }
    FxaFirst: Longint;                { first line indent in twips }
    FJUST : Tjust;                  { justification  }
    FHyph: TRTFBool;  { автоперенос слов }
    FInTable: TRTFBool; { часть таблицы }
    Fkeep: TRTFBool;       { не разрывать абзац }
    FKeepWNext: TRTFBool;  { не отрывать от следующего }
    FNoLine: TRTFBool;     { не нумеровать строки }
    FBreakBefore: TRTFBool;{ разрыв страницы до абзаца }
    FSideBSide: TRTFBool;  { спина к спине }
    FBefore: Integer;     { отбивка до }
    FAfter : Integer;     { после }
    FBetween: Integer;    { интерлиньяж }
    FLineSpaceExact: TRTFBool;{ использовать интерлиньяж как значение или множитель }
    FBox           : TRTFBool; {\box - border around paragraph }
    FBorder: TBorder;
  protected
    procedure SetxaLeft(Value: Longint);                 { left indent in twips }
    procedure SetxaRight(Value: Longint);                { right indent in twips }
    procedure SetxaFirst(Value: Longint);                { first line indent in twips }
    procedure SetJUST(Value : Tjust);                  { justification  }
    procedure SetHyph(Value: TRTFBool);  { автоперенос слов }
    procedure SetInTable(Value: TRTFBool); { часть таблицы }
    procedure Setkeep(Value: TRTFBool);       { не разрывать абзац }
    procedure SetKeepWNext(Value: TRTFBool);  { не отрывать от следующего }
    procedure SetNoLine(Value: TRTFBool);     { не нумеровать строки }
    procedure SetBreakBefore(Value: TRTFBool);{ разрыв страницы до абзаца }
    procedure SetSideBSide(Value: TRTFBool);  { спина к спине }
    procedure SetBefore(Value: Integer);     { отбивка до }
    procedure SetAfter(Value : Integer);     { после }
    procedure SetBetween(Value: Integer);    { интерлиньяж }
    procedure SetLineSpaceExact(Value: TRTFBool);{ использовать интерлиньяж как значение или множитель }
  public

    constructor Create(AReader: TObject);
      override;
      {-}
    destructor Destroy;
      override;
      {-}
    procedure Assign(APAP: TPAP);
    procedure Clear;
      override;
      {-}
    function RTFToken: AnsiString; override;

    property xaLeft: Longint
      read FxaLeft write SetxaLeft;                 { left indent in twips }
    property xaRight: Longint
      read FxaRight write SetxaRight;                { right indent in twips }
    property xaFirst: Longint
      read FxaFirst write SetxaFirst;                { first line indent in twips }
    property JUST : Tjust
      read FJust write SetJust;                  { justification  }
    property Hyph: TRTFBool
      read FHyph write SetHyph;  { автоперенос слов }
    property InTable: TRTFBool
      read FInTable write SetInTable; { часть таблицы }
    property keep: TRTFBool
      read FKeep write SetKeep;       { не разрывать абзац }
    property KeepWNext: TRTFBool
      read FKeepWNext write SetKeepWNext;  { не отрывать от следующего }
    property NoLine: TRTFBool
      read FNoLine write SetNoLine;     { не нумеровать строки }
    property BreakBefore: TRTFBool
      read FBreakBefore write SetBreakBefore;{ разрыв страницы до абзаца }
    property SideBSide: TRTFBool
      read FSideBSide write SetSideBSide;  { спина к спине }
    property Before: Integer
      read FBefore write SetBefore;     { отбивка до }
    property After : Integer
      read FAfter write SetAfter;     { после }
    property Between: Integer
      read FBetween write SetBetween;    { интерлиньяж }
    property LineSpaceExact: TRTFBool
      read FLineSpaceExact write SetLineSpaceExact;{ использовать интерлиньяж как значение или множитель }
    property Border : TBorder
      read FBorder write FBorder;
  end;{TPAP - PAragraph Properties}

  TDOP = class
    xaPage: Integer;                 { page width in twips  }
    yaPage: Integer;                 { page height in twips }
    xaLeft: Integer;                 { left margin in twips }
    yaTop: Integer;                  { top margin in twips  }
    xaRight: Integer;                { right margin in twips }
    yaBottom: Integer;               { bottom margin in twips }
    xGutter: Integer;                { ширина поля подшивки }
    pgnStart: Integer;               { starting page number in twips }
    fFacingp: TRTFBool;               { facing pages enabled?          }
    fLandscape: TRTFBool;             { landscape or portrait??        }
    FurstSpec : TRTFBool;             { первая страница имеет спецформат }
    constructor Create;
  end;{TDOP - DOcument Properties}

  TSEP = record
    cCols: Integer;                  { number of column }
    ColsSpace: Integer;    { пространство между колонками }
    LineBetween: TRTFBool;  { линия между колонками }
    SBK: Tsbk;                    { section break type  }
    xaPgn: Integer;                  { x position of page number in twips }
    yaPgn: Integer;                  { y position of page number in twips }
    pgnFormat: TPGN;              { how the page number is formatted      }
    EndHere: TRTFBool; { конечные сноски в конце секции }
    FirstBin: Byte;   { принтерный поддон для первой страницы }
    Bin     : Byte;   { для всех остальных страниц }
    Unlocked: TRTFBool; { раздел открыт для форм }
    DOP: TDOP;        { параметры страницы }
  end;{TSEP - SEction Properties}

  TTableCell = class(Tl3Base)
    private
    {internal fields}
      f_Border : TBorder;
      f_Width  : Longint;
    protected
    {internal methods}
      procedure Cleanup;
        override;
        {-}
    public
    {public methods}
      function GetReader: TRTFKernel;
      constructor Create(AReader: TObject);
        override;
        {-}
      procedure Assign(aCell: TPersistent);
        override;
        {-}
    public
    {public properties}
      property Reader: TRTFKernel
        read GetReader;
        {-}
      property Border: TBorder
        read f_Border;
        {-}
      property Width: Long
        read f_Width;
        {-}  
  end;{TTableCell}

  TTAP = class(Tl3Base)  { Table properties }
    private
    {property fields}
      FCells  : Tl3PersistentList;
      FGaph   : Long;
      FBorder : TBorder;
      FLeft   : Long;
    protected
    {property methods}
      function GetCells(Index: Integer): TTableCell;
      function GetCellCount: Integer;
    public
    {public methods}
      constructor Create(aReader: TObject);
        override;
        {-}
      destructor Destroy;
        override;
        {-}
      procedure Clear;
        override;
        {-}
      procedure SetDefault;
        {-}
      procedure Assign(aTAP: TPersistent);
        override;
        {-}
    public
    {public properties}
      property Border: TBorder
        read FBorder write FBorder;
        {-}
      property Gaph: Longint
        read FGaph write FGaph;
        {-}
      property Cells[Index: Integer]: TTableCell
        read GetCells;
        {-}
      property CellCount: Integer
        read GetCellCount;
        {-}
      property Left: Longint
        read FLeft write FLeft;
        {-}
  end;{TTAP}

  TStanding = class
  private
    FPAP: TPAP;
    FCHP: TCHP;
    FRDS: TRDS;
    FRIS: TRIS;
    FBOP: TBorder;
    FTAP: TTAP;
  protected
  public
    constructor Create(AStanding: TStanding; AReader: TRTFKernel);
    destructor Destroy;
      override;
      {-}
    property PAP : TPAP
      read FPAP write FPAP;
    property CHP : TCHP
      read FCHP write FCHP;
    property RDS: TRDS
      read FRDS write FRDS;
    property RIS : TRIS
      read FRIS write FRIS;
    property BOP: TBorder
      read FBOP write FBOP;
    property TAP: TTAP
      read FTAP write FTAP;
  end;

  TRTFStyle = class(TCustomStyleEntry)
  private
    FCHP: TCHP;
    FPAP: TPAP;
    FBasedOn: Longint;
  protected

  public
    constructor Create(aReader: TObject);
      override;
      {-}
    destructor Destroy;
      override;
      {-}
    property CHP: TCHP
      read FCHP write FCHP;
    property PAP: TPAP
      read FPAP write FPAP;
    property BasedOn: Longint
      read FBasedOn write FbasedOn;
  end;


  TGroupEvent = procedure (Sender: TObject) of object;
  TBorderOwner = (boChar, boPara, boRow, boCell);

  TRTFReader = class(TCustomRTFReader)
  private
    FBuffer: Array[-1..4096] of AnsiChar;
    FFiler: Tl3CustomFiler;
    FReaded: Word;
    FIndex: Word;
    FStandingList: TddList;
    FDOP: TDOP;
    {$IFNDEF SaveTableProperty}
    FTAP: TTAP;
    {$ENDIF}
    FOnEndGroup: TGroupEvent;
    FOnStartGroup: TGroupEvent;
    FCurBorderPart : TBorderParts;
    FBorderOwner: TBorderOwner;
    FCurCellIdx: Integer;
    FRed, FGreen, FBlue: Integer;
  protected
    procedure SetFiler(Value: Tl3CustomFiler);
    function GetC: AnsiChar; override;
    procedure UngetC; override;
    function EndOfFile: Boolean; override;
    function GetSrcSize: Longint;
    function GetCurCell: TTableCell;

    procedure ecParseProperty(propType: TPropType; What: Tiprop; Value: Longint);
      override;
    procedure ClearProperty(propType: TPropType); override;
    procedure ecPushRtfState; override;
    { Началась новая группа }
    procedure ecPopRtfState; override;
    { Закончилась текущая группа }
    procedure ecEndGroupAction(aRDS: Trds); override;
    { Закончился текущий RDS }
    procedure SetRDS(Value: TRDS); override;
    function GetRDS: TRDS; override;
    procedure SetRIS(Value: TRIS); override;
    function GetRIS: TRIS; override;
    procedure SetCHP(Value: TCHP);
    function GetCHP: TCHP;
    procedure SetPAP(Value: TPAP);
    function GetPAP: TPAP;
    procedure SetBOP(Value: TBorder);
    function GetBOP: TBorder;
    procedure SetTAP(Value: TTAP);
    function GetTAP: TTAP;
    procedure FinishRow; override;
  public
    constructor Create(anOwner: TObject);
      override;
      {-}
    destructor Destroy;
      override;
      {-}
    property Filer : Tl3CustomFiler
      read FFiler write SetFiler;
    property RDS: TRds
      read GetRDS write SetRDS;
    property RIS: TRis
      read GetRIS write SetRIS;
    property CHP : TCHP
      read GetCHP write SetCHP;
    property PAP : TPAP
      read GetPAP write SetPAP;
    property DOP : TDOP
      read FDOP write FDOP;
    property TAP : TTAP
      read GetTAP write SetTAP;
    property BOP : TBorder
      read GetBOP write SetBOP;
    property CurBorderPart : TBorderParts
      read FCurBorderPart;
    property BorderOwner: TBorderOwner
      read FBorderOwner write FBorderOwner;
    property CurCell: TTableCell
      read GetCurCell {write SetCurCell};
    property CurCellIdx: Integer
      read FCurCellIdx write FCurCellIdx;


    property OnEndGroup: TGroupEvent
      read FOnEndGroup write FOnEndGroup;
    property OnStartGroup: TGroupEvent
      read FOnStartGroup write FOnStartGroup;
  end;


function ColorToHighlight(Color: Longint): Integer;
function k2JustToJust(Just: TevIndentType): TJust;
function JustTok2Just(Just: TJust): TevIndentType;

implementation

uses
  Graphics,
  Unicode;

const
  TColorSet : Array[1..16] of Longint = (
                    clBlack, clBlue, clAqua, clLime, clFuchsia, clRed,
                    clYellow, clWhite, clNavy,clTeal, clGreen, clPurple,
                    clMaroon, clOlive, clGray, clSilver );

function ColorToHighlight(Color: Longint): Integer;
var
  i: Integer;
begin
  i:= 1;
  while (i <= 16) do
  begin
    if Color = TColorSet[i] then
      Break;
    Inc(i);
  end;
  if I > 16 then
    Result:= 1
  else
    Result:= i;
end;

function k2JustToJust(Just: TevIndentType): TJust;
begin
  case Just of
    ev_itRight : Result:= justR;
    ev_itCenter: Result:= justC;
    ev_itWidth : Result:= justF;
  else
    Result:= justL;
  end; { case Just}
end;

function JustTok2Just(Just: TJust): TevIndentType;
begin
  case Just of
    justL: Result:= ev_itLeft;
    justR: Result:= ev_itRight;
    justC: Result:= ev_itCenter;
    justF: Result:= ev_itWidth;
  end; { case Just}
end;

procedure TRTFReader.SetFiler(Value: Tl3CustomFiler);
begin
  if (Value <> FFiler) then
  begin
    FFiler:= Value;
    FIndex:= 0;
    FReaded:= FFiler.Read(@(FBuffer[1]), SizeOf(FBuffer)-2);
  end;
end;

function TRTFReader.GetC: AnsiChar;
begin
  Inc(FIndex);
  if FIndex > FReaded then
  begin
    l3Move(FBuffer[FReaded-2], FBuffer[-1], 2);
    FReaded:= FFiler.Read(@(FBuffer[1]), SizeOf(FBuffer)-2);
    FIndex:= 1;
  end;
  Result:= FBuffer[FIndex];
end;

procedure TRTFReader.UngetC;
begin
  Dec(FIndex);
end;

function TRTFReader.EndOfFile: Boolean;
begin
  Result:= (FReaded = 0) or ((FIndex = FReaded) and (FReaded <> (SizeOf(FBuffer)-2)))
end;

function TRTFReader.GetSrcSize: Longint;
begin
end;

procedure TRTFReader.FinishRow;
begin
 CurCellIdx:= 0;
end;

procedure TRTFReader.ecParseProperty(propType: TPropType; What: Tiprop; Value: Longint);

 procedure CheckCurCell;
 var
  C : TTableCell;
 begin
  if (CurCell = nil) then begin
   C := TTableCell.Create(Self);
   try
    TAP.FCells.Add(C);
   finally
    l3Free(C);
   end;{try..finally}
  end;{CurCell = nil}
 end;{CheckCurCell}

var
 tmpBorder : TBorder;
 i         : Byte;
begin
  try
    case RDS of
      rdsNorm:
       begin

        case propType of
          propCHP :
           with CHP do
           begin
            BeforeProperty(propType);
            case What of
              ipropAnime : ;
              ipropPos   : Pos:= TCharPosition(Value);
              ipropHighlight : Highlight:= Value;
              ipropBold: Bold:= TRTFBool(Value);
              ipropItalic: Italic:= TRTFBool(Value);
              ipropUnderline : Underline:= TUnderline(Value);
              iproPAnsiCharCaps : Caps:= TCharCapsType(Value);
              ipropHidden  : Hidden:= TRTFBool(Value);
              ipropDeleted : ;
              iproPAnsiCharScale : ;
              iproPAnsiCharpos: ;
              ipropNumber: FontNumber:= Value;
              ipropHeight: FontSize:= Value;
              ipropLang: Language:= Value;
              ipropColorF:
                 FColor:= Value;
              ipropColorB: BColor:= Value;
              ipropDefault: Clear{Reset};
              ipropUnicode: ecPrintChar(Unicode2Ansi(Value))
            end;
            ChangeProperty(propType, What);
           end;
          propPAP :
           with PAP do
           begin
             case What of
               ipropLeft : XaLeft:= Value;
               ipropFirst: XaFirst:= Value;
               ipropRight: XaRight:= Value;
               ipropJust: Just:= TJust(Value);
               ipropInTable: InTable:= boolTrue;
               ipropBorderWhere:
                 begin
                   BorderOwner:= boPara;
                   case TddBorderWhere(Value) of
                    bwTop: begin
                             FCurBorderPart:= bpTop;
                             Border.Frames[bpTop].Enable:= boolTrue;
                           end;
                    bwRight: begin
                               Border.Frames[bpRight].Enable:= boolTrue;
                               FCurBorderPart:= bpRight;
                             end;
                    bwBottom: begin
                                Border.Frames[bpBottom].Enable:= boolTrue;
                                FCurBorderPart:= bpBottom;
                              end;
                    bwLeft: begin
                              Border.Frames[bpLeft].Enable:= boolTrue;
                              FCurBorderPart:= bpLeft;
                            end;
                    bwHorizontal: Border.Frames[bpHorizontal].Enable:= boolTrue;
                    bwVertical: Border.Frames[bpVertical].Enable:= boolTrue;
                    bwBox:
                      for i:= ord(bpTop) to ord(bpRight) do
                      begin
                        Border.Frames[TBorderParts(i)].Enable:= boolTrue;
                        Border.FrameWidth[TBorderParts(i)]:= 10;
                        {Border.FrameColor[TBorderPart(i)]:= ;}
                        Border.FrameType[TBorderParts(i)]:= btSingleThick;
                      end;
                   end;
                 end;
               ipropDefault: Clear;
             end; { case}
           end;
          propSep: ;
          propDop:
           with DOP do
           begin
            case What of
             ipropWidth: xaPage:= Value;
             ipropHeight: YaPage:= Value;
             ipropLeft: xaLeft:= Value;
             ipropRight: xaRight:= Value;
            end;
           end;
          propRow:
           begin
            BeforeProperty(propType);
            case What of
             ipropFirst: TAP.FGaph:= Value;
             ipropBorderWhere:
                 begin
                   case TddBorderWhere(Value) of
                     bwTop: FCurBorderPart:= bpTop;
                     bwLeft: FCurBorderPart:= bpLeft;
                     bwBottom: FCurBorderPart:= bpBottom;
                     bwRight: FCurBorderPart:= bpRight;
                     bwHorizontal: FCurBorderPart:= bpHorizontal;
                     bwVertical: FCurBorderPart:= bpVertical;
                   end;
                   BorderOwner:= boRow;
                 end;
             ipropLeft: TAP.Left:= Value;
             ipropDefault: begin
                             TAP.Clear;
                             CurCellIdx:= 0;
                           end;
            end;
            ChangeProperty(propType, What);
          end;
          propCell:
           begin
            BeforeProperty(propType);
            case What of
             ipropWidth:
               begin
                 CheckCurCell;
                 CurCell.f_Width := Value;
                 CurCellIdx:= CurCellIdx+1;
               end;
             ipropTop   : begin
                            FCurBorderPart:= bpTop;
                            BorderOwner:= boCell;
                            CheckCurCell;
                          end;
             ipropLeft  : begin
                            FCurBorderPart:= bpLeft;
                            BorderOwner:= boCell;
                            CheckCurCell;
                          end;
             ipropBottom: begin
                            FCurBorderPart:= bpBottom;
                            BorderOwner:= boCell;
                            CheckCurCell;
                          end;
             ipropRight : begin
                            FCurBorderPart:= bpRight;
                            BorderOwner:= boCell;
                            CheckCurCell;
                          end;
            end;

          end;
          propFrame:
            begin
              case BorderOwner of
                boChar: ;
                boPara: tmpBorder:= PAP.Border;
                boRow : tmpBorder:= TAP.Border;
                boCell: begin
                          if CurCell <> nil then
                            tmpBorder:= CurCell.Border
                          else
                            tmpBorder:= PAP.Border;
                        end;
              end;
              case What of

                ipropWidth: tmpBorder.FrameWidth[FCurBorderPart]:= Value;
                ipropColorF: tmpBorder.FrameColor[FCurBorderPart]:= Value;
                ipropLineType: tmpBorder.FrameType[FCurBorderPart]:= TBorderType(Value);
                ipropBorderWhere: FCurBorderPart:= TBorderparts(Value-1);
              end;
              ChangeProperty(propType, What);
            end;
        end;
       end;
      rdsFontTable:
        case What of
          ipropNumber:
            begin
              if FontEntry <> nil then
              begin
                FontTable[Value]:= FontEntry;
                FontEntry:= nil;
              end;
              if FontEntry = nil then
              begin
                FontEntry:= TFontEntry.Create(nil);
                FontEntry.FNumber:= Value;
              end;
            end;

        end;
      rdsStyleSheet: ;
      rdsColorTable:
        begin
          case What of
            ipropRed: FRed:= Value;
            ipropGreen: FGreen:= Value;
            ipropBlue: FBlue:= Value;
          end;
          if AddRGBColor(FRed, FGreen, FBlue) > -1 then
          begin
            FRed:= -1;
            FGreen:= -1;
            FBlue:= -1;
          end;
        end;
    end;
  except
    raise;
  end;
end;

procedure TRTFReader.ecPushRtfState;
{ Началась новая группа, запихиваем текущее состояние в стек }
begin
  with FStandingList do
    Add(TStanding.Create(Items[Pred(Count)], Self));

  if (RDS = rdsNorm) and Assigned(FOnStartGroup) then
    FOnStartGroup(Self);
end;



procedure TRTFReader.ecPopRtfState;
{ Закончилась текущая группа, выпихиваем предыдущее состояние из стека }
var
  S: TStanding;
  oldRDS: TRDS;
begin
  try
    oldRDS:= RDS;
    with FStandingList do
    begin
      S:= Items[Pred(Count)];
      Remove(S);
      Pack;
      l3Free(S);
    end;
    if oldRDS <> RDS then
      ecEndGroupAction(oldRDS);
    if (oldRDS = rdsNorm) and (RDS = rdsNone) and Assigned(FOnFinishDocument) then
        FOnFinishDocument(Self);

    if (RDS = rdsNorm) and Assigned(FOnEndGroup) then
      FOnEndGroup(Self);
  except
  end;
end;

procedure TRTFReader.ClearProperty;
{ Clear specified property }
begin
  case propType of
    propChp : CHP.Clear;
    propPap :
      begin
        PAP.Clear;
        {CHP.Clear; }
      end;
    propSep :;
    propDop :;
    propRow : {TAP.SetDefault}TAP.Clear;
  end;
end;

procedure TRTFReader.SetRDS(Value: TRDS);
begin
  with FStandingList do
    TStanding(Items[Pred(Count)]).RDS:= Value;
end;

function TRTFReader.GetRDS: TRDS;
begin
  Result:= TStanding(FStandingList.Items[FStandingList.Count-1]).RDS;
end;

procedure TRTFReader.SetRIS(Value: TRIS);
begin
  TStanding(FStandingList.Items[FStandingList.Count-1]).RIS:= Value;
end;

function TRTFReader.GetRIS: TRIS;
begin
  Result:= TStanding(FStandingList.Items[FStandingList.Count-1]).RIS;
end;

procedure TRTFReader.SetCHP(Value: TCHP);
begin
  TStanding(FStandingList.Items[FStandingList.Count-1]).CHP:= Value;
end;

function TRTFReader.GetCHP: TCHP;
begin
  Result:= TStanding(FStandingList.Items[FStandingList.Count-1]).CHP;
end;

procedure TRTFReader.SetBOP(Value: TBorder);
begin
  TStanding(FStandingList.Items[FStandingList.Count-1]).BOP:= Value;
end;

function TRTFReader.GetBOP: TBorder;
begin
  Result:= TStanding(FStandingList.Items[FStandingList.Count-1]).BOP;
end;

procedure TRTFReader.SetTAP(Value: TTAP);
begin
  {$IFDEF SaveTableProperty}
  TStanding(FStandingList.Items[FStandingList.Count-1]).TAP:= Value;
  {$ELSE}
  FTAP:= Value;
  {$ENDIF}
end;

function TRTFReader.GetTAP: TTAP;
begin
  {$IFDEF SaveTableProperty}
  Result:= TStanding(FStandingList.Items[FStandingList.Count-1]).TAP;
  {$ELSE}
  Result:= FTAP;
  {$ENDIF}
end;

function TRTFReader.GetCurCell: TTableCell;
begin
  if (CurCellIdx >=0) and (CurCellIdx < TAP.CellCount) then
    Result:= TAP.Cells[CurCellIdx]
  else
    Result:= nil;
end;


procedure TRTFReader.SetPAP(Value: TPAP);
begin
  TStanding(FStandingList.Items[FStandingList.Count-1]).PAP:= Value;
end;

function TRTFReader.GetPAP: TPAP;
begin
  Result:= TStanding(FStandingList.Items[FStandingList.Count-1]).PAP;
end;

procedure TRTFReader.ecEndGroupAction(aRDS: Trds);
begin
 { Здесь нужно сообщить всему миру, что начался или закончился документ }

end;

constructor TRTFReader.Create(anOwner: TObject);
begin
  inherited Create(anOwner);
  FStandingList:= TddList.Create(nil);
  FStandingList.Add(TStanding.Create(nil, Self));
  FDOP:= TDOP.Create;
  {$IFNDEF SaveTableProperty}
  FTAP:= TTAP.Create(Self);
  {$ENDIF}
  FCurBorderPart:= bpTop;
  FCurCellIdx:= 0;
  FBorderOwner:= boPara;
  FRed:= -1;
  FGreen:= -1;
  FBlue:= -1;
end;

destructor TRTFReader.Destroy;
begin
  {$IFNDEF SaveTableProperty}
  l3Free(FTAP);
  {$ENDIF}
  l3Free(FDOP);
  l3Free(FStandingList);
  inherited Destroy;
end;

{^^^========================= End Of RTFReader =============================^^^}


constructor TCHP.Create(AReader: TObject);
begin
 inherited Create(aReader);
 Clear;
end;

procedure TCHP.Reset;
begin
 Clear;
 FCharScale:= -1;
 FSubpos:= -1;
 FFontNumber:= -1;
 FFontSize:= -1;
 FLanguage:= -1;
 FFColor:= -1;
 FBColor:= -1;
 {
 FIndexColor:= -1;
 BIndexColor:= -1;
 }
 FAnime:= atNotDefined;
 FBold:= boolNotDefined;
 FUnderline:= utNotDefined;
 FItalic:= boolNotDefined;
 FCaps:= ccNotDefined;
 FHidden:= boolNotDefined;
 FDeleted:= boolNotDefined;
 FContour:= ctNotDefined;
end;

function TCHP.RTFToken: AnsiString;
begin
  Result:= '';
  try
    if FontNumber > -1 then
      Result:= Kernel.KW(valu_f, FontNumber, False);
    if FontSize > -1 then
      Result:= Result +Kernel.KW(valu_fs, FontSize, False);
    if Bold = boolTrue then
      Result:= Result +Kernel.KW(togg_b, Ord(True), False);
    if Italic = boolTrue then
      Result:= Result +Kernel.KW(togg_i, Ord(True), False);
    if (Underline <> utNone) and (Underline <> utNotDefined) then
      Result:= Result +Kernel.KW(togg_ul, Ord(True), False);
       {  CHP.ResultrikeOut:= f_StyleEv.Font.Strikeout;}
    if FIndexColor > -1 then
      Result:= Result +Kernel.KW(valu_cf, FIndexColor, False);
    if BIndexColor > -1 then
      Result:= Result +Kernel.KW(valu_cb, BIndexColor, False);
  except
    Result:= '';
  end;
end;

function TCHP.GetFontName: AnsiString;
var
  F: TFontEntry;
begin
  Result:= '';
  if Kernel <> nil then
  begin
    F:= Kernel.FontTable[FFontNumber];
    if Assigned(F) then
      Result:= F.FFontName
  end;
end;

procedure TCHP.SetFontName(Value: AnsiString);
begin
  FontNumber:= Kernel.AddFontName(Value);
end;

procedure TCHP.Clear;
begin
 inherited Clear;
 FAnime:= atNone;
 FBold:= boolFalse;
 FUnderline:= utNone;
 FItalic:= boolFalse;
 FCaps:= ccNone;
 FHidden:= boolFalse;
 FDeleted:= boolFalse;
 FCharScale:= 0;
 FSubpos:= 0;
 FContour:= ctNone;
 FFontNumber:= 0;
 FFontSize:= 20;
 FLanguage:= 0;
 FFColor:= 0;
 FBColor:= 0;
 IsDefault:= True;
end;

procedure TCHP.Assign(aCHP: TPersistent);
var
 _CHP : TCHP absolute aCHP;
begin
 if (aCHP Is TCHP) then begin
  IsDefault:= _CHP.IsDefault;
  FAnime:= _CHP.Anime;
  FBold:= _CHP.Bold;
  FUnderline:= _CHP.Underline;
  FItalic:= _CHP.Italic;
  FCaps:= _CHP.Caps;
  FHidden:= _CHP.Hidden;
  FDeleted:= _CHP.Deleted;
  FCharScale:= _CHP.CharScale;
  FSubpos:= _CHP.Subpos;
  FContour:= _CHP.Contour;
  FFontNumber:= _CHP.FontNumber;
  FFontSize:= _CHP.FontSize;
  FLanguage:= _CHP.Language;
  FColor:= _CHP.FFColor;
  {FForeColor:= aCHP.FFOreColor;}
  BColor:= _CHP.FBColor;
 { FBAckColor:= aCHP.FBackColor;}
  Highlight:= _CHP.FHighlight;
  Pos:= _CHP.Pos;
 end else
  inherited Assign(aCHP);
end;

function TCHP.GetFColor: Longint;
begin
  if FFColor > 0 then
    Result:= Kernel.ColorTable[FFColor]
  else
    Result:= 0;
end;

procedure TCHP.SetFColor(Value : Longint);
var
  F: TColorEntry;
begin
  if Value <> FFColor then
  begin
    FFColor:= Value;
    if (Kernel <> nil) then
    begin
     if FFColor <> 0 then
     begin
    {  Kernel.BeforeProperty(propCHP);}

      FForeColor:= Kernel.ColorTable[Pred(FFColor)];
{      if FFColor > 0 then
       Kernel.ChangeProperty(propCHP, ipropFColor);}
     end
     else
     FForeColor:= 0;
    end;
  end;
end;

function TCHP.GetBColor: Longint;
begin
  if FBColor > 0 then
   Result:= Kernel.ColorTable[FBColor]
  else
   Result:= 0;
end;

procedure TCHP.SetBColor(Value : Longint);
var
  F: TColorEntry;
begin
  if Value <> FBColor then
  begin
    FBColor:= Value;
    if Kernel <> nil then
    begin
     {if FFColor <> 0 then
      Kernel.BeforeProperty(propCHP);}

      FBackColor:= Kernel.ColorTable[{Pred}(FBColor)];

{     if FFColor > 0 then
      Kernel.ChangeProperty(propCHP, ipropColorB);}
    end;
  end;
end;

function TCHP.GetHighlight: Longint;
begin
  if FHighlight > 0 then
    Result:= {TColorSet[FHighlight]} Kernel.ColorTable[FHighlight]
  else
    Result:= 0;
end;

procedure TCHP.SetHighlight(Value: Longint);
begin
  if Value <> FHighlight then
  begin
    FHighlight:= Value {TColorSet[Value]};
    if FHighlight <> 0 then
    begin
{      if Assigned(Kernel) then
      begin
       Kernel.BeforeProperty(propCHP);
       Kernel.ChangeProperty(propCHP, ipropHighlight);
      end}
    end;
  end;
end;

procedure TCHP.SetAnime(Value : TAnime);
begin
  if Value <> FAnime then
  begin
    FAnime:= Value;
    {if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropAnime);}
  end;
end;

procedure TCHP.SetBold(Value : TRTFBool);
begin
  if Value <> FBold then
  begin
{    if Assigned(Kernel) and not Saving then
      Kernel.BeforeProperty(propCHP);}
    FBold:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropBold);}
    IsDefault:= False;
  end;
end;

procedure TCHP.SetPos(Value : TCharPosition);
begin
  if Value <> FPos then
  begin
{    if Assigned(Kernel) and not Saving  then
      Kernel.BeforeProperty(propCHP);}
    FPos:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropPos);}
  end;
end;

procedure TCHP.SetUnderline(Value : TUnderline);
begin
  if Value <> FUnderline then
  begin
    {if Assigned(Kernel) and not Saving  then
      Kernel.BeforeProperty(propCHP);}

    FUnderline:= Value;
    if FUnderline = utDotted then
      ;
    {if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropUnderline);}
  end;
end;

procedure TCHP.SetItalic(Value : TRTFBool);
begin
  if Value <> FItalic then
  begin
{    if Assigned(Kernel) then
      Kernel.BeforeProperty(propCHP);}
    FItalic:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropItalic);}
  end;
end;

procedure TCHP.SetCaps(Value : TCharCapsType);
begin
  if Value <> FCaps then
  begin
{    if Assigned(Kernel) and not Saving  then
      Kernel.BeforeProperty(propCHP);}
    FCaps:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropAllCaps);}
  end;
end;

procedure TCHP.SetHidden(Value : TRTFBool);
begin
  if Value <> FHidden then
  begin
{    if Assigned(Kernel) and not Saving  then
      Kernel.BeforeProperty(propCHP);}
    FHidden:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropHidden);}
  end;
end;

procedure TCHP.SetDeleted(Value : TRTFBool);
begin
  if Value <> FDeleted then
  begin
{    if Assigned(Kernel) and not Saving  then
      Kernel.BeforeProperty(propCHP);}
    FDeleted:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropDeleted);}
  end;
end;

procedure TCHP.SetCharScale(Value : Integer);
begin
  if Value <> FCharScale then
  begin
{    if Assigned(Kernel) and not Saving  then
      Kernel.BeforeProperty(propCHP);}
    FCharScale:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, iproPAnsiCharScale);}
  end;
end;

procedure TCHP.SetSubpos(Value : Integer);
begin
  if Value <> FSubpos then
  begin
{    if Assigned(Kernel) and not Saving  then
      Kernel.BeforeProperty(propCHP);}
    FSubpos:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropSubpos);}
  end;
end;

procedure TCHP.SetContour(Value : TContourType);
begin
  if Value <> FContour then
  begin
{    if Assigned(Kernel) and not Saving  then
      Kernel.BeforeProperty(propCHP);}
    FContour:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropEmbo);}
  end;
end;

procedure TCHP.SetFontNumber(Value : Integer);
begin
  if Value <> FFontNumber then
  begin
    FFontNumber:= Value;

{    if Assigned(Kernel) and not Saving then
    begin
      Kernel.BeforeProperty(propCHP);
      Kernel.ChangeProperty(propCHP, ipropFontNumber);
    end;}
  end;
end;

procedure TCHP.SetFontSize(Value : Integer);
begin
  if Value <> FFontSize then
  begin
    FFontSize:= Value;
    {if Assigned(Kernel) and not Saving  then
    begin
      Kernel.BeforeProperty(propCHP);
      Kernel.ChangeProperty(propCHP, ipropFontSize);
    end;}
  end;
end;

procedure TCHP.SetLanguage(Value : Integer);
begin
  if Value <> FLanguage then
  begin
{    if Assigned(Kernel) then
      Kernel.BeforeProperty(propCHP);}
    FLanguage:= Value;
{    if Assigned(Kernel) then
      Kernel.ChangeProperty(propCHP, ipropLanguage);}
  end;
end;

procedure TCHP.Merge(aCHP: TCHP);
begin
 IsDefault:= False;
 if aCHP.Anime <> atNotDefined then
   FAnime:= ACHP.Anime;
 if aCHP.Bold <> boolNotDefined then
   FBold:= ACHP.Bold;
 if aCHP.Underline <> utNotDefined then
   FUnderline:= ACHP.Underline;
 if aCHP.Italic <> boolNotDefined then
   FItalic:= ACHP.Italic;
 if aCHP.Caps <> ccNotDefined then
   FCaps:= ACHP.Caps;
 if aCHP.Hidden <> boolNotDefined then
   FHidden:= ACHP.Hidden;
 if aCHP.Deleted <> boolNotDefined then
   FDeleted:= ACHP.Deleted;
 if aCHP.CharScale <> -1 then
   FCharScale:= ACHP.CharScale;
 if aCHP.Subpos <> -1 then
   FSubpos:= ACHP.Subpos;
 if aCHP.Contour  <> ctNotDefined then
   FContour:= ACHP.Contour;
 if aCHP.FontNumber <> -1 then
   FFontNumber:= ACHP.FontNumber;
 if aCHP.FontSize <> -1 then
   FFontSize:= ACHP.FontSize;
 if aCHP.Language <> -1 then
   FLanguage:= ACHP.Language;
 if aCHP.FFColor <> -1 then
   FColor:= ACHP.FFColor;
 {FForeColor:= aCHP.FFOreColor;}
 BColor:= ACHP.FBColor;
{ FBAckColor:= aCHP.FBackColor;}
 Highlight:= aCHP.FHighlight;

 Pos:= aCHP.Pos;
end;

function TCHP.Compare(Value: Tl3Base): Long;
  {override;}
  {-}
begin
 Result := 1;
 if not(Value Is TCHP) then Exit;
 if Anime <> TCHP(Value).Anime then
   Exit;
 if Bold <> TCHP(Value).Bold then
   Exit;
 if Underline <> TCHP(Value).Underline then
   Exit;
 if Italic <> TCHP(Value).Italic then
   Exit;
 if Caps <> TCHP(Value).Caps then
   Exit;
 if Hidden <> TCHP(Value).Hidden then
   Exit;
 if Deleted <> TCHP(Value).Deleted then
   Exit;
 if CharScale <> TCHP(Value).CharScale then
   Exit;
 if Subpos <> TCHP(Value).Subpos then
   Exit;
 if Contour <> TCHP(Value).Contour then
   Exit;
 if FontNumber <> TCHP(Value).FontNumber then
   Exit;
 if FontSize <> TCHP(Value).FontSize then
   Exit;
 if Language <> TCHP(Value).Language then
   Exit;
 if FColor <> TCHP(Value).FColor then
   Exit;
 if BColor <> TCHP(Value).BColor then
   Exit;
 if Pos <> TCHP(Value).Pos then
   Exit;
 if Highlight <> TCHP(Value).Highlight then
   Exit;
 Result:= 0;
end;

{================== TPAP ================================}
procedure TPAP.SetxaLeft(Value: Longint);                 { left indent in twips }
begin
  if Value <> FxaLeft then
  begin
    FxaLeft:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropLeft);
    end;
  end;
end;

procedure TPAP.SetxaRight(Value: Longint);                { right indent in twips }
begin
  if Value <> FxaRight then
  begin
    FxaRight:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropRight);
    end;
  end;
end;

procedure TPAP.SetxaFirst(Value: Longint);                { first line indent in twips }
begin
  if Value <> FxaFirst then
  begin
    FxaFirst:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropFirst);
    end;
  end;
end;

procedure TPAP.SetJUST(Value : Tjust);                  { justification  }
begin
  if Value <> FJust then
  begin
    FJust:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropJust);
    end;
  end;
end;

procedure TPAP.SetHyph(Value: TRTFBool);  { автоперенос слов }
begin
  if Value <> FHyph then
  begin
    FHyph:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropHyph);
    end;
  end;
end;

procedure TPAP.SetInTable(Value: TRTFBool); { часть таблицы }
begin
  if Value <> FInTable then
  begin
    FInTable:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropInTable);
    end;
  end;
end;

procedure TPAP.Setkeep(Value: TRTFBool);       { не разрывать абзац }
begin
  if Value <> FKeep then
  begin
    FKeep:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropKeep);
    end;
  end;
end;

procedure TPAP.SetKeepWNext(Value: TRTFBool);  { не отрывать от следующего }
begin
  if Value <> FKeepWNext then
  begin
    FKeepWNext:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropKeepWNext);
    end;
  end;
end;

procedure TPAP.SetNoLine(Value: TRTFBool);     { не нумеровать строки }
begin
  if Value <> FNoLine then
  begin
    FNoLine:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropNoLine);
    end;
  end;
end;

procedure TPAP.SetBreakBefore(Value: TRTFBool);{ разрыв страницы до абзаца }
begin
  if Value <> FBreakBefore then
  begin
    FBreakBefore:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropBreakBefore);
    end;
  end;
end;

procedure TPAP.SetSideBSide(Value: TRTFBool);  { спина к спине }
begin
  if Value <> FSideBSide then
  begin
    FSideBSide:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropSideBSide);
    end;
  end;
end;

procedure TPAP.SetBefore(Value: Integer);     { отбивка до }
begin
  if Value <> FBefore then
  begin
    FBefore:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropTop);
    end;
  end;
end;

procedure TPAP.SetAfter(Value : Integer);     { после }
begin
  if Value <> FAfter then
  begin
    FAfter:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropBottom);
    end;
  end;
end;

procedure TPAP.SetBetween(Value: Integer);    { интерлиньяж }
begin
  if Value <> FBetween then
  begin
    FBetween:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropBetween);
    end;
  end;
end;

procedure TPAP.SetLineSpaceExact(Value: TRTFBool);{ использовать интерлиньяж как значение или множитель }
begin
  if Value <> FLineSpaceExact then
  begin
    FLineSpaceExact:= Value;
    if Kernel <> nil then
    begin
      IsDefault:= False;
      Kernel.ChangeProperty(propPAP, ipropLineSpaceExact);
    end;
  end;
end;

destructor TPAP.Destroy;
begin
 l3Free(FBorder);
 inherited Destroy;
end;

constructor TPAP.Create(AReader: TObject);
begin
  inherited Create(aReader);
  FxaLeft:= 0;
  FxaRight:= 0;                { right indent in twips }
  FxaFirst:= 0;                { first line indent in twips }
  FJUST := justL;                  { justification  }
  FHyph:= boolFalse;  { автоперенос слов }
  FInTable:= boolFalse; { часть таблицы }
  Fkeep:= boolFalse;       { не разрывать абзац }
  FKeepWNext:= boolFalse;  { не отрывать от следующего }
  FNoLine:= boolTrue;     { не нумеровать строки }
  FBreakBefore:= boolFalse;{ разрыв страницы до абзаца }
  FSideBSide:= boolFalse;  { спина к спине }
  FBefore:= 0;     { отбивка до }
  FAfter := 0;     { после }
  FBetween:= 0;    { интерлиньяж }
  FLineSpaceExact:= boolTrue;{ использовать интерлиньяж как значение или множитель }
  FBorder:= TBorder.Create(aReader);
end;

procedure TPAP.Clear;
begin
 inherited Clear;
  {
  if Kernel <> nil and not Saving then
      Kernel.BeforeProperty(propPAP);
  }
  IsDefault:= True;
  FxaLeft:= 0;
  FxaRight:= 0;                { right indent in twips }
  FxaFirst:= 0;                { first line indent in twips }
  FJUST := justL;                  { justification  }
  Hyph:= boolFalse;  { автоперенос слов }
  InTable:= boolFalse; { часть таблицы }
  keep:= boolFalse;       { не разрывать абзац }
  KeepWNext:= boolFalse;  { не отрывать от следующего }
  NoLine:= boolTrue;     { не нумеровать строки }
  BreakBefore:= boolFalse;{ разрыв страницы до абзаца }
  SideBSide:= boolFalse;  { спина к спине }
  FBefore:= 0;     { отбивка до }
  FAfter := 0;     { после }
  FBetween:= 0;    { интерлиньяж }
  FLineSpaceExact:= boolTrue;{ использовать интерлиньяж как значение или множитель }
  FBorder.Clear;
end;

function TPAP.RTFToken: AnsiString;
begin
  Result:= '';
  if not IsDefault then
  try
    if xaLeft <> 0 then
      Result:= Kernel.KW(valu_li, xaLeft, False);
    if xaRight <> 0 then
      Result:= Result + Kernel.KW(valu_ri, xaRight, False);
    if xaFirst <> 0 then
      Result:= Result + Kernel.KW(valu_fi, xaFirst, False);
    case JUST of
     justL: Result:= Result + Kernel.KW(flag_ql, 0, False);
     justR: Result:= Result + Kernel.KW(flag_qr, 0, False);
     justC: Result:= Result + Kernel.KW(flag_qc, 0, False);
     justF: Result:= Result + Kernel.KW(flag_qj, 0, False);
    end;
    if Hyph = boolTrue then
      Result:= Result + Kernel.KW(togg_HyphPar, 1, False);
    if InTable = boolTrue then
      Result:= Result + Kernel.KW(flag_intbl, Ord(True), False);
    (*
    keep:= False;       { не разрывать абзац }
    KeepWNext:= False;  { не отрывать от следующего }
    NoLine:= True;     { не нумеровать строки }
    BreakBefore:= False;{ разрыв страницы до абзаца }
    SideBSide:= False;  { спина к спине }
    FBetween:= 0;    { интерлиньяж }
    FLineSpaceExact:= True;{ использовать интерлиньяж как значение или множитель }
    *)
    Result:= Result + Kernel.KW(valu_sb, Before, False);
    Result:= Result + Kernel.KW(valu_sa, After, True);
  except
  end;
end;

procedure TPAP.Assign(APAP: TPAP);
begin
 IsDefault:= IsDefault;
 InTable:= APAP.InTable;
 xaLeft:= APAP.xaLeft;
 xaRight:= APAP.xaRight;                { right indent in twips }
 xaFirst:= APAP.xaFirst;                { first line indent in twips }
 JUST := APAP.Just;                  { justification  }
 Hyph:= APAP.Hyph;  { автоперенос слов }
 keep:= APAP.Keep;       { не разрывать абзац }
 KeepWNext:= APAP.KeepWNext;  { не отрывать от следующего }
 NoLine:= APAP.NoLine;     { не нумеровать строки }
 BreakBefore:= APAP.BreakBefore;{ разрыв страницы до абзаца }
 SideBSide:= APAP.SideBSide;  { спина к спине }
 Before:= APAP.Before;     { отбивка до }
 After := APAP.After;     { после }
 Between:= APAP.Between;    { интерлиньяж }
 LineSpaceExact:= APAP.LineSpaceExact;{ использовать интерлиньяж как значение или множитель }
 FBorder.Assign(APAP.Border);
end;

{ start class TTableCell }

constructor TTableCell.Create(aReader: TObject);
begin
 inherited Create(aReader);
 f_Border := TBorder.Create(aReader);
end;

procedure TTableCell.Assign(aCell: TPersistent);
  {override;}
  {-}
begin
 if (aCell Is TTableCell) then begin
  f_Width := TTableCell(aCell).f_Width;
  f_Border.Assign(TTableCell(aCell).f_Border);
 end else
  inherited Assign(aCell);
end;

function TTableCell.GetReader: TRTFKernel;
begin
 Result:= Border.Kernel;
end;

procedure TTableCell.Cleanup;
  {override;}
  {-}
begin
 l3Free(f_Border);
 inherited;
end;

{ start class TTAP }

constructor TTAP.Create(aReader: TObject);
  {override;}
  {-}
begin
 inherited Create(nil);
 FCells := Tl3PersistentList.Create(nil);
 FBorder := TBorder.Create(aReader);
 SetDefault;
end;

destructor TTAP.Destroy;
begin
 l3Free(FCells);
 l3Free(FBorder);
 inherited Destroy;
end;

procedure TTAP.Assign(aTAP: TPersistent);
var
  C, c1: TTableCell;
  i: Integer;
begin
 if (aTAP Is TTAP) then begin
  { Здесь нужно присвоить свойства одной таблицы другой }
  FBorder.Assign(TTAP(aTAP).Border);
  FCells.Clear;
  for i := 0 to TTAP(aTAP).FCells.Hi do begin
   C1 := TTAP(aTAP).FCells[i];
   C := C1.Clone(C1.Reader);
   try
    FCells.Add(C);
   finally
    l3Free(C);
   end;{try..finally} 
  end;{for i..}
  Left:= TTAP(aTAP).Left;
  Gaph:= TTAP(aTAP).Gaph;
 end else
  inherited Assign(aTAP); 
end;

function TTAP.GetCells(Index: Integer): TTableCell;
begin
 try
   Result:= TTableCell(FCells[Index])
 except
   Result:= nil;
 end;
end;

function TTAP.GetCellCount: Integer;
begin
 Result:= FCells.Count;
end;

procedure TTAP.Clear;
begin
 FCells.Clear;
end;

procedure TTAP.SetDefault;
var
 i : Integer;
begin
 Gaph:= 108;
 Left:= -108;
 for i := 0 to FCells.Hi do begin
  with TTableCell(FCells[i]) do begin
   f_Width := 0;
   f_Border.Clear;
  end;{with TTableCell..}
 end;{for i..}
 Border.Clear;
end;

constructor TStanding.Create(aStanding: TStanding; aReader: TRTFKernel);
begin
 inherited Create;
 CHP:= TCHP.Create(AReader);
 CHP.Reset;
 PAP:= TPAP.Create(AReader);
 BOP:= TBorder.Create(AReader);
 TAP:= TTAP.Create(aReader);
 if Assigned(aStanding) then begin
  PAP.Assign(aStanding.PAP);
  CHP.Assign(aStanding.CHP);
  BOP.Assign(aStanding.BOP);
  RDS:= aStanding.RDS;
  RIS:= aStanding.RIS;
  TAP.Assign(aStanding.TAP);
 end else begin
  RDS:= rdsNorm;
  RIS:= risNorm;
 end;
end;

destructor TStanding.Destroy;
begin
 l3Free(fCHP);
 l3Free(fPAP);
 l3Free(fBOP);
 l3Free(fTAP);
 inherited Destroy;
end;

constructor TDOP.Create;
begin
 inherited Create;
 xaPage:= 12240;
 yaPage:= 15840;
 xaLeft:= 1800;
 xaRight:= 1800;
 yaTop:= 1440;
 yaBottom:= 1440;
 xGutter:= 0;
end;


procedure TBorder.Clear;
begin
 inherited Clear;
 FTop.Clear;
 FBottom.Clear;
 FLeft.Clear;
 FRight.Clear;
 FHorizontal.Clear;
 FVertical.Clear;
end;

procedure TBorder.Assign(aBorder: TPersistent);
begin
 if (aBorder Is TBorder) then begin
  FTop.Assign(TBorder(aBorder).FTop);
  FBottom.Assign(TBorder(aBorder).FBottom);
  FLeft.Assign(TBorder(aBorder).FLeft);
  FRight.Assign(TBorder(aBorder).FRight);
  FHorizontal.Assign(TBorder(aBorder).FHorizontal);
  FVertical.Assign(TBorder(aBorder).FVertical);
 end else
  inherited Assign(aBorder);
end;

constructor TBorder.Create(AReader: TObject);
begin
  inherited Create(aReader);
  FTop:= TBorderPart.Create(nil);
  FLeft:= TBorderPart.Create(nil);
  FBottom:= TBorderPart.Create(nil);
  FRight:= TBorderPart.Create(nil);
  FHorizontal:= TBorderPart.Create(nil);
  FVertical:= TBorderPart.Create(nil);
end;

destructor TBorder.Destroy;
begin
  l3Free(FTop);
  l3Free(FLeft);
  l3Free(FBottom);
  l3Free(FRight);
  l3Free(FHorizontal);
  l3Free(FVertical);
  inherited Destroy;
end;

function TBorder.GetFrameColor(Index: TBorderParts): Longint;
begin
  if Frames[Index].FColor > 0 then
    Result:= Kernel.ColorTable[Frames[Index].FColor]
  else
    Result:= 0;
end;

function TBorder.GetFrameWidth(Index: TBorderParts): Longint;
begin

  if Frames[Index].FWidth > 0 then
    Result:= Frames[Index].FWidth
  else
    Result:= 0;
end;

function TBorder.GetFrameType(Index: TBorderParts): TBorderType;
begin
  Result:= Frames[Index].FType
end;

procedure TBorder.SetFrameColor(Index: TBorderParts; Value: Longint);
begin
  if Index = bpBox then
  begin
    FrameColor[bpTop]:= Value;
    FrameColor[bpLeft]:= Value;
    FrameColor[bpRight]:= Value;
    FrameColor[bpBottom]:= Value;
  end
  else
  if Frames[Index].FColor <> Value then
    Frames[Index].FColor := Value;
end;

procedure TBorder.SetFrameWidth(Index: TBorderParts; Value: Longint);
begin
  if Index = bpBox then
  begin
    FrameWidth[bpTop]:= Value;
    FrameWidth[bpLeft]:= Value;
    FrameWidth[bpRight]:= Value;
    FrameWidth[bpBottom]:= Value;
  end
  else
  if Frames[Index].FWidth <> Value then
    Frames[Index].FWidth := Value;
end;

procedure TBorder.SetFrameType(Index: TBorderParts; Value: TBorderType);
begin
  if Index = bpBox then
  begin
    FrameType[bpTop]:= Value;
    FrameType[bpLeft]:= Value;
    FrameType[bpRight]:= Value;
    FrameType[bpBottom]:= Value;
  end
  else
  if Frames[Index].FType <> Value then
  begin
    Frames[Index].FType := Value;
    {if Value <> btNone then
      Frames[Index].FWidth:= 10;}
  end;
end;

function TBorder.GetIsFramed: Boolean;
begin
  Result:= (FrameType[bpTop] <> btNone) or
           (FrameType[bpLeft] <> btNone) or
           (FrameType[bpBottom] <> btNone) or
           (FrameType[bpRight] <> btNone);
end;

function TBorder.GetFrames(Index: TBorderParts): TBorderPart;
begin
  case Index of
    bpTop        : Result:= FTop;
    bpLeft       : Result:= FLeft;
    bpBottom     : Result:= FBottom;
    bpRight      : Result:= FRight;
    bpHorizontal : Result:= FHorizontal;
    bpVertical   : Result:= FVertical;
  else
    Result:= nil;
  end;
end;

procedure TBorder.SetFrames(Index: TBorderParts; Value: TBorderPart);
begin

end;

function TBorder.GetFrameSpace(Index: TBorderParts): Integer;
begin
 Result:= Frames[Index].FSpace;
end;

procedure TBorder.SetFrameSpace(Index: TBorderParts; Value: Integer);
begin
 Frames[Index].FSpace:= Value;
end;

procedure TBorderPart.Clear;
  {override;}
  {-}
begin
 FType:= btNone;
 FColor:= 0;
 FWidth:= 0;
 Enable:= boolFalse;
 FSpace:= 20;
end;

procedure TBorderPart.Assign(BP: TPersistent);
  {override;}
  {-}
begin
 if (BP Is TBorderPart) then begin
  FType:= TBorderPart(BP).FType;
  FColor:= TBorderPart(BP).FColor;
  FWidth:= TBorderPart(BP).FWidth;
  Enable:= TBorderPart(BP).Enable;
  FSpace:= TBorderPart(BP).FSpace;
 end else
  inherited Assign(BP);
end;

constructor TRTFStyle.Create(aReader: TRTFKernel);
begin
 inherited Create(aReader);
 FCHP:= TCHP.Create(aReader);
 FCHP.Reset;
 FPAP:= TPAP.Create(aReader);
end;

destructor TRTFStyle.Destroy;
begin
 l3Free(FCHP);
 l3Free(FPAP);
 inherited Destroy;
end;

constructor TPropertyObject.Create(aKernel: TObject);
  {override;}
  {-}
begin
 inherited Create(aKernel);
 FKernel:= aKernel As TRTFKernel;
 FIsDefault:= True;
end;

end.
