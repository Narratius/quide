unit PropertiesControls;

interface

uses classes, ExtCtrls, StdCtrls, Controls, Propertys, SizeableControls, ParamControls;

type
  //1 Панель для редактирования одного объекта
  TPropertiesPanel = class(TControlPanel)
  private
   f_Controls: TControlsArray;
   f_Properties: TProperties;
   function MakePropertyControl(aProperty: TProperty): Boolean;
   procedure pm_SetProperties(const Value: TProperties);
  protected
   procedure AddDefControl;
   function FillControls: TControlsArray; virtual;
   procedure GetLastControl(var aRec: TControlRec);
   procedure MakeActionControl(aProperty: TProperty); virtual;
   procedure MakeBooleanControl(aProperty: TProperty); virtual;
   procedure MakeChoiceControl(aProperty: TProperty); virtual;
   procedure MakeCustomControl(aControlClass: TControlClass);
   procedure MakeIntegerControl(aProperty: TProperty); virtual;
   procedure MakeStringControl(aProperty: TProperty); virtual;
   procedure MakeTextControl(aProperty: TProperty); virtual;
   procedure TuneupControl(aControl: TControl); override;
  public
   procedure CorrectControl(aControlRec: TControlRec); virtual;
   procedure MakeControls;
   procedure SetValues;
   procedure GetValues;
   property Properties: TProperties read f_Properties write pm_SetProperties;
  end;

implementation

uses SizeableTypes;

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

procedure TPropertiesPanel.MakeControls;
begin
 ClearControls;
 CreateControls(FillControls);
 SetValues;
end;

procedure TPropertiesPanel.pm_SetProperties(const Value: TProperties);
begin
 f_Properties := Value;
end;

procedure TPropertiesPanel.SetValues;
begin
 // TODO -cMM: TPropertiesPanel.SetValues необходимо написать реализацию
end;

procedure TPropertiesPanel.GetValues;
begin
 // TODO -cMM: TPropertiesPanel.SetValues необходимо написать реализацию
end;

procedure TPropertiesPanel.GetLastControl(var aRec: TControlRec);
begin
 aRec:= f_Controls[Length(f_Controls)-1];
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

function TPropertiesPanel.MakePropertyControl(aProperty: TProperty): Boolean;
begin
 Result:= True;
  case aProperty.PropertyType of
   ptString: MakeStringControl(aProperty);
   ptInteger: MakeIntegerControl(aProperty);
   ptText: MakeTextControl(aProperty);
   ptBoolean: MakeBooleanControl(aProperty);
   ptChoice: MakeChoiceControl(aProperty);
   ptAction: MakeActionControl(aProperty);
 end;
 Вызвать заполнение дополнительных полей, например, заполнить эвент для последующего наполнения свойств 
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
 MakeCustomControl(TSizeableMemo);
end;

procedure TPropertiesPanel.TuneupControl(aControl: TControl);
begin
 
end;

end.
