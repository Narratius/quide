program Quide2014;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  DesignProp in 'DesignProp.pas' {DesignerProperties},
  ObjectProp in 'ObjectProp.pas' {ObjectProperties},
  LinkProp in 'LinkProp.pas' {LinkProperties},
  NodeProp in 'NodeProp.pas' {NodeProperties},
  AboutDelphiArea in 'AboutDelphiArea.pas' {About},
  UsageHelp in 'UsageHelp.pas' {HelpOnActions},
  MarginsProp in 'MarginsProp.pas' {MarginDialog},
  AlignDlg in 'AlignDlg.pas' {AlignDialog},
  SizeDlg in 'SizeDlg.pas' {SizeDialog},
  quideGUILink in 'quideGUILink.pas',
  quideInventory in '..\internal\QuestScript\quideInventory.pas',
  quideLocationDlg in 'quideLocationDlg.pas' {quideLocationDialog},
  quideActionControls in 'quideActionControls.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Quest IDE 2014';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
