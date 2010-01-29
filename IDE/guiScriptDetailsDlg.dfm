object ScriptDetailsDlg: TScriptDetailsDlg
  Left = 1733
  Top = 323
  BorderStyle = bsDialog
  Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1089#1094#1077#1085#1072#1088#1080#1103
  ClientHeight = 271
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
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
    Width = 385
    Height = 257
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 61
    Height = 17
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '
  end
  object Label2: TLabel
    Left = 16
    Top = 56
    Width = 180
    Height = 17
    Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
  end
  object OKBtn: TButton
    Left = 404
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 404
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object editCaption: TEdit
    Left = 16
    Top = 32
    Width = 369
    Height = 25
    TabOrder = 2
  end
  object memoDescription: TMemo
    Left = 16
    Top = 72
    Width = 369
    Height = 185
    Lines.Strings = (
      '')
    TabOrder = 3
  end
end
