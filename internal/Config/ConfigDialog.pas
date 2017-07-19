unit ConfigDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  PropertiesControls, Propertys, cfgObject;

type
  TConfigDlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    ListSection: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure ListSectionClick(Sender: TObject);
  private
    f_WorkPanel: TPropertiesPanel;
    procedure ResizePanel;
    procedure SetActivePanel(PanelIndex: Integer);
    { Private declarations }
  public
    { Public declarations }
    function Execute(var aConfig: TcfgObject): Boolean;
  end;

var
  ConfigDlg: TConfigDlg;

procedure ShowConfigDlg(aConfig: TcfgObject);

implementation

{$R *.dfm}

function TConfigDlg.Execute(var aConfig: TcfgObject): Boolean;
var
 i: Integer;
 l_Panel: TPropertiesPanel;
begin
 Result:= False;
 for I := 0 to aConfig.SectionCount-1 do
 begin
   l_Panel:= TPropertiesPanel.Create(Self);
   InsertControl(l_Panel);
   l_Panel.Caption:= '';
   l_Panel.Align:= alClient;
   l_Panel.Visible:= False;
   l_Panel.Tag:= 100+i;
   l_Panel.Properties:= aConfig.Sections[i];
   ListSection.Items.Add(aConfig.Sections[i].Caption);
 end; //for i
 ListSection.ItemIndex:= 0;
 SetActivePanel(ListSection.ItemIndex);
 if IsPositiveResult(ShowModal) then
 begin
   Result:= True;
   // Прочитать свойства
   for I := 0 to ControlCount-1 do
    if Controls[i].Tag >= 100 then
    begin
      TPropertiesPanel(Controls[i]).GetValues;
      //aConfig.Sections[Controls[i].Tag-100].Assign(TPropertiesPanel(Controls[i]).Properties);
    end;
 end;
end;

procedure TConfigDlg.FormCreate(Sender: TObject);
begin
 Caption:= 'Настройки приложения';
  // Создание рабочей панели
  (*
  f_WorkPanel:= TPropertiesPanel.Create(Self);
  InsertControl(f_WorkPanel);
  f_WorkPanel.Caption:= '';
  f_WorkPanel.Left:= 0;
  f_WorkPanel.Top:= 0;
  f_WorkPanel.Height:= ClientHeight;
  f_WorkPanel.Width:= Button1.Left - 10;
  *)
end;


procedure TConfigDlg.ListSectionClick(Sender: TObject);
begin
 // переключение панельки
 SetActivePanel(ListSection.ItemIndex);
end;

procedure TConfigDlg.ResizePanel;
begin
 // Подогнать панель и диалог под контролы
 { TODO : Нужно реализовать, иначе фигня, а не диалог }
end;

procedure TConfigDlg.SetActivePanel(PanelIndex: Integer);
var
 i: Integer;
begin
 for I := 0 to ControlCount-1 do
  if Controls[i].Tag >= 100 then
  begin
    Controls[i].Visible:= Controls[i].Tag = 100+PanelIndex;
  end;
end;

procedure ShowConfigDlg(aConfig: TcfgObject);
begin
 with TConfigDlg.Create(Application) do
 try
   Execute(aConfig)
 finally
   Free;
 end;
end;

end.
