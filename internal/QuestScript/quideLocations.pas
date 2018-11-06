unit quideLocations;

interface

uses
 Classes, Generics.Collections, Xml.XMLIntf, Menus,
 quideObject, quideActions, Propertys;

type
  TquideLocation = class(TquideObject)
  private
    //f_Actions: TObjectList<TquideAction>;
    f_ID: Integer;
    f_Found: Boolean;
    function pm_GetActions(Index: Integer): TquideAction;
    function pm_GetActionsCount: Integer;
    function FindAction(aItem: TddProperty): Boolean;
    function pm_GetLinks(Index: Integer): String;
    function pm_GetLinksCount: Integer;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddAction(aActType: TquideActionType); overload;
    procedure AddAction(aAction: TquideAction); overload;
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);

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
  //AliasItems['Actions']
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
 AliasItems['Actions'].AddPropsContent(aAction);
 DoStructChange;
end;

procedure TquideLocation.AddAction(aActType: TquideActionType);
var
 l_A: TquideAction;
begin
 l_A:= nil;
 try
   case aActType of
     atGoto: l_A:= TquideJumpAction.Create(nil);
     atInventory: l_A:= TquideInventoryAction.Create(nil);
     atLogic: l_A:= TquideLogicalAction.Create(nil);
     atText: l_A:= TquideTextAction.Create(nil);
     atVariable: l_A:= TquideVariableAction.Create(nil);
     atButton: l_A:= TquideButtonAction.Create(nil);
   end;
   if l_A <> nil then
    AddAction(l_A);
  finally
    FreeAndNil(l_A);
  end;
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
var
 l_A: TquideActions;
begin
  inherited;
  Define('GraphObject', 'Визуальный элемент', ptInteger, False);
  l_A:= TquideActions.Create(nil);
  try
   DefineProps('Actions', '', l_A);
  finally
   FreeAndNil(l_A);
  end;
  //f_Actions := TObjectList<TquideAction>.Create();
end;

destructor TquideLocation.Destroy;
begin
  //FreeAndNil(f_Actions);
  inherited Destroy;
end;

function TquideLocation.FindAction(aItem: TddProperty): Boolean;
begin
  Result:= True;
  if aItem.UID = f_ID  then
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
  begin
   l_Action:= TquideAction.Make(l_Node.ChildNodes.Get(i));
   try
    AddAction(l_Action);
   finally
    FreeAndNil(l_Action);
   end;
  end;

end;

function TquideLocation.pm_GetActions(Index: Integer): TquideAction;
begin
 Result:= AliasItems['Actions'].ListItem.Items[index].ListItem as TquideAction;
end;

function TquideLocation.pm_GetActionsCount: Integer;
begin
 Result:= AliasItems['Actions'].ListItem.Count;
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
