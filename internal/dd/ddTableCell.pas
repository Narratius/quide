unit ddTableCell;

interface                                                           

uses
  Classes, ddBase, ddDocumentAtom, ddTextParagraph, l3ProtoPersistentRefList;

type
  TddTableCell = class(TddDocumentAtom)
  private
   f_ParaList : Tl3ProtoPersistentRefList;
   f_Index: Integer;
   f_Props: TddCellProperty;
   function GetCount: Integer;
   function pm_GetHi: Integer;
   function pm_GetItems(Index: Integer): TddDocumentAtom;
   procedure pm_SetProps(const Value: TddCellProperty);
  protected
   function GetLastPara: TddTextParagraph;
   procedure Cleanup; override;
  public
   constructor Create(aOwner: TObject); override;
   procedure Add(aPara: TddDocumentAtom);
   function AddParagraph: TddTextParagraph;
   procedure Assign(P: TPersistent); override;
   procedure Clear; override;
   procedure Delete(Index: Integer);
   function PrevCell: TddTableCell;
   property Count: Integer read GetCount;
   property Hi: Integer read pm_GetHi;
   property Index: Integer read f_Index write f_Index;
   property Items[Index: Integer]: TddDocumentAtom read pm_GetItems;
   property LastPara: TddTextParagraph read GetLastPara;
   property Props: TddCellProperty read f_Props write pm_SetProps;
  end;

implementation

uses
  SysUtils, ddTableRow;

{
********************************* TddTableCell *********************************
}

constructor TddTableCell.Create(aOwner: TObject);
begin
 inherited;
 f_ParaList := Tl3ProtoPersistentRefList.Make;
 AtomType:= dd_docTableCell;
 f_Props := TddCellProperty.Create(nil);
end;

procedure TddTableCell.Add(aPara: TddDocumentAtom);
begin
 if aPara.AtomType = dd_docTextParagraph then
  TddTextparagraph(aPara).PAP.InTable := True;
 f_ParaList.Add(aPara);
end;

function TddTableCell.AddParagraph: TddTextParagraph;
var
 l_P: TddTextParagraph;
begin
 l_P:= TddTextParagraph.Create(nil);
 try
  l_P.PAP.InTable := True;
  Add(l_P);
  Result:= TddTextParagraph(f_ParaList.Last);
 finally
  FreeAndNil(l_P);
 end;
end;

procedure TddTableCell.Assign(P: TPersistent);
  {override;}
  {-}
begin
 if (P Is TddTableCell) then
 begin
  f_ParaList.Assign(TddTableCell(P).f_ParaList);
  f_Props.Assign(TddTableCell(P).Props);
 end
 else
  inherited Assign(P);
end;

procedure TddTableCell.Cleanup;
begin
 FreeAndNil(f_Props);
 FreeAndNil(f_ParaList);
 inherited;                                                                                 
end;

procedure TddTableCell.Delete(Index: Integer);
begin
 f_ParaList.Delete(index);
end;

function TddTableCell.GetCount: Integer;
begin
  Result := f_ParaList.Count;
end;

function TddTableCell.GetLastPara: TddTextParagraph;
var
 i: Integer;
begin
 Result := nil;
 i := Hi;
 while (Result = nil) and (i <> -1) do
 begin
  if TObject(Items[i]) is TddTextParagraph then
   Result:= TddTextParagraph(Items[i])
  else
   Dec(i);
 end;
 if Result = nil then
 begin
  AddParagraph;
  Result:= GetLastPara;
 end; 
end;

function TddTableCell.pm_GetHi: Integer;
begin
 Result := f_ParaList.Hi;
end;

function TddTableCell.pm_GetItems(Index: Integer): TddDocumentAtom;
begin
 Result := TddDocumentAtom(f_paraList.Items[Index]);
end;

procedure TddTableCell.Clear;
begin
 f_paraList.Clear;
 f_Props.Clear;
 Closed:= False;
end;

procedure TddTableCell.pm_SetProps(const Value: TddCellProperty);
begin
 Assert(Self <> nil);
 Assert(f_Props <> nil);
 f_Props.Assign(Value);
end;

function TddTableCell.PrevCell: TddTableCell;
begin
 if f_Index > 0 then
  Result := TddTableRow(Self.GetOwner).Cells[Index - 1]
 else
  Result := nil;
end;

end.
