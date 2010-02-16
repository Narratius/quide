program Quide;

uses
  Forms,
  mainForm in 'mainForm.pas' {QuestEditorForm},
  dobFileStorage in 'dobFileStorage.pas',
  dobTextActionEdit in 'dobTextActionEdit.pas' {dobTextFrame: TFrame},
  dobButtonAction in 'dobButtonAction.pas' {ButtonFrame: TFrame},
  guiScriptDetailsDlg in 'guiScriptDetailsDlg.pas' {ScriptDetailsDlg},
  guiTypes in 'guiTypes.pas',
  dobVarActionFrame in 'dobVarActionFrame.pas' {VarActionFrame: TFrame},
  guiVariableEditDlg in 'guiVariableEditDlg.pas' {VariableEditDlg},
  guiVariablesListDlg in 'guiVariablesListDlg.pas' {VariablesListDlg},
  guiLocEditDlgEx in 'guiLocEditDlgEx.pas' {LocationEditExDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Quide 2010';
  Application.CreateForm(TQuestEditorForm, QuestEditorForm);
  Application.Run;
end.
