unit quideSteps;

interface

uses
 Generics.Collections, XML.XMLIntf,
 quideObject, quideLocations;

type
  //1 Глава сценария
  TquideChapter = class(TquideObject)
  private
    f_Locations: TObjectList<TquideLocation>;
    function pm_GetLocations(Index: Integer): TquideLocation;
    function pm_GetLocationsCount: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddLocation: TquideLocation;
    procedure Delete(Index: Integer);
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    //1 Возвращает локацию с указанным именем или nil
    function IsValidLocation(const aCaption: String): TquideLocation;
    //1 Список локаций шага сценария
    property Locations[Index: Integer]: TquideLocation read pm_GetLocations;
        default;
    property LocationsCount: Integer read pm_GetLocationsCount;
  end;


implementation

Uses
  SysUtils;

{
******************************** TquideChapter *********************************
}
constructor TquideChapter.Create;
begin
  inherited Create;
  f_Locations := TObjectList<TquideLocation>.Create();
end;

destructor TquideChapter.Destroy;
begin
  FreeAndNil(f_Locations);
  inherited Destroy;
end;

function TquideChapter.AddLocation: TquideLocation;
begin
 Result:= TquideLocation.Create;
 f_Locations.Add(Result);
end;

procedure TquideChapter.Delete(Index: Integer);
begin
 f_Locations.Delete(Index);
end;

function TquideChapter.IsValidLocation(const aCaption: String): TquideLocation;
var
  i: Integer;
begin
 Result:= nil;
 for i:= 0 to Pred(LocationsCount) do
  if AnsiSameText(Locations[i].Caption, aCaption) then
  begin
   Result:= Locations[i];
   break;
  end;
end;

procedure TquideChapter.LoadFromXML(Element: IXMLNode);
var
 l_Node,
 l_XMLLoc: IXMLNode;
 i: Integer;
 l_Location: TquideLocation;
begin
 inherited LoadFromXML(Element, False);
 l_Node:= Element.ChildNodes.FindNode('Locations');
 if l_Node <> nil then
  for I := 0 to l_Node.ChildNodes.Count-1 do
  begin
    l_XMLLoc:= l_Node.ChildNodes.Get(i);
    l_Location:= AddLocation;
    l_Location.LoadFromXML(l_XMLLoc);

  end;
end;

function TquideChapter.pm_GetLocations(Index: Integer): TquideLocation;
begin
 Result:= TquideLocation(f_Locations[index]);
end;

function TquideChapter.pm_GetLocationsCount: Integer;
begin
 Result:= f_Locations.Count;
end;



procedure TquideChapter.SaveToXML(Element: IXMLNode);
var
 l_Node: IXMLNode;
 i: Integer;
begin
 inherited SaveToXML(Element, False);
 l_Node:= Element.AddChild('Locations');
 for i:= 0 to LocationsCount-1 do
  Locations[i].SaveToXML(l_Node.AddChild('Location'));
end;

end.
