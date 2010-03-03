unit guiEnumEditDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TEnumEditDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    EnumItems: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EnumEditDlg: TEnumEditDlg;

function EditEnum(var aList: TStrings): Boolean;

implementation

{$R *.dfm}

function EditEnum(var aList: TStrings): Boolean;
begin
  with TEnumEditDlg.Create(nil) do
  try
    EnumItems.Lines:= aList;
    Result:= IsPositiveResult(ShowModal);
    if Result then
     aList.Assign(EnumItems.Lines);
  finally
    Free;
  end;
end;

end.
