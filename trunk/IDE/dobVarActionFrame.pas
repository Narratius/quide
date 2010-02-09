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
    procedure ComboVariablesChange(Sender: TObject);
  private
    f_variable: TdcVariable;
    procedure pm_Setvariable(const Value: TdcVariable);
    { Private declarations }
  public
    property variable: TdcVariable read f_variable write pm_Setvariable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TVarActionFrame.ComboVariablesChange(Sender: TObject);
begin
 // ¬ зависимости от типа выбранной переменной устанавливаем элемент редактировани€
end;

procedure TVarActionFrame.pm_Setvariable(const Value: TdcVariable);
begin
 f_variable := Value;
end;

end.
