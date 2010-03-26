unit quideControls;

interface
Uses
 QuestModeler,
 PropertiesControls,
 Forms, ExtCtrls, Classes, Menus, Propertys;

type
 TqcActionPanel = class(TPropertiesPanel)
 private
  f_Action: TdcAction;
  procedure pm_SetAction(Value: TdcAction);
 public
  procedure GetControls(aProp: TProperty; var l_Controls: TControlsArray); override;
  property Action : TdcAction
   read f_Action
   write pm_SetAction;
 end;

 TqcActionsScrollBox = class(TScrollBox)
 private
  f_Actions: TdcActionList;
  f_EnableResize: Boolean;
  f_PopUpMenu: TPopUpMenu;
  f_Script: TdcScript;
  procedure BuildMenu;
  procedure pm_SetActions(aValue: TdcActionList);
  procedure ClearActionControls;
  procedure CreateActionControls;
  procedure CreateOneControl(aAction: TdcAction);
  procedure ControlResize(Sender: TObject);
  procedure InsertButtonAction(Sender: TObject);
  procedure InsertGotoAction(Sender: TObject);
  procedure InsertLogicAction(Sender: TObject);
  procedure InsertTextAction(Sender: TObject);
  procedure InsertVarAction(Sender: TObject);
 public
  constructor Create(aOwner: TComponent); override;
  procedure Add(aAction: TdcAction);
  procedure SelfResize(Sender: TObject);
  property Actions: TdcActionList
   read f_Actions
   write pm_SetActions;
  property Script: TdcScript
   read f_Script
   write f_Script;
 end;


implementation

Uses
 SysUtils, Controls, StdCtrls;

{ TqcActionsScrollBox }

constructor TqcActionsScrollBox.Create(aOwner: TComponent);
begin
 inherited;
 Constraints.MinHeight:= 24;
 Constraints.MinWidth:= 100;
 //AutoSize:= True;
 OnResize:= SelfResize;
 f_PopUpMenu:= TPopupMenu.Create(Self);
 BuildMenu;
 PopupMenu:= f_PopupMenu;
 f_Actions:= TdcActionList.Create;
end;

procedure TqcActionsScrollBox.Add(aAction: TdcAction);
begin
 Actions.Add(aAction);
 CreateOneControl(aAction);
end;

procedure TqcActionsScrollBox.BuildMenu;
var
 l_M: TMenuItem;
begin
 l_M:= TMenuItem.Create(Self);
 l_M.Name:= 'M1';
 l_M.Caption:= 'Текст';
 l_M.OnClick:= InsertTextAction;
 f_PopupMenu.Items.Add(l_M);
 l_M:= TMenuItem.Create(Self);
 l_M.Name:= 'M2';
 l_M.Caption:= 'Переменная';
 l_M.OnClick:= InsertVarAction;
 f_PopupMenu.Items.Add(l_M);
 l_M:= TMenuItem.Create(Self);
 l_M.Name:= 'M3';
 l_M.Caption:= 'Условие';
 l_M.OnClick:= InsertLogicAction;
 f_PopupMenu.Items.Add(l_M);
 l_M:= TMenuItem.Create(Self);
 l_M.Name:= 'M4';
 l_M.Caption:= 'Переход';
 l_M.OnClick:= InsertGotoAction;
 f_PopupMenu.Items.Add(l_M);
 l_M:= TMenuItem.Create(Self);
 l_M.Name:= 'M5';
 l_M.Caption:= 'Кнопка';
 l_M.OnClick:= InsertButtonAction;
 f_PopupMenu.Items.Add(l_M);
 l_M:= TMenuItem.Create(Self);
 l_M.Name:= 'M6';
 l_M.Caption:= '-';
 f_PopupMenu.Items.Add(l_M);
 l_M:= TMenuItem.Create(Self);
 l_M.Name:= 'M7';
 l_M.Caption:= 'Упорядочить';
 //l_M.OnClick:=
 f_PopupMenu.Items.Add(l_M);
end;

