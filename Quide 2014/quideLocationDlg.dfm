object quideLocationDialog: TquideLocationDialog
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1083#1086#1082#1072#1094#1080#1080
  ClientHeight = 499
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 848
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
    Width = 761
    Height = 474
    Align = alClient
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 761
    Top = 25
    Width = 87
    Height = 474
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
    Left = 784
    Top = 152
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
    object actEditButton: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1082#1085#1086#1087#1082#1091
      OnExecute = actEditButtonExecute
    end
    object actVariable: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
      OnExecute = actVariableExecute
    end
    object actInventory: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1100
      OnExecute = actInventoryExecute
    end
    object actLogical: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077
      OnExecute = actLogicalExecute
    end
    object actDelete: TAction
      Category = #1044#1077#1081#1089#1090#1074#1080#1103
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 784
    Top = 97
    object MenuText: TMenuItem
      Action = actNewText
    end
    object MenuButton: TMenuItem
      Action = actButton
    end
    object menuVariable: TMenuItem
      Action = actVariable
    end
    object menuInventary: TMenuItem
      Action = actInventory
    end
    object N1: TMenuItem
      Action = actLogical
    end
  end
end
