unit quideConditions;
{  �������. ������ � ����������� ���������� }


interface

uses
 quideObject;

type
  TquideCondition = class(TquideObject)
  { ����������    - TquideVariable
    �������       - <, >, <=, >=, =, <>
    ��������      - Value
    �������� True - TquideAction
    �������� False- TquideAction
    }
  end;


implementation



end.
