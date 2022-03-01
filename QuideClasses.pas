Unit QuideClasses;

interface

uses
  System.Generics.Collections, Xml.XMLIntf, Xml.XMLDoc;

type
  TquideLogicOperation = (qloEqual, qloNotEqual, qloGreaterThan, qloLessThan);
  TquideCustomStoryItem = class;
  TquideStoryClass = class of TquideCustomStoryItem;


  TquideCustomStoryItem = class(TObject)
  private
    FAlias: string;
    FCaption: string;
    FParent: TquideCustomStoryItem;
    function TryGetProperty(aNode: IXMLNode; const aName: string): string;
  protected
    procedure DoAfterLoad; virtual;
    procedure DoLoad(aNode: IXMLNode); virtual;
    procedure DoSave(aNode: IXMLNode); virtual;
  public
    constructor Create(aParent: TquideCustomStoryItem; const aAlias, aCaption:
        string); virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure Load(aNode: IXMLNode);
    procedure Save(aNode: IXMLNode);
    function ToString: string; override;
    property Alias: string read FAlias write FAlias;
    property Caption: string read FCaption write FCaption;
    property Parent: TquideCustomStoryItem read FParent write FParent;
  end;

  TquideStoryItemList = TList<TquideCustomStoryItem>;

  TquideCustomStoryBlock = class(TquideCustomStoryItem)
  private
    FItems: TquideStoryItemList;
    function GetCount: Integer;
  protected
    function DefaultAlias(const aSuffix: string = 'item'): string;
    procedure DoLoad(aNode: IXMLNode); override;
    procedure DoSave(aNode: IXMLNode); override;
    procedure LoadItems(aNode: IXMLNode; aItems: TquideStoryItemList; const aName:
        string);
    procedure SaveItems(aNode: IXMLNode; aItems: TquideStoryItemList; const aName:
        string);
  public
    constructor Create(aParent: TquideCustomStoryItem; const aAlias, aCaption:
        string); override;
    destructor Destroy; override;
    procedure Add(aItem: TquideCustomStoryItem); virtual;
    procedure Clear; override;
    function FindByAlias(const AAlias: string): TquideCustomStoryItem;
    function HaveItem(aItem: TquideCustomStoryItem): Boolean; overload;
    function HaveItem(const aAlias: string): Boolean; overload;
    function ToString: string; override;
    property Count: Integer read GetCount;
    property Items: TquideStoryItemList read FItems;
  end;

  TquideConditionStoryItem = class(TquideCustomStoryItem)
  private
    FOperandA: TquideCustomStoryItem;
    FOperandAAlias: string;
    FOperandB: TquideCustomStoryItem;
    FOperandBAlias: string;
    FOperation: TquideLogicOperation;
    procedure SetOperandA(const Value: TquideCustomStoryItem);
    procedure SetOperandB(const Value: TquideCustomStoryItem);
    procedure SetOperation(const Value: TquideLogicOperation);
  protected
    procedure DoLoad(aNode: IXMLNode); override;
    procedure DoSave(aNode: IXMLNode); override;
  public
    function IsValid: Boolean;
    property OperandA: TquideCustomStoryItem read FOperandA write SetOperandA;
    property OperandB: TquideCustomStoryItem read FOperandB write SetOperandB;
    property Operation: TquideLogicOperation read FOperation write SetOperation;
  end;

  TquideCustomTransitionStoryItem = class(TquideCustomStoryItem)
  private
    FFromItem: TquideCustomStoryItem;
    FToItem: TquideCustomStoryItem;
  public
    property FromItem: TquideCustomStoryItem read FFromItem write FFromItem;
    property ToItem: TquideCustomStoryItem read FToItem write FToItem;
  end;

  TquideTextStoryItem = class(TquideCustomStoryItem)
  private
    FText: string;
    procedure SetText(const Value: string);
  protected
    procedure DoLoad(aNode: IXMLNode); override;
    procedure DoSave(aNode: IXMLNode); override;
  public
    function ToString: string; override;
    property Text: string read FText write SetText;
  end;


  TquideLogicStoryItem = class(TquideConditionStoryItem)
  private
    FResultFalse: TquideCustomStoryItem;
    FResultTrue: TquideCustomStoryItem;
    function Evaluate: TquideCustomStoryItem;
    procedure SetResultFalse(const Value: TquideCustomStoryItem);
    procedure SetResultTrue(const Value: TquideCustomStoryItem);
  public
    property ResultFalse: TquideCustomStoryItem read FResultFalse write SetResultFalse;
    property ResultTrue: TquideCustomStoryItem read FResultTrue write SetResultTrue;
  end;

  TquideJumpStoryItem = class(TquideCustomTransitionStoryItem)
  end;

  TquideEntityStoryItem = class(TquideCustomStoryItem)

  end;


  TquideStoryAction = class(TquideCustomStoryBlock)
  private
    FConditions: TquideStoryItemList;
    function CheckConditions: Boolean;
  protected
    procedure DoLoad(aNode: IXMLNode); override;
    procedure DoSave(aNode: IXMLNode); override;
  public
    constructor Create(aParent: TquideCustomStoryItem; const aAlias, aCaption:
        string); override;
    destructor Destroy; override;
    procedure AddCondition(aCondition: TquideConditionStoryItem);
    procedure Execute(aItems: TquideStoryItemList);
    property Conditions: TquideStoryItemList read FConditions;
  end;

  TquideParagraph = class(TquideStoryAction)
  public
    function AddText(const aText: string): TquideTextStoryItem;
    function AddCondition(aOperandA, aOperandB: TquideCustomStoryItem; aOperation:
        TquideLogicOperation): TquideConditionStoryItem;
  end;

  TquideStoryLocation = class(TquideStoryAction)
  private
    function GetParagraphs(Index: Integer): TquideParagraph;
  public
    function AddParagraph: TquideParagraph;
    property Paragraphs[Index: Integer]: TquideParagraph read GetParagraphs;
  end;

  TquideChapter = class(TquideStoryAction)
  private
    function GetLocations(Index: Integer): TquideStoryLocation;
  public
    function AddLocation(const aAlias, aCaption: string): TquideStoryLocation;
    property Locations[Index: Integer]: TquideStoryLocation read GetLocations;
  end;

  TquideStory = class(TquideCustomStoryBlock)
  private
    FAuthor: string;
    FCreateDate: TDateTime;
    FDescription: string;
    FVersion: string;
    function GetChapters(Index: Integer): TquideChapter;
    procedure SetAuthor(const Value: string);
    procedure SetCreateDate(const Value: TDateTime);
    procedure SetDescription(const Value: string);
    procedure SetVersion(const Value: string);
  protected
    procedure DoLoad(aNode: IXMLNode); override;
    procedure DoSave(aNode: IXMLNode); override;
  public
    function AddChapter(const aAlias, aCaption: string): TquideChapter;
    property Author: string read FAuthor write SetAuthor;
    property Chapters[Index: Integer]: TquideChapter read GetChapters;
    property CreateDate: TDateTime read FCreateDate write SetCreateDate;
    property Description: string read FDescription write SetDescription;
    property Version: string read FVersion write SetVersion;
  end;

  TquideClassManager =  class (TDictionary<string, TquideStoryClass>)
  public
    constructor Create;
    function MakeStoryItem(aNode: IXMLNode): TquideCustomStoryItem;
    procedure RegisterquideClasses;
  end;


  TquideStorage = class(TObject)
  private
    FFileName: string;
    FXML: IXMLDocument;
  private

  public
    constructor Create(const aFileName: string);
    destructor Destroy; override;
    procedure Load(aStory: TquideStory);
    procedure Save(aStory: TquideStory);
  end;


