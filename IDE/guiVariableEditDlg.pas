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
    procedure butDefineEnumClick(Sender: TObject);
    procedure ComboTypeChange(Sender: TObject);
    procedure EditCaptionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    f_ValueControl: TWinControl;
    f_EnumList: TStrings;
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
    property EnumList: TStrings
     read f_EnumList
     write f_EnumList;
    { Public declarations }
  end;

function VariableEditDialog(aScript: TdcScript; aIndex: Integer = -1): Boolean;

var
  VariableEditDlg: TVariableEditDlg;



implementation

{$R *.dfm}

Uses
 guiEnumEditDlg;

function VariableEditDialog(aScript: TdcScript; aIndex: Integer = -1): Boolean;
var
 l_Var: TdcVariable;
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
    l_Var:= aScript.Variables[aIndex];
     editCaption.Text:= l_Var.Caption;
     ComboType.ItemIndex:= Ord(l_Var.VarType);
     ComboTypeChange(ComboType);
     VarValue:= l_Var.Value;
   end;
  Result:= IsPositiveResult(ShowModal);
  if Result then
  begin
   if aIndex = -1 then
    l_Var:= aScript.NewVariable(EditCaption.Text);
   with l_Var do
   begin
    Caption:= EditCaption.Text;
    case ComboType.ItemIndex of
     0: VarType:= vtNumeric;
     1: VarType:= vtText;
     2: VarType:= vtBoolean;
     3: VarType:= vtEnum;
    end;
    Value:= VarValue;
    Enum.Assign(EnumList);
   end; // with l_Var
  end;
 end
end;

procedure TVariableEditDlg.butDefineEnumClick(Sender: TObject);
begin
 if EditEnum(f_EnumList) then
  TComboBox(f_ValueControl).Items:= f_EnumList;
end;

procedure TVariableEditDlg.ComboTypeChange(Sender: TObject);
begin
 // Удалить элемент редактирования
 f_ValueControl.Free;
 butDefineEnum.Visible:= False;
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

procedure TVariableEditDlg.FormCreate(Sender: TObject);
begin
 f_EnumList:= TStringList.Create;
end;

procedure TVariableEditDlg.FormDestroy(Sender: TObject);
begin
 f_EnumList.Free
end;

procedure TVariableEditDlg.MakeEnumInput;
begin
 f_ValueControl:= TComboBox.Create(nil);
 InsertControl(f_ValueControl);
 with TComboBox(f_ValueControl) do
 begin
  Style:= csDropDownList;
  Items:= f_EnumList;
 end;
 butDefineEnum.Visible:= true;
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
 if ComboType.ItemIndex in [0,1] then
  TEdit(f_ValueControl).Text:= aValue
 else
  TComboBox(f_ValueControl).ItemIndex:= TComboBox(f_ValueControl).Items.Indexof(aValue);
end;

end.
