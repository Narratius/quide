unit SizeableIntf;

interface

uses
  Classes, Controls, SizeableTypes;

type
  ISizeableControl = interface(IInterface)
  ['{5458A399-576E-4970-8762-919AB17A004D}']
    function pm_GetOnSizeChanged: TNotifyEvent; stdcall;
    procedure pm_SetOnSizeChanged(aValue: TNotifyEvent); stdcall;
    procedure SizeChanged; stdcall;
    property OnSizeChanged: TNotifyEvent read pm_GetOnSizeChanged write
        pm_SetOnSizeChanged;
  end;

  IControlContainer = interface(IInterface)
    ['{D2FBC108-88B0-4800-B449-4532600E4F80}']
    procedure AddControl(aControl: TControl; aSize: TControlSize; aPosition: TControlPosition); stdcall;
    procedure Lock; stdcall;
    function Locked: Boolean; stdcall;
    procedure Unlock; stdcall;
  end;



implementation


end.
