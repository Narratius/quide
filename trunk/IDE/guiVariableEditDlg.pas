unit guiVariableEditDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TVariableEditDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    EditCaption: TEdit;
    Label2: TLabel;
    ComboType: TComboBox;
    butDefineEnum: TButton;
    Label3: TLabel;
    procedure ComboTypeChange(Sender: TObject);
    procedure EditCaptionChange(Sender: TObject);
  private
    f_ValueControl: TWinControl;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VariableEditDlg: TVariableEditDlg;

implementation

{$R *.dfm}

procedure TVariableEditDlg.ComboTypeChange(Sender: TObject);
begin
 // ������� ������� ��������������
 // ������� ������� ��������������
 case comboType.ItemIndex of
  0: ; // ��������
  1: ; // ���������
  2: ; // ����������
  3: ; // ������������
 end;
end;

procedure TVariableEditDlg.EditCaptionChange(Sender: TObject);
begin
 Caption:= editCaption.Text;
end;

end.
