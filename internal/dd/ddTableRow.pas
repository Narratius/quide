unit ddTableRow;

interface

uses
  Classes, ddBase, ddDocumentAtom, ddTableCell, k2Prim,
      l3ProtoPersistentRefList, l3ObjectRefList;

type
  TddTableRow = class(TddDocumentAtom)
  private
    f_CellList: Tl3ProtoPersistentRefList;
    f_TableDef: Tl3ObjectRefList;
    f_RTFLikeWidth: Boolean;
    f_TAP: TddRowProperty;
    function pm_GetCellSpan(Index: Integer): Integer;
    function pm_GetCellWidth(Index: Integer): Integer;
    function pm_GetCellPropBySpan(Index: Integer): TddCellProperty;
    function pm_GetCellCountBySpan: Integer;
    function pm_GetCellWidthBySpan(Index: Integer): Integer;
    procedure pm_SetCellSpan(Index: Integer; const Value: Integer);
    procedure pm_SetCellWidth(Index: Integer; const Value: Integer);
  protected
    function GetCellByPos(Pos: Longint): TddTableCell;
    function GetCellCount: Integer;
    function GetCellPropByPos(Pos: Longint): TddCellProperty;
    function GetCells(Index: Integer): TddTableCell;
    function GetLastCell: TddTableCell;
    function GetLastCellProperty: TddCellProperty;
    procedure Cleanup; override;
    procedure DoClose; override;
    procedure SetTAP(aTAP: TddRowProperty);
  public
    constructor Create(aOwner: TObject); override;
    procedure AddCell(aCell: TddTableCell);
    procedure AddCellAndPara(const OnlyCell: Boolean = False);
    procedure AddEmptyCell;
    procedure AddCellDef(aCellProps: TddCellProperty);
    procedure ApplyTableDef;
    procedure Assign(P: TPersistent); override;
    function CellIndexBySpan(Index: Integer): Integer;
    procedure Clear; override;
    procedure ClearTableDef;
    procedure DeleteCell(Index: Integer);
    procedure Write2Generator(const Generator: Ik2TagGenerator; const LiteVersion:
            Boolean = False); override;
    property CellByPos[Pos: Longint]: TddTableCell read GetCellByPos;
    property CellCount: Integer read GetCellCount;
    property CellPropByPos[Pos: Longint]: TddCellProperty read GetCellPropByPos;
    property Cells[Index: Integer]: TddTableCell read GetCells; default;
    property CellSpan[Index: Integer]: Integer read pm_GetCellSpan write
        pm_SetCellSpan;
    property CellWidth[Index: Integer]: Integer read pm_GetCellWidth write
        pm_SetCellWidth;
    property CellPropBySpan[Index: Integer]: TddCellProperty read
        pm_GetCellPropBySpan;
    property CellCountBySpan: Integer read pm_GetCellCountBySpan;
    property CellWidthBySpan[Index: Integer]: Integer read pm_GetCellWidthBySpan;
    property LastCell: TddTableCell read GetLastCell;
    property LastCellProperty: TddCellProperty read GetLastCellProperty;
    property RTFLikeWidth: Boolean read f_RTFLikeWidth write f_RTFLikeWidth;
    property TAP: TddRowProperty read f_TAP write SetTAP;
  end;

implementation

uses
  ddTextParagraph, SysUtils, Math, l3Math, l3Types, TableRow_Const,
  TableCell_Const, k2Tags, evdTypes, ddTable, evConst, RTFTypes, evdFrame_Const;

{
********************************* TddTableRow **********************************
}
constructor TddTableRow.Create(aOwner: TObject);
begin
 inherited Create(aOwner);
 AtomType:= dd_docTableRow;
 f_CellList:= Tl3ProtoPersistentRefList.Make;
 f_TAP:= TddRowProperty.Create(nil);
 f_RTFLikeWidth := False;
 f_TableDef := Tl3ObjectRefList.Create();
