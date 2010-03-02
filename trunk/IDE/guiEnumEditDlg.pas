unit guiEnumEditDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TEnumEditDlg = class(TForm)
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
  EnumEditDlg: TEnumEditDlg;

function EditEnum(var aList: TStrings): Boolean;

implementation

uses Dialogs;

{$R *.dfm}

function EditEnum(var aList: TStrings): Boolean;
begin
  with TEnumEditDlg.Create(nil) do
  try
    ListBox1.Items:= aList;
    Result:= IsPositiveResult(ShowModal);
    if Result then
     aList.Assign(ListBox1.Items);
  finally
    Free;
  end;
end;

procedure TEnumEditDlg.AddButtonClick(Sender: TObject);
var
 l_Item: String;
begin
 l_Item:= '';
 if InputQuery('Элемент', 'Название элемента', l_Item) then
  ListBox1.Items.Add(l_Item);
end;

procedure TEnumEditDlg.DelButtonClick(Sender: TObject);
begin
 if ListBox1.ItemIndex <> -1 then
  if MessageDlg('Вы действительно хотите удалить элемент из списка?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
   ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TEnumEditDlg.EditButtonClick(Sender: TObject);
var
 l_Item: String;
begin
 if ListBox1.ItemIndex <> -1 then
  l_Item:= ListBox1.Items[ListBox1.ItemIndex]
 else
  l_Item:= '';
 if InputQuery('Элемент', 'Название элемента', l_Item) then
  if ListBox1.ItemIndex = -1 then
   ListBox1.Items.Add(l_Item)
  else
   ListBox1.Items[ListBox1.ItemIndex]:= l_Item;
end;

procedure TEnumEditDlg.ListBox1DblClick(Sender: TObject);
begin
 EditButtonClick(Sender);
end;

end.
