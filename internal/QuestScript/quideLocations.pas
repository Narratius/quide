unit quideLocations;

interface

uses
 Generics.Collections, Xml.XMLIntf,
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
    function AddAction(aActType: TquideActionType): TquideAction; overload;
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    procedure AddAction(aAction: TquideAction); overload;
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
 SysUtils,
 Propertys;


{
******************************** TquideLocation ********************************
}
procedure TquideLocation.AddAction(aAction: TquideAction);
begin
 aAction.Index:= f_Actions.Add(aAction);
end;

function TquideLocation.AddAction(aActType: TquideActionType): TquideAction;
begin
 Result:= nil;
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
  AddAction(Result);
end;

constructor TquideLocation.Create;
begin
  inherited Create;
  Define('GraphObject', 'Визуальный элемент', ptInteger, False);
  f_Actions := TObjectList<TquideAction>.Create();
end;

destructor TquideLocation.Destroy;
begin
  FreeAndNil(f_Actions);
  inherited Destroy;
end;

procedure TquideLocation.LoadFromXML(Element: IXMLNode);
var
 l_Node: IXMLNode;
 i: Integer;
 l_Action: TquideAction;
begin
 inherited;
 l_Node:= Element.ChildNodes.FindNode('Actions');
 if l_Node <> nil then
  for I := 0 to l_Node.ChildNodes.Count-1 do
   AddAction(TquideAction.Make(l_Node.ChildNodes.Get(i)));
end;

function TquideLocation.pm_GetActions(Index: Integer): TquideAction;
begin
 Result:= f_Actions[index]
end;

function TquideLocation.pm_GetActionsCount: Integer;
begin
 Result:= f_Actions.Count;
end;



procedure TquideLocation.SaveToXML(Element: IXMLNode);
var
 l_Node: IXMLNode;
 i: Integer;
begin
 inherited;
 l_Node:= Element.AddChild('Actions');
 for I := 0 to ActionsCount-1 do
  Actions[i].SaveToXML(l_Node.AddChild('Action'));
end;

end.
