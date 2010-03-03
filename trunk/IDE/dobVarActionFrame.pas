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
    procedure ChangeVariableControl;
    function pm_GetValue: string;
    procedure pm_SetScript(const Value: TdcScript);
    procedure pm_SetValue(const Value: string);
    procedure pm_SetVariable(const Value: TdcVariable);
    procedure UpdateVariableList;
    { Private declarations }
  public
    property Script: TdcScript read f_Script write pm_SetScript;
    property Value: string read pm_GetValue write pm_SetValue;
    property Variable: TdcVariable read f_Variable write pm_SetVariable;
    { Public declarations }
  end;

implementation

uses
 guiVariableEditDlg;

{$R *.dfm}

procedure TVarActionFrame.Button1Click(Sender: TObject);
begin
 // Вызвать окно добавления переменных
 if VariableEditDialog(Script) then
 begin
  UpdateVariableList;
  ComboVariables.ItemIndex:= Pred(Script.VariablesCount);
 end;
end;

procedure TVarActionFrame.ChangeVariableControl;
begin
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
      Items.Add('Истина');
      Items.Add('Ложь');
     end
     else
     begin
      Items:= Variable.Enum;
     end;
     ItemIndex:= Items.IndexOf(Variable.Value);
    end; // with TComboBox
   end; // vtBoolean, vtEnum
 end; // case VarType
 f_Control.Left:= ComboVariables.Left;
 f_Control.Top:= 40;
 f_Control.Width:= ComboVariables.Width;
end;

procedure TVarActionFrame.ComboVariablesChange(Sender: TObject);
begin
 Variable:= Script.Variables[ComboVariables.ItemIndex];
 ChangeVariableControl;
end;

function TVarActionFrame.pm_GetValue: string;
begin
 if Variable <> nil then
  case Variable.VarType of
  vtNumeric,
  vtText:
   Begin
    Result:= TEdit(f_Control).Text
   end;
  vtBoolean,
  vtEnum:
   begin
    Result:= TComboBox(f_Control).Items[TComboBox(f_Control).ItemIndex];
   end;
  end
 else
  Result:= '';
end;

procedure TVarActionFrame.pm_SetScript(const Value: TdcScript);
begin
 f_Script := Value;
 UpdateVariableList;
end;

procedure TVarActionFrame.pm_SetValue(const Value: string);
begin
 if Variable <> nil then
  case Variable.VarType of
   vtNumeric,
   vtText:
    Begin
     TEdit(f_Control).Text:= Value
    end;
   vtBoolean,
   vtEnum:
    begin
      TComboBox(f_Control).ItemIndex:= TComboBox(f_Control).Items.IndexOf(Value);
    end;
  end
end;

procedure TVarActionFrame.pm_SetVariable(const Value: TdcVariable);
begin
 f_Variable := Value;
 ChangeVariableControl;
end;

procedure TVarActionFrame.UpdateVariableList;
var
  i: Integer;
begin
 comboVariables.Items.Clear;
 for i:= 0 to Pred(f_Script.VariablesCount) do
  comboVariables.Items.Add(f_Script.Variables[i].Caption);
 if Variable <> nil then
  comboVariables.ItemIndex:= comboVariables.Items.IndexOf(Variable.Caption);
end;

end.
