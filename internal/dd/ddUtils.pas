//..........................................................................................................................................................................................................................................................
unit ddUtils;
{ ��������� ��������� � �������. � �������� ��������� � ���������������
  ������� � ����� ���� � ������ }


{ $Id: ddUtils.pas,v 1.74 2013/04/11 16:46:29 lulin Exp $ }

// $Log: ddUtils.pas,v $
// Revision 1.74  2013/04/11 16:46:29  lulin
// - ���������� ��� XE3.
//
// Revision 1.73  2013/04/05 12:04:30  lulin
// - ���������.
//
// Revision 1.72  2013/03/29 12:58:02  narry
// ������������ �����
//
// Revision 1.71  2013/03/28 10:19:14  narry
// UpperCaseFirstLetter ���������� ��� �������
//
// Revision 1.70  2012/11/19 06:45:20  narry
// ����������
//
// Revision 1.69  2012/11/16 06:22:59  narry
// �� �������� �����
//
// Revision 1.66  2012/06/27 08:16:03  narry
// ����������� �� ddZipUtils
//
// Revision 1.65  2012/06/27 07:43:25  narry
// ����������� �� ddZipUtils
//
// Revision 1.64  2012/06/26 13:57:05  narry
// ������� �������� ������������ ����
//
// Revision 1.63  2012/03/31 07:39:18  migel
// - fix: �� ���������������.
//
// Revision 1.62  2012/03/30 05:07:40  narry
// �� ����������
//
// Revision 1.61  2012/02/15 12:59:50  narry
// ����������
//
// Revision 1.60  2012/01/11 10:37:59  narry
// ������� Running32ON64
//
// Revision 1.59  2011/11/09 12:20:20  narry
// ���������� ����������� ����� (281514104)
//
// Revision 1.58  2011/11/07 09:08:12  narry
// �� �������� ������ ���������� (296632243)
//
// Revision 1.57  2011/10/17 10:08:47  narry
// ������������ ������ ���������� ��� ����������� (293276752)
//
// Revision 1.56  2011/06/15 08:22:19  narry
// �� ������ ������ ������ (15.06.2011)
//
// Revision 1.55  2011/04/11 10:25:01  narry
// �������� ��� ��� (259885290)
//
// Revision 1.54  2011/03/15 14:36:25  fireton
// - ��������� ��������� CalcElapsedTime
//
// Revision 1.53  2010/10/14 04:49:07  narry
// - �������� ������� IsRemote
// - ������ �����������
//
// Revision 1.52  2010/03/11 14:00:28  narry
// - ��������� "��������" �������������� ��������
//
// Revision 1.51  2010/03/11 09:16:02  lulin
// - bug fix: �� ���������� ������� F1.
//
// Revision 1.50  2010/03/10 13:57:24  narry
// - �� ����������
//
// Revision 1.49  2009/11/10 09:15:58  narry
// - ����������
//
// Revision 1.48  2009/04/16 11:48:20  fireton
// [$143396358]. ��������� base64 �� DD � L3
//
// Revision 1.47  2008/10/15 09:04:09  fireton
// - ������� ��� ������ � base64
//
// Revision 1.46  2008/08/20 10:09:54  narry
// - ��������� �������� ������� � RemoteDesktop
//
// Revision 1.45  2008/07/16 16:11:51  narry
// - ����� ������ ����������� ������� �����������
//
// Revision 1.44  2008/05/14 10:43:35  narry
// - ��������������� �������
//
// Revision 1.43  2008/03/13 14:46:40  narry
// - ������� ���������� ���������� ��� ������
//
// Revision 1.42  2008/03/04 11:42:06  narry
// - ����������� ������ � ValidFolder
//
// Revision 1.41  2008/02/27 15:49:40  narry
// - �� �������� ��������� ����
//
// Revision 1.40  2007/11/16 09:28:16  narry
// - ��������� �������� ����� �� �������������
//
// Revision 1.39  2007/09/28 05:37:16  narry
// - ����������
//
// Revision 1.38  2007/07/24 12:32:29  narry
// - ����������� ������� ���������
//
// Revision 1.37  2007/07/04 09:14:46  narry
// - ������� ��������� ���������� ������
//
// Revision 1.36  2007/04/18 11:35:46  narry
// - ������� �� Int64
//
// Revision 1.35  2007/01/29 12:20:24  narry
// - ����������
//
// Revision 1.34  2006/01/05 14:59:39  narry
// - �����: ��������� ������-������ ��������� ���������� ��������� � ����
//
// Revision 1.33  2005/10/04 11:43:50  narry
// - �����������: Range Check
//
// Revision 1.32  2005/02/18 16:59:35  narry
// - bug fix: ������������ ������� ������ � ������
//
// Revision 1.31  2005/02/16 17:10:41  narry
// - update: Delphi 2005
//
// Revision 1.30  2004/10/06 16:11:29  narry
// - update: ������ ���� �� ����
//
// Revision 1.29  2004/09/14 15:58:03  lulin
// - ������ ������ Str_Man - ����������� ������ ���� - l3String.
//
// Revision 1.28  2004/07/28 14:15:22  narry
// - update: ���������� ���������������� ������� Byte2Str
//
// Revision 1.27  2003/09/15 14:36:05  narry
// - update
//
// Revision 1.26  2003/07/18 14:00:14  narry
// - bug fix: ������� �������� ������� �������, ���������� � Byte2Str ������������������ ��� �����
//
// Revision 1.25  2003/07/16 10:36:50  narry
// - update
//
// Revision 1.24  2003/07/14 13:25:39  narry
// - bug fix: ������������ ��������� ����������
//
// Revision 1.23  2003/04/19 12:30:38  law
// - new file: ddDefine.inc.
//
// Revision 1.22  2003/02/05 11:54:06  narry
// - cleanup
//
// Revision 1.21  2002/10/01 12:11:57  narry
// - update: ����� �� ������������� l3Date
//
// Revision 1.20  2002/09/19 13:09:16  narry
// - remove unit: ddHTML.
//
// Revision 1.19  2002/02/01 11:49:23  narry
// - update
//
// Revision 1.18  2001/08/29 15:36:27  law
// - cleanup: ������� �������� ����������� �� Orpheus � SysTools.
//
// Revision 1.17  2001/04/27 09:24:48  narry
// Bug fix - ������ � ��������������� ��������
//
// Revision 1.16  2001/03/02 11:53:38  narry
// Update
//
// Revision 1.15  2000/12/15 15:29:55  law
// - ��������� ��������� Log � Id.
//

