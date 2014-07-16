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
    Hint: String;
    Tag: Integer;
    Event: TNotifyEvent;
    OnChange: TNotifyEvent;
  end;

  TControlsArray = array of TControlRec;

  TControlPanel = class(TSizeablePanel)
  private
    f_LeftIndent: Integer;
  protected
    procedure ClearControls;
    procedure TuneupControl(aControl: TControl); virtual;
  public
    procedure CreateControls(aControls: TControlsArray);
    property LeftIndent: Integer read f_LeftIndent;
  end;

const
 cDefControlRec : TControlRec = (Caption: '';
                                 ControlClass: TSizeableMemo;
                                 Position: cpNewLine;
                                 Size: csAutoSize;
                                 Height: 0;
                                 Hint: '';
                                 Tag: 0;
                                 Event: nil;
                                 OnChange: nil);

implementation

uses
 SysUtils, StdCtrls, Math;

{
******************************** TControlPanel *********************************
}
procedure TControlPanel.ClearControls;
begin
 // Удалить все контролы
 f_LeftIndent:= -1;
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
   l_C.Hint:= aControls[i].Hint;

   if (aControls[i].Size = csFixed) and (aControls[i].Height > 0) then
    l_C.Height:= aControls[i].Height;
   //AddControl(l_C, aControls[i].Size, aControls[i].Position);
   if l_C is TLabel then
    TLabel(l_C).Caption:= aControls[i].Caption
   else
   if l_C is TButton then
   begin
    TButton(l_C).OnClick:= aControls[i].Event;
    TButton(l_C).Caption:= aControls[i].Caption;
   end
   else
   if l_C is TGroupBox then
    TGroupBox(l_C).Caption:= Format(' %s ', [aControls[i].Caption])
   else
   begin
    if l_C is TEdit then
    begin
     TEdit(l_C).Text:= '';
     TEdit(l_C).OnChange:= aControls[i].OnChange;
    end
    else
    if (l_C is TComboBox) then
    begin
     TComboBox(l_C).Style:= csDropDownList;
     TComboBox(l_C).OnChange:= aControls[i].OnChange;
    end
    else
    if l_C is TMemo then
    begin
     TMemo(l_C).Text:= '';
     TMemo(l_C).OnChange:= aControls[i].OnChange;
    end
    else
    if l_C is TCheckBox then
    begin
     TCheckBox(l_C).Caption:= aControls[i].Caption;
     TCheckBox(l_C).OnClick:= aControls[i].OnChange;
    end;
    // Это зачем?
    if Assigned(aControls[i].Event) then
     aControls[i].Event(l_C);
   end;
   AddControl(l_C, aControls[i].Size, aControls[i].Position);
   f_LeftIndent:= Max(f_LeftIndent, l_C.Left);
   // Тут можно запомнить Макс. левую позицию контрола
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
