unit QuestModeler;

interface

uses
 Types, Classes, Contnrs,
 XMLIntf;

Type
 TdcScript = class;
 TdcVariable = class;
 TqmBase = class(TPersistent)
 private
  f_Caption: string;
  f_Changed: Boolean;
  f_Model: TdcScript;
  procedure pm_SetChanged(const Value: Boolean);
 public
  constructor Create(aModel: TdcScript); virtual;
  destructor Destroy; override;
  procedure Assign(Source: TPersistent); override;
  function Clone(aModel: TdcScript): Pointer;
  procedure Load(Element: IXMLNode); virtual;
  procedure Save(Element: IXMLNode); virtual;
  property Caption: string read f_Caption write f_Caption;
  property Changed: Boolean read f_Changed write pm_SetChanged;
  property Model: TdcScript read f_Model write f_Model;
 end;

 TdcAction = class;
 TdcButtonAction = class;
 TdcLocation = class(TqmBase)
 private
  f_ActionList: TObjectList;
  f_Hint: String;
  procedure GenerateCaption(aAction: TdcAction);
  function pm_GetActions(Index: Integer): TdcAction;
  function pm_GetActionsCount: Integer;
  function pm_GetButtons(Index: Integer): TdcButtonAction;
  function pm_GetButtonsCount: Integer;
  procedure pm_SetActionList(aValue: TObjectList);
 public
  constructor Create(aModel: TdcScript); override;
  destructor Destroy; override;
  procedure AddAction(aAction: TdcAction);
  procedure Assign(Source: TPersistent); override;
  procedure Load(Element: IXMLNode); override;
  class function Make(aElement: IXMLNode; aModel: TdcScript): TdcLocation;
  procedure Save(Element: IXMLNode); override;
  property ActionList: TObjectList
   read f_ActionList
   write pm_SetActionList;
  property Actions[Index: Integer]: TdcAction read pm_GetActions;
  property ActionsCount: Integer read pm_GetActionsCount;
  property Buttons[Index: Integer]: TdcButtonAction read pm_GetButtons;
  property ButtonsCount: Integer read pm_GetButtonsCount;
  property Hint: String read f_Hint write f_Hint;
 end;

 TdcInventory = class(TqmBase)
 end;

