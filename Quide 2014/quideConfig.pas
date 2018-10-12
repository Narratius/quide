unit quideConfig;

{ Конфигурация приложения }

interface

Uses
 Classes,
 Propertys;

type
 TquideConfig = class(TddProperties)
 public
   constructor Create(aOwner: TComponent); override;
   procedure LoadFromFile;
   procedure SaveToFile;
 end;

implementation

Uses
  PropertyUtils,
  XMLDoc, XMLIntf, Forms, SysUtils;

{ TquideConfig }

constructor TquideConfig.Create;
begin
  inherited Create(aOwner);
  DefineList('Generators', 'Генераторы', True,
        NewProperty('Caption', 'Название', ptString,
        NewProperty('Path', 'Файл генератора', ptString,
        nil)));
end;

procedure TquideConfig.LoadFromFile;
var
 l_Root: IXMLNode;
 l_Doc: IXMLDocument;
begin
 if FileExists(ChangeFileExt(Application.ExeName, '.cfg')) then
 begin
  l_Doc:= TXMLDocument.Create(nil);
  l_Doc.Options:= l_Doc.Options + [doNodeAutoIndent];
  l_Doc.Active:= True;
  l_Doc.LoadFromFile(ChangeFileExt(Application.ExeName, '.cfg'));
  l_Root:= l_Doc.ChildNodes.FindNode('Config');
  if l_Root <> nil then
    LoadFromXML(l_Root, False);
 end;
end;

procedure TquideConfig.SaveToFile;
var
 l_Node: IXMLNode;
 l_Doc: IXMLDocument;
 i: Integer;
begin
 l_Doc:= TXMLDocument.Create(nil);
 l_Doc.Options:= l_Doc.Options + [doNodeAutoIndent];
 l_Doc.Active:= True;
 l_Doc.Encoding:= 'UTF-8';//'Windows-1251';
 l_Node:= l_Doc.AddChild('Config');
 // Собственные атрибуты
 SaveToXML(l_Node, False);
 l_Doc.SaveToFile(ChangeFileExt(Application.ExeName, '.cfg'));
end;

end.
