object EnumEditDlg: TEnumEditDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 272
  ClientWidth = 471
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 369
    Height = 257
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 388
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 388
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
    Top = 16
    Width = 257
    Height = 241
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = ListBox1DblClick
  end
  object AddButton: TButton
    Left = 288
    Top = 16
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 3
    OnClick = AddButtonClick
  end
  object EditButton: TButton
    Left = 288
    Top = 48
    Width = 75
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 4
    OnClick = EditButtonClick
  end
  object DelButton: TButton
    Left = 288
    Top = 80
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 5
    OnClick = DelButtonClick
  end
end
