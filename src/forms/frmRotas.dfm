object Rotas: TRotas
  Left = 0
  Top = 0
  Caption = 'Rotas'
  ClientHeight = 479
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 848
    Height = 45
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edtBusca: TEdit
      Left = 8
      Top = 8
      Width = 832
      Height = 25
      Cursor = crIBeam
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TextHint = 'Buscar por Raz'#227'o Social/CPF/CNPJ/Nome Fantasia'
      OnChange = edtBuscaChange
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 434
    Width = 848
    Height = 45
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnNovo: TButton
      Left = 279
      Top = 6
      Width = 290
      Height = 35
      Cursor = crHandPoint
      Caption = #10133' Novo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnEditar: TButton
      Left = 8
      Top = 6
      Width = 265
      Height = 35
      Cursor = crHandPoint
      Caption = #9999#65039' Editar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnEditarClick
    end
    object btnExcluir: TButton
      Left = 575
      Top = 6
      Width = 265
      Height = 35
      Cursor = crHandPoint
      Caption = #55357#56785#65039' Excluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnExcluirClick
    end
  end
  object pnlCentro: TPanel
    Left = 0
    Top = 45
    Width = 848
    Height = 389
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object gridRotas: TDBGrid
      Left = 0
      Top = 0
      Width = 848
      Height = 389
      Align = alClient
      BorderStyle = bsNone
      DataSource = dsRotas
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = [fsBold]
      OnDblClick = gridRotasDblClick
      OnKeyDown = gridRotasKeyDown
    end
  end
  object qryRotas: TFDQuery
    CachedUpdates = True
    Left = 796
    Top = 371
  end
  object dsRotas: TDataSource
    DataSet = qryRotas
    Left = 796
    Top = 299
  end
  object tmrBusca: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = tmrBuscaTimer
    Left = 796
    Top = 48
  end
end
