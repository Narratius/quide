unit Propertys;

interface

uses
  SysUtils, Windows, Messages, Classes, Xml.XMLIntf, Contnrs,
  PropertyIntf;

type
 TddPropertyType = (ptString,    // TEdit
                  ptInteger,   // TEdit
                  ptText,      // TMemo
                  ptBoolean,   // TRadioGroup (TCombobox)
                  ptChoice,    // TComboBox
                  ptAction,    // TButton
                  ptList,      // TListBox
                  ptProperties // TScrollBox (Вложенные свойства)
                  );

  TddPropertyLink = class;
  TProperties = class;
  TddProperty = class(TPersistent)
  private
    f_Alias: string;
    f_Caption: String;
    f_Event: TNotifyEvent;
    f_PropertyType: TddPropertyType;
    f_Value: Variant;
    f_Visible: Boolean;
    f_ID: Integer;
    f_ListItem: TProperties;      // Эталонный элемент списка
    f_ListItems: TObjectList;  // Элементы списка
    function pm_GetItemsCount: Integer;
    procedure pm_SetPropertyType(const Value: TddPropertyType);
    function pm_GetOrdinalType: Boolean;
    function pm_GetItems(Index: Integer): TProperties;
    procedure pm_SetItem(const Value: TProperties);
  public
    constructor Create(const aAlias, aCaption: String; aType: TddPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil); reintroduce;
    constructor MakeClone(aSource: TddProperty);
    destructor Destroy; override;
    function AddItem: Integer; overload;
    function AddItem(aItem: TProperties): Integer; overload;
    procedure DeleteItem(Index: Integer);
    procedure Assign(Source: TPersistent); override;
    procedure SetItem(aItem: TddPropertyLink);
    property Alias: string read f_Alias write f_Alias;
    property Caption: String read f_Caption write f_Caption;
    property ID: Integer read f_ID write f_ID;
    property OrdinalType: Boolean read pm_GetOrdinalType;
    property PropertyType: TddPropertyType read f_PropertyType write
        pm_SetPropertyType;
    property Value: Variant read f_Value write f_Value;
    property Visible: Boolean read f_Visible write f_Visible;
    property Event: TNotifyEvent read f_Event write f_Event;
    property ListItem: TProperties read f_ListItem write pm_SetItem;
    property ListItems[Index: Integer]: TProperties read pm_GetItems;
    property ListItemsCount: Integer read pm_GetItemsCount;
  end;


  TddPropertyLink = class
  private
    FItem: TddProperty;
    FNext: TddPropertyLink;
  private
    procedure SetItem(const Value: TddProperty);
    procedure SetNext(const Value: TddPropertyLink);
  public
   constructor Create(aItem: TddProperty; aNext: TddPropertyLink = nil);
   property Item: TddProperty read FItem write SetItem;
   property Next: TddPropertyLink read FNext write SetNext;
  end;

  TddPropertyFunc = function (aItem: TddProperty): Boolean of object;
  TProperties = class(TInterfacedObject, IpropertyStore)
  private
    f_Changed: Boolean;
    f_Items: TObjectList;
    function FindProperty(aAlias: String): TddProperty;
    function pm_GetAliasItems(Alias: String): TddProperty;
    function pm_GetItems(Index: Integer): TddProperty;
    function pm_GetValues(Alias: String): Variant;
    procedure pm_SetAliasItems(Alias: String; aValue: TddProperty);
    procedure pm_SetChanged(const Value: Boolean);
    procedure pm_SetValues(Alias: String; const Value: Variant);
    function pm_GetCount: Integer;
    procedure SaveValues(Element: IXMLNode);
    procedure LoadValues(Element: IXMLNode);
    procedure SaveHeader(Element: IXMLNode);
    procedure LoadHeader(Element: IXMLNode);
    function pm_GetVisible(Alias: String): Boolean;
    procedure pm_SetVisible(Alias: String; const Value: Boolean);
  public
    constructor Create;
    function Add(const aAlias, aCaption: String; aType: TddPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil): TddProperty; overload;
    function Add(aProp: TddProperty): TddProperty; overload;
    procedure Assign(Source: TProperties);
    function Clone: Pointer;
    procedure Define(const aAlias, aCaption: String; aType: TddPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
    procedure DefineList(const aAlias, aCaption: String;  aVisible: Boolean = True; aItem: TddPropertyLink = nil);
    procedure IterateAll(aFunc: TddPropertyFunc);
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    property AliasItems[Alias: String]: TddProperty read pm_GetAliasItems write
        pm_SetAliasItems; default;
    property Changed: Boolean read f_Changed write pm_SetChanged;
    property Count: Integer read pm_GetCount;
    property Items[Index: Integer]: TddProperty read pm_GetItems;
    property Values[Alias: String]: Variant read pm_GetValues write pm_SetValues;
    property Visible[Alias: String]: Boolean read pm_GetVisible write pm_SetVisible;
  end;

type
(*
  TddPropertyList = class helper for TddProperty
  private
    function GetValues(Index: Integer; Alias: String): Variant;
    function pm_GetCount: Integer;
    procedure SetValues(Index: Integer; Alias: String; const Value: Variant);
  public
    property Count: Integer read pm_GetCount;
    property Values[Index: Integer; Alias: String]: Variant read GetValues write SetValues;
  end;
*)
  TComboBoxProperty = class helper for TddProperty
  private
   procedure CheckList;
  public
   procedure AddChoice(const aText: String);
  end;

const
 propBase = 100;
 propOrdinals : Set of TddPropertyType = [ptString,    // TEdit
                  ptInteger,   // TEdit
                  //ptText,      // TMemo
                  ptAction, // Tbutton
                  ptBoolean];   // TRadioGroup (TCombobox)

function PropertyType2String(aType: TddPropertyType): String;

function String2PropertyType(const aText: String): TddPropertyType;

implementation

Uses
 Variants;

const
 PropertyTypeNames: Array[TddPropertyType] of String = (
  'String', 'Integer', 'Text', 'Boolean', 'Choice', 'Action', 'List', 'Properties');

function PropertyType2String(aType: TddPropertyType): String;
begin
 Result:= PropertyTypeNames[aType];
end;

function String2PropertyType(const aText: String): TddPropertyType;
var
 i: TddPropertyType;
begin
 Result:= ptString;
 for I := Low(i) to High(i) do
  if AnsiSameText(aText, PropertyTypeNames[i]) then
  begin
    Result:= i;
    break;
  end;
end;

{
********************************** TddProperty ***********************************
}
function TddProperty.AddItem: Integer;
var
 l_ListItem: TProperties;
begin
 Result:= -1;
 if PropertyType = ptList then
 begin
   l_ListItem:= f_ListItem.Clone;
   Result:= f_ListItems.Add(l_ListItem);
 end;
end;

function TddProperty.AddItem(aItem: TProperties): Integer;
begin
 Result:= f_ListItems.Add(aItem);
end;

procedure TddProperty.DeleteItem(Index: Integer);
begin
 f_ListItems.Delete(Index);
end;

procedure TddProperty.Assign(Source: TPersistent);
begin
  if Source is TddProperty then
  begin
   f_Alias:= TddProperty(Source).Alias;
   f_Caption:= TddProperty(Source).Caption;
   f_PropertyType:= TddProperty(Source).PropertyType;
   f_Value:= TddProperty(Source).Value;
   f_Visible:= TddProperty(Source).Visible;
   f_ID:= TddProperty(Source).ID; // ?
   if PropertyType = ptList then
   begin
    ListItem:= TddProperty(Source).ListItem;
    // SubItems
   end;
  end
  else
   inherited;
end;

constructor TddProperty.Create;
begin
  inherited Create;
  Alias:= aAlias;
  Caption:= aCaption;
  PropertyType:= aType;
  Visible:= aVisible;
  Event:= aEvent;
end;


constructor TddProperty.MakeClone(aSource: TddProperty);
begin
 Create(aSource.Alias, aSource.Caption, aSource.PropertyType, aSource.Visible, aSource.Event);
 Assign(aSource);
end;


{
********************************* TProperties **********************************
}
constructor TProperties.Create;
begin
 F_Items := TObjectList.Create(True);
end;

function TProperties.Add(const aAlias, aCaption: String; aType: TddPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil): TddProperty;
begin
 Result := TddProperty.Create(aAlias, aCaption, aType, aVisible, aEvent);
 Result.ID:= f_Items.Add(Result) + propBase;
end;

function TProperties.Add(aProp: TddProperty): TddProperty;
begin
 Result:= TddProperty(f_Items.Add(aProp));
end;

procedure TProperties.Assign(Source: TProperties);
var
  I: Integer;
  l_Prop: TddProperty;
begin
  f_Items.Clear; //

  for I := 0 to TProperties(Source).Count - 1 do
  begin
   l_Prop:= TddProperty.MakeClone(TProperties(Source).Items[I]);
   Add(l_Prop);
  end;
end;

function TProperties.Clone;
begin
 Result:= TProperties.Create;
 TProperties(Result).Assign(Self);
end;

procedure TProperties.Define(const aAlias, aCaption: String; aType:
    TddPropertyType; aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
var
 l_P: TddProperty;
begin
 // Проверить валидность Alias - не должна начинаться с цифры
 l_P:= Add(aAlias, aCaption, aType, aVisible, aEvent);
end;

procedure TProperties.DefineList(const aAlias, aCaption: String; aVisible: Boolean;
  aItem: TddPropertyLink);
var
 l_P: TddProperty;
begin
 Define(aAlias, aCaption, ptList, aVisible);
 l_P:= AliasItems[aAlias];
 l_P.SetItem(aItem);
end;

function TProperties.FindProperty(aAlias: String): TddProperty;
var
  i: Integer;
begin
   Result:= nil;
   for i:= 0 to Pred(Count) do
    if AnsiSameText(Items[i].Alias, aAlias) then
    begin
     Result:= Items[i];
     break
    end;
end;

procedure TProperties.IterateAll(aFunc: TddPropertyFunc);
var
 i: Integer;
 l_Item: TddProperty;
begin
 if Assigned(aFunc) then
  for i:= 0 to Pred(Count) do
  begin
   l_Item:= Items[i];
   if not aFunc(l_Item) then
    break;
  end;
end;

procedure TProperties.LoadFromXML(Element: IXMLNode);
begin
 if Element <> nil then
 begin
   LoadHeader(Element);
   LoadValues(Element);
 end;
end;


procedure TProperties.LoadHeader(Element: IXMLNode);
begin
  // Загрузка структуры элемента и создание элементов
end;

procedure TProperties.LoadValues(Element: IXMLNode);
var
  i, j, k: Integer;
  l_E: IXMLNode;
  l_Strings: TStrings;
  l_Item, l_Value: IXMLNode;
  l_Prop: TddProperty;
  l_SubItem: TProperties;
  l_Type: TddPropertyType;
  l_Alias, l_Caption: String;
  l_Visible: Boolean;
begin
 // Загрузка значений элементов
  for i:= 0 to Pred(Element.ChildNodes.Count) do
  begin

    l_Item:= Element.ChildNodes.Nodes[i];
    if AnsiSameText(l_Item.NodeName, 'Property') then
    begin
      l_Alias:= l_Item.ChildValues['Alias'];
      l_Caption:= l_Item.ChildValues['Caption'];
      if not TryStrToBool(l_Item.ChildValues['Visible'], l_Visible) then
       l_Visible:= True; // Или False
      l_Type:= String2PropertyType(l_Item.ChildValues['Type']);
      if l_Type in propOrdinals then
      begin
       Define(l_Alias, l_Caption, l_Type, l_Visible);
       try
       Values[l_Alias]:= l_Item.ChildValues['Value'];
       except
       Values[l_Alias]:= l_Item.ChildValues['Value'];
       end;
      end
      else
      if l_Type = ptText then
      begin
        Define(l_Alias, l_Caption, l_Type, l_Visible);
        l_E:= l_Item.ChildNodes.FindNode('Texts');
        if l_E <> nil then
        try
          l_Strings:= TStringList.Create;
          try
           for j:= 0 to Pred(l_E.ChildNodes.Count) do
            if AnsiSameText(l_E.ChildNodes.Nodes[j].NodeName, 'Text') then
            l_Strings.Add(l_E.ChildValues[j]);
           Values[l_Alias]:= l_Strings.Text;
          finally
           FreeAndNil(l_Strings);
          end;
        finally
         l_E:= nil;
        end;
      end
      else
      if l_Type = ptList then
      begin
       DefineList(l_Alias, l_Caption, l_Visible);
       // Прочитать описание элемента списка
       l_E:= l_Item.ChildNodes.FindNode('Properties');
       l_SubItem:= TProperties.Create;
       try
        l_SubItem.LoadFromXML(l_E);
        AliasItems[l_Alias].ListItem:= l_SubItem;
       finally
        FreeAndNil(l_SubItem);
       end;
       // Прочитать сам список
       l_E:= l_Item.ChildNodes.FindNode('Value');
       for j := 0 to l_E.ChildNodes.Count-1 do
       begin
         if AnsiSameText(l_E.ChildNodes.Get(j).NodeName, 'Item') then
         begin
          // В принципе, можно считывать только Value - все остальное у нас уже есть
          k:= AliasItems[l_Alias].AddItem;
          l_SubItem:= TProperties.Create; // потом вынести за скобки
          try
           l_SubItem.LoadFromXML(l_E.ChildNodes.Get(j));
           AliasItems[l_Alias].ListItems[k].Assign(l_SubItem);
          finally
           FreeAndNil(l_SubItem);
          end;
         end; // Item
       end; // for j
      end // ptList
      else
      if l_Type = ptChoice then
      begin
       Define(l_Alias, l_Caption, l_Type, l_Visible);
      end;
    end; // Property
  end; // for i
end;

function TProperties.pm_GetAliasItems(Alias: String): TddProperty;
begin
  Result:= FindProperty(Alias);
end;

function TProperties.pm_GetCount: Integer;
begin
 Result:= f_Items.Count;
end;

function TProperties.pm_GetItems(Index: Integer): TddProperty;
begin
  Result:= TddProperty(f_Items[Index]);
end;

function TProperties.pm_GetValues(Alias: String): Variant;
begin
 Result := AliasItems[Alias].Value;
end;

function TProperties.pm_GetVisible(Alias: String): Boolean;
begin
 Result:= AliasItems[Alias].Visible;
end;

procedure TProperties.pm_SetAliasItems(Alias: String; aValue: TddProperty);
var
  l_Prop: TddProperty;
begin
  l_Prop:= FindProperty(Alias);
  if l_Prop = nil then
   raise Exception.CreateFmt('Отсутствует указанное свойство %s', [Alias]);
  l_Prop.Assign(aValue);
end;

procedure TProperties.pm_SetChanged(const Value: Boolean);
begin
 f_Changed := Value;
end;

procedure TProperties.pm_SetValues(Alias: String; const Value: Variant);
begin
 AliasItems[Alias].Value:= Value;
 Changed:= True;
end;

procedure TProperties.pm_SetVisible(Alias: String; const Value: Boolean);
begin
 AliasItems[Alias].Visible:= Value;
 Changed:= True;
end;

procedure TProperties.SaveHeader(Element: IXMLNode);
begin
 // Сохраение структуры элемента
end;

procedure TProperties.SaveToXML(Element: IXMLNode);
begin
 SaveHeader(Element);
 SaveValues(Element);
end;



procedure TProperties.SaveValues(Element: IXMLNode);
var
  i, j: Integer;
  l_E: IXMLNode;
  l_Strings: TStrings;
  l_Item, l_Value: IXMLNode;
begin
 // Сохранение значений элементов
  for i:= 0 to Pred(Count) do
  begin
   with Items[i] do
   begin
    l_Item:= Element.AddChild('Property');
    l_Item.AddChild('Alias').Text:= Alias;
    l_Item.AddChild('Caption').Text:= Caption;
    l_Item.AddChild('Visible').Text:= BoolToStr(Visible, True);
    l_Item.AddChild('Type').Text:= PropertyType2String(PropertyType);
    l_Value:= l_Item.AddChild('Value');
     case PropertyType of
      ptString: l_Value.Text:= VarToStr(Value);    // TEdit
      ptInteger: l_Value.Text:= VarToStr(Value);   // TEdit
      ptText :  // TMemo
       begin
        l_E:= l_Value.AddChild('Texts');
        try
          l_Strings:= TStringList.Create;
          try
           l_Strings.Text:= VarToStr(Value);
           l_E.SetAttribute('TextCount', l_Strings.Count);
           for j:= 0 to Pred(l_Strings.Count) do
            l_E.AddChild('Text').Text:= l_Strings[j];
          finally
           FreeAndNil(l_Strings);
          end;
        finally
         l_E:= nil;
        end;
       end;
      ptBoolean: l_Value.Text:= Value;   // TRadioGroup (TCombobox)
      ptChoice: // TComboBox
       begin

       end;
      ptAction:;    // TButton
      ptList:
       begin
        // Записываем описание эталонного элемента
        ListItem.SaveToXML(l_Item.AddChild('Properties'));
        // Теперь скидываем все элементы списка
        for j := 0 to ListItemsCount-1 do
         ListItems[j].SaveToXML(l_Value.AddChild('Item'));
       end; // ptList
      ptProperties: ; // TScrollBox (Вложенные свойства)
     end; // case
   end; // with Items[i]
  end; // for i
end;

{ TddPropertyLink }

constructor TddPropertyLink.Create(aItem: TddProperty; aNext: TddPropertyLink);
begin
 FItem:= aItem;
 FNext:= aNext;
end;

procedure TddPropertyLink.SetItem(const Value: TddProperty);
begin
  FItem := Value;
end;

procedure TddPropertyLink.SetNext(const Value: TddPropertyLink);
begin
  FNext := Value;
end;

destructor TddProperty.Destroy;
begin
 FreeAndNil(f_ListItems);
 FreeAndNil(f_ListItem);
 inherited;
end;

function TddProperty.pm_GetItems(Index: Integer): TProperties;
begin
 Result:= nil;
 if PropertyType = ptList then
 try
  Result:= TProperties(f_ListItems[index])
 except
  Result:= TProperties(f_ListItems[index])
 end;
end;

function TddProperty.pm_GetItemsCount: Integer;
begin
 if PropertyType = ptList then
  Result:= f_ListItems.Count
 else
  Result:= -1;
end;

function TddProperty.pm_GetOrdinalType: Boolean;
begin
 Result:= f_PropertyType in propOrdinals;
end;

procedure TddProperty.pm_SetItem(const Value: TProperties);
begin
 if (PropertyType = ptList) then
 begin
  if f_ListItem = nil then
   f_ListItem:= TProperties.Create;
  f_ListItem.Assign(Value);
 end
 else
  raise Exception.Create('Свойство не ptList'); // Добавить ошибку
end;

procedure TddProperty.pm_SetPropertyType(const Value: TddPropertyType);
begin
  f_PropertyType := Value;
  if Value = ptList then
   f_ListItems:= TObjectList.Create(True);
end;

procedure TddProperty.SetItem(aItem: TddPropertyLink);
var
 l_Item: TddPropertyLink;
 l_Next: TddPropertyLink;
begin
 FreeAndNil(f_ListItem);
 f_ListItem:= TProperties.Create;
 l_Next:= aItem;
 while l_Next <> nil do
 begin
   f_ListItem.Add(l_Next.Item);
   l_Item:= l_Next;
   l_Next:= l_Item.Next;
   FreeAndNil(l_Item);
 end;
end;


{ TddPropertyList }
(*
function TddPropertyList.GetValues(Index: Integer; Alias: String): Variant;
begin
 if Self.PropertyType = ptList then
  Result:= Self.Items[Index].Values[Alias]
 else
  Result:= ''
end;

function TddPropertyList.pm_GetCount: Integer;
begin
 Result:= Self.ItemsCount
end;

procedure TddPropertyList.SetValues(Index: Integer; Alias: String;
  const Value: Variant);
begin
 if Self.PropertyType = ptList then
  Self.Items[Index].Values[Alias]:= Value;
{ ^     ^            ^
   |     |             `-- Values
   |      `--------------- TProperties
   `---------------------- TddProperty
 }
end;
*)

{ TComboBoxProperty }

procedure TComboBoxProperty.AddChoice(const aText: String);
begin
 if Self.PropertyType = ptChoice then
 begin
  CheckList;

 end;
end;

procedure TComboBoxProperty.CheckList;
begin
 if f_ListItems = nil then
 begin
   f_ListItems.Create;
   f_ListItem:= TProperties.Create;
   f_ListItem.Define('Caption', 'Название', ptString);
 end; // f_ListItems
end;

end.
