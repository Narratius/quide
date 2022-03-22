unit QuideClassesManager;

interface

Uses
  System.Generics.Collections, Xml.XMLIntf,
  QuideClasses, QuideClassesControls;

type
  TquideClassManager =  class(TObject)
  private
    FClasses: TDictionary<string, TquideStoryClass>;
    FControls: TDictionary<string, TquideControlClass>;
  public
    constructor Create;
    procedure RegisterQuideClass(aClassRef: TquideStoryClass; aControlRef: TquideControlClass);
  public
    destructor Destroy; override;
    function GetControlClass(aItemClass: TquideCustomStoryItem): TquideControlClass;
    function GetItemClass(const aClassName: string): TquideStoryClass;
    function MakeStoryItem(aNode: IXMLNode): TquideCustomStoryItem;
  end;

function QuideClassManager: TquideClassManager;

implementation

uses
  System.SysUtils, System.Variants;

var
  gClassManager: TquideClassManager;

function QuideClassManager: TquideClassManager;
begin
  Result := gClassManager;
end;


constructor TquideClassManager.Create;
begin
  inherited;
  FClasses := TDictionary<string, TquideStoryClass>.Create();
  FControls := TDictionary<string, TquideControlClass>.Create();
end;

destructor TquideClassManager.Destroy;
begin
  FControls.Free;
  FClasses.Free;
  inherited Destroy;
end;

function TquideClassManager.GetControlClass(aItemClass: TquideCustomStoryItem): TquideControlClass;
begin
  if not FControls.TryGetValue(aItemClass.ClassName, Result) then
    Result:= TquideCustomControl;
end;

function TquideClassManager.GetItemClass(const aClassName: string): TquideStoryClass;
begin
  if not FClasses.TryGetValue(aClassName, Result) then
    Result:= TquideCustomStoryItem;
end;

function TquideClassManager.MakeStoryItem(aNode: IXMLNode): TquideCustomStoryItem;
var
  l_Class: TquideStoryClass;
  l_ClassName: string;
begin
  Result:= nil;
  l_ClassName:= VarToStrDef(aNode.Attributes['ClassName'], '');
  l_Class:= GetItemClass(l_ClassName);
  if Assigned(l_Class) then
    Result := l_Class.Create(nil, '', '');
end;

procedure TquideClassManager.RegisterQuideClass(aClassRef: TquideStoryClass; aControlRef: TquideControlClass);
begin
  FClasses.Add(aClassRef.ClassName, aClassRef);
  FControls.Add(aClassref.ClassName, aControlRef);
end;


initialization
  gClassManager:= TquideClassManager.Create;
  with gClassManager do
  begin
    RegisterQuideClass(TquideCustomStoryItem, TquideCustomControl);
    RegisterQuideClass(TquideStory, TquideStoryControl);
    RegisterQuideClass(TquideChapter, TquideChapterControl);
    RegisterQuideClass(TquideStoryLocation, TquideLocationControl);
    RegisterQuideClass(TquideParagraph, TquideParagraphControl);
    RegisterQuideClass(TquideTextStoryItem, TquideTextControl);
    RegisterQuideClass(TquideConditionStoryItem, TquideConditionControl);
    RegisterQuideClass(TquideCustomStoryBlock, nil);
    RegisterQuideClass(TquideCustomTransitionStoryItem, nil);
    RegisterQuideClass(TquideLogicStoryItem, TquideLogicControl);
    RegisterQuideClass(TquideJumpStoryItem, nil);
    RegisterQuideClass(TquideEntityStoryItem, nil);
    RegisterQuideClass(TquideStoryAction, TquideActionControl);
  end;
finalization
  FreeAndNil(gClassManager);
end.
