object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 118
    Top = 57
    Width = 133
    Height = 2
  end
  object ShowButton: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 0
    OnClick = ShowButtonClick
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 48
    Width = 97
    Height = 17
    Caption = #1052#1077#1090#1082#1080' '#1089#1074#1077#1088#1093#1091
    TabOrder = 1
  end
  object SerializeButton: TButton
    Left = 96
    Top = 16
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 2
    OnClick = SerializeButtonClick
  end
  object RestoreButton: TButton
    Left = 176
    Top = 16
    Width = 75
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 3
    OnClick = RestoreButtonClick
  end
  object InsertButton: TButton
    Left = 256
    Top = 16
    Width = 75
    Height = 25
    Caption = #1042#1089#1090#1072#1074#1080#1090#1100
    TabOrder = 4
  end
  object ActionList2: TActionList
    Left = 32
    Top = 128
    object Action1: TAction
      Caption = 'Action1'
    end
    object Action2: TAction
      Caption = 'Action2'
    end
  end
end