implementation

uses
  System.StrUtils, System.SysUtils, Xml.adomxmldom, Xml.Win.msxmldom,
  System.Variants;

var
  gQuideClassManager: TquideClassManager;



constructor TquideCustomStoryItem.Create(aParent: TquideCustomStoryItem; const
    aAlias, aCaption: string);
begin
  inherited Create;
  FParent:= aParent;
  FAlias:= aAlias;
  FCaption:= aCaption;
end;

destructor TquideCustomStoryItem.Destroy;
begin
  inherited Destroy;
end;

procedure TquideCustomStoryItem.Clear;
begin

end;

procedure TquideCustomStoryItem.DoAfterLoad;
begin

end;

procedure TquideCustomStoryItem.DoLoad(aNode: IXMLNode);
var
  l_Node: IXMLNode;
begin
  FAlias:= TryGetProperty(aNode, 'Alias');
  FCaption:= TryGetProperty(aNode, 'Caption');
end;

procedure TquideCustomStoryItem.DoSave(aNode: IXMLNode);
begin
  aNode.Attributes['ClassName']:= ClassName;
  aNode.AddChild('Alias').Text:= FAlias;
  aNode.AddChild('Caption').Text:= FCaption;
end;

procedure TquideCustomStoryItem.Load(aNode: IXMLNode);
begin
  DoLoad(aNode);
  DoAfterLoad;