{$I ddDefine.inc }

interface
Uses
 Forms, Controls, StFileOp;

type
  TCharSet = Set of AnsiChar;

function CalcSpeed(Size: int64; Interval: TDateTime): ShortString;

function CalcSpeedEx(Size: Longint; StartDateTime: TDateTime;
                     StopDateTime: TDateTime): ShortString;

function CalcSpeedExSec(Size, TimeSec: Int64): ShortString;

function GetProgramVersion: ShortString;

function TimeSec2Str(TimeSec: Int64): ShortString;

function ElapsedSec(aStartDateTime: TDateTime; aStopDateTime: TDateTime): Int64;
{ ����������� �����  � �������� }

function CalcElapsedTime(aStartDateTime: TDateTime;
                         aStopDateTime: TDateTime = 0): ShortString;
{ ����������� ����� � ��������� ���� }

function CalcEstimatedTime(aTotal, aCurrent: Int64; aStartDateTime, aStopDateTime: TDateTime): ShortString;
{ ������ ����� �� ������� � ��������� ����  }

function CalcLeftTime(aTotal, aCurrent: int64; aStartDateTime, aStopDateTime: TDateTime): ShortString;
{ ���������� ����� � ��������� ����  }


type
  TddSizeType = (dd_stGiga, dd_stMega, dd_stKilo, dd_stSimple, dd_stAuto);

const
 dd_KiloByte = 1024;
 dd_SizeMulti : array[TddSizeType] of Longint = (dd_KiloByte*dd_KiloByte*dd_KiloByte,
                                            dd_KiloByte*dd_KiloByte,
                                            dd_KiloByte,
                                            1,
                                            0);
 dd_SizePrefix : array[TddSizeType] of AnsiString = ('�',
                                             '�',
                                             '�',
                                             ' ',
                                             ' ');
function GetSizePrefix(const aSize: Int64): TddSizeType;
function Bytes2Str(const Size: Int64; const aSizeType: TddSizeType = dd_stAuto):
    ShortString;

procedure RestartApplication(const aParams: AnsiString = '');

procedure SaveSettings(theControl: TWinControl);

procedure LoadSettings(theControl: TWinControl);

function GetWindowsTempFolder: AnsiString;

function Decrypt(Text : ShortString): ShortString;

function Encrypt(Text : ShortString): ShortString;

procedure EnabledAsParent(container: TWinControl);

//returns True if the currently logged Windows user has Administrator rights
function IsWindowsAdmin: Boolean;