{ Виды действия:
а. Вывести текст
б. Добавить переход по кнопке
в. Безусловный переход на другую локацию
г. Условный оператор (под которым раскрывается свой список действий)
  а. Проверка переменной
  б. Проверка наличия предмета в инвентаре
  в. Логические операторы И, ИЛИ, НЕ
д. Установить переменную.
е. Добавить/удалить предмет из инвентаря

}
 { Базовый предок }
 TdcActionType = (atNone, atGoto, atInventory, atLogic, atText, atVariable, atButton);
 TdcAction = class(TqmBase)
 private
  f_ActionType: TdcActionType;
  function pm_GetTagName: String;
 public
  constructor Create(aModel: TdcScript); override;
  procedure Load(Element: IXMLNode); override;
  class function Make(aElement: IXMLNode; aModel: TdcScript): TdcAction;
  procedure Save(Element: IXMLNode); override;
  property ActionType: TdcActionType read f_ActionType write f_ActionType;
  property TagName: String read pm_GetTagName;
 end;

 TdcActionClass = class of TdcAction;

 { Отображение текста }
 TdcTextAction = class(TdcAction)
 // Текст берется из Description
 private
  f_Description: TStrings;
  procedure pm_SetDescription(aValue: TStrings);
 public
  constructor Create(aModel: TdcScript); override;
  procedure Assign(Source: TPersistent); override;
  procedure Load(Element: IXMLNode); override;
  procedure Save(Element: IXMLNode); override;
  property Description: TStrings read f_Description write pm_SetDescription;
 end;

 { Условное действие }
 TdcLogicAction = class(TdcAction)

 public
  constructor Create(aModel: TdcScript); override;
 end;

 { Действие с инвентарем }
 TdcInventoryAction = class(TdcAction)
 private
  f_Inventory: TdcInventory;
 public
  constructor Create(aModel: TdcScript); override;
  procedure AddObject(aObjectName: String);
  procedure DeleteObject(aObjectName: String);
  function CheckObject(aObjectName: String): Boolean;
  property Inventory: TdcInventory read f_Inventory write f_Inventory;
 end;

 { Действие с переменными }
 TdcVariableAction = class(TdcAction)

 private
  f_Value: String;
  f_Variable: TdcVariable;
 public
  constructor Create(aModel: TdcScript); override;
  procedure Assign(Source: TPersistent); override;
  procedure Load(Element: IXMLNode); override;
  procedure Save(Element: IXMLNode); override;
  property Value: String read f_Value write f_Value;
  property Variable: TdcVariable read f_Variable write f_Variable;
 end;

 { Переход на локацию }
 TdcGotoAction = class(TdcAction)
 private
  f_Location: TdcLocation;
 public
  constructor Create(aModel: TdcScript); override;
  procedure Assign(Source: TPersistent); override;
  procedure Load(Element: IXMLNode); override;
  procedure Save(Element: IXMLNode); override;
  property Location: TdcLocation
   read f_Location
   write f_Location;
 end;

 { переход на локацию с предварительным выбором }
 TdcButtonAction = class(TdcGotoAction)

 public
   constructor Create(aModel: TdcScript); override;
 end;


 TdcScript = class(TqmBase)
 private
  f_Author: String;
  f_Description: TStrings;
  f_Locations: TObjectList;
  f_NotValidConditions: string;
  f_StartLocation: string;
  f_Variables: TObjectList;
  f_Version: string;
  function pm_GetIsValid: Boolean;
  function pm_GetLocations(Index: Integer): TdcLocation;
  function pm_GetLocationsCount: Integer;
  function pm_GetObjectsCount: Integer;
  function pm_GetVariables(Index: Integer): TdcVariable;
  function pm_GetVariablesCount: Integer;
  procedure pm_SetDescription(aValue: TStrings);
  procedure pm_SetStartLocation(const Value: string);
 protected
  function CreateLocation: TdcLocation; virtual;
 public
  constructor Create(aModel: TdcScript);
  destructor Destroy; override;
  procedure Assign(Source: TPersistent); override;
  function CheckLocation(aCaption: String): TdcLocation;
  function CheckVariable(const aCaption: String): TdcVariable;
  function FindLocation(const aCaption: String): TdcLocation;
  function GenerateCaption: string;
  procedure GetLocationsNames(aStrings: TStrings);
  procedure LoadFromStream(aStream: TStream);
  procedure Locations2Strings(aStrings: TStrings);
  function NewLocation(aCaption: String): TdcLocation;
  function NewVariable(const aCaption: String): TdcVariable;
  procedure SaveToStream(aStream: TStream);
  property Author: String read f_Author write f_Author;
  property Description: TStrings read f_Description write pm_SetDescription;
  property IsValid: Boolean read pm_GetIsValid;
  property Locations[Index: Integer]: TdcLocation read pm_GetLocations;
  property LocationsCount: Integer read pm_GetLocationsCount;
  property NotValidConditions: string read f_NotValidConditions;
  property ObjectsCount: Integer read pm_GetObjectsCount;
  property StartLocation: string read f_StartLocation write pm_SetStartLocation;
  property Variables[Index: Integer]: TdcVariable read pm_GetVariables;
  property VariablesCount: Integer read pm_GetVariablesCount;
  property Version: string read f_Version write f_Version;
 end;

 TdcInventoryItem = class(TqmBase)
 end;

 TdcVariableType = (vtNumeric, vtText, vtBoolean, vtEnum);
 TdcVariable = class(TqmBase)
 private
  f_Enum: TStrings;
  f_Value: string;
  f_VarType: TdcVariableType;
  function pm_GetTagName: String;
  procedure pm_SetEnum(const Value: TStrings);
 public
  constructor Create(aModel: TdcScript); override;
  destructor Destroy; override;
  procedure Load(Element: IXMLNode); override;
  procedure Save(Element: IXMLNode); override;
  property Enum: TStrings read f_Enum write pm_SetEnum;
  property TagName: String read pm_GetTagName;
  property Value: string read f_Value write f_Value;
  property VarType: TdcVariableType read f_VarType write f_VarType;
 end;

