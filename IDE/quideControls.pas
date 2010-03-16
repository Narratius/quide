unit quideControls;

interface
Uses
 QuestModeler,
 PropertiesControls,
 Forms, ExtCtrls;

type
 TqcActionPanel = class(TPropertiesPanel)
 private
  f_Action: TdcAction;
  procedure pm_SetAction(Value: TdcAction);
 public
  property Action : TdcAction
   read f_Action
   write pm_SetAction;
 end;

 TqcActionsScrollBox = class(TScrollBox)
 private
  f_Actions: TdcActionList;
  f_Script: TdcScript;
  procedure pm_SetActions(aValue: TdcActionList);
  procedure ClearActionControls;
  procedure CreateActionControls;
  procedure CreateOneControl(aAction: TdcAction);
    procedure ControlResize(Sender: TObject);
    procedure EditPlaceResize(Sender: TObject);
 public
  procedure Add(aAction: TdcAction);
  property Actions: TdcActionList
   read f_Actions
   write pm_SetActions;
  property Script: TdcScript
   read f_Script
   write f_Script;
 end;


implementation

Uses
 SysUtils, Controls;

{ TqcActionsScrollBox }

procedure TqcActionsScrollBox.Add(aAction: TdcAction);
begin
 Actions.Add(aAction);
 CreateOneControl(aAction);
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
 f_Actions:= aValue;
 ClearActionControls;
 CreateActionControls;
end;

procedure TqcActionsScrollBox.ControlResize(Sender: TObject);
var
 i: Integer;
 l_Move: Boolean;
 l_Delta: Integer;
begin
 // ќдин из контролов изменилс€. Ќужно сдвинуть вниз всех, сто€щих за ним
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

procedure TqcActionsScrollBox.EditPlaceResize(Sender: TObject);
var
 i: Integer;
begin
 // »зменилс€ размер - нужно помен€ть ширины контролам
 for i:= 0 to EditPlace.ControlCount-1 do
  EditPlace.Controls[i].Width:= EditPlace.ClientWidth;
end;

{ TqcActionPanel }

procedure TqcActionPanel.pm_SetAction(Value: TdcAction);
begin
 f_Action:= Value;
 Properties:= f_Action.Properties;
end;

end.
