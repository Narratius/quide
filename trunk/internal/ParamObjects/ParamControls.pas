unit ParamControls;

interface

uses
 SizeableControls, SizeableTypes, Controls, Classes;

type
  TControlRec = record
    Caption     : String;
    ControlClass: TControlClass;
    Position    : TControlPosition;
    Size        : TControlSize;
    Height      : Integer;
    Event       : TNotifyEvent;
  end;
  TControlsArray = array of TControlRec;

 TControlPanel = class(TSizeablePanel)
 private
 protected
  procedure ClearControls;
  procedure TuneupControl(aControl: TControl); virtual;
 public
  procedure CreateControls(aControls: TControlsArray);
 end;

const
 cDefControlRec : TControlRec = (ControlClass: TSizeableMemo; Position: cpNewLine; Size: csAutoSize; Height: 0; Event: nil);

implementation

uses
 SysUtils, StdCtrls;

procedure TControlPanel.ClearControls;
begin
 // Удалить все контролы
end;

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
   if l_C is TLabel then
    TLabel(l_C).Caption:= aControls[i].Caption
   else 
   if l_C is TButton then
   begin
    TButton(l_C).OnClick:= aControls[i].Event;
    TButton(l_C).Caption:= aControls[i].Caption;
   end
   else
   if l_C is TEdit then
    TEdit(l_C).Text:= '';
   if (aControls[i].Size = csFixed) and (aControls[i].Height > 0) then
    l_C.Height:= aControls[i].Height;
   AddControl(l_C, aControls[i].Size, aControls[i].Position);
   TuneupControl(l_C)
  end; // for i
 finally
  Unlock;
 end;
end;

procedure TControlPanel.TuneupControl(aControl: TControl);
begin
 // TODO -cMM: TControlPanel.TuneupControl необходимо написать реализацию
end;

end.
