unit ddRTFReader;

// $Id: ddRTFReader.pas,v 1.146 2013/05/06 12:37:11 dinishev Exp $ 

// $Log: ddRTFReader.pas,v $
// Revision 1.146  2013/05/06 12:37:11  dinishev
// ���������� ������� � "�����������" - �������� ������ ������.
//
// Revision 1.145  2013/04/11 16:46:28  lulin
// - ���������� ��� XE3.
//
// Revision 1.144  2013/04/05 12:04:30  lulin
// - ���������.
//
// Revision 1.143  2013/03/20 11:37:28  narry
// * �� �������� �������������� ������
//
// Revision 1.142  2013/03/15 08:42:45  fireton
// - �� ����� ������ �������� ��� ������������ ������
//
// Revision 1.141  2013/02/14 10:49:59  narry
// ������ ������
//
// Revision 1.140  2013/01/25 13:13:36  narry
// �� ��������������� ����� �� ����� (424386600)
//
// Revision 1.139  2013/01/25 05:38:51  narry
// �������� ������������� �� ������������� (407745210)
//
// Revision 1.138  2013/01/24 12:59:15  narry
// �������� ������������� �� ������������� (407745210)
//
// Revision 1.137  2013/01/24 07:21:41  narry
// �� ����������
//
// Revision 1.136  2013/01/24 06:05:25  narry
// ����������
//
// Revision 1.135  2013/01/22 12:19:52  narry
// ����������� RTFReader
//
// Revision 1.133  2012/11/09 08:52:29  narry
// ������� ����� � �������� ������ (407750788)
//
// Revision 1.132  2012/09/28 10:40:39  narry
// ����� ������ ����������� ���� ����� ������ (397291894)
//
// Revision 1.131  2012/09/25 08:23:35  narry
// ������ ������ �� ���������� � 10000
//
// Revision 1.130  2012/08/28 11:02:29  narry
// ����������
//
// Revision 1.129  2012/07/06 08:57:08  fireton
// - ��������
//
// Revision 1.128  2012/06/26 13:56:16  narry
// ������������� ������ �� �������
//
// Revision 1.127  2012/04/12 11:21:55  narry
// ��������� ������������� ����������
//
// Revision 1.126  2011/09/21 12:30:06  narry
// ��������� ����� ������ ��� �������������� (285510478)
//
// Revision 1.125  2011/07/22 06:54:02  narry
// ��������� ��� ����������� �������������� "���������" rtf
//
// Revision 1.124  2011/05/18 17:46:03  lulin
// {RequestLink:266409354}.
//
// Revision 1.123  2011/04/15 12:41:27  narry
// �������� �������� (262636436)
//
// Revision 1.122  2011/02/11 08:25:53  narry
// K253666052. �������� ���� EnablePictures
//
// Revision 1.121  2011/02/10 11:24:50  narry
// K253664417. �� �������� ���� K235062061
//
// Revision 1.120  2011/02/09 11:34:21  narry
// �253657673. ������ �������� �� RTF
//
// Revision 1.119  2010/11/30 11:47:16  lulin
// {RequestLink:228688602}.
// - ������ � ����������������.
//
// Revision 1.118  2010/09/17 09:01:28  narry
// k235051685. �������� ������� �� ���������� �����
//
// Revision 1.117  2010/07/30 13:23:57  narry
// - ������ ����
//
// Revision 1.116  2010/02/24 18:16:27  lulin
// - ����������� �� ��������� � �������� ���������, ������������ � ���������� �� ������ ���������.
//
// Revision 1.115  2009/07/31 11:10:53  narry
// - ��������� ��������� ����� �� ���������
//
// Revision 1.114  2009/07/23 13:42:39  lulin
// - ��������� ��������� �������� ���� ���� ����.
//
// Revision 1.113  2009/07/23 08:15:11  lulin
// - �������� �������� ������������� ���������� ��������.
//
// Revision 1.112  2009/06/24 10:58:27  narry
// - ������-�������� RTF �� OpenOffice
//
// Revision 1.111  2009/06/11 06:34:11  narry
// - �������������� �������� �����
//
// Revision 1.110  2009/05/29 11:36:31  narry
// - ������ �������� ���� ���������� ������ � ���
//
// Revision 1.109  2009/03/04 13:33:06  lulin
// - <K>: 137470629. ���������� �������������� ����� � ������ � ������� �� �� ����� �������.
//
// Revision 1.108  2008/12/16 11:48:55  narry
// - ��������� �������
//
// Revision 1.107  2008/10/23 10:40:06  narry
// - ��������� ����� ������ � ������-��������� ��������
//
// Revision 1.106  2008/10/20 07:52:45  narry
// - �� ������������� �������� � ������ Lite
//
// Revision 1.105  2008/10/15 09:43:59  narry
// - �������������� ������-��������� � �������
//
// Revision 1.104  2008/10/13 14:59:15  voba
// no message
//
// Revision 1.103  2008/10/13 12:39:27  narry
// - ������������� ����������
//
// Revision 1.102  2008/10/03 13:58:42  narry
// - ������� ��� ����� ������������� ������ RTF
//
// Revision 1.101  2008/06/20 14:49:11  lulin
// - ���������� �������� ���������.
//
// Revision 1.100  2008/04/24 15:08:01  narry
// - ��� ������� ������������� � �����
//
// Revision 1.99  2008/04/22 10:09:20  narry
// - ����� ��������� ����� ��������
//
// Revision 1.98  2008/04/17 14:44:44  narry
// - ������, ������, ��������
//
// Revision 1.97  2008/04/10 10:59:13  narry
// - ������ �������� �������� ��� ��������� ������
//
// Revision 1.96  2008/04/09 13:51:15  narry
// - �����������
// - ������ �������� ������� �� (*, �, #)
//
// Revision 1.95  2008/04/08 11:13:35  narry
// - ��������� ����� � ������������ � ��
//
// Revision 1.94  2008/04/08 10:35:28  narry
// - ������ �� ������ �� ����� ������
//
// Revision 1.93  2008/03/21 14:09:22  lulin
// - cleanup.
//
// Revision 1.92  2008/03/14 11:36:55  narry
// - ������ � ���������� ������� �������� ������ ������
//
// Revision 1.91  2008/03/03 20:06:00  lulin
// - <K>: 85721135.
//
// Revision 1.90  2008/02/22 09:06:37  lulin
// - �������� ������������.
//
// Revision 1.89  2008/02/20 17:22:59  lulin
// - �������� ������.
//
// Revision 1.88  2008/02/14 09:40:33  lulin
// - ����� �������� �����.
//
// Revision 1.87  2008/02/13 20:20:06  lulin
// - <TDN>: 73.
//
// Revision 1.86  2008/02/06 15:37:00  lulin
// - ������� �������� ������� �� ������������ ������.
//
// Revision 1.85  2008/02/05 15:19:25  voba
// - bug fix
//
// Revision 1.84  2008/02/05 09:58:00  lulin
// - �������� ������� ������� � ��������� ����� � ��������� �� �� ������.
//
// Revision 1.83  2008/02/01 15:14:44  lulin
// - ����������� �� �������� ��������������� �������.
//
// Revision 1.82  2008/01/10 16:50:53  lulin
// - cleanup.
//
// Revision 1.81  2007/09/07 14:47:41  lulin
// - ��������� �������� ���������� �������� ������.
//
// Revision 1.80  2007/08/14 19:31:52  lulin
// - ������������ ������� ������.
//
// Revision 1.79  2006/12/29 13:09:25  lulin
// - ��������� ��������� ������������ ������ �����.
//
// Revision 1.78  2006/11/25 14:36:22  lulin
// - cleanup.
//
// Revision 1.77  2006/05/10 06:03:00  oman
// - fix: �� ���������������. ������������ ����� ��� TddTableCell.Add(TObject(...))
//
// Revision 1.76  2006/05/06 13:31:05  lulin
// - cleanup.
//
// Revision 1.75  2006/01/05 15:02:45  narry
// - �����: ������ ������������ �� ����������� ����� (�� ������ ���������)
//
// Revision 1.74  2005/07/18 06:43:51  mmorozov
// - warning fix;
//
// Revision 1.73  2005/05/06 08:40:11  fireton
// - ����� ������� � resourcestring (��� ����, ����� ���������� ����� ����)
//
// Revision 1.72  2005/04/19 15:41:42  lulin
// - ��������� �� "����������" ProcessMessages.
//
// Revision 1.71  2005/03/28 14:30:04  lulin
// - �� ������ ����������� ��������� � ����������.
//
// Revision 1.70  2004/09/21 12:21:05  lulin
// - Release ������� �� Cleanup.
//
// Revision 1.69  2004/09/15 11:09:25  lulin
// - Tl3Stream ��������� �� "������" l3Unknown.
//
// Revision 1.68  2004/06/01 16:51:23  law
// - ������ ����������� Tl3VList.MakePersistent - ����������� _Tl3ObjectRefList.
//
// Revision 1.67  2004/04/14 14:59:14  law
// - rename proc: ev_lPAnsiCharSetPresent -> l3CharSetPresent.
//
// Revision 1.66  2004/04/05 11:41:24  narry
// - cleanup
//
// Revision 1.65  2004/04/05 11:15:05  narry
// - update: ��������� ���������� ������������� ���������� ����������� ����������
//
// Revision 1.64  2004/01/16 10:09:48  narry
// - update: �������������� ������� � �������
//
// Revision 1.63  2003/05/15 11:45:13  narry
// - add: ��������� ���������
//
// Revision 1.62  2003/05/13 13:42:15  narry
// no message
//
// Revision 1.61  2003/04/30 12:42:05  narry
// - add: ��������� rtfTwip
// - change: ������ 1440 �� rtfTwip
//
// Revision 1.60  2003/04/19 12:30:38  law
// - new file: ddDefine.inc.
//
// Revision 1.59  2003/01/08 11:14:52  narry
// - bug fix: ����� � ������� � ������� �������
//
// Revision 1.58  2002/11/14 12:47:42  narry
// - bug fix: ������������� ����������� � ������ ������ "������ ����. �����������" � "����������� ����. �����������" �������� � ������������ ������ ������ - ������ ��������������� ������� Microsoft Word � RTF
//
// Revision 1.57  2002/09/09 13:52:19  narry
// - cleanup
//
// Revision 1.56  2002/08/02 08:33:43  narry
// - bug fix: ���������� ������ ������� �� \field
//
// Revision 1.55  2002/08/01 10:26:09  narry
// - bug fix: ��������� �������� � ��������
//
// Revision 1.54  2002/07/30 15:58:16  narry
// - new behavior: ��������� Strikeout
//
// Revision 1.53  2002/07/03 09:00:57  narry
// - update, cleanup � new behavior
//
// Revision 1.52.2.1  2002/07/02 14:30:45  narry
// - alpha release
//
// Revision 1.52  2002/06/05 13:22:59  narry
// - update: ������ ���������� ��������� �����
//
// Revision 1.51  2002/04/23 08:02:59  narry
// - update
//
// Revision 1.50  2001/11/22 13:58:43  narry
// - update : ������ ���������� ����� �������
//
// Revision 1.49  2001/10/15 08:21:26  narry
// - new behavior: ���������� "." � ������ ��������, ������������ superscript
//
// Revision 1.48  2001/10/08 11:24:28  narry
// - bug fix: ���������� �������� �� Nil ������� ����� ������� ��� �������
//
// Revision 1.47  2001/09/12 14:46:10  narry
// - bug fix: ������ ��������� � Lite ������
//
// Revision 1.46  2001/08/29 07:01:06  law
// - split unit: l3Intf -> l3BaseStream, l3BaseDraw, l3InterfacedComponent.
//
// Revision 1.45  2001/06/27 13:30:10  narry
// -bug fix: ��� ������� � ��������� �����, ����� ��� �������� ����������
//         ��������������� �������
//
// Revision 1.44  2001/06/04 13:57:23  narry
// - bug fix - �������� �������� ������� �������� � ������ ������� Finish
//
// Revision 1.43  2001/06/04 13:02:56  narry
// -bug fix - �������� �������� ������� �� ��������� ��������
//
// Revision 1.42  2001/05/31 15:18:25  narry
// Update - ��������� ���������� ����� � �������
//
// Revision 1.41  2001/05/31 11:49:16  narry
// Update - ������� ����� ��� �������
//
// Revision 1.40  2001/05/31 10:40:57  narry
// Update - ���������� ����� ������ ������ ���� �������
//
// Revision 1.39  2001/05/29 12:47:53  narry
// Update - �������� ���������� ����� ������ �� ��� �����
//
// Revision 1.38  2001/05/28 15:36:46  narry
// Update - ������ ���������� �����
//
// Revision 1.37  2001/05/16 10:49:00  narry
// Update - ������ ���������� ���������� ������
//
// Revision 1.36  2001/05/10 14:20:49  narry
// Update - ������ ���������� ������
//
// Revision 1.35  2001/04/27 09:21:51  narry
// Update - ��������� ������ �������
//
// Revision 1.34  2001/04/25 07:18:02  narry
// Update - ��������� �������� �� ������-������ ������ ������� � ���
//
// Revision 1.33  2001/04/12 12:58:49  narry
// Update - ������-������ ���������� ������ � ���
//
// Revision 1.32  2001/04/11 12:29:58  narry
// Update - ������������� �������������� ������������ ������ ��� ������ �� RTF
//
// Revision 1.31  2001/04/09 14:03:59  narry
// update - ��������� ��������� ��������� ���������� ������
// ��� ������ RTF-������. ������������ � ���� �������� ���������
// �������������� ������������� ������
//
// Revision 1.30  2001/03/15 12:12:44  narry
// ���������� ������ �������� �� RTF � ������ Lite
//
// Revision 1.29  2001/02/27 09:01:57  narry
// Fix - add empty paragraph in table cell
//
// Revision 1.28  2001/01/29 07:55:10  narry
// fix - lost paragraphs on section (page) break
//
// Revision 1.27  2001/01/25 14:45:08  narry
// Add section break parameters
//
// Revision 1.26  2001/01/25 12:08:11  narry
// Fix   - possible lost text
// Add - simple read section break
//
// Revision 1.25  2001/01/25 09:08:06  narry
// Fix - wrong page width, lost character format
// Add - write page break
//
// Revision 1.24  2001/01/19 12:26:03  narry
// Fix trouble with broken documents
//
// Revision 1.23  2001/01/18 12:58:07  narry
// dead tables fix
//
// Revision 1.22  2001/01/17 14:26:15  narry
// Bug fix with tables - unnecesssary paragraphs and format
//
// Revision 1.21  2000/12/18 11:40:09  narry
// small bug fix with picture
//
// Revision 1.20  2000/12/15 15:29:55  law
// - ��������� ��������� Log � Id.
//

