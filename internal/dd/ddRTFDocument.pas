unit ddRTFDocument;

// $Id: ddRTFDocument.pas,v 1.14 2013/04/11 16:46:28 lulin Exp $ 

// $Log: ddRTFDocument.pas,v $
// Revision 1.14  2013/04/11 16:46:28  lulin
// - отлаживаем под XE3.
//
// Revision 1.13  2004/09/21 12:21:05  lulin
// - Release заменил на Cleanup.
//
// Revision 1.12  2003/04/30 12:42:05  narry
// - add: константа rtfTwip
// - change: замена 1440 на rtfTwip
//
// Revision 1.11  2003/04/19 12:30:37  law
// - new file: ddDefine.inc.
//
// Revision 1.10  2002/12/24 13:01:59  law
// - change: объединил Int64_Seek c основной веткой.
//
// Revision 1.9.2.1  2002/12/24 11:56:42  law
// - new behavior: используем 64-битный Seek вместо 32-битного.
//
// Revision 1.9  2002/12/17 12:42:47  law
// - change: k2_idTableColumn переименовано в k2_idTableCell для большего соответстия смыслу тега.
//
// Revision 1.8  2000/12/15 15:29:55  law
// - вставлены директивы Log и Id.
//

{$I ddDefine.inc }

interface

Uses
  Classes,
  l3Base, l3Intf, l3Memory,
  k2TagGen,
  ddRTFProperties, ddPictDetector, RTFTypes;

type
  TddRTFDocAtomType = (dd_docTextParagraph, dd_docPicture, dd_docTableRow);


  TddRTFDocumentAtom = class(Tl3Base)
  private
    f_Type: TddRTFDocAtomType;
  public
    procedure Write2Generator(Generator: Tk2TagGenerator); virtual; abstract;

    property AtomType: TddRTFDocAtomType
      read f_Type write f_Type;
  end;

  TddTextSegment = class(Tl3NCString)
  private
    f_CHP: TddCharacterProperty;
  protected
    procedure SetCHP(aCHP: TddCharacterProperty);
    procedure Cleanup; override;
  public
    constructor Create(aOwner: TObject); override;
    procedure Assign(aSource: TPersistent);
        override;
        {-}
  public
    property CHP: TddCharacterProperty
      read f_CHP write SetCHP;
  end;

  
  TddBorderPart = class(Tl3Base)
    private
    {internal fields}
      FType: TddBorderType;
      FWidth: Byte;  {<= 75 (in twips) }
      FColor: Byte;  { index in RTFReader color table }
      FSpace: Integer;
      f_Enable: TRTFBool;
    public
    {public methods}
      procedure Clear;
        override;
        {-}
      procedure Assign(BP: TPersistent);
        override;
      property Enable: TRTFBool
        read f_Enable write f_Enable;
        {-}
  end;{TddBorderPart}

  TddBorderParts = (bpTop, bpLeft, bpBottom, bpRight, bpHorizontal, bpVertical, bpBox);

  TddBorder = class(Tl3Base)  { Border properties }
    private
    {property fields}
      FTOP,
      FBottom,
      FLeft,
      FRight,
      FHorizontal,
      FVertical: TddBorderPart;
    protected
    {property methods}
      function GetFrameColor(Index: TddBorderParts): Longint;
      function GetFrameWidth(Index: TddBorderParts): Longint;
      function GetFrameType(Index: TddBorderParts): TddBorderType;
      procedure SetFrameColor(Index: TddBorderParts; Value: Longint);
      procedure SetFrameWidth(Index: TddBorderParts; Value: Longint);
      procedure SetFrameType(Index: TddBorderParts; Value: TddBorderType);
      function GetFrames(Index: TddBorderParts): TddBorderPart;
      procedure SetFrames(Index: TddBorderParts; Value: TddBorderPart);
      function GetFrameSpace(Index: TddBorderParts): Integer;
      procedure SetFrameSpace(Index: TddBorderParts; Value: Integer);
      function GetIsFramed: Boolean;
      procedure SetIsFramed(Value: Boolean);
      procedure Cleanup; override;

    public
    {public methods}
      constructor Create(AReader: TObject);
        override;
        {-}
      procedure Clear;
        override;
        {-}
      procedure Assign(aBorder: TPersistent);
        override;
        {-}
    public
    {public properties}
      property Frames[Index: TddBorderParts]: TddBorderPart
        read GetFrames write SetFrames;
      property FrameColor[Index: TddBorderParts]: Longint
        read GetFrameColor write SetFrameColor;
      property FrameWidth[Index: TddBorderParts]: Longint
        read GetFrameWIdth write SetFrameWidth;
      property FrameType[Index: TddBorderParts]: TddBorderType
        read GetFrameType write SetFrameType;
      property FrameSpace[Index: TddBorderParts]: Integer
        read GetFrameSpace write SetFrameSpace;



      property isFramed: Boolean
        read GetIsFramed write SetIsFramed;
  end;{TddBorder}


  TddRTFTextParagraph = class(TddRTFDocumentAtom)
  private
    f_Segments: Tl3VList;  { список сегментов и текста }
    f_PAP: TddParagraphProperty;
  protected

    procedure Cleanup; override;
  public
    constructor Create(aOwner: TObject); override;

    procedure AddText(Text: Tl3String); overload;
    procedure AddText(Text: Char); overload;
    procedure AddSegment(aCHP: TddCharacterProperty);
    procedure ApplyCHP(aCHP: TddCharacterProperty);
    procedure PackSegments;
    procedure Write2Generator(Generator: Tk2TagGenerator); override;
  public
    property Segments: Tl3VList
      read f_Segments;
    property PAP: TddParagraphProperty
      read f_PAP write f_PAP;
  end;


  TddRTFPicture = class(TddRTFDocumentAtom)
  private
    f_Picture: Tl3String;
    f_Format: Integer;
  protected
    function GetFormat: Integer;
    procedure Cleanup; override;
  public
    constructor Create(aOwner: TObject); override;
    procedure Write2Generator(Generator: Tk2TagGenerator); override;
  public
    property Picture: Tl3String
      read f_Picture;
    property Format: Integer
      read GetFormat;
  end;

  TddRTFCell = class(Tl3VList)
  private
    f_Width: Longint;
  protected

  public

  end;

  TddRTFTableRow = class(TddRTFDocumentAtom)
  private
    f_CellList: Tl3VList;
    f_TAP: TddRowProperty;
  protected
    procedure SetTAP(aTAP: TddRowProperty);
    function GetCells(Index: Integer): TddRTFCell;
    procedure Cleanup; override;
  public
    constructor Create(aOwner: TObject); override;
    procedure Write2Generator(Generator: Tk2TagGenerator); override;
    procedure AddCell(aCell: TddRTFCell);
  public
    property Cells[Index: Integer]: TddRTFCell
      read GetCells;
    property TAP: TddRowProperty
      read f_TAP write SetTAP;
  end;

