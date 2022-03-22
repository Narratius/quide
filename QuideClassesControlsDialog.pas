unit QuideClassesControlsDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  QuideClasses;

type
  TQuideClassDialog = class(TForm)
    pnlControls: TPanel;
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
  private
    FQuideObject: TquideCustomStoryItem;
    procedure SetQuideObject(const Value: TquideCustomStoryItem);
    { Private declarations }
  public
    procedure GetQuideObject;
    property QuideObject: TquideCustomStoryItem read FQuideObject write
        SetQuideObject;
    { Public declarations }
  end;


function ShowQuideDialog(aQuideObject: TquideCustomStoryItem): Boolean;

implementation

{$R *.dfm}

Uses
  QuideClassesControls;

function ShowQuideDialog(aQuideObject: TquideCustomStoryItem): Boolean;
var
  l_Dlg: TQuideClassDialog;
begin
  Result := False;
  l_Dlg:= TQuideClassDialog.Create(Application);
  try
    l_Dlg.QuideObject:= aQuideObject;
    Result:= IsPositiveResult(l_Dlg.ShowModal);
    if Result then
      l_Dlg.GetQuideObject;
  finally
    l_Dlg.Free;
  end;
end;

procedure TQuideClassDialog.GetQuideObject;
begin
  (pnlControls.Controls[0] as TquideCustomControl).GetQuideObject;
end;

procedure TQuideClassDialog.SetQuideObject(const Value: TquideCustomStoryItem);
var
  l_Ctrl: TquideCustomControl;
  l_Class: TquideControlClass;
begin
  FQuideObject := Value;
  Caption:= FQuideObject.Caption;
  l_Class:= GetQuideControlClass(FQuideObject);

  l_Ctrl:= l_Class.Create(pnlControls, FQuideObject);

  pnlControls.InsertControl(l_Ctrl);
  l_Ctrl.DoAfterInsert;
end;

end.
