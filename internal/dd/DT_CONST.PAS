Unit Dt_Const;

{ $Id: DT_CONST.PAS,v 1.46 2013/04/11 16:46:26 lulin Exp $ }

// $Log: DT_CONST.PAS,v $
// Revision 1.46  2013/04/11 16:46:26  lulin
// - ���������� ��� XE3.
//
// Revision 1.45  2013/03/26 12:20:03  fireton
// - 133 ������ ����
//
// Revision 1.44  2012/11/14 11:03:39  fireton
// - ��������� id ���������� ������ � base.ini
//
// Revision 1.43  2012/10/17 07:48:13  fireton
// - ��������� ������� ��� ������������
//
// Revision 1.42  2012/06/28 08:29:07  narry
// ���������� ������ ������ ������ ������, ��� ������������ ���������� (372649129)
//
// Revision 1.41  2012/05/24 09:21:33  voba
// - bug fix
//
// Revision 1.40  2012/04/20 15:20:52  lulin
// {RequestLink:283610570}
//
// Revision 1.39  2012/03/06 13:00:31  fireton
// - ������� � ������ B_archi_base132
//
// Revision 1.38  2012/02/28 07:02:31  narry
// ���������� ��� ��������� � ���� (342330845)
//
// Revision 1.37  2012/02/27 09:46:06  fireton
// - ftnImgHandle
//
// Revision 1.36.2.1  2012/02/13 06:24:10  fireton
// - ��������� Flags � ���������� ������������� ���������
//
// Revision 1.36  2012/01/26 07:56:26  fireton
// - ������� !*HANG (K 330696104)
//
// Revision 1.35  2011/12/21 14:45:08  fireton
// - ����� ������� !*INTERNET (� 321986367)
//
// Revision 1.34  2011/06/20 09:34:10  voba
// - k : 236721575
//
// Revision 1.33  2011/06/01 14:23:14  fireton
// - ����� ���� ���������� DocID
//
// Revision 1.32  2011/04/11 10:25:01  narry
// �������� ��� ��� (259885290)
//
// Revision 1.31  2011/03/25 11:04:12  voba
// - k : 236721575
//
// Revision 1.30  2011/01/28 11:25:36  voba
// - k : 251343383
//
// Revision 1.29  2010/11/18 13:09:07  narry
// �241013352. ���������� ������� ���������� ���
//
// Revision 1.28  2010/09/24 12:10:36  voba
// - k : 235046326
//
// Revision 1.27  2010/03/17 15:41:35  voba
// no message
//
// Revision 1.26  2010/02/15 10:28:12  narry
// - ��������� ������� !NOCOMPARE
//
// Revision 1.25  2009/11/30 15:28:00  fireton
// - ������ ������
//
// Revision 1.24  2009/11/27 15:09:59  voba
// no message
//
// Revision 1.23  2009/11/18 10:13:47  voba
// - add const
//
// Revision 1.22  2009/08/28 14:36:26  voba
// - ����� utFullFeatureDocTypesEx
//
// Revision 1.21  2009/07/20 12:38:50  voba
// - ������� renum � ��������
//
// Revision 1.20  2009/06/23 07:33:58  voba
// - �������������� ������� � ���������
//
// Revision 1.19  2009/06/08 13:23:22  voba
// - enh. ���������� ���������. ��������� �� ��������������� atDateNumsChDate, atRelHLink,
//
// Revision 1.18  2009/06/01 11:28:34  fireton
// - [$146377261]
//
// Revision 1.17  2009/04/21 10:03:06  narry
// - ������ ����������� ���������� �����
//
// Revision 1.16  2009/03/04 12:34:21  voba
// - ����� �� dt_Const ��������� HyTech
//
// Revision 1.15  2009/03/02 08:24:48  voba
// - ������� function FamTblName �  MainTblName �� ���� TblName � ��������� Family
// - �������  ��� verload function TablePassword �� ���� � ��������� Family
//
// Revision 1.14  2009/02/20 13:27:54  fireton
// - ������� !CHANGE (K 77235676)
// - 131 ������ ����
//
// Revision 1.13  2009/02/17 16:46:02  voba
// - bu fix htErr=-32
//
// Revision 1.12  2009/01/13 07:57:52  voba
// no message
//
// Revision 1.11  2008/12/29 10:35:39  voba
// no message
//
// Revision 1.10  2008/12/17 11:11:04  voba
// - bug fix �������������� ��������� ������ VINCLUDED
//
// Revision 1.9  2008/11/10 14:29:43  fireton
// - ��������� �������� ����������
//
// Revision 1.8  2008/09/23 12:17:48  fireton
// - ������/������� ������ ��������� ����
//
// Revision 1.7  2008/09/17 14:47:45  fireton
// - ����� ������ ���� (130)
// - ��������� ���������
//
// Revision 1.6  2008/07/17 10:40:49  voba
// - add const
//
// Revision 1.5  2008/05/05 14:15:37  voba
// no message
//
// Revision 1.4  2008/05/05 10:41:44  voba
// - ���������� �� ������ �����������������
//
// Revision 1.3  2008/04/14 12:44:22  voba
// - enh. �������� TDLPassportRec
//
// Revision 1.2  2008/04/07 12:07:19  fireton
// - ������� ������ ���������� �� ���������
//
// Revision 1.1  2008/02/26 12:30:57  lulin
// - ������� �� ������� �������� �����.
//
// Revision 1.155  2008/01/29 07:32:00  voba
// - add const
//
// Revision 1.154  2007/12/03 08:23:58  voba
// - dd const cAllSubs
//
// Revision 1.153  2007/11/26 10:07:12  voba
// - use cUndefDictID, cUndefDocID, cUndefSubID
//
// Revision 1.152  2007/11/26 09:53:28  voba
// - use cUndefDictID, cUndefDocID, cUndefSubID
//
// Revision 1.151  2007/11/21 08:34:53  voba
// - change ExtItemsTblNames to gExtDictItemRecArr
//
// Revision 1.150  2007/10/15 14:19:53  voba
// - cc
//
// Revision 1.149  2007/10/09 08:53:53  voba
// - merge with b_archi_export_refact2
//
// Revision 1.148.4.1  2007/09/14 15:42:20  voba
// no message
//
// Revision 1.148  2007/09/07 06:45:59  voba
// - inc base version
//
// Revision 1.147  2007/08/29 13:31:26  voba
// - update to 128 DB version
//
// Revision 1.146  2007/08/14 14:30:07  lulin
// - ������������ ����������� ������ ������.
//
// Revision 1.145  2007/07/24 14:16:50  narry
// - ���� ������� �� 127 ������
//
// Revision 1.144  2007/07/24 12:32:33  narry
// - ����������� ������� ���������
//
// Revision 1.143  2007/07/19 07:17:03  voba
// no message
//
// Revision 1.142  2007/06/20 11:55:02  voba
// - add dict dlServiceInfo
//
// Revision 1.141  2007/06/19 09:49:45  fireton
// - Doc Update to 127
//
// Revision 1.140  2007/05/14 06:33:14  narry
// - �������� �������������� ������
//
// Revision 1.139  2007/05/10 12:34:24  fireton
// - ������ ������� ������������ ����� �� ���������
//
// Revision 1.138  2007/05/04 11:56:24  fireton
// - ����� ������ ����
//
// Revision 1.137  2007/04/26 10:56:50  fireton
// - ����������� DT. ������� DICTSRC ������ �� �����.
//
// Revision 1.136  2007/04/26 10:26:49  fireton
// - ����������� DT. ����� �������� ��������� � cDLPassports.
//
// Revision 1.135  2007/04/26 10:01:43  fireton
// - ����������� DT. ������� DT_Link � DT_Dict �� ������ � ����� ��������.
//
// Revision 1.134  2007/04/25 09:30:57  fireton
// - ����������� DT. ��� ���� ��������� � DT_Types, � ��������� - � DT_Const
//
// Revision 1.133  2007/04/18 12:38:54  fireton
// - update ��������� ���� �� 126 (�������)
//
// Revision 1.132  2007/03/15 12:24:49  voba
// no message
//
// Revision 1.131.2.2  2007/03/13 07:08:40  voba
// no message
//
// Revision 1.131.2.1  2007/03/09 13:35:42  voba
// no message
//
// Revision 1.131  2007/03/09 07:36:26  voba
// - _move type TFieldArray  to Dt_Types
//
// Revision 1.130  2007/02/22 13:35:39  fireton
// - ������� �� 64 ���� � HyTech
//
// Revision 1.129  2007/01/16 07:15:33  voba
// - new const
//
// Revision 1.128  2006/12/13 15:44:33  voba
// - cc
//
// Revision 1.127  2006/12/11 14:51:38  voba
// - add  const utFullFeatureDocTypes
//
// Revision 1.126  2006/11/23 12:36:16  voba
// - add acgPublished
//
// Revision 1.125  2006/11/07 16:14:10  voba
// - add ExtItemsTblNames
//
// Revision 1.124  2006/10/27 07:50:34  voba
// - _move  htDllVersion
//
// Revision 1.123  2006/10/04 08:29:01  voba
// - TImpExpType edit
//
// Revision 1.122  2006/09/26 14:01:03  voba
// - add utIzm
//
// Revision 1.121  2006/08/23 07:51:47  voba
// - merge
//
// Revision 1.120  2006/06/08 15:54:45  fireton
// - ���������� � �������� �� ������� User ID
//
// Revision 1.119.2.1  2006/06/08 08:51:07  fireton
// - ������� User ID �� Longword
// - ������ ���� ��������
//
// Revision 1.119  2006/06/05 14:56:49  voba
// - _move TdtFilterAttributes  to DT_GetFltr,  add atNotTM
//
// Revision 1.118  2006/04/17 13:08:26  voba
// - add sUsualDictsForImpEx
//
// Revision 1.117.14.5  2006/08/03 14:13:16  voba
// - enh ��������  ��� ��� ctLog
//
// Revision 1.117.14.4  2006/06/15 11:30:03  voba
// - merge
//
// Revision 1.117.14.3  2006/05/30 11:50:36  voba
// no message
//
// Revision 1.117.14.2  2006/05/04 12:51:28  voba
// - add TFieldArray
//
// Revision 1.117.14.1  2006/04/17 13:45:58  voba
// - merge
//
// Revision 1.118  2006/04/17 13:08:26  voba
// - add sUsualDictsForImpEx
//
// Revision 1.117  2005/11/21 10:10:40  step
// ������ ��������� ������ �� �������
//
// Revision 1.116  2005/11/18 15:49:39  step
// ��������� ������ �� ������� �� ������ ��
//
// Revision 1.115  2005/11/11 15:08:53  voba
// - rename stDone ������ ��� ������ �� ������������
//
// Revision 1.114  2005/10/18 11:56:22  step
// �����������, ��������� � ����������� � ����. DT#A ���� Nonperiod
//
// Revision 1.113  2005/10/17 12:54:15  step
// �������� ������ ��
//
// Revision 1.112  2005/09/14 08:59:57  step
// � �� ���������� ����. GUDT
//
// Revision 1.111  2005/09/05 13:15:37  voba
// - add typeTUserType kind utBook
//
// Revision 1.110  2005/08/10 14:47:08  step
// ������� TSaveSrchDT (��������� sstAnnoClasses)
//
// Revision 1.109  2005/06/24 12:19:52  step
// new: c_LevelSlash
//
// Revision 1.108  2005/05/16 11:02:15  voba
// - ������� atLogInfo �� atDocLogInfo, atAnnoLogInfo
//
// Revision 1.107  2005/05/05 10:13:56  voba
// -add item to  TLogActionType
//
// Revision 1.106  2005/05/03 12:27:31  narry
// - update: ����� ��������� ��� ����������� ��������
//
// Revision 1.105  2005/03/30 09:27:15  narry
// - �������� ������� ANNODATE ��� ����������
//
// Revision 1.104  2005/03/21 16:30:09  voba
// - add cOrdLogActions
//
// Revision 1.103  2005/03/11 17:31:48  voba
// - add  cJurLogActions
//
// Revision 1.102  2005/03/04 10:03:38  narry
// - ����������: ����� ��������� ���� ���������� ������ acAnnoWasImported
//
// Revision 1.101  2005/03/03 12:12:56  voba
// no message
//
// Revision 1.100  2005/02/25 16:20:43  narry
// - update: ��������� ���������
//
// Revision 1.99  2005/02/25 15:17:25  step
// ���������� ����� ������� DT#5E (ver. 112).
//
// Revision 1.98  2005/02/24 13:28:26  voba
// -add acAnnoWork
//
// Revision 1.97  2005/02/24 12:06:00  step
// �������� TLogActionType (��������� acAnnoDate)
//
// Revision 1.96  2005/02/22 17:39:20  step
// new: c_BoolToByte
//
// Revision 1.95  2005/02/22 11:57:19  step
// ��������������: dlAnnoClass -> dlAnnoClasses
//
// Revision 1.94  2005/02/18 17:41:15  step
// ��������� ��������� ��������� � �����������
//
// Revision 1.93  2005/02/15 13:10:48  step
// �������� ��� TDLType - ��������� dlAnnoClass
//
// Revision 1.92  2005/01/14 16:21:54  step
// new: PLogActionType
//
// Revision 1.91  2004/11/29 13:41:34  step
// ��������� ���������� ������� �� �����
//
// Revision 1.90  2004/11/01 14:44:30  step
// ������� � ������
//
// Revision 1.89.8.1  2004/10/29 09:30:04  step
// ������� ����� ������ ��
//
// Revision 1.89  2004/08/19 14:09:53  step
// ����������� ��������
//
// Revision 1.88  2004/08/19 13:55:23  step
// ��������� ��������� - ���� ������, ������������ HT-���������
//
// Revision 1.87  2004/08/03 08:52:48  step
// ������ dt_def.pas �� DtDefine.inc
//
// Revision 1.86  2004/07/27 15:40:41  step
// ��������� ����. ���-�� ����������� ������
//
// Revision 1.85  2004/07/22 14:13:05  voba
// - add (* ����� ��������� ��������� *)
//
// Revision 1.84  2004/07/14 12:52:48  step
// ����� ����������������� ���������� �������� ������ ����� �������� ������ TAbsHtTbl.StartTA
//
// Revision 1.83  2004/06/09 08:22:52  step
// ��������� ��������� c_AdminBaseVersion
//
// Revision 1.82  2004/06/04 12:55:43  voba
// no message
//
// Revision 1.81  2004/05/31 13:33:28  voba
// - add const cAllLogActions
//
// Revision 1.80  2004/05/27 07:53:08  voba
// - add item in TLogActionType
//
// Revision 1.79  2004/05/25 16:44:43  step
// ������ �� ����������� �� �� archi.version, � �� base.ini
//
// Revision 1.78  2004/05/06 11:40:27  narry
// update: �������������� ���������
//
// Revision 1.77  2004/05/06 11:24:00  voba
// -add const
//
// Revision 1.76  2004/05/06 09:23:32  step
// ���������� c_DbVersion
//
// Revision 1.75  2004/05/06 09:15:51  voba
// merge with adding_diapasons_table_free2
//
// Revision 1.74  2004/04/13 07:17:31  voba
// no message
//
// Revision 1.73.8.1  2004/04/09 16:57:55  step
// ��������� ����� TFreeTbl (������ �������� � �����������)
//
// Revision 1.73.2.1  2004/03/30 15:56:51  step
// ������ TFamilyTbl �� TFamilyParams (������ ������� �������. INI-����)
//
// Revision 1.73  2004/03/26 14:09:41  voba
// no message
//
// Revision 1.72.2.1  2004/03/19 17:11:56  step
// �����������, ��������� � ����������� ���� DT#A.PRIVATE
//
// Revision 1.72  2004/03/15 13:17:23  step
// �������� c_DbVersion
//
// Revision 1.71  2004/03/10 15:32:29  voba
// no message
//
// Revision 1.70  2004/03/10 10:31:43  voba
// no message
//
// Revision 1.69  2004/03/03 16:03:44  step
// �������� c_DbVersion
//
// Revision 1.68  2004/02/26 09:04:39  step
// add: c_DbVersion
//
// Revision 1.67  2004/02/10 16:25:04  step
// add: sBigDictionaries
//
// Revision 1.66  2004/02/06 14:21:55  step
// � ����. DT#A ��������� ���� ShName
//
// Revision 1.65  2004/02/03 09:42:11  voba
// -add  acPublInWork in TLogActionType
//
// Revision 1.64  2003/12/18 14:31:00  step
// ��������� const cAnySubId
//
// Revision 1.63  2003/10/30 09:20:33  voba
// - new behavior : ����� ������ ��������� ���������� ��� ���������� ���������
//
// Revision 1.62  2003/08/21 12:14:28  voba
// - �������� ������������ ���TDNType
//
// Revision 1.61  2003/06/23 14:25:05  voba
// - ������������� acg* ���������
//
// Revision 1.60  2003/06/19 09:04:51  voba
// - add TOperActionType item
//
// Revision 1.59  2003/05/30 17:05:47  voba
// no message
//
// Revision 1.58  2003/05/20 09:19:40  demon
// - add: �������� ����� ���� ��� �������� edAutoClass � sedAutoClass.
// ��������� ����� ��������� ��� ��������� ������� � Sub'� ���������� - sfAutoClass
//
// Revision 1.57  2003/05/19 15:40:45  demon
// - add: �������� ����� ������� dlAutoClasses
//
// Revision 1.56  2003/04/29 15:46:42  voba
// - ������� ����� ����
//
// Revision 1.55  2003/04/04 13:58:03  demon
// -add: TAttributes - c����� ��������� ���������
//
// Revision 1.54  2003/04/01 07:07:55  voba
// -bug fix: ����� �������� ����������� u�OldEdition, ������� utEdition � ����� ������������� ����
//
// Revision 1.53  2003/03/31 13:48:59  demon
// - new: �������� ������ �������, ���������� �� ��������� � 64�� �� 8��
//
// Revision 1.52  2003/03/28 14:17:12  voba
// - add enumerated type value utOldEdition
//
// Revision 1.51  2003/03/17 11:52:39  narry
// - change: MaxActiveDate ������ ����� Hight(TstDate)
//
// Revision 1.50  2003/03/14 13:15:06  demon
// - new: ��������� minActiveDate, maxActiveDate
//
// Revision 1.49  2003/03/13 14:43:24  demon
// - new: ��������� ��� ��������� ���� ctActive � ctAlarm
//
// Revision 1.48  2003/03/13 13:01:17  demon
// - new: ��������� ��� ���������� ���� edActive � edAlarm
//
// Revision 1.47  2003/03/13 09:42:15  demon
// - new: �������� ����� ��� ��������� utEdition
//
// Revision 1.46  2003/03/11 14:15:24  demon
// - new: ����� ������������ ��� TActiveStatus ��� ����������� ������� �������� ���������.
//
// Revision 1.45  2003/01/27 10:57:50  demon
// - new: add special type sDoNotGetNames, ��� �������� � ������� �����
// �� ������ �������� � �����.
//
// Revision 1.44  2003/01/16 15:32:58  demon
// - newr: ��������� �������� ����� TExpData TSubExpData
//
// Revision 1.43  2002/09/11 14:50:45  voba
// -new behavior : �������� ���� "�������� �� �����"
//
// Revision 1.42  2002/08/08 10:52:26  voba
// - �������� ������ HyTech.DLL
//
// Revision 1.41  2002/05/30 06:35:10  demon
// - separate TCacheTblData object in new unit
//
// Revision 1.40  2002/04/09 11:37:02  demon
// - add empty LNK tbl for JournaledDicts
//
// Revision 1.39  2002/04/03 09:30:36  demon
// - some new const
//
// Revision 1.38  2002/04/02 12:17:22  demon
// - new behavior: add methods for copyTo and copyFrom JournaledDicts
//
// Revision 1.37  2002/03/15 09:39:21  demon
// - add _dictionary constant for export in NSRC
//
// Revision 1.36  2002/03/12 15:18:52  demon
// - spellchecking
//
// Revision 1.35  2002/03/12 14:33:30  demon
// - new class: new JournaledDidtItem and his node
//
// Revision 1.34  2002/03/12 11:31:55  demon
// - bug fix
//
// Revision 1.33  2002/03/12 09:48:19  demon
// - add new diction (type = dlNewClasses)
//
// Revision 1.32  2002/03/07 08:42:02  demon
// - add new usersDocType - utWEBReference
//
// Revision 1.31  2002/01/16 11:03:25  demon
// - add new version of HT DLL
//
// Revision 1.30  2001/11/30 09:57:39  demon
// - bug fix
//
// Revision 1.29  2001/11/23 13:29:02  demon
// -new behavior: add AccGroups attribute to Search process
//
// Revision 1.28  2001/11/21 12:51:36  demon
// - new: change access mask logic (Allow and Deny masks) and size (now LongInt)
//
// Revision 1.27  2001/10/11 14:02:19  voba
// - Bug fix: �������� �������� ������ ��� ������ ��������
//
// Revision 1.26  2001/10/04 06:32:30  demon
// - new: const ExportSection
//
// Revision 1.25  2001/08/23 11:22:11  demon
// - new behavior: ShowDocFlag now renamed to UserTypeFilter
// - new: add filter on DocType - DocTypeFilter
//
// Revision 1.24  2001/08/23 10:27:44  demon
// - add new Type - TDocType its replaced some constants
//
// Revision 1.23  2001/07/05 12:38:03  demon
// - new: add new version of Hytech Dll
//
// Revision 1.22  2001/02/09 09:48:38  demon
// - add new Import type - ietPacked,
// for cached import operation in multiuser format
//
// Revision 1.21  2001/02/07 13:51:11  demon
// - add search on Warnings
//
// Revision 1.20  2000/12/15 15:36:15  law
// - ��������� ��������� Log.
//

