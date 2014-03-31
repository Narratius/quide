unit SizeableControls;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, stdCtrls, ExtCtrls,
  Contnrs, Menus, SizeableIntf, SizeableTypes;

type
  TSizeableMemo = class(TMemo, ISizeableControl)
  private
    f_LineHeight: Integer;
    f_OnSizeChanged: TNotifyEvent;
    function pm_GetLineHeight: Integer;
    function pm_GetOnSizeChanged: TNotifyEvent; stdcall;
    function pm_GetValue: Variant; stdcall;
    procedure pm_SetOnSizeChanged(aValue: TNotifyEvent); stdcall;
    procedure pm_SetValue(const Value: Variant); stdcall;
  public
    constructor Create(aOwner: TComponent); override;
    procedure SizeChanged; stdcall;
    procedure TextChanged(Sender: TObject);
    property LineHeight: Integer read pm_GetLineHeight write f_LineHeight;
    property Value: Variant read pm_GetValue write pm_SetValue;
    property OnSizeChanged: TNotifyEvent read pm_GetOnSizeChanged write
        pm_SetOnSizeChanged;
  end;

  //1 Панель для редактирования одного объекта
  TSizeablePanel = class(TPanel, IControlContainer, ISizeableControl)
  private
    f_InnerControls: TList;
    f_Locked: Integer;
    f_OnSizeChanged: TNotifyEvent;
    function pm_GetOnSizeChanged: TNotifyEvent; stdcall;
    procedure pm_SetOnSizeChanged(aValue: TNotifyEvent); stdcall;
  protected
    procedure Lock; stdcall;
    function Locked: Boolean; stdcall;
    procedure MyControlResized(Sender: TObject);
    procedure Unlock; stdcall;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddControl(aControl: TControl; aSize: TControlSize; aPosition:
        TControlPosition); stdcall;
    procedure ResizeControls;
    procedure SizeChanged; stdcall;
    property OnSizeChanged: TNotifyEvent read pm_GetOnSizeChanged write
        pm_SetOnSizeChanged;
  end;

type
  TSizeableScrollBox = class(TScrollBox, IControlContainer, ISizeableControl)
  private
    f_EnableResize: Boolean;
    f_InnerControls: TList;
    f_Locked: Integer;
    f_OnSizeChanged: TNotifyEvent;
    function pm_GetOnSizeChanged: TNotifyEvent; stdcall;
    function pm_GetValue: Variant; stdcall;
    procedure pm_SetOnSizeChanged(aValue: TNotifyEvent); stdcall;
    procedure pm_SetValue(const Value: Variant); stdcall;
  protected
    procedure Lock; stdcall;
    function Locked: Boolean; stdcall;
    procedure MyControlResized(Sender: TObject);
    procedure Unlock; stdcall;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddControl(aControl: TControl; aSize: TControlSize; aPosition:
        TControlPosition); stdcall;
    procedure SelfResize(Sender: TObject);
    procedure SizeChanged; stdcall;
    property Value: Variant read pm_GetValue write pm_SetValue;
    property OnSizeChanged: TNotifyEvent read pm_GetOnSizeChanged write
        pm_SetOnSizeChanged;
  end;

procedure AddInnerControl(aParent: TWinControl; aControls: TList; aMyControlResized: TNotifyEvent;
    aControl: TControl; aSize: TControlSize; aPosition: TControlPosition); stdcall;

const
 cDefaultHeight = -1;
 cIndent        = 4;

implementation

uses
 Math;

procedure AddInnerControl(aParent: TWinControl; aControls: TList; aMyControlResized: TNotifyEvent;
    aControl: TControl; aSize: TControlSize; aPosition: TControlPosition);
var
  l_IC: ISizeableControl;
