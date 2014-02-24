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
                  ptProperties // TScrollBox (Вложенные свойства)
                  );

  TProperty = class(TPersistent)
  private
    f_Alias: string;
    f_Caption: String;
    f_Event: TNotifyEvent;
    f_PropertyType: TPropertyType;
    f_Value: Variant;
    f_Visible: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
    property Alias: string read f_Alias write f_Alias;
    property Caption: String read f_Caption write f_Caption;
    property PropertyType: TPropertyType read f_PropertyType write
        f_PropertyType;
    property Value: Variant read f_Value write f_Value;
    property Visible: Boolean read f_Visible write f_Visible;
    property Event: TNotifyEvent read f_Event write f_Event;
  end;


  TPropertyFunc = function (aItem: TProperty): Boolean of object;
  TProperties = class(TInterfacedObject, IpropertyStore)
  private
    f_Changed: Boolean;
    f_Items: TObjectList;
    function FindProperty(aAlias: String): TProperty;
    function pm_GetAliasItems(Alias: String): TProperty;
    function pm_GetItems(Index: Integer): TProperty;
    function pm_GetValues(Alias: String): string;
    procedure pm_SetAliasItems(Alias: String; aValue: TProperty);
    procedure pm_SetChanged(const Value: Boolean);
    procedure pm_SetValues(Alias: String; const Value: string);
    function pm_GetCount: Integer;
  public
    constructor Create;
    function Add: TProperty;
    procedure Assign(Source: TProperties);
    procedure Define(const aAlias, aCaption: String; aType: TPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
    procedure IterateAll(aFunc: TPropertyFunc);
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    procedure TestProc;
    property AliasItems[Alias: String]: TProperty read pm_GetAliasItems write
        pm_SetAliasItems; default;
    property Changed: Boolean read f_Changed write pm_SetChanged;
    property Count: Integer read pm_GetCount;
    property Items[Index: Integer]: TProperty read pm_GetItems;
    property Values[Alias: String]: string read pm_GetValues write pm_SetValues;
  end;


implementation

{
********************************** TProperty ***********************************
}
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
 f_Items.Add(Result);
end;

procedure TProperties.Assign(Source: TProperties);
var
  I: Integer;
begin
  f_Items.Clear; //

  for I := 0 to TProperties(Source).Count - 1 do
   Add.Assign(TProperties(Source).Items[I]);
end;

procedure TProperties.Define(const aAlias, aCaption: String; aType:
    TPropertyType; aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
var
 l_P: TProperty;
begin
 // Проверить валидность Alias
 l_P:= Add;
 l_P.Alias:= aAlias;
 l_P.Caption:= aCaption;
 l_P.PropertyType:= aType;
 l_P.Visible:= aVisible;
 l_P.Event:= aEvent;
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

function TProperties.pm_GetValues(Alias: String): string;
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

procedure TProperties.pm_SetValues(Alias: String; const Value: string);
begin
 // TODO -cMM: TProperties.pm_SetValues необходимо написать реализацию
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

procedure TProperties.TestProc;
begin
 //
end;

end.
