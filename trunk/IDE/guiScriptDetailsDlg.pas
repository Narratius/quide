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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function EditScriptDetails(var aCaption, aAuthor: String; var aDescription: TStrings): Boolean;

var
  ScriptDetailsDlg: TScriptDetailsDlg;

implementation


{$R *.dfm}

function EditScriptDetails(var aCaption, aAuthor: String; var aDescription: TStrings): Boolean;
begin
 with TScriptDetailsDlg.Create(Application) do
 try
  editCaption.Text:= aCaption;
  editAuthor.Text:= aAuthor;
  memoDescription.Lines:= aDescription;
  Result:= IsPositiveResult(ShowModal);
  if Result then
  begin
   aCaption:= editCaption.Text;
   aAuthor:= editAuthor.Text;
   aDescription.Assign(memoDescription.Lines);
  end;
 finally
  Free;
 end;
end;

end.
