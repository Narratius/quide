object VarActionFrame: TVarActionFrame
  Left = 0
  Top = 0
  Width = 392
  Height = 70
  Constraints.MinHeight = 70
  Constraints.MinWidth = 392
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 75
    Height = 17
    Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 56
    Height = 17
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077
  end
  object ComboVariables: TComboBox
    Left = 88
    Top = 8
    Width = 201
    Height = 25
    Style = csDropDownList
    ItemHeight = 17
    TabOrder = 0
    OnChange = ComboVariablesChange
  end
  object Button1: TButton
    Left = 304
    Top = 8
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
end
