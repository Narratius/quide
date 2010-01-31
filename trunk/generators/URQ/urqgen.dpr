program urqgen;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  StrUtils,
  Classes,
  SimpleXML;

procedure OutString(aStr: string);
var
 l_Str: string;
begin
 SetLength(l_Str, Length(aStr));
 AnsiToOem(PAnsiChar(aStr), PAnsiChar(l_Str));
 Writeln(l_Str);
end;

procedure ModelFormatError;
begin
 OutString('Ошибка формата файла модели.');
 Halt(1);
end;

procedure CheckFormat(aCondition: Boolean);
begin
 if not aCondition then
  ModelFormatError;
end;

function E(const aString: string): string;
begin
 Result := AnsiReplaceStr(aString, '#', '##35$');
 Result := AnsiReplaceStr(Result, #13#10, '#/$');
 Result := AnsiReplaceStr(Result, '&', '##38$');
end;

var
 l_ModelFN, l_QuestFN: string;
 l_Str: string;
 l_FS: TFileStream;
 l_MDoc: IXmlDocument;
 l_Root: IXmlNode;
 l_Node: IXmlNode;
 l_Locations: IXmlNode;
 l_List: IXmlNodeList;
 I : Integer;

 procedure QWrite(const aString: string);
 begin
  if aString <> '' then
   l_FS.WriteBuffer(Pointer(aString)^, Length(aString));
 end;

 procedure QWriteLn(const aString: string);
 begin
  QWrite(aString);
  QWrite(#13#10);
 end;

 procedure WriteAction(aAction: IXmlNode);
 var
  l_Type: string;
 begin
  l_Type := aAction.GetAttr('Type');
  if AnsiSameText(l_Type, 'text') then
  begin
   QWriteLn('pln '+E(aAction.Text));
  end
  else
   OutString('Неизвестный тип действия: '+l_Type);
 end;

 procedure WriteButton(aButton: IXmlNode);
 var
  l_Target: string;
  l_Text: string;
 begin
  l_Target := aButton.GetAttr('Target');
  l_Text := E(aButton.GetAttr('Caption'));
  QWriteLn('btn '+l_Target+', '+l_Text);
 end;

 procedure WriteLocation(aLocation: IXmlNode);
 var
  l_List: IXmlNodeList;
  I: Integer;
 begin
  QWriteLn(#13#10':'+aLocation.GetAttr('Caption'));
  l_List := aLocation.SelectSingleNode('Actions').ChildNodes;
  for I := 0 to Pred(l_List.Count) do
   WriteAction(l_List.Item[I]);
  l_List := aLocation.SelectSingleNode('Buttons').ChildNodes;
  for I := 0 to Pred(l_List.Count) do
   WriteButton(l_List.Item[I]);
  QWriteLn('end');
 end;


begin
 Writeln('Quide URQ Generator   v. 1.0');
 if ParamCount = 0 then
 begin
  OutString('Использование: URQGEN <имя файла модели> [<имя файла квеста>]');
  Halt;
 end;
 l_ModelFN := ParamStr(1);
 if FileExists(l_ModelFN) then
 begin
  if ParamCount > 1 then
   l_QuestFN := ParamStr(2)
  else
   l_QuestFN := ChangeFileExt(l_ModelFN, '.qst');

  l_MDoc := LoadXmlDocument(l_ModelFN);
  l_Root := l_MDoc.DocumentElement;
  if l_Root <> nil then
  begin
   l_FS := TFileStream.Create(l_QuestFN, fmCreate);
   try
    l_Locations := l_Root.SelectSingleNode('Locations');
    CheckFormat((l_Locations <> nil) and (l_Locations.ChildNodes.Count > 0));
    l_Node := l_Root.SelectSingleNode('Meta');
    if l_Node <> nil then
    begin
     QWriteLn(':Quide_META');
     l_Str := E(l_Node.GetChildText('Title'));
     QWriteln('gametitle = "'+l_Str+'"');
     QWriteLn('pln #/$'+l_Str);
     QWriteLn('pln #/$Автор: '+E(l_Node.GetChildText('Author')));
     QWriteLn('pln #/$'+E(l_Node.GetChildText('Description'))+'#/$');
     QWriteLn('btn '+l_Locations.GetAttr('Start')+', Начать игру');
     QWriteLn('end'#13#10);
    end
    else
     QWriteLn('goto '+l_Locations.GetAttr('Start'));
    l_List := l_Locations.ChildNodes;
    for I := 0 to Pred(l_List.Count) do
     WriteLocation(l_List.Item[I]);
   finally
    l_FS.Free;
   end;
  end
  else
   ModelFormatError;
 end
 else
  OutString(Format('Файл %s не найден.', [l_ModelFN]));
end.
