unit PropertyUtils;

interface

Uses
 Propertys;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TPropertyType; aNext: TPropertyLink = nil): TPropertyLink;

implementation

function NewProperty(const aAlias, aCaption: String; aPropertyType: TPropertyType; aNext: TPropertyLink = nil): TPropertyLink;
var
 l_I: TProperty;
begin
 l_I:= TProperty.Create;
 l_I.Alias:= aAlias;
 l_I.Caption:= aCaption;
 l_I.PropertyType:= aPropertyType;
 Result:= TPropertyLink.Create(l_I, aNext);
end;

end.
