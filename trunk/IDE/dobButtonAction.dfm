object ButtonFrame: TButtonFrame
  Left = 0
  Top = 0
  Width = 435
  Height = 268
  Align = alClient
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  OnResize = FrameResize
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 268
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 113
      Height = 17
      Caption = #1053#1072#1076#1087#1080#1089#1100' '#1085#1072' '#1082#1085#1086#1087#1082#1077
    end
    object Label2: TLabel
      Left = 8
      Top = 40
      Width = 127
      Height = 17
      Caption = #1055#1077#1088#1077#1093#1086#1076' '#1085#1072' '#1083#1086#1082#1072#1094#1080#1102
    end
    object comboLocations: TComboBox
      Left = 144
      Top = 37
      Width = 177
      Height = 25
      Style = csDropDownList
      ItemHeight = 17
      TabOrder = 0
    end
    object editCaption: TEdit
      Left = 144
      Top = 8
      Width = 177
      Height = 25
      TabOrder = 1
    end
    object Button1: TButton
      Left = 328
      Top = 40
      Width = 75
      Height = 25
      Caption = #1053#1086#1074#1072#1103
      TabOrder = 2
      OnClick = Button1Click
    end
  end
end
