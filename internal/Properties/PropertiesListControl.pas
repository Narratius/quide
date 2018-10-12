unit PropertiesListControl;

interface

Uses
 Classes, StdCtrls,
 PropertyIntf, Propertys;

type
  TPropertiesListControl = class(TGroupBox, IPropertyControlValue)
  private
   f_ListBox: TListBox;
   f_Property: TddProperty;
  private
   procedure OnNew(Sender: TObject);
   procedure OnEdit(Sender: TObject);
   procedure OnDelete(Sender: TObject);
   procedure EditItem(aNew: Boolean);
   procedure DeleteItem;
   function pm_GetValue: Variant;
   procedure pm_SetValue(const Value: Variant);
    function pm_GetProp: TddProperty;
    procedure pm_SetProp(const Value: TddProperty);
  public
   constructor Create(AOwner: TComponent); override;
   property Value: Variant read pm_GetValue write pm_SetValue;
   property Prop: TddProperty read pm_GetProp write pm_SetProp;
  end;

implementation

Uses
 Controls, SysUtils, Variants,
 PropertyUtils;

{ TPropertiesListControl }

constructor TPropertiesListControl.Create(AOwner: TComponent);
var
 l_B: TButton;
 l_H: Integer;
begin
  inherited;
  // Нужно вставить TListBox, три TButton
  f_ListBox:= TListBox.Create(Self);
  f_ListBox.Parent:= Self;
  f_ListBox.Top:= 8 + 8{CaptionHeight}; // MagicNumber
  f_ListBox.Left:= 8;
  f_ListBox.Height:= Height - 16 - 8{CaptionHeight};
  f_ListBox.Width:= 150;
  f_ListBox.OnDblClick:= OnEdit;
  l_B:= TButton.Create(Self);
  l_B.Parent:= Self;
  l_B.Top:= 16;
  Width:= l_B.Width + 3*8 + 150;
  l_B.Left:= Width - l_B.Width - 8;
  l_B.Caption:= 'Новый';
  l_B.Anchors:= [akRight];
  l_B.OnClick:= OnNew;
  //f_ListBox.Width:= Width - 3*8 + l_B.Width;
  f_ListBox.Anchors:= [akLeft, akRight];
  l_H:= l_B.Top + l_B.Height + 4;
  l_B:= TButton.Create(Self);
  l_B.Parent:= Self;
  l_B.Top:= l_H;
  l_B.Left:= Width - l_B.Width - 8;
  l_B.Caption:= 'Правка';
  l_B.Anchors:= [akRight];
  l_B.OnClick:= OnEdit;
  l_H:= l_B.Top + l_B.Height + 4;
  l_B:= TButton.Create(Self);
  l_B.Parent:= Self;
  l_B.Top:= l_H;
  l_B.Left:= Width - l_B.Width - 8;
  l_B.Caption:= 'Удалить';
  l_B.Anchors:= [akRight];
  l_B.OnClick:= OnDelete;
end;

procedure TPropertiesListControl.DeleteItem;
begin
 // Удаление элемента
end;

procedure TPropertiesListControl.EditItem(aNew: Boolean);
var
 l_Item: TddProperties;
 l_Cap: String;
 l_Index: Integer;
begin
 if aNew then
 begin
  l_Item:= f_Property.ListItem.Clone;
  l_Cap:= 'Новый элемент';
 end
 else
 begin
  l_Item:= f_Property.ListItems[f_ListBox.ItemIndex];
  l_Cap:= 'Изменение элемента';
 end;
 if ShowPropDialog(l_Cap, l_Item) then
 begin

  if aNew then
  begin
   l_Index:= f_Property.AddItem(l_item);
   f_ListBox.Items.Add(VarToStr(l_Item.Items[0].Value))
  end
  else
  begin
   l_Index:= f_ListBox.ItemIndex;
   f_ListBox.Items.Strings[l_Index]:= VarToStr(l_Item.Items[0].Value)
  end;
 end
 else
 if aNew then
  FreeAndNil(l_Item);
end;

procedure TPropertiesListControl.OnDelete(Sender: TObject);
begin
  DeleteItem;
end;

procedure TPropertiesListControl.OnEdit(Sender: TObject);
begin
 EditItem(f_ListBox.ItemIndex = -1)
end;

procedure TPropertiesListControl.OnNew(Sender: TObject);
begin
 EditItem(True);
end;

function TPropertiesListControl.pm_GetProp: TddProperty;
begin
 Result:= f_Property;
end;

function TPropertiesListControl.pm_GetValue: Variant;
begin

end;

procedure TPropertiesListControl.pm_SetProp(const Value: TddProperty);
var
 i: Integer;
begin
 f_Property:= Value;
 for I := 0 to f_Property.ListItemsCount-1 do
  f_ListBox.Items.Add(VarToStr(f_Property.ListItems[i].Items[0].Value));

end;

procedure TPropertiesListControl.pm_SetValue(const Value: Variant);
begin
 // Получили сам TddProperty
end;

end.
