unit quideActions;

interface

uses
  XMLIntf, Contnrs, Classes, Menus,
  Propertys,
  quideObject, quideVariables, quideLinks, quideConditions;

type
 TquideActionType = (atNone, atGoto, atInventory, atLogic, atText, atVariable, atButton);

 TquideActions = class(TddProperties)
 private
  procedure AddGotoAction(Sender: TObject);
  procedure AddInventoryAction(Sender: TObject);
  procedure AddLogicAction(Sender: TObject);
  procedure AddTextAction(Sender: TObject);
  procedure AddVariableAction(Sender: TObject);
  procedure AddButtonAction(Sender: TObject);
  procedure AddAction(aType: TquideActionType);
 protected
  procedure CreatePopupMenu; override;
 public
  constructor Create(aOwner: TComponent); override;
  destructor Destroy; override;
 public
  //property Menu: TPopupMenu read f_Menu;
 end;

  //1 Базовый объект для действия в локации
  TquideAction = class(TquideObject)
  private
    f_Index: Integer;
    function pm_GetActionType: TquideActionType;
    procedure pm_SetActionType(Value: TquideActionType);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    class function Make(aElement: IXMLNode): TquideAction;
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    //1 Тип действия - текст, кнопка, переход...
    property ActionType: TquideActionType read pm_GetActionType write
        pm_SetActionType;
    property Index: Integer
     read f_Index write f_Index;
  end;

  TquideVariableAction = class(TquideAction)
  private
    f_NewValue: string;
    f_Variable: TquideVariable;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    property NewValue: string read f_NewValue write f_NewValue;
    property Variable: TquideVariable read f_Variable write f_Variable;
  end;

  TquideTextAction = class(TquideAction)
  private
    f_Links: TObjectList;
    function pm_GetLinks(Index: Integer): TquideLink;
    function pm_GetLinksCount: Integer;
    function pm_GetText: string;
    procedure pm_SetText(const Value: string);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddLink(aLink: TquideLink);
    procedure DeleteLink(Index: Integer);
    property Links[Index: Integer]: TquideLink read pm_GetLinks;
    property LinksCount: Integer read pm_GetLinksCount;
    property Text: string read pm_GetText write pm_SetText;
  end;

  TquideLogicalAction = class(TquideAction)
  private
    f_Condition: TquideCondition;
  public
    constructor Create(aOwner: TComponent); override;
    property Condition: TquideCondition read f_Condition write f_Condition;
  end;

    //1 Переход в другую локацию прямо из текста
  TquideJumpAction = class(TquideAction)
  private
  public
    constructor Create(aOwner: TComponent); override;
  end;

  //1 Кнопка для перехода в другую локацию
  TquideButtonAction = class(TquideJumpAction)
    constructor Create(aOwner: TComponent); override;
  private
    procedure SetOnClick(const Value: TNotifyEvent);
    function GetOnClick: TNotifyEvent;
  public
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
  end;

  TquideInventoryAction = class(TquideAction)
    constructor Create(aOwner: TComponent); override;
  end;


implementation

Uses
 {$IFDEF Debug}
 Dialogs,
 {$ENDIF}
 SysUtils,
 PropertyUtils;



const
 ActionTypeNames: Array[TquideActionType] of String = (
  'None', 'Goto', 'Inventory', 'Logic', 'Text', 'Variable', 'Button');

function ActionType2String(aType: TquideActionType): String;
begin
 Result:= ActionTypeNames[aType];
end;

function String2ActionType(const aText: String): TquideActionType;
var
 i: TquideActionType;
begin
 Result:= atNone;
 for I := Low(i) to High(i) do
  if AnsiSameText(aText, ActionTypeNames[i]) then
  begin
    Result:= i;
    break;
  end;
end;


{
********************************* TquideAction *********************************
}
constructor TquideAction.Create;
begin
  inherited Create(nil);
  Visible['Caption']:= False;  // Нет контрола для редактирования
  Visible['Hint']:= False; // Нет контрола для редактирования
  Define('ActionType', 'Тип действия', ptInteger, False);
end;

destructor TquideAction.Destroy;
begin
  inherited Destroy;
end;

