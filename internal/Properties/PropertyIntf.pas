unit PropertyIntf;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
  //1 Обеспечивает сохранение-загрузку
  IquideStore = interface(IInterface)
    ['{1604F322-5F86-4359-A44A-33EE3CB1F6C7}']
    procedure Load(aStream: TStream); stdcall;
    procedure Save(aStream: TStream); stdcall;
  end;

  IPropertyControlValue = interface(IInterface)
    ['{7660D972-81B7-4062-AF86-4517B58AA55E}']
    function pm_GetValue: Variant; stdcall;
    procedure pm_SetValue(const Value: Variant); stdcall;
    property Value: Variant read pm_GetValue write pm_SetValue;
  end;



implementation


end.
