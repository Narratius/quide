object ActionEditDlg: TActionEditDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1086#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
  ClientHeight = 366
  ClientWidth = 561
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 465
    Height = 350
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 50
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 50
    Height = 13
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077
  end
  object Label3: TLabel
    Left = 16
    Top = 309
    Width = 105
    Height = 13
    Caption = #1055#1077#1088#1077#1093#1086#1076' '#1085#1072' '#1083#1086#1082#1072#1094#1080#1102
  end
  object OKBtn: TButton
    Left = 479
    Top = 6
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object CancelBtn: TButton
    Left = 479
    Top = 36
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object editCaption: TEdit
    Left = 16
    Top = 32
    Width = 449
    Height = 21
    TabOrder = 0
    OnChange = editCaptionChange
  end
  object memoDescription: TMemo
    Left = 16
    Top = 72
    Width = 449
    Height = 231
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 328
    Width = 449
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = #1042#1099#1073#1077#1088#1080#1090#1077' '#1080#1083#1080' '#1079#1072#1076#1072#1081#1090#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1083#1086#1082#1072#1094#1080#1080
  end
end
