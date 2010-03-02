unit dobFileStorage;

interface

uses Controls, Classes, QuestModeler;

procedure SaveModel(const aFileName: String; theParent: TWinControl; theModel: TdcScript);

procedure LoadModel(const aFileName: String; theOwner: TComponent; theParent: TWinControl;
    PostLoadProc: TNotifyEvent; theModel: TdcScript);

implementation

uses
 DrawObjects1, SysUtils, ZipMstr;
const
 ObjectsPart = 'objects.dat';
 ModelPart   = 'model.xml';

procedure LoadModel(const aFileName: String; theOwner: TComponent; theParent: TWinControl;
    PostLoadProc: TNotifyEvent; theModel: TdcScript);
var
 strings: TStringList;
begin
 with TZipMaster.Create(nil) do
 try
  Dll_Load:= True;
  try
   ZipFileName:= aFileName;
   // На самом деле, aFilename - Это архив, в котором два потока - объекты и их описание
   if DirEntry[IndexOf(ObjectsPart)]^.UncompressedSize > 0 then
   begin
    strings := TStringList.Create;
    try
     strings.LoadFromStream(ExtractFileToStream(ObjectsPart));
     DrawObjects1.LoadDrawObjectsFromStrings(strings, theOwner, theParent, PostLoadProc);
    finally
     strings.Free;
    end;
   end; 
   theModel.LoadFromStream(ExtractFileToStream(ModelPart));
  finally
   Dll_Load:= False;
  end;
 finally
  Free;
 end;
end;

procedure SaveModel(const aFileName: String; theParent: TWinControl; theModel: TdcScript);
var
 i: integer;
 l_saveList: TList;
 l_strings: TStringList;
 l_Stream: TFileStream;
begin
 // На самом деле, aFilename - Это архив, в котором два потока - объекты и их описание
 with TZipMaster.Create(nil) do
 try
  Dll_Load:= True;
  try
   ZipFileName:= aFileName;
   l_saveList := TList.Create;
   l_strings := TStringList.Create;
   try
    with theParent do
     for i := 0 to controlCount -1 do
      if (Controls[i] is TDrawObject) then l_saveList.Add(Controls[i]);
     DrawObjects1.SaveDrawObjectsToStrings(l_saveList, l_strings);
     l_strings.SaveToStream(ZipStream);
   finally
    l_saveList.Free;
    l_strings.Free;
   end;
   AddStreamToFile(ObjectsPart, 0, 0);
   ZipStream.Size:= 0;
   theModel.SaveToStream(ZipStream);
   AddStreamToFile(ModelPart, 0, 0);
  finally
   DLL_Load:= false;
  end;
 finally
  Free;
 end;
end;

end.
