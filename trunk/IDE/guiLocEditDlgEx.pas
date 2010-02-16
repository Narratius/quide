unit guiLocEditDlgEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuestModeler, ActnList, Menus, ExtCtrls;

type
  TLocationEditExDlg = class(TForm)
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    AddText: TAction;
    AddVarAction: TAction;
    AddLogic: TAction;
    AddButton: TAction;
    AddInventory: TAction;
    EditPanel: TPanel;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    procedure AddTextExecute(Sender: TObject);
  private
    f_Location: TdcLocation;
    procedure CreateAction(anAction: TdcAction);
    procedure CreateButton(anButton: TdcButtonAction);
    function pm_GetLocation: TdcLocation;
    procedure pm_SetLocation(const Value: TdcLocation);
    procedure RefreshList;
    { Private declarations }
  public
    property Location: TdcLocation read pm_GetLocation write pm_SetLocation;
    { Public declarations }
  end;

function EditLocationEx(aLocation: TdcLocation): Boolean;

var
  Form1: TLocationEditExDlg;

implementation

uses dobTextActionEdit, dobGotoAction, dobVarActionFrame, StrUtils;

{$R *.dfm}

function EditLocationEx(aLocation: TdcLocation): Boolean;
begin
 Result := False;
 with TLocationEditExDlg.Create(nil) do
 try
  Location:= aLocation;
  Result:= IsPositiveResult(ShowModal);
 finally
  Free;
 end;
end;

procedure TLocationEditExDlg.AddTextExecute(Sender: TObject);
var
 l_A: TdcTextAction;
begin
 // Добавить фрем для редактирования текста
 l_A:= TdcTextAction.Create(Location.Model);
 Location.AddAction(l_A);
 CreateAction(l_A);
end;

procedure TLocationEditExDlg.CreateAction(anAction: TdcAction);
var
 l_Frame: TFrame;
begin
 case anAction.ActionType of
  atText:
   begin
    l_Frame:= TDobTextFrame.Create(nil);
    TDobTextFrame(l_Frame).TextMemo.Lines:= TdcTextAction(anAction).Description;
   end;
  atGoto:
   begin
    l_Frame:= TGotoActionFrame.Create(nil);
    TGotoActionFrame(l_Frame).Model:= f_Location.Model;
    if TdcGotoAction(anAction).Location <> nil then
     TGotoActionFrame(l_Frame).GotoLocation:= TdcGotoAction(anAction).Location.Caption;
   end;
  atVariable:
   begin
    l_Frame:= TVarActionFrame.Create(nil);
    if TdcVariableAction(anAction).Variable <> nil then
     TVarActionFrame(l_Frame).Variable:= TdcVariableAction(anAction).Variable;
    TVarActionFrame(l_Frame).Value:= TdcVariableAction(anAction).Value;
    TVarActionFrame(l_Frame).Script:= Location.Model;
   end;
 end; // case
 l_Frame.Name:= 'Frame'+IntToStr(EditPanel.ControlCount);
 if EditPanel.ControlCount > 0 then
  l_Frame.Top:= EditPanel.Controls[Pred(EditPanel.ControlCount)].Top + EditPanel.Controls[Pred(EditPanel.ControlCount)].Height
 else
  l_Frame.Top:= 1;
 l_Frame.Width:= EditPanel.ClientWidth;
 l_Frame.Parent:= EditPanel;
end;

procedure TLocationEditExDlg.CreateButton(anButton: TdcButtonAction);
begin
  // TODO -cMM: TLocationEditExDlg.CreateButton default body inserted
end;

function TLocationEditExDlg.pm_GetLocation: TdcLocation;
begin
  // TODO -cMM: TLocationEditExDlg.pm_GetLocation default body inserted
  Result := f_Location;
end;

procedure TLocationEditExDlg.pm_SetLocation(const Value: TdcLocation);
begin
 f_Location := Value.Clone(Value.Model);
 //editCaption.Text:=
 Caption:= IfThen(f_Location.Caption = '', 'Новая локация', f_Location.Caption);
 RefreshList();
end;

procedure TLocationEditExDlg.RefreshList;
var
  I: Integer;
  l_C: TControl;
begin
 while EditPanel.ControlCount > 0 do
 begin
  l_C:= EditPanel.Controls[0];
  EditPanel.RemoveControl(l_C);
  FreeAndNil(l_C);
 end; // while EditPanel.ControlCount > 0
 for I := 0 to Location.ActionsCount - 1 do
 begin
  if Location.Actions[i].ActionType = atButton then
  begin
   CreateButton(Location.Actions[i] as TdcButtonAction);
  end
  else
   CreateAction(Location.Actions[i]);
 end;
end;

end.
