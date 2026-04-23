object Clientes: TClientes
  Left = 0
  Top = 0
  Caption = 'Clientes'
  ClientHeight = 480
  ClientWidth = 655
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 655
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edtBusca: TEdit
      Left = 8
      Top = 10
      Width = 300
      Height = 23
      TabOrder = 0
      TextHint = 'Buscar por nome ou documento'
    end
    object btnBuscar: TButton
      Left = 314
      Top = 10
      Width = 75
      Height = 23
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarClick
    end
  end
  object pnlRodape: TPanel
    Left = 0
    Top = 435
    Width = 655
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnNovo: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Novo'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnSalvar: TButton
      Left = 89
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Salvar'
      TabOrder = 1
      OnClick = btnSalvarClick
    end
    object btnExcluir: TButton
      Left = 170
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = btnExcluirClick
    end
  end
  object pnlCentro: TPanel
    Left = 0
    Top = 45
    Width = 655
    Height = 390
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object gridClientes: TDBGrid
      Left = 0
      Top = 0
      Width = 655
      Height = 390
      Align = alClient
      DataSource = dsClientes
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
  end
  object qryClientes: TFDQuery
    CachedUpdates = True
    Left = 280
    Top = 435
  end
  object dsClientes: TDataSource
    DataSet = qryClientes
    Left = 352
    Top = 435
  end
end
