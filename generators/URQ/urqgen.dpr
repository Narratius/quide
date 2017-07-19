program urqgen;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  StrUtils,
  Classes,
  SimpleXML;

procedure OutString(aStr: Ansistring);
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

function E(const aString: TXMLString): TXMLString;
begin
 Result := AnsiReplaceStr(aString, '#', '##35$');
 Result := AnsiReplaceStr(Result, #13#10, '#/$');
 Result := AnsiReplaceStr(Result, '&', '##38$');
end;

function GetProperty(aNode: IxmlNode; const aAlias: TxmlString): TxmlString;
var
 l_Node, l_Value: IxmlNode;
 i: Integer;
 l_Str: TxmlString;
begin
  Result:= '';
  for I := 0 to Pred(aNode.ChildNodes.Count) do
  begin
    l_Node:= aNode.ChildNodes[i];
    l_Str:= E(l_Node.GetChildText('Alias'));
    if AnsiSameText(l_Str, aAlias) then
    begin
     Result:= E(l_Node.GetChildText('Value'));
     break
    end;
  end;
end;

var
 l_ModelFN, l_QuestFN: string;
 l_Str, l_Start: TXMLstring;
 l_FS: TFileStream;
 l_MDoc: IXmlDocument;
 l_Root: IXmlNode;
 l_Node, l_Attr: IXmlNode;
 l_Locations, l_Chapters, l_Actions: IXmlNode;
 l_List: IXmlNodeList;
 I, j : Integer;

 procedure QWrite(const aString: AnsiString);
 begin
  if aString <> '' then
   l_FS.WriteBuffer(Pointer(aString)^, Length(aString));
 end;

 procedure QWriteLn(const aString: AnsiString);
 begin
  QWrite(aString);
  QWrite(#13#10);
 end;

 procedure WriteAction(aAction: IXmlNode);
 var
  l_Type: string;
  l_text: IxmlNode;
  i, j: Integer;
 begin
  l_Type := aAction.GetAttr('Type');
  if AnsiSameText(l_Type, 'text') then
  begin
    for I := 0 to Pred(aAction.ChildNodes.Count) do
    begin
      if AnsiSameText(aAction.ChildNodes[i].GetChildText('Alias'), 'Text') then
      begin
        l_Text:= aAction.ChildNodes[i].SelectSingleNode('Value').SelectSingleNode('Texts');
        for j := 0 to Pred(l_text.ChildNodes.Count) do
          QWriteLn('pln '+E(l_text.ChildNodes[j].Text));
        break
      end;
    end;
  end
  else
   OutString('Неизвестный тип действия: '+l_Type);
 end;

 procedure WriteButton(aButton: IXmlNode);
 var
  l_Target: string;
  l_Text: string;
 begin
  l_Target := GetProperty(aButton, 'Target');
  l_Text := GetProperty(aButton, 'Button');
  QWriteLn('btn '+l_Target+', '+l_Text);
 end;

 procedure WriteLocation(aLocation: IXmlNode);
 var
  l_List: IXmlNodeList;
  I: Integer;
 begin
  QWriteLn(#13#10':'+GetProperty(aLocation, 'Caption'));
  l_List := aLocation.SelectSingleNode('Actions').ChildNodes;
  for I := 0 to Pred(l_List.Count) do
  begin
   if AnsiSameText(l_List[i].GetAttr('Type'), 'Button') then
    WriteButton(l_List[i])
   else
    WriteAction(l_List[I]);
  end;
  QWriteLn('end');
 end;


begin
 Writeln('Quide URQ Generator ver. 2.0');
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
   (*
     <Meta>
     <Chapters>
      <Chapter>
        <Property>
         <Start>
        <Locations>
          <Location>
            <Actions>
              <Action Type=>

   *)
    l_Chapters := l_Root.SelectSingleNode('Chapters');
    CheckFormat((l_Chapters <> nil) and (l_Chapters.ChildNodes.Count > 0));
    l_Start:= GetProperty(l_Chapters.ChildNodes[0], 'Start');
    l_Node := l_Root.SelectSingleNode('Meta');
    if l_Node <> nil then
    begin
     QWriteLn(':Quide_META');
     l_Str:= GetProperty(l_Node, 'Caption');
     QWriteln('gametitle = "'+l_Str+'"');
     QWriteLn('pln #/$'+l_Str);
     QWriteLn('pln #/$'+GetProperty(l_node, 'hint')+'#/$');
     QWriteLn('pln #/$Автор: '+ GetProperty(l_Node, 'Author'));
     QWriteLn('btn '+l_Start+', Начать игру');
     QWriteLn('end'#13#10);
    end
    else
     QWriteLn('goto '+l_Start);

    for I := 0 to Pred(l_Chapters.ChildNodes.Count) do
    begin
      l_Locations:= l_Chapters.ChildNodes[i].SelectSingleNode('Locations');
      l_List := l_Locations.ChildNodes;
      for j := 0 to Pred(l_List.Count) do
       WriteLocation(l_List.Item[j]);
    end; // for i
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
