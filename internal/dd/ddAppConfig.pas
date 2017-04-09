//..........................................................................................................................................................................................................................................................
{ Класс, хранящий в себе настройки приложения.
  Позволяет не заботиться о создании окна редактирования настроек. }
Unit ddAppConfig;
{ Свойства и настройки приложения. Для упрощения загрузки, сохранения
  и редактирования. }

  { $Id: ddAppConfig.pas,v 1.126 2013/04/22 06:41:52 lulin Exp $ }

// $Log: ddAppConfig.pas,v $
// Revision 1.126  2013/04/22 06:41:52  lulin
// - bug fix: не собиралось.
//
// Revision 1.125  2013/04/19 13:10:10  lulin
// - портируем.
//
// Revision 1.124  2013/04/11 16:46:26  lulin
// - отлаживаем под XE3.
//
// Revision 1.123  2013/02/04 11:27:28  kostitsin
// [$278837685]
//
// Revision 1.122  2012/10/29 09:37:28  kostitsin
// [$407142586]
//
// Revision 1.121  2012/09/18 11:20:56  kostitsin
// убираю лишнее
//
// Revision 1.120  2012/04/09 08:41:24  lulin
// {RequestLink:237994598}
// - думаем о VGScene.
//
// Revision 1.119  2012/02/15 12:57:09  narry
// Обновление
//
// Revision 1.118  2011/10/13 08:43:31  narry
// Накопившиеся изменения
//
// Revision 1.117  2011/06/17 12:28:22  lulin
// {RequestLink:228688486}.
//
// Revision 1.116  2011/06/06 14:42:31  lulin
// {RequestLink:268345098}.
// - чистим код.
//
// Revision 1.115  2010/07/20 12:28:21  narry
// К226003904
//
// Revision 1.114  2010/03/19 14:00:31  narry
// - криво читались, писались элементы вложенных списков
//
// Revision 1.113  2010/03/16 11:42:22  narry
// - корректная запись вложенных заданий
//
// Revision 1.112  2010/03/15 18:08:41  lulin
// {RequestLink:196969151}.
//
// Revision 1.111  2010/03/15 14:43:39  lulin
// - вычищаем невостребованное.
//
// Revision 1.110  2010/03/15 13:07:57  lulin
// [$197494663].
// Вычищаем невостребованное.
//
// Revision 1.109  2010/03/15 11:53:14  lulin
// {RequestLink:196969151}.
//
// Revision 1.108  2010/03/10 13:57:24  narry
// - не собиралось
//
// Revision 1.107  2009/03/13 15:08:35  narry
// - показ окошка узла по его имени
//
// Revision 1.106  2009/02/10 14:07:47  narry
// - обновление
//
// Revision 1.105  2009/01/23 15:48:02  narry
// - версия настроек
// - механизм преобразования настроек
//
// Revision 1.104  2009/01/20 14:38:15  narry
// - рефакторинг и исправление ошибок
//
// Revision 1.103  2008/10/23 09:41:31  narry
// - Элемент-контейнер
// - префикс для шифрованных строк
//
// Revision 1.102  2008/10/03 07:06:14  narry
// - рефакторинг
//
// Revision 1.101  2008/08/18 12:39:51  narry
// - внутреннее поле стало свойством
//
// Revision 1.100  2008/07/28 09:55:15  fireton
// - автоподстановка периодичности заданий
// - required типы заданий
//
// Revision 1.99  2008/07/25 12:50:15  narry
// - обновление
//
// Revision 1.98  2008/07/25 12:34:39  narry
// - уточнение незаполненного параметра
//
// Revision 1.97  2008/07/24 15:06:18  narry
// - развитие работы с Required элементами
//
// Revision 1.96  2008/07/23 14:14:38  narry
// - дополнительный метод обработки узла по окончании редактирования
//
// Revision 1.95  2008/06/06 15:06:12  narry
// - обновление
//
// Revision 1.94  2008/05/14 10:40:30  narry
// - новый элемент - разделитель
//
// Revision 1.93  2008/04/23 07:27:19  narry
// - переделки для сервиса
//
// Revision 1.92  2008/03/13 14:33:08  narry
// - возможность создавать группу без алиаса
//
// Revision 1.91  2008/03/03 13:03:34  narry
// - автосохранение изменений
//
// Revision 1.90  2008/02/27 16:01:28  narry
// - начало реализации позиционирования на незаполненный элемент
//
// Revision 1.89  2008/02/19 16:03:31  narry
// - возможность задать положение метки для всей закладки
//
// Revision 1.88  2008/02/06 09:30:50  lulin
// - базовые списки объектов выделяем в отдельные файлы.
//
// Revision 1.87  2008/01/28 15:21:37  lulin
// - используем "кошерный" список.
//
// Revision 1.86  2007/12/26 11:14:19  lulin
// - cleanup.
//
// Revision 1.85  2007/12/25 23:55:55  lulin
// - модуль l3Tree_TLB полностью перенесен на модель.
//
// Revision 1.84  2007/11/16 08:22:20  narry
// - новое свойство у списка - количество столбцов
//
// Revision 1.83  2007/09/28 05:35:16  narry
// - элемент список строк
//
// Revision 1.82  2007/08/14 19:31:52  lulin
// - оптимизируем очистку памяти.
//
// Revision 1.81  2007/07/25 10:43:34  narry
// - Элементы, вложенные в группу не сохраняли изменения
//
// Revision 1.80  2007/04/13 08:25:21  lulin
// - bug fix: были забыты спецификаторы константности.
//
// Revision 1.79  2007/04/13 08:19:54  lulin
// - bug fix: были забыты спецификаторы константности.
//
// Revision 1.78  2007/04/13 08:03:54  lulin
// - bug fix: были забыты спецификаторы константности.
//
// Revision 1.77  2007/04/13 07:53:44  lulin
// - bug fix: неправильно позиционировались на предыдущий узел.
//
// Revision 1.76  2007/04/09 13:38:07  oman
// - fix: Неправильно ставили видимость узла конфигурации (cq24949)
//
// Revision 1.75  2007/04/06 14:44:00  lulin
// - используем строки с кодировкой.
//
// Revision 1.74  2007/04/06 14:37:13  lulin
// - используем родное дерево.
//
// Revision 1.73  2007/02/12 16:40:34  lulin
// - переводим на строки с кодировкой.
//
// Revision 1.72  2007/02/07 17:48:45  lulin
// - избавляемся от копирования строк при чтении из настроек.
//
// Revision 1.71  2007/01/19 14:35:22  oman
// - new: Локализация библиотек - dd (cq24078)
//
// Revision 1.70  2006/04/24 06:06:31  oman
// - fix: Неправильно определялась доступность подчиненных контролов
//  от мастер-комбобокса (cq20602)
//
// Revision 1.69  2006/04/03 11:58:30  oman
// - new beh: Поддержка механизма мап "строка для отображения в UI"-<нечто>
//  при редактировании настроек.
//
// Revision 1.68  2005/12/07 10:42:34  demon
// - ошибка: сбрасывалаь высота панели кнопок в момент расчета размеров формы
//
// Revision 1.67  2005/12/07 10:21:17  narry
// - исправление: попытка сделать правильный расчет размеров формы
//
// Revision 1.66  2005/12/02 09:06:13  mmorozov
// - bugfix: было потеряно полезное увеличение высоты;
//
// Revision 1.65  2005/12/01 15:08:16  mmorozov
// - opt: GetChanged;
//
// Revision 1.64  2005/12/01 11:33:10  narry
// - обновление
//
// Revision 1.63  2005/03/09 13:48:11  am
// new: MakeNodeVisible - сделать видимой ноду из дерева настроек
//
// Revision 1.62  2005/03/09 12:45:30  am
// change: доп. параметр в _AddComboBoxItem - aMasterIndex. при выборе элемента с этим индексом, зависимые компоненты дизейблятся
//
// Revision 1.61  2005/03/02 16:26:28  narry
// - update
//
// Revision 1.60  2005/03/01 11:13:58  am
// new: _AddComboBoxItem
//
// Revision 1.59  2005/02/25 14:43:40  mmorozov
// bugfix: точно вычисляем размер формы настроек, избавляемся от чисел с "потолка";
// new: TddAppConfiguration properties FormMinHeight, FormMinWidth;
//
// Revision 1.58  2005/02/08 16:41:43  narry
// - bug fix: Range check при создании элемента редактирования числового значения
//
// Revision 1.57  2005/01/31 06:52:49  mmorozov
// new: можно создавать вложенные группы;
//
// Revision 1.56  2005/01/20 12:42:48  mmorozov
// change: для настройки типа число используются другие компоненты;
// new: контроль правильности введенных значений, вывод сообщения пользователю, позиционирование фокуса в компоненте с неверным значением;
//
// Revision 1.55  2005/01/17 11:02:36  mmorozov
// - warnings fix;
//
// Revision 1.54  2005/01/14 17:21:26  mmorozov
// - реализация MasterSlaveConfigItem;
//
// Revision 1.53  2005/01/14 09:32:26  mmorozov
// change: TddVisualConfigItem -> TddBaseVisualConfigItem;
//
// Revision 1.52  2005/01/14 09:20:56  narry
// - update: рефакторинг в преддверии добавления нового класса
//
// Revision 1.51  2005/01/08 09:21:55  mmorozov
// new: в определении максимальной высоты и ширины формы не участвуют узлы у которых определены полосы прокрутки (TddCustomConfigNode.ScrollBars);
//
// Revision 1.50  2004/10/26 11:34:17  narry
// - update: чтение-установка позиции в дереве
//
// Revision 1.49  2004/09/30 07:55:43  mmorozov
// new behaviour: в _FillDialog устанавливаем фокус в дереве;
//
// Revision 1.48  2004/09/10 14:27:33  narry
// - update
//
// Revision 1.47  2004/09/10 12:34:28  mmorozov
// change: сигнатура _AddComboBoxItem;
//
// Revision 1.46  2004/09/09 12:29:14  narry
// - update: отображение подсказки
//
// Revision 1.45  2004/08/31 08:13:37  narry
// - update
//
// Revision 1.44  2004/08/31 07:50:43  narry
// - bug fix: AV при вызове окна, закрытого по Cancel
// - update: восстановлена функциональность запоминания индекса узла, на котором закрыто окно
//
// Revision 1.43  2004/08/24 09:08:48  mmorozov
// new: property TddAppConfiguration.Enabled;
//
// Revision 1.42  2004/07/08 14:37:05  mmorozov
// new: property TddAppConfiguration.ComboBoxStyle;
//
// Revision 1.41  2004/06/24 10:54:02  mmorozov
// new: types TddCaptionPanelType, TddCaptionPanelTypes;
// new: можно настраивать вид панели названия;
// change: сигнатура _FillDialog;
//
// Revision 1.40  2004/06/21 15:24:27  mmorozov
// bugfix: TddAppConfiguration.GetChanged;
//
// Revision 1.39  2004/06/21 15:09:37  narry
// - update: добавление функциональности узлу и конфигуратору (поле Changed у узла)
//
// Revision 1.38  2004/06/10 16:09:34  narry
// - bug fix: неправильное выравнивание IntegerItem
// - update
//
// Revision 1.37  2004/06/10 14:12:13  mmorozov
// new: TddAppConfiguration.Place;
//
// Revision 1.36  2004/06/09 14:17:03  mmorozov
// new: methods AddButtonItem, GetAliasName;
//
// Revision 1.35  2004/06/08 12:12:52  mmorozov
// bugfix: method TddAppConfiguration.GetChanged;
//
// Revision 1.34  2004/06/08 10:35:50  narry
// - new property: Changed
//
// Revision 1.33  2004/06/08 06:22:50  fireton
// - bug fix: хитрая подхачка против беспредела Windows
//
// Revision 1.32  2004/06/07 11:20:52  narry
// - change: сохраняются лишь измененные значения
//
// Revision 1.31  2004/06/04 15:50:31  mmorozov
// change: сигнатура TddAppConfiguration._FillDialog;
//
// Revision 1.30  2004/06/04 14:52:08  mmorozov
// change: в вызовах функций используем вместо TForm -> TCustomForm;
//
// Revision 1.29  2004/06/04 09:27:51  narry
// - bug fix: Не очищались ссылки на элементы ввода после уничтожения окна
//
// Revision 1.28  2004/06/03 12:27:10  narry
// - update: новая идеология окна конфигурации
//
// Revision 1.27  2004/06/01 08:52:18  narry
// - update: борьба с предупреждениями - функция не возвращает значение
//
// Revision 1.26  2004/05/31 18:14:46  demon
// - warning fix
//
// Revision 1.25  2004/05/31 14:55:01  mmorozov
// new: method TddAppConfiguration.AddMapValue;
// new: property TddAppConfiguration.SaveAsString;
// new: в методе TddAppConfiguration.Add поддержан TddMapValueConfigItem;
//
// Revision 1.24  2004/05/29 13:04:27  mmorozov
// new: method TddAppConfiguration._AddComboBoxItem;
// new: property TddAppConfiguration.DialogCaption;
// new: необязательный параметр aCaption в методе TddAppConfiguration.ShowDialog;
//
// Revision 1.23  2004/05/07 10:14:38  narry
// - bug fix: неправильное вычисление размера при AutoSize
//
// Revision 1.22  2004/04/29 13:22:24  narry
// - update and bug fix
//
// Revision 1.21.2.3  2004/04/28 13:40:19  narry
// - update and bug fix
//
// Revision 1.21.2.2  2004/04/21 15:43:53  narry
// - update
// - bug fix: не "выключались" дополнительные элементы строковых элементов
//
// Revision 1.21.2.1  2004/03/16 16:58:41  narry
// - update: переделка с _TPanel на TFrame
//
// Revision 1.21  2004/03/16 14:26:17  narry
// - update
//
// Revision 1.20  2004/03/11 14:15:29  narry
// - bug fix: AV при закрытии окна конфигурации по кнопке ОК
// - bug fix: неправильная длина элемента IntegerConfigItem
//
// Revision 1.19  2004/03/10 15:33:15  narry
// - update: замена содержимым ветки
//
// Revision 1.18.2.4  2004/03/09 16:57:00  narry
// - update: продолжение рефакторинга, на 90% восстановлена былая функциональность
//
// Revision 1.18.2.3  2004/03/05 15:04:26  narry
// - update: восстановлен TRadioGroup, снято ограничение с размера формы в режиме AutoSize
//
// Revision 1.18.2.2  2004/03/04 17:53:52  narry
// - update: продолжение рефакторинга, на 80% восстановлена былая функциональность
//
// Revision 1.18.2.1  2004/03/03 17:18:44  narry
// - update: продолжение рефакторинга
//
// Revision 1.18  2004/02/24 14:28:43  narry
// - update
//
// Revision 1.17  2004/02/24 13:35:43  narry
// - new: использование PasswordChar для ввода "секретных" строк
//
// Revision 1.16  2004/02/20 16:42:26  narry
// - add: новый тип элемента dd_citFont
//
// Revision 1.15  2004/02/19 13:10:40  narry
// - add: возможность изменять свойства последнему добавленному элементу (расположение метки, максимальное, минимальное значение)
//
// Revision 1.14  2004/02/18 15:29:20  narry
// - update:
//
// Revision 1.13  2004/02/18 14:06:51  narry
// - update: продолжение документирования классов
//
// Revision 1.12  2004/02/17 15:08:11  narry
// - update: первое приближение свойства AutoSize
//
// Revision 1.11  2004/02/16 11:11:45  narry
// - new: новые типы элементов - цвет и имя шрифта
// - cleanup
//
// Revision 1.10  2004/02/13 11:03:10  narry
// - new: ClearNode - для добавление невизуальных свойств
//
// Revision 1.9  2004/02/09 10:46:56  narry
// - bug fix: не учитывался статус главного элемента для определения доступности подчиненного
//
// Revision 1.8  2004/02/09 09:11:45  narry
// - new: добавление элементов без создания узла означает создание невизуальных элементов, которые не отображаются в окне настройки и сохраняются
//
// Revision 1.7  2004/02/06 17:14:37  narry
// - add: новое свойство AutoSize - подгонка размеров окна конфигурации под количество элементов
//
// Revision 1.6  2004/02/06 17:11:47  narry
// - bug fix: не сохранялились и не загружались значения для типа dd_citRadio
// - add: новый тип элемента dd_citRadioGroup
//
// Revision 1.5  2004/02/04 14:23:40  narry
// - new: значение по умолчанию
//
// Revision 1.4  2004/02/04 12:23:00  narry
// - update: очередной шаг к совершенству
//
// Revision 1.3  2004/01/22 17:58:20  narry
// - update: начало реализации редактирования элементов списка
//
// Revision 1.2  2003/12/01 15:20:34  narry
// - cleanup
// - bug fix: Integer overflow при формировании номера блока глубокой вложенности
// -change: переименование пункта "Произвольно" в "Больше пяти уровней" и перенос его в конец списка
//
// Revision 1.1  2003/11/19 17:55:19  narry
// - new: хранение и отображение настроек приложения
//