{$I DtDefine.inc}

interface

uses
 l3Types,
 l3Base,
 l3Date,

 DT_Types;

const
{+------------------------------------------------------------------------+
 | ������� ������ ��                                                      |
 +------------------------------------------------------------------------+}
 c_DocBaseVersion   = 133;
 c_AdminBaseVersion = c_DocBaseVersion;
{+------------------------------------------------------------------------+
 | ��������� ����� �������                                                |
 +------------------------------------------------------------------------+}

 {������ ���������� � ���������}

 acgNameAttr  = $0001;
 acgText      = $0002;

 acgHyperLink = $0004;
 acgSub       = $0008;
 acgBlock     = $0010;

 acgKeyWord   = $0020;
 acgClass     = $0040;
 acgJurOp     = $0080;
 acgAnno      = $0100;
 acgPublished = $0200;

 acgTextDependMask = acgText + acgHyperLink + acgSub + acgBlock;

 {��� ��������� �������}

 acfDocGroup = $0001; {1}
 acfDelete   = $0002; {2}

 acFullBlock = $00020000;

{+------------------------------------------------------------------------+
 | ��������� ����� �������                                                |
 +------------------------------------------------------------------------+}

 {����������� ������ �������}

 agNotIncludedGroup = 1;
 agIncludedGroup    = 2;

