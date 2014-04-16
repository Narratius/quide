unit Propertys;

interface

uses
  SysUtils, Windows, Messages, Classes, Xml.XMLIntf, Contnrs,
  PropertyIntf;

type
 TPropertyType = (ptString,    // TEdit
                  ptInteger,   // TEdit
                  ptText,      // TMemo
                  ptBoolean,   // TRadioGroup (TCombobox)
                  ptChoice,    // TComboBox
                  ptAction,    // TButton
                  ptList,      // TListBox
                  ptProperties // TScrollBox (Вложенные свойства)
                  );

  TPropertyLink = class;
  TProperties = class;
  TProperty = class(TPersistent)
  private
    f_Alias: string;
    f_Caption: String;
    f_Event: TNotifyEvent;
    f_PropertyType: TPropertyType;
    f_Value: Variant;
    f_Visible: Boolean;
    f_ID: Integer;
    f_Item: TProperties;
    f_SubItems: TObjectList;
    function pm_GetItemsCount: Integer;
    procedure pm_SetPropertyType(const Value: TPropertyType);
    function pm_GetOrdinalType: Boolean;
    function pm_GetItems(Index: Integer): TProperties;
    procedure pm_SetItem(const Value: TProperties);
  public
    constructor Create(const aAlias, aCaption: String; aType: TPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil); reintroduce;
    constructor MakeClone(aSource: TProperty);
    destructor Destroy; override;
    function AddItem: Integer; overload;
    function AddItem(aItem: TProperties): Integer; overload;
    procedure DeleteItem(Index: Integer);
    procedure Assign(Source: TPersistent); override;
    procedure SetItem(aItem: TPropertyLink);
    property Alias: string read f_Alias write f_Alias;
    property Caption: String read f_Caption write f_Caption;
    property ID: Integer read f_ID write f_ID;
    property OrdinalType: Boolean read pm_GetOrdinalType;
    property PropertyType: TPropertyType read f_PropertyType write
        pm_SetPropertyType;
    property Value: Variant read f_Value write f_Value;
    property Visible: Boolean read f_Visible write f_Visible;
    property Event: TNotifyEvent read f_Event write f_Event;
    property Item: TProperties read f_Item write pm_SetItem;
    property Items[Index: Integer]: TProperties read pm_GetItems;
    property ItemsCount: Integer read pm_GetItemsCount;
  end;


  TPropertyLink = class
  private
    FItem: TProperty;
    FNext: TPropertyLink;
  private
    procedure SetItem(const Value: TProperty);
    procedure SetNext(const Value: TPropertyLink);
  public
   constructor Create(aItem: TProperty; aNext: TPropertyLink = nil);
   property Item: TProperty read FItem write SetItem;
   property Next: TPropertyLink read FNext write SetNext;
  end;

  TPropertyFunc = function (aItem: TProperty): Boolean of object;
  TProperties = class(TInterfacedObject, IpropertyStore)
  private
    f_Changed: Boolean;
    f_Items: TObjectList;
    function FindProperty(aAlias: String): TProperty;
    function pm_GetAliasItems(Alias: String): TProperty;
    function pm_GetItems(Index: Integer): TProperty;
    function pm_GetValues(Alias: String): Variant;
    procedure pm_SetAliasItems(Alias: String; aValue: TProperty);
    procedure pm_SetChanged(const Value: Boolean);
    procedure pm_SetValues(Alias: String; const Value: Variant);
    function pm_GetCount: Integer;
    procedure SaveValues(Element: IXMLNode);
    procedure LoadValues(Element: IXMLNode);
    procedure SaveHeader(Element: IXMLNode);
    procedure LoadHeader(Element: IXMLNode);
  public
    constructor Create;
    function Add(const aAlias, aCaption: String; aType: TPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil): TProperty; overload;
    function Add(aProp: TProperty): TProperty; overload;
    procedure Assign(Source: TProperties);
    function Clone: Pointer;
    procedure Define(const aAlias, aCaption: String; aType: TPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
    procedure DefineList(const aAlias, aCaption: String;  aVisible: Boolean = True; aItem: TPropertyLink = nil);
    procedure IterateAll(aFunc: TPropertyFunc);
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    property AliasItems[Alias: String]: TProperty read pm_GetAliasItems write
        pm_SetAliasItems; default;
    property Changed: Boolean read f_Changed write pm_SetChanged;
    property Count: Integer read pm_GetCount;
    property Items[Index: Integer]: TProperty read pm_GetItems;
    property Values[Alias: String]: Variant read pm_GetValues write pm_SetValues;
  end;

  TPropertyList = class helper for TProperty
  private
    function GetValues(Index: Integer; Alias: String): Variant;
    function pm_GetCount: Integer;
    procedure SetValues(Index: Integer; Alias: String; const Value: Variant);
  public
    property Count: Integer read pm_GetCount;
    property Values[Index: Integer; Alias: String]: Variant read GetValues write SetValues;
  end;

  TComboBoxProperty = class helper for TProperty
   procedure AddChoice(const aText: String);
  end;

const
 propBase = 100;
 propOrdinals : Set of TPropertyType = [ptString,    // TEdit
                  ptInteger,   // TEdit
                  //ptText,      // TMemo
                  ptAction, // Tbutton
                  ptBoolean];   // TRadioGroup (TCombobox)

function PropertyType2String(aType: TPropertyType): String;

function String2PropertyType(const aText: String): TPropertyType;

implementation

Uses
 Variants;

const
 PropertyTypeNames: Array[TPropertyType] of String = (
  'String', 'Integer', 'Text', 'Boolean', 'Choice', 'Action', 'List', 'Properties');

function PropertyType2String(aType: TPropertyType): String;
begin
 Result:= PropertyTypeNames[aType];
end;

function String2PropertyType(const aText: String): TPropertyType;
var
 i: TPropertyType;
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
********************************** TProperty ***********************************
}
function TProperty.AddItem: Integer;
var
 l_SubItem: TProperties;
