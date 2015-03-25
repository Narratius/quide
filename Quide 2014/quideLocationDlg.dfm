object quideLocationDialog: TquideLocationDialog
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1083#1086#1082#1072#1094#1080#1080
  ClientHeight = 242
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 527
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object WorkPanel: TPanel
    Left = 0
    Top = 25
    Width = 440
    Height = 217
    Align = alClient
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 440
    Top = 25
    Width = 87
    Height = 217
    Align = alRight
    TabOrder = 2
    object Button1: TButton
      Left = 8
      Top = 0
      Width = 75
      Height = 25
      Caption = #1054#1050
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 8
      Top = 31
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = actNewText
              end>
            Caption = #1044#1077#1081#1089#1090#1074#1080#1103
          end>
      end
      item
        Items = <
          item
            Items = <
              item
                Action = actNewText
              end
              item
                Action = actButton
              end>
            Caption = #1044#1077#1081#1089#1090#1074#1080#1103
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 32
    Top = 168
    StyleName = 'Platform Default'
    object actNewText: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1058#1077#1082#1089#1090
      Hint = #1044#1086#1073#1072#1074#1083#1103#1077#1090' '#1073#1083#1086#1082' '#1074#1099#1074#1086#1076#1072' '#1090#1077#1082#1089#1090#1072
      OnExecute = actNewTextExecute
    end
    object actButton: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1050#1085#1086#1087#1082#1072
      Hint = #1044#1086#1073#1072#1074#1083#1103#1077#1090' '#1082#1085#1086#1087#1082#1091' '#1087#1077#1088#1077#1093#1086#1076#1072
      OnExecute = actButtonExecute
    end
  end
end
