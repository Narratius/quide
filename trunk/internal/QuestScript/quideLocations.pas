unit quideLocations;

interface

uses
 Generics.Collections,
 quideObject, quideActions;

type
  TquideLocation = class(TquideObject)
  private
    f_Actions: TObjectList<TquideAction>;
    function pm_GetActions(Index: Integer): TquideAction;
    function pm_GetActionsCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddAction(aActType: TquideActionType): TquideAction;
    property Actions[Index: Integer]: TquideAction read pm_GetActions; default;
    //1 Количество действий на локации
    property ActionsCount: Integer read pm_GetActionsCount;
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

Uses
 SysUtils;


{
******************************** TquideLocation ********************************
}
function TquideLocation.AddAction(aActType: TquideActionType): TquideAction;
begin
 case aActType of
   atNone: Result:= nil;
   atGoto: Result:= TquideJump.Create;
   atInventory: ;
   atLogic: ;
   atText: Result:= TquideTextAction.Create;
   atVariable: ;
   atButton: Result:= TquideButton.Create;
 end;
 if Result <> nil then
   f_Actions.Add(Result);
end;

constructor TquideLocation.Create;
begin
  inherited Create;
  f_Actions := TObjectList<TquideAction>.Create();
end;

destructor TquideLocation.Destroy;
begin
  FreeAndNil(f_Actions);
  inherited Destroy;
end;

function TquideLocation.pm_GetActions(Index: Integer): TquideAction;
begin
 Result:= TquideAction(f_Actions[index])
end;

function TquideLocation.pm_GetActionsCount: Integer;
begin
 Result:= f_Actions.Count;
end;



end.
