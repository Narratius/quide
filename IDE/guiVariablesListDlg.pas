unit guiVariablesListDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, QuestModeler;

type
  TVariablesListDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ListVariables: TListBox;
    AddButton: TButton;
    EditButton: TButton;
    DelButton: TButton;
    procedure DelButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure ListVariablesDblClick(Sender: TObject);
  private
    f_ListChanged: Boolean;
    f_Script: TdcScript;
    procedure pm_SetScript(const Value: TdcScript);
    { Private declarations }
  public
    property ListChanged: Boolean read f_ListChanged;
    property Script: TdcScript read f_Script write pm_SetScript;
    { Public declarations }
  end;

function EditVariablesList(aScript: TdcScript): Boolean;

var
  VariablesListDlg: TVariablesListDlg;

implementation

Uses
 guiVAriableEditDlg;

{$R *.dfm}

function EditVariablesList(aScript: TdcScript): Boolean;
begin
 with TVariablesListDlg.Create(nil) do
 try
  Script:= aScript;
  ShowModal;
  Result:= ListChanged;
 finally
  Free;
 end;
end;

procedure TVariablesListDlg.AddButtonClick(Sender: TObject);
begin
 if VariableEditDialog(Script) then
 begin
  ListVariables.Items.Add(Script.Variables[Script.VariablesCount-1].Caption);
  f_ListChanged:= True;
 end;
end;

procedure TVariablesListDlg.DelButtonClick(Sender: TObject);
begin
 //
end;

procedure TVariablesListDlg.EditButtonClick(Sender: TObject);
begin
 if VariableEditDialog(Script, ListVariables.ItemIndex) then
 begin
  ListVariables.Items[ListVariables.ItemIndex]:= Script.Variables[ListVariables.ItemIndex].Caption;
  f_ListChanged:= True;
 end;
end;

procedure TVariablesListDlg.ListVariablesDblClick(Sender: TObject);
begin
 if ListVariables.ItemIndex > -1 then
  EditButtonClick(sender)
 else
  AddButtonClick(Sender);
end;

procedure TVariablesListDlg.pm_SetScript(const Value: TdcScript);
var
 i: Integer;
begin
 f_Script:= Value;
 f_ListChanged:= False;
 ListVariables.Items.Clear;
 for I := 0 to Script.VariablesCount - 1 do
  ListVariables.Items.Add(Script.Variables[i].Caption);
end;

end.