function GetSpecialFolderPath(folder : integer) : AnsiString;
// ���������� ����������� ���� � ����������� �� Folder:
(* ���������, ���������� � SHFolder
  CSIDL_PERSONAL = $0005; { My Documents }
  CSIDL_APPDATA = $001A; { Application Data, new for NT4 }
  CSIDL_LOCAL_APPDATA = $001C; { non roaming, user\Local Settings\Application Data }
  CSIDL_INTERNET_CACHE = $0020;
  CSIDL_COOKIES = $0021;
  CSIDL_HISTORY = $0022;
  CSIDL_COMMON_APPDATA = $0023; { All Users\Application Data }
  CSIDL_WINDOWS = $0024; { GetWindowsDirectory() }
  CSIDL_SYSTEM = $0025; { GetSystemDirectory() }
  CSIDL_PROGRAM_FILES = $0026; { C:\Program Files }
  CSIDL_MYPICTURES = $0027; { My Pictures, new for Win2K }
  CSIDL_PROGRAM_FILES_COMMON = $002b; { C:\Program Files\Common }
  CSIDL_COMMON_DOCUMENTS = $002e; { All Users\Documents }

  CSIDL_FLAG_CREATE = $8000; { new for Win2K, or this in to force creation of folder }

  CSIDL_COMMON_ADMINTOOLS = $002f; { All Users\Start Menu\Programs\Administrative Tools }
  CSIDL_ADMINTOOLS = $0030; { <user name>\Start Menu\Programs\Administrative Tools }
*)

function ValidFolder(aFolder: AnsiString; ForWrite: Boolean = True): Boolean;

function SafeValidFolder(aFolderName: AnsiString; ForWrite: Boolean = True): AnsiString;

function ExtractPattern(aText: AnsiString): AnsiString;

function GetNearestDay(aToday: TDateTime; aDayOfWeek: Word; const aNext: Boolean = True): TDateTime;

function IsRelativePath(aPath: AnsiString): Boolean;

type
  TddTimeType = (dd_ttDay, dd_ttHour, dd_ttMin, dd_ttSec);

function CopyFolder(Source, Destination: AnsiString; FullStructure: Boolean =
    True): Boolean;

function CopyFiles(const aSourceFolder, aDestFolder: AnsiString; Operation: TStFileOp = fopCopy):
    Boolean;

procedure MoveFiles(const aSourceFolder, aDestinationFolder: AnsiString);

procedure UpperCaseFirstLetter(var aText: AnsiString);

function MakeUniqueFolderName(const aFolder: AnsiString; const aLast: Boolean =
    False): AnsiString;

function DateToString(aDate: TDateTime): AnsiString;

function EnableOpenFile(const aFileName: AnsiString): Boolean;

function Running32ON64: boolean;

function GetAppFolderFileName(const aFileName: AnsiString; aUnique: Boolean = False): AnsiString;

function ResetSelfLog(aSizeLimit: Integer): AnsiString;

function NumSuffix(const aNum: Integer; const aOneForm, aTwoForm, aPluralForm: AnsiString): AnsiString;
{ ��������� ���������� � ������������� ����� � ������ �����, ���������� ������ � ������ � ��������� }
{ �������������: Msg2Log('%s', [NumSuffix(l_Num, '�������', '�������', '�������')]); }

const
  dd_TimeMulti : array[TddTimeType] of Longint =
             (24*60*60, 60*60, 60, 1);
  dd_TimeName : array[TddTimeType] of ShortString =
             ('����', '���', '���', '���');
  dd_MaxTime = 30*24*60*60; // �����

implementation

uses
  SysUtils, ShellApi, Windows, DateUtils, StdCtrls, Classes, Math, SHFolder,
  vtVerInf, l3IniFile, l3FileUtils, l3String,
  StrUtils, Types, CheckLst, L3Bits, ExtCtrls, ComCtrls, l3ExceptionsLog,
  l3Base, l3Chars;

const
 c_100 = 100;

function GetSpecialFolderPath(folder : integer) : AnsiString;
const
  SHGFP_TYPE_CURRENT = 0;
var
  path: array [0..MAX_PATH] of AnsiChar;
begin
  if SUCCEEDED(SHGetFolderPath(0,folder,0,SHGFP_TYPE_CURRENT,@path[0])) then
    Result := path
  else
    Result := '';
end;


function CalcSpeed(Size: int64; Interval: TDateTime): ShortString;
var
 l_SizePrefix: TddSizeType;
  TimeSt: AnsiString;
  SizeRealHi, SizeRealLo: Integer;
  TimeRealHi, TimeRealLo: Integer;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Interval, Hour, Min, Sec, MSec);
  if Hour > 0 then
  begin
    TimeSt:= '�����';
    TimeRealHi:= Hour+Min div c_100;
    TimeRealLo:= Hour+Min mod c_100;
  end
  else
  if Min > 0 then
  begin
    TimeSt:= '�����';
    TimeRealHi:= Min+Sec div c_100;
    TimeRealLo:= Min+Sec mod c_100;
  end
  else
  begin
    TimeSt:= '������';
    TimeRealHi:= Sec+MSec div c_100;
    TimeRealLo:= Sec+MSec mod c_100;
  end;

 l_SizePrefix:= GetSizePrefix(Size);
 if l_SizePrefix > dd_stMega then
  l_SizePrefix:= dd_stMega;
 SizeRealHi:= Size div dd_SizeMulti[l_SizePrefix];
 SizeRealLo:= Size mod dd_SizeMulti[l_SizePrefix];

 Result:= Format('���������� %4d.%3d %s���� �� %4d.%2d %s',
                  [SizeRealHi, SIzeREalLo div c_100, dd_SizePrefix[l_SizePrefix],
                   TimeRealHi, TimeRealLo div c_100, TimeSt]);
