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
    procedure FormCreate(Sender: TObject);
  end;


implementation

{$R *.dfm}

procedure TAbout.FormCreate(Sender: TObject);
begin
  SetBounds(Screen.Width - Width - 30, 50, Width, Height);
end;

end.
