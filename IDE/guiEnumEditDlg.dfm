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
  object EnumItems: TMemo
    Left = 16
    Top = 16
    Width = 353
    Height = 241
    Lines.Strings = (
      '')
    TabOrder = 2
  end
end
