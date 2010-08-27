unit PropertyIntf;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
  IPropertyControl = interface(IInterface)
    ['{5458A399-576E-4970-8762-919AB17A004D}']
    function pm_GetOnSizeChanged: TNotifyEvent; stdcall;
    procedure pm_SetOnSizeChanged(aValue: TNotifyEvent); stdcall;
    property OnSizeChanged: TNotifyEvent read pm_GetOnSizeChanged write
        pm_SetOnSizeChanged;
  end;

  IControlContainer = interface(IInterface)
    ['{D2FBC108-88B0-4800-B449-4532600E4F80}']
    procedure AddControl(aControl: TControl); stdcall;
  end;

  IPropertyControlValue = interface(IInterface)
    ['{7660D972-81B7-4062-AF86-4517B58AA55E}']
    function pm_GetValue: Variant; stdcall;
    procedure pm_SetValue(const Value: Variant); stdcall;
    property Value: Variant read pm_GetValue write pm_SetValue;
  end;



implementation


end.
