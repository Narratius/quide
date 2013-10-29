unit PropertiesControls;

interface

uses classes, ExtCtrls, StdCtrls, Controls, Propertys, SizeableControls, ParamControls;

type
  //1 ������ ��� �������������� ������ �������
  TPropertiesPanel = class(TControlPanel)
  private
    f_Properties: TProperties;
    function MakePropertyControl(aProperty: TProperty): Boolean;
    procedure pm_SetProperties(const Value: TProperties);
  protected
    f_Controls: TControlsArray;
    procedure AddDefControl;
    function FillControls: TControlsArray; virtual;
    procedure GetLastControl(var aRec: TControlRec);
    procedure MakeActionControl(aProperty: TProperty); virtual;
    procedure MakeBooleanControl(aProperty: TProperty); virtual;
    procedure MakeChoiceControl(aProperty: TProperty); virtual;
    procedure MakeCustomControl(aControlClass: TControlClass);
    procedure MakeIntegerControl(aProperty: TProperty); virtual;
    procedure MakePropertiesControl(aProperty: TProperty); virtual;
    procedure MakeStringControl(aProperty: TProperty); virtual;
    procedure MakeTextControl(aProperty: TProperty); virtual;
    procedure TuneupControl(aControl: TControl); override;
  public
    procedure CorrectControl(aControlRec: TControlRec); virtual;
    procedure GetValues;
    procedure MakeControls;
    procedure SetValues;
    property Properties: TProperties read f_Properties write pm_SetProperties;
  end;

implementation

uses SizeableTypes;

{
******************************* TPropertiesPanel *******************************
}
procedure TPropertiesPanel.AddDefControl;
begin
 SetLength(f_Controls, Length(f_Controls)+1);
 f_Controls[Length(f_Controls)-1]:= cDefControlRec;
end;

procedure TPropertiesPanel.CorrectControl(aControlRec: TControlRec);
begin
end;

function TPropertiesPanel.FillControls: TControlsArray;
begin
 SetLength(f_Controls, 0);
 if Properties <> nil then
  Properties.IterateAll(MakePropertyControl);
 Result:= f_Controls;
end;

procedure TPropertiesPanel.GetLastControl(var aRec: TControlRec);
begin
 aRec:= f_Controls[Length(f_Controls)-1];
end;

procedure TPropertiesPanel.GetValues;
begin
 // TODO -cMM: TPropertiesPanel.SetValues ���������� �������� ����������
end;

procedure TPropertiesPanel.MakeActionControl(aProperty: TProperty);
begin
 MakeCustomControl(TButton);
 with f_Controls[Length(f_Controls)-1] do
 begin
  Caption:= aProperty.Caption;
  Size:= csFixed;
 end;
end;

procedure TPropertiesPanel.MakeBooleanControl(aProperty: TProperty);
begin
 MakeCustomControl(TLabel);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TComboBox);
end;

procedure TPropertiesPanel.MakeChoiceControl(aProperty: TProperty);
begin
 MakeCustomControl(TLabel);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TComboBox);
end;

procedure TPropertiesPanel.MakeControls;
begin
 ClearControls;
 CreateControls(FillControls);
 SetValues;
end;

procedure TPropertiesPanel.MakeCustomControl(aControlClass: TControlClass);
begin
 AddDefControl;
 with f_Controls[Length(f_Controls)-1] do
  ControlClass:= aControlClass;
end;

procedure TPropertiesPanel.MakeIntegerControl(aProperty: TProperty);
begin
 MakeCustomControl(TLabel);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TEdit);
end;

procedure TPropertiesPanel.MakePropertiesControl(aProperty: TProperty);
begin
 MakeCustomControl(TLabel);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TSizeableScrollBox);
end;

function TPropertiesPanel.MakePropertyControl(aProperty: TProperty): Boolean;
var
 i, l_Count: Integer;
begin
 Result:= True;
 if aProperty.Visible then
 begin
  l_Count:= Length(f_Controls);
  case aProperty.PropertyType of
    ptString: MakeStringControl(aProperty);
    ptInteger: MakeIntegerControl(aProperty);
    ptText: MakeTextControl(aProperty);
    ptBoolean: MakeBooleanControl(aProperty);
    ptChoice: MakeChoiceControl(aProperty);
    ptAction: MakeActionControl(aProperty);
    ptProperties: MakePropertiesControl(aProperty);
  end;
  for i:= l_Count to Pred(Length(f_Controls)) do
  begin
   f_Controls[i].Tag:= aProperty.ID;
   f_Controls[i].Event:= aProperty.Event;
  end;
 end; // aProperty.Visible
end;

procedure TPropertiesPanel.MakeStringControl(aProperty: TProperty);
begin
 MakeCustomControl(TLabel);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TEdit);
end;

procedure TPropertiesPanel.MakeTextControl(aProperty: TProperty);
begin
 MakeCustomControl(TLabel);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TSizeableMemo);
end;

procedure TPropertiesPanel.pm_SetProperties(const Value: TProperties);
begin
 f_Properties := Value;
end;

procedure TPropertiesPanel.SetValues;
begin
 // TODO -cMM: TPropertiesPanel.SetValues ���������� �������� ����������
end;

procedure TPropertiesPanel.TuneupControl(aControl: TControl);
var
 l_Property: TProperty;
begin
 l_Property:= TProperty(f_Properties.FindItemID(aControl.Tag));
 if l_Property <> nil then
 begin
 end;
end;

end.