object LocationEditExDlg: TLocationEditExDlg
  Left = 336
  Top = 121
  Width = 870
  Height = 640
  Caption = 'LocationEditExDlg'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object EditPanel: TPanel
    Left = 0
    Top = 0
    Width = 854
    Height = 604
    AutoSize = True
    Constraints.MinHeight = 604
    Constraints.MinWidth = 854
    PopupMenu = PopupMenu1
    TabOrder = 0
  end
  object PopupMenu1: TPopupMenu
    Left = 256
    Top = 248
    object N1: TMenuItem
      Action = AddText
    end
    object N2: TMenuItem
      Action = AddVarAction
    end
    object N3: TMenuItem
      Action = AddLogic
    end
    object N4: TMenuItem
      Action = AddInventory
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Action = AddButton
    end
  end
  object ActionList1: TActionList
    Left = 392
    Top = 208
    object AddText: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1077#1082#1089#1090
      OnExecute = AddTextExecute
    end
    object AddVarAction: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077' '#1089' '#1087#1077#1088#1077#1084#1077#1085#1085#1086#1081
    end
    object AddLogic: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077
    end
    object AddButton: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1085#1086#1087#1082#1091
    end
    object AddInventory: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077' '#1089' '#1080#1085#1074#1077#1085#1090#1072#1088#1077#1084
    end
  end
end