end;

procedure TquideCustomStoryItem.Save(aNode: IXMLNode);
begin
  DoSave(aNode);
end;

function TquideCustomStoryItem.ToString: string;
begin
  Result := Caption;
end;

function TquideCustomStoryItem.TryGetProperty(aNode: IXMLNode; const aName:
    string): string;
var
  l_Node: IXMLNode;
begin
  l_Node:= aNode.ChildNodes.FindNode(aName);
  if Assigned(l_Node) then
    Result:= l_Node.Text
  else
    Result := EmptyStr;
end;

constructor TquideCustomStoryBlock.Create(aParent: TquideCustomStoryItem; const
    aAlias, aCaption: string);
begin
  inherited;
  FItems := TquideStoryItemList .Create();
end;

destructor TquideCustomStoryBlock.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TquideCustomStoryBlock.Add(aItem: TquideCustomStoryItem);
begin
  if aItem.Parent <> Self then
    aItem.Parent:= Self;
  FItems.Add(aItem);
end;

procedure TquideCustomStoryBlock.Clear;
begin
  inherited;
  FItems.Clear;
end;

function TquideCustomStoryBlock.DefaultAlias(const aSuffix: string = 'item'): string;
var
  l_Index: Integer;
begin
  l_Index:= 1;
  Result := Alias + '.' + aSuffix + (Count+1).ToString;
end;

function TquideCustomStoryBlock.FindByAlias(const AAlias: string): TquideCustomStoryItem;
var
  l_Item: TquideCustomStoryItem;
begin
  Result := nil;
  for l_Item in FItems do
    if SameText(aAlias, l_Item.Alias) then
    begin
      Result:= l_Item;
      break;
    end;
  if not Assigned(Result) then
    for l_Item in FItems do
      if l_Item is TquideCustomStoryBlock then
      begin
        Result:= (l_Item as TquideCustomStoryBlock).FindByAlias(AAlias);
        if Assigned(Result) then
          break;
      end;
end;

function TquideCustomStoryBlock.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TquideCustomStoryBlock.HaveItem(aItem: TquideCustomStoryItem): Boolean;
var
  l_Item: TquideCustomStoryItem;
begin
  Result := FItems.Contains(aItem);
  if not Result then
    for l_Item in FItems do
      if l_Item is TquideCustomStoryBlock then
      begin
        Result:= (l_Item as TquideCustomStoryBlock).HaveItem(aItem);
        if Result then
          break;
      end;
end;

function TquideCustomStoryBlock.HaveItem(const aAlias: string): Boolean;
begin
  Result := FindByAlias(AAlias) <> nil;
