object ConfigDlg: TConfigDlg
  Left = 0
  Top = 0
  Caption = 'ConfigDlg'
  ClientHeight = 446
  ClientWidth = 692
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 401
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object ListSection: TListBox
      Left = 1
      Top = 1
      Width = 183
      Height = 399
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = ListSectionClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 401
    Width = 692
    Height = 45
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 525
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1050
      ModalResult = 1
      TabOrder = 0
    end
    object Button2: TButton
      Left = 606
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
end