end;

function ElapsedSec(aStartDateTime: TDateTime; aStopDateTime: TDateTime): Int64;
begin
 Result:= SecondsBetween(aStopDateTime, aStartDateTime);
end;


function CalcSpeedEx(Size: Longint; StartDateTime: TDateTime;
                     StopDateTime: TDateTime): ShortString;
var
  TotTime: Longint;
  SpeedHi, SpeedLo: Longint;
begin
 TotTime:= SecondsBetween(StopDateTime, StartDateTime);
 try
  if TotTime > 0 then
  begin
   SpeedHi:= (Size div TotTime) div dd_KiloByte;
   SpeedLo:= (Size div TotTime) mod dd_KiloByte;
   Result:= Format('%3d.%2d ��/���', [SpeedHi, SpeedLo]);
  end
  else
   Result:= '??? ��/���';
 except
  Result:= '??? ��/���'
 end;
end;

function CalcSpeedExSec(Size, TimeSec: Int64): ShortString;
var
  SpeedHi, SpeedLo: Longint;
begin
 if TimeSec <> 0 then
 try
  SpeedHi:= (Size div TimeSec) div dd_KiloByte;
  SpeedLo:= (Size div TimeSec) mod dd_KiloByte div c_100;
  Result:= Format('%3d.%2d ��/���', [SpeedHi, SpeedLo]);
 except
  Result:= '??? ��/���'
 end
 else
  Result:= '??? ��/���';
end;

function GetProgramVersion: ShortString;
var
  VI: TVersionInfo;
begin
 try
  VI := TVersionInfo.Create(ParamStr(0));
  try
   Result:= Format('%s ������ %s �� %s.',
         [VI.FileDescription,
         LongVersionToString(VI.ProductLongVersion),
         DateToStr(VI.VerFileDate)]);
  finally
    vi.Free;
  end;
 except
   Result:= '������ ��������� ����������';
 end;
end;

function TimeSec2Str(TimeSec: Int64): ShortString;
var
  Day, Hour, Min, Sec: Longint;
begin
 if InRange(TimeSec, 0, dd_MaxTime) then
 try
  Day:= TimeSec div dd_TimeMulti[dd_ttDay];
  Hour:= TimeSec div dd_TimeMulti[dd_ttHour];
  Min:=  TimeSec div dd_TimeMulti[dd_ttMin];
  Sec:=  TimeSec;
  if Day > 1 then
  begin
   Hour:= (TimeSec mod dd_TimeMulti[dd_ttDay]) div dd_TimeMulti[dd_ttHour];
   Result:= Format('%2d ��� %2d ���', [Day, Hour])
  end
  else
  if Hour > 0 then
  begin
   Min:=  TimeSec mod dd_TimeMulti[dd_ttHour] div dd_TimeMulti[dd_ttMin];
   Result:= Format('%2d ��� %2d ���', [Hour, Min])
  end
  else
  if  Min > 0 then
  begin
   Sec:=  TimeSec mod dd_TimeMulti[dd_ttMin];
   Result:= Format('%2d ��� %2d ���', [Min, Sec])
  end
  else
  if Sec > 0 then
    Result:= Format('%2d ���', [Sec])
  else
    Result:= '������ ������';
 except
  Result:= '??? ���';
 end
 else
   Result:= '����������';
end;

{$IFDEF NewDT}
{$ENDIF}

function GetSizePrefix(const aSize: Int64): TddSizeType;
var
 l_Index: TddSizeType;
begin
 Result:= dd_stSimple;
 for l_Index:= Low(TddSizeType) to High(TddSizeType) do
  if aSize >= dd_SizeMulti[l_Index] then
  begin
   Result:= l_Index;
   break;                                                                
  end;
end;

function Bytes2Str(const Size: Int64; const aSizeType: TddSizeType = dd_stAuto):
    ShortString;
var
 SizeTot: TddSizeType;
 i, j: Integer;
