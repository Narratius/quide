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
    function pm_GetItemsValue(Index: Integer; const aAlias: String): Variant;
    procedure pm_SetItemsValue(Index: Integer; const aAlias: String;
      const Value: Variant);
    procedure pm_SetPropertyType(const Value: TPropertyType);
    function pm_GetOrdinalType: Boolean;
    function pm_GetItems(Index: Integer): TProperties;
  public
    destructor Destroy; override;
    function AddItem: Integer;
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
    property Items[Index: Integer]: TProperties read pm_GetItems;
    property ItemsCount: Integer read pm_GetItemsCount;
    property ItemsValue[Index: Integer; const aAlias: String]: Variant read pm_GetItemsValue write pm_SetItemsValue;
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
  public
    constructor Create;
    function Add: TProperty; overload;
    function Add(aProp: TProperty): TProperty; overload;
    procedure Assign(Source: TProperties);
    function Clone: Pointer;
    procedure Define(const aAlias, aCaption: String; aType: TPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
    procedure DefineList(const aAlias, aCaption: String; aItem: TPropertyLink; aVisible: Boolean = True);
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

const
 propBase = 100;
 propOrdinals : Set of TPropertyType = [ptString,    // TEdit
                  ptInteger,   // TEdit
                  ptText,      // TMemo
                  ptBoolean];   // TRadioGroup (TCombobox)


implementation

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

procedure TProperty.Assign(Source: TPersistent);
begin
  if Source is TProperty then
  begin
   f_Alias:= TProperty(Source).Alias;
   f_Caption:= TProperty(Source).Caption;
   f_PropertyType:= TProperty(Source).PropertyType;
   f_Value:= TProperty(Source).Value;
  end
  else
   inherited;
end;

{
********************************* TProperties **********************************
}
constructor TProperties.Create;
begin
 F_Items := TObjectList.Create(True);
end;

function TProperties.Add: TProperty;
begin
 Result := TProperty.Create;
 Result.ID:= f_Items.Add(Result) + propBase;
end;

function TProperties.Add(aProp: TProperty): TProperty;
begin
 Result:= TProperty(f_Items.Add(aProp));
end;

procedure TProperties.Assign(Source: TProperties);
var
  I: Integer;
begin
  f_Items.Clear; //

  for I := 0 to TProperties(Source).Count - 1 do
   Add.Assign(TProperties(Source).Items[I]);
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
 l_P:= Add;
 l_P.Alias:= aAlias;
 l_P.Caption:= aCaption;
 l_P.PropertyType:= aType;
 l_P.Visible:= aVisible;
 l_P.Event:= aEvent;
end;

procedure TProperties.DefineList(const aAlias, aCaption: String;
  aItem: TPropertyLink; aVisible: Boolean);
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
var
  i, j: Integer;
  l_E: IXMLNode;
  l_Strings: TStrings;
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
        l_E:= Element.AddChild('Texts');
        try
          l_Strings:= TStringList.Create;
          try
           l_Strings.Text:= Value;
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
      ptBoolean: Value:= Element.GetAttribute(Alias);   // TRadioGroup (TCombobox)
      ptChoice,    // TComboBox
      ptAction,    // TButton
      ptProperties: ; // TScrollBox (Вложенные свойства)
     end; // case
   end; // with Items[i]
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

procedure TProperties.SaveToXML(Element: IXMLNode);
var
  i, j: Integer;
  l_E: IXMLNode;
  l_Strings: TStrings;
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
        l_E:= Element.AddChild('Texts');
        try
          l_Strings:= TStringList.Create;
          try
           l_Strings.Text:= Value;
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
      ptBoolean: Element.SetAttribute(Alias, Value);   // TRadioGroup (TCombobox)
      ptChoice,    // TComboBox
      ptAction,    // TButton
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

function TProperty.pm_GetItemsValue(Index: Integer;
  const aAlias: String): Variant;
begin
 Result:= Items[Index].Values['aAlias'];
end;

function TProperty.pm_GetOrdinalType: Boolean;
begin
 Result:= f_PropertyType in propOrdinals;
end;

procedure TProperty.pm_SetItemsValue(Index: Integer; const aAlias: String;
  const Value: Variant);
begin
 Items[Index].Values['aAlias']:= Value;
end;

procedure TProperty.pm_SetPropertyType(const Value: TPropertyType);
begin
  f_PropertyType := Value;
  if Value = ptList then
   f_SubItems:= TObjectList.Create(True);
end;

procedure TProperty.SetItem(aItem: TPropertyLink);
var
 l_I: TPropertyLink;
 l_L: TPropertyLink;
begin
 FreeAndNil(f_Item);
 f_Item:= TProperties.Create;
 l_I:= aItem;
 while l_I <> nil do
 begin
   f_Item.Add(aItem.Item);
   l_L:= l_I;
   l_I:= l_I.Next;
   FreeAndNil(l_L);
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
end;

end.