end;

procedure TquideCustomStoryBlock.DoLoad(aNode: IXMLNode);
begin
  inherited;
  LoadItems(aNode, FItems, 'Items');
end;

procedure TquideCustomStoryBlock.DoSave(aNode: IXMLNode);
begin
  inherited;
  SaveItems(aNode, FItems, 'Items');
end;

procedure TquideCustomStoryBlock.LoadItems(aNode: IXMLNode; aItems:
    TquideStoryItemList; const aName: string);
var
  i: Integer;
  l_Item: TquideCustomStoryItem;
  l_Items: IXMLNode;
  l_Node: IXMLNode;
begin
  AItems.Clear;
  l_Items:= aNode.ChildNodes.FindNode(aName);
  if Assigned(l_Items) then
    for i:= 0 to l_Items.ChildNodes.Count-1 do
    begin
      l_Node:= l_Items.ChildNodes[i];
      l_Item:= gQuideClassManager.MakeStoryItem(l_Node);
      if Assigned(l_Item) then
      begin
        aItems.Add(l_Item);
        l_Item.Load(l_Node);
      end;
    end;
end;

procedure TquideCustomStoryBlock.SaveItems(aNode: IXMLNode; aItems:
    TquideStoryItemList; const aName: string);
var
  l_Item: TquideCustomStoryItem;
  l_Items: IXMLNode;
begin
  l_Items:= aNode.AddChild(aName);
  for l_Item in aItems do
    l_Item.DoSave(l_Items.AddChild('Item'));
end;

function TquideCustomStoryBlock.ToString: string;
var
  l_Item: TquideCustomStoryItem;
begin
  Result := '';
  for l_Item in FItems do
    Result:= Result + l_Item.ToString + sLineBreak;
end;

procedure TquideTextStoryItem.DoLoad(aNode: IXMLNode);
begin
  inherited;
  FText:= TryGetProperty(aNode, 'Text');
end;

procedure TquideTextStoryItem.DoSave(aNode: IXMLNode);
begin
  inherited;
  aNode.AddChild('Text').Text:= FText;
end;

procedure TquideTextStoryItem.SetText(const Value: string);
begin
  FText := Value;
end;

function TquideTextStoryItem.ToString: string;
begin
  Result := Text;
end;

function TquideStory.AddChapter(const aAlias, aCaption: string): TquideChapter;
begin
  Result := TquideChapter.Create(Self, aAlias, aCaption);
  Add(Result);
end;

function TquideStory.GetChapters(Index: Integer): TquideChapter;
begin
  Result := Items[Index] as TquideChapter;
end;

procedure TquideStory.DoLoad(aNode: IXMLNode);
begin
  inherited;
end;

procedure TquideStory.DoSave(aNode: IXMLNode);
begin
  inherited;
  aNode.AddChild('Author').Text:= FAuthor;
  aNode.AddChild('Version').Text:= FVersion;
  aNode.AddChild('Description').Text:= FDescription;
  aNode.AddChild('CreateDate').Text:= DateTimeToStr(FCreateDate);
end;

procedure TquideStory.SetAuthor(const Value: string);
begin
  FAuthor := Value;
end;

procedure TquideStory.SetCreateDate(const Value: TDateTime);
begin
  FCreateDate := Value;
end;

procedure TquideStory.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TquideStory.SetVersion(const Value: string);
begin
  FVersion := Value;
end;

function TquideLogicStoryItem.Evaluate: TquideCustomStoryItem;
begin
  Result := nil;
end;

procedure TquideLogicStoryItem.SetResultFalse(const Value: TquideCustomStoryItem);
begin
  FResultFalse := Value;
end;

procedure TquideLogicStoryItem.SetResultTrue(const Value: TquideCustomStoryItem);
begin
  FResultTrue := Value;
end;

constructor TquideStoryAction.Create(aParent: TquideCustomStoryItem; const
    aAlias, aCaption: string);
