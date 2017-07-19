program XMLDemo;

uses
  Forms,
  UXMLDemo in 'UXMLDemo.pas' {MainForm};

{$R *.res}

begin
  {$ifdef Debug}
  ReportMemoryLeaksOnShutdown := DebugHook<>0;
  {$endif}
  Application.Initialize;
{$IF Compilerversion>=18}
  Application.MainFormOnTaskBar := True;
{$IFEND}
  Application.Title := 'XML Viewer';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
