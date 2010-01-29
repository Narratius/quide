unit guiActionListDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Contnrs, QuestModeler;

type
  TActionListDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    ListBox1: TListBox;
    NewButton: TButton;
    EditButton: TButton;
    DeleteButton: TButton;
    procedure NewButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
  private
    f_ActionList: TObjectList;
    f_Model: TdcScript;
    { Private declarations }
    procedure pm_SetActionList(aValue: TObjectList);
    procedure RefreshList;
  public
    { Public declarations }
   property ActionList: TObjectList
    read f_ActionList
    write pm_SetActionList;
  end;

var
  ActionListDlg: TActionListDlg;

function EditActionList(aLocation: TdcLocation; theModel: TdcScript): Boolean;

implementation

{$R *.dfm}

Uses
 Dialogs,
 guiActionEditDlg;

procedure TActionListDlg.DeleteButtonClick(Sender: TObject);
begin
 if IsPositiveResult(MessageDlg('¬ы уверены, что хотите удалить действие '+ (ActionList.Items[ListBox1.ItemIndex] as TdcAction).Caption, mtConfirmation, [mbYes, mbNo], 0)) then
 begin
  ActionList.Delete(ListBox1.ItemIndex);
  RefreshList;
 end;
end;

procedure TActionListDlg.EditButtonClick(Sender: TObject);
begin
 if ListBox1.ItemIndex <> -1 then
 begin
   if EditAction(ActionList.Items[ListBox1.ItemIndex] as TdcGotoAction, f_Model) then
    RefreshList;
 end;
end;

procedure TActionListDlg.FormCreate(Sender: TObject);
begin
 f_ActionList:= TObjectList.Create;
end;

procedure TActionListDlg.FormDestroy(Sender: TObject);
begin
 f_ActionList.Free;
end;

procedure TActionListDlg.NewButtonClick(Sender: TObject);
var
 l_Action: TdcGotoAction;
begin
 l_Action:= TdcGotoAction.Create(nil);
 if EditAction(l_Action, f_Model) then
 begin
  f_ActionList.Add(l_Action);
  RefreshList;
 end
 else
  l_Action.Free;
end;

function EditActionList(aLocation: TdcLocation; theModel: TdcScript): Boolean;
begin
 with TActionListDlg.Create(nil) do
 try
  f_Model:= theModel;
   ActionList:= aLocation.ActionList;
   Result:= IsPositiveResult(ShowModal);
   if Result then
    aLocation.ActionList:= ActionList;
 finally
   Free;
 end;
end;

procedure TActionListDlg.pm_SetActionList(aValue: TObjectList);
begin
 if aValue <> nil then
 begin
  CloneActions(aValue, f_ActionList, f_Model);
  RefreshList;
 end;
end;

procedure TActionListDlg.RefreshList;
var
  I: Integer;
begin
 ListBox1.Items.Clear;
 for I := 0 to ActionList.Count - 1 do
  ListBox1.Items.Add(TdcAction(actionList.Items[i]).Caption);
end;

end.
