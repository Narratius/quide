object LocationEditExDlg: TLocationEditExDlg
  Left = 366
  Top = 194
  Width = 870
  Height = 600
  Caption = 'LocationEditExDlg'
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 854
    Height = 65
    Align = alTop
    TabOrder = 0
    DesignSize = (
      854
      65)
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 50
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
    end
    object Label2: TLabel
      Left = 16
      Top = 40
      Width = 50
      Height = 13
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    end
    object editCaption: TEdit
      Left = 96
      Top = 8
      Width = 537
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object HintEdit: TEdit
      Left = 96
      Top = 32
      Width = 537
      Height = 21
      TabOrder = 1
    end
    object OKButton: TButton
      Left = 686
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 2
    end
    object CancelButton: TButton
      Left = 768
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 3
    end
  end
end
