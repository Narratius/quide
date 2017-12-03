unit PropertiesControls;

interface

uses
  Classes, ExtCtrls, StdCtrls, Controls, Types,
  Propertys, SizeableControls, ParamControls;

type
  //1 Панель для редактирования одного объекта
  TPropertiesPanel = class(TControlPanel)
  private
    f_Properties: TProperties;
    FLabelTop: Boolean;
    function MakePropertyControl(aProperty: TddProperty): Boolean;
    procedure pm_SetProperties(const Value: TProperties);
    procedure SetLabelTop(const Value: Boolean);
    function pm_GetCtrlCount: Integer;
  protected
    f_Controls: TControlsArray;
    procedure AddDefControl;
    procedure AdjustControls;
    function FillControls: TControlsArray; virtual;
    procedure GetLastControl(var aRec: TControlRec);
    procedure PropChanged(Sender: TObject);
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
    procedure MakeStaticText(aProperty: TddProperty); virtual;
    procedure MakeDivider(aProperty: TddProperty); virtual;
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
    function LabelByTag(aTag: Integer): TControl;
    procedure PropertyByTag(aTag: Integer; aCtrlRec: TControlRec);
  protected
    property CtrlCount: Integer read pm_GetCtrlCount;
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
 Variants, Vcl.ComCtrls, SySutils, Math, Dialogs,
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
 l_CurCtrlIdx, l_Cur, i, j, l_Count, l_LblCount: Integer;
 l_CtrlRec: TControlRec;
 l_CurCtrl, l_FirstCtrl: TControl;
 l_Width, l_LblWidth: Integer;
 l_Left, l_Top, l_LeftIndent: Integer;

 function lf_CtrlByTag(aTag: Integer): Integer;
 var
  i: Integer;
 begin
  Result:= -1;
   for I := 0 to Pred(Length(f_Controls)) do
    if f_Controls[i].Tag = aTag then
    begin
     Result:= i;
     break
    end;
 end;


 procedure lp_SetMaxLeftIndent;
 begin
  l_CurCtrlIdx:= 0;
  // Максимальная длина метки для выравнивания
  while l_CurCtrlIdx < CtrlCount do // цикл по контролам
  begin
   if (f_Controls[l_CurCtrlIdx].CtrlPosition = cpNewLine) then
   begin
    if f_Controls[l_CurCtrlIdx].LabelPosition = cpInline then
    begin
      l_LblWidth:= LabelByTag(f_Controls[l_CurCtrlIdx].Tag).Width;
      l_LeftIndent:= Max(l_LeftIndent, l_LblWidth+cIndent);
    end;
   end;
   Inc(l_CurCtrlIdx);
  end; // while l_CurCtrlIdx < ControlCount
 end;

 procedure lp_SetFirstCtrl;
 begin
   l_FirstCtrl:= ControlByTag(f_Properties.Items[l_CurCtrlIdx].ID);
   if f_Controls[lf_CtrlByTag(f_Properties.Items[l_CurCtrlIdx].ID)].LabelPosition = cpInline then
   begin
     // Подгонка отступа и ширины по левому краю
     l_FirstCtrl.Left:= l_LeftIndent + cIndent;
     if f_Controls[lf_CtrlByTag(l_FirstCtrl.Tag)].Size = csAutoSize then
      l_FirstCtrl.Width:= ClientWidth - l_FirstCtrl.Left - cIndent;
     l_LblWidth:= l_FirstCtrl.Left-2*cIndent;//LabelByTag(f_Properties.Items[l_CurCtrlIdx].ID).Width;
   end;
 end;

