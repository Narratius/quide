unit quideGUILink;

interface
Uses
 Classes, Types,
 quideObject;

Type
 TquideGUILink = class(TquideObject)
  private
    FGraphID: DWORD;
    procedure SetGraphID(const Value: DWORD);
 public
  procedure Load(aStream: TStream); override;
  procedure Save(aStream: TStream); override;

  property GraphID: DWORD read FGraphID write SetGraphID; // в общем случае идентификатор прямоугольника
 end;

implementation

{ TquideGUILink }

procedure TquideGUILink.Load(aStream: TStream);
begin
  inherited;

end;

procedure TquideGUILink.Save(aStream: TStream);
begin
  inherited;

end;

procedure TquideGUILink.SetGraphID(const Value: DWORD);
begin
  FGraphID := Value;
end;

end.
