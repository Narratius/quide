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
  private
    f_Script: TdcScript;
    procedure pm_SetScript(const Value: TdcScript);
    { Private declarations }
  public
    property Script: TdcScript read f_Script write pm_SetScript;
    { Public declarations }
  end;

procedure EditVariablesList(aScript: TdcScript);

var
  VariablesListDlg: TVariablesListDlg;

implementation

Uses
 guiVAriableEditDlg;

{$R *.dfm}

procedure EditVariablesList(aScript: TdcScript);
begin
 with TVariablesListDlg.Create(nil) do
 try
  Script:= aScript;
  ShowModal;
 finally
  Free;
 end;
end;

procedure TVariablesListDlg.AddButtonClick(Sender: TObject);
begin
 if VariableEditDialog(Script) then
  ListVariables.Items.Add(Script.Variables[Script.VariablesCount-1].Caption);
end;

procedure TVariablesListDlg.DelButtonClick(Sender: TObject);
begin
 //
end;

procedure TVariablesListDlg.EditButtonClick(Sender: TObject);
begin
 //
end;

procedure TVariablesListDlg.pm_SetScript(const Value: TdcScript);
var
 i: Integer;
begin
 f_Script:= Value;
 ListVariables.Items.Clear;
 for I := 0 to Script.VariablesCount - 1 do
  ListVariables.Items.Add(Script.Variables[i].Caption);
end;

end.
