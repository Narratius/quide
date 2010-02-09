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
    f_Script: TdcScript;
    f_Variable: TdcVariable;
    procedure pm_SetScript(const Value: TdcScript);
    procedure pm_SetVariable(const Value: TdcVariable);
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
 // Вызвать окно добавления переменных
end;

procedure TVarActionFrame.ComboVariablesChange(Sender: TObject);
begin
 // В зависимости от типа выбранной переменной устанавливаем элемент редактирования
end;

procedure TVarActionFrame.pm_SetScript(const Value: TdcScript);
var
 i: Integer;
begin
 f_Script := Value;
 comboVariables.Items.Clear;
 for i:= 0 to Pred(f_Script.VariablesCount) do
  comboVariables.Items.Add(f_Script.Variables[i].Caption);
end;

procedure TVarActionFrame.pm_SetVariable(const Value: TdcVariable);
begin
 f_Variable := Value;
end;

end.