{+------------------------------------------------------------------------+
 | ��������� Item Flags                                                   |
 +------------------------------------------------------------------------+}
  ifSelected = $01;
  ifModified = $02;
{+------------------------------------------------------------------------+
 | ��������� Sub �����                                                    |
 +------------------------------------------------------------------------+}
  sfbitSubNumber = 0;
  sfbitExpName   = 1;
  sfbitKeyWords  = 2;
  sfbitTreeNodes = 3;
  sfbitNOTUSED   = 4;
  sfbitDocType   = 5;
  sfbitContents  = 6;
  sfbitRTFImage  = 7;

  sfSubNumber = 1 shl sfbitSubNumber;
  sfExpName   = 1 shl sfbitExpName;
  sfKeyWords  = 1 shl sfbitKeyWords;
  sfTreeNodes = 1 shl sfbitTreeNodes;
  sfDocType   = 1 shl sfbitDocType;
  sfContents  = 1 shl sfbitContents;
  sfRTFImage  = 1 shl sfbitRTFImage;
{+------------------------------------------------------------------------+
 | ���� �������� ��������                                                 |
 +------------------------------------------------------------------------+}
  actt_Normal = 0;
  actt_Unsure = 1;
{+------------------------------------------------------------------------+
 | ������ ���������                                                       |
 +------------------------------------------------------------------------+}
  MaxTbls        = 70;  (* ����� ������������ �������� ������ *)
  MaxTblsBuf     = 20;  {125;}

  MaxTrsTime     = 40; { ���������� ����� ���������� ���������� (���.) }
  DefaultTransTime = MaxTrsTime; {��� �������� �������� ���� ���������}

  BaseSection : String[12] = 'BaseDocPath'; { ������ ��� � ���������������� ����� }
  FamilySection : String = 'FamilyConst'; { ������ �������� � ���������������� ����� }
  ExportSection : String[12] = 'ExportData'; { ������ ��� �������� ����������� ��������,
                                           ������������ �� ������� � User.ini }

  AbsNumFld      = 0;

  MaxStatusMask  = 1;

  cUndefDocID    = -1;
  cUndefSubID    = -1;

  MinSrchDate    = 1;
  cBlankDate     = 0;
  BlankDate : TStDate = cBlankDate;
  FullDoc        = $FFFF;
  cAllSubs       = -1;
  AllSubs        = cAllSubs; //depricated
  cAnySubId      = AllSubs;
  MaxBuffSize    =  8*1024*1024;
  Zero : LongInt =  0;
  cBlankDocID    =  0;
  cSubNameSize   =  800;
  cMaxBlockID    = 1073741821;

  HostNameSize = 15;

  c_LevelSlash = '\';
  c_LevelSlashStr : AnsiString = '\';
  cWrongEnglishMark = '*'; // ������ ���� ������
  cEmptyEngName : AnsiString = '*';

 (* ����������� ���� ��������� �������� ��������� *)
 minActiveDate : TStDate = 1;
 (* ������������ ���� ��������� �������� ��������� *)
 maxActiveDate : TStDate = High(TStDate);

 c_BoolToByte: array[False..True] of Byte = (0, 1);

