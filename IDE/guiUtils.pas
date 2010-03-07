unit guiUtils;

interface
Uses
 Controls,
 ExtCtrls;

type
 TEditPanel = class(TPanel)

 end;

type
 TControlItem = class
   Caption: TCaption;
   Control: TControlClass;
   Next   : TControlItem;
 end;


function NewItem(aCaption: TCaption; aClass: TControlClass; aNext: TControlItem): TControlItem;

function NewPanel(aParent: TWinControl; aItems: TControlItem): TPanel;

implementation
Uses
 Math, SysUtils,
 Classes,
 StdCtrls;


function NewItem(aCaption: TCaption; aClass: TControlClass; aNext: TControlItem): TControlItem;
begin
 Result:= TControlItem.Create;
 Result.Caption:= aCaption;
 Result.Control:= aClass;
 Result.Next:= aNext;
end;

function NewPanel(aParent: TWinControl; aItems: TControlItem): TPanel;
var
 l_Item: TControlItem;
 l_Count: Integer;
 l_C: TControl;
 l_Len: Integer;
 function lp_MakeControl(aClass: TControlClass; theOwner: TComponent; theLeft: Integer): TControl;
 begin
   Result:= aClass.Create(theOwner);
   Result.Name:= Result.ClassName + IntToStr(l_Count);
 end;
begin
 Result:= TPanel.Create(aParent);
 Result.Caption:= '';
 l_Item:= aItems;
 l_Len:= 0;
 while l_Item <> nil do
 begin
   l_Len:= Max(l_Len, Length(l_Item.Caption));
   l_Item:= l_Item.Next;
 end;
 Result.Width:= 16+l_Len*10 + 100;
 l_Count:= 0;
 l_Item:= aItems;
 while l_Item <> nil do
 begin
   Inc(l_Count);
   Result.Height:= l_Count*24+16;
   // Label
   l_C:= TLabel.Create(aParent);
   l_C.Name:= l_C.ClassName + IntToStr(l_Count);
   l_C.Left:= 8;
   TLabel(l_C).Caption:= l_Item.Caption;
   l_C.Top:= 8+(l_Count-1)*24;
   Result.InsertControl(l_C);
   // Control
   l_C:= l_Item.Control.Create(Result);
   l_C.Name:= l_C.ClassName+IntToStr(l_Count);
   l_C.Top:= 8+(l_Count-1)*24;
   l_C.Left:= 8+l_Len*10;
   l_C.Width:= 100;
   Result.InsertControl(l_C);
   l_Item:= l_Item.Next;
 end;
end;

end.