begin
 {$IFDEF Debug}
 Msg2Log('AdjustControls');
 {$ENDIF}
 { Выравнивание контролов относительно меток
  Следующий контрол может располагаться на этой же строке
  Нужно подсчитать, сколько контролов после текущего расположено на одной строке
  Подсчитать ширины и выровнять пропорционально, если AutoSize или друг за другом, если нет
 }
 l_LeftIndent:= 0;
 {$IFDEF Debug}
 Msg2Log('%s.%d: Left: %d Top: %d Width: %d Height: %d', [ClassName, Tag, Left, Top, Width, Height]);
 {$ENDIF}

 lp_SetMaxLeftIndent;

 // Масштабирование и выравнивание контролов в строке
 l_FirstCtrl:= nil;
 l_LblWidth:= 0;
 l_Count:= 0;
 l_CurCtrlIdx:= 0;
 l_LblCount:= 0;
 while l_CurCtrlIdx < f_Properties.Count do // цикл по свойствам
 begin
  // каждый контрол с новой строки считается первым в строке
  if (f_Properties.Items[l_CurCtrlIdx].NewLine) then
   lp_SetFirstCtrl
  else
  if not f_Properties.Items[l_CurCtrlIdx].NewLine then
  begin
   // Считаем количество контролов в одной строке и ширину их меток
   if l_FirstCtrl = nil then
     lp_SetFirstCtrl
   else // l_FirstCtrl <> nil
   begin
     l_Cur:= l_CurCtrlIdx;
     // Поиск контролов
     while l_CurCtrlIdx < f_Properties.Count do
     begin
      if not f_Properties.Items[l_CurCtrlIdx].NewLine then
      begin
       if (f_Controls[lf_CtrlByTag(f_Properties.Items[l_CurCtrlIdx].ID)].LabelPosition = cpInline) then
       begin
        Inc(l_LblWidth, LabelByTag(f_Properties.Items[l_CurCtrlIdx].ID).Width+cIndent);
        Inc(l_LblCount);
       end;
       Inc(l_CurCtrlIdx);
       Inc(l_Count);
      end
      else
       break
     end; // while
     // Выравнивание
     if l_Count > 0 then
     begin
      if l_LblCount > 0 then
       Inc(l_LblWidth, cIndent);
      { TODO : Ширина не учитывает один отступ }
      l_Width:= (ClientWidth - l_LblWidth-cIndent*(l_Count+l_lblCount+1{метка первого контрола}+2{последний отступ})) div (l_Count+1);
      l_FirstCtrl.Width:= l_Width;
      l_FirstCtrl.Anchors:= [akLeft, akTop];
      l_Left:= l_FirstCtrl.Width + l_FirstCtrl.Left;
      for i := l_Cur to l_Cur + l_Count-1 do
      begin
       j:= lf_CtrlByTag(f_Properties.Items[i].ID);
       if f_Controls[j].LabelPosition = cpInline then
       begin
        with LabelByTag(f_Controls[j].Tag) do
        begin
         Left:= l_Left + cIndent;
         Inc(l_Left, Width+cIndent);
        end;
       end; // f_Controls[j].LabelPosition = cpInline
       with ControlByTag(f_Controls[j].Tag) do
       begin
        Anchors:= [akLeft, akTop];
        Width:= l_Width; // - (LeftIndent - l_CurCtrl.Left);
        Left:= l_Left + cIndent; //LeftIndent;
        Inc(l_Left, Width+cIndent);
       end; // l_CurCtrl.Left <> LeftIndent
      end; // for j
     end; // l_Count > 0
   end; // l_FirstCtrl <> nil
  end; // (f_Controls[l_CurCtrlIdx].CtrlPosition = cpInline)
  Inc(l_CurCtrlIdx);
 end; //while i
 if CtrlCount > 0 then
 
 Height:= ControlByTag(f_Controls[Pred(CtrlCount)].Tag).Top + ControlByTag(f_Controls[Pred(CtrlCount)].Tag).Height + cIndent;
 {$IFDEF Debug}
 for j := 0 to ControlCount-1 do
  with Controls[j] do
   Msg2Log('%s.%d: Left: %d Top: %d Width: %d Height: %d', [ClassName, Tag, Left, Top, Width, Height]);
 {$ENDIF}
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
 begin
  if aProperty.ChoiceStyle = csEditableList then
   aProperty.CheckItem(TComboBox(aControl).Text)
  else
   aProperty.Value:= TComboBox(aControl).ItemIndex;
 end;
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
 MakeCustomControl(TCheckBox, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
 begin
  Caption:= aProperty.Caption;
  LabelPosition:= cpNone;
 end;
end;

procedure TPropertiesPanel.MakeChoiceControl(aProperty: TddProperty);
begin
 if aProperty.Caption <> '' then
 begin
   MakeCustomControl(TLabel, aProperty.NewLine);
   with f_Controls[Length(f_Controls)-1] do
    Caption:= aProperty.Caption;
 end;
 MakeCustomControl(TComboBox, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
 begin
   if aProperty.Caption = '' then
     LabelPosition:= cpNone
   else
     if not LabelTop then
       LabelPosition:= cpInline;
   ChoiceStyle:= aProperty.ChoiceStyle;
 end; // with
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
 if aProperty.Caption <> '' then
 begin
  MakeCustomControl(TLabel, aProperty.NewLine);
  with f_Controls[Length(f_Controls)-1] do
   Caption:= aProperty.Caption;
 end;
 MakeCustomControl(TPropertiesPanel, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
 begin
  if aProperty.ListItem <> nil then
  begin
   //Menu:= aProperty.ListItem.Menu;
   SubItem:= aProperty.ListItem;
  end;
  if aProperty.Caption = '' then
   LabelPosition:= cpNone;
 end;
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
 if aProperty.Caption <> '' then
 begin
  MakeCustomControl(TLabel, aProperty.NewLine);
  with f_Controls[Length(f_Controls)-1] do
   Caption:= aProperty.Caption;
 end;
 MakeCustomControl(TEdit, aProperty.NewLine);
 with f_Controls[Length(f_Controls)-1] do
 begin
   if aProperty.Caption = '' then
     LabelPosition:= cpNone
   else
     if not LabelTop then
       LabelPosition:= cpInline;
 end; // with
end;

procedure TPropertiesPanel.MakeTextControl(aProperty: TddProperty);
begin
 if aProperty.Caption <> '' then
 begin
   MakeCustomControl(TLabel, aProperty.NewLine);
   with f_Controls[Length(f_Controls)-1] do
    Caption:= aProperty.Caption;
 end;
 //MakeCustomControl(TSizeableMemo);
 { TODO : Нужно бы поменять обратно... }
 MakeCustomControl(TRichEdit, aProperty.NewLine);
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

function TPropertiesPanel.pm_GetCtrlCount: Integer;
begin
  Result:= Length(f_Controls);
end;

procedure TPropertiesPanel.pm_SetProperties(const Value: TProperties);
begin
 f_Properties := Value;
 PopUpMenu:= f_Properties.Menu;
 MakeControls;
 AdjustControls;
 f_Properties.OnPanelStructureChange:= PropChanged;
end;

procedure TPropertiesPanel.PropChanged(Sender: TObject);
begin
 MakeControls;
 AdjustControls;
end;

procedure TPropertiesPanel.PropertyByTag(aTag: Integer; aCtrlRec: TControlRec);
begin
  aCtrlRec:= f_Controls[aTag-propBase];
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