begin
 { TODO -o������� ����� -c������ : ���-�� ����� ��������� }
 if Size > 0 then
 begin
  if aSizeType = dd_stAuto then
   SizeTot:= GetSizePrefix(size)
  else
   SizeTot:= aSizeType;
  Result:= Format('%3.2f %s����', [Size/dd_SizeMulti[SizeTot], dd_SizePrefix[SizeTot]]);
  i:= Pred(Pos(' ', Result));
  j:= i;
  while Result[j] = '0' do
   Dec(j);
  if i <> j then
  begin
   if Result[j] in [',','.'] then
    Dec(j);
   Delete(Result, Succ(j), i-j);
  end;
 end
 else
  Result:= '';
end;

function FormatTime(Sec: Int64): ShortString;
var
  H, M, S: Longint;
begin
 try
  H:= Sec div 3600;
  M:= (Sec mod 3600) div 60;
  S:= (Sec mod 3600) mod 60;
  if H > 0 then
    Result:= Format('%d ��� %d ��� %d ���', [H, M, S])
  else
  if M > 0 then
    Result:= Format('%d ��� %d ���', [M, S])
  else
    Result:= Format('%d ���', [S]);
 except
  Result:= '';
 end;
end;

function CalcElapsedTime(aStartDateTime: TDateTime; aStopDateTime: TDateTime = 0): ShortString;
begin
  if aStopDateTime = 0 then
   aStopDateTime := Now;
  Result:= FormatTime(SecondsBetween(aStopDateTime, aStartDateTime));
end;

function CalcEstimatedTime(aTotal, aCurrent: Int64; aStartDateTime, aStopDateTime: TDateTime): ShortString;
var
  TotTime: int64;
  EstTime: int64;
begin
 if aCurrent <> 0 then
 try
  TotTime:= SecondsBetween(aStopDateTime, aStartDateTime);
  EstTime:= (aTotal*TotTime) div aCurrent;
  Result:= FormatTime(EstTime);
 except
  Result:= '???';
 end
 else
  Result:= '???';
end;

function CalcLeftTime(aTotal, aCurrent: int64; aStartDateTime, aStopDateTime: TDateTime): ShortString;
var
  TotTime: int64;
  EstTime: int64;
begin
 if aCurrent <> 0 then
 try
  TotTime:= SecondsBetween(aStopDateTime, aStartDateTime);
  EstTime:= (aTotal*TotTime) div aCurrent;
  if TotTime > EstTime then
    Result:= '����������'
  else
    Result:= FormatTime(EstTime-TotTime);
 except
   Result:= '';
 end
 else
  Result:= '';
end;

procedure RestartApplication(const aParams: AnsiString = '');
var
 AppName: PAnsiChar;
begin
 AppName:= PAnsiChar(Application.ExeName);
 ShellExecuteA(Application.Handle, 'open', AppName, PAnsiChar(aParams), nil, sw_shownormal);
 Application.Terminate;
end;

procedure SaveSettings(theControl: TWinControl);
var
 i, j: Integer;
 l_Ini: TCfgList;
 l_C: TControl;
 l_Value: Longint;
begin
 with TCfgList.Create do
 try
  Section := 'Settings';
  for i:= 0 to Pred(theControl.ControlCount) do
  begin
   l_C := theControl.Controls[i];
   if l_C is TCustomEdit then
    writeParamStr(l_C.Name, TCustomEdit(l_C).Text)
   else
   if l_C is TCustomListControl then
   begin
    writeParamInt(l_C.Name, TCustomListControl(l_C).ItemIndex);
    if l_C is TCheckListBox then
    begin
     l_Value:= 0;
     for j:= 0 to Pred(TCheckListBox(l_C).Items.Count) do
      if TCheckListBox(l_C).Checked[j] then
       l3setBit(l_Value, j);
     WriteParamInt(l_C.Name+'.Checked', l_Value);
    end
   end
   else
   if l_C is TCheckBox then
    WriteParamBool(l_C.Name, TCheckBox(l_C).Checked)
   else
   if l_C is TRadioButton then
    WriteParamBool(l_C.Name, TRadioButton(l_C).Checked)
   else
   if l_C is TRadioGroup then
    WriteParamInt(l_C.Name, TRadioGroup(l_C).ItemIndex)
   else
   if (l_C is TGroupBox) or (l_C is TPanel) or (l_C is TPageControl) or (l_C is TTabSheet) then
    SaveSettings(l_C as TWinControl);
  end;
 finally
  Free;
 end;
end;

procedure LoadSettings(theControl: TWinControl);
var
 i, j: Integer;
 l_Ini: TCfgList;
 l_C: TControl;
 l_Value: Longint;