procedure TquideAction.LoadFromXML(Element: IXMLNode);
begin
 inherited LoadFromXML(Element, False);
end;

procedure TquideAction.Clear;
begin
  inherited Clear;
  ActionType:= atNone;
end;

class function TquideAction.Make(aElement: IXMLNode): TquideAction;
begin
 Result:= nil;
  case String2ActionType(aElement.Attributes['Type']) of
    //atGoto: Result:= TquideJump.Create;
    atInventory: Result:= TquideInventoryAction.Create(nil);
    atLogic: Result:= TquideLogicalAction.Create(nil);
    atText: Result:= TquideTextAction.Create(nil);
    atVariable: Result:= TquideVariableAction.Create(nil);
    atButton: Result:= TquideButtonAction.Create(nil);
  end;
  if Result <> nil then
   Result.LoadFromXML(aElement);
end;

function TquideAction.pm_GetActionType: TquideActionType;
begin
 Result:= TquideActionType(Values['ActionType'])
end;

procedure TquideAction.pm_SetActionType(Value: TquideActionType);
begin
 Values['ActionType']:= IntToStr(Ord(Value));
end;

procedure TquideAction.SaveToXML(Element: IXMLNode);
begin
 inherited SaveToXML(Element, False);
 Element.SetAttribute('Type', ActionType2String(ActionType));
end;

{
***************************** TquideVariableAction *****************************
}
constructor TquideVariableAction.Create;
begin
  inherited Create(nil);
  f_Variable := TquideVariable.Create(nil);
  ActionType:= atVariable;
  DefineChoice('VarList', '');
  ChoiceStyles['VarList']:= csEditableList;
  DefineString('VarValue', '=');
  NewLines['VarValue']:= False;
end;

destructor TquideVariableAction.Destroy;
begin
  FreeAndNil(f_Variable);
  inherited Destroy;
end;

{
******************************* TquideTextAction *******************************
}
constructor TquideTextAction.Create;
begin
  inherited Create(nil);
  f_Links := TObjectList.Create();
  DefineText('Text', '');
  ActionType:= atText;
end;

destructor TquideTextAction.Destroy;
begin
  FreeAndNil(f_Links);
  inherited Destroy;
end;

procedure TquideTextAction.AddLink(aLink: TquideLink);
begin
 f_Links.Add(aLink);
end;

procedure TquideTextAction.DeleteLink(Index: Integer);
begin
 f_Links.Delete(Index);
end;

function TquideTextAction.pm_GetLinks(Index: Integer): TquideLink;
begin
 Result:= TquideLink(f_Links[Index]);
end;

function TquideTextAction.pm_GetLinksCount: Integer;
begin
 Result:= f_Links.Count;
end;

function TquideTextAction.pm_GetText: string;
begin
 Result:= Values['Text'];
end;

procedure TquideTextAction.pm_SetText(const Value: string);
begin
 Values['Text']:= Value;
end;

{ TquideLogicalAction }

constructor TquideLogicalAction.Create;
var
 l_Acts: TquideActions;
begin
  inherited;
  ActionType:= atLogic;
  DefineChoice('What', 'Если');
  ChoiceStyles['What']:= csEditableList;
  DefineChoice('Condition', '',
    NewChoice(0, 'равно',
    NewChoice(1, 'не равно',
    NewChoice(2, 'больше',
    NewChoice(3, 'меньше',
    NewChoice(4, 'больше или равно',
    NewChoice(5, 'меньше или равно',
    nil)))))));
  DefineString('Value', '');
  NewLines['Condition']:= False;
  NewLines['Value']:= False;
  l_Acts:= TquideActions.Create(nil);
  try
   DefineProps('True', '', l_Acts);
  finally
   FreeAndNil(l_Acts);
  end;
  DefineStaticText('Иначе');
  l_Acts:= TquideActions.Create(nil);
  try
   DefineProps('False', '', l_Acts);
  finally
   FreeAndNil(l_Acts);
  end;

end;

{ TquideButtonAction }

constructor TquideButtonAction.Create;
begin
  inherited;
  ActionType:= atButton;
  DefineButton('Button', '', nil); // Просто событие для клика
end;

function TquideButtonAction.GetOnClick: TNotifyEvent;
begin
 Result:= AliasItems['Button'].Event;
