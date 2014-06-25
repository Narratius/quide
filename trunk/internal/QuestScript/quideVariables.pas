unit quideVariables;

interface

uses
  quide;

type
 TdcVariableType = (vtNumeric, vtText, vtBoolean, vtEnum);
  TquideVariable = class(TquideValueObject)
  private
    f_VarType: TquideVariableType;
  public
    property VarType: TquideVariableType read f_VarType write f_VarType;
  end;


implementation



end.
