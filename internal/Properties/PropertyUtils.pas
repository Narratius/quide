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

function LinkToProperties(aLink: TddPropertyLink): TddProperties;

function ShowPropDialog(const aCaption: String; aProperties: TddProperties;
    aLabelTop: Boolean = False): Boolean; overload;

function ShowPropDialog(const aCaption: String; aProperty: TddProperty;
    aLabelTop: Boolean = False): Boolean; overload;

procedure SaveToFile(const aFileName: String; aProperties: TddProperties; aSaveStruct: Boolean); overload;

procedure LoadFromFile(const aFileName: String; aProperties: TddProperties; aLoadStruct: Boolean); overload;

procedure SaveToFile(const aFileName: String; aProperties: TddProperties); overload;

procedure LoadFromFile(const aFileName: String; aProperties: TddProperties); overload;


implementation

Uses
 Forms, UITypes, SysUtils, Classes,
 XMLDoc, XMLIntf,
 PropertiesDialog;

function NewProperty(const aAlias, aCaption: String; aPropertyType: TddPropertyType; aNext: TddPropertyLink = nil): TddPropertyLink;
var
 l_I: TddProperty;
begin
 l_I:= TddProperty.Create(nil);
 l_I.Define(aAlias, aCaption, aPropertyType, True);
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

function LinkToProperties(aLink: TddPropertyLink): TddProperties;
var
 l_Item: TddPropertyLink;
 l_Next: TddPropertyLink;
begin
 Result:= TddProperties.Create(nil);
 l_Next:= aLink;
 while l_Next <> nil do
 begin
   Result.AddProp(l_Next.Item);
   l_Item:= l_Next;
   l_Next:= l_Item.Next;
   FreeAndNil(l_Item);
 end;
end;




function ShowPropDialog(const aCaption: String; aProperties: TddProperties;
    aLabelTop: Boolean = False): Boolean;
begin
 with TPropDialog.Create(Application) do
 try
  LabelTop:= aLabelTop;
  Caption:= aCaption;
  Result:= Execute(aProperties);
 finally
  Free;
 end;
end;


function ShowPropDialog(const aCaption: String; aProperty: TddProperty; aLabelTop: Boolean = False): Boolean;
var
 l_Prop: TddProperties;
 l_P: TddProperty;
begin
 { TODO : Нужно клонировать aProperty }
 l_Prop:= TddProperties.Create(nil);
 try
  l_Prop.AddProp(aProperty);
  with TPropDialog.Create(Application) do
  try
   LabelTop:= aLabelTop;
   Caption:= aCaption;
   Result:= Execute(l_Prop);
  finally
   Free;
  end;
 finally
  FreeAndNil(l_Prop);
 end;
end;



procedure SaveToFile(const aFileName: String; aProperties: TddProperties; aSaveStruct: Boolean);
var
 l_XML: IXMLDocument;
begin
  l_XML:= TXMLDocument.Create(nil);
  try
   l_XML.Options:= l_XML.Options + [doNodeAutoIndent];
   l_XML.Active:= True;
   l_XML.Encoding:= 'UTF-8';//'Windows-1251';
   aProperties.SaveToXML(l_XML.AddChild('Properties'), aSaveStruct);
   l_XML.SaveToFile(aFileName);
  finally
    l_XML:= nil;
  end;
end;

procedure LoadFromFile(const aFileName: String; aProperties: TddProperties; aLoadStruct: Boolean);
var
 l_XML: IXMLDocument;
 l_Node: IXMLNode;
begin
  if FileExists(aFileName) then
  begin
    l_XML:= TXMLDocument.Create(nil);
    try
     l_XML.Options:= l_XML.Options + [doNodeAutoIndent];
     l_XML.Active:= True;
     l_XML.Encoding:= 'UTF-8';//'Windows-1251';
     l_XML.LoadFromFile(aFileName);
     try
      aProperties.LoadFromXML(l_XML.ChildNodes.FindNode('Properties'), aLoadStruct);
     except
      {$IFDEF Debug}
      // вывести в лог
      {$ENDIF}
     end;
    finally
      l_XML:= nil;
    end;
  end;
end;


procedure SaveToFile(const aFileName: String; aProperties: TddProperties);
var
  FileStream: TFileStream;
  MemStream: TMemoryStream;
begin
  // test
  FileStream := TFileStream.Create(ChangeFileExt(aFileName, '.bin'), fmCreate or fmShareDenyWrite);
  try
   FileStream.WriteComponent(aProperties);
  finally
    FileStream.Free;
  end;
  // test
  FileStream := TFileStream.Create(aFileName, fmCreate or fmShareDenyWrite);
  try
    MemStream := TMemoryStream.Create;
    try
      MemStream.WriteComponent(aProperties);
      MemStream.Position := 0;
      ObjectBinaryToText(MemStream, FileStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure LoadFromFile(const aFileName: String; aProperties: TddProperties);
var
  FileStream: TFileStream;
  MemStream: TMemoryStream;
begin
  FileStream := TFileStream.Create(aFileName, 0);
  MemStream := TMemoryStream.Create;
  try
    ObjectTextToBinary(FileStream, MemStream);
    MemStream.Position := 0;
    MemStream.ReadComponent(aProperties);
  finally
    MemStream.Free;
    FileStream.Free;
  end;
end;

end.
