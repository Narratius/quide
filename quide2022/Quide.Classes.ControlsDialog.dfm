object QuideClassDialog: TQuideClassDialog
  Left = 0
  Top = 0
  Caption = 'QuideClassDialog'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlControls: TPanel
    Left = 0
    Top = 0
    Width = 544
    Height = 299
    Align = alClient
    TabOrder = 0
  end
  object pnlButtons: TPanel
    Left = 544
    Top = 0
    Width = 91
    Height = 299
    Align = alRight
    TabOrder = 1
    object btnOK: TButton
      Left = 6
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 6
      Top = 39
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
end
