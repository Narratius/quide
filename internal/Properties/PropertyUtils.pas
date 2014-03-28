unit PropertyUtils;

interface

Uses
 Propertys;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TPropertyType; aNext: TPropertyLink = nil): TPropertyLink;

function ShowPropDialog(const aCaption: String; aProperties: TProperties): Boolean;

implementation

Uses
 Forms, UITypes,
 PropertiesDialog;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TPropertyType; aNext: TPropertyLink = nil): TPropertyLink;
var
 l_I: TProperty;
begin
 l_I:= TProperty.Create(aAlias, aCaption, aPropertyType);
 Result:= TPropertyLink.Create(l_I, aNext);
end;

function ShowPropDialog(const aCaption: String; aProperties: TProperties): Boolean;
begin
 with TPropDialog.Create(Application) do
 try
  Caption:= aCaption;
  Result:= Execute(aProperties);
 finally
  Free;
 end;
end;

end.
