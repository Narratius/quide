unit guiLocEditDlgEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuestModeler, ActnList, Menus, ExtCtrls, StdCtrls;

type
  TLocationEditExDlg = class(TForm)
    EditPlace: TScrollBox;
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
    TuneAction: TAction;
    N7: TMenuItem;
    Panel1: TPanel;
    OKButton: TButton;
    CancelButton: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    editCaption: TEdit;
    procedure FormDestroy(Sender: TObject);
    procedure AddTextExecute(Sender: TObject);
    procedure EditPlaceResize(Sender: TObject);
    procedure VarActionExecute(Sender: TObject);
  private
    f_EnableResize: Boolean;
    f_Location: TdcLocation;
    procedure ControlResize(Sender: TObject);
    procedure CreateAction(anAction: TdcAction);
    procedure CreateButton(anButton: TdcButtonAction);
    procedure GetLocationData;
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
  if Result then
   aLocation.Assign(Location)
 finally
  Free;
 end;
end;

procedure TLocationEditExDlg.FormDestroy(Sender: TObject);
begin
 f_Location.Free;
end;

procedure TLocationEditExDlg.AddTextExecute(Sender: TObject);
var
 l_A: TdcTextAction;
begin
 // Добавить фрем для редактирования текста
 l_A:= TdcTextAction.Create(f_Location.Model);
 f_Location.AddAction(l_A);
 CreateAction(l_A);
end;

procedure TLocationEditExDlg.ControlResize(Sender: TObject);
var
 i: Integer;
 l_Move: Boolean;
 l_Delta: Integer;
begin
 // Один из контролов изменился. Нужно сдвинуть вниз всех, стоящих за ним
 if f_EnableResize then
 begin
  l_Move:= False;
  l_Delta:= 0;
  for i:= 0 to EditPlace.ControlCount-1 do
  begin
   if l_Move then
    EditPlace.Controls[i].Top:= EditPlace.Controls[i].Top + l_Delta
   else
   if EditPlace.Controls[i] = Sender then
   begin
    l_Move:= True;
    if i < Pred(EditPlace.ControlCount) then
     l_Delta:= EditPlace.Controls[i].Top + EditPlace.Controls[i].Height - EditPlace.Controls[i+1].Top;
   end;
  end;
 end; 
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
    TVarActionFrame(l_Frame).Script:= f_Location.Model;
   end;
 end; // case

 l_Frame.Name:= 'Frame'+IntToStr(EditPlace.ControlCount);
 if EditPlace.ControlCount > 0 then
  l_Frame.Top:= EditPlace.Controls[Pred(EditPlace.ControlCount)].Top + EditPlace.Controls[Pred(EditPlace.ControlCount)].Height
 else
  l_Frame.Top:= 1;
 l_Frame.Width:= EditPlace.ClientWidth;
 l_Frame.Parent:= EditPlace;
 l_Frame.OnResize:= ControlResize;
end;

procedure TLocationEditExDlg.CreateButton(anButton: TdcButtonAction);
begin
  // TODO -cMM: TLocationEditExDlg.CreateButton default body inserted
end;

procedure TLocationEditExDlg.EditPlaceResize(Sender: TObject);
var
 i: Integer;
begin
 // Изменился размер - нужно поменять ширины контролам
 for i:= 0 to EditPlace.ControlCount-1 do
  EditPlace.Controls[i].Width:= EditPlace.ClientWidth;
end;

procedure TLocationEditExDlg.GetLocationData;
var
 i: Integer;
 l_A: TdcAction;
 l_LocName: string;
begin
 f_Location.Caption:= editCaption.Text;
 for i:= 0 to f_Location.ActionsCount-1 do
 begin
  l_A:= f_Location.Actions[i];
  case l_A.ActionType of
   atText: TdcTextAction(l_A).Description:= (EditPlace.Controls[i] as TdobTextFrame).TextMemo.Lines;
   atGoto:
    begin
     l_LocName:= TGotoActionFrame(EditPlace.Controls[i]).GotoLocation;
     TdcGotoAction(l_A).Location:= f_Location.Model.FindLocation(l_LocName);
    end;
   atVariable:
    with TdcVariableAction(l_A) do
    begin
     Variable:= TVarActionFrame(EditPlace.Controls[i]).Variable;
     Value:= TVarActionFrame(EditPlace.Controls[i]).Value;
    end;
  end;
 end;
end;

function TLocationEditExDlg.pm_GetLocation: TdcLocation;
begin
 GetLocationData;
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
 f_EnableResize:= False;
 while EditPlace.ControlCount > 0 do
 begin
  l_C:= EditPlace.Controls[0];
  EditPlace.RemoveControl(l_C);
  FreeAndNil(l_C);
 end; // while EditPlace.ControlCount > 0
 for I := 0 to f_Location.ActionsCount - 1 do
 begin
  if f_Location.Actions[i].ActionType = atButton then
   CreateButton(f_Location.Actions[i] as TdcButtonAction)
  else
   CreateAction(f_Location.Actions[i]);
 end;
 editCaption.Text:= f_Location.Caption;
 f_EnableResize:= True;
end;

procedure TLocationEditExDlg.VarActionExecute(Sender: TObject);
var
 l_A: TdcAction;
begin
 l_A:= TdcVariableAction.Create(f_Location.Model);
 f_Location.AddAction(l_A);
 CreateAction(l_A);
end;

end.
