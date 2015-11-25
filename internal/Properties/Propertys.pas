unit Propertys;

interface

uses
  SysUtils, Windows, Messages, Classes, Xml.XMLIntf, Generics.Collections,
  PropertyIntf;

type
 TddPropertyType = (
                    ptChar,      // TEdit
                    ptString,    // TEdit
                    ptInteger,   // TEdit
                    ptText,      // TMemo
                    ptBoolean,   // TRadioGroup (TCombobox)
                    ptChoice,    // TComboBox
                    ptAction,    // TButton
                    ptList,      // TListBox
                    ptProperties // TScrollBox (��������� ��������)
                    );

  TddChoiceLink = class;
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
    f_ListItem: TProperties;      // ��������� ������� ������
    f_ListItems: TObjectList<TProperties>;
    f_Hint: String;
    f_OnChange: TNotifyEvent;  // �������� ������
    function pm_GetItemsCount: Integer;
    procedure pm_SetPropertyType(const Value: TddPropertyType);
    function pm_GetOrdinalType: Boolean;
    function pm_GetItems(Index: Integer): TProperties;
    procedure pm_SetItem(const Value: TProperties);
  public
    constructor Create(const aAlias, aCaption: String; aType: TddPropertyType;
        aVisible: Boolean = True); reintroduce;
    constructor MakeClone(aSource: TddProperty);
    constructor MakeList(const aAlias, aCaption: String; aListDef: TddPropertyLink;
        aVisible: Boolean = True);
    constructor MakeButton(const aAlias, aCaption: String; aEvent: TNotifyEvent;
        aVisible: Boolean = True);
    constructor MakeChoice(const aAlias, aCaption: String; aChoiceDef: TddChoiceLink;
        aVisible: Boolean = True);
    destructor Destroy; override;
    function AddItem: Integer; overload;
    function AddItem(aItem: TProperties): Integer; overload;
    procedure DeleteItem(Index: Integer);
    procedure Assign(Source: TPersistent); override;
    procedure SetItem(aItem: TddPropertyLink);
    procedure SetChoice(aChoiceDef: TddChoiceLink);
    property Alias: string read f_Alias write f_Alias;
    property Caption: String read f_Caption write f_Caption;
    property ID: Integer read f_ID write f_ID;
    property Hint: String read f_Hint write f_Hint;
    property OrdinalType: Boolean read pm_GetOrdinalType;
    property PropertyType: TddPropertyType read f_PropertyType write
        pm_SetPropertyType;
    property Value: Variant read f_Value write f_Value;
    property Visible: Boolean read f_Visible write f_Visible;
    property Event: TNotifyEvent read f_Event write f_Event;
    property ListItem: TProperties read f_ListItem write pm_SetItem;
    property ListItems[Index: Integer]: TProperties read pm_GetItems;
    property ListItemsCount: Integer read pm_GetItemsCount;
    property OnChange: TNotifyEvent read f_OnChange write f_OnChange;
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

  TddChoiceLink = class
  private
    FID: Integer;
    FText: String;
    FNext: TddChoiceLink;
    procedure SetID(const Value: Integer);
    procedure SetNext(const Value: TddChoiceLink);
    procedure SetText(const Value: String);
  public
   constructor Create(aID: Integer; aText: String; aNext: TddChoiceLink = nil);
   property ID: Integer read FID write SetID;
   property Text: String read FText write SetText;
   property Next: TddChoiceLink read FNext write SetNext;
  end;

  TddPropertyFunc = function (aItem: TddProperty): Boolean of object;
  TProperties = class(TInterfacedObject, IpropertyStore)
  private
    f_Changed: Boolean;
    f_Items: TObjectList<TddProperty>;
    FOnChange: TNotifyEvent;
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
    function GetHints(Alias: String): String;
    procedure SetHints(Alias: String; const Value: String);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure InnerOnChange(Sender: TObject);
  public
    constructor Create; virtual;
    function Add(aProp: TddProperty): TddProperty;
    procedure Assign(Source: TProperties);
    function Clone: Pointer;
    procedure Define(const aAlias, aCaption: String; aType: TddPropertyType;
        aVisible: Boolean = True);
    procedure DefineButton(const aAlias, aCaption: String; aEvent: TNotifyEvent);
    procedure DefineChoice(const aAlias, aCaption: String;  aVisible: Boolean = True; aItem: TddChoiceLink = nil);
    procedure DefineList(const aAlias, aCaption: String;  aVisible: Boolean = True; aItem: TddPropertyLink = nil);
    procedure IterateAll(aFunc: TddPropertyFunc);
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    property AliasItems[Alias: String]: TddProperty read pm_GetAliasItems write
        pm_SetAliasItems; default;
    property Changed: Boolean read f_Changed write pm_SetChanged;
    property Count: Integer read pm_GetCount;
    property Items[Index: Integer]: TddProperty read pm_GetItems;
    property Hints[Alias: String]: String read GetHints write SetHints;
    property Values[Alias: String]: Variant read pm_GetValues write pm_SetValues;
    property Visible[Alias: String]: Boolean read pm_GetVisible write pm_SetVisible;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
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
 propOrdinals : Set of TddPropertyType = [
                  ptChar, // TEdit
                  ptString,    // TEdit
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
  'Char', 'String', 'Integer', 'Text', 'Boolean', 'Choice', 'Action', 'List', 'Properties');

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
 if PropertyType in [ptList, ptChoice] then
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
var
 i: Integer;
