//..........................................................................................................................................................................................................................................................
unit ddConfigStorages;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,

  l3Interfaces
  ;

type
  {1 Интерфейс для чтения-записи данных конфигурации }
  IddConfigStorage = interface(IUnknown)
    ['{D3A8CAA1-2068-4234-811B-723C80A61E69}']
    function  GetSection: AnsiString;
      stdcall;
    function  ReadBool(const Alias: AnsiString; Default: Boolean): Boolean;
      stdcall;
    function  ReadDateTime(const Alias: AnsiString; Default: TDateTime): TDateTime;
      stdcall;
    function  ReadInteger(const Alias: AnsiString; Default: Integer): Integer;
      stdcall;
    function  ReadString(const Alias: AnsiString; const Default: AnsiString): Il3CString;
      stdcall;
    procedure SetSection(const Value: AnsiString);
      stdcall;
    procedure WriteBool(const Alias: AnsiString; B: Boolean);
      stdcall;
    procedure WriteDateTime(const Alias: AnsiString; DT: TDateTime);
      stdcall;
    procedure WriteInteger(const Alias: AnsiString; I: Integer);
      stdcall;
    procedure WriteString(const Alias: AnsiString; const S: AnsiString);
      stdcall;
    property Section: AnsiString
      read GetSection
      write SetSection;
  end;//IddConfigStorage
  

implementation


end.
