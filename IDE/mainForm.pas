unit mainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DrawObjects1, DrawObjects2, Menus, ComCtrls, Printers,
  Types, ClipBrd, ExtCtrls, ActnList, ActnMan, IniFiles,
  ExtDlgs, dobQM, QuestModeler, dobFileStorage, ImgList, guiTypes,
  XPStyleActnCtrls, System.Actions;

type
  TDragListRec = record
    control: TControl;
    startPt: TPoint;
  end;
  PDragListRec = ^TDragListRec;

  TQuestEditorForm = class(TForm)
    PopupMenu1: TPopupMenu;
    NewRectangle1: TMenuItem;
    NewDiamond1: TMenuItem;
    NewEllipse1: TMenuItem;
    NewArc1: TMenuItem;
    NewPolygon1: TMenuItem;
    NewStar1: TMenuItem;
    NewSolidArrow1: TMenuItem;
    NewSolidBezier1: TMenuItem;
    N1: TMenuItem;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    N3: TMenuItem;
    Delete1: TMenuItem;
    DisableDesigning1: TMenuItem;
    StatusBar1: TStatusBar;
    ColorDialog1: TColorDialog;
    N4: TMenuItem;
    GrowLine1: TMenuItem;
    N5: TMenuItem;
    NewLine1: TMenuItem;
    NewBezier1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Rotate1: TMenuItem;
    NewPlainText1: TMenuItem;
    ModelBox: TScrollBox;
    N6: TMenuItem;
    Print1: TMenuItem;
    N7: TMenuItem;
    BringtoFront1: TMenuItem;
    SendtoBack1: TMenuItem;
    FontDialog1: TFontDialog;
    N9: TMenuItem;
    NewLLine1: TMenuItem;
    NewZLine1: TMenuItem;
    NewSolidPoint1: TMenuItem;
    SetBackgroundColor1: TMenuItem;
    ActionManager1: TActionManager;
    actBringToFront: TAction;
    actSendToBack: TAction;
    actProperties: TAction;
    Properties1: TMenuItem;
    actDelete: TAction;
    actCopy: TAction;
    actCopyAsBitmap: TAction;
    actPaste: TAction;
    actShrink: TAction;
    actRotate: TAction;
    actPrint: TAction;
    actBackground: TAction;
    FileSaveAs: TAction;
    FileOpen: TAction;
    actCopyAsMetafile: TAction;
    Configure1: TMenuItem;
    DefaultLineProperties1: TMenuItem;
    DefaultSolidProperties1: TMenuItem;
    N13: TMenuItem;
    New1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    NewBitmapPic1: TMenuItem;
    actCut: TAction;
    SplitPolyButton1: TMenuItem;
    DeletePolyButton1: TMenuItem;
    actGrowTop: TAction;
    GrowLinefromTop1: TMenuItem;
    actShrinkTop: TAction;
    actGrow: TAction;
    ShrinkLinefromTop1: TMenuItem;
    ShrinkLinefromBottom1: TMenuItem;
    actFlip: TAction;
    FlipHorizontally1: TMenuItem;
    N8: TMenuItem;
    UseTextDialogPrompt1: TMenuItem;
    NewTextBezier1: TMenuItem;
    FileSave: TAction;
    Save2: TMenuItem;
    actSavePicToBMP: TAction;
    SavePictureDialog1: TSavePictureDialog;
    SavePictoBMPfile1: TMenuItem;
    PrintDialog1: TPrintDialog;
    UseHitTest1: TMenuItem;
    actAlignLeft: TAction;
    actAlignTop: TAction;
    actAlignRight: TAction;
    actAlignBottom: TAction;
    actSpaceHorz: TAction;
    actSpaceVert: TAction;
    actEqualWidths: TAction;
    actEqualHeights: TAction;
    PaintBox1: TPaintBox;
    actGrid: TAction;
    ShowGrid1: TMenuItem;
    actSnapToGrid: TAction;
    actAlignCenterHorz: TAction;
    actAlignCenterVert: TAction;
    N16: TMenuItem;
    N17: TMenuItem;
    ScriptNewLocation: TAction;
    PopupMenu2: TPopupMenu;
    ScriptDescription: TAction;
    N18: TMenuItem;
    FileExit: TAction;
    FileNewModel: TAction;
    N10: TMenuItem;
    HelpAbout: TAction;
    N11: TMenuItem;
    ImageList1: TImageList;
    ScriptInventory: TAction;
    ScriptCheck: TAction;
    N12: TMenuItem;
    N14: TMenuItem;
    AlignLeft1: TMenuItem;
    ScriptVariables: TAction;
    N15: TMenuItem;
    itemGenerate: TMenuItem;
    procedure Delete1Click(Sender: TObject);
    procedure DisableDesigning1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure GrowLine1Click(Sender: TObject);
    procedure actSaveAsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actOpenClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ModelBoxClick(Sender: TObject);
    procedure actPrintClick(Sender: TObject);
    procedure CopyObject1Click(Sender: TObject);
    procedure PasteObject1Click(Sender: TObject);
    procedure CopyAsBitmapClick(Sender: TObject);
    procedure BringtoFront1Click(Sender: TObject);
    procedure SendtoBack1Click(Sender: TObject);
    procedure ModelBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ModelBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ModelBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure actBackgroundClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure actCopyAsMetafileClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure actCutExecute(Sender: TObject);
    procedure SplitPolyButton1Click(Sender: TObject);
    procedure DeletePolyButton1Click(Sender: TObject);
    procedure ShrinkLine1Click(Sender: TObject);
    procedure actFlipExecute(Sender: TObject);
    procedure UseTextDialogPrompt1Click(Sender: TObject);
    procedure actSaveClick(Sender: TObject);
    procedure actSavePicToBMPClick(Sender: TObject);
    procedure UseHitTest1Click(Sender: TObject);
    procedure actAlignLeftClick(Sender: TObject);
    procedure actSpaceHorzClick(Sender: TObject);
    procedure actEqualWidthsClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure actGridClick(Sender: TObject);
    procedure actSnapToGridClick(Sender: TObject);
    procedure FileExitExecute(Sender: TObject);
    procedure FileNewModelExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure HelpAboutExecute(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure ScriptNewLocationExecute(Sender: TObject);
    procedure ScriptDescriptionExecute(Sender: TObject);
    procedure ScriptVariablesExecute(Sender: TObject);
  private
    popupPt: TPoint;
    tmpLine: TLine;
    tmpSolid: TRectangle;
    fPastingFromClipboard: boolean;
    fCustomColors: TStringList;
    DragList: TList;
    f_Generators: TGeneratorCollection;
    f_Script: TdoModel;
    startDragPt: TPoint;
    procedure DrawFocusRec(Rec: TRect);
    procedure ClearAllDrawObjFocuses;
    function ScrollboxHasDrawObjects: boolean;
    procedure DrawObjMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DrawObjMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DrawObjMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DrawObjDblClick(Sender: TObject);
    procedure CountFocusedDrawObjs(out cnt: integer; out last: TDrawObject);
    function GetSolidObjFromScreenPt(pt: TPoint): TSolid;
    procedure DrawObjLoaded(Sender: TObject);
    procedure ObjectInspectorClose(Sender: TObject);
    procedure LoadIniSettings;
    procedure SaveIniSettings;
    procedure OpenObjects(const Filename: string);
    procedure SaveObjects(const Filename: string);
    //dragging stuff ...
    procedure ClearDragList;
    procedure AddControlToDragList(control: TControl);
    procedure CheckNewObjects;
    function CheckObject(aObj: TDrawObject): Boolean;
    procedure ClearConnectors(aFrom: TdoLocation);
    procedure ClearGenerators;
    procedure CreateConnector(aFrom, aTo: TdcLocation; aIsButton: Boolean = True);
    function CreateLocation: TdoLocation;
    function DragListObj(index: integer): PDragListRec;
    function FindConnectorFor(aFrom, aTo: TdcLocation): TConnector;
    procedure FindGenerators;
    function FindLocation(aLocation: TdcLocation): TdoLocation;
    procedure GenerateGame(Sender: TObject);
    function GetNewLocPosition: TPoint;
    function isOrphant(aLocation: TdcLocation): Boolean;
    procedure NewModel;
    procedure LocationEdit(sender: TObject);
    function pm_GetChanged: Boolean;
    procedure pm_SetChanged(const Value: Boolean);
    procedure SyncModelWithObjects;
    procedure UpdateCaption;
  public
    property Changed: Boolean read pm_GetChanged write pm_SetChanged;
    { Public declarations }
  end;

var
  QuestEditorForm: TQuestEditorForm;

  CF_DRAWOBJECTS: Cardinal;
  GridSize: integer = 8;

implementation

uses
 guiLocEditDlg, guiScriptDetailsDlg,
 StrUtils, ShellAPI, Math, guiLocEditDlgEx, guiVariableEditDlg, guiVariablesListDlg;



{$R *.dfm}
{.$R winxp.res}


function ScreenToPrinterX(pxl: integer): integer;
begin
  Result := round(pxl *
    GetDeviceCaps(Printer.Handle, LOGPIXELSX)/screen.PixelsPerInch);
end;
//------------------------------------------------------------------------------

function ScreenToPrinterY(pxl: integer): integer;
begin
  Result := round(pxl *
    GetDeviceCaps(Printer.Handle, LOGPIXELSY)/screen.PixelsPerInch);
end;
//------------------------------------------------------------------------------

function MakeDarker(color: TColor): TColor;
var
  r,g,b: byte;
begin
  Color := ColorToRGB(color);
  b := (Color shr 16) and $FF;
  g := (Color shr 8) and $FF;
  r := (Color and $FF);
  b := b * 31 div 32;
  g := g * 31 div 32;
  r := r * 31 div 32;
  result := (b shl 16) or (g shl 8) or r;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

procedure TQuestEditorForm.FormCreate(Sender: TObject);
begin
  DragList := TList.create;
  fCustomColors := TStringList.Create;

  SaveDialog1.InitialDir := ExtractFilePath(paramstr(0));
  OpenDialog1.InitialDir := ExtractFilePath(paramstr(0));
  OpenPictureDialog1.InitialDir := ExtractFilePath(paramstr(0));
  SavePictureDialog1.InitialDir := ExtractFilePath(paramstr(0));
  fCustomColors.Add('ColorA=' + inttohex(ColorToRGB(color),6));
  fCustomColors.Add('ColorB=' + inttohex(ColorToRGB(clCream),6));
  fCustomColors.Add('ColorC=' + inttohex(ColorToRGB(clMoneyGreen),6));
  fCustomColors.Add('ColorD=' + inttohex(ColorToRGB(clSkyBlue),6));

  ColorDialog1.CustomColors.Assign(fCustomColors);

  tmpLine := TLine.Create(self);
  tmpLine.Name := 'DefaultLine';
  tmpLine.CanFocus := false;
  tmpLine.Arrow2 := true;

  tmpSolid := TRectangle.Create(self);
  tmpSolid.Name := 'DefaultSolid';
  tmpSolid.Strings.Text := 'DefaultSolid';
  tmpSolid.CanFocus := false;

  LoadIniSettings;
  CF_DRAWOBJECTS := RegisterClipboardFormat('DrawObjects Format');

  Paintbox1.Canvas.Pen.Color := MakeDarker(color);

  //the following line is important to prevent flickering whenever
  //moving or adjusting drawObject controls...
  ModelBox.DoubleBuffered := true;

  //just in case a user wants to associate *.dob files with DrawObjects ...
  if ParamCount > 0 then
   OpenObjects(paramstr(1))
  else
   NewModel;
  FindGenerators
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.FormDestroy(Sender: TObject);
begin
 ClearGenerators;
  ClearDragList;
  DragList.Free;
  fCustomColors.Free;
  SaveIniSettings;
  tmpLine.Free;
  tmpSolid.Free;
  f_Script.Free;
end;

//------------------------------------------------------------------------------

procedure TQuestEditorForm.LoadIniSettings;
var
  l,t,w,h: integer;
begin
  with TIniFile.Create(changeFileExt(paramstr(0),'.ini')) do
  try
    //mainform position ...
    l := ReadInteger('MainWinPos','Left',MaxInt);
    t := ReadInteger('MainWinPos','Top',MaxInt);
    w := ReadInteger('MainWinPos','Width',100);
    h := ReadInteger('MainWinPos','Height',100);
    if (l <> MaxInt) and (t <> MaxInt) and (w > 100) and (h > 100) then
    begin
      if (l < 0) and (t < 0) then
        WindowState := wsMaximized
      else
      begin
        Position := poDesigned;
        if l + w > Screen.WorkAreaWidth then l := Screen.WorkAreaWidth - w;
        if t + h > Screen.WorkAreaHeight then t := Screen.WorkAreaHeight - h;
        setbounds(l,t,w,h);
      end;
    end;

    tmpLine.Color := TColor(ReadInteger('DefLine','Color',$FFFFFF)); //ie filled beziers

    tmpLine.ShadowSize := ReadInteger('DefLine','ShadowSize',2);
    tmpLine.ColorShadow := TColor(ReadInteger('DefLine','ShadowColor',$C0C0C0));

    tmpLine.Pen.Color := TColor(ReadInteger('DefLine','PenColor',$000000));
    tmpLine.Pen.Width := ReadInteger('DefLine','PenWidth', tmpLine.Pen.Width);
    tmpLine.Pen.Style := TPenStyle(byte(ReadInteger('DefLine','PenStyle', 0)));

    tmpSolid.Font.Name := ReadString('DefSolid','FontName', Font.Name);
    tmpSolid.Font.Size := ReadInteger('DefSolid','FontSize', Font.Size);
    tmpSolid.Font.Style := TFontStyles(byte(ReadInteger('DefSolid','FontStyle', 1)));
    tmpSolid.Color := TColor(ReadInteger('DefSolid','Color',$EEEEEE));
    tmpSolid.ShadowSize := ReadInteger('DefSolid','ShadowSize',2);
    tmpSolid.ColorShadow := TColor(ReadInteger('DefSolid','ShadowColor',$C0C0C0));

    tmpSolid.Pen.Color := TColor(ReadInteger('DefSolid','PenColor',$000000));
    tmpSolid.Pen.Width := ReadInteger('DefSolid','PenWidth', tmpLine.Pen.Width);
    tmpSolid.Pen.Style := TPenStyle(byte(ReadInteger('DefSolid','PenStyle', 0)));

    color := TColor(ReadInteger('Background','Color', integer(color)));

    UseTextDialogPrompt1.Checked := ReadBool('Setup', 'TestPrompt', false);
    UseHitTest1.Checked := ReadBool('Setup', 'UseHitTest', true);

    actGrid.Checked := ReadBool('Setup', 'ShowGrid', true);
    if actGrid.Checked then PaintBox1.Visible := true;

  finally
    free;
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.SaveIniSettings;
begin
  with TIniFile.Create(changeFileExt(paramstr(0),'.ini')) do
  try
    WriteInteger('MainWinPos','Left',left);
    WriteInteger('MainWinPos','Top',top);
    WriteInteger('MainWinPos','Width',width);
    WriteInteger('MainWinPos','Height',height);

    WriteInteger('DefLine','Color',integer(tmpLine.Color));

    WriteInteger('DefLine','ShadowSize',tmpLine.ShadowSize);
    WriteInteger('DefLine','ShadowColor',integer(tmpLine.ColorShadow));

    WriteInteger('DefLine','PenColor',integer(tmpLine.Pen.Color));
    WriteInteger('DefLine','PenWidth', tmpLine.Pen.Width);
    WriteInteger('DefLine','PenStyle', byte(tmpLine.Pen.Style));

    WriteString('DefSolid','FontName', tmpSolid.Font.Name);
    WriteInteger('DefSolid','FontSize', tmpSolid.Font.Size);
    WriteInteger('DefSolid','FontStyle', byte(tmpSolid.Font.Style));
    WriteInteger('DefSolid','Color',integer(tmpSolid.Color));
    WriteInteger('DefSolid','ShadowSize',tmpSolid.ShadowSize);
    WriteInteger('DefSolid','ShadowColor',integer(tmpSolid.ColorShadow));

    WriteInteger('DefSolid','PenColor',integer(tmpSolid.Pen.Color));
    WriteInteger('DefSolid','PenWidth', tmpLine.Pen.Width);
    WriteInteger('DefSolid','PenStyle', byte(tmpSolid.Pen.Style));

    WriteInteger('Background','Color', integer(color));

    WriteBool('Setup', 'TestPrompt', UseTextDialogPrompt1.Checked);
    WriteBool('Setup', 'UseHitTest', UseHitTest1.Checked);
    WriteBool('Setup', 'ShowGrid', actGrid.Checked);

  finally
    free;
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.ClearAllDrawObjFocuses;
var
  i: integer;
begin
  //hide design buttons & bounding rect for all TDrawObjects ...
  with ModelBox do
    for i := 0 to controlCount -1 do
      if Controls[i] is TDrawObject then
        TDrawObject(Controls[i]).Focused := false;
end;
//------------------------------------------------------------------------------

function TQuestEditorForm.ScrollboxHasDrawObjects: boolean;
var
  i: integer;
begin
  result := true;
  with ModelBox do for i := 0 to controlCount -1 do
    if Controls[i] is TDrawObject then exit;
  result := false;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.CountFocusedDrawObjs(out cnt: integer; out last: TDrawObject);
var
  i: integer;
begin
  //Count 'focused' TDrawObjects (ie with visible designer buttons).
  //nb: TGraphicControl descendants never get real 'focus' (ie they don't
  //respond directly to keyboard input).
  cnt := 0;
  last := nil;
  with ModelBox do
    for i := 0 to controlCount -1 do
      if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
      begin
        last := TDrawObject(Controls[i]);
        inc(cnt);
      end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.ModelBoxClick(Sender: TObject);
begin
  ClearAllDrawObjFocuses;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.DisableDesigning1Click(Sender: TObject);
var
  i: integer;
begin
  DisableDesigning1.Checked := not DisableDesigning1.Checked;
  with ModelBox do
    for i := 0 to controlCount -1 do
      if Controls[i] is TDrawObject then
        TDrawObject(Controls[i]).CanFocus := not DisableDesigning1.Checked;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.PopupMenu1Popup(Sender: TObject);
var
  i,cnt: integer;
  drawObj: TDrawObject;
  hasDrawObjects: boolean;
begin
(*
  //first, get the location for the new control (in case adding an Object) ...
  GetCursorPos(popupPt);

  //now only show the popup menuitems relevant to focused controls ...
  hasDrawObjects := ScrollboxHasDrawObjects;
  CountFocusedDrawObjs(cnt, drawObj);

  ActProperties.Enabled := (cnt = 1);
  actDelete.Visible := (cnt > 0);

  actGrow.Visible := (cnt = 1) and
    ((drawObj is TLine) or (drawObj is TBezier))
    and not assigned(TConnector(drawObj).Connection2);
  actGrowTop.Visible := (cnt = 1) and
    ((drawObj is TLine) or (drawObj is TBezier))
    and not assigned(TConnector(drawObj).Connection1);

  actShrink.Visible := actGrow.Visible and
    (((drawObj is TBezier) and (drawObj.ButtonCount > 4)) or
    (not (drawObj is TBezier) and (drawObj.ButtonCount > 2)));
  actShrinkTop.Visible := actGrowTop.Visible and
    (((drawObj is TBezier) and (drawObj.ButtonCount > 4)) or
    (not (drawObj is TBezier) and (drawObj.ButtonCount > 2)));

  actRotate.Visible := (cnt = 1);
  actCut.Enabled := (cnt > 0);
  actCopy.Enabled := (cnt > 0);
  actPaste.Enabled := clipboard.HasFormat(CF_DRAWOBJECTS);
  actCopyAsBitmap.Enabled := hasDrawObjects;
  actCopyAsMetafile.Enabled := actCopyAsBitmap.Enabled;
  actPrint.Enabled := actCopyAsBitmap.Enabled;
  actBringtoFront.Visible := (cnt = 1);
  actSendtoBack.Visible := (cnt = 1);
  actFlip.Visible := (cnt = 1) and
    ((drawObj is TPolygon) or (drawObj is TSolidBezier));
  actSavePicToBMP.Visible := (cnt = 1) and (drawObj is TPic);

  splitPolyButton1.Visible :=
    (cnt = 1) and (drawObj is TPolygon) and not (drawObj is TStar) and
    (TPolygon(drawObj).BtnIdxFromPt(TPolygon(drawObj).ScreenToClient(popupPt),true,i));
  deletePolyButton1.Visible :=
    splitPolyButton1.Visible and (TPolygon(drawObj).ButtonCount > 3);

  actSaveAs.Enabled := hasDrawObjects;
  actSave.Enabled := hasDrawObjects;

  Align1.Enabled := (cnt > 0);
  actAlignLeft.Enabled := (cnt > 1);
  actAlignTop.Enabled := (cnt > 1);
  actAlignRight.Enabled := (cnt > 1);
  actAlignBottom.Enabled := (cnt > 1);

  Spacing1.Enabled := (cnt > 2);
  Sizing1.Enabled  := (cnt > 1);
*)  
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.DrawObjLoaded(Sender: TObject);
begin
  with TDrawObject(Sender) do
  begin
    OnMouseDown := DrawObjMouseDown;
    OnMouseMove := DrawObjMouseMove;
    OnMouseUp := DrawObjMouseUp;
    //OnDblClick := DrawObjDblClick;
    CanFocus := not DisableDesigning1.Checked;
    Focused := CanFocus;
    if Sender is TBaseLine then
      TBaseLine(Sender).UseHitTest := UseHitTest1.Checked
    else
    if Sender is TdoLocation then
     TdoLocation(Sender).OnDblClick:= LocationEdit; 

    //if pasting from the clipboard, offset new objects slightly ...
    if fPastingFromClipboard then
    begin
      left := left + 10;
      top := top + 10;
    end;
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.UseTextDialogPrompt1Click(Sender: TObject);
begin
  UseTextDialogPrompt1.Checked := not UseTextDialogPrompt1.Checked;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.UseHitTest1Click(Sender: TObject);
var
  i: integer;
begin
  //'UseHitTest' means that the object (not just somewhere within its bounding
  //rectangle) must be clicked to select that object. This is useful especially
  //with lines whose bounding rectangles typically overlap other objects making
  //it harder to select the objects underneath.
  UseHitTest1.Checked := not UseHitTest1.Checked;
  with ModelBox do
    for i := 0 to controlCount -1 do
      if (Controls[i] is TDrawObject) then
        TDrawObject(Controls[i]).UseHitTest := UseHitTest1.Checked;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.Delete1Click(Sender: TObject);
var
  i: integer;
begin
  //delete TDrawObject controls that have focus ...

  with ModelBox do
    for i := controlCount -1 downto 0 do
      if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
      begin
       CheckObject(TDrawObject(Controls[i]));
        Controls[i].Free;
      end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.BringtoFront1Click(Sender: TObject);
var
  cnt: integer;
  drawObj: TDrawObject;
begin
  CountFocusedDrawObjs(cnt, drawObj);
  if (cnt = 1) then drawObj.BringToFront;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.SendtoBack1Click(Sender: TObject);
var
  cnt: integer;
  drawObj: TDrawObject;
begin
  CountFocusedDrawObjs(cnt, drawObj);
  if (cnt = 1) then drawObj.SendToBack;
  //we don't want our drawingObjects behind the PaintBox grid ...
  PaintBox1.SendToBack;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actBackgroundClick(Sender: TObject);
begin
  ColorDialog1.Color := color;
  if not ColorDialog1.Execute then exit;
  color := ColorDialog1.Color;
  Paintbox1.Canvas.Pen.Color := MakeDarker(color);
  fCustomColors.Assign(ColorDialog1.CustomColors);
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actGridClick(Sender: TObject);
begin
  actGrid.Checked := not actGrid.Checked;
  PaintBox1.Visible := actGrid.Checked;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.CopyObject1Click(Sender: TObject);
var
  i: integer;
  theList: TList;
  theStrings: TStringList;

  Data: THandle;
  DataPtr: Pointer;
  str: string;
begin
  theStrings := TStringList.create;
  theList := TList.create;
  try
    //copy all objects ...
    with ModelBox do for i := 0 to controlCount -1 do
      if Controls[i] is TDrawObject and TDrawObject(Controls[i]).Focused then
        theList.Add(Controls[i]);
    if theList.Count = 0 then exit;
    SaveDrawObjectsToStrings(theList, theStrings);

    //clipboard.AsText := theStrings.Text;
    //let's use a custom clipboard format instead ...
    str := theStrings.Text;
    Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, length(str)+1);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(pchar(str)^, DataPtr^, length(str)+1);
        clipboard.Open;
        try
          clipboard.clear;
          SetClipboardData(CF_DRAWOBJECTS, Data);
        finally
          clipboard.Close;
        end;
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
    end;

  finally
    theStrings.Free;
    theList.Free;
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actCutExecute(Sender: TObject);
begin
  CopyObject1Click(Sender);
  Delete1Click(Sender);
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.CopyAsBitmapClick(Sender: TObject);
var
  i,l,t,w,h: integer;
  bmp: TBitmap;
