Unit quideLocationDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  quideLocations, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.ExtCtrls, PropertiesControls, Vcl.StdCtrls, quideActions, quideScenarios,
  Vcl.Menus;

type
  TquideLocationDialog = class(TForm)
    ActionManager: TActionManager;
    actNewText: TAction;
    actButton: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    WorkPanel: TPanel;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    PopupMenu1: TPopupMenu;
    MenuText: TMenuItem;
    MenuButton: TMenuItem;
    actEditButton: TAction;
    menuVariable: TMenuItem;
    actVariable: TAction;
    actInventory: TAction;
    menuInventary: TMenuItem;
    actLogical: TAction;
    N1: TMenuItem;
    actDelete: TAction;
    procedure actNewTextExecute(Sender: TObject);
    procedure actButtonExecute(Sender: TObject);
    procedure actEditButtonExecute(Sender: TObject);
    procedure actVariableExecute(Sender: TObject);
    procedure actLogicalExecute(Sender: TObject);
    procedure actInventoryExecute(Sender: TObject);
  private
    f_Scenario: TquideScenario;
    FLocation: TquideLocation;
    f_Header : TPropertiesPanel;
    f_Actions: TPanel;
    procedure SetLocation(const Value: TquideLocation);
    { Private declarations }
    procedure ClearControls;
    procedure CreateHeader;
    procedure CreateActions;
    procedure AddAction(aAction: TquideAction);
    procedure GetActionsValues;
  public
    { Public declarations }
   function Execute(aLocation: TquideLocation; theScenario: TquideScenario): Boolean;
   property Location: TquideLocation read FLocation write SetLocation;
  end;


implementation

{$R *.dfm}

Uses
  quideButtonEditDlg
  {$IFDEF Debug}, ddLogFile{$ENDIF};

{ TForm1 }

procedure TquideLocationDialog.actButtonExecute(Sender: TObject);
var
 l_Loc, l_Cap: String;
 l_Act: TquideAction;
begin
 // Добавляем кнопку
 l_Loc:= ''; l_Cap:= '';
 { TODO : Подтянуть список существующих локаций или создать новую }
  if ButtonEditDlg(l_Cap, l_Loc, f_Scenario.LocationsNames) then
  begin
   l_Act:= fLocation.AddAction(atButton);
   TquideButtonAction(l_Act).Values['Button']:= l_Cap; // Текст на кнопке
   TquideButtonAction(l_Act).Values['Target']:= l_Loc; // Название локации для перехода
   TquideButtonAction(l_Act).OnClick:= actEditButtonExecute;
   AddAction(l_Act);
  end;
end;

procedure TquideLocationDialog.actEditButtonExecute(Sender: TObject);
var
 l_Loc, l_Cap: String;
 l_Act: TquideAction;
begin
 // Изменяем свойства кнопки
 l_Act:= fLocation.ActionByID((Sender as TControl).Tag);

 l_Cap:= TquideButtonAction(l_Act).Values['Button']; // Текст на кнопке
 l_Loc:= TquideButtonAction(l_Act).Values['Target']; // Название локации для перехода
 if ButtonEditDlg(l_Cap, l_Loc, nil) then
 begin
  TquideButtonAction(l_Act).Values['Button']:= l_Cap; // Текст на кнопке
  TquideButtonAction(l_Act).Values['Target']:= l_Loc; // Название локации для перехода
 end;
end;

procedure TquideLocationDialog.actInventoryExecute(Sender: TObject);
begin
 AddAction(fLocation.AddAction(atInventory));
end;

procedure TquideLocationDialog.actLogicalExecute(Sender: TObject);
begin
 AddAction(fLocation.AddAction(atLogic));
end;

procedure TquideLocationDialog.actNewTextExecute(Sender: TObject);
begin
 // Добавляем текст
 AddAction(fLocation.AddAction(atText));
end;

