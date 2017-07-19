unit ddProgressor;

interface
Uses
 Generics.Collections,
 ComCtrls, Controls;

type
 TddProgressState = (dd_psStart, dd_psUpdate, dd_psFinish);
 TddProgressEvent = procedure (aState: TddProgressState; aValue: Integer; aMessage: String = '') of object;

 TddProcess = class
 private
   FCurrent: Integer;
   FTotal: Integer;
   FTitle: String;
   f_Message: String;
   procedure pm_SetCurrent(const Value: Integer);
   procedure pm_SetTitle(const Value: String);
   procedure pm_SetTotal(const Value: Integer);
   function pm_Current: Integer;
   function pm_GetTitle: String;
   function pm_GetTotal: Integer;
    function pm_GetMessage: String;
    procedure pm_SetMessage(const Value: String);
 public
   procedure Start;
   procedure Update(aStep: Integer = 1; const aMessage: String = '');
   procedure Finish;
 public
  property Title: String read pm_GetTitle write pm_SetTitle;
  property Total: Integer read pm_GetTotal write pm_SetTotal;
  property Current: Integer read pm_Current write pm_SetCurrent;
  property Message: String
   read pm_GetMessage
   write pm_SetMessage;
 end;

 TddProgressor = class
 private
   f_ProgressBar: TProgressBar;
   f_Processes: TObjectList<TddProcess>;
   f_InfoControl: TControl;
    function pm_GetCurrentProcess: TddProcess;
    procedure ShowMesage(const aMessage: string);
 protected
  procedure ShowProcess;
 protected
  property CurrentProcess: TddProcess
   read pm_GetCurrentProcess;
 public
  constructor Create(aProgressBar: TProgressBar; aInfoControl: TControl);
  destructor Destroy; override;
  procedure AddProcess(aMaxValue: Integer; const  aTitle: String);
  procedure StartProcess(const aMessage: String = 'Процесс начался');
  procedure UpdateProcess(aIncValue: Integer = 1; const aMessage: String = '');
  procedure FinishProcess(const aMessage: String = 'Процесс завершился');
 public

 end;

implementation

Uses
  SysUtils, Forms, StdCtrls;

{ TddProcess }

procedure TddProcess.Finish;
begin
 Current:= Total;
end;

function TddProcess.pm_Current: Integer;
begin
 Result:= fCurrent;
end;

function TddProcess.pm_GetMessage: String;
begin
 Result:= f_Message;
end;

function TddProcess.pm_GetTitle: String;
begin
 Result:= fTitle;
end;

function TddProcess.pm_GetTotal: Integer;
begin
 Result:= fTotal;
end;

procedure TddProcess.pm_SetCurrent(const Value: Integer);
begin
  FCurrent := Value;
end;

procedure TddProcess.pm_SetMessage(const Value: String);
begin
 if Value <> '' then
  f_Message:= Value;
end;

procedure TddProcess.pm_SetTitle(const Value: String);
begin
  FTitle := Value;
  Message:= Value;
end;

procedure TddProcess.pm_SetTotal(const Value: Integer);
begin
  FTotal := Value;
end;

procedure TddProcess.Start;
begin
 FCurrent:= 0;
end;

procedure TddProcess.Update(aStep: Integer; const aMessage: String);
begin
 Inc(fCurrent, aStep);
 Message:= aMessage;
end;

{ TddProgressor }

procedure TddProgressor.AddProcess(aMaxValue: Integer; const aTitle: String);
var
 l_P: TddProcess;
begin
  l_P:= TddProcess.Create;
  l_P.Total:= aMaxValue;
  l_P.Title:= aTitle;
  f_Processes.Add(l_P);
end;

constructor TddProgressor.Create(aProgressBar: TProgressBar; aInfoControl: TControl);
begin
  inherited Create;
  f_Processes:= TObjectList<TddProcess>.Create;
  f_ProgressBar:= aProgressBar;
  f_InfoControl:= aInfoControl;
end;

destructor TddProgressor.Destroy;
begin
  FreeAndNil(f_Processes);
  inherited;
end;

procedure TddProgressor.FinishProcess;
begin
  CurrentProcess.Finish;
  ShowProcess;
  ShowMesage(aMessage);
end;

procedure TddProgressor.ShowMesage(const aMessage: string);
begin
  if f_InfoControl is TListBox then
    TListBox(f_InfoControl).Items.Add(aMessage)
  else if f_InfoControl is TLabel then
    TLabel(f_InfoControl).Caption := aMessage;
end;

function TddProgressor.pm_GetCurrentProcess: TddProcess;
begin
  Result:= f_Processes[Pred(f_Processes.Count)]
end;

procedure TddProgressor.ShowProcess;
begin
  // Собственно визуализация прогресса
 if f_ProgressBar <> nil then
 begin
  f_ProgressBar.Max:= CurrentProcess.Total;
  f_ProgressBar.Position:= CurrentProcess.Current;
  Application.ProcessMessages;
 end;
end;

procedure TddProgressor.StartProcess(const aMessage: String);
begin
 CurrentProcess.Start;
 ShowProcess;
 ShowMesage(CurrentProcess.Title);
end;

procedure TddProgressor.UpdateProcess(aIncValue: Integer = 1; const aMessage: String = '');
begin
 CurrentProcess.Update(aIncValue, aMessage);
 ShowProcess;
end;

end.
