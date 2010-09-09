unit PropertyIntf;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
  IPropertyControlValue = interface(IInterface)
    ['{7660D972-81B7-4062-AF86-4517B58AA55E}']
    function pm_GetValue: Variant; stdcall;
    procedure pm_SetValue(const Value: Variant); stdcall;
    property Value: Variant read pm_GetValue write pm_SetValue;
  end;



implementation


end.
