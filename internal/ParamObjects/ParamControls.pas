unit ParamControls;

interface

uses
 SizeableControls, SizeableTypes, Controls, Classes;

type
  TControlRec = record
    ControlClass: TControlClass;
    Position    : TControlPosition;
    Size        : TControlSize;
    Height      : Integer;
    Event       : TNotifyEvent;
  end;
  TControlsArray = array of TControlRec;

 TControlPanel = class(TSizeablePanel)
 public
  procedure CreateControls(aControls: TControlsArray);
 end;

const
 cDefControlRec : TControlRec = (ControlClass: TSizeableMemo; Position: cpNewLine; Size: csAutoSize; Height: 0; Event: nil);

implementation

uses
 SysUtils, StdCtrls;

procedure TControlPanel.CreateControls(aControls: TControlsArray);
var
  l_C: TControl;
  i: Integer;
begin
 Lock;
 try
  for i:= 0 to Length(aControls)-1 do
  begin
   l_C:= aControls[i].ControlClass.Create(Self);
   l_C.Name:= l_C.ClassName + IntToStr(Succ(ControlCount));
   l_C.Tag:= Succ(i);
   if l_C is TButton then
    TButton(l_C).OnClick:= aControls[i].Event;
   if (aControls[i].Size = csFixed) and (aControls[i].Height > 0) then
    l_C.Height:= aControls[i].Height;
   AddControl(l_C, aControls[i].Size, aControls[i].Position);
  end; // for i
 finally
  Unlock;
 end;
end;

end.
