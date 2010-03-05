unit guiLocEditDlg;

interface

uses
 Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
 Buttons, ExtCtrls,
 QuestModeler, Menus, ComCtrls, ToolWin, ActnList, ImgList, ListBoxOnChangeU;

type
  TLocationDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    editCaption: TEdit;
    ActionsPanel: TPanel;
    EditPanel: TPanel;
    ToolBar1: TToolBar;
    Label3: TLabel;
    ToolButton1: TToolButton;
    TypeDropDown: TPopupMenu;
    ToolButton2: TToolButton;
    N1: TMenuItem;
    N2: TMenuItem;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ActionList1: TActionList;
    TextAction: TAction;
    DelAction: TAction;
    MoveUpAction: TAction;
    MoveDownAction: TAction;
    NewAction: TAction;
    GotoAction: TAction;
    ImageList1: TImageList;
    InventaryAction: TAction;
    VariableAction: TAction;
    LogicalAction: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Panel1: TPanel;
    ToolBar2: TToolBar;
    Label2: TLabel;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ButtonsListBox: TListBox;
    ButtonsPanel: TPanel;
    ButtonAction: TAction;
    ButtonDelete: TAction;
    ButtonUp: TAction;
    ButtonDown: TAction;
    treeActions: TTreeView;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActionListBoxClick(Sender: TObject);
    procedure ActionListBoxDblClick(Sender: TObject);
    procedure ButtonActionExecute(Sender: TObject);
    procedure ButtonsListBoxClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure editCaptionChange(Sender: TObject);
    procedure GotoActionExecute(Sender: TObject);
    procedure MoveDownActionExecute(Sender: TObject);
    procedure MoveUpActionExecute(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TextActionExecute(Sender: TObject);
    procedure treeActionsChange(Sender: TObject; Node: TTreeNode);
    procedure VariableActionExecute(Sender: TObject);
  private
    { Public declarations }
    f_Location: TdcLocation;
    procedure AddAction(aAction: TdcActionClass);
    procedure AddAction2ListBox(aAction: TdcAction);
    procedure AddButton2ListBox(aAction: TdcAction);
    procedure ClearEditFrame;
    procedure GetButtonData(Index: Integer; aList: TStrings);
    procedure ButtonsIndexChange(Sender: TObject; OldIndex, NewIndex: Integer);
    procedure GetActionData;
    procedure OnCaptionEdit(Sender: TObject);
    procedure pm_SetLocation(const Value: TdcLocation);
    procedure RefreshList;
    { Private declarations }
  public
    property Location: TdcLocation read f_Location write pm_SetLocation;
  end;

var
  LocationDlg: TLocationDlg;

function EditLocation(aLocation: TdcLocation; theModel: TdcScript): Boolean;

implementation

{$R *.dfm}

Uses
 StrUtils, Contnrs,
 guiActionListDlg, guiActionEditDlg, Dialogs, dobTextActionEdit, dobGotoAction, dobButtonAction,
 dobVarActionFrame;

function EditLocation(aLocation: TdcLocation; theModel: TdcScript): Boolean;
var
 l_Dlg: TLocationDlg;
begin
 // нужно редактировать копию, иначе не отработает Cancel
 l_Dlg:= TLocationDlg.Create(nil);
 try
  l_Dlg.Location:= aLocation;
  Result:= IsPositiveResult(l_Dlg.ShowModal);
  if Result then
   aLocation.Assign(l_dlg.Location);
 finally
  l_Dlg.Free;
 end;
end;

procedure TLocationDlg.FormDestroy(Sender: TObject);
begin
 f_Location.Free;
end;

procedure TLocationDlg.FormCreate(Sender: TObject);
begin
 //ActionListBox.OnChange:= ActionListBoxClick;
 //ActionListBox.OnItemIndexChange:= IndexChange;
 ButtonsListBox.OnChange:= ButtonsListBoxClick;
 ButtonsListBox.OnItemIndexChange:= ButtonsIndexChange;
end;

procedure TLocationDlg.ActionListBoxClick(Sender: TObject);
begin
 MoveUpAction.Enabled:= treeActions.Items.Count > 0;//ActionListBox.ItemIndex > 0;
 MOveDownAction.Enabled:= treeActions.Selected.Index < Pred(treeActions.Items.Count);//ActionListBox.ItemIndex < Pred(ActionListBox.Items.Count);
 DelAction.Enabled:= treeActions.Selected <> nil;
 // Синхронизация с редактированием
 if (f_Location <> nil) and (treeActions.selected <> nil) then
 begin
  EditPanel.Controls[treeActions.selected.Index].Show;
 end; // f_Location
end;

procedure TLocationDlg.ActionListBoxDblClick(Sender: TObject);
var
 l_S: String;
begin
 // Редактирование названия
 l_S:= treeActions.Selected.Text;
 if InputQuery('название действия', 'Введите название', l_S) then
 begin
  treeActions.Selected.Text:= l_S;
  TdcAction(treeActions.Selected.Data).Caption:= l_S;
 end;
end;

procedure TLocationDlg.AddAction(aAction: TdcActionClass);
var
 l_A: TdcAction;
 l_LocName: string;
begin
 GetActionData;
 l_A:= aAction.Create(f_Location.Script);
 f_Location.AddAction(l_A);
 AddAction2ListBox(l_A);
end;

procedure TLocationDlg.AddAction2ListBox(aAction: TdcAction);
var
 l_Frame: TFrame;
 l_Node: TTreeNode;
begin
 l_Node:= TTreeNode.Create(treeActions.Items);
 treeActions.Items.AddChildObject(nil, aAction.Caption, aAction);
 if aAction is TdcTextAction then
 begin
  l_Frame:= TDobTextFrame.Create(nil);
  TDobTextFrame(l_Frame).TextMemo.Lines:= TdcTextAction(aAction).Description;
 end
 else
 if aAction is TdcGotoAction then
 begin
  l_Frame:= TGotoActionFrame.Create(nil);
  TGotoActionFrame(l_Frame).Model:= f_Location.Script;
  if TdcGotoAction(aAction).Location <> nil then
   TGotoActionFrame(l_Frame).GotoLocation:= TdcGotoAction(aAction).Location.Caption;
 end
 else
 if aAction is TdcVariableAction then
 begin
  l_Frame:= TVarActionFrame.Create(nil);
  if TdcVariableAction(aAction).Variable <> nil then
   TVarActionFrame(l_Frame).Variable:= TdcVariableAction(aAction).Variable;
  TVarActionFrame(l_Frame).Value:= TdcVariableAction(aAction).Value;
  TVarActionFrame(l_Frame).Script:= Location.Script;
 end;
 l_Frame.Name:= 'Frame'+IntToStr(EditPanel.ControlCount);
 l_Frame.Parent:= EditPanel;
 l_Frame.Hide;
end;

procedure TLocationDlg.AddButton2ListBox(aAction: TdcAction);
var
 l_Frame: TFrame;
begin
 ButtonsListBox.Items.AddObject(aAction.Caption, aAction);
 if aAction is TdcButtonAction then
 begin
  l_Frame:= TButtonFrame.Create(nil);
  TButtonFrame(l_Frame).editCaption.Text:= TdcButtonAction(aAction).Caption;
  TButtonFrame(l_Frame).Script:= f_Location.Script;
  if TdcButtonAction(aAction).Location <> nil then
   TButtonFrame(l_Frame).GotoLocation:= TdcButtonAction(aAction).Location.Caption;
  l_Frame.Name:= 'Frame'+IntToStr(ButtonsPanel.ControlCount);
  l_Frame.Parent:= ButtonsPanel;
  l_Frame.Hide;
 end;
end;

procedure TLocationDlg.ButtonActionExecute(Sender: TObject);
var
 l_A: TdcAction;
begin
 if ButtonsListBox.ItemIndex <> -1 then
  GetButtonData(ButtonsListBox.ItemIndex, ButtonsListBox.Items);
 l_A:= TdcButtonAction.Create(f_Location.Script);
 f_Location.AddAction(l_A);
 AddButton2ListBox(l_A);
end;

procedure TLocationDlg.ButtonsListBoxClick(Sender: TObject);
var
 l_Frame: TFrame;
begin
 ButtonUp.Enabled:= ButtonsListBox.ItemIndex > 0;
 ButtonDown.Enabled:= ButtonsListBox.ItemIndex < Pred(ButtonsListBox.Items.Count);
 ButtonDelete.Enabled:= ButtonsListBox.ItemIndex <> -1;
 // Синхронизация с редактированием
 if (f_Location <> nil) and (ButtonsListBox.ItemIndex <> -1) then
 begin
  ButtonsPanel.Controls[ButtonsListBox.ItemIndex].Show;
 end; // f_Location
end;

procedure TLocationDlg.ClearEditFrame;
var
 i: Integer;
begin
 for i:= Pred(EditPanel.ControlCount) downto 0 do
  EditPanel.Controls[i].Free;
end;

procedure TLocationDlg.DelButtonClick(Sender: TObject);
begin
 if IsPositiveResult(MessageDlg('Вы уверены, что хотите удалить действие '+ treeActions.Selected.Text, mtConfirmation, [mbYes, mbNo], 0)) then
 begin
  Location.ActionList.Delete(treeActions.Selected.Index);
  RefreshList;
 end;
end;

procedure TLocationDlg.editCaptionChange(Sender: TObject);
begin
 f_Location.Caption:= editCaption.Text;
end;

procedure TLocationDlg.GetButtonData(Index: Integer; aList: TStrings);
var
 l_LocName: String;
 l_A: TdcAction;
begin
 l_A:= aList.Objects[Index] as TdcAction;
 case l_A.ActionType of
  atText: TdcTextAction(l_A).Description:= (EditPanel.Controls[Index] as TdobTextFrame).TextMemo.Lines;
  atGoto:
   begin
    l_LocName:= TGotoActionFrame(EditPanel.Controls[Index]).GotoLocation;
    TdcGotoAction(l_A).Location:= f_Location.Script.FindLocation(l_LocName);
    aList.Strings[Index]:= TdcGotoAction(l_A).Caption;
   end;
  atButton:
   begin
    TdcButtonAction(l_A).Caption:= TButtonFrame(ButtonsPanel.Controls[Index]).editCaption.Text;
    l_LocName:= TButtonFrame(ButtonsPanel.Controls[Index]).GotoLocation;
    TdcButtonAction(l_A).Location:= f_Location.Script.FindLocation(l_LocName);
    aList.Strings[Index]:= TdcButtonAction(l_A).Caption;
   end;
 end;

 if l_A is TdcButtonAction then
  ButtonsPanel.Controls[Index].Hide
 else
  EditPanel.Controls[Index].Hide;
end;

procedure TLocationDlg.GotoActionExecute(Sender: TObject);
begin
 AddAction(TdcGotoAction);
end;

procedure TLocationDlg.ButtonsIndexChange(Sender: TObject; OldIndex, NewIndex: Integer);
begin
 // Нужно забрать данные из текущего элемента
 if OldIndex <> -1 then
 begin
  GetButtonData(OldIndex, ButtonsListBox.Items);
 end;
end;

procedure TLocationDlg.GetActionData;
var
 l_A: TdcAction;
 l_LocName: string;
begin
 if treeActions.Selected <> nil then
 begin
  l_A:= TdcAction(treeActions.Selected.Data);
  case l_A.ActionType of
   atText: TdcTextAction(l_A).Description:= (EditPanel.Controls[treeActions.Selected.Index] as TdobTextFrame).TextMemo.Lines;
   atGoto:
    begin
     l_LocName:= TGotoActionFrame(EditPanel.Controls[treeActions.Selected.Index]).GotoLocation;
     TdcGotoAction(l_A).Location:= f_Location.Script.FindLocation(l_LocName);
     treeActions.Selected.Text:= TdcGotoAction(l_A).Caption;
    end;
   atVariable:
    with TdcVariableAction(l_A) do
    begin
     Variable:= TVarActionFrame(EditPanel.Controls[treeActions.Selected.Index]).Variable;
     Value:= TVarActionFrame(EditPanel.Controls[treeActions.Selected.Index]).Value;
    end;
  end;
 end;
end;

procedure TLocationDlg.MoveDownActionExecute(Sender: TObject);
var
 l_Index: Integer;
begin
 // Переместить действие вниз
 l_Index:= Succ(treeActions.Selected.Index);
 Location.ActionList.Move(treeActions.Selected.Index, l_Index);
 RefreshList;
 // Установить подсветку
end;

procedure TLocationDlg.MoveUpActionExecute(Sender: TObject);
var
 l_Index: Integer;
begin
 // Переместить действие вверх
 l_Index:= Pred(treeActions.Selected.Index);
 Location.ActionList.Move(l_Index, treeActions.Selected.Index);
 RefreshList;
 //ActionListBox.ItemIndex:= l_Index;
end;

procedure TLocationDlg.OKBtnClick(Sender: TObject);
begin
 GetActionData;
 if ButtonsListBox.ItemIndex <> -1 then
  GetButtonData(ButtonsListBox.ItemIndex, ButtonsListBox.Items);
end;

procedure TLocationDlg.OnCaptionEdit(Sender: TObject);
begin

end;

procedure TLocationDlg.pm_SetLocation(const Value: TdcLocation);
begin
 f_Location := Value.Clone(Value.Script);
 editCaption.Text:= IfThen(f_Location.Caption = '', 'Новая локация', f_Location.Caption);
 Caption:= editCaption.Text;
 RefreshList();
end;

procedure TLocationDlg.RefreshList;
var
  I: Integer;
  l_C: TControl;
begin
 treeActions.Items.Clear;
 ButtonsListBox.Items.Clear;
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
  //if ButtonsListBox.Items.IndexOf(Location.Actions[i].Caption) = -1 then
   AddButton2ListBox(Location.Actions[i]);
  end
  else
  //if ActionListBox.Items.IndexOf(Location.Actions[i].Caption) = -1 then
   AddAction2ListBox(Location.Actions[i]);
 end;
 //ActionListBox.ItemIndex:= 0;
 ButtonsListBox.ItemIndex:= 0;
end;

procedure TLocationDlg.TextActionExecute(Sender: TObject);
begin
 AddAction(TdcTextAction);
end;

procedure TLocationDlg.treeActionsChange(Sender: TObject; Node: TTreeNode);
var
 l_Frame: TFrame;
begin
// TTreeView(Sender).Selected - старый узел
// Node - новый узел
 GetActionData;
 MoveUpAction.Enabled:= treeActions.Items.Count > 0;//ActionListBox.ItemIndex > 0;
 MOveDownAction.Enabled:= treeActions.Selected.Index < Pred(treeActions.Items.Count);//ActionListBox.ItemIndex < Pred(ActionListBox.Items.Count);
 DelAction.Enabled:= treeActions.Selected <> nil;
 // Синхронизация с редактированием
 if (f_Location <> nil) and (treeActions.selected <> nil) then
 begin
  EditPanel.Controls[treeActions.selected.Index].Show;
 end; // f_Location

end;

procedure TLocationDlg.VariableActionExecute(Sender: TObject);
begin
 AddAction(TdcVariableAction);
end;

end.
