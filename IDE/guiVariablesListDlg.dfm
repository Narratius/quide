object VariablesListDlg: TVariablesListDlg
  Left = 417
  Top = 271
  BorderStyle = bsDialog
  Caption = #1055#1077#1088#1077#1084#1077#1085#1085#1099#1077
  ClientHeight = 252
  ClientWidth = 465
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 361
    Height = 241
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 380
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 380
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ListVariables: TListBox
    Left = 16
    Top = 16
    Width = 265
    Height = 225
    ItemHeight = 13
    TabOrder = 2
  end
  object Button1: TButton
    Left = 288
    Top = 16
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 3
  end
  object Button2: TButton
    Left = 288
    Top = 48
    Width = 75
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 4
  end
  object Button3: TButton
    Left = 288
    Top = 80
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 5
  end
end
