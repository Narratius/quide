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

 TqcActionsListPanel = class(TScrollBox)
 private
    f_Actions: TdcActionList;
  procedure pm_SetActions(aValue: TdcActionList);
  procedure ClearActionControls;
  procedure CreateActionControls;
 public
  property Actions: TdcActionList
   read f_Actions
   write pm_SetActions;
 end;


implementation

Uses
 SysUtils, Controls;

{ TqcActionsListPanel }

procedure TqcActionsListPanel.ClearActionControls;
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

procedure TqcActionsListPanel.CreateActionControls;
var
 i: Integer;
 l_Panel: TqcActionPanel;
begin
 for i:= 0 to Actions.Count - 1 do
 begin
  l_Panel:= TqcActionPanel.Create(Self);
  l_Panel.Action:= Actions[i];
  if ControlCount > 0 then
   l_Panel.Top:= Controls[Pred(ControlCount)].Top + Controls[Pred(ControlCount)].Height
  else
   l_Panel.Top:= 1;
  l_Panel.Name:= l_Panel.ClassName + IntToStr(Succ(ControlCount));
  InsertControl(l_Panel);
 end;
end;

procedure TqcActionsListPanel.pm_SetActions(aValue: TdcActionList);
begin
 f_Actions:= aValue;
 ClearActionControls;
 CreateActionControls;
end;

{ TqcActionPanel }

procedure TqcActionPanel.pm_SetAction(Value: TdcAction);
begin
 f_Action:= Value;
 Properties:= f_Action.Properties;
end;

end.
