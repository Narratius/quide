unit Propertys;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
 TPropertyType = (ptString, ptInteger, ptText, ptBoolean);
  TProperty = class(TCollectionItem)
  private
    f_Alias: string;
    f_Caption: TCaption;
    f_PropertyType: TPropertyType;
    f_Value: Variant;
  public
    procedure Assign(Source: TPersistent); override;
    property Alias: string read f_Alias write f_Alias;
    property Caption: TCaption read f_Caption write f_Caption;
    property PropertyType: TPropertyType read f_PropertyType write
        f_PropertyType;
    property Value: Variant read f_Value write f_Value;
  end;

  TProperties = class(TCollection)
  private
    f_Changed: Boolean;
    function FindProperty(aAlias: String): TProperty;
    function pm_GetItems(Alias: String): TProperty;
    function pm_GetValues(Alias: String): string;
    procedure pm_SetChanged(const Value: Boolean);
    procedure pm_SetItems(Alias: String; aValue: TProperty);
    procedure pm_SetValues(Alias: String; const Value: string);
  public
    procedure Define(const aAlias, aCaption: String; aType: TPropertyType);
    property Changed: Boolean read f_Changed write pm_SetChanged;
    property Items[Alias: String]: TProperty read pm_GetItems write pm_SetItems;
        default;
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

procedure TProperties.Define(const aAlias, aCaption: String; aType: TPropertyType);
begin
 // TODO -cMM: TProperty.Define необходимо написать реализацию
end;

{
********************************* TProperties **********************************
}
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

function TProperties.pm_GetItems(Alias: String): TProperty;
begin
  Result:= FindProperty(Alias);
end;

function TProperties.pm_GetValues(Alias: String): string;
begin
 // TODO -cMM: TProperties.pm_GetValues необходимо написать реализацию
 Result := '';
end;

procedure TProperties.pm_SetChanged(const Value: Boolean);
begin
 f_Changed := Value;
end;

procedure TProperties.pm_SetItems(Alias: String; aValue: TProperty);
var
  l_Prop: TProperty;
begin
  l_Prop:= FindProperty(Alias);
  if l_Prop = nil then
   l_Prop:= TProperty(Add);
  l_Prop.Assign(aValue);
end;

procedure TProperties.pm_SetValues(Alias: String; const Value: string);
begin
 // TODO -cMM: TProperties.pm_SetValues необходимо написать реализацию
 Changed:= True;
end;



end.
