unit QuideClassesControls;

interface

Uses
  System.Classes, Vcl.ExtCtrls, QuideClasses, Vcl.Controls, Vcl.StdCtrls;


type
  TquideCustomControl = class(TPanel)
  private
    FQuideObject: TquideCustomStoryItem;
    procedure AdjustControls;
    function CreateItemControl(aItem: TquideCustomStoryItem): TControl;
    function CreateLabel(const aCaption: string): TControl;
    function GetControlWidth(aControl: TControl): Integer;
    function GetNextCtrlTop: Integer;
  protected
    procedure CreateConditions(const aItems: TquideStoryItemList);
    function CreateListEdit(const aCaption: string): TControl;
    function CreateMemoEdit(const aCaption, aValue: string): TControl;
    function CreateTextEdit(const aCaption, aValue: string): TControl;
    procedure FillListBox(const aListBox: TListBox; const aItems:
        TquideStoryItemList);
    function GetControlValue(const aControlName: string): string;
    procedure GetListValue(const aControlName: string; const aItems: TquideStoryItemList);
    procedure ShowItemDialog(Sender: TObject);
  public
    constructor Create(aOwner: TComponent; aQuideObject: TquideCustomStoryItem); reintroduce;
    procedure CreateControls; virtual;
    procedure DoAfterInsert; virtual;
    procedure GetQuideObject; virtual;
    property QuideObject: TquideCustomStoryItem read FQuideObject;
  end;

  TquideControlClass = class of TquideCustomControl;

  TquideStoryControl = class(TquideCustomControl)
  private
    fList: TListBox;
  public
    procedure CreateControls; override;
    procedure DoAfterInsert; override;
    procedure GetQuideObject; override;
  end;

  TquideConditionControl = class(TquideCustomControl)
  private
    function GetOperationName(aOperation: TquideLogicOperation): string;
  public
    procedure CreateControls; override;
  end;

  TquideActionControl = class(TquideCustomControl)
  public
    procedure CreateControls; override;
  end;

  TquideChapterControl = class(TquideActionControl)
  private
    fList: TListBox;
  public
    procedure CreateControls; override;
    procedure DoAfterInsert; override;
    procedure GetQuideObject; override;
  end;

  TquideLocationControl = class(TquideActionControl)
  private
    FList: TListBox;
  public
    procedure CreateControls; override;
    procedure DoAfterInsert; override;
  end;

  TquideTextControl = class(TquideActionControl)
  public
    procedure CreateControls; override;
  end;

  TquideParagraphControl = class(TquideActionControl)
  public
    procedure CreateControls; override;
  end;

  TquideLogicControl = class(TquideConditionControl)
  private
  public
    procedure CreateControls; override;
  end;


function GetQuideControlClass(aClass: TquideCustomStoryItem): TquideControlClass;

implementation

uses
  System.Math, System.SysUtils,
  QuideClassesControlsDialog, QuideClassesManager;

function GetQuideControlClass(aClass: TquideCustomStoryItem): TquideControlClass;
begin
  Result:= QuideClassManager.GetControlClass(aClass);
end;

constructor TquideCustomControl.Create(aOwner: TComponent; aQuideObject: TquideCustomStoryItem);
begin
  inherited Create(aOwner);
  Align:= alTop;
  FquideObject:= aQuideObject;
  Caption:= '';
  CreateControls;
  Height:= GetNextCtrlTop;
  AdjustControls;
end;

procedure TquideCustomControl.AdjustControls;
var
  I: Integer;
  l_Left: Integer;
begin
  l_Left:= 0;
  for I := 0 to ControlCount-1 do
    if Controls[i] is TLabel then
      l_Left:= Max(l_Left, GetControlWidth(Controls[i]));

  for I := 0 to ControlCount-1 do
    if not (Controls[i] is TLabel) then
    begin
      Controls[i].Left:= l_Left;
      Controls[i].Width:= Width - l_Left - 4 - BorderWidth*2;
      Controls[i].Anchors:= [akTop, akLeft, akRight];
    end;
end;

procedure TquideCustomControl.CreateConditions(const aItems:
    TquideStoryItemList);
var
  l_Ctrl: TControl;
  l_Item: TquideCustomStoryItem;
  l_Top: Integer;
begin
  for l_Item in aItems do
  begin
    CreateItemControl(l_Item);
    (*
    l_Top:= GetNextCtrlTop;
    l_Ctrl:= TquideConditionControl.Create(Self, l_Item);
    l_Ctrl.Top:= l_top;
    InsertControl(l_Ctrl);
    *)
  end;
