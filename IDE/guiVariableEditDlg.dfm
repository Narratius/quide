object OKRightDlg: TOKRightDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 284
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 17
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 417
    Height = 273
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 57
    Height = 17
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 21
    Height = 17
    Caption = #1058#1080#1087
  end
  object OKBtn: TButton
    Left = 492
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 492
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object EditCaption: TEdit
    Left = 80
    Top = 16
    Width = 233
    Height = 25
    TabOrder = 2
  end
  object ComboType: TComboBox
    Left = 72
    Top = 56
    Width = 233
    Height = 25
    Style = csDropDownList
    ItemHeight = 17
    TabOrder = 3
    Items.Strings = (
      #1063#1080#1089#1083#1086#1074#1086#1081
      #1058#1077#1082#1089#1090#1086#1074#1099#1081
      #1051#1086#1075#1080#1095#1077#1089#1082#1080#1081
      #1055#1077#1088#1077#1095#1080#1089#1083#1080#1084#1099#1081)
  end
  object butDefineEnum: TButton
    Left = 311
    Top = 56
    Width = 105
    Height = 25
    Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100
    TabOrder = 4
    Visible = False
  end
end