{$I ddDefine.inc }
{$DEFINE SaveTableProperty}
{.$DEFINE OnePass}
{.$DEFINE Border4Table}

interface


Uses
  Classes,
  l3Base, l3Types, l3Memory,
  k2Interfaces,
  k2TagGen,
  RTFTypes, ddLowLevelRTF, ddRTFProperties, ddBase,
  l3ObjectRefList,
  l3StringList,
  l3SimpleObjectRefList,
  ddRTFDestination, ddRTFKeywords,

  l3ProtoPersistentRefList
  , rtfListTable, ddRTFState, Graphics, ddCharacterProperty,
  ddParagraphProperty, ddDocumentAtom;

type
  TddRTFReader = class(TddRTFParser)
 private
    f_CheckDest     : Boolean;
    f_Destinations  : array[TRDS] of TddRTFDestination;
    f_DocIsDone     : Bool;
    f_DontSkipNext  : Boolean;
    f_DOP: TddDocumentProperty;
    f_EnablePictures: Boolean;
    f_FullCycle     : Boolean;
    f_Info          : TddRTFInfo;
    f_LastRDS       : TRDS;
    f_ListTable     : TrtfListTable;
    f_OverrideListTable: TrtfListOverrideTable;
    f_SkipNextGroup : Boolean;
    f_SkipPicture   : Boolean;
    f_SkipSkipable  : Boolean;
    f_States        : TrtfStateStack;
    procedure ApplyToCreateTime(What: Tiprop; Value: Longint);
    procedure ApplyToDOP(What: Tiprop; Value: Longint);
    procedure ApplyToFont(What: Tiprop; Value: Longint);
    procedure ApplyToInfo(What: Tiprop; Value: Longint);
    procedure ApplyToListTable(What: Tiprop; Value: Longint);
    procedure ApplyToRevisionTime(What: Tiprop; Value: Longint);
    procedure ApplyToStyleSheet(propType: TPropType; What: Tiprop; Value: Longint);
    procedure Close_rdsField(aOldDest, aNewDest: TddRTFDestination);
    procedure Close_rdsFormFieldItem(aOldDest, aNewDest: TddRTFDestination);
    procedure Close_rdsLevelText(aOldDest, aNewDest: TddRTFDestination);
    procedure Close_rdsList(aOldDest, aNewDest: TddRTFDestination);
    procedure Close_rdsPicture(aOldDest, aNewDest: TddRTFDestination);
    function ListByID(aID: Integer): TrtfList;
    procedure Close_rdsListLevel(aOldDest, aNewDest: TddRTFDestination);
    procedure Close_rdsListOverride(aOldDest, aNewDest: TddRTFDestination);
    procedure Close_rdsStyleSheet(aOldDest, aNewDest: TddRTFDestination);
    function GetFonts(ID: Integer): TddFontEntry;
    function pm_GetSEP: TddSectionProperty;
    function pm_GetSkipGroup: Boolean;
    function pm_GetState: TddRTFState;
    procedure pm_SetSEP(const Value: TddSectionProperty);
    procedure StartSkipGroup;
    procedure StopSkipGroup;
 protected
    procedure PushState; override;
    procedure AddKeyword(aKeyword: TSYM; aHasParam: Boolean; aParam: Long; aText: Tl3String = nil);
        override;
    procedure AddText(aText: AnsiChar); overload;  override;
    procedure AddText(aText: Tl3String); overload;  override;
    procedure AddText(aText: Word); overload;  override;
    procedure ChangeDest(aNewRDS: TRDS);
    procedure Cleanup; override;
    procedure PopState; override;
    function ColorByIndex(Index: Longint): TColor;
    procedure ConvertHex2Text;
    procedure ecPopRtfState;
    procedure ecPushRtfState;
    function GetBOP: TddBorder;
    function GeTChP: TddCharacterProperty;
    function GetDestination(aRDS: TRDS): TddRTFDestination;
    function GeTPaP: TddParagraphProperty;
    function GetRDS: TRDS;
    function GetTAP: TddRowProperty;
        {-}
    procedure OpenStream; override;
    procedure ParseProperty(propType: TPropType; What: Tiprop; Value: Longint);
    procedure ParseSymbol(Symbol: Long; propType: TPropType);
    procedure SetBOP(Value: TddBorder);
    procedure SeTChP(Value: TddCharacterProperty);
    procedure SeTPaP(Value: TddParagraphProperty);
    procedure SetRDS(Value: TRDS);
    procedure SetTAP(Value: TddRowProperty);
    function StyleByNumber(Number: Integer): TddStyleEntry;
    procedure TranslateKeyword(aKeyword: TSYM; aHasParam: Boolean; aParam: Long);
    procedure Write2Generator;
    procedure WriteText(aText: Tl3String); overload;
    property BOP : TddBorder
      read GetBOP write SetBOP;
    property CHP : TddCharacterProperty
      read GeTCHP write SeTChP;
    property Destination[aRDS: TRDS]: TddRTFDestination
      read GetDestination;
    property PAP : TddParagraphProperty
      read GeTPaP write SeTPaP;
    property RDS: TRds
      read GetRDS write SetRDS;
    property SEP: TddSectionProperty read pm_GetSEP write pm_SetSEP;
    property TAP : TddRowProperty
      read GetTAP write SetTAP;
 public
    constructor Create(aOwner: Tk2TagGeneratorOwner); override;
    procedure AddData(aStream: TStream); override;
    procedure Read; override;
    property DOP: TddDocumentProperty read f_DOP write f_DOP;
    property FullCycle: Boolean
      read f_FullCycle write f_FullCycle;
    property SkipGroup: Boolean read pm_GetSkipGroup;
    property SkipSkipable  : Boolean
      read f_SkipSkipable write f_SkipSkipable;
    property State: TddRTFState read pm_GetState;
  published
    property EnablePictures: Boolean read f_EnablePictures write f_EnablePictures;
  end;


