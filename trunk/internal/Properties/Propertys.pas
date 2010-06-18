unit Propertys;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
 TPropertyType = (ptInteger, ptString, ptText, ptBoolean, ptCaption, ptButton, ptTextWitButton,
                  ptActions);

  TProperty = class(TCollectionItem)
  private
    f_Alias: string;
    f_Caption: TCaption;
    f_PropertyType: TPropertyType;
    f_Value: Variant;
    f_Visible: Boolean;
  public
    procedure Assign(Source: TPersistent); override;
    procedure Define(const aAlias: String; const aCaption: TCaption; aType: TPropertyType; aValue:
        Variant; aVisible: Boolean = True);
    property Alias: string read f_Alias write f_Alias;
    property Caption: TCaption read f_Caption write f_Caption;
    property PropertyType: TPropertyType read f_PropertyType write
        f_PropertyType;
    property Value: Variant read f_Value write f_Value;
    property Visible: Boolean read f_Visible write f_Visible;
  end;

  TProperties = class(TCollection)
  private
    function FindProperty(aAlias: String): TProperty;
    function pm_GetItems(Index: Integer): TProperty;
    procedure pm_SetItems(Index: Integer; aValue: TProperty);
  public
    function Add: TProperty;
    property Items[Index: Integer]: TProperty read pm_GetItems write pm_SetItems; default;
  end;

  TPropertyObject = class(TPersistent)
  private
    f_Changed: Boolean;
    f_Properties: TProperties;
    function pm_GetValues(Alias: String): Variant;
    function pm_GetVisible(Alias: String): Boolean;
    procedure pm_SetValues(Alias: String; const Value: Variant);
    procedure pm_SetVisible(Alias: String; const Value: Boolean);
  protected
  public
   constructor Create;
   destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
   procedure Define(const aAlias: String; const aCaption: TCaption; aType: TPropertyType; aValue:
       Variant; aVisible: Boolean = True);
    property Changed: Boolean read f_Changed write f_Changed;
    property Properties: TProperties read f_Properties;
    property Values[Alias: String]: Variant read pm_GetValues write pm_SetValues;
    property Visible[Alias: String]: Boolean read pm_GetVisible write pm_SetVisible;
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
   f_Visible:= TProperty(Source).Visible;
  end
  else
   inherited;
end;

procedure TProperty.Define(const aAlias: String; const aCaption: TCaption; aType: TPropertyType;
    aValue: Variant; aVisible: Boolean = True);
begin
 Alias:= aAlias;
 Caption:= aCaption;
 PropertyType:= aType;
 Value:= aValue;
 Visible:= aVisible;
end;

{
********************************* TProperties **********************************
}
function TProperties.Add: TProperty;
begin
 Result:= TProperty(inherited Add);
end;

function TProperties.FindProperty(aAlias: String): TProperty;
var
  i: Integer;
begin
  Result:= nil;
  for i:= 0 to Pred(Count) do
   if AnsiSameText(TProperty(Items[i]).Alias, aAlias) then
   begin
    Result:= TProperty(Items[i]);
    break
   end;
 if Result = nil then
  raise Exception.CreateFmt('Отсутствует свойство %s', [aAlias]);
end;

function TProperties.pm_GetItems(Index: Integer): TProperty;
begin
  Result:= inherited Items[Index] as TProperty;
end;

procedure TProperties.pm_SetItems(Index: Integer; aValue: TProperty);
var
  l_Prop: TProperty;
begin
  l_Prop:= Items[Index];
  l_Prop.Assign(aValue);
end;



{ TPropertyObject }

constructor TPropertyObject.Create;
begin
 inherited;
 f_Properties:= TProperties.Create(TProperty);
 f_Changed:= False;
end;

procedure TPropertyObject.Define(const aAlias: String; const aCaption: TCaption; aType:
    TPropertyType; aValue: Variant; aVisible: Boolean = True);
begin
 TProperty(f_Properties.Add).Define(aAlias, aCaption, aType, aValue, aVisible);
end;

destructor TPropertyObject.Destroy;
begin
 FreeAndNil(f_Properties);
 inherited;
end;

procedure TPropertyObject.Assign(Source: TPersistent);
begin
  if Source is TPropertyObject then
   f_Properties.Assign(TPropertyObject(Source).Properties)
  else
   inherited;
end;

function TPropertyObject.pm_GetValues(Alias: String): Variant;
begin
 Result:= Properties.FindProperty(Alias).Value;
end;

function TPropertyObject.pm_GetVisible(Alias: String): Boolean;
begin
 Result := Properties.FindProperty(Alias).Visible;;
end;

procedure TPropertyObject.pm_SetValues(Alias: String; const Value: Variant);
begin
 Properties.FindProperty(Alias).Value:= Value;
 f_Changed:= True;
end;

procedure TPropertyObject.pm_SetVisible(Alias: String; const Value: Boolean);
begin
 Properties.FindProperty(Alias).Visible:= Value;
end;

end.