begin
  if Source is TddProperty then
  begin
   f_Alias:= TddProperty(Source).Alias;
   f_Caption:= TddProperty(Source).Caption;
   f_PropertyType:= TddProperty(Source).PropertyType;
   f_Value:= TddProperty(Source).Value;
   f_Visible:= TddProperty(Source).Visible;
   f_ID:= TddProperty(Source).ID; // ?
   if PropertyType in [ptList, ptChoice] then
   begin
    ListItem:= TddProperty(Source).ListItem;
    // SubItems
    for i := 0 to TddProperty(Source).f_ListItems.Count-1 do
     f_ListItems.Add(TddProperty(Source).f_ListItems[i]);
   end;
  end
  else
   inherited;
end;

constructor TddProperty.Create;
begin
  inherited Create;
  if (aAlias = '') or (aAlias[1] in ['0'..'9']) then
   raise Exception.Create('Alias �� ������ ���� ������ ��� ���������� � �����');
  Alias:= aAlias;
  Caption:= aCaption;
  PropertyType:= aType;
  Visible:= aVisible;
  f_ListItems:= TObjectList<TProperties>.Create;
end;


constructor TddProperty.MakeButton(const aAlias, aCaption: String;
  aEvent: TNotifyEvent; aVisible: Boolean);
begin
 Create(aAlias, aCaption, ptAction, aVisible);
 Event:= aEvent;
end;

constructor TddProperty.MakeChoice(const aAlias, aCaption: String;
  aChoiceDef: TddChoiceLink; aVisible: Boolean);
begin
 Create(aAlias, aCaption, ptChoice, aVisible);
 SetChoice(aChoiceDef);
end;

constructor TddProperty.MakeClone(aSource: TddProperty);
begin
 Create(aSource.Alias, aSource.Caption, aSource.PropertyType, aSource.Visible);
 Assign(aSource);
end;


constructor TddProperty.MakeList(const aAlias, aCaption: String;
  aListDef: TddPropertyLink; aVisible: Boolean);
begin
 Create(aAlias, aCaption, ptList, aVisible);
 SetItem(aListDef);
end;

{
********************************* TProperties **********************************
}
constructor TProperties.Create;
begin
 F_Items := TObjectList<TddProperty>.Create(True);
end;

function TProperties.Add(aProp: TddProperty): TddProperty;
begin
 Result:= aProp;
 Result.ID:= f_Items.Add(aProp) + propBase;
 Result.OnChange:= InnerOnChange;
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
    TddPropertyType; aVisible: Boolean = True);
begin
 // ��������� ���������� Alias - �� ������ ���������� � �����
 Add(TddProperty.Create(aAlias, aCaption, aType, aVisible));
end;

procedure TProperties.DefineButton(const aAlias, aCaption: String;
  aEvent: TNotifyEvent);
begin
 Define(aAlias, aCaption, ptAction, True);
 AliasItems[aAlias].Event:= aEvent;
end;

procedure TProperties.DefineChoice(const aAlias, aCaption: String;
  aVisible: Boolean; aItem: TddChoiceLink);
var
 l_P: TddProperty;
begin
 Define(aAlias, aCaption, ptChoice, aVisible);
 l_P:= AliasItems[aAlias];
 l_P.SetChoice(aItem);
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

function TProperties.GetHints(Alias: String): String;
begin
 Result:= AliasItems[Alias].Hint;
end;

procedure TProperties.InnerOnChange(Sender: TObject);
begin
 f_Changed:= True;
 if Assigned(fOnChange) then
  fOnChange(Self);
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
   f_Items.Clear;
   LoadHeader(Element);
   LoadValues(Element);
 end;
end;


procedure TProperties.LoadHeader(Element: IXMLNode);
begin
  // �������� ��������� �������� � �������� ���������
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


  function lp_SetValue(aAlias: String): Variant;
  var
   l_Val: Variant;
  begin
    l_Val:= l_Item[aAlias];
    if not VarIsNull(l_Val) then
     Result:= l_Val
     else
      Result:= '';
  end;