begin
  inherited;
  FConditions := TquideStoryItemList.Create();
end;

destructor TquideStoryAction.Destroy;
begin
  FConditions.Free;
  inherited Destroy;
end;

procedure TquideStoryAction.AddCondition(aCondition: TquideConditionStoryItem);
begin
  // TODO -cMM: TquideStoryAction.AddCondition default body inserted
end;

function TquideStoryAction.CheckConditions: Boolean;
var
  i: Integer;
  l_Condition: TquideConditionStoryItem;
begin
  Result := True;
  for i:= 0 to FConditions.Count-1 do
  begin
    l_Condition:= FConditions[i] as TquideConditionStoryItem;
    if not l_Condition.IsValid then
    begin
      Result:= False;
      break;
    end;
  end;
end;

procedure TquideStoryAction.DoLoad(aNode: IXMLNode);
begin
  inherited;
  LoadItems(aNode, FConditions, 'Conditions');
end;

procedure TquideStoryAction.DoSave(aNode: IXMLNode);
begin
  inherited;
  SaveItems(aNode, FConditions, 'Conditions');
end;

procedure TquideStoryAction.Execute(aItems: TquideStoryItemList);
var
  l_Item: TquideCustomStoryItem;
begin
  aItems.Clear;
  if CheckConditions then
    for l_Item in Items do
      aItems.Add(l_Item);
end;

procedure TquideConditionStoryItem.DoLoad(aNode: IXMLNode);
var
  l_Node: IXMLNode;
begin
  inherited;
  l_Node:= aNode.ChildNodes.FindNode('OperandA');
  if Assigned(l_Node) then
    FOperandAAlias:= l_Node.Text;
  l_Node:= aNode.ChildNodes.FindNode('OperandB');
  if Assigned(l_Node) then
    FOperandBAlias:= l_Node.Text;
  l_Node:= aNode.ChildNodes.FindNode('Operation');
  if Assigned(l_Node) then
    FOperation:= TquideLogicOperation(l_Node.Text.ToInteger);
end;

function TquideConditionStoryItem.IsValid: Boolean;
var
  l_Result: Integer;
begin
  Result := False;
  if Assigned(OperandA) and Assigned(OperandB) then
  begin
    l_Result:= CompareText(OperandA.ToString, OperandB.ToString);
    case FOperation of
      qloEqual: Result:= l_Result = 0;
      qloNotEqual: Result:= l_Result <> 0;
      qloGreaterThan: Result:= l_Result > 0;
      qloLessThan: Result:= l_Result < 0;
    end;
  end;
end;

procedure TquideConditionStoryItem.DoSave(aNode: IXMLNode);
begin
  inherited;
  if Assigned(FOperandA) then
    aNode.AddChild('OperandA').Text:= FOperandA.Alias;
  if Assigned(FOperandB) then
    aNode.AddChild('OperandB').Text:= FOperandB.Alias;
  ANode.AddChild('Operation').Text:= Ord(FOperation).ToString;
end;

procedure TquideConditionStoryItem.SetOperandA(const Value: TquideCustomStoryItem);
begin
  FOperandA := Value;
end;

procedure TquideConditionStoryItem.SetOperandB(const Value: TquideCustomStoryItem);
begin
  FOperandB := Value;
end;

procedure TquideConditionStoryItem.SetOperation(const Value: TquideLogicOperation);
begin
  FOperation := Value;
end;

function TquideChapter.AddLocation(const aAlias, aCaption: string):
    TquideStoryLocation;
begin
  Result := TquideStoryLocation.Create(Self, aAlias, aCaption);
  Add(Result);
end;

function TquideChapter.GetLocations(Index: Integer): TquideStoryLocation;
begin
  Result := Items[Index] as TquideStoryLocation;
end;

function TquideStoryLocation.AddParagraph: TquideParagraph;
begin
  Result := TquideParagraph.Create(Self, DefaultAlias('Paragraph'), '');
  Add(Result);
