unit PropertiesControls;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, stdCtrls, ExtCtrls,
  Propertys;

type
  TAutoSizeMemo = class(TMemo)
  private
    f_LineHeight: Integer;
  public
    constructor Create(aOwner: TComponent); override;
    procedure TextChanged(Sender: TObject);
    property LineHeight: Integer read f_LineHeight write f_LineHeight;
  end;

  TControlsArray = array of TControlClass;
  TPropertiesPanel = class(TPanel)
  private
    f_Properties: TProperties;
    f_PropertyObject: TPropertyObject;
    procedure pm_SetProperties(aValue: TProperties);
    procedure pm_SetPropertyObject(const Value: TPropertyObject);
  public
    constructor Create(aOwner: TComponent); override;
    procedure CreateControl(aProp: TProperty);
    procedure GetControls(PropertyType: TPropertyType; var l_Controls: TControlsArray);
    procedure GetValues;
    procedure ResizeControls(Sender: TObject);
    procedure SetValues;
    property Properties: TProperties read f_Properties write pm_SetProperties;
    property PropertyObject: TPropertyObject read f_PropertyObject write pm_SetPropertyObject;
  end;


implementation


{
******************************** TAutoSizeMemo *********************************
}
constructor TAutoSizeMemo.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  OnChange:= TextChanged;
  LineHeight:= 16;
  Height:= 2*LineHeight + 4;
end;

procedure TAutoSizeMemo.TextChanged(Sender: TObject);
begin
 if Parent <> nil then
  Height:= (Lines.Count+1)*LineHeight + 4;
end;

{
******************************* TPropertiesPanel *******************************
}
constructor TPropertiesPanel.Create(aOwner: TComponent);
begin
  inherited ;
  Caption:= '';
  OnResize:= ResizeControls;
  Height:= 12;
end;

procedure TPropertiesPanel.CreateControl(aProp: TProperty);
var
  l_Controls: TControlsArray;
  l_C: TControl;
  i, l_Top: Integer;
begin
  GetControls(aProp.PropertyType, l_Controls);
  for i:= 0 to Length(l_Controls)-1 do
  begin
   l_C:= l_Controls[i].Create(Self);
   l_C.Name:= l_C.ClassName + IntToStr(Succ(ControlCount));
   l_C.Top:= Height - 4;
   l_C.Left:= 8;
   if l_C is TLabel then
    TLabel(l_C).Caption:= aProp.Caption;
   l_C.Tag:= aProp.Index;
   Height:= l_C.Top + l_C.Height + 8;
   InsertControl(l_C);
  end; // for i
end;

procedure TPropertiesPanel.GetControls(PropertyType: TPropertyType; var l_Controls: TControlsArray);
begin
  SetLength(l_Controls, 2);
  l_Controls[0]:= TLabel;
  case PropertyType of
   ptInteger: l_Controls[1]:= TEdit;
   ptString : l_Controls[1]:= TEdit;
   ptText   : l_Controls[1]:= TAutoSizeMemo;
   ptBoolean: l_Controls[1]:= TComboBox;
  end;
end;

procedure TPropertiesPanel.GetValues;
var
 i: Integer;
begin
 for i:= 0 to ControlCount-1 do
 begin
  if Controls[i] is TEdit then
   Properties[Controls[i].Tag].Value:= TEdit(Controls[i]).Text
  else
  if Controls[i] is TMemo then
   Properties[Controls[i].Tag].Value:= TMemo(Controls[i]).Text;
 end;
end;

procedure TPropertiesPanel.pm_SetProperties(aValue: TProperties);
var
 i: Integer;
begin
  f_Properties := aValue;
  for i:= 0 to Pred(f_Properties.Count) do
  begin
   CreateControl(TProperty(f_Properties.Items[i]));
  end;
  SetValues;
end;

procedure TPropertiesPanel.pm_SetPropertyObject(const Value: TPropertyObject);
begin
 f_PropertyObject := Value;
 Properties:= f_PropertyObject.Properties;
end;

procedure TPropertiesPanel.ResizeControls(Sender: TObject);
var
  i: Integer;
begin
 if Parent <> nil then
 begin
  for i:= 0 to Pred(ControlCount) do
   if not (Controls[i] is TButton) then
    Controls[i].Width:= ClientWidth - 16;
 end;
end;

procedure TPropertiesPanel.SetValues;
var
 i: Integer;
begin
 for i:= 0 to ControlCount-1 do
 begin
  if Controls[i] is TEdit then
   TEdit(Controls[i]).Text:= Properties[Controls[i].Tag].Value
  else
  if Controls[i] is TMemo then
   TMemo(Controls[i]).Text:= Properties[Controls[i].Tag].Value
 end;
end;



end.
