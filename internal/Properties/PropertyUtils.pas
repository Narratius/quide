unit PropertyUtils;

interface

Uses
 Propertys;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink;

function ShowPropDialog(const aCaption: String; aProperties: TProperties): Boolean;

implementation

Uses
 Forms, UITypes,
 PropertiesDialog;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink;
var
 l_I: TddProperty;
begin
 l_I:= TddProperty.Create(aAlias, aCaption, aPropertyType);
 Result:= TddPropertyLink.Create(l_I, aNext);
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
