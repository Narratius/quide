object ActionFrame: TActionFrame
  Left = 0
  Top = 0
  Width = 559
  Height = 214
  Align = alClient
  TabOrder = 0
  object EditPlace: TScrollBox
    Left = 0
    Top = 0
    Width = 559
    Height = 214
    Align = alClient
    TabOrder = 0
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 16
    object N1: TMenuItem
      Action = TextAction
    end
    object N2: TMenuItem
      Action = VarAction
    end
    object N3: TMenuItem
      Action = LogicAction
    end
    object N4: TMenuItem
      Action = GotoAction
    end
    object N6: TMenuItem
      Action = ButtonAction
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N7: TMenuItem
      Action = TuneAction
    end
  end
  object ActionList1: TActionList
    Left = 120
    Top = 16
    object TextAction: TAction
      Caption = #1058#1077#1082#1089#1090
    end
    object ButtonAction: TAction
      Caption = #1050#1085#1086#1087#1082#1072
    end
    object VarAction: TAction
      Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
    end
    object LogicAction: TAction
      Caption = #1059#1089#1083#1086#1074#1080#1077
    end
    object GotoAction: TAction
      Caption = #1055#1077#1088#1077#1093#1086#1076
    end
    object TuneAction: TAction
      Caption = #1059#1087#1086#1088#1103#1076#1086#1095#1080#1090#1100
    end
  end
end
