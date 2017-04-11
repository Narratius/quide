//1 ������� �����
unit quideObject;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  PropertyIntf, Propertys;

type
  //1 ������� ������
  TquideObject = class(TProperties)
  private
    f_Changed: Boolean;
    //f_GraphID: DWord;
    function pm_GetCaption: string;
    function pm_GetHint: string;
    procedure pm_SetCaption(const Value: string);
    procedure pm_SetHint(const Value: string);
  protected
  public
    constructor Create; virtual;
    constructor Make(const aCaption, aHint: string);
    destructor Destroy; override;
    //1 ���������� � ��������� ���������
    procedure Clear; virtual;
    //1 ��������� ������������� �� ���������� �������� ������������
    function ItsMe(const aCaption: String): Boolean;
    procedure Load(aStream: TStream); virtual;
    procedure Save(aStream: TStream); virtual;
    //1 ��������
    property Caption: string read pm_GetCaption write pm_SetCaption;
    property Changed: Boolean read f_Changed write f_Changed;
    //property GraphID: DWord read f_GraphID write f_GraphID;
    //1 ������� ��������
    property Hint: string read pm_GetHint write pm_SetHint;
  end;


implementation

{
********************************* TquideObject *********************************
}
constructor TquideObject.Create;
begin
 inherited Create;
  Define('Caption', '��������', ptString);
  Define('Hint', '��������', ptString);
end;

constructor TquideObject.Make(const aCaption, aHint: string);
begin
  Create;
  Caption:= aCaption;
  Hint:= aHint;
end;

destructor TquideObject.Destroy;
begin
end;



procedure TquideObject.Clear;
begin
 Caption:= '';
 Hint:= '';
 Changed:= False;
end;

function TquideObject.ItsMe(const aCaption: String): Boolean;
begin
 Result:= AnsiSameText(aCaption, Caption)
end;

procedure TquideObject.Load(aStream: TStream);
begin
 Clear;
 { TODO -o����� : ������-������ �� �������� }
 //Properties.Load(aStream);
 Changed:= False;
end;

function TquideObject.pm_GetCaption: string;
begin
 Result:= Values['Caption'];
end;

function TquideObject.pm_GetHint: string;
begin
 Result:= Values['Hint'];
end;

procedure TquideObject.pm_SetCaption(const Value: string);
begin
 Values['Caption']:= Value;
end;

procedure TquideObject.pm_SetHint(const Value: string);
begin
 Values['Hint']:= Value;
end;

procedure TquideObject.Save(aStream: TStream);
begin
 { TODO -o����� : ������-������ �� �������� }
 //f_Properties.Save(aStream);
 Changed:= False;
end;



end.
