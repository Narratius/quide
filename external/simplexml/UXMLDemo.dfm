object MainForm: TMainForm
  Left = 192
  Top = 107
  Width = 1016
  Height = 766
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 561
    Top = 0
    Width = 6
    Height = 693
    Cursor = crHSplit
  end
  object TreeView: TTreeView
    Left = 0
    Top = 0
    Width = 561
    Height = 693
    Align = alLeft
    HideSelection = False
    Indent = 19
    TabOrder = 0
    OnChange = TreeViewChange
  end
  object Panel1: TPanel
    Left = 567
    Top = 0
    Width = 441
    Height = 693
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 0
      Top = 505
      Width = 441
      Height = 6
      Cursor = crVSplit
      Align = alTop
    end
    object AttributMemo: TMemo
      Left = 0
      Top = 0
      Width = 441
      Height = 505
      Align = alTop
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object ValueMemo: TMemo
      Left = 0
      Top = 511
      Width = 441
      Height = 182
      Align = alClient
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 693
    Width = 1008
    Height = 19
    Panels = <
      item
        Width = 400
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object MainMenu: TMainMenu
    Left = 64
    Top = 40
    object FileMenu: TMenuItem
      Caption = '&Datei'
      object NewFileMenu: TMenuItem
        Caption = '&Neu'
        ShortCut = 16462
        Visible = False
      end
      object OpenFileMenu: TMenuItem
        Caption = #214'&ffnen...'
        ShortCut = 16454
        OnClick = OpenFileMenuClick
      end
      object CloseFileMenu: TMenuItem
        Caption = 'Sch&lie'#223'en'
        ShortCut = 16460
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MSaveFileMenu: TMenuItem
        Caption = '&Speichern'
        ShortCut = 16467
        OnClick = MSaveFileMenuClick
      end
      object SaveAsFileMenu: TMenuItem
        Caption = 'Speichern &unter...'
        Visible = False
      end
      object N2: TMenuItem
        Caption = '-'
        Visible = False
      end
      object PrintMenu: TMenuItem
        Caption = '&Drucken'
        ShortCut = 16452
        Visible = False
      end
      object Druckereinrichtung1: TMenuItem
        Caption = 'Drucker&einrichtung...'
        Visible = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object QuitMenu: TMenuItem
        Caption = '&Beenden'
        OnClick = QuitMenuClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Alle Dateien (*.*)|*.*|XML Dateien (*.xml)|*.xml'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 96
    Top = 40
  end
end