procedure CloneActions(aSource: TObjectList; var aDestination: TObjectList;
    aModel: TdcScript);

function FindInList(theList: TObjectList; const aCaption: String): TqmBase;

function ActionTypeToStr(aType: TdcActionType): string;

function StringToActionType(aStr: String): TdcActionType;

implementation

Uses
 SysUtils, XMLDoc, StrUtils, Variants, TypInfo;


function VarType2String(aVarType: TdcVariableType): String;
begin
 case aVarType of
  vtNumeric : Result:= 'Numeric';
  vtText    : Result:= 'String';
  vtBoolean : Result:= 'Boolean';
  vtEnum    : Result:= 'Enum';
 end;
end;

function String2VarType(const aVarType: String): TdcvariableType;
begin
 if AnsiSameText('Numeric', aVarType) then
  Result:= vtNumeric
 else
  if AnsiSameText('Boolean', aVarType) then
   Result:= vtBoolean
  else
   if AnsiSametext('Enum', aVarType) then
    Result:= vtEnum
   else
    Result:= vtText;
end;


procedure TqmBase.Assign(Source: TPersistent);
begin
  if Source is TqmBase then
  begin
   f_Model:= (Source as TqmBase).Model;
   f_Caption:= TqmBase(Source).Caption;
   f_Changed:= Tqmbase(Source).Changed;
  end
  else
   inherited;
end;

constructor TqmBase.Create(aModel: TdcScript);
begin
 inherited Create;
 f_Model:= aModel;
 f_Changed:= False;
 f_Caption:= '';
end;

destructor TqmBase.Destroy;
begin
 inherited;
end;

function TqmBase.Clone(aModel: TdcScript): Pointer;
type
 RBase = class of TqmBase;
begin
 Result := RBase(ClassType).Create(aModel);
 TqmBase(Result).Assign(Self);
end;

procedure TqmBase.Load(Element: IXMLNode);
begin
 //Caption:= Element['Caption'];
 if Element.HasAttribute('Caption') then
  Caption:= Element.Attributes['Caption'];
end;

procedure TqmBase.pm_SetChanged(const Value: Boolean);
begin
 f_Changed := Value;
end;

procedure TqmBase.Save(Element: IXMLNode);
begin
 //Element.AddChild('Caption').Text:= Caption;
 Element.SetAttribute('Caption', Caption);
end;




{ TdcLocation }

procedure TdcLocation.Assign(Source: TPersistent);
begin
 inherited;
 if Source is TdcLocation then
 begin
  CloneActions((Source as TdcLocation).ActionList, f_ActionList, Model);
 end;
end;

procedure CloneActions(aSource: TObjectList; var aDestination: TObjectList;
    aModel: TdcScript);
var
 i: Integer;
begin
  aDestination.Clear;
  for I := 0 to aSource.Count - 1 do
  begin
   aDestination.Add((aSource[i] as TdcAction).Clone(aModel));
  end;
end;

function FindInList(theList: TObjectList; const aCaption: String): TqmBase;
var
  I: Integer;
  l_S: String;
begin
 Result:= nil;
 l_S:= TrimRight(aCaption);
 for I := 0 to theList.Count - 1 do
 if AnsiSameText((theList[i] as TqmBase).Caption, l_S) then
 begin
   Result:= theList[i] as TqmBase;
   break;
 end;
