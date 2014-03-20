unit PropertiesControls;

interface

uses classes, ExtCtrls, StdCtrls, Controls, Propertys, SizeableControls, ParamControls;

type
  //1 Панель для редактирования одного объекта
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
    // Создание контролов
    procedure MakeActionControl(aProperty: TProperty); virtual;
    procedure MakeBooleanControl(aProperty: TProperty); virtual;
    procedure MakeChoiceControl(aProperty: TProperty); virtual;
    procedure MakeCustomControl(aControlClass: TControlClass);
    procedure MakeIntegerControl(aProperty: TProperty); virtual;
    procedure MakeListControl(aProperty: TProperty); virtual;
    procedure MakePropertiesControl(aProperty: TProperty); virtual;
    procedure MakeStringControl(aProperty: TProperty); virtual;
    procedure MakeTextControl(aProperty: TProperty); virtual;
    // Установка значений в контролы
    procedure SetActionValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure SetBooleanValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure SetChoiceValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure SetIntegerValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure SetListValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure SetPropertiesValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure SetStringValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure SetTextValue(aProperty: TProperty; aControl: TControl); virtual;
    // Чтение значений из контролов
    procedure GetActionValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure GetBooleanValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure GetChoiceValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure GetIntegerValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure GetListValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure GetPropertiesValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure GetStringValue(aProperty: TProperty; aControl: TControl); virtual;
    procedure GetTextValue(aProperty: TProperty; aControl: TControl); virtual;
    // Вспомогательные функции
    procedure TuneupControl(aControl: TControl); override;
    function SetOneValue(aProperty: TProperty): Boolean;
    function GetOneValue(aProperty: TProperty): Boolean;
    function ControlByTag(aTag: Integer): TControl;
  public
    procedure CorrectControl(aControlRec: TControlRec); virtual;
    procedure GetValues;
    procedure MakeControls;
    procedure SetValues;
    property Properties: TProperties read f_Properties write pm_SetProperties;
  end;

implementation

uses
 SizeableTypes, PropertiesListControl;

{
******************************* TPropertiesPanel *******************************
}
procedure TPropertiesPanel.AddDefControl;
begin
 SetLength(f_Controls, Length(f_Controls)+1);
 f_Controls[Length(f_Controls)-1]:= cDefControlRec;
end;

function TPropertiesPanel.ControlByTag(aTag: Integer): TControl;
var
 i: Integer;
begin
 Result:= nil;
 for i:= 0 to Pred(ControlCount) do
  if (Controls[i].Tag = aTag) and not (Controls[i] is TLabel) then
  begin
   Result:= Controls[i];
   break;
  end;
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

procedure TPropertiesPanel.GetActionValue(aProperty: TProperty;
  aControl: TControl);
begin
 // Кнопка
end;

procedure TPropertiesPanel.GetBooleanValue(aProperty: TProperty;
  aControl: TControl);
begin
 if aControl is TCheckBox then
  aProperty.Value:= TCheckBox(aControl).Checked;
end;

procedure TPropertiesPanel.GetChoiceValue(aProperty: TProperty;
  aControl: TControl);
begin
 if aControl is TComboBox then
  aProperty.Value:= TComboBox(aControl).ItemIndex;
end;

procedure TPropertiesPanel.GetIntegerValue(aProperty: TProperty;
  aControl: TControl);
begin
 if aControl is TEdit then
  aProperty.Value:= TEdit(aControl).Text;
end;

procedure TPropertiesPanel.GetLastControl(var aRec: TControlRec);
begin
 aRec:= f_Controls[Length(f_Controls)-1];
end;

procedure TPropertiesPanel.GetListValue(aProperty: TProperty;
  aControl: TControl);
begin

end;

function TPropertiesPanel.GetOneValue(aProperty: TProperty): Boolean;
var
 l_C: TControl;
begin
 l_C:= ControlByTag(aProperty.ID);
 if l_C <> nil then
    case aProperty.PropertyType of
      ptString: GetStringValue(aProperty, l_C);
      ptInteger: GetIntegerValue(aProperty, l_C);
      ptText: GetTextValue(aProperty, l_C);
      ptBoolean: GetBooleanValue(aProperty, l_C);
      ptChoice: GetChoiceValue(aProperty, l_C);
      ptAction: GetActionValue(aProperty, l_C);
      ptList: GetListValue(aProperty, l_C);
      ptProperties: GetPropertiesValue(aProperty, l_C);
    end;
 Result:= True;
