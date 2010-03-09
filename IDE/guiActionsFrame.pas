unit guiActionsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ActnList, Menus, ExtCtrls, QuestModeler, Contnrs;

type
  TActionFrame = class(TFrame)
    EditPlace: TScrollBox;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    ActionList1: TActionList;
    TextAction: TAction;
    ButtonAction: TAction;
    VarAction: TAction;
    LogicAction: TAction;
    GotoAction: TAction;
    TuneAction: TAction;
    procedure AddTextExecute(Sender: TObject);
    procedure EditPlaceResize(Sender: TObject);
    procedure VarActionExecute(Sender: TObject);
  private
    f_ActionList: TObjectList;
    f_EnableResize: Boolean;
    f_Script: TdcScript;
    procedure ControlResize(Sender: TObject);
    procedure CreateAction(anAction: TdcAction);
    procedure CreateButton(anButton: TdcButtonAction);
    { Private declarations }
  public
    procedure GetLocationData;
    procedure RefreshList;
    property ActionList: TObjectList read f_ActionList write f_ActionList;
    property Script: TdcScript read f_Script write f_Script;
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses
 dobTextActionEdit, dobGotoAction, dobVarActionFrame;

procedure TActionFrame.AddTextExecute(Sender: TObject);
var
 l_A: TdcTextAction;
begin
 // Добавить фрейм для редактирования текста
 l_A:= TdcTextAction.Create(f_Script);
 f_ActionList.Add(l_A);
 CreateAction(l_A);
end;

procedure TActionFrame.ControlResize(Sender: TObject);
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

procedure TActionFrame.CreateAction(anAction: TdcAction);
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
    TGotoActionFrame(l_Frame).Model:= f_Script;
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
    TVarActionFrame(l_Frame).Script:= f_Script;
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

procedure TActionFrame.CreateButton(anButton: TdcButtonAction);
begin
  // TODO -cMM: TLocationEditExDlg.CreateButton default body inserted
end;

procedure TActionFrame.EditPlaceResize(Sender: TObject);
var
 i: Integer;
begin
 // Изменился размер - нужно поменять ширины контролам
 for i:= 0 to EditPlace.ControlCount-1 do
  EditPlace.Controls[i].Width:= EditPlace.ClientWidth;
end;

procedure TActionFrame.GetLocationData;
var
 i: Integer;
 l_A: TdcAction;
 l_LocName: string;
begin
 for i:= 0 to f_ActionList.Count-1 do
 begin
  l_A:= f_ActionList[i] as TdcAction;
  case l_A.ActionType of
   atText: TdcTextAction(l_A).Description:= (EditPlace.Controls[i] as TdobTextFrame).TextMemo.Lines;
   atGoto:
    begin
     l_LocName:= TGotoActionFrame(EditPlace.Controls[i]).GotoLocation;
     TdcGotoAction(l_A).Location:= f_Script.FindLocation(l_LocName);
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

procedure TActionFrame.RefreshList;
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
 end; // while f_ActionFrame.EditPlace.ControlCount > 0
 for I := 0 to f_ActionList.Count - 1 do
 begin
  if TdcAction(f_ActionList[i]).ActionType = atButton then
   CreateButton(f_ActionList[i] as TdcButtonAction)
  else
   CreateAction(f_ActionList[i] as TdcAction);
 end;
 f_EnableResize:= True;
end;

procedure TActionFrame.VarActionExecute(Sender: TObject);
var
 l_A: TdcAction;
begin
 l_A:= TdcVariableAction.Create(f_Script);
 f_ActionList.Add(l_A);
 CreateAction(l_A);
end;

end.
