unit ddRTFState;

interface

uses
  Classes, ddBase, l3ProtoPersistent, RTfTypes, l3ProtoPersistentRefList,
  ddCharacterProperty, ddParagraphProperty;

type
  TddRTFState = class(Tl3ProtoPersistent)
  private
    FBOP: TddBorder;
    FCHP: TddCharacterProperty;
    FPAP: TddParagraphProperty;
    FTAP: TddRowProperty;
    f_CEP: TddCellProperty;
    f_RDS: TRDS;                                                                   
    f_SEP: TddSectionProperty;
    f_SkipGroup: Boolean;
    procedure pm_SetSEP(const aValue: TddSectionProperty);
  protected
    procedure Cleanup; override;
    procedure SetBOP(Value: TddBorder);
    procedure SetCHP(Value: TddCharacterProperty);
    procedure SetPAP(Value: TddParagraphProperty);
    procedure SetTAP(Value: TddRowProperty);
  public
    constructor Create;
    procedure Assign(aSource: TPersistent); override;
    function Clone: TddRTFState;
    property BOP: TddBorder read FBOP write SetBOP;
    property CEP: TddCellProperty read f_CEP write f_CEP;
    property CHP: TddCharacterProperty read FCHP write SetCHP;
    property PAP: TddParagraphProperty read FPAP write SetPAP;
    property RDS: TRDS read f_RDS write f_RDS;
    property SEP: TddSectionProperty read f_SEP write pm_SetSEP;
    property SkipGroup: Boolean read f_SkipGroup write f_SkipGroup;
    property TAP: TddRowProperty read FTAP write SetTAP;
  end;

 TrtfStateStack = class(Tl3ProtoPersistentRefList)
 public
  function Peek: TddRTFState;
  function Pop: TddRTFState;
  procedure Push;
 end;

implementation

uses
  SysUtils;

{
********************************** TStanding ***********************************
}
constructor TddRTFState.Create;
begin
  inherited;
  fCHP:= TddCharacterProperty.Create(nil);
  fCHP.Reset;
  fPAP:= TddParagraphProperty.Create(nil);
  fBOP:= TddBorder.Create(nil);
  fBOP.isFramed:= False;
  fTAP:= TddRowProperty.Create(nil);
  fTAP.Border.isFramed:= False;
  f_CEP:= TddCellProperty.Create(nil);
  f_CEP.Border.isFramed:= False;
  f_SEP:= TddSectionProperty.Create(nil);
  f_SkipGroup:= False;
  f_RDS:= rdsNone;
end;

procedure TddRTFState.Assign(aSource: TPersistent);
var
 aState: TddRTFState absolute aSource;
begin
  if (aSource Is TddRTFState) then
  begin
   fPAP.Assign(aState.PAP);
   fCHP.Assign(aState.CHP);
   fBOP.Assign(aState.BOP);
   fTAP.Assign(aState.TAP);
   f_Cep.Assign(aState.CEP);
   f_SkipGroup:= aState.SkipGroup;
   f_RDS:= aState.RDS;
   f_SEP.Assign(aState.SEP);
  end
  else
   inherited Assign(aSource);
end;

procedure TddRTFState.Cleanup;
begin
  FreeAndNil(fCHP);
  FreeAndNil(fPAP);
  FreeAndNil(fBOP);
  FreeAndNil(fTAP);
  FreeAndNil(f_CEP);
  FreeAndNil(f_SEP);
  inherited ;
end;

function TddRTFState.Clone: TddRTFState;
begin
 Result := TddRTFState.Create;
 Result.Assign(Self);
end;

procedure TddRTFState.pm_SetSEP(const aValue: TddSectionProperty);
begin
 f_SEP.Assign(aValue);
end;

procedure TddRTFState.SetBOP(Value: TddBorder);
begin
  fBOP.Assign(Value);
end;

procedure TddRTFState.SetCHP(Value: TddCharacterProperty);
begin
  fCHP.Assign(Value);
end;

procedure TddRTFState.SetPAP(Value: TddParagraphProperty);
begin
  fPAP.Assign(Value);
end;

procedure TddRTFState.SetTAP(Value: TddRowProperty);
begin
  fTAP.Assign(Value);
end;

function TrtfStateStack.Peek: TddRTFState;
begin
 Result := TddRTFState(Last);
end;

function TrtfStateStack.Pop: TddRTFState;
begin
 Result := TddRTFState(Last);;
 DeleteLast;
end;

procedure TrtfStateStack.Push;
var
 l_State: TddRTFState;
begin
 l_State := Peek.Clone;
 try
  Add(l_State);
 finally
  FreeAndNil(l_State);
 end;
end;

end.
