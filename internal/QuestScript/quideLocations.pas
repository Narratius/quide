unit quideLocations;

interface

uses
 Contnrs,
 quideObject, quideActions;

type
  TquideLocation = class(TquideObject)
  private
    f_Actions: TObjectList;
    function pm_GetActions(Index: Integer): TquideAction;
    function pm_GetActionsCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Actions[Index: Integer]: TquideAction read pm_GetActions; default;
    //1 Количество действий на локации
    property ActionsCount: Integer read pm_GetActionsCount;
  end;

  TquideLocations = class(TObjectList)
  private
    function pm_GetItems(Index: Integer): TquideLocation;
    procedure pm_SetItems(Index: Integer; Value: TquideLocation);
  public
    function Add: TquideLocation;
    property Items[Index: Integer]: TquideLocation read pm_GetItems write
        pm_SetItems; default;
  end;

    //1 Переход в другую локацию прямо из текста
  TquideJump = class(TquideAction)
  private
    f_Target: TquideLocation;
  public
    property Target: TquideLocation read f_Target write f_Target;
  end;

  //1 Кнопка для перехода в другую локацию
  TquideButton = class(TquideJump)
  end;

implementation

{
******************************* TquideLocations ********************************
}
function TquideLocations.Add: TquideLocation;
begin
end;

function TquideLocations.pm_GetItems(Index: Integer): TquideLocation;
begin
end;

procedure TquideLocations.pm_SetItems(Index: Integer; Value: TquideLocation);
begin
end;

{
******************************** TquideLocation ********************************
}
constructor TquideLocation.Create;
begin
  inherited Create;
  f_Actions := TObjectList.Create();
end;

destructor TquideLocation.Destroy;
begin
  FreeAndNil(f_Actions);
  inherited Destroy;
end;

function TquideLocation.pm_GetActions(Index: Integer): TquideAction;
begin
 Result:= TquideAction(f_Actions[i])
end;

function TquideLocation.pm_GetActionsCount: Integer;
begin
 Result:= f_Actions.Count;
end;



end.