procedure TquideLocationDialog.actVariableExecute(Sender: TObject);
begin
  AddAction(fLocation.AddAction(atVariable));
end;

procedure TquideLocationDialog.AddAction(aAction: TquideAction);
var
 l_Actions: TPropertiesPanel;
 l_Top: Integer;
begin
 if f_Actions.ControlCount > 0 then
  l_Top:= f_Actions.Controls[f_Actions.ControlCount-1].Top + f_Actions.Controls[f_Actions.ControlCount-1].Height
 else
  l_Top:= 0;
 // Добавляем панель и контролы
 if aAction.ActionType = atVariable  then
  aAction.AliasItems['VarList'].SetChoice(f_Scenario.AliasItems['Variables'])
 else
 if aAction.ActionType = atInventory  then
  aAction.AliasItems['InvList'].SetChoice(f_Scenario.AliasItems['Inventory']);
 l_Actions:= TPropertiesPanel.Create(Self);
 with l_Actions do
 begin
  Align:= alNone;
  Parent:= f_Actions;
  Width:= f_Actions.ClientWidth;
  Anchors:= Anchors + [akRight];
  Top:= l_Top;
  Tag:= aAction.Index;
  Height:= 16;
  Properties:= aAction;
 end;
 {$IFDEF Debug}
 with l_Actions do
   Msg2Log('Add Control: %s (Left: %d, Top: %d, Width: %d, Height: %d)', [ClassName, Left, Top, Width, Height]);
 {$ENDIF}
end;

procedure TquideLocationDialog.ClearControls;
begin
 // Удалить текущие контролы
end;

procedure TquideLocationDialog.CreateActions;
var
  I, l_Top: Integer;
begin
 for I := 0 to Pred(fLocation.ActionsCount) do
 begin
  if fLocation[i].ActionType = atButton then
    TquideButtonAction(fLocation[i]).OnClick:= actEditButtonExecute;
  AddAction(fLocation[i]);
 end;
end;

procedure TquideLocationDialog.CreateHeader;
begin
 f_Header:= TPropertiesPanel.Create(Self);
 f_Header.LabelTop:= False;
 f_Header.Align:= alTop;
 f_Header.Parent:= WorkPanel;
 f_Header.Properties:= fLocation;
 f_Actions:= TPanel.Create(Self);
 f_Actions.Parent:= WorkPanel;
 f_Actions.Align:= alClient;
 f_Actions.Caption:= '';
end;

function TquideLocationDialog.Execute(aLocation: TquideLocation; theScenario: TquideScenario): Boolean;
begin
 Result:= False;
 f_Scenario:= theScenario;
 Location:= aLocation;
 if IsPositiveResult(ShowModal) then
 begin
   // Считать значения из окошка
   f_Header.GetValues;
   GetActionsValues;
   Result:= True;
 end;
end;

procedure TquideLocationDialog.GetActionsValues;
var
 i: Integer;
begin
 //  Прочитать значения действий
 //fLocation.Clear; - нельзя
 { TODO : Нужно реализовать }
 (* *)
 for i := 0 to f_Actions.ControlCount-1 do
 begin
   if f_Actions.Controls[i] is TPropertiesPanel then
    TPropertiesPanel(f_Actions.Controls[i]).GetValues;
 end;
 (* *)
end;

procedure TquideLocationDialog.SetLocation(const Value: TquideLocation);
var
 l_A: TquideActions;
begin
  FLocation := Value;
  Caption:= fLocation.Caption;
  // очистить текущее содержимое
  ClearControls;
  CreateHeader;
 (*
 with TPropertiesPanel.Create(Self) do
 begin
  Align:= alNone;
  Parent:= f_Actions;
  Width:= f_Actions.ClientWidth;
  Anchors:= Anchors + [akRight];
  Height:= 16;
  l_A:= TquideActions.Create;
  Properties:= l_A;
  PopupMenu:= l_A.Menu;
 end;
 *)
 CreateActions;
end;

end.