end;
(*
function ActionTypeToStr(aType: TdcActionType): string;
begin
 Result:= GetEnumName(TypeInfo(TdcActionType), Ord(aType));
end;

function StringToActionType(aStr: String): TdcActionType;
begin
 Result := TdcActionType(GetEnumValue(TypeInfo(TdcActionType), aStr));
end;
*)
function ActionTypeToStr(aType: TdcActionType): string;
begin
 case aType of
  atNone : Result:= 'none';
  atGoto : Result:= 'Goto';
  atInventory: Result:= 'Inv';
  atLogic: Result:= 'Logic';
  atText: Result:= 'Text';
  atVariable: Result:= 'Var';
  atButton: Result:= 'Button';
 end;
end;

function StringToActionType(aStr: String): TdcActionType;
begin
 Result := atNone;
 if AnsiCompareText(aStr, 'none') = 0 then
  Result:= atNone
 else
 if AnsiCompareText(aStr, 'goto') = 0 then
  Result:= atGoto
 else
 if AnsiCompareText(aStr, 'inv') = 0 then
  Result:= atInventory
 else
 if AnsiCompareText(aStr, 'logic') = 0 then
  Result:= atLogic
 else
 if AnsiCompareText(aStr, 'text') = 0 then
  Result:= atText
 else
 if AnsiCompareText(aStr, 'var') = 0 then
  Result:= atVariable
 else
 if AnsiCompareText(aStr, 'button') = 0 then
  Result:= atButton
end;
constructor TdcLocation.Create(aModel: TdcScript);
begin
 inherited;
 f_ActionList:= TObjectList.Create;
end;

destructor TdcLocation.Destroy;
begin
  f_ActionList.Free;
  inherited;
end;

procedure TdcLocation.AddAction(aAction: TdcAction);
begin
 Assert(aAction <> nil, 'Нельзя добавлять пустое действие');
 GenerateCaption(aAction);
 f_ActionList.Add(aAction);
end;

procedure TdcLocation.GenerateCaption(aAction: TdcAction);
var
 l_Template: string;
 l_Count: Integer;
begin
 if aAction.Caption = '' then
 begin
   l_Count:= 1;
   if aAction is TdcTextAction then
    l_Template:= 'Текст'
   else
   if (aAction is TdcGotoAction) and not (aAction is TdcButtonAction) then
    l_Template:= 'Переход'
   else
   if aAction is TdcInventoryAction then
    l_Template:= 'Инвентарь'
   else
   if aAction is TdcLogicAction then
    l_Template:= 'Условие'
   else
   if aAction is TdcVariableAction then
    l_Template:= 'Переменная'
   else
   if aAction is TdcButtonAction then
    l_Template:= 'Кнопка';

   while FindInList(f_ActionList, l_Template + IntToStr(l_Count)) <> nil do
    Inc(l_Count);
   aAction.Caption:= l_Template + IntToStr(l_Count);
 end;
end;

procedure TdcLocation.Load(Element: IXMLNode);
var
 l_Count, i, j: Integer;
 l_Node, l_E, l_a: IXMLNode;
begin
 inherited;
 l_Node:= Element.ChildNodes.FindNode('Actions');
 for i:= 0 to l_Node.ChildNodes.Count - 1 do
 begin
  l_E:= l_Node.ChildNodes.Get(i);
  AddAction(TdcAction.Make(l_E, Model));
 end; // for i
 l_Node:= Element.ChildNodes.FindNode('Buttons');
 for i:= 0 to l_Node.ChildNodes.Count - 1 do
 begin
  l_E:= l_Node.ChildNodes.Get(i);
  AddAction(TdcAction.Make(l_E, Model));
 end; // for i
 if Element.HasAttribute('Hint') then
  Hint:= element.GetAttribute('Hint');
end;

