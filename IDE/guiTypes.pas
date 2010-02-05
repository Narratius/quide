unit guiTypes;
{ Вспомогательные типы для Quide }

interface

uses Classes;

type
 TGeneratorInfo = class(TCollectionItem)
 private
  f_Caption: String;
  f_Generator: string;
 public
  function Generate(aSourceFile: String): Boolean;
  property Caption: String read f_Caption write f_Caption;
  property Generator: string read f_Generator write f_Generator;
 end;

implementation

function TGeneratorInfo.Generate(aSourceFile: String): Boolean;
begin
 Result:= False;
end;
              ComCtrls
end.