end;

procedure TquideCustomControl.CreateControls;
begin
  CreateTextEdit('Алиас', FquideObject.Alias).Name:= 'editAlias';
  CreateTextEdit('Название', FQuideObject.Caption).Name:= 'editCaption';
end;

function TquideCustomControl.CreateItemControl(aItem: TquideCustomStoryItem): TControl;
begin
  if Assigned(aItem) then
  begin
    Result:= QuideClassManager.GetControlClass(aItem).Create(self, aItem);
    Result.Top:= GetNextCtrlTop;
    Result.Left:= 4;
    InsertControl(Result);
  end
  else
    Result := nil;
end;

function TquideCustomControl.CreateLabel(const aCaption: string): TControl;
begin
  Result:= TLabel.Create(Self);
  Result.Top:= GetNextCtrlTop;
  InsertControl(Result);
  (Result as TLabel).Caption:= aCaption;
  Result.Left:= 4;
end;

function TquideCustomControl.CreateListEdit(const aCaption: string): TControl;
var
  l_Label: TControl;
  l_Edit: TListBox;
  l_Top: Integer;
begin
  // Список, двойной клик открывает сущность
  l_Top:= GetNextCtrlTop;
  l_Label:= CreateLabel(aCaption);

  l_Edit:= TListBox.Create(Self);
  l_Edit.Left:= GetControlWidth(l_Label);
  l_Edit.Top:= l_Top;
  InsertControl(l_Edit);
  l_Edit.OnDblClick:= ShowItemDialog;
  Result:= l_Edit;
end;

function TquideCustomControl.CreateMemoEdit(const aCaption, aValue: string):
    TControl;
var
  l_Label: TControl;
  l_Edit: TMemo;
  l_Top: Integer;
begin
  l_Top:= GetNextCtrlTop;
  l_Label:= CreateLabel(aCaption);

  l_Edit:= TMemo.Create(Self);
  l_Edit.Left:= GetControlWidth(l_Label);
  l_Edit.Top:= l_Top;
  l_Edit.Text:= aValue;
  InsertControl(l_Edit);
  Result:= l_Edit;
end;

function TquideCustomControl.CreateTextEdit(const aCaption, aValue: string):
    TControl;
var
  l_Label: TControl;
  l_Edit: TEdit;
  l_Top: Integer;
begin
  l_Top:= GetNextCtrlTop;

  l_Label:= CreateLabel(aCaption);

  l_Edit:= TEdit.Create(Self);
  l_Edit.Left:= GetControlWidth(l_Label);
  l_Edit.Top:= l_Top;
  l_Edit.Text:= aValue;
  InsertControl(l_Edit);

  l_Label.Top:= l_Top + (l_Edit.Height - l_Label.Height) div 2;
  Result:= l_Edit;
end;

procedure TquideCustomControl.DoAfterInsert;
begin
  // TODO -cMM: TquideCustomControl.DoAfterInsert default body inserted
end;

procedure TquideCustomControl.FillListBox(const aListBox: TListBox; const
    aItems: TquideStoryItemList);
var
  l_Item: TquideCustomStoryItem;
begin
  for l_Item in aItems do
    aListBox.Items.AddObject(l_Item.Caption, l_Item);
end;

function TquideCustomControl.GetControlValue(const aControlName: string): string;
var
  l_Ctrl: TControl;
begin
  l_Ctrl:= FindChildControl(aControlName);
  if l_Ctrl is TEdit then
    Result:= (l_Ctrl as TEdit).Text
  else
  if l_Ctrl is TMemo then
    Result:= (l_Ctrl as TMemo).Text
  else
    Result:= EmptyStr;
end;

function TquideCustomControl.GetControlWidth(aControl: TControl): Integer;
begin
  Result := 4 + aControl.Left + aControl.Width;
end;

procedure TquideCustomControl.GetListValue(const aControlName: string; const aItems: TquideStoryItemList);
begin
  // TODO -cMM: TquideCustomControl.GetListValue default body inserted
end;

function TquideCustomControl.GetNextCtrlTop: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to ControlCount-1 do
    Result:= Max(Result, Controls[i].Top + Controls[i].Height);
  Inc(Result, 4);
end;

procedure TquideCustomControl.GetQuideObject;
begin
  FQuideObject.Alias:= GetControlValue('editAlias');
  FQuideObject.Caption:= GetControlValue('editCaption');
end;

