unit dobTextActionEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TdobTextFrame = class(TFrame)
    TextMemo: TMemo;
    procedure TextMemoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TdobTextFrame.TextMemoChange(Sender: TObject);
var
 l_TextHeight : Integer;
 l_Canvas: TCanvas;
 l_P: TWinControl;
begin
 l_P:= Parent;
 if l_P <> nil then
 begin
  while not (l_P is TCustomForm) do l_P:= l_P.Parent;
  l_Canvas:= (l_P as TCustomForm).Canvas;
  l_TextHeight:= l_Canvas.TextHeight('A')*(TextMemo.Lines.Count+1);
  ClientHeight:= l_textHeight;
 end; 
end;

end.