begin
  l := maxInt; t := MaxInt;
  w := 0; h := 0;
  with ModelBox do for i := 0 to controlCount -1 do
    if Controls[i] is TDrawObject then
      with TDrawObject(Controls[i]) do
      begin
        l := min(l, left);
        t := min(t, top);
        w := max(w, left + width);
        h := max(h, top + height);
      end;
  if (w = 0) or (h = 0) then exit;

  bmp := TBitmap.Create;
  bmp.Width := w - l; bmp.Height := h -t;
  bmp.Canvas.Brush.Color := self.Color;
  bmp.Canvas.FillRect(Rect(0,0,w,h));
  try
    //we could use either the DrawObject.bitmap property or
    //the DrawObject.Draw() method here since no scaling is required ...
    with ModelBox do for i := 0 to controlCount -1 do
      if Controls[i] is TDrawObject then
        with TDrawObject(Controls[i]) do
          draw(bmp.Canvas, left -l, top - t);

    Clipboard.SetAsHandle(CF_BITMAP, bmp.Handle);
  finally
    bmp.Free;
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actCopyAsMetafileClick(Sender: TObject);
var
  i,l,t,w,h: integer;
  mf: TMetafile;
  mfc: TMetafileCanvas;
begin
  l := maxInt; t := MaxInt;
  w := 0; h := 0;
  with ModelBox do for i := 0 to controlCount -1 do
    if Controls[i] is TDrawObject then
      with TDrawObject(Controls[i]) do
      begin
        l := min(l, left);
        t := min(t, top);
        w := max(w, left + width);
        h := max(h, top + height);
      end;
  if (w = 0) or (h = 0) then exit;

  mf := TMetafile.Create;
  try
    mf.Width := w - l; mf.Height := h -t;
    mfc := TMetafileCanvas.Create(mf, 0);
    try                              
      with ModelBox do for i := 0 to controlCount -1 do
        if (Controls[i] is TDrawObject) then with TDrawObject(Controls[i]) do
          Draw(mfc, left - l, top - t);
    finally
      FreeAndNil(mfc);
    end;
    ClipBoard.SetAsHandle(CF_ENHMETAFILE, mf.Handle);
  finally
    mf.Free;
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.PasteObject1Click(Sender: TObject);
var
  theStrings: TStringList;
  Data: THandle;
  str: string;
