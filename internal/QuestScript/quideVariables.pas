unit quideVariables;

interface

Uses
 quideObject;

type
  TquideVariableType = (vtNumeric, vtText, vtBoolean, vtEnum);
  TquideVariable = class(TquideObject{TquideValueObject})
  private
    f_VarType: TquideVariableType;
  public
    property VarType: TquideVariableType read f_VarType write f_VarType;
  end;

implementation





end.
