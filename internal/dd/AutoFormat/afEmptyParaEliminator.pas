unit afEmptyParaEliminator;
{ ������� ������ ������ �� ������ }
// $Id: afEmptyParaEliminator.pas,v 1.2 2013/04/16 09:30:55 fireton Exp $

// $Log: afEmptyParaEliminator.pas,v $
// Revision 1.2  2013/04/16 09:30:55  fireton
// - �� ����������
//
// Revision 1.1  2013/04/16 08:09:55  narry
// �������������� ��������������
//


interface

uses
  dd_lcTextFormatter2, k2Interfaces;

type
 TafEmptyParaEliminator = class(Tdd_lcBaseFormatter)
 protected
  procedure ClearParameters; override;
  function EnableWrite(const aPara: Ik2Tag): Tdd_lcTextReaction; override;
 end;

implementation

uses
  k2Tags;

procedure TafEmptyParaEliminator.ClearParameters;
begin
 inherited ClearParameters;
 CheckEmptyPara:= True;
end;

function TafEmptyParaEliminator.EnableWrite(const aPara: Ik2Tag): Tdd_lcTextReaction;
begin
 Result:= lcWrite;
 if not InTable and (aPara.StrA[k2_tiText] = '') then
   Result:= lcSkip;
end;

end.