implementation


Uses
  l3Types, k2Tags, evSegLst, l3Math, evConst, evTypes;

constructor TddTextSegment.Create(aOwner: TObject);
begin
  inherited;
  f_CHP:= TddCharacterProperty.Create(nil);
end;

procedure TddTextSegment.Cleanup;
begin
  l3Free(f_CHP);
  inherited;
end;

procedure TddTextSegment.Assign(aSource: TPersistent);
var
 Value: TddTextSegment absolute aSource;
begin
 inherited Assign(aSource);
 if (aSource Is TddTextsegment) then
 begin
   f_CHP.Assign(Value.CHP)
 end;{aSource Is TddTextSegment}
end;

procedure TddTextsegment.SetCHP(aCHP: TddCharacterProperty);
begin
  f_CHP.Assign(aCHP);
end;

constructor TddRTFTextParagraph.Create(aOwner: TObject);
var
  l_S: TddTextSegment;
begin
  inherited;
  f_PAP:= TddParagraphProperty.Create(nil);
  f_Segments:= Tl3VList.MakePersistent;
  l_S:= TddTextSegment.Create(nil);
  try
    f_Segments.Add(TObject(l_S));
  finally
    l3Free(l_S);
  end;
end;

procedure TddRTFTextParagraph.Cleanup;
begin
  l3Free(f_PAP);
  l3Free(f_segments);
  inherited;
end;

procedure TddRTFTextParagraph.AddText(Text: Tl3String);
begin
  Tl3String(f_Segments.Items[f_Segments.Hi]).JoinWith(Text, nil);
end;

