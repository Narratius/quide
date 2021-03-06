unit quideSteps;

interface

uses
 Classes, Generics.Collections, XML.XMLIntf,
 quideObject, quideLocations;

type
  //1 ����� ��������
  TquideChapter = class(TquideObject)
  private
    f_Locations: TObjectList<TquideLocation>;
    function pm_GetLocations(Index: Integer): TquideLocation;
    function pm_GetLocationsCount: Integer;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    function AddLocation: TquideLocation;
    procedure Delete(Index: Integer); overload;
    procedure Delete(Loc: TquideLocation); overload;
    procedure LoadFromXML(Element: IXMLNode);
    procedure SaveToXML(Element: IXMLNode);
    //1 ���������� ������� � ��������� ������ ��� nil
    function IsValidLocation(const aCaption: String): TquideLocation;
    function FindLocationByGraph(aGraphID: Cardinal): TquideLocation;
    //1 ������ ������� ���� ��������
    property Locations[Index: Integer]: TquideLocation read pm_GetLocations;
        default;
    property LocationsCount: Integer read pm_GetLocationsCount;
  end;


implementation

Uses
  SysUtils, Propertys;

{
******************************** TquideChapter *********************************
}
constructor TquideChapter.Create;
begin
  inherited Create(aOwner);
  f_Locations := TObjectList<TquideLocation>.Create();
  Define('Start', '������ ����', ptString)
end;

procedure TquideChapter.Delete(Loc: TquideLocation);
begin
  Delete(f_Locations.IndexOf(Loc))
end;

destructor TquideChapter.Destroy;
begin
  FreeAndNil(f_Locations);
  inherited Destroy;
end;

function TquideChapter.FindLocationByGraph(aGraphID: Cardinal): TquideLocation;
var
  i: Integer;
begin
 Result:= nil;
 for i:= 0 to Pred(LocationsCount) do
  if Locations[i].Values['GraphObject'] = aGraphID then
  begin
   Result:= Locations[i];
   break;
  end;
end;

function TquideChapter.AddLocation: TquideLocation;
begin
 Result:= TquideLocation.Create(nil);
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
