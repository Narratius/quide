unit PropertiesControls;

interface

uses classes, ExtCtrls, StdCtrls, Controls, Propertys, SizeableControls, ParamControls;

type
  //1 ������ ��� �������������� ������ �������
  TPropertiesPanel = class(TControlPanel)
  private
    f_Properties: TProperties;
    FLabelTop: Boolean;
    function MakePropertyControl(aProperty: TddProperty): Boolean;
    procedure pm_SetProperties(const Value: TProperties);
    procedure SetLabelTop(const Value: Boolean);
  protected
    f_Controls: TControlsArray;
    procedure AddDefControl;
    procedure AdjustControls;
    function FillControls: TControlsArray; virtual;
    procedure GetLastControl(var aRec: TControlRec);
    // �������� ���������
    procedure MakeActionControl(aProperty: TddProperty); virtual;
    procedure MakeBooleanControl(aProperty: TddProperty); virtual;
    procedure MakeCharControl(aProperty: TddProperty); virtual;
    procedure MakeChoiceControl(aProperty: TddProperty); virtual;
    procedure MakeCustomControl(aControlClass: TControlClass; aNewLine: Boolean);
    procedure MakeIntegerControl(aProperty: TddProperty); virtual;
    procedure MakeListControl(aProperty: TddProperty); virtual;
    procedure MakePropertiesControl(aProperty: TddProperty); virtual;
    procedure MakeStringControl(aProperty: TddProperty); virtual;
    procedure MakePasswordControl(aProperty: TddProperty); virtual;
    procedure MakeTextControl(aProperty: TddProperty); virtual;
    procedure MakeStaticText(aProperty: TddProperty); virtual;
    procedure MakeDivider(aProperty: TddProperty); virtual;
    // ��������� �������� � ��������
    procedure SetActionValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetBooleanValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetChoiceValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetIntegerValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetListValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetPropertiesValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetStringValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetTextValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetPasswordValue(aProperty: TddProperty; aControl: TControl); virtual;
    // ������ �������� �� ���������
    procedure GetActionValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetBooleanValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetChoiceValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetIntegerValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetListValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetPropertiesValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetStringValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetTextValue(aProperty: TddProperty; aControl: TControl); virtual;
    // ��������������� �������
    procedure TuneupControl(aControl: TControl); override;
    function SetOneValue(aProperty: TddProperty): Boolean;
    function GetOneValue(aProperty: TddProperty): Boolean;
    function ControlByTag(aTag: Integer): TControl;
    function LabelByTag(aTag: Integer): TControl;
    procedure PropertyByTag(aTag: Integer; aCtrlRec: TControlRec);
  public
    constructor Create(aOwner: TComponent); override;
    procedure CorrectControl(aControlRec: TControlRec); virtual;
    procedure GetValues;
    procedure MakeControls;
    procedure SetValues;
    property Properties: TProperties read f_Properties write pm_SetProperties;
    property LabelTop: Boolean read FLabelTop write SetLabelTop;
  end;


const
  DefLabelClass : TControlClass = TLabel;

implementation

uses
 Variants, Vcl.ComCtrls, SySutils, Math,
 SizeableTypes, PropertiesListControl
 {$IFDEF Debug}, ddLogFile{$ENDIF};

{
******************************* TPropertiesPanel *******************************
}
procedure TPropertiesPanel.AddDefControl;
begin
 SetLength(f_Controls, Length(f_Controls)+1);
 f_Controls[Length(f_Controls)-1]:= cDefControlRec;
end;

procedure TPropertiesPanel.AdjustControls;
var
 l_CurCtrlIdx, l_Cur, j, l_Count: Integer;
 l_CtrlRec: TControlRec;
 l_CurCtrl, l_FirstCtrl: TControl;
 l_Width, l_LblWidth: Integer;
 l_Left, l_Top, l_LeftIndent: Integer;
