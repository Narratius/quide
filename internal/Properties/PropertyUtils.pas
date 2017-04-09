unit PropertyUtils;

interface

Uses
 Propertys;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink; overload;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aDefValue: Variant; aNext: TddPropertyLink = nil): TddPropertyLink; overload;

function NewReadOnlyProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink;

function NewHiddenProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink;

function NewListProperty(const aAlias, aCaption: String; aListDef: TddPropertyLink; aNext: TddPropertyLink = nil): TddPropertyLink;

function NewChoiceProperty(const aAlias, aCaption: String; aChoiceDef: TddChoiceLink; aNext: TddPropertyLink = nil): TddPropertyLink;

function NewChoice(aID: Integer; aCaption: String; aNext: TddChoiceLink = nil): TddChoiceLink;

function LinkToProperties(aLink: TddPropertyLink): TProperties;

function ShowPropDialog(const aCaption: String; aProperties: TProperties): Boolean;

implementation

Uses
 Forms, UITypes, SysUtils,
 PropertiesDialog;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink;
var
 l_I: TddProperty;
begin
 l_I:= TddProperty.Create(aAlias, aCaption, aPropertyType);
 Result:= TddPropertyLink.Create(l_I, aNext);
end;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aDefValue: Variant; aNext: TddPropertyLink = nil): TddPropertyLink; overload;
begin
  Result:= NewProperty(aAlias, aCaption, aPropertyType, aNext);
  Result.Item.Value:= aDefValue;
end;

function NewReadOnlyProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink; overload;
begin
  Result:= NewProperty(aAlias, aCaption, aPropertyType, aNext);
  Result.Item.ReadOnly:= True;
end;

function NewHiddenProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink;
begin
  Result:= NewProperty(aAlias, aCaption, aPropertyType, aNext);
  Result.Item.Visible:= False;
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

function LinkToProperties(aLink: TddPropertyLink): TProperties;
var
 l_Item: TddPropertyLink;
 l_Next: TddPropertyLink;
begin
 Result:= TProperties.Create;
 l_Next:= aLink;
 while l_Next <> nil do
 begin
   Result.Add(l_Next.Item);
   l_Item:= l_Next;
   l_Next:= l_Item.Next;
   FreeAndNil(l_Item);
 end;
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
