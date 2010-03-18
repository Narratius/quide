unit guiLocEditDlgEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuestModeler, ActnList, Menus, ExtCtrls, StdCtrls, quideControls;

type
  TLocationEditExDlg = class(TForm)
    Panel2: TPanel;
    Label1: TLabel;
    editCaption: TEdit;
    Label2: TLabel;
    HintEdit: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LogicActionExecute(Sender: TObject);
    procedure TextActionExecute(Sender: TObject);
  private
    f_ActionFrame: TqcActionsScrollBox;
    f_Location: TdcLocation;
    function pm_GetLocation: TdcLocation;
    procedure pm_SetLocation(const Value: TdcLocation);
    { Private declarations }
  public
    property Location: TdcLocation read pm_GetLocation write pm_SetLocation;
    { Public declarations }
  end;

function EditLocationEx(aLocation: TdcLocation): Boolean;

var
  Form1: TLocationEditExDlg;

implementation

uses
 StrUtils;

{$R *.dfm}

function EditLocationEx(aLocation: TdcLocation): Boolean;
begin
 with TLocationEditExDlg.Create(nil) do
 try
  Location:= aLocation;
  Result:= IsPositiveResult(ShowModal);
  if Result then
   aLocation.Assign(Location)
 finally
  Free;
 end;
end;

procedure TLocationEditExDlg.FormCreate(Sender: TObject);
begin
 f_ActionFrame:= TqcActionsScrollBox.Create(Self);
 f_ActionFrame.Align:= alClient;
 InsertControl(f_ActionFrame);
end;

procedure TLocationEditExDlg.FormDestroy(Sender: TObject);
begin
 FreeAndNil(f_Location);
end;

procedure TLocationEditExDlg.LogicActionExecute(Sender: TObject);
begin
 f_ActionFrame.Add(TdcLogicAction.Create(Location.Script));
end;

function TLocationEditExDlg.pm_GetLocation: TdcLocation;
begin
 f_Location.Caption:= editCaption.Text;
 f_Location.Hint:= HintEdit.Text;
 //f_Location.ActionList:= f_ActionFrame.ActionList;
 //f_ActionFrame.GetLocationData;
 Result := f_Location;
end;

procedure TLocationEditExDlg.pm_SetLocation(const Value: TdcLocation);
begin
 f_Location := Value.Clone(Value.Script);
 editCaption.Text:= f_Location.Caption;
 HintEdit.Text:= f_Location.Hint;
 Caption:= IfThen(f_Location.Caption = '', '����� �������', f_Location.Caption);
 f_ActionFrame.Script:= f_Location.Script;
 f_ActionFrame.Actions:= f_Location.ActionList;
end;

procedure TLocationEditExDlg.TextActionExecute(Sender: TObject);
begin
 f_ActionFrame.Add(TdcTextAction.Create(Location.Script));
end;

end.
