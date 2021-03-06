unit ddVirtualTable;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ���������� "dd"
// ������: "w:/common/components/rtl/Garant/dd/ddVirtualTable.pas"
// ������ Delphi ���������� (.pas)
// Generated from UML model, root element: <<SimpleClass::Class>> Shared Delphi::dd::Convertors::TddVirtualTable
//
//
// ��� ����� ����������� ��� ��� "������-������".
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ! ��������� ������������ � ������. ������� ������ - ������. !

{$Include w:\common\components\rtl\Garant\dd\ddDefine.inc}

interface

uses
  ddTableConvTypes,
  ddTable
  ;

type
 TddVirtualTable = class(TddTable)
 private
 // private fields
   f_CellAdjust : TddAutoFitBehavior;
    {* ���� ��� �������� CellAdjust}
   f_MaxWidth : Integer;
    {* ���� ��� �������� MaxWidth}
 protected
 // property methods
   function pm_GetTotalCellCount: Integer;
 public
 // overridden public methods
   constructor Create(anOwner: TObject = nil); override;
 public
 // public methods
   procedure Restructure(NewCellCount: Integer);
 public
 // public properties
   property CellAdjust: TddAutoFitBehavior
     read f_CellAdjust
     write f_CellAdjust;
   property MaxWidth: Integer
     read f_MaxWidth
     write f_MaxWidth;
   property TotalCellCount: Integer
     read pm_GetTotalCellCount;
 end;//TddVirtualTable

implementation

uses
  l3UnitsTools,
  l3MinMax,
  l3Base,
  ddTableRow,
  ddTextParagraph
  ;

// start class TddVirtualTable

procedure TddVirtualTable.Restructure(NewCellCount: Integer);
//#UC START# *4FACE2C8026A_4F683CE400D6_var*
var
 l_NewTable: TddTable;
 l_Row, l_NewRow: TddTableRow;
 i, j, l_RowCount, l_Add, l_CellCount, l_CellIndex: Integer;
 l_R, l_C, l_p, l_RowWidth: Integer;
//#UC END# *4FACE2C8026A_4F683CE400D6_var*
begin
//#UC START# *4FACE2C8026A_4F683CE400D6_impl*
 l_NewTable:= TddTable.Create(nil);
 try
  l_CellCount:= RowList.Count*LastRow.CellCount;
  if (l_CellCount > 0) and (NewCellCount > 0) then
  begin
   if l_CellCount mod NewCellCount > 0 then
    l_Add:= 1
   else
    l_Add:= 0;
   l_RowCount:= l_CellCount div NewCellCount + l_Add;
   l_CellIndex:= 0;                                                        
   for i:= 1 to l_RowCount do
   begin
    l_NewRow:= TddTableRow.Create(nil);
    try
     for j:= 1 to NewCellCount do
     begin
      l_NewRow.AddCellAndPara(True);
      l_NewRow.LastCell.Props := l_NewRow.LastCell.Props;
      if l_CellIndex < l_CellCount then
      begin
       l_R:= l_CellIndex div LastRow.CellCount;
       l_C:= l_CellIndex mod LastRow.CellCount;
       l_NewRow.LastCell.Assign(Cells[l_r, l_c]);
       { DONE -oNarry -c������ : ����������� �������������� ������ ����� }
       if CellAdjust = afEqual then
        l_NewRow.LastCell.Props.Width:= evInch2Char((MaxWidth div NewCellCount))
       else
        for l_p:= 0 to l_NewRow.LastCell.Hi do
         l_NewRow.LastCell.Props.Width:= Max(l_NewRow.LastCell.Props.Width,
                         TddTextParagraph(l_NewRow.LastCell.Items[l_p]).Text.Len);
      end; // l_CellIndex <= l_CellCount
      Inc(l_CellIndex);
     end;
     l_NewTable.AddRow(l_NewRow);
    finally
     l3Free(l_NewRow);
    end;
   end;
   // ��������� ����� �����
   if CellAdjust = afContent then
   begin
    for l_C:= 0 to Pred(l_NewTable.LastRow.CellCount) do
    begin
     l_Add:= 0;
     for l_R:= 0 to Pred(l_NewTable.RowCount) do
      l_Add:= Max(l_Add, l_NewTable.Rows[l_R].Cells[l_C].Props.Width);
     Inc(l_RowWidth, l_Add);
     for l_R:= 0 to Pred(l_NewTable.RowCount) do
      l_NewTable.Rows[l_R].Cells[l_C].Props.Width:= l_Add;
    end; // for l_C

    for l_R:= 0 to Pred(l_NewTable.RowCount) do
    begin
     l_Row:= l_NewTable.Rows[l_R];
     for l_C:= 0 to Pred(l_Row.CellCount) do
      l_Row.Cells[l_C].Props.Width:= Max(2,
         evInch2Char(MaxWidth)*l_Row.Cells[l_C].Props.Width div l_RowWidth);
    end; // for l_R
   end; // CellAdjust = afContent
   Clear;
   for i:= 0 to Pred(l_NewTable.RowCount) do
    AddRow(l_NewTable.Rows[i]);
  end; // (l_CellCount > 0) and (NewCellCount > 0)
 finally
  l3Free(l_NewTable);
 end; // l_NewTable
//#UC END# *4FACE2C8026A_4F683CE400D6_impl*
end;//TddVirtualTable.Restructure

function TddVirtualTable.pm_GetTotalCellCount: Integer;
//#UC START# *4FACE27702C7_4F683CE400D6get_var*
//#UC END# *4FACE27702C7_4F683CE400D6get_var*
begin
//#UC START# *4FACE27702C7_4F683CE400D6get_impl*
 if LastRow <> nil then
  Result:= RowList.Count*LastRow.CellCount
 else
  Result:= 0;
//#UC END# *4FACE27702C7_4F683CE400D6get_impl*
end;//TddVirtualTable.pm_GetTotalCellCount

constructor TddVirtualTable.Create(anOwner: TObject = nil);
//#UC START# *4DD3EB5A01C3_4F683CE400D6_var*
//#UC END# *4DD3EB5A01C3_4F683CE400D6_var*
begin
//#UC START# *4DD3EB5A01C3_4F683CE400D6_impl*
 inherited;
 CellAdjust:= afContent;
//#UC END# *4DD3EB5A01C3_4F683CE400D6_impl*
end;//TddVirtualTable.Create

end.