implementation

Uses
  SysUtils, Forms, 

  l3Chars, l3String,

  afwFacade,

  k2Tags,
  evSegLst, l3Math, evConst, evdStyles, l3StringEx,// Unicode,
  ddRTFObjects, ddRTFConst

  {$IfNDef l3ConsoleApp},Dialogs{$ENDIF}
  , StrUtils, Windows,

  Document_Const,
  Table_Const,
  TextPara_Const
  , TypInfo, l3ObjectRefList1, Math, l3Interfaces, k2Prim, dd_rtfFields,
  ddTextSegment;

resourcestring
 SRTFBadStruct = '�������� ��������� �����';


constructor TddRTFReader.Create(aOwner: Tk2TagGeneratorOwner);
var
 l_State : TddRTFState;
begin
  inherited;
  f_Info  := TddRTFInfo.Create(nil);
  f_ListTable:= TrtfListTable.make;
  f_OverrideListTable:= TrtfListOverrideTable.Make;
  l3FillChar(f_Destinations, SizeOf(f_Destinations), 0);
  f_States:= TrtfStateStack.Make;
  l_State:= TddRTFState.Create;
  try
   f_States.Add(l_State);
  finally
   FreeAndNil(l_State);
  end;
  //f_SkipSkipable:= True;
  f_FullCycle:= True;
  f_EnablePictures:= False;
 f_DOP := TddDocumentProperty.Create(nil);