begin
 Result:= -1;
 if PropertyType = ptList then
 begin
   l_SubItem:= f_Item.Clone;
   Result:= f_SubItems.Add(l_SubItem);
 end;
end;

function TProperty.AddItem(aItem: TProperties): Integer;
begin
 Result:= f_SubItems.Add(aItem);
end;

procedure TProperty.DeleteItem(Index: Integer);
begin
 f_SubItems.Delete(Index);
end;

procedure TProperty.Assign(Source: TPersistent);
begin
  if Source is TProperty then
  begin
   f_Alias:= TProperty(Source).Alias;
   f_Caption:= TProperty(Source).Caption;
   f_PropertyType:= TProperty(Source).PropertyType;
   f_Value:= TProperty(Source).Value;
   f_Visible:= TProperty(Source).Visible;
   f_ID:= TProperty(Source).ID; // ?
   if PropertyType = ptList then
   begin
    Item:= TProperty(Source).Item;
    // SubItems
   end;
  end
  else
   inherited;
end;

constructor TProperty.Create;
begin
  inherited Create;
  Alias:= aAlias;
  Caption:= aCaption;
  PropertyType:= aType;
  Visible:= aVisible;
  Event:= aEvent;
end;


constructor TProperty.MakeClone(aSource: TProperty);
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

function TProperties.Add(const aAlias, aCaption: String; aType: TPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil): TProperty;
begin
 Result := TProperty.Create(aAlias, aCaption, aType, aVisible, aEvent);
 Result.ID:= f_Items.Add(Result) + propBase;
end;

function TProperties.Add(aProp: TProperty): TProperty;
begin
 Result:= TProperty(f_Items.Add(aProp));
end;

procedure TProperties.Assign(Source: TProperties);
var
  I: Integer;
  l_Prop: TProperty;
begin
  f_Items.Clear; //

  for I := 0 to TProperties(Source).Count - 1 do
  begin
   l_Prop:= TProperty.MakeClone(TProperties(Source).Items[I]);
   Add(l_Prop);
  end;
end;

function TProperties.Clone;
begin
 Result:= TProperties.Create;
 TProperties(Result).Assign(Self);
end;

