//1 Базовый класс
unit quideObject;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  PropertyIntf, Propertys;

type
  //1 Базовый объект
  TquideObject = class(TPersistent, IquideStore)
  private
    f_Changed: Boolean;
    f_Properties: TProperties;
    function pm_GetCaption: string;
    function pm_GetHint: string;
    procedure pm_SetCaption(const Value: string);
    procedure pm_SetHint(const Value: string);
  protected
    procedure AddProperty(const aAlias, aCaption: String; aType: TPropertyType;
        aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
  public
    constructor Create; virtual;
    constructor Make(const aCaption, aHint: string);
    destructor Destroy; override;
    procedure Assign(aSource: TPersistent);
    //1 Сбрасывает в начальное состояние
    procedure Clear; virtual;
    //1 Проверяет соответствует ли переданное название собственному
    function ItsMe(const aCaption: String): Boolean;
    procedure Load(aStream: TStream); virtual;
    procedure Save(aStream: TStream); virtual;
    //1 Название
    property Caption: string read pm_GetCaption write pm_SetCaption;
    property Changed: Boolean read f_Changed write f_Changed;
    //1 Краткое описание
    property Hint: string read pm_GetHint write pm_SetHint;
  end;


implementation

{
********************************* TquideObject *********************************
}
constructor TquideObject.Create;
begin
  f_Properties := TProperties.Create();
  AddProperty('Caption', 'Название', ptString, nil);
  AddProperty('Hint', 'Описание', ptString, nil);
end;

constructor TquideObject.Make(const aCaption, aHint: string);
begin
  Create;
  Caption:= aCaption;
  Hint:= aHint;
end;

destructor TquideObject.Destroy;
begin
 FreeAndNil(f_Properties);
end;

procedure TquideObject.AddProperty(const aAlias, aCaption: String; aType:
    TPropertyType; aVisible: Boolean = True; aEvent: TNotifyEvent = nil);
var
 l_P: TProperty;
begin
 l_P:= Add;
 l_P.Alias:= aAlias;
 l_P.Caption:= aCaption;
 l_P.PropertyType:= aType;
 l_P.Visible:= aVisible;
 l_P.Event:= aEvent;
end;

procedure TquideObject.Assign(aSource: TPersistent);
begin
 if aSource is TquideObject then
 begin
  f_Properties.Assign(aSource.f_Properies);
 end;
end;

procedure TquideObject.Clear;
begin
 Caption:= '';
 Hint:= '';
 Cahnged:= False;
end;

function TquideObject.ItsMe(const aCaption: String): Boolean;
begin
 Result:= AnsiSameText(aCaption, Caption)
end;

procedure TquideObject.Load(aStream: TStream);
begin
 Clear;
 f_Properties.Load(aStream);
 Changed:= False;
end;

function TquideObject.pm_GetCaption: string;
begin
 Result:= f_Properties.Values['Caption'];
end;

function TquideObject.pm_GetHint: string;
begin
 Result:= f_Properties.Values['Hint'];
end;

procedure TquideObject.pm_SetCaption(const Value: string);
begin
 f_Properties.Values['Caption']:= Value;
end;

procedure TquideObject.pm_SetHint(const Value: string);
begin
 f_Properties.Values['Hint']:= Value;
end;

procedure TquideObject.Save(aStream: TStream);
begin
 f_Properties.Save(aStream);
 Changed:= False;
end;



end.
