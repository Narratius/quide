unit PropTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList,
  Propertys;

type
  TMainForm = class(TForm)
    ShowButton: TButton;
    CheckBox1: TCheckBox;
    ActionList2: TActionList;
    Action1: TAction;
    Action2: TAction;
    SerializeButton: TButton;
    RestoreButton: TButton;
    Bevel1: TBevel;
    InsertButton: TButton;
    procedure ShowButtonClick(Sender: TObject);
    procedure SerializeButtonClick(Sender: TObject);
    procedure RestoreButtonClick(Sender: TObject);
  private
    procedure FillProp(aProp: TProperties);
    procedure FillIf(aProp: TProperties);
    procedure FillList(aProp: TProperties);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

Uses
  PropertyUtils, Menus, System.Rtti, System.TypInfo
  {$IFDEF Debug}, ddLogFile{$ENDIF};

{  Define('Author', 'Автор', ptString);
  DefineList('Variables', 'Переменные', True,
    NewProperty('Caption', 'Название', ptString,
    NewChoiceProperty('VarType', 'Тип',  // vtNumeric, vtText, vtBoolean, vtEnum
      NewChoice(0, 'Число',
      NewChoice(1, 'Строка',
      NewChoice(2, 'Булеан',
      NewChoice(3, 'Перечисление',
      nil)))),
    NewProperty('Value', 'Значение', ptString,
    nil))));
}

var
 gClick: Integer = 0;


procedure TMainForm.ShowButtonClick(Sender: TObject);
var
  l_Prop, l_P: TProperties;
  l_FileName: String;
  l_List: TStrings;
begin
  l_Prop:= TProperties.Create(nil);
  try
   l_P:= TProperties.Create(nil);
   try
    (*
    FillProp(l_P);
    l_P.Values['p1']:= 'Very long text';
    l_P.Values['Date']:= date;
    l_Prop.DefineProps('InnerProps', 'Вложенные свойства', l_P);
    ShowMessage(l_Prop.Values['p1']);
    //FillList(l_Prop);
     *)
    FillIf(l_prop);
   finally
    l_P.Free;
   end;
   ShowPropDialog('Test Properties', l_Prop, CheckBox1.Checked);
  finally
   FreeAndNil(l_Prop);
  end;
end;


procedure TMainForm.FillList(aProp: TProperties);
begin
 aProp.DefineList('Generators', 'Генераторы', True,
        NewProperty('Caption', 'Название', ptString,
        NewProperty('Path', 'Файл генератора', ptString,
        nil)));
end;

procedure TMainForm.FillProp(aProp: TProperties);
begin
  with aProp do
  begin
   Name:= 'Properties1';
   DefineString('p1', 'Long Caption');
   DefineDivider('Даты');
   DefineDate('Date', 'Дата работы');
   DefineTime('Start', 'Начало');
   DefineTime('Finish', 'Окончание');
   NewLines['Start']:= False;
   NewLines['Finish']:= False;
  end;
end;

procedure TMainForm.RestoreButtonClick(Sender: TObject);
var
 l_Prop: TProperties;
begin
  l_Prop:= TProperties.Create(nil);
  try
   LoadFromFile(ChangeFileExt(Application.ExeName, '.data'), l_Prop);
   SaveToFile(ChangeFileExt(Application.ExeName, '.data2'), l_Prop);
   ShowPropDialog('Загруженные данные', l_Prop);
  finally
   FreeAndNil(l_Prop);
  end;
end;

procedure TMainForm.SerializeButtonClick(Sender: TObject);
var
 l_Prop, l_P: TProperties;
begin
  l_Prop:= TProperties.Create(nil);
  try
   l_P:= TProperties.Create(nil);
   try
    FillProp(l_P);
    l_Prop.DefineProps('InnerProps', 'Вложенные свойства', l_P);
   finally
    l_P.Free;
   end;
   SaveToFile(ChangeFileExt(Application.ExeName, '.data'), l_Prop);
  finally
   FreeAndNil(l_Prop);
  end;
end;

procedure TMainForm.FillIf(aProp: TProperties);
begin
 with aProp do
 begin
  (* *)
  DefineChoice('What', 'Если');
  ChoiceStyles['What']:= csEditableList;
  DefineChoice('Condition', '',
    NewChoice(0, 'равно',
    NewChoice(1, 'не равно',
    NewChoice(2, 'больше',
    NewChoice(3, 'меньше',
    NewChoice(4, 'больше или равно',
    NewChoice(5, 'меньше или равно',
    nil)))))));
  DefineString('Value', '');
  NewLines['Condition']:= False;
  NewLines['Value']:= False;
  (* *)
  DefineProps('True', '');
  DefineStaticText('Иначе');
  DefineProps('False', ''); (* *)
 end;
end;

end.