begin
 { TODO : ��� ��� �������� }
 //exit;
 {$IFDEF Debug}
 Msg2Log('AdjustControls');
 {$ENDIF}
 { ������������ ��������� ������������ �����
  ��������� ������� ����� ������������� �� ���� �� ������
  ����� ����������, ������� ��������� ����� �������� ����������� �� ����� ������
  ���������� ������ � ��������� ���������������, ���� AutoSize ��� ���� �� ������, ���� ���
 }
 l_LeftIndent:= 0;
 {$IFDEF Debug}
 Msg2Log('%s.%d: Left: %d Top: %d Width: %d Height: %d', [ClassName, Tag, Left, Top, Width, Height]);
 {$ENDIF}
 l_CurCtrlIdx:= 0;
 while l_CurCtrlIdx < ControlCount do // ���� �� ���������
 begin
  if (f_Controls[l_CurCtrlIdx].CtrlPosition = cpNewLine) then
  begin
   if f_Controls[l_CurCtrlIdx].LabelPosition = cpInline then
   begin
     l_LblWidth:= LabelByTag(f_Controls[l_CurCtrlIdx].Tag).Width;
     l_LeftIndent:= Max(l_LeftIndent, l_LblWidth);
   end;
  end;
  Inc(l_CurCtrlIdx);
 end; // while l_CurCtrlIdx < ControlCount
 l_FirstCtrl:= nil;
 l_LblWidth:= 0;
 l_Count:= 0;
 l_CurCtrlIdx:= 0;
 while l_CurCtrlIdx < ControlCount do // ���� �� ���������
 begin
  if (f_Controls[l_CurCtrlIdx].CtrlPosition = cpNewLine) then
  begin
   l_FirstCtrl:= ControlByTag(f_Controls[l_CurCtrlIdx].Tag);
   if f_Controls[l_CurCtrlIdx].LabelPosition = cpInline then
   begin
    l_LblWidth:= Max(LabelByTag(f_Controls[l_CurCtrlIdx].Tag).Width, l_LeftIndent);
    if (f_Controls[l_CurCtrlIdx].Size = csAutoSize) and (l_FirstCtrl.Left < l_LeftIndent) then
     l_FirstCtrl.Width:= l_FirstCtrl.Width - (l_LeftIndent - l_FirstCtrl.Left) - 2*cIndent;
    l_FirstCtrl.Left:= l_LeftIndent + 2*cIndent;
   end;
  end
  else
  if (f_Controls[l_CurCtrlIdx].CtrlPosition = cpInline) then
  begin
   if l_FirstCtrl = nil then
   begin
     l_FirstCtrl:= ControlByTag(f_Controls[l_CurCtrlIdx].Tag);
     //l_Count:= 1;
     if f_Controls[l_CurCtrlIdx].LabelPosition = cpInline then
       l_LblWidth:= LabelByTag(f_Controls[l_CurCtrlIdx].Tag).Width;
   end
   else // l_FirstCtrl <> nil
   begin
     l_Cur:= l_CurCtrlIdx;
     // ����� ���������
     while l_CurCtrlIdx < ControlCount do
     begin
      if f_Controls[l_CurCtrlIdx].CtrlPosition = cpInline then
      begin
       if (f_Controls[l_CurCtrlIdx].LabelPosition = cpInline) then
        Inc(l_LblWidth, LabelByTag(f_Controls[l_CurCtrlIdx].Tag).Width);
       Inc(l_CurCtrlIdx);
       Inc(l_Count);
      end
      else
       break
     end; // while
     // ������������
     if l_Count > 0 then
     begin
      l_Width:= (ClientWidth - l_LblWidth-cIndent*(l_Count+1)) div l_Count;
      l_FirstCtrl.Width:= l_Width;
      l_Left:= l_FirstCtrl.Width + l_FirstCtrl.Left+cIndent;
      for j := l_Cur to l_Cur + l_Count-2 do
      begin
       if f_Controls[j].LabelPosition = cpInline then
       begin
        with LabelByTag(f_Controls[j].Tag) do
        begin
         Left:= l_Left{ + cIndent};
         Inc(l_Left, Width);
        end;
       end; // f_Controls[j].LabelPosition = cpInline
       with ControlByTag(f_Controls[j].Tag) do
       begin
        Width:= l_Width; // - (LeftIndent - l_CurCtrl.Left);
        Left:= l_Left + cIndent; //LeftIndent;
        Inc(l_Left, Width);
       end; // l_CurCtrl.Left <> LeftIndent
      end; // for j
     end; // l_Count > 0
   end; // l_FirstCtrl <> nil
  end; // (f_Controls[l_CurCtrlIdx].CtrlPosition = cpInline)
  Inc(l_CurCtrlIdx);
 end; //while i
 Height:= ControlByTag(f_Controls[Pred(ControlCount)].Tag).Top + ControlByTag(f_Controls[Pred(ControlCount)].Tag).Height + cIndent;
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