begin
  if not clipboard.HasFormat(CF_DRAWOBJECTS) then exit;
  ClearAllDrawObjFocuses;

  fPastingFromClipboard := true;
  theStrings := TStringList.create;
  try

    //theStrings.Text := clipboard.AsText;
    str := '';
    clipboard.Open;
    try
      Data := GetClipboardData(CF_DRAWOBJECTS);
      if Data <> 0 then
      try
        str := PChar(GlobalLock(Data));
      finally
        GlobalUnlock(Data);
      end;
    finally
      clipboard.Close;
    end;
    theStrings.Text := str;

    LoadDrawObjectsFromStrings(theStrings, self, ModelBox, DrawObjLoaded);
  finally
    theStrings.Free;
    fPastingFromClipboard := false;
  end;

end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.GrowLine1Click(Sender: TObject);
var
  cnt: integer;
  drawObj: TDrawObject;
begin
  CountFocusedDrawObjs(cnt, drawObj);
  if (cnt = 1) and (drawObj is TConnector) and
    not assigned(TConnector(drawObj).Connection2) then
      TConnector(drawObj).Grow( Sender = actGrowTop );
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.ShrinkLine1Click(Sender: TObject);
var
  cnt: integer;
  drawObj: TDrawObject;
begin
  CountFocusedDrawObjs(cnt, drawObj);
  if (cnt = 1) and (drawObj is TConnector) and
    not assigned(TConnector(drawObj).Connection2) then
      TConnector(drawObj).Shrink( Sender = actShrinkTop );
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.SplitPolyButton1Click(Sender: TObject);
var
  i,cnt: integer;
  drawObj: TDrawObject;