begin
 with TCfgList.Create do
 try
  Section := 'Settings';
  for i:= 0 to Pred(theControl.ControlCount) do
  begin
   l_C := theControl.Controls[i];
   if l_C is TCustomEdit then
    TCustomEdit(l_C).Text:= ReadParamStrDef(l_C.Name, TCustomEdit(l_C).Text)
   else
   if l_C is TCustomListControl then
   begin
    TCustomListControl(l_C).ItemIndex:= ReadParamIntDef(l_C.Name, TCustomListControl(l_C).ItemIndex);
    if l_C is TCheckListBox then
    begin
     l_Value:= ReadParamIntDef(l_C.Name+'.Checked', 0);
     for j:= 0 to Pred(TCheckListBox(l_C).Items.Count) do
      TCheckListBox(l_C).Checked[j]:= l3TestBit(l_Value, j);
    end;
   end
   else
   if l_C is TCheckBox then
    TCheckBox(l_C).Checked:= ReadParamBoolDef(l_C.Name, TCheckBox(l_C).Checked)
   else
   if l_C is TRadioButton then
    TRadioButton(l_C).Checked:= ReadParamBoolDef(l_C.Name, TRadioButton(l_C).Checked)
   else
   if l_C is TRadioGroup then
    TRadioGroup(l_C).ItemIndex:= ReadParamIntDef(l_C.Name, TRadioGroup(l_C).ItemIndex)
   else
   if (l_C is TGroupBox) or (l_C is TPanel) or (l_C is TPageControl) or (l_C is TTabSheet) then
    LoadSettings(l_C as TWinControl)
  end;
 finally
  Free;
 end;
end;

function GetWindowsTempFolder: AnsiString;
var
 lng: DWORD;
 thePath: AnsiString;
begin
 SetLength(thePath, MAX_PATH) ;
 lng := GetTempPathA(MAX_PATH, PAnsiChar(thePath)) ;
 SetLength(thePath, lng) ;
 Result:= thePath;
end;

const
  C1 = 439;
  C2 = 163;
  
{$R-}
function BorlandEncrypt(const S: ShortString; Key: Word): ShortString;
var
  I: byte;
begin
  SetLength(Result,Length(S));
  for I := 1 to Length(S) do
  begin
    Result[I] := ansichar(byte(S[I]) xor (Key shr 8));
    try
    Key := (byte(Result[I]) + Key) * C1 + C2;
    except
    Key := (byte(Result[I]) + Key) * C1 + C2;
    end;
  end;
end;

function BorlandDecrypt(const S: ShortString; Key: Word): ShortString;
var
  I: byte;
begin
 try
  SetLength(Result,Length(S));
  for I := 1 to Length(S) do begin
    Result[I] := ansichar(byte(S[I]) xor (Key shr 8));
    Key := (byte(S[I]) + Key) * C1 + C2;
  end;
 except
  Result := '';
 end;
end;
{$R+}

function Encrypt(Text : ShortString): ShortString;
begin
 Result := BorlandEncrypt(Text,17732);
end;

function Decrypt(Text : ShortString): ShortString;
begin
 if Text = '' then
  result := ''
 else
  result := BorlandDecrypt(Text,17732);
end;

procedure EnabledAsParent(container: TWinControl) ;
var
  index : integer;
  aControl : TControl;
  isContainer : boolean;
begin
  for index := 0 to -1 + container.ControlCount do
  begin
    aControl := container.Controls[index];

    aControl.Enabled := container.Enabled;

    isContainer := (csAcceptsControls in container.Controls[index].ControlStyle) ;

    if (isContainer) AND (aControl is TWinControl) then
    begin
      //recursive for child controls
      EnabledAsParent(TWinControl(container.Controls[index])) ;
    end;
  end;
end;

const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5)) ;

const
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;


function IsWindowsAdmin: Boolean;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  g: Integer;
  bSuccess: BOOL;
begin
  Result := False;

  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, hAccessToken) ;
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
    bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken) ;
  end;


  if bSuccess then
  begin
    GetMem(ptgGroups, 1024) ;

    bSuccess := GetTokenInformation(hAccessToken, TokenGroups, ptgGroups, 1024, dwInfoBufferSize) ;

    CloseHandle(hAccessToken) ;

    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID,
                               DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, psidAdministrators) ;

      for g := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[g].Sid) then
        begin
          Result := True;
          Break;
        end;

      FreeSid(psidAdministrators) ;
    end;

    FreeMem(ptgGroups) ;
  end;
end;

function ValidFolder(aFolder: AnsiString; ForWrite: Boolean = True): Boolean;
var
 l_FileName: AnsiString;
 l_Handle: Integer;