const
 {TUserTypeSETS}

  utFullFeatureDocTypes = [utNone, utDoc, utIzm];
  {* - ��������� � ������ ������� ���������}

  utDocTypesHasDoc = utFullFeatureDocTypes + [utBook];
  {* - ��������� ���������� ��� !Doc}

  utDocTypesHasText = cAllUserTypeSet - [utCard];
  {* - ��������� ����� ����� �����}

  utDocTypesHasSpr = utFullFeatureDocTypes + [utBook, utAAK_Cont, utAAK_Doc];
  {* - ��������� ����� ����� �������}

  utDocTypesHasAnno = utFullFeatureDocTypes + [utBook];
  {* - ��������� ����� ����� ���������}

const
 (* ����� ��������� ��������� *)
  dstatChargeFree = $01; // ����������
  dstatNotTM      = $02; // �� ��������� � ������ �������
  dstatNoCompare  = $04; // �� ���������� ��������
  dstatInternet   = $08; // ��������-��������
  dstatHang       = $10; // "��������" �������� (����������� � ���� ��������)

const
 (* ����� ��������� ������������� *)
  pinfClone = $01;

const
  cAllLogActions  = [Low(TLogActionType)..High(TLogActionType)];

  cDocJurLogActions = [acIncluded, acChanged, acAbolished, acLControl, acAnonced];
  {- ����������� �������� ��������� ��� �������� }

  cAnnoJurLogActions = [acAnnoDate];
  {- ����������� �������� ��������� ��� �������� }

  cJurLogActions  = cDocJurLogActions + cAnnoJurLogActions;
  {- ����������� ��������}

  cOrdLogActions  = cAllLogActions - cJurLogActions;
  {- ������������� ��������}

  cAnnoLogActions = cAnnoJurLogActions + [acAnnoWork, acAnnoWasImported, acAnnoWasDeleted];
  {- �������� ���������}

  cDocLogActions = cAllLogActions - cAnnoLogActions - [acRevision];
  {- �������� ���������}

  cSingleJurLogActions = [acIncluded]; // acAbolished, acLControl, acAnonced
  {- ����������� ��������, ������� � ���� �� ��� �� ������}