procedure TddRTFTextParagraph.AddText(Text: Char);
begin
  Tl3String(f_Segments.Items[f_Segments.Hi]).Append(Text);
end;

procedure TddRTFTextParagraph.ApplyCHP(aCHP: TddCharacterProperty);
begin
  TddTextSegment(f_Segments.Items[f_Segments.Hi]).CHP.JoinWith(aCHP, nil);
end;

procedure TddRTFTextParagraph.AddSegment;
var
  l_S: TddTextSegment;
begin
  l_S:= TddTextSegment.Create(nil);
  try
    l_S.CHP:= aCHP;
    f_Segments.Add(TObject(l_S));
  finally
    l3Free(l_S);
  end;
end;

procedure TddRTFTextParagraph.PackSegments;
var
  i: long;
  l_List: Tl3VList;
  l_Seg, l_NewSeg: TddTextsegment;
begin
  { Упаковка пустых сегментов }
  l_List:= Tl3Vlist.MakePersistent;
  try
    l_List.Add(TObject(TddTextSegment(f_Segments.Items[0])));
    if f_Segments.Count > 1 then
      for i:= 1 to f_Segments.Hi do
      begin
        l_Seg:= TddTextSegment(f_Segments.Items[i]);
          if l_Seg.Empty {} then
          begin
           // if not l_Seg.CHP.IsDefault then
              TddTextSegment(l_List.Items[l_List.Hi]).CHP.JoinWith(l_Seg.CHP, nil);
          end
          else
            l_List.Add(TObject(l_Seg));
      end;
    f_Segments.Assign(l_List);
  finally
    l3Free(l_List);
  end;
end;


function Hex2Dec(const St: AnsiString): Byte;
var
 B: Byte;
begin
 if St[1] in ['0'..'9'] then
   B:= Ord(St[1]) - Ord('0')
 else
   B:= Ord(Upcase(St[1])) - Ord('A')+10;
 B:= B*16;
 if St[2] in ['0'..'9'] then
   B:= B+Ord(St[2]) - Ord('0')
 else
   B:= B+Ord(Upcase(St[2])) - Ord('A')+10;
 Hex2Dec:= B;
end;



procedure TddRTFTextParagraph.Write2Generator(Generator: Tk2TagGenerator);
var
  j: Integer;
  l_Seg: TddTextSegment;
  l_S: Tl3String;
begin
  Generator.StartChild(k2_idTextPara);
  try
    //if not PAP.IsDefault then
    with PAP do
    begin
      Generator.AddIntegerAtom(k2_tiLeftIndent, l3MulDiv(xaLeft, evInchMul, rtfTwip));
      Generator.AddIntegerAtom(k2_tiFirstIndent, l3MulDiv(xaFirst + xaLeft, evInchMul, rtfTwip));
      Generator.AddIntegerAtom(k2_tiFirstLineIndent, l3MulDiv(xaFirst, evInchMul, rtfTwip));
      Generator.AddIntegerAtom(k2_tiRightIndent, l3MulDiv(xaRight, evInchMul, rtfTwip));

      { вычисление ширины абзаца }
      (*
      if PAP.InTable = boolTrue then
      begin

      end
      else
        G.AddIntegerAtom(k2_tiWidth, l3MulDiv(FRTFReader.DOP.xaPage - FRTFReader.DOP.xaLeft - FRTFReader.DOP.xaRight - xaRight, evInchMul, rtfTwip));

      if (PAP.InTable <> boolTrue) and (xaRight <> 0) and (xaLeft <> 0) then
            G.AddIntegerAtom(k2_tiWidth, l3MulDiv(FRTFReader.DOP.xaPage - FRTFREader.DOP.xaLeft -
               FRTFREader.DOP.xaRight - FRTFReader.DOP.xGutter -
               xaLeft - xaRight, evInchMul, rtfTwip));
      *)
      case Just of
        justR: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itRight));
        justC: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itCenter));
        justF: Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itWidth));
      else
        Generator.AddIntegerAtom(k2_tiJustification, Ord(ev_itLeft));
      end; { case Just}

      

    //  WriteBorder(Border);
    end; {  with }

    l_S:= Tl3String.Create(nil);
    try
     if Segments.Count > 0 then
     begin
      Generator.StartTag(k2_tiSegments);
      try
        Generator.StartChild(k2_idSegmentsLayer);
        try
          Generator.AddIntegerAtom(k2_tiHandle, ev_slView);

          for j:= 0 to Segments.Hi do
          begin
            { Выливка оформления сегментов }
           l_Seg:= TddTextSegment(Segments.Items[j]);
           if l_Seg.Len > 0 then
           begin
            Generator.StartChild(k2_idTextSegment);
            try
              Generator.AddIntegerAtom(k2_tiStart, l_S.Len+1);
              Generator.StartTag(k2_tiFont);
              try
               { here font properties }
                with l_SeG.CHP do
                begin { Вываливаем шрифтовое оформление }
                  if (Bold <> boolNotDefined) then
                    Generator.AddBoolAtom(k2_tiBold, ByteBool(Ord(Bold)));
                  Generator.AddBoolAtom(k2_tiItalic, ByteBool(Ord(Italic)));
                  (*
                  if (FontName <> CurCHP.FontName) and
                     (FontNumber > -1) then
                    Generator.AddStringAtom(k2_tiName, FontName);
                  *)
                  if (FontSize > -1) then
                    Generator.AddIntegerAtom(k2_tiSize, FontSize div 2);