end;

procedure TddRTFReader.AddData(aStream: TStream);
begin
 if (RDS = rdsPicture) {and (f_PictureEntry <> nil)} and f_EnablePictures then
  TdestPicture(Destination[RDS]).Picture.AddHexStream(aStream);
end;

procedure TddRTFReader.PushState;
begin
 if not f_DocIsDone then
 begin
  ecPushRTFState;
  if f_SkipNextGroup then
  begin
   StartSkipGroup;
   f_SkipNextGroup:= False;
  end;
  f_CheckDest:= True;
 end; 
end;

procedure TddRTFReader.AddKeyword(aKeyword: TSYM; aHasParam: Boolean; aParam: Long; aText:
    Tl3String = nil);
begin
 if not f_DocIsDone then
 begin
  if  (RDS = rdsSkip) and f_SkipSkipable then
   //  ���������� ��� ������
   StartSkipGroup
  else
   TranslateKeyword(aKeyword, aHasParam, aParam);
 end;
end;

procedure TddRTFReader.AddText(aText: AnsiChar);
begin
 if not SkipGroup  then
 begin
  Destination[RDS].AddAnsiChar(aText, State);
  (*
    if l_Dest.UnicodeBuffer.Position > 0 then
    begin
      if RDS in CollectibleRDS then
        l_Dest.FlushUnicodeBuffer(State)
      else
        l_Dest.Unicode2Text;
    end;
    ConvertSymbolChar(aText);
    l_Dest.TextBuffer.Append(aText);
   *)
   ReadData:= RDS = rdsPicture;
 end;
end;

procedure TddRTFReader.AddText(aText: Tl3String);
begin
 if not SkipGroup then
 begin
  Destination[RDS].AddString(aText, State);
  (*
    if l_Dest.UnicodeBuffer.Position > 0 then
    begin
      if RDS in CollectibleRDS then
        l_Dest.FlushUnicodeBuffer(State)
      else
        l_Dest.Unicode2Text;
    end;
    if RDS = rdsPicture then
    begin

     if f_EnablePictures then
      TdestPicture(destination[RDS]).Picture.AddText(aText);
    end
    else
    l_Dest.TextBuffer.JoinWith(aText);
   *)
  ReadData:= RDS = rdsPicture;
 end;
end;

procedure TddRTFReader.AddText(aText: Word);
begin
 if not SkipGroup then
 begin
    Destination[RDS].AddUnicodeChar(aText, State);
    (*
    if not l_Dest.TextBuffer.Empty then
    begin
      if RDS in CollectibleRDS then
        l_Dest.FlushTextBuffer(State)
      else
      begin
        WriteText(l_Dest.TextBuffer);
        l_Dest.TextBuffer.Clear;
      end;
    end;
    l_Dest.UnicodeBuffer.write(aText, SizeOf(aText));
    *)
 end;
end;

procedure TddRTFReader.ApplyToCreateTime(What: Tiprop; Value: Longint);
begin

 with f_Info.CreateTime do
 begin
   case What of
     ipropDay  : Day:= Value;
     ipropMonth: Month:= Value;
     ipropYear : Year:= Value;
     ipropHour : Hour:= Value;
     ipropMin  : Min:= Value;
   end; {case What}
 end; { with};
end;

procedure TddRTFReader.ApplyToDOP(What: Tiprop; Value: Longint);
begin
 with DOP do
 begin
  case What of
   iproPAnsiCharSet: CharSet:= TrtfCharacterSet(Value);
   ipropCodePage: CodePage:= Value;
   ipropWidth: xaPage:= Value;
   ipropHeight: YaPage:= Value;
   ipropLeft: xaLeft:= Value;
   ipropRight: xaRight:= Value;
   ipropTop: yaTop:= Value;
   ipropBottom: yaBottom:= Value;
   ipropDefLang: Deflang:= Value;
   ipropDefFont: DefFont:= Value;
   ipropDefTab: DefTab:= Value;

   ipropwidowctrl    : ;
   ipropftnbj        : ;
   ipropaenddoc      : ;
   ipropnoxlattoyen  : ;
   ipropexpshrtn     : ;
   ipropnoultrlspc   : ;
   ipropdntblnsbdb   : ;
   ipropnospaceforul : ;
   iprophyphcaps     : ;
   ipropformshade    : ;
   ipropviewkind     : ;
   ipropviewscale    : ;
   ipropviewzk       : ;
   iproppgbrdrhead   : ;
   iproppgbrdrfoot   : ;
   ipropfet          : ;
   ipropsectd        : ;
   iproplinex        : ;
   ipropendnhere     : ;

  end;
 end;
end;

procedure TddRTFReader.ApplyToFont(What: Tiprop; Value: Longint);
begin
 { TODO : ������ �� ���������� �� Destination }
end;

procedure TddRTFReader.ApplyToInfo(What: Tiprop; Value: Longint);
begin

 with f_Info do
 begin
   case What of
     ipropVersion  : Version:= Value;
     ipropedmins   : edmins:= Value;
     ipropnofpages : nofpages:= Value;
     ipropnofwords : nofwords:= Value;
     ipropnofchars : nofchars:= Value;
     ipropnofcharsws : nofcharsws:= Value;
     ipropVern     : InternalVersion:= Value;
   end; {case}
 end;
end;

procedure TddRTFReader.ApplyToListTable(What: Tiprop; Value: Longint);
var
 l_List: TrtfList;
 l_Level: TrtfListLevel;
begin
 l_List:= f_ListTable.Lists[f_ListTable.Hi];
 if not l_List.Empty then
  l_Level:= l_List.Levels[l_List.Hi]
 else
  l_Level:= nil;

 case What of
  iproplistid              : l_List.ID:= Value;
  iproplistoverridecount   : ;
  ipropListOverrideFormat  : ;
  iproplistrestarthdn      : ;
  iproplistsimple          : ;
  ipropliststyleid         : ;
  iproplistTemplateID      : l_List.TemplateID:= Value;
  iproplevelpicturenosize	 : ;
  iproplisthybrid          : ;//l_ListIndex].Hybrid:= True;
  iproplistoverridestartat : ;
  iproplevelfollow         : l_Level.Follow:= Value;
  iproplevelindent         : {l_Level.Indent:= Value};
  ipropleveljc             : l_Level.Justify:= Value;
  ipropleveljcn            : ;
  iproplevellegal          : ;
  iproplevelnfc            : l_Level.NumberType:= Value;
  iproplevelnfcn           : ;
  iproplevelnorestart      : ;
  iproplevelold            : ;
  iproplevelpicture        : ;
  iproplevelprev           : ;
  iproplevelprevspace      : ;
  iproplevelspace          : ;
  iproplevelstartat        : l_Level.StartAt:= Value;
 end;