const
 MainTblsFamily = 0;
 CurrentFamily: Word = 1;

 TblPassW : Array [0..1] of String[8] = ('','corvax');

 FamTblNames : Array [Low(TFamTbls)..High(TFamTbls)] of TTblNameStr =
                ('---', // ��������� �������
                 'FILE','HLINK','SUB','FREE',
                 'DT#1','DT#2','DT#3','DT#5','DT#5E',
                 'DT#6','DT#7','DT#8','DT#9','DT#A',
                 'DT#B','DT#C','DT#D','DT#E','DT#3E',
                 'DT#F','DT#G','DT#GE','DT#I','DT#J',

                 'LNK#1','LNK#2','LNK#3','LNK#4','LNK#5',
                 'LNK#6','LNK#7','LNK#8','LNK#9','LNK#A',
                 'LNK#B','LNK#C','LNK#D','LNK#E',
                 'LNK#F','LNK#G', 'LNK#H', 'LNK#I','LNK#J',
                 'LNK#K',
                 'PRIOR','RENUM','STAGE','LOG',
                 'ACTIV', 'ALARM', 'CTRL',
                 'FILE'{Dup1}, 'FILE'{Dup2});

 FamPassIndex : Array[Low(TFamTbls)..High(TFamTbls)] of Byte =
                (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                 0,0,0,0);

