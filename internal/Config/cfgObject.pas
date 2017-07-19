unit cfgObject;

interface

Uses
 Classes, Generics.Collections,
 Propertys;

type
 TcfgSection = class(TProperties)
 public
  constructor Create(const aCaption, aHint: String);
  private
    FHint: String;
    FCaption: String;
    procedure SetCaption(const Value: String);
    procedure SetHint(const Value: String);
 public
  property Caption: String read FCaption write SetCaption;
  property Hint: String read FHint write SetHint;
 end;


 TcfgObject = class
 private
  f_Sections: TObjectList<TcfgSection>;
 private
  function NewAlias: String;
  procedure CheckSection;
  function pm_GetParametes(aAlias: String): Variant;
  function pm_GetSectionCount: Integer;
  function pm_GetSections(Index: Integer): TcfgSection;
 public
  constructor Create;
  destructor Destroy; override;
  procedure OpenSection(const aCaption: String; const aHint: String = '');
  procedure CloseSection;
  procedure AddHeader(aCaption: String);
  procedure AddParams(aParams: TddPropertyLink);
  procedure LoadFromFile(const aFileName: String);
  procedure SaveToFile(const aFileName: String);
 public
  property Parameters[aAlias: String]: Variant
   read pm_GetParametes; default;
  property Sections[Index: Integer] : TcfgSection
   read pm_GetSections;
  property SectionCount: Integer
   read pm_GetSectionCount;
 end;

implementation

Uses
 SysUtils, XML.XMLIntf, XML.XMLDoc, Variants,
 PropertyUtils;

{ TcfgObject }

procedure TcfgObject.AddHeader(aCaption: String);
begin
 CheckSection;
 f_Sections.Last.Define(NewAlias, aCaption, ptNothing);
end;

procedure TcfgObject.AddParams(aParams: TddPropertyLink);
begin
 CheckSection;
 // Что будет с Caption и Hint?
 f_Sections.Last.Assign(LinkToProperties(aParams));
end;

procedure TcfgObject.CheckSection;
begin
 if f_Sections.Count = 0 then
  OpenSection('Конфигурация', 'Настройки приложения');
end;

procedure TcfgObject.CloseSection;
begin
 // ?
end;

constructor TcfgObject.Create;
begin
 inherited;
 f_Sections:= TObjectList<TcfgSection>.Create(True);
end;

destructor TcfgObject.Destroy;
begin
 FreeAndNil(f_Sections);
 inherited;
end;

procedure TcfgObject.LoadFromFile(const aFileName: String);
var
 l_XML: IXMLDocument;
 l_Node: IXMLNode;
 i: Integer;
begin
 if FileExists(aFileName) then
 begin
   l_XML:= TXMLDocument.Create(nil);
   try
     l_XML.LoadFromFile(aFileName);
     l_Node:= l_XML.ChildNodes.FindNode('Configuration');
     // Находим нужный узел и загружаем его
     for I := 0 to f_Sections.Count-1 do
      f_Sections[i].LoadFromXML(l_Node.ChildNodes.FindNode(f_Sections[i].Caption), False);
   finally
     l_XML:= nil;
   end;
 end;

end;

function TcfgObject.NewAlias: String;
begin
 Result:= 'Alias' + IntToStr(f_Sections.Count + 1);
end;

procedure TcfgObject.OpenSection(const aCaption: String; const aHint: String = '');
begin
 f_Sections.Add(TcfgSection.Create(aCaption, aHint));
end;

function TcfgObject.pm_GetParametes(aAlias: String): Variant;
var
 i: Integer;
 l_Item: TddProperty;
begin
 Result:= Unassigned;
 for I := 0 to f_Sections.Count-1 do
 begin
  l_Item:= f_Sections[i].AliasItems[aAlias];
  if l_Item <> nil then
  begin
    Result:= l_Item.Value;
    break;
  end;
 end;
end;

function TcfgObject.pm_GetSectionCount: Integer;
begin
 Result:= f_Sections.Count;
end;

function TcfgObject.pm_GetSections(Index: Integer): TcfgSection;
begin
 Result:= f_Sections[Index];
end;

procedure TcfgObject.SaveToFile(const aFileName: String);
var
 l_XML: IXMLDocument;
 i: Integer;
 l_Node: IXMLNode;
begin
 l_XML:= TXMLDocument.Create(nil);
 try
   l_XML.Active:= True;
   l_Node:= l_XML.AddChild('Configuration');
   for I := 0 to f_Sections.Count-1 do
    f_Sections[i].SaveToXML(l_Node.AddChild(f_Sections[i].Caption), False);
   l_XML.SaveToFile(aFileName);
 finally
   l_XML:= nil;
 end;

end;

{ TcfgSection }

constructor TcfgSection.Create(const aCaption, aHint: String);
begin
  inherited Create;
  FCaption:= aCaption;
  FHint:= aHint;
end;

procedure TcfgSection.SetCaption(const Value: String);
begin
  FCaption := Value;
end;

procedure TcfgSection.SetHint(const Value: String);
begin
  FHint := Value;
end;

end.
