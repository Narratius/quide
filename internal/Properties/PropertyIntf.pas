unit PropertyIntf;

interface

uses
  SysUtils, Windows, Messages, Classes, Xml.XMLIntf;

type
  //1 Обеспечивает сохранение-загрузку
  IPropertyStore = interface
    ['{1604F322-5F86-4359-A44A-33EE3CB1F6C7}']
    procedure LoadFromXML(Element: IXMLNode; LoadStruct: Boolean);
    procedure SaveToXML(Element: IXMLNode; SaveStruct: Boolean);
  end;

  IPropertyControlValue = interface
    ['{7660D972-81B7-4062-AF86-4517B58AA55E}']
    function pm_GetValue: Variant;
    procedure pm_SetValue(const Value: Variant);
    property Value: Variant read pm_GetValue write pm_SetValue;
  end;



implementation


end.