end;

procedure TddRTFReader.ApplyToRevisionTime(What: Tiprop; Value: Longint);
begin
 with f_Info.RevisionTime do
 begin
   case What of
     ipropDay  : Day:= Value;
     ipropMonth: Month:= Value;
     ipropYear : Year:= Value;
     ipropHour : Hour:= Value;
     ipropMin  : Min:= Value;
   end; {case What}
 end; { with};
end;

procedure TddRTFReader.ApplyToStyleSheet(propType: TPropType; What: Tiprop; Value: Longint);
begin
 TdestStyleSheet(Destination[rdsStyleSheet]).ApplyProperty(propType, What, Value, State);
 if What = iproPAnsiCharStyle then
  StopSkipGroup;
end;

procedure TddRTFReader.ChangeDest(aNewRDS: TRDS);
var
 l_List: TrtfList;
 l_ListLevel: TrtfListLevel;
 l_ListOverride: TrtfListOverride;
begin
 // �������
 {$IFDEF Write2Log}
 l3System.Str2Log(Format('Change destination %s -> %s', [GetEnumName(TypeInfo(TRDS), Ord(RDS)), GetEnumName(TypeInfo(TRDS), Ord(aNewRDS))]));
 {$ENDIF}

  Status:= ecOk;
  if (RDS in CollectibleRDS) and not (aNewRDS in CollectibleRDS) then
   f_LastRDS:= RDS;  // ������, ��� �� �����

  if SkipGroup then
   if (aNewRDS <> rdsSkip){ or not f_SkipSkipable} then
    StopSkipGroup
   else
   if (aNewRDS = rdsSkip){ and f_SkipSkipable} then
    StartSkipGroup;
  if f_DontSkipNext then
  begin
    aNewRDS:= RDS;
    f_DontSkipNext:= False;
  end;
  (*
  { TODO : ������������ (��������� � TdestNorm) }
  try
    if (RDS in CollectibleRDS) and (RDS <> aNewRDS) and Destination[RDS].LastParagraph.Empty{<= ���������, ������ ��� ���� ���������? } then
    begin
      if Destination[RDS].LastParagraph.DeleteLastSegment then
      // Destination[RDS].StandingList.DeleteLast; { TODO : ����� ��������� ���������? }
    end;
  except
   on E: Exception do
    l3System.Exception2Log(E);
  end;
  *)
  case aNewRDS of
   rdsPicture:
    if (RDS <> rdsPicture) and (RDS <> rdsPictureProp) then
    begin
     (*
     if (f_PictureEntry <> nil) then
      FreeAndNil(f_PictureEntry); { ��� ��������. ���������, ��������� ��� ��������? }
     f_PictureEntry:= TddPicture.Create(nil);
     //f_PictureEntry.PAP.Assign(PAP);{ TODO : ������������ (��������� � TdestNorm) }
     *)
    end;
   (* ��������� ������ ���������� �� destination
   rdsList:
    begin
     l_list:= TrtfList.Create();
     try
      f_ListTable.Add(l_List);
     finally
      FreeAndNil(l_List);
     end;
    end;
   rdsListLevel:
    begin
     l_ListLevel:= TrtfListLevel.Create;
     try
      f_ListTable.Lists[f_ListTable.Hi].Add(l_ListLevel);
     finally
      FreeAndNil(l_ListLevel);
     end;
    end;
   rdslistoverride:
    begin
     l_ListOverride:= TrtfListOverride.Create;
     try
      f_OverrideListTable.Add(l_ListOverride);
     finally
      FreeAndNil(l_ListOverride);
     end;
    end;
   *) 
  end; // case aNewRDS
  if ((rds = rdsStyleSheet) and (aNewRDS = rdsSkip)) {or ((aNewRDS = rdsStyleSheet) and (rds = rdsSkip))} then
    StopSkipGroup
  else
    RDS:= aNewRDS;
end;

procedure TddRTFReader.Cleanup;
var
 i: TRDS;
begin
 for i:= Low(TRDS) to High(TRDS) do
  FreeAndNil(f_Destinations[i]);
 FreeAndNil(f_DOP);
 FreeAndNil(f_States);
 FreeAndNil(f_Info);
 FreeAndNil(f_ListTable);
 FreeAndNil(f_OverrideListTable);
 inherited;
end;

procedure TddRTFReader.Close_rdsField(aOldDest, aNewDest: TddRTFDestination);
var
 l_FieldResult: AnsiString;
begin
 if (aNewDest is TdestNorm) then
 begin
  with TdestFieldInstruction(Destination[rdsFieldInstruction]) do
  begin
   Instruction2Result;
   l_FieldResult:= FieldResult;
  end; // with TdestFieldInstruction(Destination[rdsFieldInstruction])
  case TdestFieldInstruction(Destination[rdsFieldInstruction]).FieldType of
   dd_fieldUnknown   : ;
   dd_fieldHyperlink : ;
   dd_fieldSymbol    : ;
   dd_fieldForm      :
    begin
     l_FieldResult:= TdestFormField(Destination[rdsFormField]).GetFormResult;
    end;
  end;

   
  if l_FieldResult <> '' then
   TdestFieldResult(Destination[rdsFieldResult]).FieldResult:= l_FieldResult;
  TdestNorm(aNewDest).Append(TdestFieldResult(Destination[rdsFieldResult]), True);
 end;
 Destination[rdsFieldInstruction].Clear;
 Destination[rdsFieldResult].Clear;
 Destination[rdsFormField].Clear;
 TdestNorm(Destination[rdsFieldResult]).Paragraphs.Clear;
  (* ������ �����
  f_FieldEntry.Instruction2Result;
  Destination[newRDS].WriteText(f_FieldEntry.FieldResult, State);
  f_FieldEntry.Clear;
  if not (newRDS in [rdsField, rdsFieldInstruction, rdsFieldResult]) then
   FreeAndNil(f_FieldEntry);
  *);
end;

procedure TddRTFReader.Close_rdsFormFieldItem(aOldDest, aNewDest:
    TddRTFDestination);
begin
 TdestFormField(aNewDest).AddItem(TdestFormFieldItem(aOldDest).Item);
 aOldDest.Clear;
end;

procedure TddRTFReader.Close_rdsLevelText(aOldDest, aNewDest:
    TddRTFDestination);
begin
 if aNewDest.RDS = rdsListLevel then
 begin
  TdestListLevel(aNewDest).Level.Text:= TdestLevelText(aOldDest).Text;
  TdestListLevel(aNewDest).Level.Numbers:= TdestLevelText(aOldDest).Numbers;
 end; // aNewDest.RDS = rdsListLevel
 aOldDest.clear;
end;

procedure TddRTFReader.Close_rdsList(aOldDest, aNewDest: TddRTFDestination);
begin
 if (aNewDest.RDS = rdsListTable) then
 begin
  TdestListTable(aNewDest).AddList(TdestList(aOldDest));
  aOldDest.clear;
 end;
end;

procedure TddRTFReader.Close_rdsPicture(aOldDest, aNewDest: TddRTFDestination);
begin
 if not f_SkipPicture and (TdestPicture(aOldDest).Picture.Format > 0) and f_EnablePictures then
 begin
  if aNewDest is TdestNorm then
   TdestNorm(aNewDest).AddPicture(TdestPicture(aOldDest).Picture, State);
 end;
 f_SkipPicture:= False;
 aOldDest.clear;
