unit dobButtonAction;
{ Редактирование кнопки }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, QuestModeler;

type
  TButtonFrame = class(TFrame)
    Panel1: TPanel;
    comboLocations: TComboBox;
    Label1: TLabel;
    editCaption: TEdit;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Public declarations }
   f_Script: TdcScript;
    function pm_GetGotoLocation: String;
    procedure pm_SetGotoLocation(const Value: String);
   procedure pm_SetScript(const Value: TdcScript);
    { Private declarations }
  public
    property GotoLocation: String read pm_GetGotoLocation write pm_SetGotoLocation;
   property Script: TdcScript read f_Script write pm_SetScript;
  end;

implementation

{$R *.dfm}

procedure TButtonFrame.Button1Click(Sender: TObject);
var
 l_S: String;
begin
 // запросить имя локации
 l_S:= Script.GenerateCaption;
 if InputQuery('Новая локация', 'Введите имя локации', l_S) then
 begin
  comboLocations.Items.Add(l_S);
  comboLocations.ItemIndex:= comboLocations.Items.IndexOf(l_S);
  // Создать новую локацию
  f_Script.NewLocation(l_S);
 end;
end;

procedure TButtonFrame.FrameResize(Sender: TObject);
begin
 comboLocations.Height:= ClientHeight - comboLocations.Top - 4;
end;

function TButtonFrame.pm_GetGotoLocation: String;
begin
 if comboLocations.ItemIndex > -1 then
  Result := comboLocations.Items.Strings[comboLocations.ItemIndex]
 else
  Result := '';
end;

procedure TButtonFrame.pm_SetGotoLocation(const Value: String);
begin
 comboLocations.ItemIndex:= comboLocations.Items.IndexOf(Value);
end;

procedure TButtonFrame.pm_SetScript(const Value: TdcScript);
begin
 f_Script := Value;
 f_Script.Locations2Strings(comboLocations.Items);
end;

end.