end;

procedure TddTableRow.AddCell(aCell: TddTableCell);
begin
 aCell.Index:= f_CellList.Add(aCell);
end;

procedure TddTableRow.AddCellAndPara(const OnlyCell: Boolean = False);
var
 l_Cell     : TddTableCell;
 l_Property : TddTextParagraph;
begin
 //TAP.AddCell;
 l_Cell := TddTableCell.Create(Self);
 try
  // Нужно ли добавить абзац
  if not OnlyCell then
  begin
   l_Property := TddTextParagraph.Create(nil);
   try
    l_Property.PAP.InTable := True;
    l_Cell.Add(l_Property);
   finally
    FreeAndNil(l_Property);
   end;
  end; // not OnlyCell
  
  AddCell(l_Cell);
 finally
  FreeAndNil(l_Cell);
 end;
end;

procedure TddTableRow.AddEmptyCell;
var
 l_Cell: TddTableCell;
begin
 l_Cell := TddTableCell.Create(Self);
 try
  AddCell(l_Cell);
 finally
  FreeAndNil(l_Cell);
 end;
end;

procedure TddTableRow.AddCellDef(aCellProps: TddCellProperty);
var
 l_Cell: TddCellProperty;
begin
 l_Cell:= TddCellProperty.Create(nil);
 try
  l_Cell.Assign(aCellProps);
  f_TableDef.Add(l_Cell);
 finally
  FreeAndNil(l_Cell);
 end;
end;

procedure TddTableRow.ApplyTableDef;
var
 i      : Integer;
 l_Cell : TddTableCell;
begin
 for i := 0 to f_TableDef.Hi do
 begin
  l_Cell := Cells[i];
  if l_Cell = nil then Break; 
  l_Cell.Props := TddCellProperty(f_TableDef[i]);
 end;
 ClearTableDef;
end;

procedure TddTableRow.Assign(P: TPersistent);
var
 i: Integer;
 l_Cell: TddtableCell;
begin
 if (P Is TddTableRow) then
 begin
  f_TAP.Assign(TddTableRow(P).TAP);
  for i:= 0 to TddTableRow(P).f_CellList.Hi do
  begin
   l_Cell:= TddTableCell.Create(nil);
   try
    l_Cell.Assign(TddTableRow(P)[i]);
    l_Cell.Clear;
    f_CellList.Add(l_Cell);
   finally
    FreeAndNil(l_Cell)
   end;
  end;
 end
 else
  inherited Assign(P);
end;

procedure TddTableRow.Clear;
var
 i: Integer;
begin
 inherited;
 f_TAP.Clear;
 ClearTableDef;
 i:= f_CellList.Hi;
 while i <> -1 do
 begin
  if not Cells[i].Closed then
   f_CellList.DeleteLast;
  Dec(i);
 end;
//f_CellList.Clear;
end;

procedure TddTableRow.DeleteCell(Index: Integer);
var
  l_CP: TddCellProperty;
begin
  l_CP:= Cells[Index].Props;
  if (l_CP <> nil) and (CellCount > 1) then
  begin
   if Index > 0 then
   begin
    Cells[Index].Props.Border.Frames[bpLeft].Assign(Cells[Index-1].Props.Border.Frames[bpLeft]);
    Cells[Index-1].Props.Assign(Cells[Index].Props);
   end
   else
   begin
    Cells[Index + 1].Props.Border.Frames[bpLeft].Assign(Cells[Index].Props.Border.Frames[bpLeft]);
   end;
   f_CellList.Delete(Index);
  end;
end;

function TddTableRow.GetCellByPos(Pos: Longint): TddTableCell;
var
  i: Integer;
  Delta: LongInt;
begin
  Result:= nil;
  for i := 0 to f_CellList.Hi do
  begin
   if i > 0 then
    Delta := Cells[Pred(i)].Props.Width
   else
    Delta := 0;
   if InRange(Pos, Delta, Cells[i].Props.Width) then
   begin
    Result := Cells[i];
    Break;
   end; // InRange
  end; // for i
