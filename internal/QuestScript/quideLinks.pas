unit quideLinks;

interface

uses
 quideObject;

type
  TquideLinkType = (linkText);
  //1 ������ �� ������ �� ������ �������
  TquideLink = class(TquideObject)
  private
    f_LinkType: TquideLinkType;
  public
    property LinkType: TquideLinkType read f_LinkType write f_LinkType;
  end;


implementation



end.
