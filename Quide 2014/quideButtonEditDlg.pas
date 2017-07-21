unit quideButtonEditDlg;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TButtonEditDialog = class(TForm)
    comboLocations: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    editCaption: TEdit;
    btnOK: TButton;
    BtnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute: Boolean;
  end;

var
  ButtonEditDialog: TButtonEditDialog;

function ButtonEditDlg(var aCaption, aLocationName: String; aLocations: TStrings): Boolean;


implementation

{$R *.dfm}

{ TButtonEditDialog }

function TButtonEditDialog.Execute: Boolean;
begin
  Result:= IsPositiveResult(ShowModal)
end;

function ButtonEditDlg(var aCaption, aLocationName: String; aLocations: TStrings): Boolean;
begin
  with TButtonEditDialog.Create(nil) do
  try
    if aLocations <> nil then
    begin
      comboLocations.Items:= aLocations;
      comboLocations.ItemIndex:= aLocations.IndexOf(aLocationName);
    end
    else
      comboLocations.Text:= aLocationName;
    editCaption.Text:= aCaption;
    Result:= Execute;
    if Result then
    begin
      aCaption:= editCaption.Text;
      aLocationName:= comboLocations.Text;
    end; // Result
  finally
    Free;
  end;
end;

end.
