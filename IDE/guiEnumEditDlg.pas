unit guiEnumEditDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TOKRightDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ListBox1: TListBox;
    AddButton: TButton;
    EditButton: TButton;
    DelButton: TButton;
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OKRightDlg: TOKRightDlg;

implementation

uses Dialogs;

{$R *.dfm}

procedure TOKRightDlg.AddButtonClick(Sender: TObject);
begin
 if InputQuery('Элемент', 'Название элемента'
end;

procedure TOKRightDlg.DelButtonClick(Sender: TObject);
begin
 //
end;

procedure TOKRightDlg.EditButtonClick(Sender: TObject);
begin
 //
end;

procedure TOKRightDlg.ListBox1DblClick(Sender: TObject);
begin
 //
end;

end.