begin
  //split a polygon button into 2 buttons ...
  CountFocusedDrawObjs(cnt, drawObj);
  if not (cnt = 1) or not (drawObj is DrawObjects2.TPolygon) or (drawObj is TStar) then exit;

  with DrawObjects2.TPolygon(drawObj) do
    if BtnIdxFromPt(ScreenToClient(popupPt),true,i) then DuplicateButton(i);
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.DeletePolyButton1Click(Sender: TObject);
var
  i,cnt: integer;
  drawObj: TDrawObject;
begin
  //remove a polygon button ...
  CountFocusedDrawObjs(cnt, drawObj);
  if not (cnt = 1) or not (drawObj is DrawObjects2.TPolygon) or (drawObj is TStar) then exit;

  with DrawObjects2.TPolygon(drawObj) do
    if BtnIdxFromPt(ScreenToClient(popupPt),true,i) then RemoveButton(i);
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actFlipExecute(Sender: TObject);
var
  cnt: integer;
  drawObj: TDrawObject;
begin
  CountFocusedDrawObjs(cnt, drawObj);
  if (drawObj is DrawObjects2.TPolygon) then DrawObjects2.TPolygon(drawObj).Mirror
  else if (drawObj is TSolidBezier) then TSolidBezier(drawObj).Mirror;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actSavePicToBMPClick(Sender: TObject);
