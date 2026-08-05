object EmissaoOS: TEmissaoOS
  Left = 0
  Top = 0
  Caption = 'Emiss'#227'o de Ordem de Servi'#231'o'
  ClientHeight = 680
  ClientWidth = 1100
  Color = 15921906
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 17
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      1100
      70)
    object lblNumOS: TLabel
      Left = 24
      Top = 22
      Width = 103
      Height = 25
      Caption = 'OS N'#186' 0000'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2960685
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblStatus: TLabel
      Left = 140
      Top = 26
      Width = 76
      Height = 17
      Caption = 'Aguardando'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object dtpData: TDateTimePicker
      Left = 936
      Top = 20
      Width = 140
      Height = 28
      Anchors = [akTop, akRight]
      Date = 46200.000000000000000000
      Time = 46200.000000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 615
    Width = 1100
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      1100
      65)
    object btnCancelarOS: TButton
      Left = 24
      Top = 15
      Width = 120
      Height = 36
      Caption = 'Cancelar OS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnCancelarOSClick
    end
    object btnFechar: TButton
      Left = 592
      Top = 15
      Width = 110
      Height = 36
      Anchors = [akTop, akRight]
      Caption = 'Sair'
      TabOrder = 1
      OnClick = btnFecharClick
    end
    object btnSalvar: TButton
      Left = 832
      Top = 15
      Width = 110
      Height = 36
      Anchors = [akTop, akRight]
      Caption = 'Salvar Rascunho'
      TabOrder = 2
      OnClick = btnSalvarClick
    end
    object btnEmitir: TButton
      Left = 952
      Top = 15
      Width = 124
      Height = 36
      Anchors = [akTop, akRight]
      Caption = 'Emitir OS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnEmitirClick
    end
    object btnVisualizar: TButton
      Left = 1000
      Top = 79
      Width = 110
      Height = 36
      Anchors = [akTop, akRight]
      Caption = 'Visualizar'
      TabOrder = 4
    end
    object btnImprimir: TButton
      Left = 712
      Top = 15
      Width = 110
      Height = 36
      Anchors = [akTop, akRight]
      Caption = 'Imprimir'
      TabOrder = 5
      OnClick = btnImprimirClick
    end
  end
  object pnlResumoLateral: TPanel
    Left = 820
    Top = 70
    Width = 280
    Height = 545
    Align = alRight
    BevelOuter = bvNone
    Color = 15921906
    Padding.Left = 8
    Padding.Top = 16
    Padding.Right = 24
    Padding.Bottom = 16
    ParentBackground = False
    TabOrder = 2
    object grpCarga: TGroupBox
      Left = 8
      Top = 16
      Width = 248
      Height = 220
      Align = alTop
      Caption = ' Resumo da Carga '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2960685
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object lblPeso: TLabel
        Left = 16
        Top = 89
        Width = 88
        Height = 17
        Caption = 'Peso Bruto Tot.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5263440
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblQtd: TLabel
        Left = 16
        Top = 153
        Width = 97
        Height = 17
        Caption = 'Qtd. de Volumes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5263440
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object lblValNF: TLabel
        Left = 16
        Top = 26
        Width = 120
        Height = 17
        Caption = 'Valor Total das NFes'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5263440
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edtPeso: TEdit
        Left = 16
        Top = 110
        Width = 216
        Height = 25
        Color = 15000804
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object edtQtd: TEdit
        Left = 16
        Top = 174
        Width = 216
        Height = 25
        Color = 15000804
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object edtValNF: TEdit
        Left = 16
        Top = 47
        Width = 216
        Height = 25
        Color = 15000804
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object grpFinanceiro: TGroupBox
      Left = 8
      Top = 236
      Width = 248
      Height = 293
      Align = alClient
      Caption = ' Totais Financeiros '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 2960685
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      DesignSize = (
        248
        293)
      object lblFrete: TLabel
        Left = 16
        Top = 30
        Width = 116
        Height = 17
        Caption = 'Valor do Frete (R$)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 2960685
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblValICMS: TLabel
        Left = 16
        Top = 218
        Width = 111
        Height = 17
        Caption = 'Valor do ICMS (R$)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 5263440
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object edtFrete: TEdit
        Left = 16
        Top = 51
        Width = 216
        Height = 33
        Color = 13434828
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 22717
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnChange = edtFreteChange
        OnExit = edtFreteExit
      end
      object edtValICMS: TEdit
        Left = 16
        Top = 239
        Width = 216
        Height = 25
        Color = 15000804
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object btnRecalcularFrete: TButton
        Left = 122
        Top = 90
        Width = 110
        Height = 36
        Anchors = [akTop, akRight]
        Caption = 'Recalcular Frete'
        TabOrder = 2
        OnClick = btnRecalcularFreteClick
      end
    end
  end
  object pgcEmissao: TPageControl
    Left = 0
    Top = 70
    Width = 820
    Height = 545
    ActivePage = tsPasso3
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object tsPasso1: TTabSheet
      Caption = '1. Participantes e Notas Fiscais'
      object grpPartes: TGroupBox
        Left = 16
        Top = 12
        Width = 780
        Height = 157
        Caption = ' Envolvidos na Opera'#231#227'o '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object lblRemetente: TLabel
          Left = 16
          Top = 30
          Width = 62
          Height = 17
          Caption = 'Remetente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblDest: TLabel
          Left = 400
          Top = 30
          Width = 70
          Height = 17
          Caption = 'Destinat'#225'rio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblTomador: TLabel
          Left = 16
          Top = 90
          Width = 102
          Height = 17
          Caption = 'Tipo de Tomador'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object cboRemetente: TComboBox
          Left = 16
          Top = 51
          Width = 360
          Height = 25
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cboDest: TComboBox
          Left = 400
          Top = 51
          Width = 360
          Height = 25
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object cboTipoTomador: TComboBox
          Left = 16
          Top = 111
          Width = 160
          Height = 25
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnChange = cboTipoTomadorChange
        end
        object cboTomador: TComboBox
          Left = 192
          Top = 111
          Width = 360
          Height = 25
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
      end
      object grpNFe: TGroupBox
        Left = 16
        Top = 179
        Width = 780
        Height = 320
        Caption = ' Documentos Fiscais Vinculados (NF-e) '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        DesignSize = (
          780
          320)
        object gridNFe: TStringGrid
          Left = 16
          Top = 64
          Width = 748
          Height = 240
          Anchors = [akLeft, akTop, akRight, akBottom]
          ColCount = 7
          FixedCols = 0
          RowCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs]
          ParentFont = False
          TabOrder = 0
        end
        object btnImportXML: TButton
          Left = 16
          Top = 24
          Width = 145
          Height = 30
          Caption = 'Importar XML'
          TabOrder = 1
          OnClick = btnImportXMLClick
        end
        object btnAddNFe: TButton
          Left = 528
          Top = 24
          Width = 110
          Height = 30
          Anchors = [akTop, akRight]
          Caption = 'Adicionar Linha'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnAddNFeClick
        end
        object btnRemNFe: TButton
          Left = 654
          Top = 24
          Width = 110
          Height = 30
          Anchors = [akTop, akRight]
          Caption = 'Remover Linha'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnRemNFeClick
        end
      end
    end
    object tsPasso2: TTabSheet
      Caption = '2. Trajeto e Transporte'
      ImageIndex = 1
      object grpTransporte: TGroupBox
        Left = 16
        Top = 12
        Width = 780
        Height = 173
        Caption = ' Informa'#231#245'es Log'#237'sticas '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object lblFrota: TLabel
          Left = 16
          Top = 30
          Width = 83
          Height = 17
          Caption = 'Ve'#237'culo (Placa)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblRota: TLabel
          Left = 400
          Top = 30
          Width = 94
          Height = 17
          Caption = 'Rota de Viagem'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblKM: TLabel
          Left = 400
          Top = 95
          Width = 91
          Height = 17
          Caption = 'Quilometragem'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object cboFrota: TComboBox
          Left = 16
          Top = 51
          Width = 360
          Height = 25
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object cboRota: TComboBox
          Left = 400
          Top = 51
          Width = 360
          Height = 25
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnChange = cboRotaChange
        end
        object edtKM: TEdit
          Left = 400
          Top = 116
          Width = 140
          Height = 25
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
      end
    end
    object tsPasso3: TTabSheet
      Caption = '3. Valores e Tributos'
      ImageIndex = 2
      object grpTaxas: TGroupBox
        Left = 16
        Top = 12
        Width = 780
        Height = 173
        Caption = ' Valores e Impostos '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object lblCFOP: TLabel
          Left = 16
          Top = 30
          Width = 31
          Height = 17
          Caption = 'CFOP'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblSeguro: TLabel
          Left = 192
          Top = 30
          Width = 96
          Height = 17
          Caption = 'Valor do Seguro'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblBaseICMS: TLabel
          Left = 16
          Top = 95
          Width = 92
          Height = 17
          Caption = 'Base de C'#225'lculo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object lblAliquota: TLabel
          Left = 192
          Top = 95
          Width = 71
          Height = 17
          Caption = 'Al'#237'quota (%)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object edtCFOP: TEdit
          Left = 16
          Top = 51
          Width = 140
          Height = 25
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object edtSeguro: TEdit
          Left = 192
          Top = 51
          Width = 140
          Height = 25
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object edtBaseICMS: TEdit
          Left = 16
          Top = 118
          Width = 140
          Height = 25
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object edtAliquota: TEdit
          Left = 192
          Top = 116
          Width = 140
          Height = 25
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
      end
      object grpObs: TGroupBox
        Left = 16
        Top = 200
        Width = 780
        Height = 299
        Caption = ' Observa'#231#245'es do Faturamento '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        DesignSize = (
          780
          299)
        object memoObs: TMemo
          Left = 16
          Top = 32
          Width = 748
          Height = 245
          Anchors = [akLeft, akTop, akRight, akBottom]
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
end
