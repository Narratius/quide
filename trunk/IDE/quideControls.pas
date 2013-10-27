unit quideControls;

interface
Uses
 QuestModeler,
 ParamControls, SizeableControls,
 Forms, ExtCtrls, Classes, Menus, Propertys, Controls;

type
 TqcActionPanel = class(TControlPanel)
 private
  f_Action: TdcAction;
  procedure pm_SetAction(Value: TdcAction);
 protected
  function GetActionControls: TControlsArray;
 public
  property Action : TdcAction
   read f_Action
   write pm_SetAction;
 end;

 TqcActionsScrollBox = class(TSizeableScrollBox)
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
  procedure InsertButtonAction(Sender: TObject);
  procedure InsertGotoAction(Sender: TObject);
  procedure InsertLogicAction(Sender: TObject);
  procedure InsertTextAction(Sender: TObject);
  procedure InsertVarAction(Sender: TObject);
 public
  constructor Create(aOwner: TComponent); override;
  procedure Add(aAction: TdcAction);
  property Actions: TdcActionList
   read f_Actions
   write pm_SetActions;
  property Script: TdcScript
   read f_Script
   write f_Script;
 published
 end;

type
  IPropertyControlValue = interface(IInterface)
    ['{7660D972-81B7-4062-AF86-4517B58AA55E}']
    function pm_GetValue: Variant; stdcall;
    procedure pm_SetValue(const Value: Variant); stdcall;
    property Value: Variant read pm_GetValue write pm_SetValue;
  end;

implementation

Uses
 SysUtils, StdCtrls, Graphics, SizeableTypes;

{ TqcActionsScrollBox }

constructor TqcActionsScrollBox.Create(aOwner: TComponent);
begin
 inherited;
 f_PopUpMenu:= TPopupMenu.Create(Self);
 BuildMenu;
 PopupMenu:= f_PopupMenu;
 f_Actions:= TdcActionList.Create;
 Color:= clTeal;
 BorderStyle:= bsSingle;
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
  AddControl(l_Panel, csAutoSize, cpNewLine);
  l_Panel.Action:= aAction;
  l_Panel.Name:= l_Panel.ClassName + IntToStr(Succ(ControlCount));
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

function TqcActionPanel.GetActionControls: TControlsArray;
var
 i: Integer;
begin
 case Action.ActionType of
  atNone: SetLength(Result, 0);
  atGoto: ;
  atInventory: ;
  atLogic: ;
  atText:
   begin
    SetLength(Result, Action.Count);
    //Action.IterateAll(); !!!  потом вернуть
    for i:= 0 to Action.Count-1 do
    begin
     Result[i]:= cDefControlRec;
     Result[i].ControlClass:= Property2Control(Action.Items[i].PropertyType); !!! Потом вернуть
    end;
   end;
  atVariable: ;
  atButton: ;
 end; // case Action.ActionType
end;

procedure TqcActionPanel.pm_SetAction(Value: TdcAction);
begin
 f_Action:= Value;
 CreateControls(GetActionControls);
end;

end.