interface

{$Include l3Define.inc}

uses
  Classes, Controls, Forms, Contnrs, Graphics,

  StdCtrls,

  l3Interfaces,
  l3Tree_TLB,
  l3Nodes,
  l3Base,
  l3ObjectList,

  vtOutliner,
  ddAppConfigTypes, ddConfigStorages, ddAppConfigWFrame,
  ddAppConfigDataAdapters, ddAppConfigConst, ddAppConfigStrings, ddAppConfigVersions;

type
  TddAppDialogOptions = set of (dd_doNoButtons);

  TddCaptionPanelType = (
  {* - настройка вида панели названия узла. }
   cptNormalBevel
     {* - установить панели, с именем узла в дереве, BevelWidth = 1. }
   );

  TddCaptionPanelTypes = set of TddCaptionPanelType;
  {* - набор настроек вида панели. }

  TddErrorShowEvent = procedure(aSender        : TObject;
                                const aMessage : AnsiString) of Object;
    {* - событие вызываемое при исключительной ситуации.
       Параметры:
         aItem  - элемент с ошибкой.
         aFocus - устанавливаеть фокус в элементе с ошибкой. }

  TddAppRequiredEvent = procedure (aNode: TddCustomConfigNode; var Resolved: Boolean) of Object;

  TddAppConfiguration = class(TObject)
  private
    FAutoSize: Boolean;
    FDialogIndex: Integer;
    FDialogOptions: TddAppDialogOptions;
    FFontName: AnsiString;
    FUseNodeNames: Boolean;
    FUseScrollbars: Boolean;
    f_AliasNameIndex: Integer;
    f_AutoSave: Boolean;
    f_ButtonsPanel: TFrame;
    f_ConfigTree: TvtCustomOutliner;
    f_CurItem: TddBaseConfigItem;
    f_Dialog: TForm;
    f_DialogCaption: AnsiString;
    f_Items: TStrings;
    f_Root: TddAppConfigNode;
    f_SaveChanged: Boolean;
    f_Selected: TddCustomConfigNode;
    f_Storage: IddConfigStorage;
    f_OnError: TddErrorShowEvent;
    f_Groups: Tl3ObjectList;
    f_FormMinHeight: Integer;
    f_FormMinWidth: Integer;
    f_IsNode: Boolean;
    f_LabelTop: Boolean;
    f_OnRequiredEvent: TddAppRequiredEvent;
    f_RequiredMessage: AnsiString;
    f_RequiredNode: TddCustomConfigNode;
    f_Versions: TddAppConfigVersionManager;
    f_WorkFrame: TWorkFrame;
    function AddChildNode(aNode: TddCustomConfigNode): TddCustomConfigNode;
            overload;
    procedure AddNode(aNode: TddCustomConfigNode); overload;
    procedure CalculateConstants(theTree, theWork, theButtons: TFrame);
    procedure CheckEnabledStatus;
    function CheckRequiredValues: Boolean;
    procedure CheckVersion(aStorage: IddConfigStorage);
    procedure ClearControls;
    procedure CreateComponents(theTree: TvtCustomOutliner; theParent: TWinControl);
    procedure CreateTree(const aTree: TddCustomConfigNode; theTree: TvtCustomOutliner);
    function GetAllowTest: Boolean;
    function GetAsBoolean(const Alias: AnsiString): Boolean;
    function GetAsDateTime(const Alias: AnsiString): TDateTime;
    function GetAsInteger(const Alias: AnsiString): Integer;
    function GetAsObject(const Alias: AnsiString): TObject;
    function GetAsString(const Alias: AnsiString): AnsiString;
    function GetChanged: Boolean;
    function GetComboBoxStyle: TComboBoxStyle;
    function GetEnabled: Boolean;
    function GetFilter: AnsiString;
    function GetHint: AnsiString;
    function GetLabelTop: Boolean;
    function GetLastItem: TddBaseConfigItem;
    function GetMaxValue: Integer;
    function GetMinValue: Integer;
    function GetPasswordChar: Char;
    function GetPlace: TButtonPlace;
    function GetTestButtonCaption: AnsiString;
    function GetValues(const Alias: AnsiString): TddConfigValue;
    procedure RecalcFormSize(aForm: TCustomForm);
    procedure SetAllowTest(Value: Boolean);
    procedure SetAsBoolean(const Alias: AnsiString; const Value: Boolean);
    procedure SetAsDateTime(const Alias: AnsiString; const Value: TDateTime);
    procedure SetAsInteger(const Alias: AnsiString; const Value: Integer);
    procedure SetAsObject(const Alias: AnsiString; Value: TObject);
    procedure SetAsString(const Alias: AnsiString; const Value: AnsiString);
    procedure SetChanged(Value: Boolean);
    procedure SetComboBoxStyle(const Value: TComboBoxStyle);
    procedure SetDialogCaption(const Value: AnsiString);
    procedure SetEnabled(const Value: Boolean);
    procedure SetFilter(const Value: AnsiString);
    procedure SetHint(const Value: AnsiString);
    procedure SetLabelTop(Value: Boolean);
    procedure SetMaxValue(Value: Integer);
    procedure SetMinValue(Value: Integer);
    procedure SetPasswordChar(Value: Char);
    procedure SetPlace(const Value: TButtonPlace);
    procedure SetTestButtonCaption(const Value: AnsiString);
    procedure SetValues(const Alias: AnsiString; Value: TddConfigValue);
    procedure DoError(const aMessage : AnsiString;
                      aItem          : TddVisualConfigItem);
    procedure DoFocus(aItem : TddVisualConfigItem);
    function pm_GetColumns: Integer;
    function pm_GetDialogIndex: Integer;
    function pm_GetHelpContext: Integer;
    function pm_GetIsEmpty(Alias: AnsiString): Boolean;
    function pm_GetIsValid: Boolean;
    function pm_GetPathFill: TddFillType;
    function pm_GetRequired: Boolean;
    function pm_GetVersion: Integer;
    procedure pm_SetColumns(const aValue: Integer);
    procedure pm_SetDialogIndex(const aValue: Integer);
    procedure pm_SetFormMinHeight(const Value: Integer);
    procedure pm_SetFormMinWidth(const Value: Integer);
    procedure pm_SetHelpContext(const aValue: Integer);
    procedure pm_SetPathFill(const aValue: TddFillType);
    procedure pm_SetRequired(const Value: Boolean);
    procedure pm_SetVersion(const aValue: Integer);
    procedure SetFontName;
    procedure SetUseScrollbars(const Value: Boolean);
    procedure WorkupChanged;
  public
    constructor Create(const aStorage: IddConfigStorage = nil);
    destructor Destroy; override;
    function FindNode(aItem : TddBaseConfigItem) : TddCustomConfigNode;
    procedure Add(const aItemName: AnsiString);
    procedure AddAlias(const aAlias: AnsiString);
    function AddBooleanItem(const aAlias, aCaption: Il3CString; aDefault: Boolean =
            False; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
    function AddButtonItem(const aCaption: AnsiString; aClick: TNotifyEvent;
            aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
    procedure AddCaptionElement(const aCaption: AnsiString; const aAliasPrefix:
            AnsiString = '');
    function AddChild(const aAlias, aCaption: AnsiString): TddCustomConfigNode;
            overload;
    function AddColorItem(const aAlias, aCaption: AnsiString; aDefault: TColor =
            clBlack; aMasterItem: TddBaseConfigItem = nil):
            TddBaseConfigItem;
    function AddComboBoxItem(const aAlias, aCaption: Il3CString; aDefaultValue:
            Integer; aValueMap: Il3ValueMap = nil; aMasterItem: TddBaseConfigItem = nil;
            aMasterIndex: Integer = -1):
            TddBaseConfigItem;
            overload;
    function AddComboBoxItem(const aAlias, aCaption: Il3CString; const aDefaultValue:
            Il3CString; aValueMap: Il3ValueMap = nil; aMasterItem: TddBaseConfigItem = nil;
            aMasterIndex: Integer = -1):
            TddBaseConfigItem;
            overload;
    function AddComboBoxItem(const aAlias, aCaption: Il3CString; aDefaultValue:
            TddConfigValue; aValueMap: Il3ValueMap = nil; aMasterItem: TddBaseConfigItem = nil;
            aMasterIndex: Integer = -1):
            TddBaseConfigItem;
            overload;
    function AddDateItem(const aAlias, aCaption: AnsiString; aDefault: TDateTime =
            0; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
            overload;
    function AddFileNameItem(const aAlias, aCaption: AnsiString; const aDefault: AnsiString =
            ''; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
            overload;
    function AddFolderNameItem(const aAlias, aCaption: AnsiString; const aDefault: AnsiString
            = ''; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
            overload;
    function AddFontItem(const aAlias, aCaption: AnsiString; aDefault: TFont = nil;
            aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
    function AddGroupItem(const aAlias, aCaption: AnsiString; aMasterItem:
            TddBaseConfigItem = nil): TddBaseConfigItem; overload;
    function AddIntegerItem(const aAlias, aCaption: Il3CString; aDefault: Integer =
            0; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
            overload;
    function AddItem(aNode: TddCustomConfigNode; aItem: TddBaseConfigItem):
            TddBaseConfigItem; overload;
    function AddListItem(const aAlias, aCaption: AnsiString; aDataAdapter:
            TddBaseConfigDataAdapter; aMasterItem: TddBaseConfigItem = nil):
            TddBaseConfigItem;
    function AddStringsItem(const aAlias, aCaption: AnsiString; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
    procedure AddMapValue(const aCaption : AnsiString; aValue         : Integer);
    function AddNode(const aAlias, aText: AnsiString): TddCustomConfigNode; overload;
    function AddRadioGroupItem(const aAlias, aCaption: AnsiString; aDefault:
            Integer = -1; aMasterItem: TddBaseConfigItem = nil):
            TddBaseConfigItem;
    {$IfNDef Nemesis}
    function AddSoundFileNameItem(const aAlias, aCaption: AnsiString; const aDefault:
            AnsiString = ''; aMasterItem: TddBaseConfigItem = nil):
            TddBaseConfigItem;
    {$EndIf  Nemesis}
    function AddStringItem(const aAlias, aCaption: AnsiString; const aDefault: AnsiString =
            ''; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
            overload;
    {$IfNDef Nemesis}
    function AddTimeItem(const aAlias, aCaption: AnsiString; aDefault: TDateTime =
            0; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
    {$EndIf  Nemesis}
    function AddMasterSlaveItem(const Alias : AnsiString;
     const aCaption : AnsiString) : TddBaseConfigItem;
    function AddCheckListItem(const aAlias, aCaption: AnsiString; aDefault: Integer =
        -1; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
    function AddChild(const aCaption: AnsiString): TddCustomConfigNode; overload;
    procedure AddDivider(aCaption: AnsiString);
    function AddGroupItem(const aCaption: AnsiString; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem; overload;
    function AddContainerGroup(const aAlias, aCaption: AnsiString; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
        overload;
    procedure AddVersionHandler(aFromVersion, aToVersion: Integer; aProc: Tdd_acVersionUpgradeProc);
    function AddItem(aItem: TddBaseConfigItem): TddBaseConfigItem; overload;
    function AddSimpleListItem(const aAlias, aCaption: AnsiString; aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
    procedure CloseMasterSlaveItem;
    procedure AddUserNode(aNode: TddCustomConfigNode; AsChild: Boolean = False);
    procedure AdjustFormSize(aForm: TCustomForm; aOptions: TddAppDialogOptions);
    procedure ClearNode;
    procedure CloseChild;
    procedure CloseGroup;
    procedure MakeNodeVisible(aNode: TddCustomConfigNode);
    procedure FillDialog(aForm : TCustomForm; const aOptions :
            TddAppDialogOptions = []; const aCaptionPanelTypes : TddCaptionPanelTypes = []);
    function GetAliasName(const aAliasMask: AnsiString = 'AliasName'): AnsiString;
    {1 Проверяет наличие элемента с указанным псевдонимом }
    function HasValue(const aAlias: AnsiString): Boolean; overload;
    {1 Проверяет наличие элемента с указанным псевдонимом и возвращает индекс
            эелемнта, если таковой имеется }
    function HasValue(const aAlias: AnsiString; out theItem: TddBaseConfigItem): Boolean; overload;
    procedure Load(aStorage: IddConfigStorage = nil);
    procedure LoadStructure(aStream: TStream);
    function ReadValuesFromDialog(const aRead: Boolean = True) : Boolean;
    procedure ReloadDefault;
    procedure Save(aStorage: IddConfigStorage = nil);
    procedure SaveStructure(aStream: TStream);
    function ShowDialog(const aCaption: AnsiString = ''; aValidate: Boolean = False): Boolean;
    function ShowNodeDialog(const aAlias: AnsiString): Boolean;
    property AllowTest: Boolean read GetAllowTest write SetAllowTest;
    property AsBoolean[const Alias: AnsiString]: Boolean read GetAsBoolean write
            SetAsBoolean;
    property AsDateTime[const Alias: AnsiString]: TDateTime read GetAsDateTime write
            SetAsDateTime;
    property AsInteger[const Alias: AnsiString]: Integer read GetAsInteger write
            SetAsInteger;
    property AsObject[const Alias: AnsiString]: TObject read GetAsObject write
            SetAsObject;
    property AsString[const Alias: AnsiString]: AnsiString read GetAsString write SetAsString;
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    {1 Состояние всех элементов кофигурации }
    property Changed: Boolean read GetChanged write SetChanged;
    property ComboBoxStyle: TComboBoxStyle read GetComboBoxStyle write
            SetComboBoxStyle;
    property DialogCaption: AnsiString read f_DialogCaption write SetDialogCaption;
    property DialogIndex: Integer read pm_GetDialogIndex write pm_SetDialogIndex;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property Filter: AnsiString read GetFilter write SetFilter;
    property FontName: AnsiString read FFontName write FFontName;
    {1 Текст всплывающей подсказки для активного элемента }
    {{
    Активным элементом считается последний добавленный в конфигурацию.
    }
    property Hint: AnsiString read GetHint write SetHint;
    property Items: TStrings read f_Items;
    property LabelTop: Boolean read GetLabelTop write SetLabelTop;
    property LastItem: TddBaseConfigItem read GetLastItem;
    property MaxValue: Integer read GetMaxValue write SetMaxValue;
    property MinValue: Integer read GetMinValue write SetMinValue;
    property PasswordChar: Char read GetPasswordChar write SetPasswordChar;
    property Place: TButtonPlace read GetPlace write SetPlace;
    property SaveChanged: Boolean read f_SaveChanged write f_SaveChanged;
    property TestButtonCaption: AnsiString read GetTestButtonCaption write
            SetTestButtonCaption;
    property Values[const Alias: AnsiString]: TddConfigValue read GetValues write
            SetValues;
    property OnErrorShow : TddErrorShowEvent read f_OnError write f_OnError;
    property OnRequiredEvent: TddAppRequiredEvent read f_OnRequiredEvent write f_OnRequiredEvent;
    property AutoSave: Boolean read f_AutoSave write f_AutoSave;
    property ButtonsPanelHeight: Integer read f_FormMinHeight write
        pm_SetFormMinHeight;
    property Columns: Integer read pm_GetColumns write pm_SetColumns;
    property DialogOptions: TddAppDialogOptions read FDialogOptions write
        FDialogOptions;
    property FormMinWidth : Integer read f_FormMinWidth write pm_SetFormMinWidth;
    property HelpContext: Integer read pm_GetHelpContext write pm_SetHelpContext;
    property IsEmpty[Alias: AnsiString]: Boolean read pm_GetIsEmpty;
    property IsValid: Boolean read pm_GetIsValid;
    property PathFill: TddFillType read pm_GetPathFill write pm_SetPathFill;
    property Required: Boolean read pm_GetRequired write pm_SetRequired;
    property RequiredMessage: AnsiString read f_RequiredMessage write f_RequiredMessage;
    property UseNodeNames: Boolean read FUseNodeNames write FUseNodeNames;
    property UseScrollbars: Boolean read FUseScrollbars write SetUseScrollbars;
    property Version: Integer read pm_GetVersion write pm_SetVersion;
  end;//TddAppConfiguration

  IddCNode = interface(Il3Base)
    ['{2DA3C151-0925-48D7-8E36-A1F3D8B07EA6}']
      function Control: TddCustomConfigNode;
        {-}
  end;//IddCNode

  TddCNode = class(Tl3UsualNode, IddCNode)
    private
    // internal fields
      f_Node : TddCustomConfigNode;
    protected
    // internal methods  
      function Control: TddCustomConfigNode;
        {-}
    public
    // public methods
      constructor Create(aNode: TddCustomConfigNode);
        reintroduce;
        {-}
      class function Make(aNode: TddCustomConfigNode): Il3Node;
        reintroduce;
        {-}
  end;//TddCNode

var
 ddAppConfiguration: TddAppConfiguration = nil;

implementation

Uses
 SysUtils, Math, Windows,

 l3Defaults,
 l3TreeInterfaces,
 l3String,

 {$IfNDef Nemesis}
 ddIniStorage,
 {$EndIf  Nemesis}
 ddAppConfigTFrame,
 ddAppConfigBFrame, 
 ddUtils,
 Dialogs,

 ddAppResource, ddAppConfigLists, ddAppConfigDates, afwVCL, ddAppConfigUtils,

 ddAppConfigRes
 ;


const
  cFormMinWidth  = 4*75 + 5*12; // ширина кнопок + расстояния между ними
  cFormMinHeight = 104; // высота панели кнопок + Высота заголовка

{
***************************** TddAppConfiguration ******************************
}
constructor TddAppConfiguration.Create(const aStorage: IddConfigStorage = nil);
{$IfNDef Nemesis}
var
  l_Storage: TddIniStorage;
{$EndIf  Nemesis}
begin
  inherited Create;
  f_Groups := Tl3ObjectList.Make;
  f_AliasNameIndex := 0;
  f_DialogCaption := str_ddmmSettingsCaption.AsStr;
  SetFontName;
  f_Versions:= TddAppConfigVersionManager.Create(nil);
  f_Root:= TddAppConfigNode.Create('Configuration', Application.Title);
  f_Items:= TStringList.Create;
  AddIntegerItem(l3CStr('_DialogIndex'), l3CStr('Закладка в окошке'), -1);
  AddIntegerItem(l3CStr('_Version'), l3CStr('Версия настроек'), 1);
  if (aStorage <> nil) then
   f_Storage:= aStorage
  else
  begin
   {$IfNDef Nemesis}
   l_Storage:= TddIniStorage.Create(ChangeFileExt(Application.ExeName, '.ini'));
   try
    f_Storage:= l_Storage;
   finally
    l_Storage.Free;
   end;//try..finally
   {$Else   Nemesis}
   Assert(false);
   {$EndIf  Nemesis}
  end;//aStorage <> nil
  f_FormMinWidth := cFormMinWidth;
  FUseNodeNames := False;
  f_LabelTop:= True;
  AutoSave:= False;
end;

destructor TddAppConfiguration.Destroy;
begin
 if AutoSave then
  Save;
 FreeAndNil(f_Versions); 
 FreeAndNil(f_Groups);
 FreeAndNil(f_Items);
 FreeAndNil(f_Root);
 f_Storage := nil;
 inherited;
end;

function TddAppConfiguration.FindNode(aItem : TddBaseConfigItem) : TddCustomConfigNode;

  function DoNode(const aNode: Il3Node): Boolean;
  var
   l_C : TddCustomConfigNode;
  begin
   Result := false;
   l_C := (aNode As IddCNode).Control;
   if l_C.IsItem(aItem) then
   begin
    FindNode := l_C;
    Result := true;
   end;//l_C.IsItem(aItem)
  end;

  procedure _FindNode(aNode: TddCustomConfigNode);
  var
   i: Integer;
  begin
   if aNode.IsItem(aItem) then
    Result:= aNode
   else
    for i:= 0 to aNode.ChildrenCount -1 do
    begin
     _FindNode(aNode.Childrens[i]);
     if Result <> nil then
      break;
    end;
  end;

begin
 Result := nil;
 if f_ConfigTree <> nil then
  f_ConfigTree.CTree.IterateF(l3L2NA(@DoNode), imCheckResult)
 else
  _FindNode(f_Root);
end;

procedure TddAppConfiguration.Add(const aItemName: AnsiString);
begin
  if LastItem is TddRadioGroupConfigItem then
   TddRadioGroupConfigItem(LastItem).Add(aItemName)
  else
  if LastItem is TddMapValueConfigItem then
   TddMapValueConfigItem(LastItem).Item := aItemName;
end;

procedure TddAppConfiguration.AddAlias(const aAlias: AnsiString);
var
 l_Item: TddBaseConfigItem;
begin
 l_Item := nil;
 if f_CurItem is TddMasterSlaveConfigItem then
  l_Item := (f_CurItem as TddMasterSlaveConfigItem).AddAlias(aAlias);
 Assert(Assigned(l_Item), 'Элемент не был создан.');
 f_Items.AddObject(l_Item.Alias, l_Item);
 l_Item.AbsoluteIndex:= f_Items.IndexOfObject(l_Item);
end;

function TddAppConfiguration.AddBooleanItem(const aAlias, aCaption: Il3CString;
        aDefault: Boolean = False; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
  l3FillChar(l_Default, SizeOf(l_Default), 0);
   l_Default.Kind:= dd_vkBoolean;
   l_Default.AsBoolean:= aDefault;
   Result:= TddBooleanConfigItem.Create(l3Str(aAlias), l3Str(aCaption), l_Default, aMasterItem);
   AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddButtonItem(const aCaption: AnsiString; aClick:
        TNotifyEvent; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  lDefaultValue: TddConfigValue;
begin
  l3FillChar(lDefaultValue, SizeOf(lDefaultValue), 0);
  Result:= TddButtonConfigItem.Create(GetAliasName, aCaption, lDefaultValue,
   aClick, aMasterItem);
  AddItem(f_Selected, Result);
end;

procedure TddAppConfiguration.AddCaptionElement(const aCaption: AnsiString; const
        aAliasPrefix: AnsiString = '');
//var
//  i: Integer;
begin
  if f_CurItem is TddMasterSlaveConfigItem then
   (f_CurItem as TddMasterSlaveConfigItem).AddCaption(aCaption, aAliasPrefix);
  { TODO -oДимка -cРазвитие : тут нужно предусмотреть цикл по созданным элементам, если aAliasPrefix <> '' }
  (*
  if aAliasPrefix <> '' then
    for i:= 0 to (f_CurItem as TddMasterSlaveConfigItem).SubItemsCount do
    begin
     GetSubItemLink(aAliasPrefix)
    end;
  *)
end;

function TddAppConfiguration.AddChild(const aAlias, aCaption: AnsiString):
        TddCustomConfigNode;
begin
  Result:= f_Selected.AddNode(aAlias, aCaption);
  f_Selected:= Result;
  f_LabelTop:= True;
  f_IsNode:= True;
end;

function TddAppConfiguration.AddChildNode(aNode: TddCustomConfigNode):
        TddCustomConfigNode;
begin
  Result:= f_Selected.AddNode(aNode);
end;

function TddAppConfiguration.AddColorItem(const aAlias, aCaption: AnsiString;
        aDefault: TColor = clBlack; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
  l3FillChar(l_Default, SizeOf(l_Default), 0);
  l_Default.Kind:= dd_vkInteger;
  l_Default.AsInteger:= aDefault;
  Result:= TddColorConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
  AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddComboBoxItem(const aAlias, aCaption: Il3CString;
 aDefaultValue: Integer; aValueMap: Il3ValueMap; aMasterItem: TddBaseConfigItem;
 aMasterIndex: Integer): TddBaseConfigItem;
var
 lValue: TddConfigValue;
begin
 // по умолчанию
 with lValue do
 begin
  Kind := dd_vkInteger;
  AsInteger := aDefaultValue;
 end;
 Result := AddComboBoxItem(aAlias, aCaption, lValue, aValueMap, aMasterItem, aMasterIndex);
end;

function TddAppConfiguration.AddComboBoxItem(const aAlias, aCaption: Il3CString;
 const aDefaultValue: Il3CString; aValueMap: Il3ValueMap; aMasterItem: TddBaseConfigItem;
 aMasterIndex: Integer): TddBaseConfigItem;
var
 lValue: TddConfigValue;
begin
 // по умолчанию
 with lValue do
 begin
  Kind := dd_vkString;
  AsString := l3Str(aDefaultValue);
 end;
 Result := AddComboBoxItem(aAlias, aCaption, lValue, aValueMap, aMasterItem, aMasterIndex);
end;

function TddAppConfiguration.AddComboBoxItem(const aAlias, aCaption: Il3CString;
 aDefaultValue: TddConfigValue; aValueMap: Il3ValueMap; aMasterItem: TddBaseConfigItem;
 aMasterIndex: Integer): TddBaseConfigItem;
begin
  Result := TddComboBoxConfigItem.Create(l3Str(aAlias), l3Str(aCaption), aDefaultValue,
   aValueMap, aMasterItem, aMasterIndex);
  AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddDateItem(const aAlias, aCaption: AnsiString;
        aDefault: TDateTime = 0; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
  l3FillChar(l_Default, SizeOf(l_Default), 0);
  l_Default.Kind:= dd_vkDateTime;
  l_Default.AsDateTime:= aDefault;
  Result:= TddDateConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
  AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddFileNameItem(const aAlias, aCaption: AnsiString;
        const aDefault: AnsiString = ''; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
  l3FillChar(l_Default, SizeOf(l_Default), 0);
  l_Default.Kind:= dd_vkString;
  l_Default.AsString:= aDefault;
  Result:= TddFileNameConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
  AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddFolderNameItem(const aAlias, aCaption: AnsiString;
        const aDefault: AnsiString = ''; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
   l3FillChar(l_Default, SizeOf(l_Default), 0);
    l_Default.Kind:= dd_vkString;
    l_Default.AsString:= aDefault;
  Result:= TddFolderNameConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
  AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddFontItem(const aAlias, aCaption: AnsiString;
        aDefault: TFont = nil; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
  l3FillChar(l_Default, SizeOf(l_Default), 0);
   l_Default.Kind:= dd_vkObject;
   l_Default.AsObject:= TFont.Create;
   if aDefault <> nil then
    TFont(l_Default.AsObject).Assign(aDefault);
   Result:= TddFontConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
   AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddGroupItem(const aAlias, aCaption: AnsiString;
        aMasterItem: TddBaseConfigItem = nil): TddBaseConfigItem;
begin
  Result:= TddGroupConfigItem.Create(aAlias, aCaption, ddEmptyValue, aMasterItem);
  AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddIntegerItem(const aAlias, aCaption: Il3CString;
        aDefault: Integer = 0; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
 l_Default:= ddEmptyIntValue;
 l_Default.AsInteger:= aDefault;
 Result:= TddIntegerConfigItem.Create(l3Str(aAlias), l3Str(aCaption), l_Default, aMasterItem);
 AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddItem(aNode: TddCustomConfigNode; aItem:
        TddBaseConfigItem): TddBaseConfigItem;
begin
  if (aNode <> nil) and not (aNode is TddCustomConfigNode) then
  begin
   aItem.Free; // может это и не нужно делать?
   raise EddConfigError.Create('Нельзя добавлять элементы в пользовательский узел');
  end;
  if f_Items.IndexOf(aItem.Alias) = -1 then
  begin
   f_Items.AddObject(aItem.Alias, aItem);
   aItem.AbsoluteIndex:= f_Items.IndexOfObject(aItem);
   if f_Groups.Count = 0 then
   begin
    if aNode = nil then
     aNode:= f_Root;
    (aNode as TddAppConfigNode).AddItem(aItem);{ TODO -oДимка -cРазвитие : Тут нужно как-то учитывать наследование узла }
   end
   // Добавляем подэлемент в группу
   else
    TddGroupConfigItem(f_Groups[Pred(f_Groups.Count)]).Add(aItem);
   if aItem is TddGroupConfigItem then
   begin
    f_CurItem := aItem;
    f_Groups.Add(aItem);
   end;
   Result := aItem;
   if Result is TddVisualConfigItem then
    TddVisualConfigItem(Result).LabelTop:= f_LabelTop;
   f_IsNode:= False; 
  end
  else
  begin
  {   aItem.Free; // может это и не нужно делать?}
   raise EddConfigError.CreateResFmt(@rsPropertyExists, [aItem.Alias]);
  end;
end;

function TddAppConfiguration.AddListItem(const aAlias, aCaption: AnsiString;
        aDataAdapter: TddBaseConfigDataAdapter; aMasterItem:
        TddBaseConfigItem = nil): TddBaseConfigItem;
begin
  Result:= TddListConfigItem.Make(aAlias, aCaption, aDataAdapter, aMasterItem);
  AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddStringsItem(const aAlias, aCaption: AnsiString; aMasterItem: TddBaseConfigItem = nil):
    TddBaseConfigItem;
begin
  Result:= TddStringListConfigItem.Make(aAlias, aCaption, aMasterItem);
  AddItem(f_Selected, Result);
end;

procedure TddAppConfiguration.AddMapValue(const aCaption : AnsiString; aValue
        : Integer);
begin
  if LastItem is TddMapValueConfigItem then
   (LastItem as TddMapValueConfigItem).AddMapValue(aCaption, aValue);
end;

function TddAppConfiguration.AddNode(const aAlias, aText: AnsiString):
        TddCustomConfigNode;
begin
 Result:= f_Root.AddNode(aAlias, aText);
 f_Selected:= Result;
 if UseScrollbars then
  f_Selected.ScrollBars := ssBoth;
 f_IsNode:= True;
end;

procedure TddAppConfiguration.AddNode(aNode: TddCustomConfigNode);
begin
  f_Selected := f_Root.AddNode(aNode);
 if UseScrollbars then
  f_Selected.ScrollBars := ssBoth;
 f_IsNode:= True;
end;

function TddAppConfiguration.AddRadioGroupItem(const aAlias, aCaption: AnsiString;
        aDefault: Integer = -1; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
  l3FillChar(l_Default, SizeOf(l_Default), 0);
  l_Default.Kind:= dd_vkInteger;
  l_Default.AsInteger:= aDefault;
  Result:= TddRadioGroupConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
  AddItem(f_Selected, Result);
end;

{$IfNDef Nemesis}
function TddAppConfiguration.AddSoundFileNameItem(const aAlias, aCaption:
        AnsiString; const aDefault: AnsiString = ''; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
   l3FillChar(l_Default, SizeOf(l_Default), 0);
    l_Default.Kind:= dd_vkString;
    l_Default.AsString:= aDefault;
  Result:= TddSoundFileNameConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
  AddItem(f_Selected, Result);
end;
{$EndIf Nemesis}

function TddAppConfiguration.AddStringItem(const aAlias, aCaption: AnsiString;
        const aDefault: AnsiString = ''; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
begin
 Result:= TddStringConfigItem.Create(aAlias, aCaption, MakeStrValue(aDefault), aMasterItem);
 AddItem(f_Selected, Result);
end;

{$IfNDef Nemesis}
function TddAppConfiguration.AddTimeItem(const aAlias, aCaption: AnsiString;
        aDefault: TDateTime = 0; aMasterItem: TddBaseConfigItem = nil):
        TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
  l3FillChar(l_Default, SizeOf(l_Default), 0);
  l_Default.Kind:= dd_vkDateTime;
  l_Default.AsDateTime:= aDefault;
  Result:= TddTimeConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
  AddItem(f_Selected, Result);
end;
{$EndIf Nemesis}

procedure TddAppConfiguration.AddUserNode(aNode: TddCustomConfigNode; AsChild:
        Boolean = False);
begin
  if f_Items.IndexOf(aNode.Alias) = -1 then
  begin
   if AsChild then
    AddChildNode(aNode)
   else
    AddNode(aNode);
   f_Items.AddObject(aNode.Alias, aNode);
  end
  else
  begin
   aNode.Free; // может это и не нужно делать?
   raise EddConfigError.CreateResFmt(@rsPropertyExists, [aNode.Alias]);
  end;
end;

procedure TddAppConfiguration.AdjustFormSize(aForm: TCustomForm; aOptions:
        TddAppDialogOptions);
begin
 if AutoSize then
  RecalcFormSize(aForm)
 else
 begin
  aForm.ClientWidth:= 560;
  aForm.ClientHeight:= 404;
 end;
end;

procedure TddAppConfiguration.CheckEnabledStatus;
var
  i: Integer;
  l_I: TddBaseConfigItem;
  l_Obj: TObject;
begin
  { Проверяем изменение статуса доступности подэлементов }
  for i:= 0 to Pred(f_Items.Count) do
  begin
   l_Obj:= f_Items.Objects[i];
   if l_Obj is TddBaseConfigItem then
   begin
    l_I:= TddBaseConfigItem(l_Obj);
    if l_I.MasterItem <> nil then
     l_I.Enabled:= l_I.MasterItem.BooleanValue;
   end; // l_Obj is TddBaseConfigItem
  end; // for i
end;

procedure TddAppConfiguration.ClearControls;
  
  procedure _Clear(aNode: TddCustomConfigNode);
  var
   i: Integer;
  begin
   aNode.ClearControls;
   for i:= 0 to Pred(aNode.ChildrenCount) do
    _Clear(aNode.Childrens[i]);
  end;
  
begin
  f_AliasNameIndex := 0;
  _Clear(f_Root);
end;

procedure TddAppConfiguration.ClearNode;
begin
  // while f_Selected <> f_Root do
  //  CloseChild;
  f_Selected:= nil;
end;

procedure TddAppConfiguration.CloseChild;
begin
  f_Selected:= f_Selected.Parent;
end;

procedure TddAppConfiguration.CloseGroup;
begin
 if f_Groups.Count > 0 then
  f_Groups.Delete(Pred(f_Groups.Count));
 f_CurItem := nil;
end;

procedure TddAppConfiguration.CreateComponents(theTree: TvtCustomOutliner; theParent:
        TWinControl);

var
 l_Tree : Il3Tree;

 procedure DoNode(const aNode: Il3Node);
 var
  l_Frame : TFrame;
  l_CN    : TddCustomConfigNode;
 begin
  l_CN:= (aNode As IddCNode).Control;
  l_Frame := l_CN.CreateFrame(theParent, l_Tree.GetAbsIndex(aNode));
  if (l_Frame.Parent = nil) then
   l_Frame.Parent:= theParent;
  l_Frame.Visible:= aNode.IsSame(theTree.CurrentCNode);
 end;

begin
  //if AdjustFormSize then
  // RecalcFormSize;
  l_Tree := theTree.CTree;
  l_Tree.IterateF(l3L2NA(@DoNode))
end;

procedure TddAppConfiguration.CreateTree(const aTree: TddCustomConfigNode;
        theTree: TvtCustomOutliner);
var
 l_R : Il3Node;

  procedure ConvertNode(const aNode: TddCustomConfigNode; const aTreeNode: Il3Node);
  var
   i   : Integer;
   l_N : Il3Node;
  begin
   if (aTreeNode = nil) then
    l_N := l_R.InsertChild(TddCNode.Make(aNode))
   else
    l_N := aTreeNode.InsertChild(TddCNode.Make(aNode));
   for i:= 0 to Pred(aNode.ChildrenCount) do
    ConvertNode(aNode.Childrens[i], l_N);
  end;

var
 j : Integer;
begin
 l_R := theTree.CTree.CRootNode;
 l_R.ReleaseChilds;
 for j:= 0 to Pred(aTree.ChildrenCount) do
  ConvertNode(aTree.Childrens[j], nil);
end;

procedure TddAppConfiguration.FillDialog(aForm : TCustomForm; const aOptions :
        TddAppDialogOptions = []; const aCaptionPanelTypes : TddCaptionPanelTypes = []);
var
  l_Tree: TFrame;
begin
   { Итак, нам передали форму. Для того, чтобы все работало, нам нужно создать:
       - Дерево конфигурации
       - панель элементов (набор фреймов-панелей)
       - панель с кнопками
     При этом чего-то может и не быть, например, панели кнопок
   }
  if aForm <> nil then
  begin
   DialogOptions := aOptions;
   aForm.Caption:= DialogCaption;
   l_Tree:= TTreeFrame.Create(aForm);
   l_Tree.Align:= alLeft;
   f_WorkFrame:= TWorkFrame.Create(aForm);
   f_WorkFrame.Align:= alClient;
   {$IfDef Nemesis}
   f_WorkFrame.Color := cGarant2011BackColor;
   {$EndIf Nemesis}
   if aCaptionPanelTypes <> [] then
   begin
    if cptNormalBevel in aCaptionPanelTypes then
     f_WorkFrame.CaptionPanel.BevelWidth := 1;
   end;
   if not (dd_doNoButtons in aOptions) then
   begin
    f_ButtonsPanel:= TButtonsFrame.Create(aForm);
    f_ButtonsPanel.Font:= aForm.Font;
    f_ButtonsPanel.Align:= alBottom;
    TButtonsFrame(f_ButtonsPanel).HelpButton.Visible:= Application.HelpFile <> '';
    TButtonsFrame(f_ButtonsPanel).textVersion.Caption:= '  '+ GetProgramVersion;
   end
   else
    f_ButtonsPanel:= nil;
   l_Tree.Parent:= aForm;
   if f_ButtonsPanel <> nil then
   begin
    f_ButtonsPanel.Parent:= aForm;
    //TButtonsFrame(f_ButtonsPanel).OnHelpContextChange:= TTreeFrame(l_Tree).HelpContextChange;
   end;
   l_Tree.Parent:= aForm;
   f_WorkFrame.Parent:= aForm;
   CalculateConstants(l_Tree, f_WorkFrame, f_ButtonsPanel);
   AdjustFormSize(aForm, aOptions);
   //l_Tree.Width := 165; // хитрая подхачка против беспредела Windows
   with (l_Tree as TTreeFrame) do
   begin
    CreateTree(f_Root, ConfigTree);
    CreateComponents(ConfigTree, f_WorkFrame.ComponentsPanel);
    WorkFrame:= f_WorkFrame;
    f_ConfigTree:= ConfigTree;
   end; // (l_Tree as TTreeFrame)
   ReadValuesFromDialog(False);
   aForm.ActiveControl := f_ConfigTree;
  end
  else
   raise EddConfigError.Create('Отсутствует форма для отображения конфигурации');
end;

function TddAppConfiguration.GetAliasName(const aAliasMask: AnsiString = 'AliasName'): AnsiString;
begin
 repeat
  Inc(f_AliasNameIndex);
  Result := Format('%s%d', [aAliasMask, f_AliasNameIndex]);
 until Items.IndexOf(Result) = -1;
end;

function TddAppConfiguration.GetAllowTest: Boolean;
begin
  if LastItem is TddBrowseConfigItem then
   Result := (LastItem as TddBrowseConfigItem).AllowTest
  else
   Result := False;
end;

function TddAppConfiguration.GetAsBoolean(const Alias: AnsiString): Boolean;
var
  l_Value: TddConfigValue;
begin
   l_Value:= Values[Alias];
   if l_Value.Kind = dd_vkBoolean then
    Result:= l_Value.AsBoolean
   else
    raise EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

function TddAppConfiguration.GetAsDateTime(const Alias: AnsiString): TDateTime;
var
  l_Value: TddConfigValue;
begin
   l_Value:= Values[Alias];
   if l_Value.Kind = dd_vkDateTime then
    Result:= l_Value.AsDateTime
   else
    raise EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

function TddAppConfiguration.GetAsInteger(const Alias: AnsiString): Integer;
var
  l_Value: TddConfigValue;
begin
   l_Value:= Values[Alias];
   if l_Value.Kind = dd_vkInteger then
    Result:= l_Value.AsInteger
   else
    raise EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

function TddAppConfiguration.GetAsObject(const Alias: AnsiString): TObject;
var
  l_Value: TddConfigValue;
begin
   l_Value:= Values[Alias];
   if l_Value.Kind = dd_vkObject then
    Result:= l_Value.AsObject
   else
    raise EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

function TddAppConfiguration.GetAsString(const Alias: AnsiString): AnsiString;
var
  l_Value: TddConfigValue;
  i: Integer;
  l_Obj: TddBaseConfigItem;
begin
  if HasValue(Alias, l_Obj) then
  begin
   if l_Obj is TddBaseConfigItem then
    Result:= TddBaseConfigItem(l_Obj).StringValue
   else
    Result:= TddCustomConfigNode(l_Obj).Value.AsString;

   (*
   l_Value:= Values[Alias];
   case l_Value.Kind of
    dd_vkString : Result:= l_Value.AsString;
    dd_vkInteger: Result:= IntToStr(l_Value.AsInteger);
    dd_vkBoolean: Result:= ddBooleanNames[l_Value.AsBoolean];
    dd_vkDateTime :Result:= DateTimeToStr(l_Value.AsDateTime);
   end
   *)
  end
  else
   raise EddConfigError.CreateResFmt(@rsPropertyAbsent, [Alias]);
end;

function TddAppConfiguration.GetChanged: Boolean;
var
  I: Integer;
  l_Obj: TObject;
begin
  Result := False;
  for i:= 0 to Pred(f_Items.Count) do
  begin
   l_Obj:= f_Items.Objects[i];
   if l_Obj is TddBaseConfigItem then
   begin
    if TddBaseConfigItem(l_Obj).Changed then
    begin
     Result:= True;
     Break;
    end
   end
   else
    if TddCustomConfigNode(l_Obj).Changed then
    begin
     Result := True;
     Break;
    end;
  end;
end;

function TddAppConfiguration.GetComboBoxStyle: TComboBoxStyle;
begin
  Assert(LastItem is TddComboBoxConfigItem);
  Result := TddComboBoxConfigItem(LastItem).ComboBoxStyle;
end;

function TddAppConfiguration.GetEnabled: Boolean;
begin
  Result := LastItem.Enabled;
end;

function TddAppConfiguration.GetFilter: AnsiString;
begin
  if LastItem is TddFileNameConfigItem then
   Result:= (LastItem as TddFileNameConfigItem).FilterMask;
end;

function TddAppConfiguration.GetHint: AnsiString;
begin
  if LastItem is TddVisualConfigItem then
   Result := TddVisualConfigItem(LastItem).Hint
  else
   Result := '';
end;

function TddAppConfiguration.GetLabelTop: Boolean;
begin
  if LastItem is TddVisualConfigItem then
   Result := TddVisualConfigItem(LastItem).LabelTop
  else
   Result := f_LabelTop;
end;

function TddAppConfiguration.GetLastItem: TddBaseConfigItem;
begin
 if f_IsNode then
  Result:= nil
 else 
  if f_Items.Count > 0 then
   Result := TddBaseConfigItem(f_Items.Objects[Pred(f_Items.Count)])
  else
   raise EddConfigError.CreateRes(@rsListEmpty);
end;

function TddAppConfiguration.GetMaxValue: Integer;
begin
  if LastItem is TddIntegerConfigItem then
   Result := (LastItem as TddIntegerConfigItem).MaxValue
  else
   Result := 0;
end;

function TddAppConfiguration.GetMinValue: Integer;
begin
  if LastItem is TddIntegerConfigItem then
   Result := (LastItem as TddIntegerConfigItem).MinValue
  else
   Result := 0;
end;

function TddAppConfiguration.GetPasswordChar: Char;
begin
  if LastItem is TddStringConfigItem then
   Result := (LastItem as TddStringConfigItem).PasswordChar
  else
   Result := #0;
end;

function TddAppConfiguration.GetPlace: TButtonPlace;
begin
  if LastItem is TddButtonConfigItem then
   Result := TddButtonConfigItem(LastItem).Place
  else
   Result := dd_bpAsDefine;
end;

function TddAppConfiguration.GetTestButtonCaption: AnsiString;
begin
  if LastItem is TddBrowseConfigItem then
   Result:= (LastItem as TddBrowseConfigItem).TestButtonCaption
  else
   Result:= '';
end;

function TddAppConfiguration.GetValues(const Alias: AnsiString): TddConfigValue;
var
  l_Index: Integer;
  l_Obj: TddBaseConfigItem;
begin
  if HasValue(Alias, l_Obj) then
   Result:= l_Obj.Value
  else
   raise EddConfigError.CreateResFmt(@rsPropertyAbsent, [Alias])
end;

function TddAppConfiguration.HasValue(const aAlias: AnsiString): Boolean;
{1 Проверяет наличие элемента с указанным псевдонимом }
var
  l_Obj: TddBaseConfigItem;
begin
  Result:= HasValue(aAlias, l_Obj);
end;

function TddAppConfiguration.HasValue(const aAlias: AnsiString; out theItem: TddBaseConfigItem): Boolean;
{1 Проверяет наличие элемента с указанным псевдонимом и возвращает индекс
        элемента, если таковой имеется }
var
 i: Integer;
begin
 Result:= f_Root.HasValue(aAlias, theItem);
 (*
 Result:= False;
 for i:= 0 to Pred(f_Items.Count) do
 begin
  Result:= TddBaseConfigItem(f_Items.Objects[i]).HasValue(aAlias, theItem);
  if Result then
   break
 end;
 *)
end;

procedure TddAppConfiguration.Load(aStorage: IddConfigStorage = nil);
var
  l_Storage: IddConfigStorage;
  l_Index: Integer;
begin
  if aStorage = nil then
   l_Storage:= f_Storage
  else
   l_Storage:= aStorage;
  if l_Storage <> nil then
  try
   CheckVersion(l_Storage);
   f_Root.Load(l_Storage);
   CheckEnabledStatus;
  finally
   l_Storage:= nil;
  end; // f_Storage
 CheckRequiredValues;
 Changed:= False;
end;

function TddAppConfiguration.ReadValuesFromDialog(const aRead: Boolean = True) : Boolean;

  procedure _ReadValue(const aNode: TddCustomConfigNode);
  var
   i: Integer;
  begin
    if aRead then
     aNode.GetControlValues
    else
     aNode.SetControlValues(False);
    for i:= 0 to Pred(aNode.ChildrenCount) do
     _ReadValue(aNode.Childrens[i]);
  end;

var
 I    : Integer;
begin
 Result := True;
 if aRead then
  AsInteger['_DialogIndex']:= f_ConfigTree.CTree.GetAbsIndex(f_ConfigTree.CurrentCNode)
 else
  f_ConfigTree.GotoOnNode(f_ConfigTree.CTree.GetNodeByAbsIndex(AsInteger['_DialogIndex']));
 try
  { Пробегаем по дереву и считываем или устанавливаем значения элементам }
  for i:= 0 to Pred(f_Root.ChildrenCount) do
   _ReadValue(f_Root.Childrens[i]);
 except
  on E : EddInvalidValue do
  begin
   DoError(E.Message, E.Item);
   Result := False;
  end;
 end;
end;

procedure TddAppConfiguration.RecalcFormSize(aForm: TCustomForm);
var
  i: Integer;
  l_MaxHeight, l_CurHeight: Integer;
  l_MaxWidth: Integer;
  l_Height, l_Width: Integer;

  procedure CalcNodeBounds(aNode: TddCustomConfigNode);
  var
   l_Height, l_Width: Integer;
  begin
   aNode.FrameSize(aForm, l_Height, l_Width);
   if not aNode.IsVerticalScrollBar then
    l_MaxHeight:= Max(l_MaxHeight, l_Height);
   if not aNode.IsHorizontalScrollBar then
    l_MaxWidth:= Max(l_MaxWidth, l_Width);
  end;

begin
  l_MaxWidth:= 560;
  l_MaxHeight:= 404;

  //l_MaxHeight:= Low(l_MaxHeight);
  //l_MaxWidth:= Low(l_MaxWidth);
  // Вычисление максимальных ширин и высот панелей
  for i:= 0 to Pred(f_Root.ChildrenCount) do
   CalcNodeBounds(f_Root.Childrens[i]);
  // Окончательный пересчет
  if dd_doNoButtons in DialogOptions then
   l_Height:= ButtonsPanelHeight + l_MaxHeight
  else
  if Assigned(f_ButtonsPanel) then
   l_Height:= f_ButtonsPanel.Height + l_MaxHeight
  else
   l_Height := l_MaxHeight;
  // Учтем панель информации
  if Assigned(f_WorkFrame) then
   Inc(l_Height, f_WorkFrame.HeaderHeight);
  { TODO -oДмитрий Дудко -cРазвитие : Тщательно проверить пересчет }
  l_Width:= Max(f_FormMinWidth, l_MaxWidth + f_WorkFrame.Left);
  l_CurHeight:= MulDiv(l_Width, 10, 14);
  if l_CurHeight < l_Height then
   l_Width:= MulDiv(l_Height, 14, 10)
  else
   l_Height:= l_CurHeight;
  aForm.ClientHeight:= l_Height;
  aForm.ClientWidth:= l_Width;
end;

procedure TddAppConfiguration.ReloadDefault;
begin
  { TODO -oДмитрий Дудко -cРазвитие : Сброс всех значений в значение по умолчанию }
end;

procedure TddAppConfiguration.Save(aStorage: IddConfigStorage = nil);
var
  l_Storage: IddConfigStorage;
begin
  if aStorage = nil then
   l_Storage:= f_Storage
  else
   l_Storage:= aStorage;
  
   if l_Storage <> nil then
    f_Root.Save(l_Storage);
end;

procedure TddAppConfiguration.SetAllowTest(Value: Boolean);
begin
  if LastItem is TddBrowseConfigItem then
   (LastItem as TddBrowseConfigItem).AllowTest:= Value;
end;

procedure TddAppConfiguration.SetAsBoolean(const Alias: AnsiString; const Value: Boolean);
var
  l_Value: TddConfigValue;
begin
   l_Value:= Values[Alias];
   if l_Value.Kind = dd_vkBoolean then
   begin
    l_Value.AsBoolean:= Value;
    Values[Alias]:= l_Value;
   end
   else
    EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

procedure TddAppConfiguration.SetAsDateTime(const Alias: AnsiString; const Value:
        TDateTime);
var
  l_Value: TddConfigValue;
begin
 l_Value:= Values[Alias];
 if l_Value.Kind = dd_vkDateTime then
 begin
  l_Value.AsDateTime:= Value;
  Values[Alias]:= l_Value;
 end
 else
  EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

procedure TddAppConfiguration.SetAsInteger(const Alias: AnsiString; const Value: Integer);
var
 l_Value: TddConfigValue;
begin
 l_Value:= Values[Alias];
 if l_Value.Kind = dd_vkInteger then
 begin
  l_Value.AsInteger:= Value;
  Values[Alias]:= l_Value;
 end
 else
  EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

procedure TddAppConfiguration.SetAsObject(const Alias: AnsiString; Value: TObject);
var
 l_Value: TddConfigValue;
begin
 l_Value:= Values[Alias];
 if l_Value.Kind = dd_vkObject then
 begin
  l_Value.AsObject:= Value;
  Values[Alias]:= l_Value;
 end
 else
  EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

procedure TddAppConfiguration.SetAsString(const Alias: AnsiString; const Value: AnsiString);
var
  l_Value: TddConfigValue;
begin
 l_Value:= Values[Alias];
 if l_Value.Kind = dd_vkString then
 begin
  l_Value.AsString:= Value;
  Values[Alias]:= l_Value;
 end
 else
  EddConfigError.CreateResFmt(@rsDifferentType, [Alias]);
end;

procedure TddAppConfiguration.SetChanged(Value: Boolean);
var
  I: Integer;
  l_Obj: TObject;
begin
 f_Root.Changed:= Value;
 (*
  for i:= 0 to Pred(f_Items.Count) do
  begin
   l_Obj:= f_Items.Objects[i];
   if l_Obj is TddBaseConfigItem then
    TddBaseConfigItem(l_Obj).Changed := Value
   //else
   // TddCustomConfigNode(l_Obj).Changed := Value;
  end; // for i
  *)
end;

procedure TddAppConfiguration.SetComboBoxStyle(const Value: TComboBoxStyle);
begin
  Assert(LastItem is TddComboBoxConfigItem);
  TddComboBoxConfigItem(LastItem).ComboBoxStyle := Value;
end;

procedure TddAppConfiguration.SetDialogCaption(const Value: AnsiString);
begin
  f_DialogCaption := Value;
end;

procedure TddAppConfiguration.SetEnabled(const Value: Boolean);
begin
  LastItem.Enabled := Value;
end;

procedure TddAppConfiguration.SetFilter(const Value: AnsiString);
begin
  if LastItem is TddFileNameConfigItem then
   (LastItem as TddFileNameConfigItem).FilterMask:= Value;
end;

procedure TddAppConfiguration.SetHint(const Value: AnsiString);
begin
  if LastItem is TddVisualConfigItem then
   TddVisualConfigItem(LastItem).Hint:= Value;
end;

procedure TddAppConfiguration.SetLabelTop(Value: Boolean);
begin
  if LastItem is TddVisualConfigItem then
   TddVisualConfigItem(LastItem).LabelTop:= Value
  else
   f_LabelTop:= Value;
end;

procedure TddAppConfiguration.SetMaxValue(Value: Integer);
begin
  if LastItem is TddIntegerConfigItem then
   (LastItem as TddIntegerConfigItem).MaxValue:= Value;
end;

procedure TddAppConfiguration.SetMinValue(Value: Integer);
begin
  if LastItem is TddIntegerConfigItem then
   (LastItem as TddIntegerConfigItem).MinValue:= Value;
end;

procedure TddAppConfiguration.SetPasswordChar(Value: Char);
begin
  if LastItem is TddStringConfigItem then
   (LastItem as TddStringConfigItem).PasswordChar:= Value;
end;

procedure TddAppConfiguration.SetPlace(const Value: TButtonPlace);
begin
  if LastItem is TddButtonConfigItem then
   TddButtonConfigItem(LastItem).Place := Value;
end;

procedure TddAppConfiguration.SetTestButtonCaption(const Value: AnsiString);
begin
  if LastItem is TddBrowseConfigItem then
   (LastItem as TddBrowseConfigItem).TestButtonCaption:= Value;
end;

procedure TddAppConfiguration.SetValues(const Alias: AnsiString; Value: TddConfigValue);
var
  l_Obj: TddBaseConfigItem;
begin
 if hasValue(Alias, l_Obj) then
  l_Obj.Value:= Value;
end;

procedure TddAppConfiguration.DoFocus(aItem : TddVisualConfigItem);

var
 lNode  : TddCustomConfigNode;

  function DoNode(const aNode: Il3Node): Boolean;
  begin
   Result := ((aNode As IddCNode).Control = lNode);
  end;

var
 l_N : Il3Node;
begin
 lNode := FindNode(aItem);
 l_N := f_ConfigTree.CTree.IterateF(l3L2NA(@DoNode), imCheckResult);
 if (l_N <> nil) then
 begin
  f_ConfigTree.GotoOnNode(l_N);
  if TWinControl(aItem.Control).CanFocus then
   TWinControl(aItem.Control).SetFocus;
 end;//l_N <> nil
end;

procedure TddAppConfiguration.DoError(const aMessage : AnsiString;
                                      aItem          : TddVisualConfigItem);
begin
 // Установим фокус в компоненте с неверным значением
 DoFocus(aItem);
 // Сообщение пользователю
 if Assigned(f_OnError) then
  f_OnError(Self, aMessage)
 else
  {$IfDef XE}
  Application.MessageBox(PChar(String(aMessage)),
   PChar(String(str_ddmmErrorCaption.AsStr)),
   MB_ICONERROR);
  {$Else  XE}
  Application.MessageBox(PAnsiChar(aMessage),
   PAnsiChar(str_ddmmErrorCaption.AsStr),
   MB_ICONERROR);
  {$EndIf XE}
end;

function TddAppConfiguration.ShowDialog(const aCaption: AnsiString = ''; aValidate: Boolean = False): Boolean;
var
 l_Ok: Boolean;
begin
  Result := False;
  if aCaption <> '' then
   f_DialogCaption := aCaption;
  if f_Dialog = nil then
  begin
   f_Dialog:= TForm.Create(Application);
   afwHackControlFont(f_Dialog);
   with f_Dialog do
   try
    BorderStyle:= bsDialog;
    Position:= poScreenCenter;
    FillDialog(f_Dialog);
    ShowHint := True;
    l_Ok:= True;
    repeat
     if f_RequiredNode <> nil then
      MakeNodeVisible(f_RequiredNode);
     if ShowModal = mrOk then
     begin
      Result:= True;
      ReadValuesFromDialog(True);
      WorkupChanged;
      CheckEnabledStatus;
      if aValidate then
       l_Ok:= CheckRequiredValues
      else
       l_Ok:= True;
      if not l_Ok then
       MessageDlg(f_RequiredMessage, mtError, [mbOk], 0)
      else
       Save;
     end
     else
     begin
      Result:= False;
      l_Ok:= True;
     end;
    until l_Ok;
    ClearControls;
    f_ConfigTree:= nil;
   finally
    FreeAndNil(f_Dialog);
   end
  end
  else
   f_Dialog.BringToFront;
end;


function TddAppConfiguration.AddMasterSlaveItem(const Alias : AnsiString;
 const aCaption : AnsiString) : TddBaseConfigItem;
begin
 Result := TddMasterSlaveConfigItem.Create(Alias, aCaption, EmptyConfigValue);
 AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddCheckListItem(const aAlias, aCaption: AnsiString;
    aDefault: Integer = -1; aMasterItem: TddBaseConfigItem = nil):
    TddBaseConfigItem;
var
  l_Default: TddConfigValue;
begin
  l3FillChar(l_Default, SizeOf(l_Default), 0);
  l_Default.Kind:= dd_vkInteger;
  l_Default.AsInteger:= aDefault;
  Result:= TddCheckListConfigItem.Create(aAlias, aCaption, l_Default, aMasterItem);
  AddItem(f_Selected, Result);
end;

function TddAppConfiguration.AddChild(const aCaption: AnsiString): TddCustomConfigNode;
begin
 Result:= AddChild(GetAliasName('Child'), aCaption);
end;

procedure TddAppConfiguration.AddDivider(aCaption: AnsiString);
begin
 AddItem(TddDividerConfigItem.Create(GetAliasName('Divider'), aCaption, EmptyConfigValue));
end;

function TddAppConfiguration.AddGroupItem(const aCaption: AnsiString; aMasterItem: TddBaseConfigItem = nil):
    TddBaseConfigItem;
begin
 Result:= AddGroupItem(GetAliasName('Group'), aCaption, aMasterItem);
end;

function TddAppConfiguration.AddContainerGroup(const aAlias, aCaption: AnsiString; aMasterItem: TddBaseConfigItem = nil):
    TddBaseConfigItem;
begin
  Result:= TddContainerConfigItem.Create(aAlias, aCaption, ddEmptyValue, aMasterItem);
  AddItem(f_Selected, Result);
end;

procedure TddAppConfiguration.AddVersionHandler(aFromVersion, aToVersion: Integer; aProc: Tdd_acVersionUpgradeProc);
begin
 f_Versions.AddHandler(aFromVersion, aToVersion, aProc);
end;

function TddAppConfiguration.AddItem(aItem: TddBaseConfigItem): TddBaseConfigItem;
begin
 Result:= AddItem(f_Selected, aItem);
end;

function TddAppConfiguration.AddSimpleListItem(const aAlias, aCaption: AnsiString; aMasterItem: TddBaseConfigItem = nil):
    TddBaseConfigItem;
begin
 Result:= TddSimpleListConfigItem.Make(aAlias, aCaption, aMasterItem);
 AddItem(f_Selected, Result);
end;

procedure TddAppConfiguration.CalculateConstants(theTree, theWork, theButtons: TFrame);
// вычисляет константы отступов
begin
 f_FormMinWidth := theTree.Width;
 if theButtons <> nil then
 begin
  Inc(f_FormMinHeight, theButtons.Height);
//  if theButtons is TButtonFrame then
//   f_FormMinWidth :=
 end;
end;

function TddAppConfiguration.CheckRequiredValues: Boolean;

 function _CheckNode(aNode: TddCustomConfigNode): Boolean;
 var
  i: Integer;
 begin
  Result:= not aNode.IsRequired(f_RequiredMessage);
  if Result then
   for i:= 0 to Pred(aNode.ChildrenCount) do
   begin
    Result:= _CheckNode(aNode.Childrens[i]);
    if not Result then
     break;
   end
  else
  begin
   if Assigned(f_OnRequiredEvent) then
    f_OnRequiredEvent(aNode, Result);
   if not Result then
   begin
    f_RequiredNode:= aNode;
    f_RequiredMessage:= Format('Не задан параметр "%s" на вкладке "%s"', [f_RequiredMessage, aNode.Caption]);
   end;
  end;
 end;

begin
 f_RequiredNode := nil;
 f_RequiredMessage:= '';
 Result := _CheckNode(f_Root);
end;

procedure TddAppConfiguration.CheckVersion(aStorage: IddConfigStorage);
var
 l_Version: TddBaseConfigItem;
 l_CurVersion, l_OldVersion: Integer;
begin
 // Нужно прочитать версию из хранилища и при не совпадении запросить преобразование
 if HasValue('_Version', l_Version) then
 begin
  l_CurVersion:= Version;
  aStorage.Section:= f_Root.Alias;
  l_Version.LoadValue(aStorage);
  l_OldVersion:= l_Version.IntegerValue;
  if l_CurVersion > l_OldVersion then
  begin
   f_Versions.Upgrade(l_OldVersion, l_CurVersion, aStorage);
   l_Version.IntegerValue:= l_CurVersion;
   aStorage.Section:= f_Root.Alias;
   l_Version.SaveValue(aStorage);
  end; // l_CurVersion <> l_OldVersion
 end;
end;

procedure TddAppConfiguration.CloseMasterSlaveItem;
begin
 CloseGroup;
end;

procedure TddAppConfiguration.LoadStructure(aStream: TStream);
begin
 f_Root.LoadTree(aStream);
end;

procedure TddAppConfiguration.pm_SetFormMinHeight(const Value: Integer);
begin
 if Value <> f_FormMinHeight then
  f_FormMinHeight := Value;
end;

procedure TddAppConfiguration.pm_SetFormMinWidth(const Value: Integer);
begin
 if Value <> f_FormMinWidth then
  f_FormMinWidth := Value;
end;

procedure TddAppConfiguration.MakeNodeVisible(aNode: TddCustomConfigNode);
  {-}

  function DoNode(const aN: Il3Node): Boolean;
  begin
   Result := ((aN As IddCNode).Control = aNode);
  end;

var
 l_N : Il3Node;
begin
 if (f_ConfigTree <> nil) then
 begin
  l_N := f_ConfigTree.CTree.IterateF(l3L2NA(@DoNode), imCheckResult);
  if (l_N <> nil) then
   f_ConfigTree.GotoOnNode(l_N);
 end;//f_ConfigTree <> nil
end;

function TddAppConfiguration.pm_GetColumns: Integer;
begin
 if LastItem is TddCheckListConfigItem then
  Result := TddCheckListConfigItem(LastItem).Columns
 else
  Result:= 1;
end;

function TddAppConfiguration.pm_GetDialogIndex: Integer;
begin
 Result := AsInteger['_DialogIndex'];
end;

function TddAppConfiguration.pm_GetHelpContext: Integer;
begin
 if f_IsNode then
  Result:= f_Selected.HelpContext
 else
  Result := LastItem.HelpContext;
end;

function TddAppConfiguration.pm_GetIsEmpty(Alias: AnsiString): Boolean;
begin
 if HasValue(Alias) then
 begin
  Result := IsValueEmpty(Values[Alias]);
 end
 else
  raise EddConfigError.CreateResFmt(@rsPropertyAbsent, [Alias]);
end;

function TddAppConfiguration.pm_GetIsValid: Boolean;
var
 l_Index: Integer;
begin
 Result := CheckRequiredValues;
end;

function TddAppConfiguration.pm_GetPathFill: TddFillType;
begin
 if LastItem is TddBrowseConfigItem then
  Result := TddBrowseConfigItem(LastItem).PathFill;
end;

function TddAppConfiguration.pm_GetRequired: Boolean;
begin
 Result := LastItem.Required;
end;

function TddAppConfiguration.pm_GetVersion: Integer;
begin
 Result := AsInteger['_Version'];
end;

procedure TddAppConfiguration.pm_SetColumns(const aValue: Integer);
begin
 if LastItem is TddCheckListConfigItem then
  TddCheckListConfigItem(LastItem).Columns:= aValue;
end;

procedure TddAppConfiguration.pm_SetDialogIndex(const aValue: Integer);
begin
 AsInteger['_DialogIndex']:= aValue;
end;

procedure TddAppConfiguration.pm_SetHelpContext(const aValue: Integer);
begin
 if f_IsNode then
  f_Selected.HelpContext:= aValue
 else
  LastItem.HelpContext:= aValue;
end;

procedure TddAppConfiguration.pm_SetPathFill(const aValue: TddFillType);
begin
 if LastItem is TddBrowseConfigItem then
  TddBrowseConfigItem(LastItem).PathFill:= aValue;
end;

procedure TddAppConfiguration.pm_SetRequired(const Value: Boolean);
begin
 LastItem.Required := Value;
end;

procedure TddAppConfiguration.pm_SetVersion(const aValue: Integer);
begin
 AsInteger['_Version']:= aValue;
end;

procedure TddAppConfiguration.SaveStructure(aStream: TStream);
begin
 f_Root.SaveTree(aStream);
end;

procedure TddAppConfiguration.SetFontName;
begin
 if (Win32Platform = VER_PLATFORM_WIN32_NT) then
 begin
  if (Win32MajorVersion >= 6) then
  // - Vista
   FontName := 'Segoe UI'
  else
   FontName := 'Arial';
 end//Win32Platform = VER_PLATFORM_WIN32_NT
 else
  FontName := 'Arial';
end;

procedure TddAppConfiguration.SetUseScrollbars(const Value: Boolean);
begin
  if FUseScrollbars <> Value then
  begin
    FUseScrollbars := Value;
    // Перебрать все узлы и выставить им скроллеры
  end;
end;

function TddAppConfiguration.ShowNodeDialog(const aAlias: AnsiString): Boolean;
var
 l_Node: TddBaseConfigItem;
begin
 Result := False;
 if HasValue(aAlias, l_Node) then
 begin
  if l_Node is TddAppConfigNode then
   Result:= ExecuteNodeDialog(TddAppConfigNode(l_Node))
  else
   raise EddConfigError.CreateFmt('Элемент %s не является узлом', [aAlias]);
 end
 else
  raise EddConfigError.CreateFmt('Отсутствует элемент %s', [aAlias]);
end;

procedure TddAppConfiguration.WorkupChanged;
 procedure _Work(aNode: TddCustomConfigNode);
 var
  i: Integer;
 begin
  if aNode.Changed then
   aNode.PostEdit;
  for i:= 0 to Pred(aNode.ChildrenCount) do
   _Work(aNode.Childrens[i]);
 end;
begin
 _work(f_Root);
end;

// start class TddCNode

constructor TddCNode.Create(aNode: TddCustomConfigNode);
  //reintroduce;
  {-}
begin
 inherited Create;
 f_Node := aNode;
 Text := l3PCharLen(aNode.Caption);
end;

class function TddCNode.Make(aNode: TddCustomConfigNode): Il3Node;
  //reintroduce;
  {-}
var
 l_N : TddCNode;
begin
 l_N := Create(aNode);
 try
  Result := l_N;
 finally
  l3Free(l_N);
 end;//try..finally
end;

function TddCNode.Control: TddCustomConfigNode;
  {-}
begin
 Result := f_Node;
end;

end.