procedure TquideCustomControl.ShowItemDialog(Sender: TObject);
begin
  if (Sender as TListBox).ItemIndex <> -1 then
    ShowQuideDialog((Sender as TListBox).Items.Objects[(Sender as TListBox).ItemIndex] as TquideCustomStoryItem);
end;

procedure TquideStoryControl.CreateControls;
begin
  inherited;
  with FquideObject as TquideStory do
  begin
    CreateTextEdit('Автор', Author).Name:= 'editAuthor';
    CreateMemoEdit('Описание', Description).Name:= 'editDescription';
    CreateTextEdit('Версия', Version).Name:= 'editVersion';
    CreateTextEdit('Дата создания', DateToStr(CreateDate)).Name:= 'editCreateDate';
    fList:= CreateListEdit('Главы') as TListBox;
    FList.Name:= 'listChapters';
  end;
end;

procedure TquideStoryControl.DoAfterInsert;
begin
  inherited;
  FillListBox(FList, (FQuideObject as TquideStory).Items);

end;

procedure TquideStoryControl.GetQuideObject;
begin
  inherited;
  with (FQuideObject as TquideStory) do
  begin
    Author:= GetControlValue('editAuthor');
    Description:= GetControlValue('editDescription');
    Version:= GetControlValue('editVersion');
    CreateDate:= StrToDateDef(GetControlValue('editCreateDate'), CreateDate);
    GetListValue('listChapters', Items);
  end;
end;

procedure TquideChapterControl.CreateControls;
begin
  inherited;
  fList:= CreateListEdit('Локации') as TListBox;
  fList.Name:= 'editLocations';
end;

procedure TquideChapterControl.DoAfterInsert;
begin
  inherited;
  FillListBox(FList, (FQuideObject as TquideChapter).Items);
end;

procedure TquideChapterControl.GetQuideObject;
begin
  inherited;
  GetListValue('editLocations', (FQuideObject as TquideChapter).Items);
end;

procedure TquideConditionControl.CreateControls;
var
  l_Label: TControl;
  l_Left: Integer;
  l_Text: TStaticText;
  l_Top: Integer;
begin
{
    FOperandA: TquideCustomStoryItem;
    FOperandAAlias: string;
    FOperandB: TquideCustomStoryItem;
    FOperandBAlias: string;
    FOperation: TquideLogicOperation;
}
  l_Top:= GetNextCtrlTop;

  l_Label:= CreateLabel('Если');
  l_Left:= GetControlWidth(l_Label);

  l_Text:= TStaticText.Create(Self);
  l_Text.Left:= l_Left;
  l_Text.Top:= l_Top;
  InsertControl(l_Text);
  // В зависимости от типа операндов выводить или Caption или Value
  with (FquideObject as TquideConditionStoryItem) do
    l_Text.Caption:= Format('%s %s %s', [OperandA.Caption, GetOperationName(Operation), OperandB.Caption]);
end;

function TquideConditionControl.GetOperationName(aOperation: TquideLogicOperation): string;
begin
  case aOperation of
    qloEqual: Result:= '=';
    qloNotEqual: Result:= '<>';
    qloGreaterThan: Result:= '>=';
    qloLessThan: Result:= '<=';
  end;
end;

procedure TquideLocationControl.CreateControls;
begin
  inherited;
  fList:= CreateListEdit('Абзацы') as TListBox;
end;

procedure TquideLocationControl.DoAfterInsert;
begin
  inherited;
  FillListBox(FList, (FQuideObject as TquideStoryLocation).Items);
end;

procedure TquideActionControl.CreateControls;
begin
  CreateConditions((FQuideObject as TquideStoryAction).Conditions);
  inherited;
end;

procedure TquideParagraphControl.CreateControls;
var
  I: Integer;
begin
  //inherited; появлется мусор
  // Для всех Items создать контролы

  for I := 0 to (FQuideObject as TquideParagraph).Count-1 do
  begin
    CreateItemControl((FQuideObject as TquideParagraph).Items[i]);

  end;

end;

procedure TquideTextControl.CreateControls;
begin
  inherited;
  CreateMemoEdit('Текст', (FQuideObject as TquideTextStoryItem).Text);
end;

procedure TquideLogicControl.CreateControls;
var
  l_Ctrl: TControl;
  l_Item: TquideCustomStoryItem;
begin
  inherited;
  CreateItemControl((FQuideObject as TquideLogicStoryItem).ResultTrue);
  l_Ctrl:= CreateLabel('Иначе');
  CreateItemControl((FQuideObject as TquideLogicStoryItem).ResultFalse);
end;

end.
