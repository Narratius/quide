unit ddDocumentAtom;

interface

uses
  Classes, ddBase, k2Prim, l3ProtoPersistentOwnedDataContainer,
  l3ProtoPersistentRefList, l3CBaseRefList, l3Types, RTfTypes,
  ddCharacterProperty, ddParagraphProperty, l3Base;

type
  TddDocumentAtom = class(Tl3ProtoPersistentOwnedDataContainer)
  private
    f_Closed: Boolean;
    f_Owner: TObject;
    f_Type: TddDocAtomType;
    procedure pm_SetClosed(const Value: Boolean);
  protected
    procedure DoClose; virtual;
    // internal methods
    procedure DoSetOwner(Value: TObject); override;
        {-}
    function GetEmpty: Bool; override;
    function GetOwner: TPersistent; override;
  public
    constructor Make(aAtom: TddDocumentAtom);
    procedure Clear; virtual;
    procedure Write2Generator(const Generator: Ik2TagGenerator; const LiteVersion:
            Boolean = False); virtual; abstract;
    function JoinWith(P: TObject; aCorrectSegment: Boolean = False): Long; virtual;
    property AtomType: TddDocAtomType read f_Type write f_Type;
    property Closed: Boolean read f_Closed write pm_SetClosed;
  end;

  TddBreak = class(TddDocumentAtom)
  private
    f_BreakType: TddBreakType;
    f_SEP: TddSectionProperty;
  protected
    procedure Cleanup; override;
  public
    constructor Create(aOwner: TObject); override;
    procedure Write2Generator(const Generator: Ik2TagGenerator; const LiteVersion:
            Boolean = False); override;
    property BreakType: TddBreakType read f_BreakType write f_BreakType;
    property SEP: TddSectionProperty read f_SEP;
  end;

implementation

uses
  SysUtils, PageBreak_Const, k2Tags, SectionBreak_Const, Math, l3Interfaces,
  l3Math, evConst;

procedure TddDocumentAtom.DoSetOwner(Value: TObject);
  {virtual;}
  {-}
begin
 f_Owner := Value;
end;

function TddDocumentAtom.GetEmpty: Bool;
begin
 Result := false;
end;

function TddDocumentAtom.GetOwner: TPersistent;
begin
 Result := f_Owner as TPersistent;
end;

procedure TddDocumentAtom.Clear; //virtual;
begin
end;

constructor TddDocumentAtom.Make(aAtom: TddDocumentAtom);
begin
 Create(nil);
 if aAtom <> nil then
  Assign(aAtom);
end;

procedure TddDocumentAtom.DoClose;
begin
 end;

// start class TddDocumentAtom

function TddDocumentAtom.JoinWith(P: TObject; aCorrectSegment: Boolean = False): Long;
begin
 Result := -1;
end;

procedure TddDocumentAtom.pm_SetClosed(const Value: Boolean);
begin
 f_Closed := Value;
 if f_Closed then
  DoClose;
end;

{
*********************************** TddBreak ***********************************
}
constructor TddBreak.Create(aOwner: TObject);
begin
  inherited;
  AtomType:= dd_docBreak;
  f_SEP:= TddSectionProperty.Create(nil);
end;

procedure TddBreak.Cleanup;
begin
  FreeAndNil(f_SEP);
  inherited;
end;

procedure TddBreak.Write2Generator(const Generator: Ik2TagGenerator; const
        LiteVersion: Boolean = False);
begin
  case BreakType of
    breakPage :
        begin
          Generator.StartChild(k2_idPageBreak);
          Generator.Finish;
        end;
    breakSection:
        begin
          Generator.StartChild(k2_idSectionBreak);
          try
            Generator.StartTag(k2_tiParas);
            try
              if SEP.fLandscape then
              begin
                Generator.AddIntegerAtom(k2_tiOrientation, Ord(l3_poLandscape));
                Generator.AddIntegerAtom(k2_tiHeight, l3MulDiv(Max(SEP.yaPage, SEP.xaPage), evInchMul, rtfTwip));
                Generator.AddIntegerAtom(k2_tiWidth, l3MulDiv(Min(SEP.xaPage, SEP.yaPage), evInchMul, rtfTwip));
              end
              else
              begin
                Generator.AddIntegerAtom(k2_tiOrientation, Ord(l3_poPortrait));
                Generator.AddIntegerAtom(k2_tiHeight, l3MulDiv(Max(SEP.yaPage, SEP.xaPage), evInchMul, rtfTwip));
                Generator.AddIntegerAtom(k2_tiWidth, l3MulDiv(Min(SEP.xaPage, SEP.yaPage), evInchMul, rtfTwip));
              end;
              //Generator.AddIntegerAtom(k2_tiHeight, l3MulDiv(SEP.yaPage, evInchMul, rtfTwip));
              //Generator.AddIntegerAtom(k2_tiWidth, l3MulDiv(SEP.xaPage, evInchMul, rtfTwip));
            finally
              Generator.Finish;
            end;{try..finally}
          finally
            Generator.Finish;
          end;
        end;
  end;
end;

end.
