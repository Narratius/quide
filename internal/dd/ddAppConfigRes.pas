unit ddAppConfigRes;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// ���������� "dd"
// �����: ����� �.�.
// ������: "w:/common/components/rtl/Garant/dd/ddAppConfigRes.pas"
// �����: 11.03.2010 18:41
// ������ Delphi ���������� (.pas)
// Generated from UML model, root element: <<UtilityPack::Class>> Shared Delphi::dd::AppConfig::ddAppConfigRes
//
// ������� ��� ddAppConfig
//
//
// ��� ����� ����������� ��� ��� "������-������".
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ! ��������� ������������ � ������. ������� ������ - ������. !

interface

uses
  l3StringIDEx
  ;

var
  { ������������ ������ Local }
 str_ddmmSettingsCaption : Tl3StringIDEx = (rS : -1; rLocalized : false; rKey : 'ddmmSettingsCaption'; rValue : '��������� ������������');
  { '��������� ������������' }
 str_ddmmErrorCaption : Tl3StringIDEx = (rS : -1; rLocalized : false; rKey : 'ddmmErrorCaption'; rValue : '������');
  { '������' }

implementation

uses
  l3MessageID
  ;


initialization
// ������������� str_ddmmSettingsCaption
 str_ddmmSettingsCaption.Init;
// ������������� str_ddmmErrorCaption
 str_ddmmErrorCaption.Init;

end.