class function TdcLocation.Make(aElement: IXMLNode; aModel: TdcScript): TdcLocation;
begin
 Result:= nil;
 if aElement.HasAttribute('Caption') then
  Result:= aModel.CheckLocation(aElement.GetAttribute('Caption'))
 else
  Result:= aModel.NewLocation('');
 if Result <> nil then
  Result.Load(aElement);
end;

function TdcLocation.pm_GetActions(Index: Integer): TdcAction;
begin
 Result := f_ActionList.Items[Index] as TdcAction;
end;

function TdcLocation.pm_GetActionsCount: Integer;
begin
 Result := f_ActionList.Count;
end;

function TdcLocation.pm_GetButtons(Index: Integer): TdcButtonAction;
var
 l_B, i: Integer;
begin
 l_B:= -1;
 for i:= 0 to Pred(ActionsCount) do
  if Actions[i].ActionType = atButton then
  begin
   Inc(l_B);
   if l_B = Index then
    Result := Actions[i] as TdcButtonAction;
  end;
end;

function TdcLocation.pm_GetButtonsCount: Integer;
var
 i: Integer;
begin
 Result:= 0;
 for i:= 0 to Pred(ActionsCount) do
  if Actions[i].ActionType = atButton then
   Inc(Result);
end;

procedure TdcLocation.pm_SetActionList(aValue: TObjectList);
begin
 CloneActions(aValue, f_ActionList, Model);
end;

procedure TdcLocation.Save(Element: IXMLNode);
var
 i: Integer;
 l_Node: IXMLNode;
begin
 inherited;
 with Element.AddChild('Actions') do
 begin
  for i:= 0 to Pred(ActionsCount) do
   if Actions[i].ActionType <> atButton then
    Actions[i].Save(AddChild(Actions[i].TagName));
 end; // with Element.AddChild('Actions')
 with Element.AddChild('Buttons') do
 begin
  for i:= 0 to Pred(ButtonsCount) do
   Buttons[i].Save(AddChild('Button'));
 end; // with Element.AddChild('Buttons')
 Element.SetAttribute('Hint', Hint);
end;

constructor TdcGotoAction.Create(aModel: TdcScript);
begin
 inherited;
 ActionType:= atGoto;
end;

{ TdcGotoAction }
procedure TdcGotoAction.Assign(Source: TPersistent);
begin
 inherited;
 if Source is TdcGotoAction then
  f_Location:= (Source as TdcGotoAction).Location;
end;

procedure TdcGotoAction.Load(Element: IXMLNode);
begin
 inherited;
 Assert(Model <> nil);
 if Element.HasAttribute('Target') then
  Location:= Model.CheckLocation(Element.Attributes['Target']);
end;

procedure TdcGotoAction.Save(Element: IXMLNode);
begin
 inherited;
 Element.SetAttribute('Target', Location.Caption);
end;


constructor TdcInventoryAction.Create(aModel: TdcScript);
begin
 inherited;
 ActionType:= atInventory;
end;

procedure TdcInventoryAction.AddObject(aObjectName: String);
begin
 // TODO -cMM: TdcInventoryAction.AddObject необходимо написать реализацию
end;

procedure TdcInventoryAction.DeleteObject(aObjectName: String);
begin
 // TODO -cMM: TdcInventoryAction.AddObject необходимо написать реализацию
end;

function TdcInventoryAction.CheckObject(aObjectName: String): Boolean;
begin
 Result := False;
 // TODO -cMM: TdcInventoryAction.CheckObject необходимо написать реализацию
end;

{ TdcChapter }

constructor TdcScript.Create(aModel: TdcScript);
begin
 inherited;
 f_Locations:= TObjectList.Create;
 f_Variables:= TObjectList.Create;
 f_Description:= TStringList.Create;
 Caption:= 'Новый сценарий';
end;

destructor TdcScript.Destroy;
begin
  f_description.Free;
  f_Locations.Free;
  f_Variables.Free;
  inherited;
end;

procedure TdcScript.Assign(Source: TPersistent);
begin
 inherited;
 if Source is TdcScript then
 begin
  f_Description.Assign(TdcScript(Source).Description);
 end;