//                        Generator.AddIntegerAtom(k2_tiForeColor, FColor);

//                        Generator.AddIntegerAtom(k2_tiBackColor, BColor);

//                        Generator.AddIntegerAtom(k2_tiBackColor, Highlight);

                    case Pos of
                      cpNone: Generator.AddIntegerAtom(k2_tiIndex, ord(l3_fiNone));
                      cpSuperScript: Generator.AddIntegerAtom(k2_tiIndex, ord(l3_fiSuper));
                      cpSubScript: Generator.AddIntegerAtom(k2_tiIndex, ord(l3_fiSub));
                    end;

                    Generator.AddBoolAtom(k2_tiUnderline, (Underline <> utNone)
                                            and (Underline <> utNotDefined));
                end;
              finally
                Generator.Finish; { font }
              end;
              if (J <> Segments.Hi) and (l_Seg.Len > 0) then
                Generator.AddIntegerAtom(k2_tiFinish, l_S.Len+l_Seg.Len+1)
              else
                Generator.AddIntegerAtom(k2_tiFinish, l_S.Len+l_Seg.Len);
            finally
              Generator.Finish; { Segment }
            end;
            l_S.JoinWith(l_Seg);
           end; 
          end;
        finally
          Generator.Finish;
        end;
      finally
        Generator.Finish;
      end;
      Generator.AddStringAtom(k2_tiText, l_S);
     end;
    finally
      l3Free(l_S);
    end;
  finally
    Generator.Finish;
  end;
end;




constructor TddRTFPicture.Create(aOwner: TObject);
begin
  inherited;
  AtomType:= dd_docPicture;
  f_Picture:= Tl3String.Create(nil);
  f_Format:= -1;
end;

procedure TddRTFPicture.Cleanup;
begin
  l3Free(f_Picture);
  inherited;
end;

function TddRTFPicture.GetFormat: Integer;
var
  l_Detector: TddPictureFormatDetector;
  l_Stream: Tl3MemoryStream;
  i: Integer;
  S: AnsiString;
  B: Byte;
begin
 if not f_Picture.Empty then
 begin
  l_Stream:= Tl3MemoryStream.Create;
  try
    S:= '';
    for i:= 0 to Pred(f_Picture.Len) do
    begin
      s:= s+f_Picture.Ch[i];
      if Length(S) = 2 then
      begin
        B:= Hex2Dec(S);
        l_Stream.Write(B, 1);
        S:= '';
      end;
    end;
    l_Stream.Seek(0, soBeginning);

    l_Detector:= TddPictureFormatDetector.Create(nil);
    try
      l_Detector.Check(l_Stream);
      Result:= l_Detector.PictureFormat;
    finally
      l3Free(l_Detector);
    end;
  finally
    l3FRee(l_Stream);
  end;
 end
 else
  Result:= 0;
end;

procedure TddRTFPicture.Write2Generator(Generator: Tk2TagGenerator);
var
  l_Stream: Tl3MemoryStream;
  i: Integer;
  S: AnsiString;
  B: Byte;