end;

procedure TquideButtonAction.SetOnClick(const Value: TNotifyEvent);
begin
  AliasItems['Button'].Event:= Value;
end;

{ TquideJumpAction }

constructor TquideJumpAction.Create;
begin
  inherited;
  Define('Target', 'Локация для перехода', ptString, False); // Название локации для перехода
  ActionType:= atGoto;
end;


{ TquideInventoryAction }

constructor TquideInventoryAction.Create;
begin
  inherited;
  ActionType:= atInventory;
  DefineChoice('InvList', '');
  ChoiceStyles['InvList']:= csEditableList;
  DefineString('InvValue', '=');
  NewLines['InvValue']:= False;
end;



{ TquideActions }

procedure TquideActions.AddAction(aType: TquideActionType);
var
 l_A: TquideAction;
begin
 l_A:= nil;
 try
   case aType of
     atGoto: l_A:= TquideJumpAction.Create(nil);
     atInventory: l_A:= TquideInventoryAction.Create(nil);
     atLogic: l_A:= TquideLogicalAction.Create(nil);
     atText: l_A:= TquideTextAction.Create(nil);
     atVariable: l_A:= TquideVariableAction.Create(nil);
     atButton: l_A:= TquideButtonAction.Create(nil);
   end;
   if l_A <> nil then
   begin
    DefineProps('Action'+IntToStr(Count+1), '', l_A);
    DoStructChange;
   end;
  finally
    FreeAndNil(l_A);
  end;
end;

procedure TquideActions.AddButtonAction(Sender: TObject);
begin
 AddAction(atButton);
end;

procedure TquideActions.AddGotoAction(Sender: TObject);
begin
 AddAction(atGoto);
end;

procedure TquideActions.AddInventoryAction(Sender: TObject);
begin
 AddAction(atInventory);
end;

procedure TquideActions.AddLogicAction(Sender: TObject);
begin
 // Мне кажется, условие проще добавлять через дополнительные окна
 AddAction(atLogic);
end;

procedure TquideActions.AddTextAction(Sender: TObject);
begin
  AddAction(atText);
end;

procedure TquideActions.AddVariableAction(Sender: TObject);
begin
 AddAction(atVariable);
end;

constructor TquideActions.Create;
begin
  inherited;
end;

procedure TquideActions.CreatePopupMenu;
var
 l_I: TMenuItem;
begin
 inherited;
 l_I:= TMenuItem.Create(Menu);
 l_I.Name:= 'MenuItem'+IntToStr(menu.Items.Count+1);
 l_I.Caption:= 'Текст';
 l_I.OnClick:= AddTextAction;
 Menu.Items.Add(l_I);
 l_I:= TMenuItem.Create(Menu);
 l_I.Name:= 'MenuItem'+IntToStr(menu.Items.Count+1);
 l_I.Caption:= 'Переход';
 l_I.OnClick:= AddGotoAction;
 Menu.Items.Add(l_I);
 l_I:= TMenuItem.Create(Menu);
 l_I.Name:= 'MenuItem'+IntToStr(menu.Items.Count+1);
 l_I.Caption:= 'Инвентарь';
 l_I.OnClick:= AddInventoryAction;
 Menu.Items.Add(l_I);
 l_I:= TMenuItem.Create(Menu);
 l_I.Name:= 'MenuItem'+IntToStr(menu.Items.Count+1);
 l_I.Caption:= 'Условие';
 l_I.OnClick:= AddLogicAction;
 Menu.Items.Add(l_I);
 l_I:= TMenuItem.Create(Menu);
 l_I.Name:= 'MenuItem'+IntToStr(menu.Items.Count+1);
 l_I.Caption:= 'Переменная';
 l_I.OnClick:= AddVariableAction;
 Menu.Items.Add(l_I);
 l_I:= TMenuItem.Create(Menu);
 l_I.Name:= 'MenuItem'+IntToStr(menu.Items.Count+1);
 l_I.Caption:= 'Кнопка';
 l_I.OnClick:= AddButtonAction;
 Menu.Items.Add(l_I);
end;

destructor TquideActions.Destroy;
begin
  inherited;
end;

end.