var
  cnt: integer;
  drawObj: TDrawObject;
begin
  CountFocusedDrawObjs(cnt, drawObj);
  if (cnt = 1) and (drawObj is TPic) and SavePictureDialog1.Execute then
    TPic(drawObj).SavePicToFile(SavePictureDialog1.FileName);
end;
//------------------------------------------------------------------------------

//Align selected controls ...
procedure TQuestEditorForm.actAlignLeftClick(Sender: TObject);
var
  i,j: integer;
begin
  j := -1;
  with ModelBox do
  begin
    for i := 0 to controlCount -1 do
      if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
      begin
        j := i;
        break;
      end;
    if j < 0 then exit;

    if Sender = actAlignLeft then
    begin
      for i := j+1 to controlCount -1 do
        if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
          Controls[i].Left := Controls[j].Left
    end else if Sender = actAlignTop then
    begin
      for i := j+1 to controlCount -1 do
        if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
          Controls[i].Top := Controls[j].Top
    end else if Sender = actAlignRight then
    begin  for i := j+1 to controlCount -1 do
        if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
          Controls[i].left := Controls[j].left + Controls[j].Width - Controls[i].Width;
    end else if Sender = actAlignBottom then
    begin
      for i := j+1 to controlCount -1 do
        if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
          Controls[i].Top := Controls[j].Top + Controls[j].Height - Controls[i].Height
    end else if Sender = actAlignCenterHorz then
    begin
      for i := j+1 to controlCount -1 do
        if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
          Controls[i].top := Controls[j].top + (Controls[j].Height div 2) -
            (Controls[i].Height div 2)
    end else if Sender = actAlignCenterVert then
    begin
      for i := j+1 to controlCount -1 do
        if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
          Controls[i].left := Controls[j].left + (Controls[j].Width div 2) -
            (Controls[i].Width div 2)
    end;
  end;
end;
//------------------------------------------------------------------------------

//Equally space selected controls ...
procedure TQuestEditorForm.actSpaceHorzClick(Sender: TObject);
var
  objList: TStringlist;
  i,k,spc: integer;
  rec: TRect;
begin
  //since the selected objects are likely NOT to have their Z-order the same as
  //the left-right (or top-bottom) order, we need to create a (sorted) list ...
  objList := TStringlist.Create;
  try
    with ModelBox do for i := 0 to controlCount -1 do
      if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
        objList.AddObject('',Controls[i]);
    if objList.Count < 2 then exit;

    if Sender = actSpaceHorz then
    begin
      with TControl(objList.Objects[0]) do
      begin
        rec := BoundsRect;
        k := Width;
        objList[0] := format('%6.6d',[Left]); //prepare to sort on Left edges
      end;
      for i := 1 to objList.Count -1 do
        with TControl(objList.Objects[i]) do
        begin
          objList[i] := format('%6.6d',[Left]);
          if Left < rec.Left then rec.Left := Left;
          if Left + Width > rec.Right then rec.Right := Left + Width;
          inc(k, Width);
        end;
      spc := (rec.Right - rec.Left - k) div (objList.Count -1);
      objList.Sort;
      for i := 1 to objList.Count -1 do
        with TControl(objList.Objects[i-1]) do
          TControl(objList.Objects[i]).left := Left + Width + spc;
    end else //Sender = actSpaceVert
    begin
      with TControl(objList.Objects[0]) do
      begin
        rec := BoundsRect;
        k := Height;
        objList[0] := format('%6.6d',[Top]); //prepare to sort on Top edges
      end;
      for i := 1 to objList.Count -1 do
        with TControl(objList.Objects[i]) do
        begin
          objList[i] := format('%6.6d',[Top]);
          if Top < rec.Top then rec.Top := Top;
          if Top + Height > rec.Bottom then rec.Bottom := Top + Height;
          inc(k, Height);
        end;
      spc := (rec.Bottom - rec.Top - k) div (objList.Count -1);
      objList.Sort;
      for i := 1 to objList.Count -1 do
        with TControl(objList.Objects[i-1]) do
          TControl(objList.Objects[i]).Top := Top + Height + spc;
    end;
  finally
    objList.Free;
  end;

end;
//------------------------------------------------------------------------------

//Equally size selected controls ...
procedure TQuestEditorForm.actEqualWidthsClick(Sender: TObject);
var
  i,j: integer;
begin
  j := -1;
  with ModelBox do
  begin
    for i := 0 to controlCount -1 do
      if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
      begin
        j := i;
        break;
      end;
    if j < 0 then exit;

    if Sender = actEqualWidths then
    begin
      for i := j+1 to controlCount -1 do
        if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
          Controls[i].Width := Controls[j].Width;
    end else
    begin
      for i := j+1 to controlCount -1 do
        if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
          Controls[i].Height := Controls[j].Height;
    end;
  end;
end;
//------------------------------------------------------------------------------

//Paint Grid ...
procedure TQuestEditorForm.PaintBox1Paint(Sender: TObject);
var
  i: integer;
begin
  with Paintbox1 do
  begin
    for i := 0 to (Width div GridSize) do
    begin
      canvas.MoveTo(i*GridSize,0);
      canvas.LineTo(i*GridSize,height);
    end;
    for i := 0 to (Height div GridSize) do
    begin
      canvas.MoveTo(0,i*GridSize);
      canvas.LineTo(width,i*GridSize);
    end;
  end;
end;
//------------------------------------------------------------------------------

//Align to Grid the selected DrawObject's left and top ...
procedure TQuestEditorForm.actSnapToGridClick(Sender: TObject);
var
  i,j,gsDiv2,pwDiv2: integer;
begin
  if not Paintbox1.Visible then exit;

  gsDiv2 := GridSize div 2;
  with ModelBox do
    for i := 0 to controlCount -1 do
      if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
        with TDrawObject(Controls[i]) do
        begin
          pwDiv2 := pen.Width div 2;
          
          j := (Left + margin - pwDiv2) mod GridSize;
          if j <= gsDiv2 then Left := Left - j
          else Left := Left + GridSize - j;

          j := (Top + margin - pwDiv2) mod GridSize;
          if j <= gsDiv2 then Top := Top - j
          else Top := Top + GridSize - j;
        end;
end;

//------------------------------------------------------------------------------
//Object dragging methods ...
//------------------------------------------------------------------------------

procedure TQuestEditorForm.ClearDragList;
var
  i: integer;
begin
  for i := 0 to dragList.Count -1 do
    dispose(PDragListRec(dragList[i]));
  dragList.Clear;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.AddControlToDragList(control: TControl);
var
  DragListRec: PDragListRec;
begin
  if not assigned(control) then exit;
  New(DragListRec);
  dragList.Add(DragListRec);
  DragListRec.control := control;
  DragListRec.startPt := Point(control.Left, control.Top);
end;
//------------------------------------------------------------------------------

function TQuestEditorForm.DragListObj(index: integer): PDragListRec;
begin
  if (index < 0) or (index >= dragList.Count) then
    result := nil else
    result := PDragListRec(dragList[index]);
end;
//------------------------------------------------------------------------------

function ConnectorHasStuckEnd(connector: TConnector): boolean;
begin
  with connector do
    result := (assigned(Connection1) and not Connection1.Focused) or
      (assigned(Connection2) and not Connection2.Focused);
