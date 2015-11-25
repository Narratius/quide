unit quideLocationDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  quideLocations, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.ExtCtrls, PropertiesControls, Vcl.StdCtrls, quideActions;

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
    actEditButton: TAction;
    procedure actNewTextExecute(Sender: TObject);
    procedure actButtonExecute(Sender: TObject);
    procedure actEditButtonExecute(Sender: TObject);
  private
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
   function Execute(aLocation: TquideLocation): Boolean;
   property Location: TquideLocation read FLocation write SetLocation;
  end;


implementation

{$R *.dfm}

{ TForm1 }

procedure TquideLocationDialog.actButtonExecute(Sender: TObject);
var
 l_Loc: String;
 l_Act: TquideAction;
begin
 // Добавляем кнопку
 l_Loc:= '';
 if InputQuery('Выбор локации', 'Выберите локацию', l_Loc) then
 begin
  l_Act:= fLocation.AddAction(atButton);
  l_Act.AliasItems['Button'].Caption:= l_Loc;
  TquideButtonAction(l_Act).Values['Target']:= l_Loc;
  TquideButtonAction(l_Act).OnClick:= actEditButtonExecute;
  AddAction(l_Act);
 end;
end;

procedure TquideLocationDialog.actEditButtonExecute(Sender: TObject);
begin
 // Изменяем свойства кнопки
 ShowMessage('Click!');
end;

procedure TquideLocationDialog.actNewTextExecute(Sender: TObject);
begin
 // Добавляем текст
 AddAction(fLocation.AddAction(atText));
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
 l_Actions:= TPropertiesPanel.Create(Self);
 l_Actions.Align:= alNone;
 l_Actions.Parent:= f_Actions;
 l_Actions.Width:= f_Actions.ClientWidth;
 l_Actions.Properties:= aAction;
 l_Actions.Top:= l_Top;
 l_Actions.Tag:= aAction.Index;
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
  AddAction(fLocation[i]);
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

function TquideLocationDialog.Execute(aLocation: TquideLocation): Boolean;
begin
 Result:= False;
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
 //  Прочитать знаечения действий
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
begin
  FLocation := Value;
  Caption:= fLocation.Caption;
  // очистить текущее содержимое
  ClearControls;
  CreateHeader;
  CreateActions;
end;

end.