end;

procedure TPropertiesPanel.GetPropertiesValue(aProperty: TProperty;
  aControl: TControl);
begin

end;

procedure TPropertiesPanel.GetStringValue(aProperty: TProperty;
  aControl: TControl);
begin
 if aControl is TEdit then
  aProperty.Value:= TEdit(aControl).Text;
end;

procedure TPropertiesPanel.GetTextValue(aProperty: TProperty;
  aControl: TControl);
begin
 if aControl is TMemo then
  aProperty.Value:= TMemo(aControl).Text;
end;

procedure TPropertiesPanel.GetValues;
begin
 f_Properties.IterateAll(GetOneValue);
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
 // Почему комбобокс?!
 //MakeCustomControl(TLabel);
 MakeCustomControl(TCheckBox);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 //MakeCustomControl(TComboBox);
end;

procedure TPropertiesPanel.MakeChoiceControl(aProperty: TProperty);
begin
 MakeCustomControl(TLabel);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TComboBox);
 // нужно заполнить список элементов
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

procedure TPropertiesPanel.MakeListControl(aProperty: TProperty);
begin
 { TGroupBox, в который встроены TListBox и три TButton  }
  MakeCustomControl(TPropertiesListControl);
  with f_Controls[Length(f_Controls)-1] do
    Caption:= aProperty.Caption;
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
    ptList: MakeListControl(aProperty);
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
 MakeControls;
end;

procedure TPropertiesPanel.SetActionValue(aProperty: TProperty; aControl: TControl);
begin
 // Кнопка - значение отсутствует
end;

procedure TPropertiesPanel.SetBooleanValue(aProperty: TProperty; aControl: TControl);
begin
 // Чекбокс
 if aControl is TCheckbox then
  TCheckBox(aControl).Checked:= aProperty.Value;
end;

procedure TPropertiesPanel.SetChoiceValue(aProperty: TProperty; aControl: TControl);
begin
 // Комбобокс
 if aControl is TComboBox then
  TComboBox(aControl).ItemIndex:= aProperty.Value;
end;

procedure TPropertiesPanel.SetIntegerValue(aProperty: TProperty; aControl: TControl);
begin
 // Пока Строка ввода
 if aControl is TEdit then
  TEdit(aControl).Text:= aProperty.Value;
end;

procedure TPropertiesPanel.SetListValue(aProperty: TProperty;
  aControl: TControl);
begin

end;

function TPropertiesPanel.SetOneValue(aProperty: TProperty): Boolean;
var
 l_C: TControl;
begin
 l_C:= ControlByTag(aProperty.ID);
 if l_C <> nil then
    case aProperty.PropertyType of
      ptString: SetStringValue(aProperty, l_C);
      ptInteger: SetIntegerValue(aProperty, l_C);
      ptText: SetTextValue(aProperty, l_C);
      ptBoolean: SetBooleanValue(aProperty, l_C);
      ptChoice: SetChoiceValue(aProperty, l_C);
      ptAction: SetActionValue(aProperty, l_C);
      ptProperties: SetPropertiesValue(aProperty, l_C);
    end;
 Result:= True;
end;

procedure TPropertiesPanel.SetPropertiesValue(aProperty: TProperty; aControl: TControl);
begin
 // Панель
end;

procedure TPropertiesPanel.SetStringValue(aProperty: TProperty; aControl: TControl);
begin
 // Строка ввода
 if aControl is TEdit then
  TEdit(aControl).Text:= aProperty.Value;
end;

procedure TPropertiesPanel.SetTextValue(aProperty: TProperty; aControl: TControl);
begin
 // Мемо
 if aControl is TMemo then
  TMemo(aControl).Text:= aProperty.Value;
end;

procedure TPropertiesPanel.SetValues;
begin
 f_Properties.IterateAll(SetOneValue);
end;

procedure TPropertiesPanel.TuneupControl(aControl: TControl);
var
 l_Property: TProperty;
begin
 l_Property:= TProperty(f_Properties.Items[aControl.Tag - propBase]);{ TODO : Переделать на поиск по ID }
 if l_Property <> nil then
 begin
 end;
end;

end.