begin
  l_Stream:= Tl3MemoryStream.Create;
  try
    S:= '';
    for i:= 0 to Pred(f_Picture.Len) do
    begin
      s:= s+f_Picture.Ch[i];
      if Length(S) = 2 then
      begin
        B:= Hex2Dec(S);
        l_Stream.Write(B, 1);
        S:= '';
      end;
    end;

    l_Stream.Seek(0, soBeginning);

    Generator.StartChild(k2_idBitmapPara);
    try
      Generator.AddStreamAtom(k2_tiBitmap, l_Stream);
    finally
      Generator.Finish;
    end;
  finally
    l3Free(l_Stream);
  end;
end;





constructor TddRTFTableRow.Create(aOwner: TObject);
begin
  inherited;
  AtomType:= dd_docTableRow;
  f_CellList:= Tl3VList.MakePersistent;
  f_TAP:= TddRowProperty.Create(nil);
end;

procedure TddRTFTableRow.Cleanup;
begin
  l3Free(f_CellList);
  l3Free(f_TAP);
  inherited;
end;

procedure TddRTFTableRow.Write2Generator(Generator: Tk2TagGenerator);
var
  i, j: Integer;
  l_C: TddRTFCell;
  Delta, W : Long;
begin
  Generator.StartChild(k2_idTableRow);
  try
    for i:= 0 to f_CellList.Hi do
    begin
      l_C:= Cells[i];
      Generator.StartChild(k2_idTableCell);
      try
        Generator.AddIntegerAtom(k2_tiLeftIndent, l3MulDiv(TAP.Gaph, evInchMul, rtfTwip));
        if (i > 0) then
         Delta:= TAP.CellsProps[i-1].Width
        else
         Delta:= TAP.Left;
        W:= TAP.CellsProps[i].Width-Delta;
        Generator.AddIntegerAtom(k2_tiWidth, l3MulDiv(W, evInchMul, rtfTwip));



        for j:= 0 to l_C.Hi do
        begin
          TddRTFTextParagraph(l_C.Items[j]).Write2Generator(Generator);
        end; {for j}
      finally
        Generator.Finish;
      end;
    end; {for i}
  finally
    Generator.Finish;
  end;
end;

function TddRTFTableRow.GetCells(Index: Integer): TddRTFCell;
begin
  try
    Result:= TddRTFCell(f_CellList.Items[Index]);
  except
    Result:= nil;
  end;
end;

procedure TddRTFTableRow.AddCell(aCell: TddRTFCell);
begin
  f_CellList.Add(TObject(aCell));
end;

procedure TddRTFTableRow.SetTAP(aTAP: TddRowProperty);
begin
  f_TAP.Assign(aTAP);
end;


procedure TddBorder.Clear;
begin
 inherited Clear;
 FTop.Clear;
 FBottom.Clear;
 FLeft.Clear;
 FRight.Clear;
 FHorizontal.Clear;
 FVertical.Clear;
end;

procedure TddBorder.Assign(aBorder: TPersistent);
begin
 if (aBorder Is TddBorder) then begin
  FTop.Assign(TddBorder(aBorder).FTop);
  FBottom.Assign(TddBorder(aBorder).FBottom);
  FLeft.Assign(TddBorder(aBorder).FLeft);
  FRight.Assign(TddBorder(aBorder).FRight);
  FHorizontal.Assign(TddBorder(aBorder).FHorizontal);
  FVertical.Assign(TddBorder(aBorder).FVertical);
 end else
  inherited Assign(aBorder);
end;

constructor TddBorder.Create(AReader: TObject);
begin
  inherited Create(aReader);
  FTop:= TddBorderPart.Create(nil);
  FLeft:= TddBorderPart.Create(nil);
  FBottom:= TddBorderPart.Create(nil);
  FRight:= TddBorderPart.Create(nil);
  FHorizontal:= TddBorderPart.Create(nil);
  FVertical:= TddBorderPart.Create(nil);
end;

procedure TddBorder.Cleanup;
begin
  l3Free(FTop);
  l3Free(FLeft);
  l3Free(FBottom);
  l3Free(FRight);
  l3Free(FHorizontal);
  l3Free(FVertical);
  inherited;
end;