end;

function TdcScript.CheckLocation(aCaption: String): TdcLocation;
begin
 Result := FindLocation(aCaption);
 if Result = nil then
  Result:= NewLocation(aCaption);
end;

function TdcScript.CheckVariable(const aCaption: String): TdcVariable;
begin
 Result := FindInList(f_Variables, aCaption) as TdcVariable;
 if Result = nil then
  Result:= NewVariable(aCaption);
end;

function TdcScript.CreateLocation: TdcLocation;
begin
 Result := nil;
end;

function TdcScript.FindLocation(const aCaption: String): TdcLocation;
begin
 Result:= FindInList(f_Locations, aCaption) as TdcLocation;
end;

function TdcScript.GenerateCaption: string;
var
 l_Number: Integer;
begin
 l_Number:= 1;
 Result := 'Локация';
 while FindLocation(Result + IntToStr(l_Number)) <> nil do
  Inc(l_Number);
 Result:= Result + IntToStr(l_Number);
end;

procedure TdcScript.GetLocationsNames(aStrings: TStrings);
var
 i: Integer;
begin
 aStrings.Clear;
 for i:= 0 to Pred(LocationsCount) do
  aStrings.Add(Locations[i].Caption);
end;

procedure TdcScript.LoadFromStream(aStream: TStream);
var
 l_XML: IXMLDocument;
 i, l_Count: Integer;
 l_Node, l_C: IXMLNode;
 l_Loc: TdcLocation;
begin
 l_XML:= TXMLDocument.Create(nil);
 try
  l_XMl.Active:= True;
  l_XML.Options:= l_XML.Options + [doNodeAutoCreate, doAttrNull];
  l_XML.Encoding:= 'Windows-1251';  
  l_XML.LoadFromStream(aStream);
  with l_XML.ChildNodes.FindNode('Quide') do
  begin
   if HasAttribute('Version') then
    Version:= GetAttribute('Version');
   // Описание квеста
   l_Node:= ChildNodes.FindNode('Meta');
   if l_Node <> nil then
   begin
    if l_Node.ChildValues['Title'] <> Null then
     Caption:= l_Node['Title'];
    if l_Node.ChildValues['Author'] <> Null then
     Author:= l_Node['Author'];
    if l_Node.ChildValues['Description'] <> Null then
     Description.Text:= l_Node['Description'];
   end;
   // Переменные
   l_Node:= ChildNodes.FindNode('Variables');
   if l_Node <> nil then
   begin
    // Прочитать переменные
    for i:= 0 to Pred(l_Node.ChildNodes.Count) do
    begin
     l_C:= l_Node.ChildNodes.Get(i);
     NewVariable('').Load(l_C);
    end;
   end;
   // Локации
   l_Node:= ChildNodes.FindNode('Locations');
   if l_Node <> nil then
   begin
    if l_Node.HasAttribute('Start') then
     StartLocation:= l_Node.GetAttribute('Start');
    for i:= 0 to Pred(l_node.ChildNodes.Count) do
    begin
     l_C:= l_Node.ChildNodes.Get(i);
     TdcLocation.Make(l_C, Self);
    end;
   end;
   // Инвентарь
   l_Node:= ChildNodes.FindNode('Inventory');
   if l_Node <> nil then
   begin
    // Прочитать элементы инвентаря
    for i:= 0 to Pred(l_Node.ChildNodes.Count) do
    begin
     l_C:= l_Node.ChildNodes.Get(i);
     //New('').Load(l_C);
    end;
   end;
  end;
 finally
  l_XML:= nil;
 end;
end;

procedure TdcScript.Locations2Strings(aStrings: TStrings);
var
  I: Integer;
begin
 for I := 0 to f_Locations.Count - 1 do
  aStrings.Add((f_Locations[i] as TdcLocation).Caption)
end;

