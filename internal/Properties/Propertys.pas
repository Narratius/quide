unit Propertys;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
 TPropertyType = (ptString,    // TEdit
                  ptInteger,   // TEdit
                  ptText,      // TMemo
                  ptBoolean,   // TRadioGroup (TCombobox)
                  ptChoice,    // TComboBox
                  ptAction,    // TButton
                  ptProperties // TScrollBox (Вложенные свойства)
                  );

  TProperty = class(TCollectionItem)
  private
    f_Alias: string;
    f_Caption: TCaption;
    f_Event: TNotifyEvent;
    f_PropertyType: TPropertyType;
    f_Value: Variant;
    f_Visible: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
    property Alias: string read f_Alias write f_Alias;
    property Caption: TCaption read f_Caption write f_Caption;
    property PropertyType: TPropertyType read f_PropertyType write
        f_PropertyType;
    property Value: Variant read f_Value write f_Value;
    property Visible: Boolean read f_Visible write f_Visible;
    property Event: TNotifyEvent read f_Event write f_Event;
  end;


  TPropertyFunc = function (aItem: TProperty): Boolean of object;
  TProperties = class(TCollection)
  private
    f_Changed: Boolean;
    function FindProperty(aAlias: String): TProperty;
    function pm_GetAliasItems(Alias: String): TProperty;
    function pm_GetItems(Index: Integer): TProperty;
    function pm_GetValues(Alias: String): string;
    procedure pm_SetAliasItems(Alias: String; aValue: TProperty);
    procedure pm_SetChanged(const Value: Boolean);
    procedure pm_SetItems(Index: Integer; aValue: TProperty);
    procedure pm_SetValues(Alias: String; const Value: string);
  public
    constructor Create;
    function Add: TProperty;
    procedure Assign(Source: TPersistent); override;
    procedure Define(const aAlias, aCaption: String; aType: TPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
    procedure IterateAll(aFunc: TPropertyFunc);
    property AliasItems[Alias: String]: TProperty read pm_GetAliasItems write
        pm_SetAliasItems; default;
    property Changed: Boolean read f_Changed write pm_SetChanged;
    property Items[Index: Integer]: TProperty read pm_GetItems write
        pm_SetItems;
    property Values[Alias: String]: string read pm_GetValues write pm_SetValues;
  end;

function Property2Control(aProperty: TPropertyType): TControlClass;


implementation

uses
  fmx.Edit;

function Property2Control(aProperty: TPropertyType): TControlClass;
begin
  case aProperty of
   ptString: ;// TEdit;
   ptInteger:;   // TEdit
   ptText:;      // TMemo
   ptBoolean:;   // TRadioGroup (TCombobox)
   ptChoice:;    // TComboBox
   ptAction:;    // TButton
   ptProperties:; // TScrollBox (Вложенные свойства)
  end;
end;

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
 inherited Create(TProperty);
end;

function TProperties.Add: TProperty;
begin
 Result := TProperty(inherited Add);
end;

procedure TProperties.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TProperties then
  begin
    BeginUpdate;
    try
      // Replaces call to Clear to avoid BeginUpdate/try/finally/EndUpdate block
      while Count > 0 do
        Items[Count - 1].DisposeOf;

      for I := 0 to TProperties(Source).Count - 1 do
        Add.Assign(TProperties(Source).Items[I]);
    finally
      EndUpdate;
    end;
    Exit;
  end;
  inherited Assign(Source);
end;

procedure TProperties.Define(const aAlias, aCaption: String; aType:
    TPropertyType; aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
var
 l_P: TProperty;
begin
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
    if AnsiSameText(TProperty(inherited Items[i]).Alias, aAlias) then
    begin
     Result:= TProperty(inherited Items[i]);
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

function TProperties.pm_GetAliasItems(Alias: String): TProperty;
begin
  Result:= FindProperty(Alias);
end;

function TProperties.pm_GetItems(Index: Integer): TProperty;
begin
  Result:= TProperty(Inherited GetItem(Index));
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
   l_Prop:= Add;
  l_Prop.Assign(aValue);
end;

procedure TProperties.pm_SetChanged(const Value: Boolean);
begin
 f_Changed := Value;
end;

procedure TProperties.pm_SetItems(Index: Integer; aValue: TProperty);
begin
 inherited Items[Index]:= aValue;
end;

procedure TProperties.pm_SetValues(Alias: String; const Value: string);
begin
 // TODO -cMM: TProperties.pm_SetValues необходимо написать реализацию
 AliasItems[Alias].Value:= Value;
 Changed:= True;
end;



end.