begin
 Result:= False;
 if aFolder <> '' then
 begin
  if ForWrite and not DirectoryExists(aFolder) then
   Result:= ForceDirectories(aFolder)
  else
   Result := True;
  if Result and ForWrite then
  begin // �������� ������� ����
   l_FileName := GetUniqFileName(aFolder, 'test', 'test');
   l_Handle:= FileCreate(l_FileName);
   Result := l_Handle <> -1;
   if Result then
   begin
    FileClose(l_Handle);
    SysUtils.DeleteFile(l_FileName);
   end;
  end; // DirectoryExists(aFolder)
 end;// aFolder <> ''
end;

function SafeValidFolder(aFolderName: AnsiString; ForWrite: Boolean = True): AnsiString;
begin
 if ValidFolder(aFolderName, ForWrite) then
  Result:= aFolderName
 else
  Result := ExtractFileDir(Application.ExeName);
end;

function ExtractPattern(aText: AnsiString): AnsiString;
var
 l_Start, l_Finish: Integer;
begin
 Result:= '';
 // ������� ���������, ����������� � ���� %
 l_Start:= Pos('%', aText);
 l_Finish:= PosEx('%', aText, Succ(l_Start));
 if l_Finish > 0 then
  Result := UpperCase(Copy(aText, l_Start, l_Finish-l_Start+1))
end;

function GetNearestDay(aToday: TDateTime; aDayOfWeek: Word; const aNext: Boolean = True): TDateTime;
var
 l_CurDay: Word;
 l_Delta: Integer;
begin
 if aDayOfWeek in [DayMonday..DaySunday] then
 begin
  l_CurDay:= DayOfTheWeek(aToday);
  case CompareValue(l_CurDay, aDayOfWeek) of
   LessThanValue   : l_Delta:= aDayOfWeek - l_CurDay;
   EqualsValue     : l_Delta:= 0;
   GreaterThanValue: l_Delta:= 7 - (l_CurDay - aDayOfWeek);
  end;
  if not aNext then
   Dec(l_Delta, 7);
 end
 else
  l_Delta:= 0;
 Result:= IncDay(aToday, l_Delta);
end;

function IsRelativePath(aPath: AnsiString): Boolean;
begin
 Result := ExtractFileDrive(aPath) = '';
end;

function CopyFolder(Source, Destination: AnsiString; FullStructure: Boolean =
    True): Boolean;
var
 l_FileOp: TStFileOperation;
 l_SR: TSearchRec;
begin
 ForceDirectories(Destination); // ������� �������� �����

 l_FileOp  := TStFileOperation.Create(Application);
 try
  l_FileOp.ConfirmFiles:= False;
  l_FileOp.Options:= l_FileOp.Options+
                     [foNoConfirmMkDir, foNoConfirmation, foNoErrorUI]-
                     [foRenameCollision, foAllowUndo, foFilesOnly];
  l_FileOp.Destination:= Destination;
  if FullStructure then
  begin
   if FindFirst(ConcatDirName(Source, '*.*'), faAnyFile, l_SR) = 0 then
   begin
    repeat
     if (l_SR.Name[1] <> '.') then
      l_FileOp.SourceFiles.Add(ConcatDirName(Source, l_SR.Name));
    until FindNext(l_SR) <> 0;
    SysUtils.FindClose(l_SR);
   end // FindFirst(Folder, faAnyFile, l_SR) = 0
  end
  else
   l_FileOp.SourceFiles.Add(Source);

  Result:= l_FileOp.Execute;
 finally
  l_FileOp.Free;
 end; // try finally
end;

function CopyFiles(const aSourceFolder, aDestFolder: AnsiString; Operation: TStFileOp = fopCopy):
    Boolean;
var
 l_FileOp: TStFileOperation;
 l_SR: TSearchRec;
begin
 ForceDirectories(aDestFolder); // ������� �������� �����

 l_FileOp  := TStFileOperation.Create(Application);
 try
  l_FileOp.Operation:= Operation;
  l_FileOp.ConfirmFiles:= False;
  //l_FileOp.Options:= l_FileOp.Options+
  //                   [foNoConfirmMkDir, foNoConfirmation, foNoErrorUI]-
  //                   [foRenameCollision, foAllowUndo, foFilesOnly];
  l_FileOp.Destination:= aDestFolder;
  if FindFirst(ConcatDirName(aSourceFolder, '*.*'), faAnyFile, l_SR) = 0 then
  begin
   repeat
    if (l_SR.Name[1] <> '.') then
     l_FileOp.SourceFiles.Add(ConcatDirName(aSourceFolder, l_SR.Name));
   until FindNext(l_SR) <> 0;
   SysUtils.FindClose(l_SR);
  end; // FindFirst(Folder, faAnyFile, l_SR) = 0

  //l_FileOp.SourceFiles.Add(aSourceFolder);

  Result:= l_FileOp.Execute;
 finally
  l_FileOp.Free;
 end; // try finally
end;

