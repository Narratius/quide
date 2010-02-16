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
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
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

{$R *.dfm}

procedure EditVariablesList(aScript: TdcScript);
begin
  // TODO -cMM: EditVariablesList default body inserted
end;

procedure TVariablesListDlg.pm_SetScript(const Value: TdcScript);
begin
  // TODO -cMM: TVariablesListDlg.pm_SetScript default body inserted
end;

end.
