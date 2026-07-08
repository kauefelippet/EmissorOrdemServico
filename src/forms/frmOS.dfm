object OS: TOS
  Left = 0
  Top = 0
  Caption = 'Ordens de Servi'#231'o'
  ClientHeight = 650
  ClientWidth = 1024
  Color = 15921906
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 17
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      1024
      80)
    object lblTitulo: TLabel
      Left = 24
      Top = 16
      Width = 162
      Height = 25
      Caption = 'Ordens de Servi'#231'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2960685
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitulo: TLabel
      Left = 24
      Top = 44
      Width = 283
      Height = 17
      Caption = 'Consulte, emita e gerencie as Ordens de Servi'#231'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 7368816
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object edtBusca: TEdit
      Left = 600
      Top = 24
      Width = 280
      Height = 25
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TextHint = 'Pesquise por n'#250'mero, remetente...'
      OnChange = edtBuscaChange
    end
    object btnBuscar: TButton
      Left = 888
      Top = 24
      Width = 112
      Height = 32
      Anchors = [akTop, akRight]
      Caption = 'Buscar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnBuscarClick
    end
  end
  object pnlCentro: TPanel
    Left = 0
    Top = 80
    Width = 1024
    Height = 490
    Align = alClient
    BevelOuter = bvNone
    Color = 15921906
    Padding.Left = 24
    Padding.Top = 16
    Padding.Right = 24
    Padding.Bottom = 16
    ParentBackground = False
    TabOrder = 1
    object gridOS: TDBGrid
      Left = 24
      Top = 16
      Width = 976
      Height = 458
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsOS
      FixedColor = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3815994
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = 2960685
      TitleFont.Height = -13
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = [fsBold]
      OnDblClick = gridOSDblClick
      OnKeyDown = gridOSKeyDown
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 570
    Width = 1024
    Height = 80
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      1024
      80)
    object btnExcluir: TButton
      Left = 24
      Top = 22
      Width = 110
      Height = 36
      Caption = 'Excluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnExcluirClick
    end
    object btnAbrir: TButton
      Left = 764
      Top = 22
      Width = 110
      Height = 36
      Anchors = [akTop, akRight]
      Caption = 'Visualizar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnAbrirClick
    end
    object btnNovo: TButton
      Left = 888
      Top = 22
      Width = 112
      Height = 36
      Anchors = [akTop, akRight]
      Caption = 'Nova OS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnNovoClick
    end
  end
  object tmrBusca: TTimer
    Enabled = False
    OnTimer = tmrBuscaTimer
    Left = 40
    Top = 112
  end
  object qryOS: TFDQuery
    Left = 112
    Top = 112
  end
  object dsOS: TDataSource
    DataSet = qryOS
    Left = 184
    Top = 112
  end
end
