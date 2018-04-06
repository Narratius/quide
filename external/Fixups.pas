unit Fixups;

interface

uses Classes;

type
  TCptRef = ^TComponent;

procedure SaveName(const Name: string; FieldRef: TCptRef);
procedure ResolveNames(RootObject: TComponent);
procedure ClearNames;

implementation

var
  FixupInfo: TStringList;

procedure SaveName(const Name: string; FieldRef: TCptRef);
begin
  FixupInfo.AddObject(Name, TObject(FieldRef));
end;

procedure ResolveNames(RootObject: TComponent);
var
  i, j: Integer;
  CurName: string;
  CurCpt: TComponent;
begin
  Assert(Assigned(RootObject), 'Корневой объект = nil');
  with RootObject do
   for i := 0 to Pred(ComponentCount) do
   begin
      CurCpt := Components[i];
      CurName := CurCpt.Name;
      for j := Pred(FixupInfo.Count) downto 0 do
        if FixupInfo[j] = CurName then
        begin
          TCptRef(FixupInfo.Objects[j])^ := CurCpt;
          FixupInfo.Delete(j);
        end;
    end;
  Assert(FixupInfo.Count = 0, 'Остаются неразрешённые имена');
  FixupInfo.Clear;
end;

procedure ClearNames;
begin
 FixupInfo.Clear
end;

initialization
  FixupInfo := TStringList.Create;
finalization
  FixupInfo.Free;
end.