end;

function TquideStoryLocation.GetParagraphs(Index: Integer): TquideParagraph;
begin
  Result := Items[Index] as TquideParagraph;
end;

function TquideParagraph.AddCondition(aOperandA, aOperandB:
    TquideCustomStoryItem; aOperation: TquideLogicOperation):
    TquideConditionStoryItem;
begin
  Result := TquideConditionStoryItem.Create(Self, DefaultAlias('Condition'), '');
  Result.OperandA:= aOperandA;
  Result.OperandB:= aOperandB;
  Result.Operation:= aOperation;
  FConditions.Add(Result);
end;

function TquideParagraph.AddText(const aText: string): TquideTextStoryItem;
var
  l_Text: TquideTextStoryItem;
begin
  Result:= TquideTextStoryItem.Create(self, DefaultAlias('Text'), '');
  Result.Text:= aText;
  Add(Result);
end;

constructor TquideStorage.Create(const aFileName: string);
begin
  inherited Create;
  FXML:= TXMLDocument.Create(nil);
  FXML.Options:= [doNodeAutoCreate, doNodeAutoIndent, doAttrNull, doAutoPrefix, doNamespaceDecl];
  FXML.Active := True;
  FXML.Encoding :=  'windows-1251';
  FXML.Version := '1.0';

  FFileName:= aFileName;
end;

destructor TquideStorage.Destroy;
begin
  FXML:= nil;
  inherited Destroy;
end;

procedure TquideStorage.Load(aStory: TquideStory);
var
  i: Integer;
  l_Class: TquideStoryClass;
  l_Item: TquideCustomStoryItem;
  l_Node: IXMLNode;
  l_Root: IXMLNode;
begin
  aStory.Clear;
  FXML.LoadFromFile(FFileName);
  FXML.Active:= True;
  if not FXML.IsEmptyDoc then
  begin
    l_Root:= FXML.ChildNodes.FindNode('Story');
    if Assigned(l_Root) then
      aStory.Load(l_Root);
  end;
end;

procedure TquideStorage.Save(aStory: TquideStory);
var
  l_Node: IXMLNode;
begin
  l_Node:= FXML.Node.AddChild('Story');
  aStory.Save(l_Node);
  FXML.SaveToFile(FFileName);
end;

constructor TquideClassManager.Create;
begin
  inherited;
  RegisterquideClasses;
end;

function TquideClassManager.MakeStoryItem(aNode: IXMLNode):
    TquideCustomStoryItem;
var
  l_Class: TquideStoryClass;
  l_ClassName: OleVariant;
begin
  Result:= nil;
  l_ClassName:= aNode.Attributes['ClassName'];
  if not VarIsNull(l_ClassName) then
    if gQuideClassManager.TryGetValue(l_ClassName, l_Class) then
      Result := l_Class.Create(nil, '', '');
end;

procedure TquideClassManager.RegisterquideClasses;
begin
  Add('TquideCustomStoryItem', TquideCustomStoryItem);
  Add('TquideStory', TquideStory);
  Add('TquideChapter', TquideChapter);
  Add('TquideStoryLocation', TquideStoryLocation);
  Add('TquideParagraph', TquideParagraph);
  Add('TquideTextStoryItem', TquideTextStoryItem);
  Add('TquideConditionStoryItem', TquideConditionStoryItem);
  Add('TquideCustomStoryBlock', TquideCustomStoryBlock);
  Add('TquideCustomTransitionStoryItem', TquideCustomTransitionStoryItem);
  Add('TquideLogicStoryItem', TquideLogicStoryItem);
  Add('TquideJumpStoryItem', TquideJumpStoryItem);
  Add('TquideEntityStoryItem', TquideEntityStoryItem);
  Add('TquideStoryAction', TquideStoryAction);
end;


initialization
  gQuideClassManager:= TquideClassManager.Create;
finalization
  gQuideClassManager.Free;
end.