type
 TdtAttrTblPart = (atpMain, atpEQ); //����� ���������� "�����" �� ���������� ������ (������) �� ������� ������� ������� (������ ���������� ������� � ������� �������������)

const
 cAttrTblPartSuffix : array[TdtAttrTblPart] of string = ('', 'E');

 FreeRecCount = 17;
 FreeRecIndex : Array[1..FreeRecCount] of TFamTbls =
                (ftFile,ftHLink,ftDt1,ftDt2,ftDt3,ftDt5,
                 ftDt6,ftDt7,ftDT8,ftDt9,ftDtA,ftDtB,ftDtC,ftDtD,
                 ftDtE,ftDtF,ftDtG);

 MainTblNames : Array [Low(TMainTbls)..High(TMainTbls)] of TTblNameStr =
                 ('ACCESS','PASS','USERS','GUDT','GULNK',
                  'FAMILY','FREE','BB_LOG', 'CTRL', 'REGIONS');

 MainPassIndex : Array[Low(TMainTbls)..High(TMainTbls)] of Byte = (1,1,0,0,0,0,0,1,0,0);

 MainFreeRecCount = 3;
 MainFreeRecIndex : Array[1..MainFreeRecCount] of TMainTbls =
                    (mtUsers,mtGUDt,mtFamily);

 cFictTables = [ftNone, ftCtrl, ftFileDup1, ftFileDup1]; // "�����������" �������, �� �� ����� ���������, ������ � � � 

