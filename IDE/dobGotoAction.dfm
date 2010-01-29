object GotoActionFrame: TGotoActionFrame
  Left = 0
  Top = 0
  Width = 435
  Height = 268
  Align = alClient
  TabOrder = 0
  OnResize = FrameResize
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 268
    Align = alClient
    TabOrder = 0
    DesignSize = (
      435
      268)
    object LocationList: TListBox
      Left = 8
      Top = 8
      Width = 121
      Height = 225
      Anchors = [akLeft, akTop, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
    object Button1: TButton
      Left = 136
      Top = 8
      Width = 105
      Height = 25
      Caption = #1053#1086#1074#1072#1103' '#1083#1086#1082#1072#1094#1080#1103
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