begin
 // �������� �������� ���������
  for i:= 0 to Pred(Element.ChildNodes.Count) do
  begin

    l_Item:= Element.ChildNodes.Nodes[i];
    if AnsiSameText(l_Item.NodeName, 'Property') then
    begin
      l_Alias:= lp_SetValue('Alias');
      l_Caption:= lp_SetValue('Caption');

      if not TryStrToBool(l_Item['Visible'], l_Visible) then
       l_Visible:= True; // ��� False
      l_Type:= String2PropertyType(l_Item['Type']);
      if l_Type in propOrdinals then
      begin
       Define(l_Alias, l_Caption, l_Type, l_Visible);
       try
       Values[l_Alias]:= l_Item['Value'];
       except
       Values[l_Alias]:= l_Item['Value'];
       end;
      end
      else
      if l_Type = ptText then
      begin

        Define(l_Alias, l_Caption, l_Type, l_Visible);
        l_E:= l_Item.ChildNodes.FindNode('Value').ChildNodes.FindNode('Texts');
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
      if l_Type in [ptList, ptChoice] then
      begin
       if l_Type = ptList then
        DefineList(l_Alias, l_Caption, l_Visible)
       else
        DefineChoice(l_Alias, l_Caption, l_Visible);
       // ��������� �������� �������� ������
       l_E:= l_Item.ChildNodes.FindNode('Properties');
       l_SubItem:= TProperties.Create;
       try
        l_SubItem.LoadFromXML(l_E);
        AliasItems[l_Alias].ListItem:= l_SubItem;
       finally
        FreeAndNil(l_SubItem);
       end;
       // ��������� ��� ������
       l_E:= l_Item.ChildNodes.FindNode('Value');
       for j := 0 to l_E.ChildNodes.Count-1 do
       begin
         if AnsiSameText(l_E.ChildNodes.Get(j).NodeName, 'Item') then
         begin
          // � ��������, ����� ��������� ������ Value - ��� ��������� � ��� ��� ����
          k:= AliasItems[l_Alias].AddItem;
          l_SubItem:= TProperties.Create; // ����� ������� �� ������
          try
           l_SubItem.LoadFromXML(l_E.ChildNodes.Get(j));
           AliasItems[l_Alias].ListItems[k].Assign(l_SubItem);
          finally
           FreeAndNil(l_SubItem);
          end;
         end; // Item
       end; // for j
       if l_Type = ptChoice then
       begin
         // ��������� �������� ItemIndex
       end;
      end; // ptList
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
   raise Exception.CreateFmt('����������� ��������� �������� %s', [Alias]);
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
 // ��������� ��������� ��������
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
 // ���������� �������� ���������
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
      ptChar,
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

      ptAction:;    // TButton
      ptList, // TListBox
      ptChoice: // TComboBox
       begin
        // ���������� �������� ���������� ��������
        ListItem.SaveToXML(l_Item.AddChild('Properties'));
        // ������ ��������� ��� �������� ������
        for j := 0 to ListItemsCount-1 do
         ListItems[j].SaveToXML(l_Value.AddChild('Item'));
        // ��� ���������� ����� �������� ���������� ItemIndex
       end; // ptList
      ptProperties: ; // TScrollBox (��������� ��������)
     end; // case
   end; // with Items[i]
  end; // for i
end;

procedure TProperties.SetHints(Alias: String; const Value: String);
begin
 AliasItems[Alias].Hint:= Value;
end;

procedure TProperties.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
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
 if PropertyType in [ptList, ptChoice] then
  Result:= TProperties(f_ListItems[index])
end;

function TddProperty.pm_GetItemsCount: Integer;
begin
 if PropertyType in [ptList, ptChoice] then
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
 if (PropertyType in [ptList, ptChoice]) then
 begin
  if f_ListItem = nil then
   f_ListItem:= TProperties.Create;
  f_ListItem.Assign(Value);
 end
 else
  raise Exception.Create('�������� �� ptList'); // �������� ������
end;

procedure TddProperty.pm_SetPropertyType(const Value: TddPropertyType);
begin
  f_PropertyType := Value;
end;

procedure TddProperty.SetChoice(aChoiceDef: TddChoiceLink);
var
 l_Cur, l_Next: TddChoiceLink;
 l_Index: Integer;
begin
 // ������������ ������� � ��������� ������. ����� ������������ ���������� ������
 FreeAndNil(f_ListItem);
 f_ListItem:= TProperties.Create;
 f_ListItem.Define('id', 'id', ptInteger, False);
 f_ListItem.Define('caption', 'caption', ptString, False);
 f_ListItems.Clear;
 l_Next:= aChoiceDef;
 while l_Next <> nil do
 begin
  l_Index:= AddItem;
  ListItems[l_Index].Values['id']:= l_Next.ID;
  ListItems[l_Index].Values['caption']:= l_Next.Text;
  l_Cur:= l_Next;
  l_Next:= l_Cur.Next;
  FreeAndNil(l_Cur);
 end;
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
   f_ListItem.Define('Caption', '��������', ptString);
 end; // f_ListItems
end;

{ TddChoiceLink }

constructor TddChoiceLink.Create(aID: Integer; aText: String;
  aNext: TddChoiceLink);
begin
 inherited Create;
 fID:= aID;
 fText:= aText;
 fNext:= aNext;
end;

procedure TddChoiceLink.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TddChoiceLink.SetNext(const Value: TddChoiceLink);
begin
  FNext := Value;
end;

procedure TddChoiceLink.SetText(const Value: String);
begin
  FText := Value;
end;

end.
