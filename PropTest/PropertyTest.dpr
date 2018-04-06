program PropertyTest;

uses
  FastMM4,
  Vcl.Forms,
  PropTestForm in 'PropTestForm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