end;
//------------------------------------------------------------------------------

//Implement drag moving of multiple objects ...
procedure TQuestEditorForm.DrawObjMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
begin
  if not (ssShift in Shift) and not TDrawObject(Sender).Focused then
      ClearAllDrawObjFocuses;

  //prepare for possible drag moving ...
  ClearDragList;
  GetCursorPos(startDragPt);
  with ModelBox do
    for i := 0 to ControlCount -1 do
      if (Controls[i] is TDrawObject) and TDrawObject(Controls[i]).Focused then
      begin
        //connectors with a fixed (non-moving) end are very tricky so ...
        if (Controls[i] is TConnector) and
          ConnectorHasStuckEnd(TConnector(Controls[i])) then continue;

        AddControlToDragList(Controls[i]);
      end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.DrawObjMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  screenPt: TPoint;
begin
  if not (ssLeft in Shift) or (dragList.Count < 2) then exit;
  //drag move all focused objects ...
  GetCursorPos(screenPt);
  for i := 0 to dragList.Count -1 do with DragListObj(i)^ do
    control.SetBounds(
      startPt.X + (screenPt.X - startDragPt.X),
      startPt.Y + (screenPt.Y - startDragPt.Y),
      control.Width,
      control.Height);
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.DrawObjMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ClearDragList;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.FormDeactivate(Sender: TObject);
begin
  //because the 'Object Inspector' shows non-Modal we need to block
  //the mainform from responding to shortcut keys until it regains focus ...
  ActionManager1.State := asSuspended;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.FormActivate(Sender: TObject);
begin
  ActionManager1.State := asNormal;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.ObjectInspectorClose(Sender: TObject);
begin
end;
//------------------------------------------------------------------------------


//GetSolidObjFromScreenPt(): Helper method for attaching TLines to TSolids ...
function TQuestEditorForm.GetSolidObjFromScreenPt(pt: TPoint): TSolid;
var
  i: integer;
begin
  with ModelBox do
    for i := 0 to controlCount -1 do
      if (Controls[i] is TSolid) and
        TSolid(Controls[i]).PointOverObject(pt) then
      begin
        result := TSolid(Controls[i]);
        exit;
      end;
  result := nil;
end;
//------------------------------------------------------------------------------

//when double-clicking an end button of a line (TConnector) object,
//let's make it connect to an underlying solid object if there is one ...
procedure TQuestEditorForm.DrawObjDblClick(Sender: TObject);
var
  pt: TPoint;
  btnIdx: integer;
  solid: TSolid;
begin
  //check if there's a TSolid under the cursor point ...
  GetCursorPos(pt);
  solid := GetSolidObjFromScreenPt(pt);
  if not (Sender is TConnector) or not assigned(solid) then
  begin
    exit;
  end;

  //also check if a TDrawObject designer 'button' is under the cursor point ...
  pt := TConnector(Sender).ScreenToClient(pt);
  if not TConnector(Sender).BtnIdxFromPt(pt,true, btnIdx) then
  begin
    exit;
  end;

  if (btnIdx = 0) then
  begin
    //the button at the beginning of the line was clicked, so ...
    TConnector(Sender).Connection1 := solid;
  end else if (btnIdx = TConnector(Sender).ButtonCount -1) then
  begin
    //the button at the end of the line was clicked, so ...
    TConnector(Sender).Connection2 := solid;
    //let's give it an arrow too ...
    //TConnector(Sender).Arrow2 := true;
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.New1Click(Sender: TObject);
var
  i: integer;
begin
  //clear all DrawObjects
  NewModel;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.OpenObjects(const Filename: string);
begin
 //first clear existing objects ...
 New1Click(nil);
 //now load new objects from file ...
 LoadModel(FileName, Self, ModelBox, DrawObjLoaded, f_Script);
 ClearAllDrawObjFocuses;
 SaveDialog1.FileName := FileName;
 OpenDialog1.FileName := FileName;
 UpdateCaption;
 SyncModelWithObjects;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
   OpenObjects(OpenDialog1.FileName);
   
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.SaveObjects(const Filename: string);
begin
 SaveModel(FileName, ModelBox, f_Script);
 Changed:= False;
 OpenDialog1.FileName := FileName;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actSaveClick(Sender: TObject);
begin
  if (SaveDialog1.FileName = '') then
   actSaveAsClick(Sender) else
   SaveObjects(SaveDialog1.FileName);
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actSaveAsClick(Sender: TObject);
begin
  if SaveDialog1.Execute then SaveObjects(SaveDialog1.FileName);
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.Exit1Click(Sender: TObject);
begin
  close;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.actPrintClick(Sender: TObject);
var
  i: integer;
  mf: TMetafile;
  mfc: TMetafileCanvas;
  srcRec: TRect;
begin
  srcRec := Rect(maxInt, maxInt, 0, 0);
  mf := TMetafile.Create;
  with ModelBox do
  try
    //first, calculate the dimensions of the metafile ...
    for i := 0 to ControlCount -1 do
      if (Controls[i] is TDrawObject) then
        with TDrawObject(Controls[i]) do
        begin
          srcRec.Left := min(srcRec.Left, left);
          srcRec.Top := min(srcRec.Top, top);

          srcRec.Right := max(srcRec.Right, left + width);
          srcRec.Bottom := max(srcRec.Bottom, top + height);
        end;
    if (srcRec.Left = maxInt) then exit; //ie quit if no objects
    mf.Width := srcRec.Right - srcRec.Left;
    mf.Height := srcRec.Bottom - srcRec.Top;

    //now, draw each DrawObject onto a metafile canvas ...
    //Notes:
    //1. Designer buttons etc will not be drawn using either TDrawObject.Bitmap
    //   property or the TDrawObject.Draw() method.
    //2. When metafile scaling is required (eg when printing, where screen
    //   pixel sizes are (very much) larger than printer pixel sizes), it's
    //   vastly preferable to Draw() to a metafile canvas rather than simply
    //   'stretching' bitmaps to a canvas otherwise marked pixelation will occur.
    mfc := TMetafileCanvas.Create(mf, 0);
    try
      for i := 0 to ControlCount -1 do
        if (Controls[i] is TDrawObject) then with TDrawObject(Controls[i]) do
          Draw(mfc, left - srcRec.Left, top - srcRec.Top);
    finally
      FreeAndNil(mfc);
    end;

    //now preview the metafile ...
  finally
    mf.Free;
  end;
end;
//------------------------------------------------------------------------------

//Implement rubberband selection of objects ...
var
  SelectionRec: TRect;
  SelectionShape: TShape;

procedure TQuestEditorForm.DrawFocusRec(Rec: TRect);
begin
  if not Assigned(SelectionShape) then
  begin
    SelectionShape := TShape.create(self);
    SelectionShape.Parent := ModelBox;
    SelectionShape.Brush.Style := bsClear;
    SelectionShape.Pen.Style := psDot;
  end;
  with Rec do
    SelectionShape.SetBounds(left,top,right-left, bottom-top);
end;
//------------------------------------------------------------------------------

function NormalizeRect(r: TRect): TRect;
begin
  if r.Left < r.Right then
  begin
    result.Left := r.Left; result.Right := r.Right;
  end else
  begin
    result.Left := r.Right; result.Right := r.Left;
  end;
  if r.Top < r.Bottom then
  begin
    result.Top := r.Top; result.Bottom := r.Bottom;
  end else
  begin
    result.Top := r.Bottom; result.Bottom := r.Top;
  end;
end;

procedure TQuestEditorForm.CheckNewObjects;
var
 i, j: Integer;
 l_LocFrom, l_LocTo: TdcLocation;
