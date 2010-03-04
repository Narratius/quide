object dobTextFrame: TdobTextFrame
  Left = 0
  Top = 0
  Width = 435
  Height = 42
  TabOrder = 0
  object TextMemo: TMemo
    Left = 0
    Top = 0
    Width = 435
    Height = 42
    Align = alClient
    Constraints.MinHeight = 24
    Lines.Strings = (
      #1044#1086#1073#1072#1074#1100#1090#1077' '#1089#1074#1086#1081' '#1090#1077#1082#1089#1090'...')
    TabOrder = 0
    OnChange = TextMemoChange
  end
end
