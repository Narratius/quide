unit quideScenarios;

interface

uses
  SysUtils, Windows, Generics.Collections, Classes,
  quideObject, quideVariables, quideSteps, quideInventory, quideLocations;

type
  TquideScenario = class(TquideObject)
  private
    //1 —писок глав сценари€
    f_Chapters: TObjectList<TquideChapter>;
    f_Inventory: TObjectList<TquideInventoryItem>;
    f_LocationsNames: TStrings;
    f_Variables: TObjectList<TquideVariable>;
    f_VariablesNames: TStrings;
    function pm_GetChapters(Index: Integer): TquideChapter;
    function pm_GetChaptersCount: Integer;
    function pm_GetInventory(Index: Integer): TquideInventoryItem;
    function pm_GetInventoryItemsCount: Integer;
    function pm_GetLocationsNames: TStrings;
    function pm_GetVariables(Index: Integer): TquideVariable;
    function pm_GetVariablesCount: Integer;
    function pm_GetVariablesNames: TStrings;
    procedure UpdateChapters;
  public
    constructor Create; override;
    destructor Destroy; override;
    //1 —оздает √лаву и добавл€ет в список
    function AddChapter: TquideChapter;
    function AddVariable(const aAlias, aHint: String; aVarType:
        TquideVariableType; aValue: string): TquideVariable;
    //1 ”даление указанной главы
    procedure Delete(Index: Integer);
    function IsValidLocation(const aCaption: String): TquideLocation;
    //1 ѕровер€ет список переменных на наличие в нем нужной и возвращает ее
    function IsValidVariable(const aCaption: String): TquideVariable;
    property Chapters[Index: Integer]: TquideChapter read pm_GetChapters;
        default;
    property ChaptersCount: Integer read pm_GetChaptersCount;
    property Inventory[Index: Integer]: TquideInventoryItem read
        pm_GetInventory;
    property InventoryItemsCount: Integer read pm_GetInventoryItemsCount;
    property LocationsNames: TStrings read pm_GetLocationsNames;
    property Variables[Index: Integer]: TquideVariable read pm_GetVariables;
    //1  оличество переменных в сценарии
    property VariablesCount: Integer read pm_GetVariablesCount;
    //1 —писок имен переменных дл€ использовани€ в списках
    property VariablesNames: TStrings read pm_GetVariablesNames;
  end;


implementation

{
******************************** TquideScenario ********************************
}
constructor TquideScenario.Create;
begin
  inherited Create;
  f_VariablesNames := TStringList.Create;
  f_LocationsNames := TStringList.Create;
  f_Chapters := TObjectList<TquideChapter>.Create();
  f_Variables := TObjectList<TquideVariable>.Create();
  f_Inventory := TObjectList<TquideInventoryItem>.Create();
  Changed:= False;
end;

destructor TquideScenario.Destroy;
begin
  FreeAndNil(f_Chapters);
  FreeAndNil(f_Inventory);
  FreeAndNil(f_Variables);
  FreeAndNil(f_Chapters);
  FreeAndNil(f_LocationsNames);
  FreeAndNil(f_VariablesNames);
  inherited Destroy;
end;

function TquideScenario.AddChapter: TquideChapter;
begin
  Result := TquideChapter.Create();
  f_Chapters.Add(Result);
  UpdateChapters;
  Changed:= False;

end;

function TquideScenario.AddVariable(const aAlias, aHint: String; aVarType:
    TquideVariableType; aValue: string): TquideVariable;
begin
 Result:= TquideVariable.Create;
 Result.Caption:= aAlias;
 Result.Hint:= aHint;
 Result.VarType:= aVarType;
 //Result.Value:= aValue; пока нет класса со значением
 f_Variables.Add(Result);
end;

procedure TquideScenario.Delete(Index: Integer);
begin
 //перед удалением главы хорошо бы проверить все локации на использование
 f_Chapters.Delete(Index);
 UpdateChapters;
 Changed:= True;
end;

function TquideScenario.IsValidLocation(const aCaption: String): TquideLocation;
var
  i: Integer;
  l_Loc: TquideLocation;
begin
  Result:= nil;
  (*
  for i:= 0 to Pred(StepsCount) do
  begin
   l_Loc:= Chapters[i].IsValidLocation(aCaption);
   if l_Loc <> nil then
   begin
    Result:= l_Loc;
    break;
   end;
   *)
end;

function TquideScenario.IsValidVariable(const aCaption: String): TquideVariable;
var
  i: Integer;
begin
  Result:= nil;
  for i:= 0 to Pred(VariablesCount) do
   if Variables[i].ItsMe(aCaption) then
   begin
    Result:= Variables[i];
    break;
   end;
end;

function TquideScenario.pm_GetChapters(Index: Integer): TquideChapter;
begin
 Result:= TquideChapter(f_Chapters[Index])
end;

function TquideScenario.pm_GetChaptersCount: Integer;
begin
 Result:= f_Chapters.Count;
end;

function TquideScenario.pm_GetInventory(Index: Integer): TquideInventoryItem;
begin
 Result:= TquideInventoryItem(f_Inventory[Index]);
end;

function TquideScenario.pm_GetInventoryItemsCount: Integer;
begin
 Result:= f_Inventory.Count;
end;

function TquideScenario.pm_GetLocationsNames: TStrings;
begin
  Result := f_LocationsNames;
end;

function TquideScenario.pm_GetVariables(Index: Integer): TquideVariable;
begin
 Result:= TquideVariable(f_Variables[index]);
end;

function TquideScenario.pm_GetVariablesCount: Integer;
begin
 Result:= f_Variables.Count;
end;

function TquideScenario.pm_GetVariablesNames: TStrings;
begin
  Result := f_VariablesNames;
end;

procedure TquideScenario.UpdateChapters;
var
  l_Chapter: TquideChapter;
  i, j: Integer;
begin
 f_LocationsNames.Clear;
 for i:= 0 to Pred(ChaptersCount) do
 begin
  l_Chapter:= Chapters[i];
  for j:= 0 to Pred(l_Chapter.LocationsCount) do
   f_LocationsNames.Add(l_Chapter[j].Caption);
 end;
end;



end.