end;

procedure TddRTFReader.PopState;
begin
 if not f_DocIsDone then
  ecPopRTFState;
end;

function TddRTFReader.ColorByIndex(Index: Longint): TColor;
begin
 Result:= TdestColorTable(Destination[rdsColorTable]).ColorByIndex(Index);
end;

procedure TddRTFReader.ConvertHex2Text;
begin
 if Content <> nil then
  Content.ConvertHex2Text;
end;

procedure TddRTFReader.ecPopRtfState;
{ ����������� ������� ������, ���������� ���������� ��������� �� ����� }
var
 oldRDS, newRDS : TRDS;
 l_OldDest, l_NewDest: TddRTFDestination;
begin
 try
  oldRDS:= RDS;
  l_OldDest:= Destination[oldRDS];
  if f_States.Count > 0 then
   newRDS:= TddRTFState(F_States.Items[Pred(F_States.Hi)]).RDS
  else
   newRDS:= rdsNone;
  l_NewDest:= Destination[newRDS];
  {$IFDEF Write2Log}
  l3System.Str2Log(Format('Change destination %s -> %s', [GetEnumName(TypeInfo(TRDS), Ord(oldRDS)), GetEnumName(TypeInfo(TRDS), Ord(newRDS))]));
  {$ENDIF}
  case oldRDS of
   rdsPicture      : Close_rdsPicture(l_OldDest, l_NewDest);
   rdsListLevel    : Close_rdsListLevel(l_OldDest, l_NewDest);
   rdsList         : Close_rdsList(l_OldDest, l_NewDest);
   rdsListOverride : Close_rdsListOverride(l_OldDest, l_NewDest);
   rdsLevelText    : Close_rdsLevelText(l_OldDest, l_NewDest);
   rdsField        : Close_rdsField(l_OldDest, l_NewDest);
   rdsFormFieldItem: Close_rdsFormFieldItem(l_OldDest, l_NewDest);
   rdsStyleSheet   : Close_rdsStyleSheet(l_OldDest, l_NewDest);
  end;

  if (oldRDS = newRDS) and (RDS in CollectibleRDS) then
  begin
   if l_OldDest is TdestNorm then
    with TdestNorm(l_OldDest) do
    begin
     if not BufferEmpty then
     begin
      CorrectCharset(CHP, TextBuffer);
      FlushTextBuffer(State);
     end
     else
     if (LastParagraph <> nil) then
      LastParagraph.ApplyCHP(CHP);
    end;
  end{
    else
    if (newRDS <> rdsNone) and
       (oldRDS <> newRDS) and
       (oldRDS in CollectibleRDS) and
       (oldRDS <> rdsFootnote) then
    begin
     // ����� ���?
     Destination[newRDS].Append(l_OldDest);
     l_OldDest.Paragraphs.Clear;
    end};


    (* ����� ��������� ��� ��� ������ ��������
    if (oldRDS = rdsFootnote) and (newRDS <> rdsFootnote) then
    begin
      l_OldDest.CheckLastParagraph(True);
    end;
    *)

    if l_OldDest is TdestNorm then
     if not TdestNorm(l_OldDest).BufferEmpty then
     begin
       // ����������� ��������� ��� �� TdestNorm
       if TdestNorm(l_OldDest).TextBuffer.Empty then
         TdestNorm(l_OldDest).Unicode2Text;
       WriteText(TdestNorm(l_OldDest).TextBuffer);
       TdestNorm(l_OldDest).TextBuffer.Clear;
     end;
   // l_OldDest.clear; <- ������� ����� � ����� �������������
    { ������������ �� ����� RDS }
    f_States.DeleteLast;
    //l3System.Msg2Log('%s -> %s', [GetEnumName(TypeInfo(TRDS), Ord(oldRDS)), GetEnumName(TypeInfo(TRDS), Ord(newRDS))]);

    if (oldRDS = rdsNorm) and (RDS = rdsNone) then
    begin   {  ��������� ����������� ������ - ����� � ����� ����� ����� }
      f_DocIsDone:= True;
    end;


    (*{ TODO : ������������ (��������� � TdestNorm) }
    if (oldRDS in [rdsListText]) and (newRDS = rdsNorm) then
    begin
     Destination[newRDS].LastParagraph.JoinWith(Destination[oldRDS].LastParagraph);
     Destination[oldRDS].LastParagraph.Clear;
    end;
    *)
 except
  l3System.Msg2Log(SRTFBadStruct);
 end;
 ReadData := RDS = rdsPicture;
 SkipData:=  ReadData and (LiteVersion and not f_EnablePictures);
end;

procedure TddRTFReader.ecPushRtfState;
  { �������� ����� ������, ���������� ������� ��������� � ���� }
begin
 f_States.Push;

 if (RDS = rdsStyleSheet)  then
  TdestStyleSheet(Destination[rdsStyleSheet]).AddStyle;
 (*
 if RDS in CollectibleRDS then
 begin
  Destination[RDS].LastParagraph.ApplyCHP(CHP);
  Destination[RDS].LastParagraph.AddSegment(CHP);
 end;
 *)
 ReadData := RDS = rdsPicture;
 SkipData:= ReadData and (LiteVersion and not f_EnablePictures);
end;

function TddRTFReader.GetBOP: TddBorder;
begin
  Result:= State.BOP;
end;

function TddRTFReader.GeTChP: TddCharacterProperty;
begin
 Result:= State.CHP;
end;

function TddRTFReader.GetDestination(aRDS: TRDS): TddRTFDestination;
var
  l_Dest: TddRTFDestination;
begin
 Result:= f_Destinations[aRDS];
 if Result = nil then
 begin
  case aRDS of
   rdsFontTable: l_Dest:= TdestFontTable.Create;
   rdsStyleSheet: l_Dest:= TdestStyleSheet.Create;
   rdsFootnote: l_Dest:= TdestFootnote.Create;
   rdsShpInst,
   rdsShpRslt,
   rdsShp,
   rdsNorm:
    begin
     l_Dest:= TdestNorm.Create;
     TdestNorm(l_Dest).OnGetColor:= ColorByIndex;
     TdestNorm(l_Dest).OnGetList:= ListByID;
     TdestNorm(l_Dest).OnGetStyle:= StyleByNumber;
     TdestNorm(l_Dest).OnGetFontEvent:= GetFonts;
    end; // rdsNorm
   rdsColorTable: l_Dest:= TdestColorTable.Create;
   rdsPicture: l_Dest:= TdestPicture.Create;
   rdsListTable: l_Dest:= TdestListTable.Create;
   rdsList: l_Dest:= TdestList.Create;
   rdsListLevel: l_Dest:= TdestListLevel.Create;
   rdsLevelText: l_Dest:= TdestLevelText.Create;
   rdslistoverride: l_Dest:= TdestListoverride.Create;
   rdslistoverridetable: l_Dest:= TdestListOverrideTable.Create;
   rdsField: l_Dest:= TdestField.Create;
   rdsFieldInstruction: l_Dest:= TdestFieldInstruction.Create;
   rdsFieldResult: l_Dest:= TdestFieldResult.Create;
   rdsFormField: l_Dest:= TdestFormField.Create;
   rdsFormFieldItem: l_Dest:= TdestFormFieldItem.Create;
  else
   l_Dest:= TdestSkip.Create;
  end; //case RDS
  l_Dest.LiteVersion:= LiteVersion;
  l_Dest.RDS:= aRDS;
  f_Destinations[aRDS]:= l_Dest;
  Result:= l_Dest;
 end; // Result = nil
