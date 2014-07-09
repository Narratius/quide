unit PropertyUtils;

interface

Uses
 Propertys;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink;

function NewListProperty(const aAlias, aCaption: String; aListDef: TddPropertyLink; aNext: TddPropertyLink = nil): TddPropertyLink;

function NewChoiceProperty(const aAlias, aCaption: String; aChoiceDef: TddChoiceLink; aNext: TddPropertyLink = nil): TddPropertyLink;

function NewChoice(aID: Integer; aCaption: String; aNext: TddChoiceLink = nil): TddChoiceLink;

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

function NewListProperty(const aAlias, aCaption: String; aListDef: TddPropertyLink; aNext: TddPropertyLink = nil): TddPropertyLink;
var
 l_I: TddProperty;
begin
 l_I:= TddProperty.MakeList(aAlias, aCaption, aListDef);
 Result:= TddPropertyLink.Create(l_I, aNext);
end;

function NewChoice(aID: Integer; aCaption: String; aNext: TddChoiceLink = nil): TddChoiceLink;
begin
 Result:= TddChoiceLink.Create(aID, aCaption, aNext);
end;

function NewChoiceProperty(const aAlias, aCaption: String; aChoiceDef: TddChoiceLink; aNext: TddPropertyLink = nil): TddPropertyLink;
var
 l_I: TddProperty;
begin
 l_I:= TddProperty.MakeChoice(aAlias, aCaption, aChoiceDef);
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
