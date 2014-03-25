unit PropertiesDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  PropertiesControls, Propertys;

type
  TPropDialog = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
  private
    f_WorkPanel: TPropertiesPanel;
    FProperties: TProperties;
    procedure SetProperties(const Value: TProperties);
    procedure ResizePanel;
    function GetProperties: TProperties;
    { Private declarations }
  public
    { Public declarations }
    function Execute(var aProp: TProperties): Boolean;
    property WorkPanel: TPropertiesPanel read f_WorkPanel;
    property Properties: TProperties read GetProperties write SetProperties;
  end;

var
  PropDialog: TPropDialog;

implementation

{$R *.dfm}

function TPropDialog.Execute(var aProp: TProperties): Boolean;
begin
 Result:= False;
 Properties:= aProp;
 if IsPositiveResult(ShowModal) then
 begin
   Result:= True;
   aProp:= Properties;
 end;
end;

procedure TPropDialog.FormCreate(Sender: TObject);
begin
  // Создание рабочей панели
  f_WorkPanel:= TPropertiesPanel.Create(Self);
  InsertControl(f_WorkPanel);
  f_WorkPanel.Caption:= '';
  f_WorkPanel.Left:= 0;
  f_WorkPanel.Top:= 0;
end;

function TPropDialog.GetProperties: TProperties;
begin
 Result:= f_WorkPanel.Properties;
end;

procedure TPropDialog.ResizePanel;
begin
 // Подогнать панель и диалог под контролы
end;

procedure TPropDialog.SetProperties(const Value: TProperties);
begin
  F_WorkPanel.Properties := Value;
  ResizePanel;
end;

end.