end;

function TddRTFReader.GetPAP: TddPAragraphProperty;
begin
  Result:= State.PAP;
end;

function TddRTFReader.GetRDS: TRDS;
begin
 Result:= State.RDS;
end;

function TddRTFReader.GetTAP: TddRowProperty;
begin
 Result:= State.TAP;
end;

function TddRTFReader.ListByID(aID: Integer): TrtfList;
var
 l_ListID: Integer;
begin
 //���� �������� ����� � ListOverrideTale, �� ���� ����� �������� �������� ����� ������
 l_ListID:= TdestListOverrideTable(Destination[rdsListOverrideTable]).LS2ListID(aID);
 Result := TdestListTable(Destination[rdsListTable])[l_ListID];
end;

procedure TddRTFReader.Close_rdsListLevel(aOldDest, aNewDest:
    TddRTFDestination);
begin
 if (aNewDest.RDS = rdsList) then
 begin
  TdestList(aNewDest).AddLevel(TdestListLevel(aOldDest));
  aOldDest.clear;
 end; 
end;

procedure TddRTFReader.Close_rdsListOverride(aOldDest, aNewDest:
    TddRTFDestination);
begin
 if (aNewDest.RDS = rdsListOverrideTable) then
  TdestListOverrideTable(aNewDest).AddListOverride(TdestListOverride(aOldDest));
 aOldDest.clear;
end;

procedure TddRTFReader.Close_rdsStyleSheet(aOldDest, aNewDest:
    TddRTFDestination);
begin
 if aOldDest = aNewDest then
  TdestStyleSheet(Destination[RDS]).CurStyle.CheckEvd;
end;

procedure TddRTFReader.OpenStream;
  {override;}
  {-}
begin
 inherited;
 f_DocIsDone:= False;
end;

procedure TddRTFReader.ParseProperty(propType: TPropType; What: Tiprop; Value: Longint);
begin
 { ������ ������ �������� }
 if propType = propDop then
  ApplyToDOP(What, Value)
 else
  Destination[RDS].ApplyProperty(propType, What, Value, State);
 if (propType = propPict) and (What = ipropSkipPicture) then
  f_SkipPicture:= True;

 (*
 case RDS of
   rdsNorm,
   rdsFootNote,
   rdsListText,
   rdsShpTxt    : ApplyToNormRDS(propType, What, Value);
   rdsPicture   : ApplyToPicture(What, Value);
   rdsFontTable : ApplyToFont(What, Value);
   rdsStyleSheet: ApplyToStyleSheet(What, Value);
   rdsColorTable: ApplyToColorTable(What, Value);
   rdsInfo      : ApplyToInfo(What, Value);
   rdsCreatim   : ApplyToCreateTime(What, Value);
   rdsRevtim    : ApplyToRevisionTime(What, Value);
   rdsFormField : ApplyToFormField(What, Value);
   rdsListTable,
   rdsListLevel,
   rdsList,
   rdslistoverride,
   rdslistoverridetable,
   rdslistpicture,
   rdsliststylename,
   rdsListName,
   rdsLevelNumbers : ApplyToListTable(What, Value);
 end; //case RDS
 *)                                                                                        
end;

procedure TddRTFReader.ParseSymbol(Symbol: Long; propType: TPropType);
begin
 if (Symbol = Ord(rdsSkipGroup)){ and f_SkipSkipable} then
  //  ���������� ��� ������
  StartSkipGroup
 else
 //if RDS in (CollectibleRDS+[rdsFieldResult]) then
  Destination[RDS].ParseSymbol(Symbol, propType, State);
end;

function TddRTFReader.GetFonts(ID: Integer): TddFontEntry;
begin
 Result:= TdestFontTable(Destination[rdsFontTable]).FontByNumber(ID);
end;

function TddRTFReader.pm_GetSEP: TddSectionProperty;
begin
 // TODO -cMM: TddRTFReader.pm_GetSEP default body inserted
 Result := nil;
end;

function TddRTFReader.pm_GetSkipGroup: Boolean;
begin
 Result := State.SkipGroup or f_DocIsDone;
end;

function TddRTFReader.pm_GetState: TddRTFState;
begin
 Result := f_States.Peek;
end;

procedure TddRTFReader.pm_SetSEP(const Value: TddSectionProperty);
begin
 // TODO -cMM: TddRTFReader.pm_SetSEP default body inserted
end;

procedure TddRTFReader.Read;
var
  l_i: TRDS;
begin
  RDS:= rdsNone;
  f_Info.Clear;
  //f_DOP.Clear;
  for l_i:= Low(TRDS) to High(TRDS) do
   FreeAndNil(f_Destinations[l_i]);
  gNextFootnoteNumber:= 0;

  f_CheckDest:= False;
  f_DocIsDone := False;
//  f_BorderOwner:= boPara;

  {$IFDEF OnePass}
  Generator.Start;
  Generator.StartChild(k2_idDocument);
  {$ENDIF}

  inherited;
  if Status = ecOk then
  begin
    (* { TODO : ������������ (��������� � TdestNorm) }
    for l_i:= Low(TRDS) to High(TRDS) do
    begin
     if f_Destinations[l_i] <> nil then
      TddRTFDestination(f_Destinations[l_i]).CheckLastParagraph;
    end;
    *)
    if FullCycle then
    begin
     Write2Generator;
    end;
    {$IFDEF OnePass}
    Generator.Finish;
    Generator.Finish;
    {$ENDIF}
  end;
end;

procedure TddRTFReader.SetBOP(Value: TddBorder);
begin
  State.BOP:= Value;
end;

procedure TddRTFReader.SeTChP(Value: TddCharacterProperty);
begin
 State.CHP:= Value;
end;

procedure TddRTFReader.SetPAP(Value: TddPAragraphProperty);
begin
  State.PAP:= Value;
end;

procedure TddRTFReader.SetRDS(Value: TRDS);
begin
 State.RDS:= Value;
end;

procedure TddRTFReader.SetTAP(Value: TddRowProperty);
begin
 State.TAP:= Value;
end;

procedure TddRTFReader.StartSkipGroup;
begin
 State.SkipGroup:= True;
end;

procedure TddRTFReader.StopSkipGroup;
begin
 State.SkipGroup:= False;
end;

function TddRTFReader.StyleByNumber(Number: Integer): TddStyleEntry;
var
  i: Integer;
begin
 Result:= TdestStyleSheet(Destination[rdsStyleSheet]).StyleByNumber(Number);
end;

procedure TddRTFReader.TranslateKeyword(aKeyword: TSYM; aHasParam: Boolean; aParam: Long);
var
  l_Enable: Boolean;
  l_Dest: TddRTFDestination;
