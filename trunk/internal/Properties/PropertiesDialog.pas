unit PropertiesDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  PropertiesControls;

type
  TPropDialog = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
  private
    f_WorkPanel: TPropertiesPanel;
    { Private declarations }
  public
    { Public declarations }
    property WorkPanel: TPropertiesPanel read f_WorkPanel;
  end;

var
  PropDialog: TPropDialog;

implementation

{$R *.dfm}

procedure TPropDialog.FormCreate(Sender: TObject);
begin
  // Создание рабочей панели
  f_WorkPanel:= TPropertiesPanel.Create(Self);
  InsertControl(f_WorkPanel);
  f_WorkPanel.Caption:= '';
  f_WorkPanel.Left:= 0;
  f_WorkPanel.Top:= 0;
end;

end.
