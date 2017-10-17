unit PropertiesControls;

interface

uses classes, ExtCtrls, StdCtrls, Controls, Propertys, SizeableControls, ParamControls;

type
  //1 Панель для редактирования одного объекта
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
    // Создание контролов
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
    // Установка значений в контролы
    procedure SetActionValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetBooleanValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetChoiceValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetIntegerValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetListValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetPropertiesValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetStringValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetTextValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure SetPasswordValue(aProperty: TddProperty; aControl: TControl); virtual;
    // Чтение значений из контролов
    procedure GetActionValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetBooleanValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetChoiceValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetIntegerValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetListValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetPropertiesValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetStringValue(aProperty: TddProperty; aControl: TControl); virtual;
    procedure GetTextValue(aProperty: TddProperty; aControl: TControl); virtual;
    // Вспомогательные функции
    procedure TuneupControl(aControl: TControl); override;
    function SetOneValue(aProperty: TddProperty): Boolean;
    function GetOneValue(aProperty: TddProperty): Boolean;
    function ControlByTag(aTag: Integer): TControl;

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
 Variants, Vcl.ComCtrls, SySutils,
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
 i, l_Cur, j, l_Count: Integer;
 l_Ctrl: TControl;
 l_Width: Integer;
begin
 { TODO : Тут все ломается }
 exit;
 {$IFDEF Debug}
 Msg2Log('AdjustControls');
 {$ENDIF}
 // Выравнивание контролов относительно меток
 // Следующий контрол может располагаться на этой же строке
 i:= 0;
 while I < ControlCount do
 begin
  if (f_Controls[i].LabelPosition = cpInline) then
  begin
   l_Ctrl:= ControlByTag(f_Controls[i].Tag);
   //Сдвигать только тех, у кого Inline
   if (l_Ctrl.Left <> LeftIndent) then
   begin
    if (f_Controls[i].Size = csAutoSize) then
    begin
     l_Ctrl.Width:= l_Ctrl.Width - (LeftIndent - l_Ctrl.Left);
     l_Ctrl.Anchors := l_Ctrl.Anchors + [akRight];
    end;
    l_Ctrl.Left:= LeftIndent;
   end;
  end;
  (*
  else
  begin
    l_Cur:= i; // отсюда начнем подгонку
    Inc(i);
    l_Count:= 0;
    while i < ControlCount do
    begin
      if f_Controls[i].Position = cpInline then
      begin
       Inc(i);
       Inc(l_Count);
      end
      else
       break
    end; // while
    if l_Count > 0 then
    begin
      l_Width:= l_Ctrl.Width div Succ(l_Count);
      for j := l_Cur to i do
      begin
         l_Ctrl:= ControlByTag(f_Controls[j].Tag);
         //Сдвигать только тех, у кого Inline
         if (l_Ctrl.Left <> LeftIndent) then
         begin
          l_Ctrl.Width:= l_Width - (LeftIndent - l_Ctrl.Left);
          //l_Ctrl.Anchors := l_Ctrl.Anchors + [akRight];
          l_Ctrl.Left:= LeftIndent;
         end;
      end;
    end;
  end;
  *)
  {$IFDEF Debug}
   with ControlByTag(f_Controls[i].Tag) do
    Msg2Log('Control: %s (Left: %d, Top: %d, Width: %d, Height: %d)', [Name, Left, Top, Width, Height]);
  {$ENDIF}
  Inc(i);
 end; //while i
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
 // Кнопка
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
 // Почему комбобокс?!
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
 // нужно заполнить список элементов
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
 { TGroupBox, в который встроены TListBox и три TButton  }
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
    ptPassword: MakePAsswordControl(aProperty);
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
 if not LabelTop then
  with f_Controls[Length(f_Controls)-1] do
   LabelPosition:= cpInline;
end;

procedure TPropertiesPanel.pm_SetProperties(const Value: TProperties);
begin
 f_Properties := Value;
 MakeControls;
 AdjustControls;   //<- Вернуть, иначе нет выравнивание по левой границе
end;

procedure TPropertiesPanel.SetActionValue(aProperty: TddProperty; aControl: TControl);
var
 l_S: String;
begin
 // Кнопка - значение отсутствует
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
 // Чекбокс
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
 // Комбобокс
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
 // Пока Строка ввода
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
 // Панель
end;

procedure TPropertiesPanel.SetStringValue(aProperty: TddProperty; aControl: TControl);
begin
 // Строка ввода
 if aControl is TEdit then
  TEdit(aControl).Text:= VarToStr(aProperty.Value)
 end;

procedure TPropertiesPanel.SetTextValue(aProperty: TddProperty; aControl: TControl);
begin
 // Мемо
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
 l_Property:= TddProperty(f_Properties.Items[aControl.Tag - propBase]);{ TODO : Переделать на поиск по ID }
 if l_Property <> nil then
 begin
 end;
end;

end.
