unit Readers1;

{ $Id: READERS1.PAS,v 1.6 2003/04/19 12:30:36 law Exp $ }

// $Log: READERS1.PAS,v $
// Revision 1.6  2003/04/19 12:30:36  law
// - new file: ddDefine.inc.
//
// Revision 1.5  2002/01/05 11:00:41  law
// - some cosmetics.
//
// Revision 1.4  2001/10/23 09:03:38  law
// - new const: evEverestReaders & evEverestWriters.
//
// Revision 1.3  2000/12/15 15:29:53  law
// - ��������� ��������� Log � Id.
//

{$I ddDefine.inc }

interface

uses
  {$IfNDef Delphi3}
  l3Filer,
  {$EndIf  Delphi3}
  ddNSRC_r
  ;

type
  TevNSRCReader = class(TCustomNSRCReader)
    published
    {published properties}
      property Filer;
        {-}
  end;{TevNSRCReader}

{$IfNDef evRunTime}
procedure Register;
{$EndIf  evRunTime}

implementation

uses
  Classes,

  evConst
  ;

{$IfNDef evRunTime}
procedure Register;
begin
 RegisterComponents(evReaders, [TevNSRCReader]);
end;
{$EndIf  evRunTime}

end.