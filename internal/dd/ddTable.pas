unit ddTable;

interface

uses
  ddBase, ddDocumentAtom, ddTableCell, k2Prim, l3ProtoPersistentRefList,
  ddTableRow;

type
  TddTable = class(TddDocumentAtom)
  private
    FNested: Boolean;
    f_IsPercent: Boolean;
    f_IsSBS: Boolean;
    f_LeftIndent: Integer;
    f_RowList: Tl3ProtoPersistentRefList;
    f_Scale: Integer;
    f_Width: Integer;
    function pm_GetRowCount: Integer;
    function pm_GetRows(Index: Integer): TddTableRow;
  protected
    function GetCells(aRow, aCell: Integer): TddTableCell;
    function GetCellsProps(aRow, aCell: Integer): TddCellProperty;
    function GetLastRow: TddTableRow;
    procedure Cleanup; override;
    property RowList: Tl3ProtoPersistentRefList read f_RowList;
  public
    constructor Create(aOwner: TObject); override;
    procedure AddRow(aRow: TddTableRow);
    procedure AdjustWidth(NewWidth: Integer);
    procedure Clear; override;
    procedure Write2Generator(const Generator: Ik2TagGenerator; const LiteVersion:
            Boolean = False); override;
    property Cells[Row, Cell: Integer]: TddTableCell read GetCells;
    property CellsProps[Row, Cell: Integer]: TddCellProperty read GetCellsProps;
    property IsPercent: Boolean read f_IsPercent write f_IsPercent;
    property IsSBS: Boolean read f_IsSBS write f_IsSBS;
    property LastRow: TddTableRow read GetLastRow;
    property LeftIndent: Integer read f_LeftIndent write f_LeftIndent;
    property Nested: Boolean read FNested write FNested;
    property RowCount: Integer read pm_GetRowCount;
    property Rows[Index: Integer]: TddTableRow read pm_GetRows; default;
    property Scale: Integer read f_Scale write f_Scale;
    property Width: Integer read f_Width write f_Width;
  end;

implementation

uses
  l3Defaults, SysUtils, Table_Const, l3Math;

{
*********************************** TddTable ***********************************
}
constructor TddTable.Create(aOwner: TObject);
begin
  inherited;
  f_RowList:= Tl3ProtoPersistentRefList.Make;
  AtomType:= dd_docTable;
  f_IsSBS:= False;
  f_Scale:= def_Zoom;
  FNested:= False;
end;

procedure TddTable.AddRow(aRow: TddTableRow);
begin
  f_RowList.Add(aRow);
  aRow.TAP.Left:= LeftIndent;
end;

procedure TddTable.AdjustWidth(NewWidth: Integer);
var
 i, j : Integer;
 l_R: TddTableRow;
 l_OldWidth : Integer;
begin
 for i := 0 to RowList.Hi do
 begin
  l_R := TddTableRow(RowList.Items[i]);
  l_OldWidth := 0;
  for j := 0 to Pred(l_R.CellCount) do
  begin
   Inc(l_OldWidth, l_R.Cells[j].Props.Width);
   if j > 0 then
    Dec(l_OldWidth, l_R.Cells[Pred(j)].Props.Width);
  end; // for j
  if l_OldWidth > NewWidth then
   for j := 0 to Pred(l_R.CellCount) do
    l_R.Cells[j].Props.Width := l3MulDiv(l_R.Cells[j].Props.Width, NewWidth, l_OldWidth);
 end; // for i
end;

procedure TddTable.Clear;
begin
  inherited;
  f_RowList.Clear;
  f_LeftIndent:= 0;
end;

function TddTable.GetCells(aRow, aCell: Integer): TddTableCell;
begin
  if (aRow >= 0) and (aRow < RowList.Count) and
     (aCell >= 0) and (aCell < TddTableRow(RowList.Items[aRow]).CellCount) then
   Result:= TddTableRow(RowList.Items[aRow]).Cells[aCell]
  else
   Result:= nil;
end;

function TddTable.GetCellsProps(aRow, aCell: Integer): TddCellProperty;
begin
  if (aRow >= 0) and (aRow < RowList.Count) and
     (aCell >= 0) and (aCell < TddTableRow(RowList[aRow]).CellCount) then
   Result:= TddTableRow(RowList[aRow]).Cells[aCell].Props
  else
   Result:= nil;
end;

function TddTable.GetLastRow: TddTableRow;
begin
  try
    if f_RowList.Count > 0 then
   Result:= TddTableRow(f_RowList.Items[f_RowList.Hi])
  else
      Result:= nil;
  except
    Result:= nil;
 end;
end;

procedure TddTable.Cleanup;
begin
  FreeAndNil(f_RowList);
  inherited
end;

function TddTable.pm_GetRowCount: Integer;
begin
 Result := f_RowList.Count;
end;

function TddTable.pm_GetRows(Index: Integer): TddTableRow;
begin
 Result := TddTableRow(f_RowList.Items[index]);
end;

procedure TddTable.Write2Generator(const Generator: Ik2TagGenerator; const
        LiteVersion: Boolean = False);
var
  i: Integer;
begin
  Generator.StartChild(k2_idTable);
  try
   for i:=0 to f_RowList.Hi do
     TddTableRow(f_RowList.Items[i]).Write2Generator(Generator, LiteVersion);
  finally
    Generator.Finish;
  end;
end;

end.
