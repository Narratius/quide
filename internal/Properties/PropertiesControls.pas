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
    procedure pm_SetProperties(aValue: TProperties);
  public
    constructor Create(aOwner: TComponent); override;
    procedure CreateControl(aProp: TProperty);
    procedure GetControls(PropertyType: TPropertyType; var l_Controls: TControlsArray);
    procedure GetValues;
    procedure ResizeControls(Sender: TObject);
    procedure SetValues;
    property Properties: TProperties read f_Properties write pm_SetProperties;
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
  OnResize:= ResizeControls;
end;

procedure TPropertiesPanel.CreateControl(aProp: TProperty);
var
  l_Controls: TControlsArray;
  l_C: TControl;
  i: Integer;
begin
  GetControls(aProp.PropertyType, l_Controls);
  for i:= 0 to Length(l_Controls)-1 do
  begin
   l_C:= l_Controls[i].Create(Self);
   l_C.Name:= l_C.ClassName + IntToStr(Succ(ControlCount));
   if ControlCount > 0 then
    l_C.Top:= Controls[Pred(ControlCount)].Top + 8 + Controls[Pred(ControlCount)].Height
   else
    l_C.Top:= 8;
   l_C.Left:= 8;
   if l_C is TLabel then
    TLabel(l_C).Caption:= aProp.Caption;
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
begin
end;

procedure TPropertiesPanel.pm_SetProperties(aValue: TProperties);
var
 i: Integer;
begin
  f_Properties := aValue;
  Height:= f_Properties.Count*24 + 16;
  for i:= 0 to Pred(f_Properties.Count) do
  begin
   CreateControl(TProperty(f_Properties.Items[i]));
   SetValues;
  end;
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
begin
end;



end.