end;

function TddTableRow.GetCellCount: Integer;
begin
  if (Self <> nil) AND (f_CellList <> nil) then
   Result:= f_CellList.Count
  else
   Result:= 0;
end;

function TddTableRow.GetCellPropByPos(Pos: Longint): TddCellProperty;
var
  i: Integer;
  W, Delta: LongInt;
begin
  W:= 0;
  Result:= nil;
  for i:= 0 to f_CellList.Hi do
  begin
    if (i > 0) and RTFLikeWidth then
      Delta:= Cells[i].Props.Width-Cells[Pred(i)].Props.Width
    else
      Delta:= Cells[i].Props.Width;
    if (Pos > W) and (Pos <= (W+ l3MulDiv(Delta, 105, 100))) then
    begin
      Result:= Cells[i].Props;
      Result.Index:= i;
      Break;
    end
    else
      Inc(W, Delta);
  end;
end;

function TddTableRow.GetCells(Index: Integer): TddTableCell;
begin
  try
   if (Index >= 0) and (Index < f_CellList.Count) then
    Result:= TddTableCell(f_CellList.Items[Index])
   else
    Result:= nil;
  except
   Result:= nil;
  end;
end;

function TddTableRow.GetLastCell: TddTableCell;
begin
 if f_CellList.Count = 0 then
  Result:= nil //AddCellAndPara;
 else
  Result := TddTableCell(f_CellList.Last);
end;

function TddTableRow.GetLastCellProperty: TddCellProperty;
begin
 if LastCell = nil then
  AddCellAndPara;
 Result:= LastCell.Props;
end;

procedure TddTableRow.Cleanup;
begin
 FreeAndNil(f_TableDef);
 FreeAndNil(f_CellList);
 FreeAndNil(f_TAP);
 inherited;
end;

function TddTableRow.pm_GetCellSpan(Index: Integer): Integer;
begin
 Result := Cells[Index].Props.CellSpan;
end;

function TddTableRow.pm_GetCellWidth(Index: Integer): Integer;
begin
 Result := Cells[Index].Props.Width;
end;

function TddTableRow.pm_GetCellPropBySpan(Index: Integer): TddCellProperty;
begin
 Result:= Cells[CellIndexBySpan(Index)].Props;
end;

function TddTableRow.CellIndexBySpan(Index: Integer): Integer;
var
 l_SpanIndex: Integer;
 l_CellIndex: Integer;
 i, j: Integer;
begin
 l_SpanIndex:= -1;
 l_CellIndex:= 0;
 Result:= -1;
 for l_CellIndex:= 0 to Pred(CellCount) do
 begin
  for j:= 1 to CellSpan[l_CellIndex] do
  begin
   Inc(l_SpanIndex);
   if l_SpanIndex = Index then
   begin
    Result := l_CellIndex;
    break;
   end;
  end;
 end; // while
 if Result = -1 then
 begin
 l_SpanIndex:= -1;
 l_CellIndex:= 0;
 Result:= -1;
 for l_CellIndex:= 0 to Pred(CellCount) do
 begin
  for j:= 1 to CellSpan[l_CellIndex] do
  begin
   Inc(l_SpanIndex);
   if l_SpanIndex = Index then
   begin
    Result := l_CellIndex;
    break;
   end;
  end;
 end; // while
 end;
end;

procedure TddTableRow.ClearTableDef;
begin
 f_TableDef.Clear;
end;

procedure TddTableRow.DoClose;
var
 i: Integer;
begin
 for i:= 0 to Pred(CellCount) do
  Cells[i].Closed:= True; 
end;

function TddTableRow.pm_GetCellCountBySpan: Integer;
var
 i: Integer;
begin
 Result:= 0;
 for i:= 0 to Pred(CellCount) do
  Inc(Result, CellSpan[i]);
