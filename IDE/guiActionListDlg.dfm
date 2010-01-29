object ActionListDlg: TActionListDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 188
  ClientWidth = 432
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 337
    Height = 172
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 132
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1076#1077#1081#1089#1090#1074#1080#1080' '#1083#1086#1082#1072#1094#1080#1080
  end
  object OKBtn: TButton
    Left = 351
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 351
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 16
    Top = 38
    Width = 241
    Height = 131
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = EditButtonClick
  end
  object NewButton: TButton
    Left = 263
    Top = 38
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 3
    OnClick = NewButtonClick
  end
  object EditButton: TButton
    Left = 263
    Top = 66
    Width = 75
    Height = 25
    Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100
    TabOrder = 4
    OnClick = EditButtonClick
  end
  object DeleteButton: TButton
    Left = 263
    Top = 97
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 5
    OnClick = DeleteButtonClick
  end
end
