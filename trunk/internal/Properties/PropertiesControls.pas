unit PropertiesControls;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, stdCtrls, ExtCtrls,
  Propertys, Contnrs, Menus, QuestModeler;

type
  TAutoSizeMemo = class(TMemo)
  private
    f_LineHeight: Integer;
  public
    constructor Create(aOwner: TComponent); override;
    procedure TextChanged(Sender: TObject);
    property LineHeight: Integer read f_LineHeight write f_LineHeight;
    property OnResize;
  end;

  TControlAlign = (caNewLine, caInline);
  TControlRec = record
   ControlClass: TControlClass;
   Align       : TControlAlign;
  end;

  TControlsArray = array of TControlRec;
  //1 Панель для редактирования одного объекта
  TPropertiesPanel = class(TPanel)
  private
    f_Controls: TList;
    f_OnControlResize: TNotifyEvent;
    f_Properties: TProperties;
    f_PropertyObject: TPropertyObject;
    procedure pm_SetProperties(aValue: TProperties);
    procedure pm_SetPropertyObject(const Value: TPropertyObject);
  protected
    procedure MyControlResized(Sender: TObject);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateControl(aProp: TProperty);
    procedure GetControls(aProp: TProperty; var l_Controls: TControlsArray); virtual;
    procedure GetValues;
    procedure ResizeControls;
    procedure SetValues;
    property Properties: TProperties read f_Properties write pm_SetProperties;
    property PropertyObject: TPropertyObject read f_PropertyObject write pm_SetPropertyObject;
  published
    property OnControlResize: TNotifyEvent read f_OnControlResize write f_OnControlResize;
  end;

 TTextButton = class(TPanel)
 end;

type
 TPropertiesScrollBox = class(TScrollBox)
 private
  f_EnableResize: Boolean;
  f_OnControlResize: TNotifyEvent;
 protected
  procedure ControlResize(Sender: TObject);
 public
  constructor Create(aOwner: TComponent); override;
  procedure SelfResize(Sender: TObject);
 published
  property OnControlResize: TNotifyEvent read f_OnControlResize write f_OnControlResize;
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
  BevelOuter:= bvNone;
  Caption:= '';
  //OnResize:= ResizeControls;
  Height:= 12;
 f_Controls := TList.Create();
end;

destructor TPropertiesPanel.Destroy;
begin
 FreeAndNil(f_Controls);
 inherited Destroy;
end;

procedure TPropertiesPanel.CreateControl(aProp: TProperty);
var
  l_Controls: TControlsArray;
  l_C: TControl;
  i, l_Top: Integer;
begin
 if aProp.Visible then
 begin
  GetControls(aProp, l_Controls);
  for i:= 0 to Length(l_Controls)-1 do
  begin
   { TODO : Нужно учитывать взаимное расположение }
   l_C:= l_Controls[i].ControlClass.Create(Self);
   l_C.Name:= l_C.ClassName + IntToStr(Succ(ControlCount));
   l_C.Top:= Height - 4;
   l_C.Left:= 8;
   if l_C is TLabel then
    TLabel(l_C).Caption:= aProp.Caption;
   l_C.Tag:= aProp.Index;
   l_C.Width:= Width - 8;
   Height:= l_C.Top + l_C.Height + 8;
   f_Controls.Add(l_C);
   if (l_C is TAutoSizeMemo) then
    TAutoSizeMemo(l_C).OnResize:= MyControlResized
   else
   if l_C is TPropertiesScrollBox then
    TPropertiesScrollBox(l_C).OnControlResize:= MyControlResized;
   InsertControl(l_C);
  end; // for i
 end; // aProp.Visible
end;

procedure TPropertiesPanel.GetControls(aProp: TProperty; var l_Controls: TControlsArray);
var
 i: Integer;
begin
 if aProp.PropertyType in [ptInteger, ptString, ptText, ptBoolean] then
 begin
  if aProp.Caption <> '' then
  begin
   SetLength(l_Controls, 2);
   l_Controls[0].ControlClass:= TLabel;
  end
  else
   SetLength(l_Controls, 1);
  i:= Pred(Length(l_Controls));
  case aProp.PropertyType of
   ptInteger: l_Controls[i].ControlClass:= TEdit;
   ptString : l_Controls[i].ControlClass:= TEdit;
   ptText   : l_Controls[i].ControlClass:= TAutoSizeMemo;
   ptBoolean: l_Controls[i].ControlClass:= TComboBox;
  end;
 end
 else
  SetLength(l_Controls, 0);
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
end;

procedure TPropertiesPanel.pm_SetPropertyObject(const Value: TPropertyObject);
begin
 f_PropertyObject := Value;
 Properties:= f_PropertyObject.Properties;
end;

procedure TPropertiesPanel.ResizeControls;
var
  i: Integer;
begin
 // Расширяем своих детей до собственного размера
 if Parent <> nil then
 begin
  for i:= 0 to Pred(ControlCount) do
   if not (Controls[i] is TButton) then
    Controls[i].Width:= ClientWidth - 16;
 end;
end;

procedure TPropertiesPanel.MyControlResized(Sender: TObject);
var
 l_Index, l_Start: Integer;
begin
 // Нужно сдвинуть всех тех, кто ниже сендера и увеличить собственный размер
 l_Start:= f_Controls.IndexOf(Sender);
 if l_Start <> -1 then
 begin
  for l_Index:= +1 to f_Controls.Count-1 do
  begin
   TControl(f_Controls[l_Index]).Top:= TControl(f_Controls[l_Index-1]).Top + TControl(f_Controls[l_Index-1]).Height + 4
  end;
  ClientHeight:= TControl(f_Controls.Last).Top + TControl(f_Controls.Last).Height + 4;
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

{ TPropertiesScrollBox }

constructor TPropertiesScrollBox.Create(aOwner: TComponent);
begin
 inherited;
 Constraints.MinHeight:= 24;
 Constraints.MinWidth:= 100;
 OnResize:= SelfResize;
end;

procedure TPropertiesScrollBox.ControlResize(Sender: TObject);
var
 i: Integer;
 l_Move: Boolean;
 l_Delta: Integer;
begin
 // Один из контролов изменился. Нужно сдвинуть вниз всех, стоящих за ним
 if f_EnableResize then
 begin
  l_Move:= False;
  l_Delta:= 0;
  for i:= 0 to ControlCount-1 do
  begin
   if l_Move then
    Controls[i].Top:= Controls[i].Top + l_Delta
   else
   if Controls[i] = Sender then
   begin
    l_Move:= True;
    if i < Pred(ControlCount) then
     l_Delta:= Controls[i].Top + Controls[i].Height - Controls[i+1].Top;
   end;
   if Controls[i] is TPropertiesPanel then
    TPropertiesPanel(Controls[i]).ResizeControls;
  end;
 end;
end;

procedure TPropertiesScrollBox.SelfResize(Sender: TObject);
var
 i: Integer;
begin
 for i:= 0 to ControlCount-1 do
 begin
  Controls[i].Width:= ClientWidth;
  (Controls[i] as TPropertiesPanel).ResizeControls;
 end;
end;



end.