constructor TPropertiesPanel.Create(aOwner: TComponent);
begin
  inherited;
  fLabelTop:= False;
  ShowHint:= True;
end;

function TPropertiesPanel.FillControls: TControlsArray;
begin
 SetLength(f_Controls, 0);
 if Properties <> nil then
  Properties.IterateAll(MakePropertyControl);
 Result:= f_Controls;
end;

procedure TPropertiesPanel.GetActionValue(aProperty: TddProperty;
  aControl: TControl);
begin
 // ������
end;

procedure TPropertiesPanel.GetBooleanValue(aProperty: TddProperty;
  aControl: TControl);
begin
 if aControl is TCheckBox then
  aProperty.Value:= TCheckBox(aControl).Checked;
end;

procedure TPropertiesPanel.GetChoiceValue(aProperty: TddProperty;
  aControl: TControl);
begin
 if aControl is TComboBox then
  aProperty.Value:= TComboBox(aControl).ItemIndex;
end;

procedure TPropertiesPanel.GetIntegerValue(aProperty: TddProperty;
  aControl: TControl);
begin
 if aControl is TEdit then
  aProperty.Value:= TEdit(aControl).Text;
end;

procedure TPropertiesPanel.GetLastControl(var aRec: TControlRec);
begin
 aRec:= f_Controls[Length(f_Controls)-1];
end;

procedure TPropertiesPanel.GetListValue(aProperty: TddProperty;
  aControl: TControl);
begin

end;

function TPropertiesPanel.GetOneValue(aProperty: TddProperty): Boolean;
var
 l_C: TControl;
begin
 l_C:= ControlByTag(aProperty.ID);
 if l_C <> nil then
    case aProperty.PropertyType of
      ptChar,
      ptString,
      ptPassword: GetStringValue(aProperty, l_C);
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

procedure TPropertiesPanel.GetPropertiesValue(aProperty: TddProperty;
  aControl: TControl);
begin

end;

procedure TPropertiesPanel.GetStringValue(aProperty: TddProperty;
  aControl: TControl);
begin
 if aControl is TEdit then
  aProperty.Value:= TEdit(aControl).Text;
end;

procedure TPropertiesPanel.GetTextValue(aProperty: TddProperty;
  aControl: TControl);
begin
 if aControl is TRichEdit then
  aProperty.Value:= TRichEdit(aControl).Text;
end;

procedure TPropertiesPanel.GetValues;
begin
 f_Properties.IterateAll(GetOneValue);
end;

function TPropertiesPanel.LabelByTag(aTag: Integer): TControl;
var
 i: Integer;
begin
 Result:= nil;
 for i:= 0 to Pred(ControlCount) do
  if (Controls[i].Tag = aTag) and (Controls[i] is TLabel) then
  begin
   Result:= Controls[i];
   break;
  end;
end;

