unit dobVarActionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, QuestModeler, StdCtrls;

type
  TVarActionFrame = class(TFrame)
    Label1: TLabel;
    ComboVariables: TComboBox;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure ComboVariablesChange(Sender: TObject);
  private
    f_Control: TWinControl;
    f_Script: TdcScript;
    f_Variable: TdcVariable;
    procedure pm_SetScript(const Value: TdcScript);
    procedure pm_SetVariable(const Value: TdcVariable);
    procedure UpdateVariableList;
    { Private declarations }
  public
    property Script: TdcScript read f_Script write pm_SetScript;
    property Variable: TdcVariable read f_Variable write pm_SetVariable;
    { Public declarations }
  end;

implementation

uses
 guiVariableEditDlg;

{$R *.dfm}

procedure TVarActionFrame.Button1Click(Sender: TObject);
begin
 // ������� ���� ���������� ����������
 if VariableEditDialog(Script) then
 begin
  UpdateVariableList;
  ComboVariables.ItemIndex:= Pred(Script.VariablesCount);
 end;
end;

procedure TVarActionFrame.ComboVariablesChange(Sender: TObject);
begin
 Variable:= Script.Variables[ComboVariables.ItemIndex];
 // � ����������� �� ���� ��������� ���������� ������������� ������� ��������������
 f_Control.Free;
 case Variable.VarType of
  vtNumeric,
  vtText:
   begin
    f_Control:= TEdit.Create(nil);
    InsertControl(f_Control);
    TEdit(f_Control).Text:= Variable.Value;
   end;
  vtBoolean,
  vtEnum:
   begin
    f_Control:= TComboBox.Create(nil);
    InsertControl(f_Control);
    with TComboBox(f_Control) do
    begin
     Style:= csDropDownList;
     if Variable.VarType = vtBoolean then
     begin
      Items.Add('������');
      Items.Add('����');
     end
     else
     begin
     end;
     ItemIndex:= Items.IndexOf(Variable.Value);
    end; // with TComboBox
   end; // vtBoolean, vtEnum
 end; // case VarType
 f_Control.Left:= ComboVariables.Left;
 f_Control.Top:= 40;
 f_Control.Width:= ComboVariables.Width;
end;

procedure TVarActionFrame.pm_SetScript(const Value: TdcScript);
begin
 f_Script := Value;
 UpdateVariableList;
end;

procedure TVarActionFrame.pm_SetVariable(const Value: TdcVariable);
begin
 f_Variable := Value;
end;

procedure TVarActionFrame.UpdateVariableList;
var
  i: Integer;
begin
  comboVariables.Items.Clear;
  for i:= 0 to Pred(f_Script.VariablesCount) do
   comboVariables.Items.Add(f_Script.Variables[i].Caption);
end;

end.
