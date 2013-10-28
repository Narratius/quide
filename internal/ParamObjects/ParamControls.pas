unit ParamControls;

interface

uses
 SizeableControls, SizeableTypes, Controls, Classes;

type
  TControlRec = record
    Caption: string;
    ControlClass: TControlClass;
    Position: TControlPosition;
    Size: TControlSize;
    Height: Integer;
    Tag: Integer;
    Event: TNotifyEvent;
  end;

  TControlsArray = array of TControlRec;

  TControlPanel = class(TSizeablePanel)
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

{
******************************** TControlPanel *********************************
}
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
   l_C.Tag:= aControls[i].Tag;

   if (aControls[i].Size = csFixed) and (aControls[i].Height > 0) then
    l_C.Height:= aControls[i].Height;
   AddControl(l_C, aControls[i].Size, aControls[i].Position);
   if l_C is TLabel then
    TLabel(l_C).Caption:= aControls[i].Caption
   else
   if l_C is TButton then
   begin
    TButton(l_C).OnClick:= aControls[i].Event;
    TButton(l_C).Caption:= aControls[i].Caption;
   end
   else
   begin
    if l_C is TEdit then
     TEdit(l_C).Text:= ''
    else
    if (l_C is TComboBox) then
     TComboBox(l_C).Style:= csDropDownList
    else
    if l_C is TMemo then
     TMemo(l_C).Text:= '';
    if Assigned(aControls[i].Event) then
     aControls[i].Event(l_C);
   end;
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