begin
 // Нужно:
 //  - пробежаться по всем локациям модели и создать недостающие
 for i:= 0 to Pred(f_Script.LocationsCount) do
  if isOrphant(f_Script.Locations[i]) then
   CreateLocation.Location:= f_Script.Locations[i];
 //  - пробежаться по всем действиям всех локаций и сделать соединения
 for i:= 0 to Pred(f_Script.LocationsCount) do
 begin
  l_LocFrom:= f_Script.Locations[i];
  for j:= 0 to Pred(l_LocFrom.ActionsCount) do
  begin
   if l_LocFrom.Actions[j] is TdcGotoAction then
   begin
    l_LocTo:= TdcGotoAction(l_LocFrom.Actions[j]).Location;
    if (l_LocTo <> nil) then
     if (FindConnectorFor(l_LocFrom, l_LocTo) = nil) then
      CreateConnector(l_LocFrom, l_locTo, False)
   end; // l_LocFrom.Actions[j] is TdcGotoAction
  end; // for j
  for j:= 0 to Pred(l_LocFrom.ButtonsCount) do
  begin
   if l_LocFrom.Buttons[j] is TdcButtonAction then
   begin
    l_LocTo:= TdcButtonAction(l_LocFrom.Buttons[j]).Location;
    if (l_LocTo <> nil) then
     if (FindConnectorFor(l_LocFrom, l_LocTo) = nil) then
      CreateConnector(l_LocFrom, l_locTo)
   end; // l_LocFrom.Actions[j] is TdcGotoAction
  end; // for j
 end; // for i
end;

function TQuestEditorForm.CheckObject(aObj: TDrawObject): Boolean;
begin
 // TODO -cMM: TQuestEditorForm.CheckObject необходимо написать реализацию
 // необходимо проверить удаляемый объект на использование
 Result:= True;
end;

procedure TQuestEditorForm.ClearConnectors(aFrom: TdoLocation);
var
 i: Integer;
begin
 with ModelBox do
 begin
  i:= Pred(ControlCount);
  while i >= 0 do
  begin
   if i = ControlCount then
    Dec(i);
   if (Controls[i] is TConnector) then
    if (TConnector(Controls[i]).Connection1 = aFrom) then
    begin
     RemoveControl(Controls[i]);
     Inc(i);
    end;
   Dec(i);
  end;
 end;
end;

procedure TQuestEditorForm.ClearGenerators;
begin
  f_Generators.Free;
end;

