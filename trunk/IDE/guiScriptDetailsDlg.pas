unit guiScriptDetailsDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, QuestModeler;

type
  TScriptDetailsDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    editCaption: TEdit;
    Label2: TLabel;
    memoDescription: TMemo;
    Label3: TLabel;
    editAuthor: TEdit;
    Label4: TLabel;
    comboStartLocation: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function EditScriptDetails(aScript: TdcScript): Boolean;

var
  ScriptDetailsDlg: TScriptDetailsDlg;

implementation


{$R *.dfm}

function EditScriptDetails(aScript: TdcScript): Boolean;
begin
 with TScriptDetailsDlg.Create(Application) do
 try
  editCaption.Text:= aScript.Caption;
  editAuthor.Text:= aScript.Author;
  memoDescription.Lines:= aScript.Description;
  aScript.GetLocationsNames(comboStartLocation.Items);
  comboStartLocation.ItemIndex:= comboStartLocation.Items.IndexOf(aScript.StartLocation);
  Result:= IsPositiveResult(ShowModal);
  if Result then
  begin
   aScript.Caption:= editCaption.Text;
   aScript.Author:= editAuthor.Text;
   aScript.Description.Assign(memoDescription.Lines);
   aScript.StartLocation:= comboStartLocation.Text;
  end;
 finally
  Free;
 end;
end;

end.
