unit quideLocations;

interface

uses
 Generics.Collections, Xml.XMLIntf,
 quideObject, quideActions, Propertys;

type
  TquideLocation = class(TquideObject)
  private
    f_Actions: TObjectList<TquideAction>;
    f_ID: Integer;
    f_Found: Boolean;
    function pm_GetActions(Index: Integer): TquideAction;
    function pm_GetActionsCount: Integer;
    function FindAction(aItem: TddProperty): Boolean;
    function pm_GetLinks(Index: Integer): String;
    function pm_GetLinksCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddAction(aActType: TquideActionType): TquideAction; overload;
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    procedure AddAction(aAction: TquideAction); overload;
    function ActionByID(aActionID: Integer): TquideAction;
    procedure CheckTargets(const OldCaption, NewCaption: String);
    property Actions[Index: Integer]: TquideAction read pm_GetActions; default;
    //1 Количество действий на локации
    property ActionsCount: Integer read pm_GetActionsCount;
    property LinksCount: Integer
      read pm_GetLinksCount;
    property Links[Index: Integer]: String
      read pm_GetLinks;
  end;


implementation

Uses
 SysUtils;


{
******************************** TquideLocation ********************************
}
function TquideLocation.ActionByID(aActionID: Integer): TquideAction;
var
 i: Integer;
begin
  Result:= nil;
  f_ID:= aActionID;
  f_Found:= False;
  for I := 0 to Pred(ActionsCount) do
  begin
    Actions[i].IterateAll(FindAction);
    if f_Found then
    begin
      Result:= Actions[i];
      break
    end;
  end;
end;

procedure TquideLocation.AddAction(aAction: TquideAction);
begin
 aAction.Index:= f_Actions.Add(aAction);
end;

function TquideLocation.AddAction(aActType: TquideActionType): TquideAction;
begin
 Result:= nil;
 case aActType of
   atNone: Result:= nil;
   atGoto: Result:= TquideJumpAction.Create;
   atInventory: Result:= nil;
   atLogic: Result:= TquideLogicalAction.Create;
   atText: Result:= TquideTextAction.Create;
   atVariable: Result:= TquideVariableAction.Create;
   atButton: Result:= TquideButtonAction.Create;
 end;
 if Result <> nil then
  AddAction(Result);
end;

procedure TquideLocation.CheckTargets(const OldCaption, NewCaption: String);
var
 i: Integer;
begin
  if not AnsiSameText(OldCaption, NewCaption) then

   for I := 0 to Pred(ActionsCount) do
    if Actions[i].ActionType = atButton then
    begin
      if Actions[i].Values['Target'] = OldCaption then
      begin
        Actions[i].Values['Target'] := NewCaption;
        break
      end;
    end;
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

function TquideLocation.FindAction(aItem: TddProperty): Boolean;
begin
  Result:= True;
  if aItem.ID = f_ID  then
  begin
    f_Found:= True;
    Result:= False;
  end;
end;

procedure TquideLocation.LoadFromXML(Element: IXMLNode);
var
 l_Node: IXMLNode;
 i: Integer;
 l_Action: TquideAction;
begin
 inherited LoadFromXML(Element, False);
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



function TquideLocation.pm_GetLinks(Index: Integer): String;
var
  i, l_Count: Integer;
begin
  l_Count:= -1;
  Result:= '';
  for I := 0 to pred(ActionsCount) do
    if Actions[i].ActionType = atButton then
    begin
     Inc(l_Count);
     if l_Count = Index then
     begin
      Result:= TquideButtonAction(Actions[i]).Values['Target'];
      break
     end;
    end;
end;

function TquideLocation.pm_GetLinksCount: Integer;
var
 i: Integer;
begin
  Result:= 0;
  for I := 0 to pred(ActionsCount) do
    if Actions[i].ActionType = atButton then
     Inc(Result);
end;

procedure TquideLocation.SaveToXML(Element: IXMLNode);
var
 l_Node: IXMLNode;
 i: Integer;
begin
 inherited SaveToXML(Element, False);
 l_Node:= Element.AddChild('Actions');
 for I := 0 to ActionsCount-1 do
  Actions[i].SaveToXML(l_Node.AddChild('Action'));
end;


end.