function TddBorder.GetFrameColor(Index: TddBorderParts): Longint;
begin
  if Frames[Index].FColor > 0 then
    Result:= {Kernel.ColorTable[}Frames[Index].FColor//]
  else
    Result:= 0;
end;

function TddBorder.GetFrameWidth(Index: TddBorderParts): Longint;
begin
  if Frames[Index].FWidth > 0 then
    Result:= Frames[Index].FWidth
  else
    Result:= 0;
end;

function TddBorder.GetFrameType(Index: TddBorderParts): TddBorderType;
begin
  Result:= Frames[Index].FType
end;

procedure TddBorder.SetFrameColor(Index: TddBorderParts; Value: Longint);
begin
  if Index = bpBox then
  begin
    FrameColor[bpTop]:= Value;
    FrameColor[bpLeft]:= Value;
    FrameColor[bpRight]:= Value;
    FrameColor[bpBottom]:= Value;
  end
  else
  if Frames[Index].FColor <> Value then
    Frames[Index].FColor := Value;
end;

procedure TddBorder.SetFrameWidth(Index: TddBorderParts; Value: Longint);
begin
  if Index = bpBox then
  begin
    FrameWidth[bpTop]:= Value;
    FrameWidth[bpLeft]:= Value;
    FrameWidth[bpRight]:= Value;
    FrameWidth[bpBottom]:= Value;
  end
  else
  if Frames[Index].FWidth <> Value then
    Frames[Index].FWidth := Value;
end;

procedure TddBorder.SetFrameType(Index: TddBorderParts; Value: TddBorderType);
begin
  if Index = bpBox then
  begin
    FrameType[bpTop]:= Value;
    FrameType[bpLeft]:= Value;
    FrameType[bpRight]:= Value;
    FrameType[bpBottom]:= Value;
  end
  else
  if Frames[Index].FType <> Value then
  begin
    Frames[Index].FType := Value;
    {if Value <> btNone then
      Frames[Index].FWidth:= 10;}
  end;
end;

function TddBorder.GetIsFramed: Boolean;
begin
  Result:= (FrameType[bpTop] <> btNone) or
           (FrameType[bpLeft] <> btNone) or
           (FrameType[bpBottom] <> btNone) or
           (FrameType[bpRight] <> btNone);
end;

procedure TddBorder.SetIsFramed(Value: Boolean);
begin
  if  Value <> IsFramed then
    if Value then
    begin
      FrameType[bpTop] := btSingleThick;
      FrameType[bpLeft] := btSingleThick;
      FrameType[bpBottom] := btSingleThick;
      FrameType[bpRight] := btSingleThick;
      FrameWidth[bpTop]:= 10;
      FrameWidth[bpLeft]:= 10;
      FrameWidth[bpRight]:= 10;
      FrameWidth[bpBottom]:= 10;
    end
    else
    begin
      FrameType[bpTop] := btNone;
      FrameType[bpLeft] := btNone;
      FrameType[bpBottom] := btNone;
      FrameType[bpRight] := btNone;
    end;
end;

function TddBorder.GetFrames(Index: TddBorderParts): TddBorderPart;
begin
  case Index of
    bpTop        : Result:= FTop;
    bpLeft       : Result:= FLeft;
    bpBottom     : Result:= FBottom;
    bpRight      : Result:= FRight;
    bpHorizontal : Result:= FHorizontal;
    bpVertical   : Result:= FVertical;
  else
    Result:= nil;
  end;
end;

procedure TddBorder.SetFrames(Index: TddBorderParts; Value: TddBorderPart);
begin
 ;
end;

function TddBorder.GetFrameSpace(Index: TddBorderParts): Integer;
begin
 Result:= Frames[Index].FSpace;
end;

procedure TddBorder.SetFrameSpace(Index: TddBorderParts; Value: Integer);
begin
 Frames[Index].FSpace:= Value;
end;

{ start class TddBorderPart }

procedure TddBorderPart.Clear;
  {override;}
  {-}
begin
 FType:= btNone;
 FColor:= 0;
 FWidth:= 0;
 Enable:= boolFalse;
 FSpace:= 20;
 inherited Clear;
end;

procedure TddBorderPart.Assign(BP: TPersistent);
  {override;}
  {-}
begin
 if (BP Is TddBorderPart) then begin
  FType:= TddBorderPart(BP).FType;
  FColor:= TddBorderPart(BP).FColor;
  FWidth:= TddBorderPart(BP).FWidth;
  Enable:= TddBorderPart(BP).Enable;
  FSpace:= TddBorderPart(BP).FSpace;
 end else
  inherited Assign(BP);
end;


end.
