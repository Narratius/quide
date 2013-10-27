unit dobQM;

interface

uses
 QuestModeler,
 DrawObjects2;

type
 TdoModel = class(TdcScript)
 private
  f_Height: Integer;
  f_Width: Integer;
  procedure pm_SetHeight(const Value: Integer);
  procedure pm_SetWidth(const Value: Integer);
 protected
  function CreateLocation: TdcLocation; override;
 public
  constructor Create(aModel: TdcScript);
  destructor Destroy; override;
  procedure GetFreePosition(var aLeft, aTop: Integer);
  property Height: Integer read f_Height write pm_SetHeight;
  property Width: Integer read f_Width write pm_SetWidth;
 end;

 TdoLocation = class(TRectangle)
 private
  f_Location: TdcLocation;
  procedure pm_SetLocation(const Value: TdcLocation);
 protected
 public
  function ResizeObjectToFitText: boolean; override;
  property Location: TdcLocation read f_Location write pm_SetLocation;
 end;

implementation

uses Classes, Math;


const
 cLocationWidth  = 100;
 cLocationHeight = 50;
 cSpace          = 20;

constructor TdoModel.Create(aModel: TdcScript);
begin
 inherited;
 f_Height:= 1000;
 f_Width:= 1000;
 //NewLocation('Начало');
end;

destructor TdoModel.Destroy;
begin
  inherited;
end;

function TdoModel.CreateLocation: TdcLocation;
begin
 Result:= TdcLocation.Create(Self);
end;

procedure TdoModel.GetFreePosition(var aLeft, aTop: Integer);
var
 l_StepX, l_StepY,
 l_X, l_Y: Word;
begin
{ TODO -oДимка -cУлучшение : Нужно поправить расчет позиции для новой локации }
 l_StepX:= f_Width div (2*cSpace + cLocationWidth);
 l_StepY:= f_Height div (2*cSpace + cLocationHeight);
 DivMod(LocationsCount, l_StepY, l_X, l_Y);
 aLeft:= cSpace + l_X*(2*cSpace + cLocationWidth);
 aTop:= cSpace + l_Y*(2*cSpace + cLocationHeight);
end;

procedure TdoModel.pm_SetHeight(const Value: Integer);
begin
 f_Height := Value;
end;

procedure TdoModel.pm_SetWidth(const Value: Integer);
begin
 f_Width := Value;
end;

procedure TdoLocation.pm_SetLocation(const Value: TdcLocation);
begin
 if Value <> nil then
 begin
  f_Location := Value;
  Strings.Text:= f_Location.Caption;
  Hint:= f_Location.Hint;
 end; // Value <> nil
end;

//------------------------------------------------------------------------------

function TdoLocation.ResizeObjectToFitText: boolean;
begin
 Result := False;
end;

initialization
 RegisterClasses([TdoLocation]);
end.
