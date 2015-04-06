unit quideActions;

interface

uses
  XMLIntf, Contnrs,
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

    //Target: TquideLocation;
  public
    constructor Create; override;
    //property Target: TquideLocation read f_Target write f_Target;
  end;

  //1 Кнопка для перехода в другую локацию
  TquideButtonAction = class(TquideJumpAction)
    constructor Create; override;
  end;


implementation

Uses
 SysUtils,
 Propertys;



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
  Visible['Caption']:= False;
  Visible['Hint']:= False;
  Define('ActionType', 'Тип действия', ptInteger, False);
end;

destructor TquideAction.Destroy;
begin
  inherited Destroy;
end;

procedure TquideAction.LoadFromXML(Element: IXMLNode);
begin
 inherited;
end;

procedure TquideAction.Clear;
begin
  inherited Clear;
  ActionType:= atNone;
end;

class function TquideAction.Make(aElement: IXMLNode): TquideAction;
begin
 Result:= nil;
 // Все не так :(
 (* *)
  case String2ActionType(aElement.Attributes['Type']) of
  //case TquideActionType(StrToIntDef(aElement.Attributes['Type'], 0)) of
    //atGoto: Result:= TquideJump.Create;
    //atInventory: Result:= TquideInventoryAction.Create;
    atLogic: Result:= TquideLogicalAction.Create;
    atText: Result:= TquideTextAction.Create;
    atVariable: Result:= TquideVariableAction.Create;
    atButton: Result:= TquideButtonAction.Create;
  end;
  if Result <> nil then
   Result.LoadFromXML(aElement);
  (* *)
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
 inherited;
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
  Define('Text', '', ptText);
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
begin
  inherited;
  ActionType:= atLogic;
end;

{ TquideButtonAction }

constructor TquideButtonAction.Create;
begin
  inherited;
  ActionType:= atButton;
end;

{ TquideJumpAction }

constructor TquideJumpAction.Create;
begin
  inherited;
  ActionType:= atGoto;
end;


end.
