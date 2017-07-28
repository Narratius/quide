unit quideConditions;
{  Условия. Панель с несколькими элементами }


interface

uses
 quideObject;

type
  TquideCondition = class(TquideObject)
  { Переменная    - TquideVariable
    Условие       - <, >, <=, >=, =, <>
    Значение      - Value
    Действие True - TquideAction
    Действие False- TquideAction
    }
  end;


implementation



end.
