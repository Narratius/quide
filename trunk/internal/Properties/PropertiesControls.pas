unit PropertiesControls;

interface

uses classes, ExtCtrls, StdCtrls, Controls, Propertys, SizeableControls, ParamControls;

type
  TTextButton = class(TPanel)
  end;

  TPropertiesEdit = class(TEdit)
  private
    f_OnSizeChanged: TNotifyEvent;
    function pm_GetOnSizeChanged: TNotifyEvent; stdcall;
    function pm_GetValue: Variant; stdcall;
    procedure pm_SetOnSizeChanged(aValue: TNotifyEvent); stdcall;
    procedure pm_SetValue(const Value: Variant); stdcall;
  public
    property Value: Variant read pm_GetValue write pm_SetValue;
    property OnSizeChanged: TNotifyEvent read pm_GetOnSizeChanged write
        pm_SetOnSizeChanged;
  end;

  TPropertiesComboBox = class(TComboBox)
  private
    f_OnSizeChanged: TNotifyEvent;
    function pm_GetOnSizeChanged: TNotifyEvent; stdcall;
    function pm_GetValue: Variant; stdcall;
    procedure pm_SetOnSizeChanged(aValue: TNotifyEvent); stdcall;
    procedure pm_SetValue(const Value: Variant); stdcall;
  public
    property Value: Variant read pm_GetValue write pm_SetValue;
    property OnSizeChanged: TNotifyEvent read pm_GetOnSizeChanged write
        pm_SetOnSizeChanged;
  end;

  //1 Панель для редактирования одного объекта
  TPropertiesPanel = class(TParamPanel)
  private
  protected
  public
  end;

procedure GetPropertyControls(aProp: TProperty; var l_Controls: TControlsArray);

implementation

procedure GetPropertyControls(aProp: TProperty; var l_Controls: TControlsArray);
var
  i: Integer;
begin
  if aProp.PropertyType in [ptInteger, ptString, ptText, ptBoolean] then
  begin
   if aProp.Caption <> '' then
   begin
    SetLength(l_Controls, 2);
    l_Controls[0].ControlClass:= TLabel;
    l_Controls[0].Height:= cDefaultHeight;
   end
   else
    SetLength(l_Controls, 1);
   i:= Pred(Length(l_Controls));
   l_Controls[i].Height:= cDefaultHeight;
   case aProp.PropertyType of
    ptInteger: l_Controls[i].ControlClass:= TPropertiesEdit;
    ptString : l_Controls[i].ControlClass:= TPropertiesEdit;
    ptText   :
     begin
      l_Controls[i].ControlClass:= TPropertiesMemo;
      l_Controls[i].Height:= 32;
     end;
    ptBoolean: l_Controls[i].ControlClass:= TPropertiesComboBox;
   end;
  end
  else
   SetLength(l_Controls, 0);
end;

{
******************************* TPropertiesEdit ********************************
}
function TPropertiesEdit.pm_GetOnSizeChanged: TNotifyEvent;
begin
  Result := f_OnSizeChanged;
end;

function TPropertiesEdit.pm_GetValue: Variant;
begin
  Result:= Text;
end;

procedure TPropertiesEdit.pm_SetOnSizeChanged(aValue: TNotifyEvent);
begin
  f_OnSizeChanged := aValue;
end;

procedure TPropertiesEdit.pm_SetValue(const Value: Variant);
begin
  Text := Value;
end;

{
***************************** TPropertiesComboBox ******************************
}
function TPropertiesComboBox.pm_GetOnSizeChanged: TNotifyEvent;
begin
  Result := f_OnSizeChanged;
end;

function TPropertiesComboBox.pm_GetValue: Variant;
begin
  Result:= ItemIndex;
end;

procedure TPropertiesComboBox.pm_SetOnSizeChanged(aValue: TNotifyEvent);
begin
  f_OnSizeChanged := aValue;
end;

procedure TPropertiesComboBox.pm_SetValue(const Value: Variant);
begin
  ItemIndex:= Value;
end;

end.