begin
 if {(aKeyword <> key_Unknown) and} (not f_DocIsDone) then
 begin
  l_Dest:= Destination[RDS];
  if not (SkipNext {or (SkipGroup and SkipSkipable)}) then
  begin
   if l_Dest is TdestNorm then
     if (not TdestNorm(l_Dest).BufferEmpty) and (aKeyword.StringID <> valu_Hex) and (aKeyword.StringID <> valu_u) then
     begin
      { TODO : ��������� �� TdestNorm }
       if TdestNorm(l_Dest).TextBuffer.Empty then
         TdestNorm(l_Dest).Unicode2Text;
       WriteText(TdestNorm(l_Dest).TextBuffer);
       //l_Dest.Clear; ????
     end;
     case aKeyword.Kwd of
       kwdFlag: ParseProperty(aKeyword.propType, aKeyword.What, aKeyword.Value);
       kwdDest: ChangeDest(TRDS(aKeyword.Value));
       kwdSymb: ParseSymbol(aKeyword.Value, aKeyword.propType);
       kwdTogg: begin
                  l_Enable:= (not aHasParam) or (aHasParam and (aParam <> 0));
                  ParseProperty(aKeyword.propType, aKeyword.What, Ord(l_Enable));
                end;{kwdTogg}
       kwdValu:
         begin
           if aKeyword.StringID = valu_Hex then
             AddText(AnsiChar(aParam))
           else
           if aKeyword.StringID = valu_u then
           begin
            // ���������
            case aParam of
             8194: AddText(cc_SoftSpace);
             8722: AddText(cc_LargeDash);
            else
             AddText(Word(SmallInt(aParam)));
            end;
            SkipNext:= True;
           end
           else
             ParseProperty(aKeyword.propType, aKeyword.What, aParam);
         end;
     end; { case }
  end
  else
    SkipNext:= False;
 end;
end;

procedure TddRTFReader.Write2Generator;
var
  i, j, k, l: Long;
  l_P: TddDocumentAtom;
  l_Table: Boolean;
  l_Dest: TdestNorm;
  l_Style: TddStyleEntry;
  l_Seg: TddTextSegment;
  l_NullWidth: Boolean;
begin
 l_Table := False;
 {$IFNDEF OnePass}
 Generator.StartChild(k2_idDocument);
 try
   { ������� ���� �� ������ �����-������ ��������� ��������� - ������ ������,
     ���������� � ��. � ��. }
    { TODO : ������������ (��������� � TdestNorm) }
   if not LiteVersion then
   begin
    Generator.AddIntegerAtom(k2_tiWidth, l3MulDiv(DOP.xaPage, evInchMul, rtfTwip));
    Generator.AddIntegerAtom(k2_tiLeftIndent, l3MulDiv(DOP.xaLeft, evInchMul, rtfTwip));
    Generator.AddIntegerAtom(k2_tiRightIndent, l3MulDiv(DOP.xaRight, evInchMul, rtfTwip));
    // ����� ������ ������� ������?
   end;

 {$ENDIF}

  l_Dest:= TdestNorm(Destination[rdsNorm]);
  if  l_Dest <> nil then
   l_Dest.Write(Generator);

  l_Dest:= TdestNorm(Destination[rdsFootnote]);
  if  (l_Dest <> nil) and (l_Dest.Paragraphs.Count > 0) then
  begin
   l_Dest.write(Generator);

  end; { l_Dest <> nil }
 {$IFNDEF OnePass}
 finally
   Generator.Finish;
 end;
 {$ENDIF}
end;

procedure TddRTFReader.WriteText(aText: Tl3String);
var
  l_Dest: TddRTFDestination;
begin
 {$IFDEF Write2Log}
 l3System.Msg2Log('Reader.WriteText: %s', [atext.AsString]);
 {$ENDIF}
  case RDS of
    rdsNorm,
    rdsHeader,
    rdsFooter,
    rdsFootnote,
    rdsListText,
    rdsShpTxt :
      if Destination[RDS] is TdestNorm then
      begin
       { ��� ������� ���� �� ������ ����� ����� ����� ���������}
       l_Dest:= Destination[RDS];
       if TdestNorm(l_Dest).UnicodeBuffer.Position > 0 then
        TdestNorm(l_Dest).FlushUnicodeBuffer(State)
       else
        TdestNorm(l_Dest).WriteText(aText, State);
      end;
    rdsFontTable :
      begin
       TdestFontTable(Destination[rdsFontTable]).CurFont.JoinWith(aText);
       (*
        if f_FontEntry <> nil then
        begin
          f_FontEntry.JoinWith(aText);
          if f_FontEntry.Ch[f_FontEntry.Len-1] = ';' then
          begin
            f_FontEntry.Delete(Pred(f_FontEntry.Len), 1);
            f_FontTable.Add(f_FontEntry);
            FreeAndNil(f_FontEntry);
          end;
        end;
       *)
      end;
    rdsPanose :
      begin
       TdestFontTable(Destination[rdsFontTable]).CurFont.Panose.JoinWith(aText);
      end;
    rdsFalt :
      begin
       TdestFontTable(Destination[rdsFontTable]).CurFont.Alternate.JoinWith(aText);
      end;
    rdsColorTable :
      begin
       Destination[RDS].WriteText(aText, State);
       (*
        if f_ColorEntry <> nil then
        begin
          f_ColorTable.Add(f_ColorEntry);
          FreeAndNil(f_ColorEntry);
        end;
       *)
      end;
    rdsStyleSheet:
      begin
       TdestStyleSheet(Destination[rdsStyleSheet]).WriteText(aText, State);
      end; { rdsStyleSheet }
    rdsInfo :
      begin

      end; {  rdsInfo}
    rdsTitle   : f_Info.Title.JoinWith(aText);
    rdsAuthor  : f_Info.Author.JoinWith(aText);
    rdsOperator: f_Info.Operator.JoinWith(aText);
    rdsCompany : f_Info.Company.JoinWith(aText);
    rdsPicture :
      begin
       { ����� ���, ��� ��������� �������� ����� ������ � ���� �� ���������}
       Assert(False, '���������� �������� �� ���������� �����');
       with TdestPicture(Destination[RDS]) do
       begin
        Picture.Picture.Assign(aText);
        Picture.PAP.Assign(PAP);
        if not f_SkipPicture and (Picture.Format > 0) and f_EnablePictures then
         TdestNorm(Destination[rdsNorm]).AddPicture(Picture, State);
        Picture.Clear;
       end;
       f_SkipPicture:= False;
      end;
    rdsFieldInstruction:
      begin
       Destination[rds].WriteText(atext, State);
       // if f_FieldEntry <> nil then
       //   f_FieldEntry.Instruction.JoinWith(aText);
      end;
    rdsFieldResult:
      begin
       Destination[rds].WriteText(atext, State);
        //if f_FieldEntry <> nil then
        //  f_FieldEntry.FieldResult.JoinWith(aText);
      end;
    rdsFormFieldItem:
      Destination[rds].WriteText(atext, State);
      //if f_FieldEntry <> nil then
      // f_FieldEntry.AddListItem(aText);

    rdsBookmarkStart:
     begin
      // ��� ���������� ����� ������������ ��� ����������� ����� ��� ������ �����
     end;
    rdsBookmarkEnd:
     begin
      // ��� ��������� �����
     end;
  end; { case RDS }
  //FreeAndNil(aText);
end;






end.

