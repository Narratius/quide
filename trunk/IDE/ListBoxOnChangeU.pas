unit ListBoxOnChangeU;
{
*****************************************************************************
*                                                                           *
*              TListBox Extention with Drag/Drop and On Change              *
*                                                                           *
*                            By Jens Borrisholt                             *
*                           Jens@Borrisholt.com                             *
*                                                                           *
* This file may be distributed and/or modified under the terms of the GNU   *
* General Public License (GPL) version 2 as published by the Free Software  *
* Foundation.                                                               *
*                                                                           *
* This file has no warranty and is used at the users own peril              *
*                                                                           *
* Please report any bugs to Jens@Borrisholt.com or contact me if you want   *
* to contribute to this unit.  It will be deemed a breach of copyright if   *
* you publish any source code  (modified or not) herein under your own name *
* without the authors consent!!!!!                                          *
*                                                                           *
* CONTRIBUTIONS:-                                                           *
*      Jens Borrisholt (Jens@Borrisholt.com) [ORIGINAL AUTHOR]              *
*                                                                           *
* Published:  http://delphi.about.com/.......                               *
*****************************************************************************
}

interface
uses
  Windows, Messages, Classes, Controls, StdCtrls;

{$M+}
type
  TItemIndexChangeEvent = procedure (Sender: TObject; OldIndex, NewIndex: Integer) of object;
  TListBox = class(StdCtrls.TListBox)
  private
    FOnChange: TNotifyEvent;
    FDragDropListBox: TListBox;
    FAllowInternalDrag: Boolean;
    FLButtonDown: Boolean;
    f_OnIndexChange: TItemIndexChangeEvent;
    procedure DoChangeIndex(OldIndex, NewIndex: Integer);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetDragDropListBox(const Value: TListBox);
    procedure SetAllowInternalDrag(const Value: Boolean);
    procedure SetOnIndexChange(const Value: TItemIndexChangeEvent);
    function GetActiveString: string;
    procedure SetActiveString(Value: String);
    function GetActiveObject: TObject;
  published
    property ActiveString: string read GetActiveString write SetActiveString;
    property ActiveObject: TObject read GetActiveObject;
    property AllowInternalDrag: Boolean read FAllowInternalDrag write SetAllowInternalDrag;
    property DragDropListBox: TListBox read FDragDropListBox write SetDragDropListBox;
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    property OnItemIndexChange: TItemIndexChangeEvent read f_OnIndexChange write SetOnIndexChange;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DragDrop(Source: TObject; X, Y: Integer); override;
    function ItemAtPos(PosX, PosY: Integer; Existing: Boolean): Integer;
  protected
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure DoChange;
    procedure SetItemIndex(const Value: Integer); override;

    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMOuseMove(var Message: TWMMouse); message WM_MOUSEMOVE;
  end;

implementation

{ TListBox }

constructor TListBox.Create(AOwner: TComponent);
begin
  inherited;
  FAllowInternalDrag := True;
  FLButtonDown := False;
end;


procedure TListBox.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TListBox.DoChangeIndex(OldIndex, NewIndex: Integer);
begin
 if Assigned(f_OnIndexChange) then
  f_OnIndexChange(Self, OldIndex, NewIndex);
end;

procedure TListBox.DragDrop(Source: TObject; X, Y: Integer);
var
  DropPosition: Integer;
  SourceListBox: TListBox;
  SourceStrValue: string;
  SourceObjValue: TObject;
begin
  DropPosition := ItemAtPos(x, y, True);
  SourceListBox := TListBox(Source);

  SourceStrValue := SourceListBox.ActiveString;
  SourceObjValue := SourceListBox.ActiveObject;

  SourceListBox.Items.Delete(SourceListBox.ItemIndex);

  if DropPosition < 0 then
    DropPosition := Items.Count;

  Items.InsertObject(DropPosition, SourceStrValue, SourceObjValue);

  inherited;
  DoChange;
end;

procedure TListBox.DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;

  if FDragDropListBox = nil then
    Exit;

  Accept := (Integer(Source) = Integer(Self)) and (FAllowInternalDrag);

  if not Accept then
    Accept := (Integer(Source) = Integer(FDragDropListBox));
end;

function TListBox.GetActiveObject: TObject;
begin
  Result := nil;

  if ItemIndex < 0 then
    exit;

  Result := Items.Objects[ItemIndex];
end;

function TListBox.GetActiveString: string;
begin
  Result := '';

  if ItemIndex < 0 then
    Exit;

  Result := Items[ItemIndex];
end;

function TListBox.ItemAtPos(PosX, PosY: Integer; Existing: Boolean): Integer;
begin
  Result := inherited ItemAtPos(Point(PosX, PosY), Existing);
end;

procedure TListBox.SetActiveString(Value: String);
begin
  if ItemIndex < 0 then
    exit;

  Items.Strings[ItemIndex]:= Value;

end;

procedure TListBox.SetAllowInternalDrag(const Value: Boolean);
begin
  FAllowInternalDrag := Value;
end;

procedure TListBox.SetDragDropListBox(const Value: TListBox);
begin
  FDragDropListBox := Value;
  if Value <> nil then
  begin
    DragMode := dmAutomatic;
    Value.FDragDropListBox := Self;
    Value.DragMode := dmAutomatic;
  end
  else
  begin
    DragMode := dmManual;
    Value.FDragDropListBox := nil;
    Value.DragMode := dmManual;
  end;
end;

procedure TListBox.SetItemIndex(const Value: Integer);
begin
 if (ItemIndex <> Value) then
  DoChangeIndex(ItemIndex, Value);

  inherited;
  DoChange;
end;

procedure TListBox.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TListBox.SetOnIndexChange(const Value: TItemIndexChangeEvent);
begin
 f_OnIndexChange:= Value;
end;

procedure TListBox.WMKeyDown(var Message: TWMKeyDown);
var
  OldIndex: Integer;
begin
  OldIndex := ItemIndex;
  inherited;
  if OldIndex <> ItemIndex then
  begin
   DoChangeIndex(OldIndex, ItemIndex);
   DoChange;
  end;
end;

procedure TListBox.WMLButtonDown(var Message: TWMLButtonDown);
var
  OldIndex: Integer;
begin
  FLButtonDown := True;
  OldIndex := ItemIndex;
  inherited;
  if OldIndex <> ItemIndex then
  begin
   DoChangeIndex(OldIndex, ItemIndex);
   DoChange;
  end;
end;

procedure TListBox.WMLButtonUp(var Message: TWMLButtonUp);
begin
  FLButtonDown := False;
  inherited;
end;

procedure TListBox.WMMOuseMove(var Message: TWMMouse);
begin
  if not FLButtonDown then
    exit;

  inherited;
  DoChange;
end;

end.