end;

function TddTableRow.pm_GetCellWidthBySpan(Index: Integer): Integer;
var
 l_CellIndex: Integer;
begin
 Result:= 0;
 l_CellIndex:= CellIndexBySpan(Index);
 if l_CellIndex <> -1 then
  Result := CellWidth[l_CellIndex] div CellSpan[l_CellIndex];
end;

procedure TddTableRow.pm_SetCellSpan(Index: Integer; const Value: Integer);
begin
 Cells[Index].Props.CellSpan:= Value;
end;

procedure TddTableRow.pm_SetCellWidth(Index: Integer; const Value: Integer);
begin
 Cells[Index].Props.Width:= Value;
end;

procedure TddTableRow.SetTAP(aTAP: TddRowProperty);
begin
  f_TAP.Assign(aTAP);
end;

procedure TddTableRow.Write2Generator(const Generator: Ik2TagGenerator; const
        LiteVersion: Boolean = False);
var
 i, j: Integer;
 l_C: TddTableCell;
 Delta, W: Long;
begin
  Generator.StartChild(k2_idTableRow);
  try
   if not LiteVersion then
    TAP.Border.Write2Generator(Generator);
    for i:= 0 to f_CellList.Hi do
    begin
      l_C:= Cells[i];
       Generator.StartChild(k2_idTableCell);
       try
         if Cells[i].Props.VMergeFirst then
           Generator.AddIntegerAtom(k2_tiMergeStatus, Ord(ev_msHead))
         else
         if Cells[i].Props.VMerged then
           Generator.AddIntegerAtom(k2_tiMergeStatus, Ord(ev_msContinue));
         if not LiteVersion then
         begin
           if Cells[i].Props.PatternBackColor <> propUndefined then
             Generator.AddIntegerAtom(k2_tiBackColor, Cells[i].Props.PatternBackColor);

             //Generator.AddIntegerAtom(k2_tiLeftIndent, l3MulDiv(TAP.Gaph, evInchMul, rtfTwip));
         end;
         if (i > 0) then
          Delta:= CellWidth[Pred(i)]
         else
          Delta:= TAP.Left;

         W:= CellWidth[i]-Delta;

         Generator.AddIntegerAtom(k2_tiWidth, l3MulDiv(W, evInchMul, rtfTwip));

         if not LiteVersion then
         begin
           Generator.AddIntegerAtom(k2_tiLeftIndent, l3MulDiv(Cells[i].Props.LeftPad, evInchMul, rtfTwip));
           Generator.AddIntegerAtom(k2_tiRightIndent, l3MulDiv(Cells[i].Props.RightPad, evInchMul, rtfTwip));
           Generator.AddIntegerAtom(k2_tiSpaceBefore, l3MulDiv(Cells[i].Props.TopPad, evInchMul, rtfTwip));
           Generator.AddIntegerAtom(k2_tiSpaceAfter, l3MulDiv(Cells[i].Props.BottomPad, evInchMul, rtfTwip));
         end;
         if Cells[i].Props.Border.isFramed then
          Cells[i].Props.Border.Write2Generator(Generator)
         else
          Generator.AddIntegerAtom(k2_tiFrame, evd_fvEmpty);

         Generator.AddIntegerAtom(k2_tiVerticalAligment, Ord(Cells[i].Props.Just));
         if not Cells[i].Props.VMerged then
         begin
          if l_C.Count = 0 then
           l_C.AddParagraph;
          for j:= 0 to l_C.Hi do
          begin
           if (l_C.Items[j].AtomType = dd_docTable) then
            TddTable(l_C.Items[j]).AdjustWidth(W-Cells[i].Props.LeftPad-Cells[i].Props.RightPad);
           l_C.Items[j].Write2Generator(Generator, LiteVersion);
          end {for j}
         end;
       finally
         Generator.Finish;
       end;
    end; {for i}
  finally
    Generator.Finish;
  end;
end;

end.
