unit PropertiesDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  PropertiesControls, Propertys;

type
  TPropDialog = class(TForm)
    ButtontsPanel: TPanel;
    Button2: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
  private
    f_WorkPanel: TPropertiesPanel;
    procedure SetProperties(const Value: TddProperties);
    procedure ResizePanel;
    function GetProperties: TddProperties;
    function pm_GetLabelTop: Boolean;
    procedure pm_Setf_LabelTop(const Value: Boolean);
    { Private declarations }
  public
    { Public declarations }
    function Execute(var aProp: TddProperties): Boolean;
    property LabelTop: Boolean read pm_GetLabelTop write pm_Setf_LabelTop;
    property WorkPanel: TPropertiesPanel read f_WorkPanel;
    property Properties: TddProperties read GetProperties write SetProperties;
  end;

var
  PropDialog: TPropDialog;

implementation

Uses
 Math;

{$R *.dfm}

function TPropDialog.Execute(var aProp: TddProperties): Boolean;
begin
 Result:= False;
 Properties:= aProp;
 if IsPositiveResult(ShowModal) then
 begin
   Result:= True;
   //Тут все падает
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
  //f_WorkPanel.Height:= ClientHeight;
  f_WorkPanel.Align:= alClient;
end;

function TPropDialog.GetProperties: TddProperties;
begin
 f_WorkPanel.GetValues;
 Result:= f_WorkPanel.Properties;
end;

function TPropDialog.pm_GetLabelTop: Boolean;
begin
 Result:= f_WorkPanel.LabelTop
end;

procedure TPropDialog.pm_Setf_LabelTop(const Value: Boolean);
begin
 f_WorkPanel.LabelTop:= Value;
end;

procedure TPropDialog.ResizePanel;
begin
 // Подогнать панель и диалог под контролы
 { TODO : Нужно реализовать, иначе фигня, а не диалог }
   ClientHeight:= Max(f_WorkPanel.ActualHeight, ClientHeight);
end;

procedure TPropDialog.SetProperties(const Value: TddProperties);
begin
  F_WorkPanel.Properties := Value;
  ResizePanel;
end;

end.