procedure TqcActionsScrollBox.ClearActionControls;
var
 l_C: TControl;
begin
 while ControlCount > 0 do
 begin
  l_C:= Controls[0];
  RemoveControl(l_C);
  FreeAndNil(l_C);
 end;
end;


procedure TqcActionsScrollBox.CreateOneControl(aAction: TdcAction);
var
 l_Panel: TqcActionPanel;
begin
  l_Panel:= TqcActionPanel.Create(Self);
  l_Panel.Action:= aAction;
  if ControlCount > 0 then
   l_Panel.Top:= Controls[Pred(ControlCount)].Top + Controls[Pred(ControlCount)].Height
  else
   l_Panel.Top:= 1;
  l_Panel.Name:= l_Panel.ClassName + IntToStr(Succ(ControlCount));
  l_Panel.Width:= ClientWidth;
  l_Panel.OnResize:= ControlResize;
  ClientHeight:= l_Panel.Top + l_Panel.Height + 4;
  InsertControl(l_Panel);
end;

procedure TqcActionsScrollBox.CreateActionControls;
var
 i: Integer;
begin
 for i:= 0 to Actions.Count - 1 do
  CreateOneControl(Actions[i]);
end;

procedure TqcActionsScrollBox.pm_SetActions(aValue: TdcActionList);
begin
 f_EnableResize:= False;
 try
  f_Actions.Assign(aValue);
  ClearActionControls;
  CreateActionControls;
 finally
  f_EnableResize:= True;
 end;
end;

procedure TqcActionsScrollBox.ControlResize(Sender: TObject);
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
  for i:= 0 to ControlCount-1 do
  begin
   if l_Move then
    Controls[i].Top:= Controls[i].Top + l_Delta
   else
   if Controls[i] = Sender then
   begin
    l_Move:= True;
    if i < Pred(ControlCount) then
     l_Delta:= Controls[i].Top + Controls[i].Height - Controls[i+1].Top;
   end;
   if Controls[i] is TPropertiesPanel then
    TPropertiesPanel(Controls[i]).ResizeControls;
  end;
 end;
end;

procedure TqcActionsScrollBox.InsertButtonAction(Sender: TObject);
begin
 Add(TdcButtonAction.Create(Script));
end;

procedure TqcActionsScrollBox.InsertGotoAction(Sender: TObject);
begin
 Add(TdcGotoAction.Create(Script));
end;

procedure TqcActionsScrollBox.InsertLogicAction(Sender: TObject);
begin
 Add(TdcLogicAction.Create(Script));
end;

procedure TqcActionsScrollBox.InsertTextAction(Sender: TObject);
begin
 Add(TdcTextAction.Create(Script));
end;

procedure TqcActionsScrollBox.InsertVarAction(Sender: TObject);
begin
 Add(TdcVariableAction.Create(Script));
end;

procedure TqcActionsScrollBox.SelfResize(Sender: TObject);
var
 i: Integer;
begin
 for i:= 0 to ControlCount-1 do
 begin
  Controls[i].Width:= ClientWidth;
  (Controls[i] as TqcActionPanel).ControlResize(Self);
 end;
end;

procedure TqcActionPanel.GetControls(aProp: TProperty; var l_Controls: TControlsArray);
var
 i: Integer;
begin
 inherited;
 if Length(l_Controls) = 0 then
 begin
  if aProp.Caption <> '' then
  begin
   SetLength(l_Controls, 2);
   l_Controls[0].ControlClass:= TLabel;
  end
  else
   SetLength(l_Controls, 1);
  i:= Pred(Length(l_Controls));
  case aProp.PropertyType of
   ptButton : l_Controls[i].ControlClass:= TButton;
   ptTextWitButton: l_Controls[i].ControlClass:= TButton;
   ptActions: l_Controls[i].ControlClass:= TqcActionsScrollBox;
  end;
 end;
end;

{ TqcActionPanel }

procedure TqcActionPanel.pm_SetAction(Value: TdcAction);
begin
  f_Action:= Value;
  Properties:= f_Action.Properties;
end;

end.
