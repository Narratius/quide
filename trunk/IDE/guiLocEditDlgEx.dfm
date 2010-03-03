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
  object EditPlace: TScrollBox
    Left = 0
    Top = 40
    Width = 854
    Height = 562
    PopupMenu = PopupMenu1
    TabOrder = 0
  end
  object OKButton: TButton
    Left = 688
    Top = 8
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 1
  end
  object CancelButton: TButton
    Left = 768
    Top = 8
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object ActionList1: TActionList
    Left = 456
    Top = 152
    object TextAction: TAction
      Caption = #1058#1077#1082#1089#1090
      OnExecute = AddTextExecute
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
  end
  object PopupMenu1: TPopupMenu
    Left = 288
    Top = 264
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
    object N5: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Action = ButtonAction
    end
  end
end