function TdcScript.NewLocation(aCaption: String): TdcLocation;
begin
 Result:= CreateLocation;
 if Result <> nil then
 begin
  if Result.Model = nil then
   Result.Model:= Self;
  if aCaption = '' then
   Result.Caption:= GenerateCaption
  else
   Result.Caption:= aCaption;
  f_Locations.Add(Result);
 end;
end;

function TdcScript.NewVariable(const aCaption: String): TdcVariable;
begin
 Result:= TdcVariable.Create(self);
 Result.Caption:= aCaption;
 f_Variables.Add(Result);
end;

function TdcScript.pm_GetIsValid: Boolean;
begin
 f_NotValidConditions:= '';
 if StartLocation = '' then
  f_NotValidConditions:= 'Не указана начальная локация';
 Result:= f_NotValidConditions = '';
end;

function TdcScript.pm_GetLocations(Index: Integer): TdcLocation;
begin
 Result := f_Locations.Items[Index] as TdcLocation;
end;

function TdcScript.pm_GetLocationsCount: Integer;
begin
 // TODO -cMM: TdcScript.pm_GetLocationsCount необходимо написать реализацию
 Result := f_Locations.Count;
end;

function TdcScript.pm_GetObjectsCount: Integer;
begin
  // TODO -cMM: TdcScript.pm_GetObjectsCount default body inserted
  Result := 0;
end;

function TdcScript.pm_GetVariables(Index: Integer): TdcVariable;
begin
  Result := TdcVariable(f_Variables.Items[Index]);
end;

function TdcScript.pm_GetVariablesCount: Integer;
begin
  Result := f_Variables.Count;
end;

procedure TdcScript.pm_SetDescription(aValue: TStrings);
begin
 f_Description.Assign(aValue);
end;

procedure TdcScript.pm_SetStartLocation(const Value: string);
begin
  f_StartLocation := Value;
end;

procedure TdcScript.SaveToStream(aStream: TStream);
var
 l_XML: IXMLDocument;
 i: Integer;
 l_Node, l_SubNode: IXMLNode;
begin
 l_XML:= TXMLDocument.Create(nil);
 try
  l_XMl.Active:= True;
  l_XML.Options:= l_XML.Options + [doNodeAutoIndent];
  l_XML.Encoding:= 'Windows-1251';
  with l_XML.AddChild('Quide') do
  begin
   SetAttribute('Version', '1.0');
   SetAttribute('Date', DateToStr(Date));
   // Описание квеста
   l_Node:= AddChild('Meta');
   l_Node.AddChild('Title').Text:= Caption;
   l_Node.AddChild('Author').Text:= Author;
   l_node.AddChild('Description').Text:= Description.text;
   // Переменные
   l_Node:= AddChild('Variables');
   if VariablesCount > 0 then
    for i:= 0 to Pred(VariablesCount) do
     Variables[i].Save(l_Node.AddChild(Variables[i].TagName));
   // Локации
   l_Node:= AddChild('Locations');
   l_Node.SetAttribute('Start', StartLocation);
   if LocationsCount > 0 then
    for i:= 0 to Pred(LocationsCount) do
     Locations[i].Save(l_Node.AddChild('Location'));
   // Инвентарь
   l_Node:= AddChild('Inventory');
  end;
  l_XML.SaveToStream(aStream);
 finally
  l_XML:= nil;
 end;
end;

constructor TdcTextAction.Create(aModel: TdcScript);
begin
 inherited;
 f_Description:= TStringList.Create;
 ActionType:= atText;
end;

procedure TdcTextAction.Assign(Source: TPersistent);
begin
 inherited;
 if Source is TdcTextAction then
 begin
  f_Description.Assign(TdcTextAction(Source).Description);
 end;
end;

procedure TdcTextAction.Load(Element: IXMLNode);
begin
  inherited;
  f_Description.Text:= Element.text;
end;