procedure MoveFiles(const aSourceFolder, aDestinationFolder: AnsiString);
begin
 CopyFiles(aSourceFolder, aDestinationFolder, fopMove);
end;

procedure UpperCaseFirstLetter(var aText: AnsiString);
var
 i: Integer;
begin
 if aText <> '' then
 begin
  aText:= Trim(aText); 
  i:= 1;
  while not (aText[i] in cc_AlphaNum) and (i < Length(aText)) do inc(i);
  if i < Length(aText) then
   l3MakeUpperCase(PAnsiChar(aText)+Pred(i), 1);
 end; // aText <> ''
end;

function MakeUniqueFolderName(const aFolder: AnsiString; const aLast: Boolean =
    False): AnsiString;
var
  l_Suffix: Integer;
begin
  l_Suffix:= 0;
  Result:= aFolder;
  while FileExists(Result) do
  begin
    Result:= SysUtils.Format('%s.%d', [aFolder, l_Suffix]);
    Inc(l_Suffix);
  end;
  if (l_Suffix > 0) then
   Dec(l_Suffix);
  if aLast then
   Result:= SysUtils.Format('%s.%d', [aFolder, Pred(l_Suffix)]);
end;

function DateToString(aDate: TDateTime): AnsiString;
var
 Y, M, D: Word;
begin
 DecodeDate(aDate, Y, M, D);
 Result := Format('%.4d%.2d%.2d', [Y, M, D]);
end;

function EnableOpenFile(const aFileName: AnsiString): Boolean;
var
 l_Handle: Integer;
begin
 Result := False;
 l_Handle:= FileOpen(aFileName, fmOpenRead);
 if l_Handle >= 0 then
 begin
  Result:= True;
  FileClose(l_Handle);
 end; // l_Handle >= 0
end;

function Running32ON64: boolean;
type
  TIsWow64Process = function(Handle:THandle; var IsWow64 : boolean) : boolean; stdcall;
var
  hDLL : cardinal;
  IsWow64Process : TIsWow64Process;
begin
  result := false;
  hDLL := LoadLibrary('kernel32.dll');
  if (hDLL = 0) then Exit;
  try
    @IsWow64Process := GetProcAddress(hDLL, 'IsWow64Process');
    if Assigned(IsWow64Process) then IsWow64Process(GetCurrentProcess, result);
  finally
    FreeLibrary(hDLL);
  end;
end;

function GetAppFolderFileName(const aFileName: AnsiString; aUnique: Boolean = False): AnsiString;
var
 l_Folder: AnsiString;
begin
 l_Folder:= ExtractFileDir(Application.ExeName);
 Result:= ConcatDirName(l_Folder, aFileName);
 if aUnique then
  Result:= MakeUniqueFileName(Result);
end;

function ResetSelfLog(aSizeLimit: Integer): AnsiString;
{$IFDEF _m0LOGSAV1}
var
 l_LogFileName, l_OldLogFileName, l_Folder: ShortString;
{$ENDIF}
begin
 {$IFDEF _m0LOGSAV1}
 l_LogFileName:= Gm0EXCLibDefSrv.LogFileName;
 FreeAndNil(Gm0EXCLibDefSrv);
 try
 if FileExists(l_LogFileName) and (SizeOfFile(l_LogFileName) > aSizeLimit) then
  begin
   l_Folder:= GetAppFolderFileName('Log Files');
   if ForceDirectories(l_Folder) then
   begin
    l_OldLogFileName:= ConcatDirName(l_Folder, ExtractFileName(l_LogFileName)+'.'+SysUtils.FormatDateTime('YYYY-MM-DD', Now));
    try
     Result:= MakeUniqueFileName(l_OldLogFileName);
     RenameFile(l_LogFileName, Result);
    except
     // ����-�� ���...
     // l3System.Msg2Log('�� ������� ����������� ���-����');
    end;
   end; // ForceDirectories(l_Folder)
  end;
 finally
  Gm0EXCLibDefSrv:= Tm0ExceptionServer.Create(l_LogFileName);
 end;
 {$ENDIF}
end;

function NumSuffix(const aNum: Integer; const aOneForm, aTwoForm, aPluralForm: AnsiString): AnsiString;
var
 l_Mod: Byte;
begin
 l_Mod := Abs(aNum mod 100);
 if l_Mod in [10..20] then
  Result := Format('%d %s', [aNum, aPluralForm])
 else
 begin
  l_Mod := Abs(aNum mod 10);
  case l_Mod of
   1     : Result := Format('%d %s', [aNum, aOneForm]);
   2,3,4 : Result := Format('%d %s', [aNum, aTwoForm]);
  else
   Result := Format('%d %s', [aNum, aPluralForm]);
  end;
 end;
end;


end.
