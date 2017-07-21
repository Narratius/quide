object ButtonEditDialog: TButtonEditDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1083#1086#1082#1072#1094#1080#1080' '#1076#1083#1103' '#1087#1077#1088#1077#1093#1086#1076#1072
  ClientHeight = 122
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 172
    Height = 13
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1083#1086#1082#1072#1094#1080#1102' '#1076#1083#1103' '#1087#1077#1088#1077#1093#1086#1076#1072
  end
  object Label2: TLabel
    Left = 8
    Top = 38
    Width = 68
    Height = 13
    Caption = #1058#1077#1082#1089#1090' '#1082#1085#1086#1087#1082#1080
  end
  object comboLocations: TComboBox
    Left = 186
    Top = 8
    Width = 231
    Height = 21
    TabOrder = 0
  end
  object editCaption: TEdit
    Left = 186
    Top = 35
    Width = 231
    Height = 21
    TabOrder = 1
  end
  object btnOK: TButton
    Left = 248
    Top = 72
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object BtnCancel: TButton
    Left = 342
    Top = 72
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
