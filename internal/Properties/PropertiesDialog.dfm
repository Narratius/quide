object PropDialog: TPropDialog
  Left = 0
  Top = 0
  Caption = 'PropDialog'
  ClientHeight = 242
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtontsPanel: TPanel
    Left = 445
    Top = 0
    Width = 89
    Height = 242
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object Button2: TButton
      Left = 6
      Top = 40
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 0
    end
    object Button1: TButton
      Left = 6
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1050
      Default = True
      ModalResult = 1
      TabOrder = 1
    end
  end
end
