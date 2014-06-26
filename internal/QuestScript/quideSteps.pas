unit quideSteps;

interface

uses
 quideObject, quideLocations;

type
  //1 Глава сценария
  TquideChapter = class(TquideObject)
  private
    f_Locations: TquideLocations;
    function pm_GetLocations(Index: Integer): TquideLocation;
    function pm_GetLocationsCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddLocation: TquideLocation;
    procedure Delete(Index: Integer);
    //1 Возвращает локацию с указанным именем или nil  
    function IsValidLocation(const aCaption: String): TquideLocation;
    //1 Список локаций шага сценария
    property Locations[Index: Integer]: TquideLocation read pm_GetLocations;
        default;
    property LocationsCount: Integer read pm_GetLocationsCount;
  end;


implementation

Uses
  SysUtils;

{
******************************** TquideChapter *********************************
}
constructor TquideChapter.Create;
begin
  inherited Create;
  f_Locations := TquideLocations.Create();
end;

destructor TquideChapter.Destroy;
begin
  FreeAndNil(f_Locations);
  inherited Destroy;
end;

function TquideChapter.AddLocation: TquideLocation;
begin
 Result:= f_Locations.Add;
end;

procedure TquideChapter.Delete(Index: Integer);
begin
 f_Locations.Delete(Index);
end;

function TquideChapter.IsValidLocation(const aCaption: String): TquideLocation;
var
  i: Integer;
begin
 Result:= nil;
 for i:= 0 to Pred(LocationsCount) do
  if AnsiSameText(Locations[i].Caption, aCaption) then
  begin
   Result:= Locations[i];
   break;
  end;
end;

function TquideChapter.pm_GetLocations(Index: Integer): TquideLocation;
begin
 Result:= TquideLocation(f_Locations[index]);
end;

function TquideChapter.pm_GetLocationsCount: Integer;
begin
 Result:= f_Locations.Count;
end;



end.