begin
 if aControls.Count > 0 then
 begin
  case aPosition of
   cpNewLine:
    begin
     aControl.Top:= cIndent + TControl(aControls[aControls.Count-1]).Top + TControl(aControls[aControls.Count-1]).Height;
     aControl.Left:= cIndent;
     aParent.Height:= aParent.Height + aControl.Height + cIndent;
    end;
   cpInline:
    begin
     { TODO -oДД -cУлучшение на будущее : Тут может быть больше одного элемента }
     aControl.Top:= TControl(aControls[aControls.Count-1]).Top;
     aControl.Left:= cIndent + TControl(aControls[aControls.Count-1]).Left + TControl(aControls[aControls.Count-1]).Width;
     aControl.Width:= aParent.ClientWidth - cIndent - aControl.Left;
    end;
  end;
 end
 else
 begin
  aControl.Top:= cIndent;
  aControl.Left:= cIndent;
  aParent.Height:= aControl.Height + 2*cIndent;
 end;
 if (aSize = csAutoSize) and (aPosition = cpNewLine) then
 begin
  aControl.Width:= aParent.ClientWidth - 2*cIndent;
  aControl.Anchors:= aControl.Anchors + [akRight];
 end;

 aParent.InsertControl(aControl);
 if aParent.GetInterface(ISizeableControl, l_IC) then
  l_Ic.SizeChanged;
 if aControl.GetInterface(ISizeableControl, l_IC) then
  l_IC.OnSizeChanged:= aMyControlResized;
 aControls.Add(aControl);
end;

procedure InnerControlResized(aParent: TWinControl; aControl: TControl; aControlsList: TList);
var
 i,
 l_Delta,
 l_Index: Integer;
 l_IC: ISizeableControl;
begin
 l_Delta:= cIndent;
 l_Index:= aControlsList.IndexOf(aControl);
 if l_Index <> -1 then
 begin
  if l_Index = Pred(aControlsList.Count) then
   l_Delta:= cIndent + aControl.Top + aControl.Height - aParent.Height
  else
   l_Delta:= cIndent + aControl.Top + aControl.Height - TControl(aControlsList[Succ(l_Index)]).Top;

  for i:= Succ(l_Index) to Pred(aControlsList.Count) do
  begin
   TControl(aControlsList[i]).Top:= TControl(aControlsList[i]).Top + l_Delta
   (*
   if Controls[i] is TSizeablePanel then
    TSizeablePanel(Controls[i]).ResizeControls;
   *)
  end;
  aParent.Height:= aParent.Height + l_Delta;
  if aParent.GetInterface(ISizeableControl, l_IC) then
   l_Ic.SizeChanged;
 end;
end;

{
******************************** TSizeableMemo *********************************
}
constructor TSizeableMemo.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  OnChange:= TextChanged;
  LineHeight:= 13;
  Height:= 2*LineHeight+2;
end;

function TSizeableMemo.pm_GetLineHeight: Integer;
var
 l_P: TWinControl;
begin
 if Parent <> nil then
 begin
  l_P:= Parent;
  While not (l_P is TForm) do l_P:= l_P.Parent;
  Result:= TForm(l_P).Canvas.TextHeight('Aq');
 end
 else
  Result := f_LineHeight;
end;

function TSizeableMemo.pm_GetOnSizeChanged: TNotifyEvent;
begin
  Result := f_OnSizeChanged;
end;

function TSizeableMemo.pm_GetValue: Variant;
begin
  Result:= Text;
end;

procedure TSizeableMemo.pm_SetOnSizeChanged(aValue: TNotifyEvent);
begin
  f_OnSizeChanged := aValue;
end;

procedure TSizeableMemo.pm_SetValue(const Value: Variant);
begin
  Text:= Value;
end;

procedure TSizeableMemo.SizeChanged;
begin
 if Assigned(f_OnSizeChanged) then
  f_OnSizeChanged(Self);
end;

procedure TSizeableMemo.TextChanged(Sender: TObject);
begin
  if Parent <> nil then
   ClientHeight:= (Lines.Count+1)*LineHeight+2;
  if Assigned(f_OnSizeChanged) then
   f_OnSizeChanged(Self);
end;

{
******************************** TSizeablePanel ********************************
}
constructor TSizeablePanel.Create(aOwner: TComponent);
begin
  inherited ;
  BevelOuter:= bvNone;
  Caption:= '';
  Height:= 12;
  f_InnerControls := TList.Create();
  f_Locked:= 0;
end;

