unit AboutDelphiArea;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Vcl.Imaging.pngimage;

type
  TAbout = class(TForm)
    btnOk: TButton;
    Image1: TImage;
    Label1: TLabel;
    VersionLabel: TLabel;
    ProductNameLabel: TLabel;
    CompanyLabel: TLabel;
    procedure FormCreate(Sender: TObject);
  end;


implementation

{$R *.dfm}

Uses
  jclFileUtils;

procedure TAbout.FormCreate(Sender: TObject);
begin
  SetBounds(Screen.Width - Width - 30, 50, Width, Height);
  with TJclFileVersionInfo.Create(Application.ExeName) do
  try
    ProductNameLabel.Caption := ProductName;
    VersionLabel.Caption := Format('Версия: %s', [FileVersion{ProductVersion}]);
    CompanyLabel.Caption := LegalCopyright;
  finally
    Free;
  end;
end;

end.