procedure TProperties.Define(const aAlias, aCaption: String; aType:
    TPropertyType; aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
var
 l_P: TProperty;
begin
 // Проверить валидность Alias - не должна начинаться с цифры
 l_P:= Add(aAlias, aCaption, aType, aVisible, aEvent);
end;

procedure TProperties.DefineList(const aAlias, aCaption: String; aVisible: Boolean;
  aItem: TPropertyLink);
var
 l_P: TProperty;
begin
 Define(aAlias, aCaption, ptList, aVisible);
 l_P:= AliasItems[aAlias];
 l_P.SetItem(aItem);
end;

function TProperties.FindProperty(aAlias: String): TProperty;
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

procedure TProperties.IterateAll(aFunc: TPropertyFunc);
var
 i: Integer;
 l_Item: TProperty;
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
  l_Prop: TProperty;
  l_SubItem: TProperties;
  l_Type: TPropertyType;
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
        AliasItems[l_Alias].Item:= l_SubItem;
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
           AliasItems[l_Alias].Items[k].Assign(l_SubItem);
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

function TProperties.pm_GetAliasItems(Alias: String): TProperty;
begin
  Result:= FindProperty(Alias);
end;

function TProperties.pm_GetCount: Integer;
begin
 Result:= f_Items.Count;
end;

function TProperties.pm_GetItems(Index: Integer): TProperty;
begin
  Result:= TProperty(f_Items[Index]);
end;

function TProperties.pm_GetValues(Alias: String): Variant;
begin
 Result := AliasItems[Alias].Value;
end;

procedure TProperties.pm_SetAliasItems(Alias: String; aValue: TProperty);
var
  l_Prop: TProperty;
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
        Item.SaveToXML(l_Item.AddChild('Properties'));
        for j := 0 to Count-1 do
         Items[j].SaveToXML(l_Value.AddChild('Item'));
       end; // ptList
      ptProperties: ; // TScrollBox (Вложенные свойства)
     end; // case
   end; // with Items[i]
  end; // for i
end;

{ TPropertyLink }

constructor TPropertyLink.Create(aItem: TProperty; aNext: TPropertyLink);
begin
 FItem:= aItem;
 FNext:= aNext;
end;

procedure TPropertyLink.SetItem(const Value: TProperty);
begin
  FItem := Value;
end;

procedure TPropertyLink.SetNext(const Value: TPropertyLink);
begin
  FNext := Value;
end;

destructor TProperty.Destroy;
begin
 FreeAndNil(f_SubItems);
  inherited;
end;

function TProperty.pm_GetItems(Index: Integer): TProperties;
begin
 Result:= nil;
 if PropertyType = ptList then
  Result:= TProperties(f_SubItems[index])
end;

function TProperty.pm_GetItemsCount: Integer;
begin
 if PropertyType = ptList then
  Result:= f_SubItems.Count
 else
  Result:= -1;
end;

function TProperty.pm_GetOrdinalType: Boolean;
begin
 Result:= f_PropertyType in propOrdinals;
end;

procedure TProperty.pm_SetItem(const Value: TProperties);
begin
 if (PropertyType = ptList) then
 begin
  if f_Item = nil then
   f_Item:= TProperties.Create;
  f_Item.Assign(Value);
 end
 else
  raise Exception.Create('Свойство не ptList'); // Добавить ошибку
end;

procedure TProperty.pm_SetPropertyType(const Value: TPropertyType);
begin
  f_PropertyType := Value;
  if Value = ptList then
   f_SubItems:= TObjectList.Create(True);
end;

procedure TProperty.SetItem(aItem: TPropertyLink);
var
 l_Item: TPropertyLink;
 l_Next: TPropertyLink;
begin
 FreeAndNil(f_Item);
 f_Item:= TProperties.Create;
 l_Next:= aItem;
 while l_Next <> nil do
 begin
   f_Item.Add(l_Next.Item);
   l_Item:= l_Next;
   l_Next:= l_Item.Next;
   FreeAndNil(l_Item);
 end;
end;


{ TPropertyList }

function TPropertyList.GetValues(Index: Integer; Alias: String): Variant;
begin
 if Self.PropertyType = ptList then
  Result:= Self.Items[Index].Values[Alias]
 else
  Result:= ''
end;

function TPropertyList.pm_GetCount: Integer;
begin
 Result:= Self.ItemsCount
end;

procedure TPropertyList.SetValues(Index: Integer; Alias: String;
  const Value: Variant);
begin
 if Self.PropertyType = ptList then
  Self.Items[Index].Values[Alias]:= Value;
(* ^     ^            ^
   |     |             `-- Values
   |      `--------------- TProperties
   `---------------------- TProperty
 *)
end;

{ TComboBoxProperty }

procedure TComboBoxProperty.AddChoice(const aText: String);
begin
 if Self.PropertyType = ptChoice then
 begin
   //
 end;
end;

end.
