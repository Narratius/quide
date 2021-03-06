unit QuestModeler;

interface

uses
 Propertys,
 Types, Classes, Contnrs,
 XMLIntf;

Type
 TdcScript = class;
 TdcVariable = class;
  TqmBase = class(TProperties)
  private
    function pm_GetCaption: string;
    procedure pm_SetCaption(const Value: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    function Clone: Pointer;
    procedure Load(Element: IXMLNode); virtual;
    procedure Save(Element: IXMLNode); virtual;
    property Caption: string read pm_GetCaption write pm_SetCaption;
  end;

 TdcAction = class;
 TdcButtonAction = class;
 TdcActionList = class;
  TdcLocation = class(TqmBase)
  private
    f_ActionList: TdcActionList;
    f_Hint: string;
    procedure GenerateCaption(aAction: TdcAction);
    function pm_GetActions(Index: Integer): TdcAction;
    function pm_GetActionsCount: Integer;
    function pm_GetButtons(Index: Integer): TdcButtonAction;
    function pm_GetButtonsCount: Integer;
    procedure pm_SetActionList(aValue: TdcActionList);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure AddAction(aAction: TdcAction);
    procedure Assign(Source: TPersistent); override;
    procedure Load(Element: IXMLNode); override;
    class function Make(aElement: IXMLNode; aModel: TdcScript): TdcLocation;
    procedure Save(Element: IXMLNode); override;
    property ActionList: TdcActionList read f_ActionList write pm_SetActionList;
    property Actions[Index: Integer]: TdcAction read pm_GetActions;
    property ActionsCount: Integer read pm_GetActionsCount;
    property Buttons[Index: Integer]: TdcButtonAction read pm_GetButtons;
    property ButtonsCount: Integer read pm_GetButtonsCount;
    property Hint: string read f_Hint write f_Hint;
  end;

  TdcInventory = class(TqmBase)
  end;

{ ���� ��������:
�. ������� �����
�. �������� ������� �� ������
�. ����������� ������� �� ������ �������
�. �������� �������� (��� ������� ������������ ���� ������ ��������)
  �. �������� ����������
  �. �������� ������� �������� � ���������
  �. ���������� ��������� �, ���, ��
�. ���������� ����������.
�. ��������/������� ������� �� ���������

}
 { ������� ������ }
 TdcActionType = (atNone, atGoto, atInventory, atLogic, atText, atVariable, atButton);
  TdcAction = class(TqmBase)
  private
    f_ActionType: TdcActionType;
    function pm_GetTagName: string;
  public
    constructor Create; override;
    procedure Load(Element: IXMLNode); override;
    class function Make(aElement: IXMLNode): TdcAction;
    procedure Save(Element: IXMLNode); override;
    property ActionType: TdcActionType read f_ActionType write f_ActionType;
    property TagName: string read pm_GetTagName;
  end;

 TdcActionClass = class of TdcAction;

 { ����������� ������ }
  TdcTextAction = class(TdcAction)
  private
    function pm_GetDescription: string;
    procedure pm_SetDescription(const aValue: string);
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    procedure Load(Element: IXMLNode); override;
    procedure Save(Element: IXMLNode); override;
    property Description: string read pm_GetDescription write pm_SetDescription;
  end;

 { �������� �������� }
  TdcLogicAction = class(TdcAction)
  protected
    procedure ButtonClick(Sender: TObject);
    procedure MakePopupmenu(Sender: TObject);
  public
    constructor Create; override;
  end;

 { �������� � ���������� }
  TdcInventoryAction = class(TdcAction)
  private
    f_Inventory: TdcInventory;
  public
    constructor Create; override;
    procedure AddObject(aObjectName: String);
    function CheckObject(aObjectName: String): Boolean;
    procedure DeleteObject(aObjectName: String);
    property Inventory: TdcInventory read f_Inventory write f_Inventory;
  end;

 { �������� � ����������� }
  TdcVariableAction = class(TdcAction)
  private
    f_Value: string;
    f_Variable: TdcVariable;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    procedure Load(Element: IXMLNode); override;
    procedure Save(Element: IXMLNode); override;
    property Value: string read f_Value write f_Value;
    property Variable: TdcVariable read f_Variable write f_Variable;
  end;

 { ������� �� ������� }
  TdcGotoAction = class(TdcAction)
  private
    f_Location: TdcLocation;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    procedure Load(Element: IXMLNode); override;
    procedure Save(Element: IXMLNode); override;
    property Location: TdcLocation read f_Location write f_Location;
  end;

 { ������� �� ������� � ��������������� ������� }
  TdcButtonAction = class(TdcGotoAction)
  public
    constructor Create; override;
  end;


  //1 �������� ����
  //1 �������� ����
  {{
  �������� ����.
  ������� ���������, �����������, ����������
  }
  TdcScript = class(TqmBase)
  private
    f_Author: string;
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
    constructor Create; override;
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
    property Author: string read f_Author write f_Author;
    property Description: TStrings read f_Description write pm_SetDescription;
    property IsValid: Boolean read pm_GetIsValid;
    property Locations[Index: Integer]: TdcLocation read pm_GetLocations;
    property LocationsCount: Integer read pm_GetLocationsCount;
    property NotValidConditions: string read f_NotValidConditions;
    property ObjectsCount: Integer read pm_GetObjectsCount;
    property StartLocation: string read f_StartLocation write
        pm_SetStartLocation;
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
    function pm_GetTagName: string;
    procedure pm_SetEnum(const Value: TStrings);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(Element: IXMLNode); override;
    procedure Save(Element: IXMLNode); override;
    property Enum: TStrings read f_Enum write pm_SetEnum;
    property TagName: string read pm_GetTagName;
    property Value: string read f_Value write f_Value;
    property VarType: TdcVariableType read f_VarType write f_VarType;
  end;


  TdcActionList = class(TObjectList)
  private
    function pm_GetItems(Index: Integer): TdcAction;
  public
    property Items[Index: Integer]: TdcAction read pm_GetItems; default;
  end;

procedure CloneActions(aSource: TdcActionList; var aDestination: TdcActionList);

function FindInList(theList: TObjectList; const aCaption: String): TqmBase;

function ActionTypeToStr(aType: TdcActionType): string;

function StringToActionType(aStr: String): TdcActionType;

implementation

Uses
 SysUtils, XMLDoc, StrUtils, Variants, TypInfo, Dialogs;


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


{
*********************************** TqmBase ************************************
}
constructor TqmBase.Create;
begin
 inherited Create;
 Define('Caption', '��������', ptString, False);
end;

destructor TqmBase.Destroy;
begin
 inherited;
end;

procedure TqmBase.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
end;

function TqmBase.Clone: Pointer;
type
 RBase = class of TqmBase;
begin
 Result := RBase(ClassType).Create;
 TqmBase(Result).Assign(Self);
end;

procedure TqmBase.Load(Element: IXMLNode);
var
  i: Integer;
  l_Strings: TStrings;
  j: Integer;
begin
 for i:= 0 to Pred(Count) do
 begin
  with Items[i] do
  begin
    case PropertyType of
     ptString: Value:= Element.GetAttribute(Alias);    // TEdit
     ptInteger: Value:= Element.GetAttribute(Alias);   // TEdit
     ptText :  // TMemo
      begin
       l_Strings:= TStringList.Create;
       try
        l_Strings.Text:= Value;
        for j:= 0 to Pred(Element.ChildNodes.Count) do
         l_Strings.Add(Element.ChildNodes.Get(j).Text);
       finally
        FreeAndNil(l_Strings);
       end;
      end;
     ptBoolean: Value:= Element.GetAttribute(Alias);   // TRadioGroup (TCombobox)
     ptChoice:;    // TComboBox
     ptAction:;    // TButton
     ptProperties:; // TScrollBox (��������� ��������)
    end; // case
  end; // with Items[i]
 end; // for i
end;

function TqmBase.pm_GetCaption: string;
begin
 Result := Values['Caption'];
end;

procedure TqmBase.pm_SetCaption(const Value: string);
begin
 Values['Caption']:= Value;
end;

procedure TqmBase.Save(Element: IXMLNode);
var
  i: Integer;
  l_Strings: TStrings;
  j: Integer;
begin
 for i:= 0 to Pred(Count) do
 begin
  with Items[i] do
  begin
    case PropertyType of
     ptString: Element.SetAttribute(Alias, Value);    // TEdit
     ptInteger: Element.SetAttribute(Alias, Value);   // TEdit
     ptText :  // TMemo
      begin
       l_Strings:= TStringList.Create;
       try
        l_Strings.Text:= Value;
        for j:= 0 to Pred(l_Strings.Count) do
         Element.AddChild('Line').Text:= l_Strings[j];
       finally
        FreeAndNil(l_Strings);
       end;
      end;
     ptBoolean: Element.SetAttribute(Alias, Value);   // TRadioGroup (TCombobox)
     ptChoice:;    // TComboBox
     ptAction:;    // TButton
     ptProperties:; // TScrollBox (��������� ��������)
    end; // case
  end; // with Items[i]
 end; // for i
end;




{ TdcLocation }

{
********************************* TdcLocation **********************************
}
constructor TdcLocation.Create;
begin
 inherited;
 f_ActionList:= TdcActionList.Create;
end;

destructor TdcLocation.Destroy;
begin
  f_ActionList.Free;
  inherited;
end;

procedure TdcLocation.AddAction(aAction: TdcAction);
begin
 Assert(aAction <> nil, '������ ��������� ������ ��������');
 GenerateCaption(aAction);
 f_ActionList.Add(aAction);
end;

procedure TdcLocation.Assign(Source: TPersistent);
begin
 inherited;
 if Source is TdcLocation then
 begin
  Hint:=  TdcLocation(Source).Hint;
  CloneActions((Source as TdcLocation).ActionList, f_ActionList);
 end;
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
    l_Template:= '�����'
   else
   if (aAction is TdcGotoAction) and not (aAction is TdcButtonAction) then
    l_Template:= '�������'
   else
   if aAction is TdcInventoryAction then
    l_Template:= '���������'
   else
   if aAction is TdcLogicAction then
    l_Template:= '�������'
   else
   if aAction is TdcVariableAction then
    l_Template:= '����������'
   else
   if aAction is TdcButtonAction then
    l_Template:= '������';

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
  AddAction(TdcAction.Make(l_E));
 end; // for i
 l_Node:= Element.ChildNodes.FindNode('Buttons');
 for i:= 0 to l_Node.ChildNodes.Count - 1 do
 begin
  l_E:= l_Node.ChildNodes.Get(i);
  AddAction(TdcAction.Make(l_E));
 end; // for i
 if Element.HasAttribute('Hint') then
  Hint:= element.GetAttribute('Hint');
end;

class function TdcLocation.Make(aElement: IXMLNode; aModel: TdcScript):
    TdcLocation;
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

procedure TdcLocation.pm_SetActionList(aValue: TdcActionList);
begin
 CloneActions(aValue, f_ActionList);
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

procedure CloneActions(aSource: TdcActionList; var aDestination: TdcActionList);
var
 i: Integer;
begin
  aDestination.Clear;
  for I := 0 to aSource.Count - 1 do
  begin
   aDestination.Add((aSource[i] as TdcAction).Clone);
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
 if AnsiSameText(aStr, 'none') then
  Result:= atNone
 else
 if AnsiSameText(aStr, 'goto') then
  Result:= atGoto
 else
 if AnsiSameText(aStr, 'inv') then
  Result:= atInventory
 else
 if AnsiSameText(aStr, 'logic') then
  Result:= atLogic
 else
 if AnsiSameText(aStr, 'text') then
  Result:= atText
 else
 if AnsiSameText(aStr, 'var') then
  Result:= atVariable
 else
 if AnsiSameText(aStr, 'button') then
  Result:= atButton
end;


{
******************************** TdcGotoAction *********************************
}
constructor TdcGotoAction.Create;
begin
 inherited;
 ActionType:= atGoto;
end;

procedure TdcGotoAction.Assign(Source: TPersistent);
begin
 inherited;
 if Source is TdcGotoAction then
  f_Location:= (Source as TdcGotoAction).Location;
end;

procedure TdcGotoAction.Load(Element: IXMLNode);
begin
 inherited;
 //if Element.HasAttribute('Target') then
 // Location:= {Script.CheckLocation}(Element.Attributes['Target']);
end;

procedure TdcGotoAction.Save(Element: IXMLNode);
begin
 inherited;
 Element.SetAttribute('Target', Location.Caption);
end;

{ TdcGotoAction }

{
****************************** TdcInventoryAction ******************************
}
constructor TdcInventoryAction.Create;
begin
 inherited;
 ActionType:= atInventory;
end;

procedure TdcInventoryAction.AddObject(aObjectName: String);
begin
 // TODO -cMM: TdcInventoryAction.AddObject ���������� �������� ����������
end;

function TdcInventoryAction.CheckObject(aObjectName: String): Boolean;
begin
 Result := False;
 // TODO -cMM: TdcInventoryAction.CheckObject ���������� �������� ����������
end;

procedure TdcInventoryAction.DeleteObject(aObjectName: String);
begin
 // TODO -cMM: TdcInventoryAction.AddObject ���������� �������� ����������
end;

{ TdcChapter }

{
********************************** TdcScript ***********************************
}
constructor TdcScript.Create;
begin
 inherited;
 f_Locations:= TObjectList.Create;
 f_Variables:= TObjectList.Create;
 f_Description:= TStringList.Create;
 Caption:= '����� ��������';
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
 Result := '�������';
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
   // �������� ������
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
   // ����������
   l_Node:= ChildNodes.FindNode('Variables');
   if l_Node <> nil then
   begin
    // ��������� ����������
    for i:= 0 to Pred(l_Node.ChildNodes.Count) do
    begin
     l_C:= l_Node.ChildNodes.Get(i);
     NewVariable('').Load(l_C);
    end;
   end;
   // �������
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
   // ����� ������� CheckLocation
   // ���������
   l_Node:= ChildNodes.FindNode('Inventory');
   if l_Node <> nil then
   begin
    // ��������� �������� ���������
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
 for I := 0 to LocationsCount - 1 do
  aStrings.Add(Locations[i].Caption)
end;

function TdcScript.NewLocation(aCaption: String): TdcLocation;
begin
 Result:= CreateLocation;
 if Result <> nil then
 begin
  //if Result.Script = nil then
  // Result.Script:= Self;
  if aCaption = '' then
   Result.Caption:= GenerateCaption
  else
   Result.Caption:= aCaption;
  f_Locations.Add(Result);
 end;
end;

function TdcScript.NewVariable(const aCaption: String): TdcVariable;
begin
 Result:= TdcVariable.Create;
 Result.Caption:= aCaption;
 f_Variables.Add(Result);
end;

function TdcScript.pm_GetIsValid: Boolean;
begin
 f_NotValidConditions:= '';
 if StartLocation = '' then
  f_NotValidConditions:= '�� ������� ��������� �������';
 Result:= f_NotValidConditions = '';
end;

function TdcScript.pm_GetLocations(Index: Integer): TdcLocation;
begin
 Result := f_Locations.Items[Index] as TdcLocation;
end;

function TdcScript.pm_GetLocationsCount: Integer;
begin
 // TODO -cMM: TdcScript.pm_GetLocationsCount ���������� �������� ����������
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
   SetAttribute('Version', '1.0'); // �������� �� ���������
   SetAttribute('Date', DateToStr(Date));
   // �������� ������
   l_Node:= AddChild('Meta');
   l_Node.AddChild('Title').Text:= Caption;
   l_Node.AddChild('Author').Text:= Author;
   l_node.AddChild('Description').Text:= Description.text;
   // ����������
   l_Node:= AddChild('Variables');
   if VariablesCount > 0 then
    for i:= 0 to Pred(VariablesCount) do
     Variables[i].Save(l_Node.AddChild(Variables[i].TagName));
   // �������
   l_Node:= AddChild('Locations');
   l_Node.SetAttribute('Start', StartLocation);
   if LocationsCount > 0 then
    for i:= 0 to Pred(LocationsCount) do
     Locations[i].Save(l_Node.AddChild('Location'));
   // ���������
   l_Node:= AddChild('Inventory');
  end;
  l_XML.SaveToStream(aStream);
 finally
  l_XML:= nil;
 end;
end;

{
******************************** TdcTextAction *********************************
}
constructor TdcTextAction.Create;
begin
 inherited;
 ActionType:= atText;
 Define('Description', '�����', ptText);
end;

procedure TdcTextAction.Assign(Source: TPersistent);
begin
 inherited;
end;

procedure TdcTextAction.Load(Element: IXMLNode);
begin
  inherited;
  //f_Description.Text:= Element.ChildValues['Description'];
end;

function TdcTextAction.pm_GetDescription: string;
begin
  // TODO -cMM: TdcTextAction.pm_GetDescription default body inserted
  Result := Values['Description'];
end;

procedure TdcTextAction.pm_SetDescription(const aValue: string);
begin
 Values['Description']:= aValue;
end;

procedure TdcTextAction.Save(Element: IXMLNode);
begin
 inherited;
 // �� �����������...
 //Element.Text:= f_Description.Text;
end;

{
********************************** TdcAction ***********************************
}
constructor TdcAction.Create;
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

class function TdcAction.Make(aElement: IXMLNode): TdcAction;
begin
 Result:= nil;
  case StringToActionType(aElement.Attributes['Type']) of
    atGoto: Result:= TdcGotoAction.Create;
    atInventory: Result:= TdcInventoryAction.Create;
    atLogic: Result:= TdcLogicAction.Create;
    atText: Result:= TdcTextAction.Create;
    atVariable: Result:= TdcVariableAction.Create;
    atButton: Result:= TdcButtonAction.Create;
  end;
  if Result <> nil then
   Result.Load(aElement);
end;

function TdcAction.pm_GetTagName: string;
begin
 Result := ActionTypeToStr(ActionType);
end;

procedure TdcAction.Save(Element: IXMLNode);
begin
 inherited;
end;

{
******************************** TdcLogicAction ********************************
}
constructor TdcLogicAction.Create;
begin
 inherited;
 ActionType:= atLogic;
 Define('Condition', '�������', ptAction, True, ButtonClick);
 Define('True', '�����������', ptProperties, True, MakePopupmenu);
 Define('False', '�� �����������', ptProperties, True, MakePopupmenu);
end;

procedure TdcLogicAction.ButtonClick(Sender: TObject);
begin
 // TODO -cMM: �������� �������
 ShowMessage('��� ������������� ������� :)');
end;

procedure TdcLogicAction.MakePopupmenu(Sender: TObject);
begin
 // TODO -cMM: ���� ��� ���������� ���������
end;

{
****************************** TdcVariableAction *******************************
}
constructor TdcVariableAction.Create;
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
  //Variable:= f_Script.CheckVariable(element.GetAttribute('Variable'));
  //if (Variable <> nil) and Element.HasAttribute('Value') then
  // Value:= Element.GetAttribute('Value');
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

{
******************************* TdcButtonAction ********************************
}
constructor TdcButtonAction.Create;
begin
 inherited;
 ActionType:= atButton;
end;

{
********************************* TdcVariable **********************************
}
constructor TdcVariable.Create;
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

function TdcVariable.pm_GetTagName: string;
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

{ TdcActionList }

{
******************************** TdcActionList *********************************
}
function TdcActionList.pm_GetItems(Index: Integer): TdcAction;
begin
  Result:= TdcAction(inherited Items[Index])
end;

end.