destructor TSizeablePanel.Destroy;
begin
  FreeAndNil(f_InnerControls);
  inherited Destroy;
end;

procedure TSizeablePanel.AddControl(aControl: TControl; aSize: TControlSize;
    aPosition: TControlPosition);
begin
 AddInnerControl(Self, f_InnerControls, MyControlResized, aControl, aSize, aPosition);
end;

procedure TSizeablePanel.Lock;
begin
 Inc(f_Locked);
end;

function TSizeablePanel.Locked: Boolean;
begin
 Result:= f_Locked > 0;
end;

procedure TSizeablePanel.MyControlResized(Sender: TObject);
begin
 InnerControlResized(Self, Sender as TControl, f_InnerControls);
end;

function TSizeablePanel.pm_GetOnSizeChanged: TNotifyEvent;
begin
  Result := f_OnSizeChanged;
end;

procedure TSizeablePanel.pm_SetOnSizeChanged(aValue: TNotifyEvent);
begin
  f_OnSizeChanged := aValue;
end;

procedure TSizeablePanel.ResizeControls;
var
  i: Integer;
begin
  // Расширяем своих детей до собственного размера
  if Parent <> nil then
  begin
   for i:= 0 to Pred(ControlCount) do
    if not (Controls[i] is TButton) then
     Controls[i].Width:= ClientWidth - 16;
  end;
end;

procedure TSizeablePanel.SizeChanged;
begin
 if Assigned(f_OnSizeChanged) then
  f_OnSizeChanged(Self);
end;

procedure TSizeablePanel.Unlock;
begin
 Dec(f_Locked);
end;

{ TSizeableScrollBox }

{
****************************** TSizeableScrollBox ******************************
}
constructor TSizeableScrollBox.Create(aOwner: TComponent);
begin
  inherited;
  f_Locked:= 0;
  Constraints.MinHeight:= 24;
  Constraints.MinWidth:= 100;
  OnResize:= SelfResize;
 f_InnerControls := TList.Create();
end;

destructor TSizeableScrollBox.Destroy;
begin
 FreeAndNil(f_InnerControls);
 inherited Destroy;
end;

procedure TSizeableScrollBox.AddControl(aControl: TControl; aSize: TControlSize;
    aPosition: TControlPosition);
begin
 AddInnerControl(Self, f_InnerControls, MyControlResized, aControl, aSize, aPosition);
 f_EnableResize:= True;
end;

procedure TSizeableScrollBox.Lock;
begin
 Inc(f_Locked);
end;

function TSizeableScrollBox.Locked: Boolean;
begin
 Result:= f_Locked > 0;
end;

procedure TSizeableScrollBox.MyControlResized(Sender: TObject);
begin
  InnerControlResized(Self, Sender as TControl, f_InnerControls);
end;

function TSizeableScrollBox.pm_GetOnSizeChanged: TNotifyEvent;
begin
  Result:= f_OnSizeChanged;
end;

function TSizeableScrollBox.pm_GetValue: Variant;
begin
  Result:= Text;
end;

procedure TSizeableScrollBox.pm_SetOnSizeChanged(aValue: TNotifyEvent);
begin
  f_OnSizeChanged:= aValue;
end;

procedure TSizeableScrollBox.pm_SetValue(const Value: Variant);
begin
  Text:= Value;
end;

procedure TSizeableScrollBox.SelfResize(Sender: TObject);
var
  i: Integer;
begin
  for i:= 0 to f_InnerControls.Count-1 do
  begin
   TControl(f_InnerControls[i]).Width:= ClientWidth;
   (*
   if TControl(f_InnerControls[i]) is TSizeablePanel then
    (TControl(f_InnerControls[i]) as TSizeablePanel).ResizeControls;
   *)
  end;
  if Assigned(f_OnSizeChanged) then
   f_OnSizeChanged(Self);
end;

procedure TSizeableScrollBox.SizeChanged;
begin
 if Assigned(f_OnSizeChanged) then
  f_OnSizeChanged(Self);
end;

procedure TSizeableScrollBox.Unlock;
begin
 Dec(f_Locked);
end;



end.
