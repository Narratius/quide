unit guiVariableEditDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, QuestModeler;

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
    procedure MakeEnumInput;
    procedure MakeLogicInput;
    procedure MakeNumericInput;
    procedure MakeTextInput;
    { Private declarations }
    function pm_GetValue: String;
    procedure pm_SetValue(const aValue: String);
  public
    property VarValue: string
     read pm_GetValue
     write pm_SetValue;
    { Public declarations }
  end;

function VariableEditDialog(aScript: TdcScript; aIndex: Integer = -1): Boolean;

var
  VariableEditDlg: TVariableEditDlg;



implementation

{$R *.dfm}

function VariableEditDialog(aScript: TdcScript; aIndex: Integer = -1): Boolean;
begin
 with TVariableEditDlg.Create(nil) do
 begin
   if aIndex = -1 then
   begin
     editCaption.Text:= '';
     ComboType.ItemIndex:= -1;
   end
   else
   begin
     editCaption.Text:= aScript.Variables[aIndex].Caption;
     ComboType.ItemIndex:= Ord(aScript.Variables[aIndex].VarType);
     ComboTypeChange(ComboType);
     VarValue:= aScript.Variables[aIndex].Value;
   end;
  Result:= IsPositiveResult(ShowModal);
  if Result then
  begin
   with aScript.NewVariable(EditCaption.Text) do
   begin
    case ComboType.ItemIndex of
     0: VarType:= vtNumeric;
     1: VarType:= vtText;
     2: VarType:= vtBoolean;
     3: VarType:= vtEnum;
    end;
    Value:= VarValue;
   end;
  end;
 end
end;

procedure TVariableEditDlg.ComboTypeChange(Sender: TObject);
begin
 // Удалить элемент редактирования
 f_ValueControl.Free;
 // Создать элемент редактирования
 case comboType.ItemIndex of
  0: MakeNumericInput; // Числовой
  1: MakeTextInput; // Текстовый
  2: MakeLogicInput; // Логический
  3: MakeEnumInput; // Перечислимый
 end;
 f_ValueControl.Left:= 80;
 f_ValueControl.Width:= 225;
 f_ValueControl.Top:= 80;
end;

procedure TVariableEditDlg.EditCaptionChange(Sender: TObject);
begin
 Caption:= editCaption.Text;
end;

procedure TVariableEditDlg.MakeEnumInput;
begin
 f_ValueControl:= TComboBox.Create(nil);
 InsertControl(f_ValueControl);
 with TComboBox(f_ValueControl) do
 begin
  Style:= csDropDownList;
 end;
end;

procedure TVariableEditDlg.MakeLogicInput;
begin
 f_ValueControl:= TComboBox.Create(nil);
 InsertControl(f_ValueControl);
 with TComboBox(f_ValueControl) do
 begin
  Style:= csDropDownList;
  Items.Add('Истина');
  Items.Add('Ложь');
 end;
end;

procedure TVariableEditDlg.MakeNumericInput;
begin
 f_ValueControl:= TEdit.Create(nil);
 InsertControl(f_ValueControl);
 TEdit(f_ValueControl).Text:= '';
end;

procedure TVariableEditDlg.MakeTextInput;
begin
 f_ValueControl:= TEdit.Create(nil);
 InsertControl(f_ValueControl);
 TEdit(f_ValueControl).Text:= '';
end;

function TVariableEditDlg.pm_GetValue: String;
begin
 if ComboType.ItemIndex in [0,1] then
  Result := TEdit(f_ValueControl).Text
 else
  Result := TComboBox(f_ValueControl).Items[TComboBox(f_ValueControl).ItemIndex];
end;

procedure TVariableEditDlg.pm_SetValue(const aValue: String);
begin
//
end;

end.
