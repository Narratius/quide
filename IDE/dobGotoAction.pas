unit dobGotoAction;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, QuestModeler;

type
  TGotoActionFrame = class(TFrame)
    Panel1: TPanel;
    LocationList: TListBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    { Public declarations }
   f_Model: TdcScript;
    function pm_GetGotoLocation: String;
    procedure pm_SetGotoLocation(const Value: String);
   procedure pm_SetModel(const Value: TdcScript);
    { Private declarations }
  public
    property GotoLocation: String read pm_GetGotoLocation write pm_SetGotoLocation;
   property Model: TdcScript read f_Model write pm_SetModel;
  end;

implementation

{$R *.dfm}

procedure TGotoActionFrame.Button1Click(Sender: TObject);
var
 l_S: String;
begin
 // запросить имя локации
 l_S:= Model.GenerateCaption;
 if InputQuery('Новая локация', 'Введите имя локации', l_S) then
 begin
  LocationList.Items.Add(l_S);
  LocationList.ItemIndex:= LocationList.Items.IndexOf(l_S);
  // Создать новую локацию
  f_Model.NewLocation(l_S);
 end;
end;

procedure TGotoActionFrame.FrameResize(Sender: TObject);
begin
 LOcationList.Height:= ClientHeight - LocationList.Top - 4;
end;

function TGotoActionFrame.pm_GetGotoLocation: String;
begin
 if LocationList.ItemIndex > -1 then
  Result := LocationList.Items.Strings[LocationList.ItemIndex]
 else
  Result:= '';
end;

procedure TGotoActionFrame.pm_SetGotoLocation(const Value: String);
begin
 LocationList.ItemIndex:= LocationList.Items.IndexOf(Value);
end;

procedure TGotoActionFrame.pm_SetModel(const Value: TdcScript);
begin
 f_Model := Value;
 f_Model.Locations2Strings(LocationList.Items);
end;

end.
