unit quideLinks;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs;

type
  //1 —сылка из текста
  TquideLink = class(TquideObject)
  private
    f_LinkType: TquideLinkType;
  public
    property LinkType: TquideLinkType read f_LinkType write f_LinkType;
  end;


implementation



end.
