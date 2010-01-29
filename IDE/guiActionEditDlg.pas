unit guiActionEditDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls,
  QuestModeler;

type
  TActionEditDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    editCaption: TEdit;
    Label2: TLabel;
    memoDescription: TMemo;
    Label3: TLabel;
    ComboBox1: TComboBox;
    procedure editCaptionChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ActionEditDlg: TActionEditDlg;

function EditAction(aAction: TdcGotoAction; theModel: TdcScript): Boolean;

implementation

{$R *.dfm}

Uses
 Dialogs;

const
 defText = 'Выберите или задайте название локации';

function EditAction(aAction: TdcGotoAction; theModel: TdcScript): Boolean;
begin
 with TActionEditDlg.Create(nil) do
 try
   editCaption.Text:= aAction.Caption;
   ComboBox1.Text:= defText;
   theModel.Locations2Strings(ComboBox1.Items);
   if aAction.Location <> nil then
    ComboBox1.ItemIndex:= ComboBox1.Items.IndexOf(aAction.Location.Caption);
   Result:= IsPositiveResult(ShowModal);
   if Result then
   begin
     aAction.Caption:= editCaption.Text;
     aAction.Location:= theModel.FindLocation(comboBox1.Text);
     if (aAction.Location = nil) and not AnsiSameText(ComboBox1.Text, defText) then
      if IsPositiveResult(MessageDlg('Указанная локация не существует. Создать?', mtConfirmation, [mbYes, mbNo], 0)) then
       aAction.Location:= theModel.NewLocation(comboBox1.Text);
   end;
 finally
   Free;
 end;
end;

procedure TActionEditDlg.editCaptionChange(Sender: TObject);
begin
 Caption:= editCaption.Text;
end;

end.