procedure TdcTextAction.pm_SetDescription(aValue: TStrings);
begin
 f_Description.Assign(aValue);
end;

procedure TdcTextAction.Save(Element: IXMLNode);
begin
 inherited;
 Element.Text:= f_Description.Text;
end;

constructor TdcAction.Create(aModel: TdcScript);
begin
 inherited;
 ActionType:= atNone;
end;

procedure TdcAction.Load(Element: IXMLNode);
var
 l_Type: string;
begin
  inherited;
  ActionType:= StringToActionType(Element.NodeName);
end;

class function TdcAction.Make(aElement: IXMLNode; aModel: TdcScript): TdcAction;
begin
 Result:= nil;
  case StringToActionType(aElement.NodeName) of
    atGoto: Result:= TdcGotoAction.Create(aModel);
    atInventory: Result:= TdcInventoryAction.Create(aModel);
    atLogic: Result:= TdcLogicAction.Create(aModel);
    atText: Result:= TdcTextAction.Create(aModel);
    atVariable: Result:= TdcVariableAction.Create(aModel);
    atButton: Result:= TdcButtonAction.Create(aModel);
  end;
  if Result <> nil then
   Result.Load(aElement);
end;

function TdcAction.pm_GetTagName: String;
begin
 Result := ActionTypeToStr(ActionType);
end;

procedure TdcAction.Save(Element: IXMLNode);
begin
 inherited;
end;

constructor TdcLogicAction.Create(aModel: TdcScript);
begin
 inherited;
 ActionType:= atLogic;
end;

constructor TdcVariableAction.Create(aModel: TdcScript);
begin
 inherited;
 ActionType:= atVariable;
end;

procedure TdcVariableAction.Assign(Source: TPersistent);
begin
 inherited;
 if Source is TdcVariableAction then
 begin
  Variable:= TdcVariableAction(Source).Variable;
  Value:= TdcVariableAction(Source).Value;
 end;
end;

procedure TdcVariableAction.Load(Element: IXMLNode);
begin
 inherited;
 if Element.HasAttribute('Variable') then
 begin
  Variable:= f_Model.CheckVariable(element.GetAttribute('Variable'));
  if (Variable <> nil) and Element.HasAttribute('Value') then
   Value:= Element.GetAttribute('Value');
 end;
end;

procedure TdcVariableAction.Save(Element: IXMLNode);
begin
 inherited;
 if Variable <> nil then
 begin
  Element.setAttribute('Variable', Variable.Caption);
  Element.SetAttribute('Value', Value);
 end; 
end;

constructor TdcButtonAction.Create(aModel: TdcScript);
begin
 inherited;
 ActionType:= atButton;
end;

constructor TdcVariable.Create(aModel: TdcScript);
begin
 inherited;
 f_Enum:= TStringList.Create;
end;

destructor TdcVariable.Destroy;
begin
 f_Enum.Free;
 inherited;
end;

procedure TdcVariable.Load(Element: IXMLNode);
var
 i: Integer;
begin
 inherited;
 if Element.HasAttribute('Value') then
  Value:= Element.GetAttribute('Value');
 VarType:= String2VarType(element.NodeName);
 if VarType = vtEnum then
 begin
  f_Enum.Clear;
  for i:= 0 to Pred(Element.ChildNodes.Count) do
   f_Enum.Add(Element.ChildNodes.Get(i).Text);
 end;
end;

function TdcVariable.pm_GetTagName: String;
begin
 Result := varType2String(VarType);
end;

procedure TdcVariable.pm_SetEnum(const Value: TStrings);
begin
 f_Enum.Assign(Value);
end;

procedure TdcVariable.Save(Element: IXMLNode);
var
 i: Integer;
begin
 inherited;
 Element.SetAttribute('Value', Value);
 if VarType = vtEnum then
 begin
  for i:= 0 to (f_Enum.Count-1) do
   Element.AddChild('Item').Text:= f_Enum[i];
 end;
end;

end.