procedure TQuestEditorForm.CreateConnector(aFrom, aTo: TdcLocation; aIsButton: Boolean = True);
var
 drawObj: {TBezier;//}TLine;
begin
 drawObj := TLine.Create(self);
 MakeNameForControl(drawObj);
 drawObj.parent := ModelBox;
 DrawObjLoaded(drawObj);
 if aIsButton then
  drawObj.Color := tmpLine.Color
 else
  drawObj.Color:= clGray;
 drawObj.ColorShadow := tmpLine.ColorShadow;
 drawObj.Pen.Assign(tmpLine.Pen);
 drawObj.ShadowSize := tmpLine.ShadowSize;
 with TLine(drawObj) do
 begin
  Arrow2:= true;
  Connection1:= FindLocation(aFrom);
  Connection2:= FindLocation(aTo);
 end;
end;

function TQuestEditorForm.CreateLocation: TdoLocation;
begin
 ClearAllDrawObjFocuses;
 Changed:= True;
 
 Result := TdoLocation.Create(self);
 with GetNewLocPosition do
 begin
   Result.Left := X;
   Result.Top := Y;
 end;
 Result.Rounded:= True;
 Result.Height:= 50;
 Result.Width:= 100;

 MakeNameForControl(Result);
 Result.parent := ModelBox;
 DrawObjLoaded(Result);
 Result.Color := tmpSolid.Color;
 Result.ColorShadow := tmpSolid.ColorShadow;
 Result.Pen.Assign(tmpSolid.Pen);
 Result.ShadowSize := tmpSolid.ShadowSize;
 Result.Pen.Style:= psClear;

 Result.ShowHint:= True;
end;

procedure TQuestEditorForm.FileExitExecute(Sender: TObject);
begin
 Close;
end;

procedure TQuestEditorForm.FileNewModelExecute(Sender: TObject);
begin
 NewModel;
end;

function TQuestEditorForm.FindConnectorFor(aFrom, aTo: TdcLocation): TConnector;
var
 l_Loc1, l_Loc2: TdoLocation;
 i: Integer;
begin
 Result := nil;
 l_Loc1:= FindLocation(aFrom);
 l_Loc2:= FindLocation(aTo);
 with ModelBox do
  for i := 0 to Pred(ControlCount) do
   if (Controls[i] is TConnector) then
    if (TConnector(Controls[i]).Connection1 = l_Loc1) and (TConnector(Controls[i]).Connection2 = l_Loc2) then
    begin
     Result:= TConnector(Controls[i]);
     break;
    end;
end;

procedure TQuestEditorForm.FindGenerators;
var
 l_SR: TSearchRec;
 l_Item: TGeneratorInfo;
 l_Ini: TIniFile;
 l_Folder: String;
 l_MenuItem: TMenuItem;
begin
 // бежим по папке в поисках ini-файлов, открываем их, проверяем в них наличие раздела Generator
 f_Generators:= TGeneratorCollection.Create(TGeneratorInfo);
 l_Folder:= ExtractFileDir(Application.ExeName);
 if FindFirst(l_Folder+'\*.ini', faAnyFile, l_SR) = 0 then
 begin
   repeat
    if l_SR.Name[1] <> '.' then
    begin
     l_Ini:= TIniFile.Create(l_Folder + '\' + l_SR.Name);
     try
      if l_Ini.SectionExists('Generator') then
      begin
       l_Item:= TGeneratorInfo(f_Generators.Add);
       l_Item.Caption:= l_Ini.ReadString('Generator', 'Format', '');
       l_Item.Generator:= l_Folder + '\' + l_Ini.ReadString('Generator', 'exe', '');
       l_MenuItem:= TMenuItem.Create(MainMenu1);
       l_MenuItem.Caption:= l_Item.Caption;
       l_MenuItem.Tag:= l_Item.Index;
       l_MenuItem.OnClick:= GenerateGame;
       l_MenuItem.Enabled:= FileExists(l_Item.Generator);
       itemGenerate.Add(l_MenuItem);
      end;
     finally
      l_Ini.Free;
     end;
    end;
   until FindNext(l_SR) <> 0;
   FindClose(l_sr);
 end;
end;

function TQuestEditorForm.FindLocation(aLocation: TdcLocation): TdoLocation;
var
 i: Integer;
begin
 Result:= nil;
 with ModelBox do
  for i := 0 to Pred(ControlCount) do
   if (Controls[i] is TdoLocation) then
    if TdoLocation(Controls[i]).Location = aLocation then
    begin
     Result:= TdoLocation(Controls[i]);
     break;
    end;
end;

procedure TQuestEditorForm.FormCloseQuery(Sender: TObject; var CanClose:
    Boolean);
var
 l_Result: Integer;
begin
 if Changed then
 begin
  l_Result:= MessageDlg('Сценарий изменился. Сохранить?', mtWarning, mbyesNoCancel, 0);
  CanClose:= l_Result <> mrCancel;
  if l_Result = mrYes then
   actSaveClick(self);
 end
 else
  CanClose:= True;
end;

//------------------------------------------------------------------------------

procedure TQuestEditorForm.ModelBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not (ssLeft in Shift) then exit;
  SelectionRec := Rect(X,Y,X,Y);
  DrawFocusRec(SelectionRec);
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.ModelBoxMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if not Assigned(SelectionShape) then exit;
  SelectionRec.Right := X;
  SelectionRec.Bottom := Y;
  DrawFocusRec(NormalizeRect(SelectionRec));
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.ModelBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  dummyRec: TRect;
begin
  if Assigned(SelectionShape) then
  begin
    FreeAndNil(SelectionShape);
    SelectionRec := NormalizeRect(SelectionRec);
    with SelectionRec, ModelBox do
      for i := 0 to ControlCount -1 do
        if (Controls[i] is TDrawObject) then
          with TDrawObject(Controls[i]) do
            Focused := Visible and
              IntersectRect(dummyRec, SelectionRec, BoundsRect);
  end;
end;
//------------------------------------------------------------------------------

procedure TQuestEditorForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    //Escape key will cancel any impending rubberband selection ...
    if Assigned(SelectionShape) then FreeAndNil(SelectionShape);
  end;
end;

procedure TQuestEditorForm.GenerateGame(Sender: TObject);
var
 l_Gen: TGeneratorInfo;
 l_Stream: TStream;
 l_FileName: String;
 l_Result: Integer;
 l_Msg: String;
begin
 if f_Script.IsValid then
 begin
  l_Gen:= TGeneratorInfo(f_Generators.Items[(Sender as TMenuItem).Tag]);
  ActSaveClick(Sender);
  if SaveDialog1.FileName = '' then
   MessageDlg('Перед генерацией игры необходимо сохранить сценарий', mtError, [mbCancel], 0)
  else
  begin
   l_FileName:= ChangeFileExt(SaveDialog1.FileName, '.temp');
   l_Stream:= TFileStream.Create(l_FileName, fmCreate);
   try
    f_Script.SaveToStream(l_Stream);
   finally
    l_Stream.Free;
   end;
   //l_Result:= ShellExecute(Application.Handle, 'open', PChar(l_Gen.Generator), PChar(l_FileName), nil, sw_shownormal);
   l_Result:= WinExec32AndWait(l_Gen.Generator+' '+l_FileName, SW_HIDE);
   if l_Result <> 0 then
   begin
    case l_Result of
     ERROR_FILE_NOT_FOUND: l_Msg:= 'The specified file was not found.';
     ERROR_PATH_NOT_FOUND: l_Msg:= 'The specified path was not found.';
     ERROR_BAD_FORMAT: l_Msg:= 'The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
     SE_ERR_ACCESSDENIED: l_Msg:= '	The operating system denied access to the specified file.';
     SE_ERR_ASSOCINCOMPLETE: l_Msg:= '	The filename association is incomplete or invalid.';
     SE_ERR_DDEBUSY: l_Msg:= '	The DDE transaction could not be completed because other DDE transactions were being processed.';
     SE_ERR_DDEFAIL: l_Msg:= '	The DDE transaction failed.';
     SE_ERR_DDETIMEOUT: l_Msg:= '	The DDE transaction could not be completed because the request timed out.';
     SE_ERR_DLLNOTFOUND: l_Msg:= '	The specified dynamic-link library was not found.';
     //SE_ERR_FNF: l_Msg:= '	The specified file was not found.';
     SE_ERR_NOASSOC: l_Msg:= '	There is no application associated with the given filename extension.';
     SE_ERR_OOM: l_Msg:= '	There was not enough memory to complete the operation.';
     //SE_ERR_PNF: l_Msg:= '	The specified path was not found.';
     SE_ERR_SHARE: l_Msg:= '	A sharing violation occurred.';
    else
     l_Msg:= IntToStr(l_Result)
    end;
    MessageDlg('Генерация игры завершилась с ошибкой: '+l_Msg, mtError, [mbCancel], 0);
   end
   else
    MessageDlg('Генерация игры завершилась успешно', mtError, [mbOk], 0);
   DeleteFile(l_FileName);
  end;
 end
 else
  MessageDlg('Сценарий не готов для генерации игры. Проверьте условия:'#10+
             f_Script.NotValidConditions , mtError, [mbCancel], 0)
end;

function TQuestEditorForm.GetNewLocPosition: TPoint;
begin
 f_Script.GetFreePosition(Result.X, Result.Y);
end;

procedure TQuestEditorForm.HelpAboutExecute(Sender: TObject);
begin
 ShowMessage('Графический редактор сюжета.'^M'Версия 0.1');
end;

function TQuestEditorForm.isOrphant(aLocation: TdcLocation): Boolean;
begin
 Result := FindLocation(aLocation) = nil;
end;

procedure TQuestEditorForm.NewModel;
var
 i: integer;
begin
 with ModelBox do
   for i := controlCount -1 downto 0 do
     if Controls[i] is TDrawObject then Controls[i].free;
 Freeandnil(f_Script);
 f_Script:= TdoModel.Create(nil);
 Changed:= False;
 caption := f_Script.Caption + ' - ' + Application.title;
 SaveDialog1.FileName := '';
end;

procedure TQuestEditorForm.LocationEdit(sender: TObject);
begin
 if Sender is TdoLocation then
 begin
  if EditLocationEx(TdoLocation(Sender).Location) then

  //if EditLocation(TdoLocation(Sender).Location, f_Script) then
  begin
   Changed:= True;
   TdoLOcation(Sender).Strings.Text:= TdoLocation(Sender).Location.Caption;
   TdoLocation(Sender).Hint:= TdoLocation(Sender).Location.Hint;
   TdoLocation(Sender).Padding := 0;
   ClearConnectors(TdoLocation(Sender));
   CheckNewObjects;
  end; // EditLocation(TdoLocation(Sender).Location)
 end;
end;

function TQuestEditorForm.pm_GetChanged: Boolean;
begin
  Result := f_Script.Changed;
end;

procedure TQuestEditorForm.Properties1Click(Sender: TObject);
begin
 LocationEdit(Sender);
end;

procedure TQuestEditorForm.ScriptNewLocationExecute(Sender: TObject);
 // Нужно добавить новую локацию (прямоугольник заданного размера)
var
 l_Loc: TdoLocation;
begin
 l_Loc:= CreateLocation;
 l_Loc.Location:= f_Script.NewLocation('');
 LocationEdit(l_Loc);
end;

procedure TQuestEditorForm.SyncModelWithObjects;
var
 i: Integer;
begin
 with ModelBox do
  for i := 0 to Pred(ControlCount) do
   if (Controls[i] is TdoLocation) then
   begin
    TdoLocation(Controls[i]).Location:= f_Script.FindLocation(TdoLocation(Controls[i]).Strings.Text);

   end;
end;

//------------------------------------------------------------------------------

procedure TQuestEditorForm.ScriptDescriptionExecute(Sender: TObject);
begin
 // Ввод и редактирование описание квеста
 if EditScriptDetails(f_Script) then
 begin
  UpdateCaption;
  Changed:= True;
 end; // EditScriptDetails(l_C, l_D)
end;

procedure TQuestEditorForm.pm_SetChanged(const Value: Boolean);
begin
 f_Script.Changed := Value;
 StatusBar1.Panels[1].Text:= IfThen(Value, '*', '');
end;

procedure TQuestEditorForm.ScriptVariablesExecute(Sender: TObject);
begin
 Changed:= EditVariablesList(f_Script);
end;

procedure TQuestEditorForm.UpdateCaption;
begin
 if f_Script.Caption <> '' then
  caption := f_Script.Caption + ' - ' + Application.title
 else
  caption := ExtractFileName(SaveDialog1.FileName) + ' - ' + Application.title;
end;

end.
