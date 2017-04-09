unit ddAppConfigRes;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Библиотека "dd"
// Автор: Люлин А.В.
// Модуль: "w:/common/components/rtl/Garant/dd/ddAppConfigRes.pas"
// Начат: 11.03.2010 18:41
// Родные Delphi интерфейсы (.pas)
// Generated from UML model, root element: <<UtilityPack::Class>> Shared Delphi::dd::AppConfig::ddAppConfigRes
//
// Ресурсы для ddAppConfig
//
//
// Все права принадлежат ООО НПП "Гарант-Сервис".
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ! Полностью генерируется с модели. Править руками - нельзя. !

interface

uses
  l3StringIDEx
  ;

var
  { Локализуемые строки Local }
 str_ddmmSettingsCaption : Tl3StringIDEx = (rS : -1; rLocalized : false; rKey : 'ddmmSettingsCaption'; rValue : 'Настройка конфигурации');
  { 'Настройка конфигурации' }
 str_ddmmErrorCaption : Tl3StringIDEx = (rS : -1; rLocalized : false; rKey : 'ddmmErrorCaption'; rValue : 'Ошибка');
  { 'Ошибка' }

implementation

uses
  l3MessageID
  ;


initialization
// Инициализация str_ddmmSettingsCaption
 str_ddmmSettingsCaption.Init;
// Инициализация str_ddmmErrorCaption
 str_ddmmErrorCaption.Init;

end.