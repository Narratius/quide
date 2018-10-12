unit ParamControls;

interface

uses
 SizeableControls, SizeableTypes, Propertys,
 Controls, Classes, Menus;

type
  { TODO : ������ �� �� ������� ����� ���� ��������? ��� ���� �� �������� ���������� }
  TControlRec = record
    PropType: TddPropertyType;
    Caption: string;
    ChoiceStyle: TddChoiceStyle;
    ControlClass: TControlClass;
    CtrlPosition: TControlPosition;
    LabelPosition: TControlPosition;
    Size: TControlSize;
    Height: Integer;
    Width: Integer;
    Hint: String;
    Tag: Integer;
    ReadOnly: Boolean;
    Menu: TPopupmenu;
    Event: TNotifyEvent;
    OnChange: TNotifyEvent;
    SubItem: TddProperties;
  end;

  TControlsArray = array of TControlRec;

  TControlPanel = class(TSizeablePanel)
  private
    f_LeftIndent: Integer;
  protected
    procedure ClearControls; override;
    procedure TuneupControl(aControl: TControl); virtual;
  public
    procedure CreateControls(aControls: TControlsArray);
    property LeftIndent: Integer read f_LeftIndent;
  end;

const
 cDefControlRec : TControlRec = (
        PropType: ptNothing;
        Caption: '';
        ChoiceStyle: csReadOnlyList;
        ControlClass: TSizeableMemo;
        CtrlPosition: cpNewLine;
        LabelPosition: cpNewLine;
        Size: csAutoSize;
        Height: 0;
        Width: 0;
        Hint: '';
        Tag: 0;
        ReadOnly: False;
        Menu: nil;
        Event: nil;
        OnChange: nil;
        SubItem: nil
        );

implementation

uses
 SysUtils, StdCtrls, ComCtrls, Math, ExtCtrls, Graphics,
 PropertiesControls
 {$IFDEF Debug}, ddLogFile{$ENDIF};

{
******************************** TControlPanel *********************************
}
procedure TControlPanel.ClearControls;
begin
 inherited;
 // ������� ��� ��������
 f_LeftIndent:= -1;
 DestroyComponents
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
   if (aControls[i].Size = csFixed) and (aControls[i].Width > 0) then
    l_C.Width:= aControls[i].Width;
   l_C.Enabled:= not aControls[i].ReadOnly;

   //AddControl(l_C, aControls[i].Size, aControls[i].Position);
   if l_C is TLabel then
   begin
    TLabel(l_C).Caption:= aControls[i].Caption;
    if aControls[i].PropType = ptDivider then
     TLabel(l_C).Font.Style:= [fsBold];
   end
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
     // ������ ������������ ����� ��������
     TEdit(l_C).OnChange:= aControls[i].OnChange;
    end
    else
    if (l_C is TComboBox) then
    begin
     if aControls[i].ChoiceStyle = csReadOnlyList then
      TComboBox(l_C).Style:= csDropDownList
     else
     begin
      TComboBox(l_C).Style:= csDropDown;
      TComboBox(l_C).Text:= '';
     end;
     TComboBox(l_C).OnChange:= aControls[i].OnChange;
    end
    else
    if l_C is TMemo then
    begin
     TMemo(l_C).Text:= '';
     TMemo(l_C).ScrollBars:= ssVertical;
     TMemo(l_C).OnChange:= aControls[i].OnChange;
    end
    else
    if l_C is TCheckBox then
    begin
     TCheckBox(l_C).Caption:= aControls[i].Caption;
     TCheckBox(l_C).OnClick:= aControls[i].OnChange;
    end
    else
    if l_C is TStaticText then
     TStaticText(l_C).Caption := aControls[i].Caption
    else
    if l_C is TPropertiesPanel then
    begin
     TPropertiesPanel(l_C).Caption:= '';
     if aControls[i].SubItem <> nil then
      TPropertiesPanel(l_C).PopupMenu:= aControls[i].SubItem.Menu;
    end
    else
    if l_C is TDateTimePicker then
    begin
     if aControls[i].PropType = ptDate then
      TDateTimePicker(l_C).Kind := dtkDate
     else
      TDateTimePicker(l_C).Kind := dtkTime;
    end;
    // ��� �����?
    if Assigned(aControls[i].Event) then
     aControls[i].Event(l_C);
   end;
   AddControl(l_C, aControls[i].Size, aControls[i].CtrlPosition, aControls[i].LabelPosition);
   if l_C is TPropertiesPanel then
   begin
     // ��� ����� ��������� ��������?
     if aControls[i].SubItem <> nil then // ??
       TPropertiesPanel(l_C).Properties:= aControls[i].SubItem;
   end;
   { TODO : ��������� ������ ����� ���������� ����� ����, ��� ��� �������� ��������� }
   f_LeftIndent:= Max(f_LeftIndent, l_C.Left);
   // ��� ����� ��������� ����. ����� ������� ��������
   TuneupControl(l_C)
  end; // for i
 finally
  Unlock;
 end;
 {$IFDEF Debug}
 Msg2Log('Controls Created: %d (Left: %d, Top: %d, Width: %d, Height: %d)', [Length(aControls), Left, Top, Width, Height]);
 {$ENDIF}
end;

procedure TControlPanel.TuneupControl(aControl: TControl);
begin
 // TODO -cMM: TControlPanel.TuneupControl ���������� �������� ����������
end;

end.