const
 cMaxRightsMask : TTblMaskRec = (AllowMask: $FFFF; DenyMask: $0000);

const
  cBadRegion = 255;
  cMaxUserID = $00FFFFFF; // ����������� ��������� ����� ������������ (��� ���� �������)
  cDelStation : TStationID = #0#0#0#0#0#0#0#0;
  cDelStationID : Int64 = 0;
  cEmptyByte = High(Byte);

const
// ��������� ��������, ������������ ��������, ����������� ������ ���������� � HyTech ��
 cClearLocksGeneralError        = 1000;

  // �� ������ ����������� ���� ��������, ���������� �������.
 cCLExeFilelNotFound            = cClearLocksGeneralError + 1;
  // ������ ��� �������� ��������, ���������� �������.
 cCLProcessNotStarted           = cClearLocksGeneralError + 2;
  // ������ ��� ���������� ��������, ���������� �������.
 cCLProcessFailed               = cClearLocksGeneralError + 3;
  // ���������� ������� �������� ��������, ���������� �������.
 cCLProcessIsTimedOut           = cClearLocksGeneralError + 4;
  // �������, ��������� �������, �� ������ ���������.
 cThereNoResultOfCLProcess      = cClearLocksGeneralError + 5;
  // �������, ��������� �������, �� ������� ��������� ����������
 cNotEnoughParamsForCLProcess   = cClearLocksGeneralError + 6;
  // �������, ��������� �������, ������� �������� ���� � ���� ������.
 cCLProcessGetWrongFullBasePath = cClearLocksGeneralError + 7;

 //Free Table Names
 NameDictExternalNumber = 'DictExtN';
 ftnDocIDExternal       = 'DOCIDEXT';
 ftnObjIDExternal       = 'OBJIDEXT';
 ftnDocIDForLists       = 'DOCIDLST'; // ��� ��������� DocID ��� ��������� ������� (�:119473985)
 ftnDocIDLawCase        = 'LAWCASE';  // �������� ������� ��� ������������� ��
 ftnDocIDVAS            = 'VASCASE';  // ������������� ���
 ftnDocID1st            = 'SPBDOC';   // ��������� ����� ������ ���������
 ftnDocIDFAS1           = 'FAS1'; // ��� ���
 ftnDocIDFAS2           = 'FAS2'; // ��� ���
 ftnDocIDFAS3           = 'FAS3'; // ��� ���
 ftnDocIDFAS4           = 'FAS4'; // ��� ���
 ftnDocIDFAS5           = 'FAS5'; // ��� ��
 ftnDocIDFAS6           = 'FAS6'; // ��� ���
 ftnDocIDFAS7           = 'FAS7'; // ��� ��
 ftnDocIDFAS8           = 'FAS8'; // ��� ���
 ftnDocIDFAS9           = 'FAS9'; // ��� ���
 ftnDocIDFAS10          = 'FAS10'; // ��� ��
 ftnImgHandle           = 'HIMAGE';

