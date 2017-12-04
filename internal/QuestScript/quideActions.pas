unit quideActions;

interface

uses
  XMLIntf, Contnrs, Classes, Menus,
  Propertys,
  quideObject, quideVariables, quideLinks, quideConditions;

type
 TquideActionType = (atNone, atGoto, atInventory, atLogic, atText, atVariable, atButton);


  //1 Базовый объект для действия в локации
  TquideAction = class(TquideObject)
  private
    f_Index: Integer;
    function pm_GetActionType: TquideActionType;
    procedure pm_SetActionType(Value: TquideActionType);
  public
    constructor Create; override;
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

 TquideActions = class(TProperties)
 private

 private
  procedure AddGotoAction(Sender: TObject);
  procedure AddInventoryAction(Sender: TObject);
  procedure AddLogicAction(Sender: TObject);
  procedure AddTextAction(Sender: TObject);
  procedure AddVariableAction(Sender: TObject);
  procedure AddButtonAction(Sender: TObject);
  procedure AddAction(aType: TquideActionType); overload;
  procedure AddAction(aAction: TquideAction); overload;
  procedure actButtonExecute(Sender: TObject);
  procedure actEditButtonExecute(Sender: TObject);
 protected
  procedure MakemenuItems;override;
 public
  constructor Create; override;
  destructor Destroy; override;
 public
 end;



  TquideVariableAction = class(TquideAction)
  private
    f_NewValue: string;
    f_Variable: TquideVariable;
  public
    constructor Create; override;
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
    constructor Create; override;
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
    constructor Create; override;
    property Condition: TquideCondition read f_Condition write f_Condition;
  end;

    //1 Переход в другую локацию прямо из текста
  TquideJumpAction = class(TquideAction)
  private
  public
    constructor Create; override;
  end;

  //1 Кнопка для перехода в другую локацию
  TquideButtonAction = class(TquideJumpAction)
    constructor Create; override;
  private
    procedure SetOnClick(const Value: TNotifyEvent);
    function GetOnClick: TNotifyEvent;
  public
    property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
  end;

  TquideInventoryAction = class(TquideAction)
    constructor Create; override;
  end;


implementation

Uses
 SysUtils, Dialogs,
 PropertyUtils, quideButtonEditDlg;



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
  inherited Create;
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
    atInventory: Result:= TquideInventoryAction.Create;
    atLogic: Result:= TquideLogicalAction.Create;
    atText: Result:= TquideTextAction.Create;
    atVariable: Result:= TquideVariableAction.Create;
    atButton: Result:= TquideButtonAction.Create;
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
  inherited Create;
  f_Variable := TquideVariable.Create();
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
  inherited Create;
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
 l_P: TquideActions;
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
<<<<<<< HEAD
  l_P:= TquideActions.Create;
  try
   DefineProperties('True', '', l_P);
  finally
   l_P.Free;
  end;
  DefineStaticText('Иначе');
  l_P:= TquideActions.Create;
  try
   DefineProperties('False', '', l_P); (* *)
  finally
   l_P.Free;
  end;
=======
  DefineProps('True', '');
  DefineStaticText('Иначе');
  DefineProps('False', ''); (* *)
>>>>>>> ac0925feb1c76a9e0b4781d8ab66a4d4ec276492
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
 case AType of
   atNone: l_A:= nil;
   atGoto: l_A:= TquideJumpAction.Create;
   atInventory: l_A:= TquideInventoryAction.Create;
   atLogic: l_A:= TquideLogicalAction.Create;
   atText: l_A:= TquideTextAction.Create;
   atVariable: l_A:= TquideVariableAction.Create;
   atButton: l_A:= TquideButtonAction.Create;
 end;
 AddAction(l_A);
 FreeAndNil(l_A);
end;

procedure TquideActions.AddAction(aAction: TquideAction);
begin
 if aAction <> nil then
 begin
  DefineProperties(ActionType2String(aAction.ActionType)+IntToStr(Succ(Count)), '', aAction);
  StructureChanged:= True;
 end;
end;

procedure TquideActions.AddButtonAction(Sender: TObject);
begin
 // Спросить про название и локацию перехода
 AddAction(atButton);
end;


procedure TquideActions.actButtonExecute(Sender: TObject);
var
 l_Loc, l_Cap: String;
 l_Act: TquideAction;
begin
 // Добавляем кнопку
 l_Loc:= ''; l_Cap:= '';
 { TODO : Подтянуть список существующих локаций или создать новую }
  if ButtonEditDlg(l_Cap, l_Loc, nil{f_Scenario.LocationsNames}) then
  begin
   l_Act:= TquideButtonAction.Create;
   TquideButtonAction(l_Act).Values['Button']:= l_Cap; // Текст на кнопке
   TquideButtonAction(l_Act).Values['Target']:= l_Loc; // Название локации для перехода
   TquideButtonAction(l_Act).OnClick:= actEditButtonExecute;
   AddAction(l_Act);
  end;
end;

procedure TquideActions.actEditButtonExecute(Sender: TObject);
var
 l_Loc, l_Cap: String;
 l_Act: TquideAction;
begin
 // Изменяем свойства кнопки
 //l_Act:= fLocation.ActionByID((Sender as TControl).Tag);

 l_Cap:= TquideButtonAction(l_Act).Values['Button']; // Текст на кнопке
 l_Loc:= TquideButtonAction(l_Act).Values['Target']; // Название локации для перехода
 if ButtonEditDlg(l_Cap, l_Loc, nil) then
 begin
  TquideButtonAction(l_Act).Values['Button']:= l_Cap; // Текст на кнопке
  TquideButtonAction(l_Act).Values['Target']:= l_Loc; // Название локации для перехода
 end;
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

destructor TquideActions.Destroy;
begin
  inherited;
end;

procedure TquideActions.MakemenuItems;
var
 l_Item: TMenuItem;
begin
  inherited;
  // atButton
  l_Item:= TMenuItem.Create(nil);
  l_Item.Caption:= 'Добавить кнопку...';
  l_Item.OnClick:= actButtonExecute;
  Menu.Items.Add(l_Item);
  // atText
  l_Item:= TMenuItem.Create(nil);
  l_Item.Caption:= 'Добавить текст...';
  l_Item.OnClick:= AddTextAction;
  Menu.Items.Add(l_Item);
  // atInventory
  l_Item:= TMenuItem.Create(nil);
  l_Item.Caption:= 'Добавить инвентарь...';
  l_Item.OnClick:= AddInventoryAction;
  Menu.Items.Add(l_Item);
  // atVariable
  l_Item:= TMenuItem.Create(nil);
  l_Item.Caption:= 'Добавить переменную...';
  l_Item.OnClick:= AddVariableAction;
  Menu.Items.Add(l_Item);
  // atLogic
  l_Item:= TMenuItem.Create(nil);
  l_Item.Caption:= 'Добавить условие...';
  l_Item.OnClick:= AddLogicAction;
  Menu.Items.Add(l_Item);
  // atGoto
  l_Item:= TMenuItem.Create(nil);
  l_Item.Caption:= 'Добавить переход...';
  l_Item.OnClick:= AddGotoAction;
  Menu.Items.Add(l_Item);
end;

end.