procedure TPropertiesPanel.MakeActionControl(aProperty: TddProperty);
begin
 MakeCustomControl(TButton, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
 begin
  Caption:= aProperty.Caption;
  Size:= csAutoSize;
  LabelPosition:= cpNone;
 end;
end;

procedure TPropertiesPanel.MakeBooleanControl(aProperty: TddProperty);
begin
 // ������ ���������?!
 //MakeCustomControl(TLabel);
 MakeCustomControl(TCheckBox, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 //MakeCustomControl(TComboBox);
end;

procedure TPropertiesPanel.MakeChoiceControl(aProperty: TddProperty);
begin
 MakeCustomControl(TLabel, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TComboBox, aProperty.NewLine);
 if not LabelTop then
  with f_Controls[Length(f_Controls)-1] do
   LabelPosition:= cpInline;
 // ����� ��������� ������ ���������
end;

procedure TPropertiesPanel.MakeControls;
begin
 ClearControls;
 CreateControls(FillControls);
 SetValues;
end;

procedure TPropertiesPanel.MakeCustomControl(aControlClass: TControlClass;
    aNewLine: Boolean);
begin
 AddDefControl;
 with f_Controls[Length(f_Controls)-1] do
 begin
  ControlClass:= aControlClass;
  if not LabelTop then
   LabelPosition:= cpInline
  else
   LabelPosition:= cpNewLine;
  if aNewLine then
    CtrlPosition:= cpNewLine
  else
    CtrlPosition:= cpInline;
 end; // with
end;

procedure TPropertiesPanel.MakeDivider(aProperty: TddProperty);
begin

end;

procedure TPropertiesPanel.MakeIntegerControl(aProperty: TddProperty);
begin
 MakeCustomControl(TLabel, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TEdit, aProperty.NewLine);
 if not LabelTop then
  with f_Controls[Length(f_Controls)-1] do
   LabelPosition:= cpInline;
end;

procedure TPropertiesPanel.MakeListControl(aProperty: TddProperty);
begin
 { TGroupBox, � ������� �������� TListBox � ��� TButton  }
  MakeCustomControl(TPropertiesListControl, aProperty.NewLine);
  with f_Controls[Length(f_Controls)-1] do
  begin
    Caption:= aProperty.Caption;
    LabelPosition:= cpNone;
  end;
end;

procedure TPropertiesPanel.MakePasswordControl(aProperty: TddProperty);
begin
  MakeStringControl(aProperty);
  // TEdit(f_Controls[Length(f_Controls)-1]).PasswordChar:= '*';
end;

procedure TPropertiesPanel.MakePropertiesControl(aProperty: TddProperty);
begin
 MakeCustomControl(TLabel, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TSizeableScrollBox, aProperty.NewLine);
end;

function TPropertiesPanel.MakePropertyControl(aProperty: TddProperty): Boolean;
var
 i, l_Count: Integer;
begin
 Result:= True;
 { Debug }
 if aProperty.Visible then
 begin
  l_Count:= Length(f_Controls);
  case aProperty.PropertyType of
    ptChar: MakeCharControl(aProperty);
    ptString: MakeStringControl(aProperty);
    ptInteger: MakeIntegerControl(aProperty);
    ptText: MakeTextControl(aProperty);
    ptBoolean: MakeBooleanControl(aProperty);
    ptChoice: MakeChoiceControl(aProperty);
    ptAction: MakeActionControl(aProperty);
    ptList: MakeListControl(aProperty);
    ptProperties: MakePropertiesControl(aProperty);
    ptPassword: MakePasswordControl(aProperty);
    ptStaticText: MakeStaticText(aProperty);
    ptDivider: MakeDivider(aProperty);
  end;
  for i:= l_Count to Pred(Length(f_Controls)) do
  begin
   f_Controls[i].ReadOnly:= aProperty.ReadOnly;
   f_Controls[i].Tag:= aProperty.ID;
   f_Controls[i].Event:= aProperty.Event;
   f_Controls[i].Hint:= aProperty.Hint;
   f_Controls[i].OnChange:= aProperty.OnChange;
  end;
 end; // aProperty.Visible
end;

procedure TPropertiesPanel.MakeCharControl(aProperty: TddProperty);
begin
 MakeCustomControl(TLabel, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 MakeCustomControl(TEdit, aProperty.NewLine);
 if not LabelTop then
  with f_Controls[Length(f_Controls)-1] do
   LabelPosition:= cpInline;
 with f_Controls[Length(f_Controls)-1] do
 begin
  Size:= csFixed;
  Width:= 16;
 end;
end;


procedure TPropertiesPanel.MakeStaticText(aProperty: TddProperty);
begin
 MakeCustomControl(TStaticText, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
 begin
  Caption:= aProperty.Caption;
  LabelPosition:= cpNone;
 end;
end;

procedure TPropertiesPanel.MakeStringControl(aProperty: TddProperty);
begin
 MakeCustomControl(TLabel, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
 begin
  Caption:= aProperty.Caption;
 end;
 MakeCustomControl(TEdit, aProperty.NewLine);
end;

procedure TPropertiesPanel.MakeTextControl(aProperty: TddProperty);
begin
 MakeCustomControl(TLabel, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
  Caption:= aProperty.Caption;
 //MakeCustomControl(TSizeableMemo);
 MakeCustomControl(TRichEdit, aProperty.NewLine);
// !!!
 if Caption <> '' then
 begin
   if not LabelTop then
    with f_Controls[Length(f_Controls)-1] do
     LabelPosition:= cpInline;
 end
 else
   with f_Controls[Length(f_Controls)-1] do
     LabelPosition:= cpNone;

end;

procedure TPropertiesPanel.pm_SetProperties(const Value: TProperties);
begin
 f_Properties := Value;
 MakeControls;
 AdjustControls;   //<- �������, ����� ��� ������������ �� ����� �������
end;

procedure TPropertiesPanel.PropertyByTag(aTag: Integer; aCtrlRec: TControlRec);
begin
  aCtrlRec:= f_Controls[aTag-propBase];
end;

procedure TPropertiesPanel.SetActionValue(aProperty: TddProperty; aControl: TControl);
var
 l_S: String;
begin
 // ������ - �������� �����������
  if (aControl is TButton)  then
  begin
    l_S:= VarToStr(aProperty.Value);
    if l_S <> '' then
      TButton(aControl).Caption := l_S;
  end;
end;

procedure TPropertiesPanel.SetBooleanValue(aProperty: TddProperty; aControl: TControl);
var
 l_IsChecked: Boolean;
begin
 // �������
 if (aControl is TCheckbox) then
 begin
  l_IsChecked:= False;
  if not (VarIsClear(aProperty.Value) or VarIsEmpty(aProperty.Value)) then
  begin
   if VarType(aProperty.Value) = vtBoolean then
    l_IsChecked:= aProperty.Value
   else
    l_IsChecked:= StrToBoolDef(VarToStrDef(aProperty.Value, 'False'), False);
  TCheckBox(aControl).Checked:= l_IsChecked;
  end;
 end;
end;

procedure TPropertiesPanel.SetChoiceValue(aProperty: TddProperty; aControl: TControl);
var
  I: Integer;
begin
 // ���������
 if aControl is TComboBox then
 begin
  TComboBox(aControl).Items.Clear;
  for I := 0 to aProperty.ListItemsCount-1 do
   TComboBox(aControl).Items.add(aProperty.ListItems[i].Values['caption']);
  if VarIsEmpty(aProperty.Value) then
    TComboBox(aControl).ItemIndex:= -1
  else
   TComboBox(aControl).ItemIndex:= StrToInt(VarToStrDef(aProperty.Value, '-1'));
 end;
end;

procedure TPropertiesPanel.SetIntegerValue(aProperty: TddProperty; aControl: TControl);
begin
 // ���� ������ �����
 if aControl is TEdit then
  TEdit(aControl).Text:= VarToStr(aProperty.Value);
end;

procedure TPropertiesPanel.SetLabelTop(const Value: Boolean);
begin
  FLabelTop := Value;
end;

procedure TPropertiesPanel.SetListValue(aProperty: TddProperty;
  aControl: TControl);
begin
 if aControl is TPropertiesListControl then
  TPropertiesListControl(aControl).Prop:= aProperty;
end;

function TPropertiesPanel.SetOneValue(aProperty: TddProperty): Boolean;
var
 l_C: TControl;
begin
 l_C:= ControlByTag(aProperty.ID);
 if l_C <> nil then
    case aProperty.PropertyType of
      ptChar,
      ptString: SetStringValue(aProperty, l_C);
      ptInteger: SetIntegerValue(aProperty, l_C);
      ptText: SetTextValue(aProperty, l_C);
      ptBoolean: SetBooleanValue(aProperty, l_C);
      ptChoice: SetChoiceValue(aProperty, l_C);
      ptAction: SetActionValue(aProperty, l_C);
      ptList: SetListValue(aProperty, l_C);
      ptProperties: SetPropertiesValue(aProperty, l_C);
      ptPassword: SetPasswordValue(aProperty, l_C);
    end;
 Result:= True;
end;

procedure TPropertiesPanel.SetPasswordValue(aProperty: TddProperty; aControl: TControl);
begin
  if aControl is TEdit then
  begin
    TEdit(aControl).PasswordChar:= '*';
    TEdit(aControl).Text:= VarToStr(aProperty.Value);
  end;
end;

procedure TPropertiesPanel.SetPropertiesValue(aProperty: TddProperty; aControl: TControl);
begin
 // ������
end;

procedure TPropertiesPanel.SetStringValue(aProperty: TddProperty; aControl: TControl);
begin
 // ������ �����
 if aControl is TEdit then
  TEdit(aControl).Text:= VarToStr(aProperty.Value)
 end;

procedure TPropertiesPanel.SetTextValue(aProperty: TddProperty; aControl: TControl);
begin
 // ����
 if aControl is TRichEdit then
  TRichEdit(aControl).Text:= VarToStr(aProperty.Value);
end;

procedure TPropertiesPanel.SetValues;
begin
 f_Properties.IterateAll(SetOneValue);
end;

procedure TPropertiesPanel.TuneupControl(aControl: TControl);
var
 l_Property: TddProperty;
begin
 l_Property:= TddProperty(f_Properties.Items[aControl.Tag - propBase]);{ TODO : ���������� �� ����� �� ID }
 if l_Property <> nil then
 begin
 end;
end;

end.