const
 c_SupervisorUserName = 'supervisor'; 


 {��������� ���� � ������� ������}
 function FamTblPrefName(aTable: TFamTbls): AnsiString;
 function TableName(aFamily: TFamilyID; aTblID: Integer; aTblPart : TdtAttrTblPart = atpMain): AnsiString;
 function TablePassword(aFamily: TFamilyID; aTblID : Integer): AnsiString;

implementation
uses
 SysUtils;

const
 scFakeTableUse = '������������� ��������� �������';

function FamTblPrefName(aTable: TFamTbls): AnsiString;
begin
 Assert(aTable <> ftNone, scFakeTableUse);
 Result := FamTblNames[aTable];
end;

function TableName(aFamily: TFamilyID; aTblID: Integer; aTblPart : TdtAttrTblPart = atpMain): AnsiString;
begin
 if aFamily = MainTblsFamily then
  Result := MainTblNames[TMainTbls(aTblID)]
 else
 begin
  Assert(TFamTbls(aTblID) <> ftNone, scFakeTableUse);
  Result := FamTblNames[TFamTbls(aTblID)] + cAttrTblPartSuffix[aTblPart] + IntToHex(aFamily, 3);
 end;
end;

function TablePassword(aFamily: TFamilyID; aTblID : Integer): AnsiString;
begin
 if aFamily = MainTblsFamily then
  Result := TblPassW[MainPassIndex[TMainTbls(aTblID)]]
 else
 begin
  Assert(TFamTbls(aTblID) <> ftNone, scFakeTableUse);
  Result := TblPassW[FamPassIndex[TFamTbls(aTblID)]];
 end;
end;


end.
