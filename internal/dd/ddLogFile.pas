unit ddLogFile;

interface
Uses
 Classes;

type
 TddLogFile = class
 private
  f_Stream: TFileStream;
 public
   constructor Create(const aFileName: String = '');
   destructor Destroy; override;
   procedure Msg(const aText: String); overload;
   procedure Msg(aValue: Int64); overload;
   procedure Msg(const aFormat: String; const Args: array of const); overload;
 end;

procedure Msg2Log(const aText: String); overload;
procedure Msg2Log(aValue: Int64); overload;
procedure Msg2Log(const aFormat: String; const Args: array of const); overload;


implementation

Uses
 SysUtils, StrUtils, Math;

var
 gLogFile : TddLogFile = nil;

procedure pInitLogFile;
begin
 if gLogFile = nil then
  gLogFile:= TddLogFile.Create();
end;

procedure pDoneLogFile;
begin
  FreeAndNil(gLogFile);
end;


procedure Msg2Log(const aText: String);
begin
  pInitLogFile;
  gLogFile.Msg(aText);
end;

procedure Msg2Log(aValue: Int64);
begin
  pInitLogFile;
  gLogFile.Msg(aValue);
end;

procedure Msg2Log(const aFormat: String; const Args: array of const);
begin
  pInitLogFile;
  gLogFile.Msg(aFormat, Args);
end;


{ TddLogFile }

constructor TddLogFile.Create(const aFileName: String);
var
 l_FileName: String;
 l_Mode: Word;
begin
  inherited Create;
  l_FileName:= IfThen(aFileName = '', ChangeFileExt(ParamStr(0), '.log'), aFileName);
  l_Mode:= IfThen(FileExists(l_FileName), fmOpenWrite, fmCreate);
  f_Stream:= TFileStream.Create(l_FileName, l_Mode or fmShareDenyWrite);
  f_Stream.Seek(0, soEnd);
end;

destructor TddLogFile.Destroy;
begin
  FreeAndNil(f_Stream);
  inherited;
end;

procedure TddLogFile.Msg(const aFormat: String; const Args: array of const);
begin
  Msg(Format(aFormat, Args));
end;

procedure TddLogFile.Msg(aValue: Int64);
begin
  Msg(IntToStr(aValue));
end;

procedure TddLogFile.Msg(const aText: String);
var
 l_B: AnsiString;
begin
  l_B:= FormatDateTime('dd-mm-yyyy hh:nn:ss:zzz ', Now) + aText + #13#10;
  f_Stream.Write(l_B[1], Length(l_B));
end;



initialization
finalization
  pDoneLogFile;
end.
