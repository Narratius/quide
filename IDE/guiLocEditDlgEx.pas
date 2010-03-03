unit guiLocEditDlgEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuestModeler, ActnList, Menus, ExtCtrls, StdCtrls;

type
  TLocationEditExDlg = class(TForm)
    EditPlace: TScrollBox;
    OKButton: TButton;
    CancelButton: TButton;
    ActionList1: TActionList;
    PopupMenu1: TPopupMenu;
    TextAction: TAction;
    ButtonAction: TAction;
    VarAction: TAction;
    LogicAction: TAction;
    GotoAction: TAction;
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
    begin
     TVarActionFrame(l_Frame).Variable:= TdcVariableAction(anAction).Variable;
     TVarActionFrame(l_Frame).Value:= TdcVariableAction(anAction).Value;
    end; // TdcVariableAction(anAction).Variable <> nil
    TVarActionFrame(l_Frame).Script:= Location.Model;
   end;
 end; // case

 l_Frame.Name:= 'Frame'+IntToStr(EditPlace.ControlCount);
 if EditPlace.ControlCount > 0 then
  l_Frame.Top:= EditPlace.Controls[Pred(EditPlace.ControlCount)].Top + EditPlace.Controls[Pred(EditPlace.ControlCount)].Height
 else
  l_Frame.Top:= 1;
 l_Frame.Width:= EditPlace.ClientWidth;
 l_Frame.Parent:= EditPlace;
end;

procedure TLocationEditExDlg.CreateButton(anButton: TdcButtonAction);
begin
  // TODO -cMM: TLocationEditExDlg.CreateButton default body inserted
end;

function TLocationEditExDlg.pm_GetLocation: TdcLocation;
begin
  // TODO перебрать элементы и обновить значения действий
  Result := f_Location;
end;

procedure TLocationEditExDlg.pm_SetLocation(const Value: TdcLocation);
begin
 f_Location := Value.Clone(Value.Model);
 Caption:= IfThen(f_Location.Caption = '', 'Новая локация', f_Location.Caption);
 RefreshList();
end;

procedure TLocationEditExDlg.RefreshList;
var
  I: Integer;
  l_C: TControl;
begin

 while EditPlace.ControlCount > 0 do
 begin
  l_C:= EditPlace.Controls[0];
  EditPlace.RemoveControl(l_C);
  FreeAndNil(l_C);
 end; // while EditPlace.ControlCount > 0
 for I := 0 to Location.ActionsCount - 1 do
 begin
  if Location.Actions[i].ActionType = atButton then
   CreateButton(Location.Actions[i] as TdcButtonAction)
  else
   CreateAction(Location.Actions[i]);
 end;

end;

end.
