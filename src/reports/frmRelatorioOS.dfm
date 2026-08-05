object RelatorioOS: TRelatorioOS
  Left = 0
  Top = 0
  Caption = 'Impress'#227'o de Ordem de Servi'#231'o'
  ClientHeight = 900
  ClientWidth = 835
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 13
  object RLOrdemServico: TRLReport
    Left = 8
    Top = 8
    Width = 794
    Height = 1123
    DataSource = dtsOS
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    Title = 'Ordem de Servi'#231'o de Transporte'
    object btHeader: TRLBand
      Left = 38
      Top = 38
      Width = 718
      Height = 105
      BandType = btHeader
      object imgLogo: TRLImage
        Left = 0
        Top = 8
        Width = 110
        Height = 60
        Stretch = True
      end
      object lblTitulo: TRLLabel
        Left = 118
        Top = 8
        Width = 600
        Height = 28
        Alignment = taCenter
        Caption = 'ORDEM DE SERVI'#199'O DE TRANSPORTE'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblPrefixoNum: TRLLabel
        Left = 140
        Top = 50
        Width = 20
        Height = 13
        Caption = 'N'#186
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbNumero: TRLDBText
        Left = 165
        Top = 50
        Width = 60
        Height = 13
        AutoSize = False
        DataField = 'NUMERO'
        DataSource = dtsOS
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        Text = ''
      end
      object lblData: TRLLabel
        Left = 240
        Top = 50
        Width = 30
        Height = 13
        Caption = 'Data:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object dbData: TRLDBText
        Left = 275
        Top = 50
        Width = 80
        Height = 13
        AutoSize = False
        DataField = 'DATA_FMT'
        DataSource = dtsOS
        Text = ''
      end
      object lblStatus: TRLLabel
        Left = 370
        Top = 50
        Width = 37
        Height = 13
        Caption = 'Status:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object dbStatus: TRLDBText
        Left = 412
        Top = 50
        Width = 80
        Height = 13
        AutoSize = False
        DataField = 'STATUS'
        DataSource = dtsOS
        Text = ''
      end
      object lblCFOP: TRLLabel
        Left = 510
        Top = 50
        Width = 32
        Height = 13
        Caption = 'CFOP:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object dbCFOP: TRLDBText
        Left = 547
        Top = 50
        Width = 60
        Height = 13
        AutoSize = False
        DataField = 'CFOP'
        DataSource = dtsOS
        Text = ''
      end
      object rlDraw1: TRLDraw
        Left = 0
        Top = 95
        Width = 718
        Height = 2
        DrawKind = dkLine
        Pen.Color = clSilver
      end
    end
    object btPartes: TRLBand
      Left = 38
      Top = 143
      Width = 718
      Height = 115
      BandType = btTitle
      object lblSecPartes: TRLLabel
        Left = 0
        Top = 4
        Width = 113
        Height = 13
        Caption = 'PARTES ENVOLVIDAS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object pnlTomador: TRLPanel
        Left = 0
        Top = 22
        Width = 234
        Height = 85
        Color = clWhitesmoke
        ParentColor = False
        Transparent = False
        object lblTomTitulo: TRLLabel
          Left = 6
          Top = 6
          Width = 59
          Height = 13
          Caption = 'TOMADOR'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object dbTomNome: TRLDBText
          Left = 6
          Top = 22
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'TOM_NOME'
          DataSource = dtsOS
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          Text = ''
        end
        object dbTomDoc: TRLDBText
          Left = 6
          Top = 38
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'TOM_DOC'
          DataSource = dtsOS
          Text = ''
        end
        object dbTomLocal: TRLDBText
          Left = 6
          Top = 54
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'TOM_LOCAL'
          DataSource = dtsOS
          Text = ''
        end
      end
      object pnlRemetente: TRLPanel
        Left = 242
        Top = 22
        Width = 234
        Height = 85
        Color = clWhitesmoke
        ParentColor = False
        Transparent = False
        object lblRemTitulo: TRLLabel
          Left = 6
          Top = 6
          Width = 116
          Height = 13
          Caption = 'REMETENTE (Origem)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object dbRemNome: TRLDBText
          Left = 6
          Top = 22
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'REM_NOME'
          DataSource = dtsOS
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          Text = ''
        end
        object dbRemDoc: TRLDBText
          Left = 6
          Top = 38
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'REM_DOC'
          DataSource = dtsOS
          Text = ''
        end
        object dbRemEnd: TRLDBText
          Left = 6
          Top = 54
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'REM_END'
          DataSource = dtsOS
          Text = ''
        end
        object dbRemLocal: TRLDBText
          Left = 6
          Top = 70
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'REM_LOCAL'
          DataSource = dtsOS
          Text = ''
        end
      end
      object pnlDestinatario: TRLPanel
        Left = 484
        Top = 22
        Width = 234
        Height = 85
        Color = clWhitesmoke
        ParentColor = False
        Transparent = False
        object lblDestTitulo: TRLLabel
          Left = 6
          Top = 6
          Width = 135
          Height = 13
          Caption = 'DESTINAT'#193'RIO (Destino)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object dbDestNome: TRLDBText
          Left = 6
          Top = 22
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'DEST_NOME'
          DataSource = dtsOS
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          Text = ''
        end
        object dbDestDoc: TRLDBText
          Left = 6
          Top = 38
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'DEST_DOC'
          DataSource = dtsOS
          Text = ''
        end
        object dbDestEnd: TRLDBText
          Left = 6
          Top = 54
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'DEST_END'
          DataSource = dtsOS
          Text = ''
        end
        object dbDestLocal: TRLDBText
          Left = 6
          Top = 70
          Width = 220
          Height = 13
          AutoSize = False
          DataField = 'DEST_LOCAL'
          DataSource = dtsOS
          Text = ''
        end
      end
    end
    object btHeaderNFe: TRLBand
      Left = 38
      Top = 258
      Width = 718
      Height = 35
      BandType = btTitle
      object lblSecNFe: TRLLabel
        Left = 0
        Top = 0
        Width = 176
        Height = 13
        Caption = 'DOCUMENTOS DA CARGA (NF-es)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object pnlColHdr: TRLPanel
        Left = 0
        Top = 16
        Width = 718
        Height = 17
        Color = 14737632
        ParentColor = False
        Transparent = False
        object hdrNum: TRLLabel
          Left = 2
          Top = 2
          Width = 68
          Height = 13
          Caption = 'N'#186' NF-e'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object hdrSerie: TRLLabel
          Left = 72
          Top = 2
          Width = 30
          Height = 13
          Caption = 'S'#233'rie'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object hdrEmit: TRLLabel
          Left = 104
          Top = 2
          Width = 140
          Height = 13
          Caption = 'Emitente'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object hdrChave: TRLLabel
          Left = 246
          Top = 2
          Width = 267
          Height = 13
          Caption = 'Chave NF-e'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object hdrPeso: TRLLabel
          Left = 513
          Top = 2
          Width = 70
          Height = 13
          Alignment = taRightJustify
          Caption = 'Peso (kg)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object hdrQtd: TRLLabel
          Left = 585
          Top = 2
          Width = 40
          Height = 13
          Alignment = taCenter
          Caption = 'Qtd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object hdrValor: TRLLabel
          Left = 625
          Top = 2
          Width = 90
          Height = 13
          Alignment = taRightJustify
          Caption = 'Valor (R$)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
    object btMasterDetail: TRLBand
      Left = 38
      Top = 293
      Width = 718
      Height = 1
    end
    object btNFeDetail: TRLSubDetail
      Left = 38
      Top = 294
      Width = 718
      Height = 103
      DataSource = dtsNFe
      object bndNFeRow: TRLBand
        Left = 0
        Top = 0
        Width = 718
        Height = 18
        object dbNFeNum: TRLDBText
          Left = 2
          Top = 2
          Width = 68
          Height = 13
          AutoSize = False
          DataField = 'NUMERO_NFE'
          DataSource = dtsNFe
          Text = ''
        end
        object dbNFeSerie: TRLDBText
          Left = 72
          Top = 2
          Width = 30
          Height = 13
          AutoSize = False
          DataField = 'SERIE'
          DataSource = dtsNFe
          Text = ''
        end
        object dbNFeEmit: TRLDBText
          Left = 104
          Top = 2
          Width = 140
          Height = 13
          AutoSize = False
          DataField = 'EMITENTE'
          DataSource = dtsNFe
          Text = ''
        end
        object dbNFeChave: TRLDBText
          Left = 246
          Top = 2
          Width = 267
          Height = 13
          AutoSize = False
          DataField = 'CHAVE_NFE'
          DataSource = dtsNFe
          Text = ''
        end
        object dbNFePeso: TRLDBText
          Left = 513
          Top = 2
          Width = 70
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          DataField = 'PESO'
          DataSource = dtsNFe
          Text = ''
        end
        object dbNFeQtd: TRLDBText
          Left = 585
          Top = 2
          Width = 40
          Height = 13
          Alignment = taCenter
          AutoSize = False
          DataField = 'QUANTIDADE'
          DataSource = dtsNFe
          Text = ''
        end
        object dbNFeValor: TRLDBText
          Left = 625
          Top = 2
          Width = 90
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          DataField = 'VALOR_MERCADORIA'
          DataSource = dtsNFe
          Text = ''
        end
      end
      object btNFeFooter: TRLBand
        Left = 0
        Top = 18
        Width = 718
        Height = 85
        BandType = btSummary
        object pnlTotCarga: TRLPanel
          Left = 0
          Top = 0
          Width = 718
          Height = 22
          Color = 14544605
          ParentColor = False
          Transparent = False
          object lblTotCarga: TRLLabel
            Left = 360
            Top = 4
            Width = 110
            Height = 13
            Alignment = taRightJustify
            Caption = 'TOTAIS DA CARGA:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object resNFePeso: TRLDBResult
            Left = 513
            Top = 4
            Width = 70
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            DataField = 'PESO'
            DataSource = dtsNFe
            DisplayMask = '#,##0.000'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            Info = riSum
            ParentFont = False
            Text = ''
          end
          object resNFeQtd: TRLDBResult
            Left = 585
            Top = 4
            Width = 40
            Height = 13
            Alignment = taCenter
            AutoSize = False
            DataField = 'QUANTIDADE'
            DataSource = dtsNFe
            DisplayMask = '#,##0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            Info = riSum
            ParentFont = False
            Text = ''
          end
          object resNFeValor: TRLDBResult
            Left = 625
            Top = 4
            Width = 90
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            DataField = 'VALOR_MERCADORIA'
            DataSource = dtsNFe
            DisplayMask = '#,##0.00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            Info = riSum
            ParentFont = False
            Text = ''
          end
        end
        object rlDrawLogistica: TRLDraw
          Left = 0
          Top = 32
          Width = 718
          Height = 2
          DrawKind = dkLine
          Pen.Color = clSilver
        end
        object lblSecLogistica: TRLLabel
          Left = 0
          Top = 42
          Width = 108
          Height = 13
          Caption = 'DADOS LOG'#205'STICOS'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblVeiculo: TRLLabel
          Left = 0
          Top = 62
          Width = 45
          Height = 13
          Caption = 'Ve'#237'culo:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object dbPlaca: TRLDBText
          Left = 50
          Top = 62
          Width = 70
          Height = 13
          AutoSize = False
          DataField = 'PLACA'
          DataSource = dtsOS
          Text = ''
        end
        object dbFrotaDesc: TRLDBText
          Left = 125
          Top = 62
          Width = 200
          Height = 13
          AutoSize = False
          DataField = 'FROTA_DESC'
          DataSource = dtsOS
          Text = ''
        end
      end
    end
    object btSummary: TRLBand
      Left = 38
      Top = 397
      Width = 718
      Height = 372
      BandType = btSummary
      object rlDrawSep: TRLDraw
        Left = 0
        Top = 10
        Width = 718
        Height = 2
        DrawKind = dkLine
        Pen.Color = clSilver
      end
      object lblSecFrete: TRLLabel
        Left = 0
        Top = 20
        Width = 191
        Height = 13
        Caption = 'COMPOSI'#199#195'O DO FRETE E IMPOSTOS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblFreteTit: TRLLabel
        Left = 150
        Top = 45
        Width = 140
        Height = 13
        Alignment = taRightJustify
        Caption = 'Valor do Frete:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbValorFrete: TRLDBText
        Left = 300
        Top = 45
        Width = 100
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        DataField = 'VALOR_FRETE'
        DataSource = dtsOS
        Text = ''
      end
      object lblSeguroTit: TRLLabel
        Left = 150
        Top = 65
        Width = 140
        Height = 13
        Alignment = taRightJustify
        Caption = 'Seguro:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbSeguro: TRLDBText
        Left = 300
        Top = 65
        Width = 100
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        DataField = 'SEGURO'
        DataSource = dtsOS
        Text = ''
      end
      object lblBaseICMSTit: TRLLabel
        Left = 150
        Top = 85
        Width = 140
        Height = 13
        Alignment = taRightJustify
        Caption = 'Base C'#225'lculo ICMS:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbBaseICMS: TRLDBText
        Left = 300
        Top = 85
        Width = 100
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        DataField = 'BASE_ICMS'
        DataSource = dtsOS
        Text = ''
      end
      object lblAliqTit: TRLLabel
        Left = 150
        Top = 105
        Width = 140
        Height = 13
        Alignment = taRightJustify
        Caption = 'Al'#237'quota ICMS:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbAliquota: TRLDBText
        Left = 300
        Top = 105
        Width = 100
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        DataField = 'ALIQUOTA'
        DataSource = dtsOS
        Text = ''
      end
      object lblICMSTit: TRLLabel
        Left = 150
        Top = 125
        Width = 140
        Height = 13
        Alignment = taRightJustify
        Caption = 'Valor ICMS:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbValorICMS: TRLDBText
        Left = 300
        Top = 125
        Width = 100
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        DataField = 'VALOR_ICMS'
        DataSource = dtsOS
        Text = ''
      end
      object pnlTotalGeral: TRLPanel
        Left = 470
        Top = 35
        Width = 248
        Height = 96
        Color = 15790320
        ParentColor = False
        Transparent = False
        object lblTotalGeralTit: TRLLabel
          Left = 8
          Top = 10
          Width = 232
          Height = 15
          Alignment = taCenter
          Caption = 'TOTAL GERAL'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblTotalSub: TRLLabel
          Left = 8
          Top = 30
          Width = 232
          Height = 13
          Alignment = taCenter
          Caption = '(Frete + Seguro)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
        object dbTotalGeral: TRLDBText
          Left = 8
          Top = 55
          Width = 232
          Height = 25
          Alignment = taCenter
          AutoSize = False
          DataField = 'TOTAL_GERAL'
          DataSource = dtsOS
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          Text = ''
        end
      end
      object lblObsTit: TRLLabel
        Left = 0
        Top = 155
        Width = 84
        Height = 13
        Caption = 'OBSERVA'#199#213'ES'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbObs: TRLDBMemo
        Left = 0
        Top = 175
        Width = 718
        Height = 45
        Behavior = [beSiteExpander]
        DataField = 'OBSERVACOES'
        DataSource = dtsOS
      end
      object lblAssTitle: TRLLabel
        Left = 0
        Top = 235
        Width = 77
        Height = 13
        Caption = 'ASSINATURAS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object rlLinhaMot: TRLDraw
        Left = 10
        Top = 275
        Width = 210
        Height = 1
        DrawKind = dkLine
      end
      object lblAssMot: TRLLabel
        Left = 10
        Top = 280
        Width = 210
        Height = 13
        Alignment = taCenter
        Caption = 'Assinatura do Motorista'
      end
      object lblDataMot: TRLLabel
        Left = 10
        Top = 295
        Width = 210
        Height = 13
        Alignment = taCenter
        Caption = 'Data: ____/____/________'
      end
      object rlLinhaRem: TRLDraw
        Left = 254
        Top = 275
        Width = 210
        Height = 1
        DrawKind = dkLine
      end
      object lblAssRem: TRLLabel
        Left = 254
        Top = 280
        Width = 210
        Height = 13
        Alignment = taCenter
        Caption = 'Assinatura do Remetente'
      end
      object lblDataRem: TRLLabel
        Left = 254
        Top = 295
        Width = 210
        Height = 13
        Alignment = taCenter
        Caption = 'Data: ____/____/________'
      end
      object rlLinhaDest: TRLDraw
        Left = 498
        Top = 275
        Width = 210
        Height = 1
        DrawKind = dkLine
      end
      object lblAssDest: TRLLabel
        Left = 498
        Top = 280
        Width = 210
        Height = 13
        Alignment = taCenter
        Caption = 'Assinatura do Destinat'#225'rio'
      end
      object lblDataDest: TRLLabel
        Left = 498
        Top = 295
        Width = 210
        Height = 13
        Alignment = taCenter
        Caption = 'Data: ____/____/________'
      end
    end
  end
  object qryOS: TFDQuery
    Connection = Conexao.FDConnection1
    SQL.Strings = (
      'SELECT '
      '  OS.ID, '
      '  OS.NUMERO, '
      '  OS.STATUS, '
      '  OS.CFOP, '
      '  OS.OBSERVACOES, '
      '  CAST(EXTRACT(DAY   FROM OS.DATA) AS VARCHAR(2)) || '#39'/'#39' || '
      '  CAST(EXTRACT(MONTH FROM OS.DATA) AS VARCHAR(2)) || '#39'/'#39' || '
      '  CAST(EXTRACT(YEAR  FROM OS.DATA) AS VARCHAR(4)) AS DATA_FMT, '
      '  OS.VALOR_FRETE, '
      '  OS.SEGURO, '
      '  OS.BASE_ICMS, '
      '  OS.ALIQUOTA, '
      '  OS.VALOR_ICMS, '
      '  OS.PESO, '
      '  OS.QUANTIDADE, '
      '  OS.VALOR_MERCADORIA, '
      '  CASE WHEN OS.KM > 0 THEN CAST(OS.KM AS VARCHAR(15)) || '#39' km'#39' '
      '       ELSE '#39#8212#39' END AS KM_FMT, '
      '  (OS.VALOR_FRETE + OS.SEGURO) AS TOTAL_GERAL, '
      '  T.RAZAO_SOCIAL AS TOM_NOME, '
      '  T.DOCUMENTO    AS TOM_DOC, '
      '  T.CIDADE || '#39'/'#39' || T.UF AS TOM_LOCAL, '
      '  R.RAZAO_SOCIAL AS REM_NOME, '
      '  R.DOCUMENTO    AS REM_DOC, '
      '  R.LOGRADOURO || '#39', '#39' || R.NUMERO AS REM_END, '
      '  R.CIDADE || '#39'/'#39' || R.UF         AS REM_LOCAL, '
      '  D.RAZAO_SOCIAL AS DEST_NOME, '
      '  D.DOCUMENTO    AS DEST_DOC, '
      '  D.LOGRADOURO || '#39', '#39' || D.NUMERO AS DEST_END, '
      '  D.CIDADE || '#39'/'#39' || D.UF         AS DEST_LOCAL, '
      '  F.PLACA, '
      '  F.DESCRICAO AS FROTA_DESC, '
      '  RT.DESCRICAO AS ROTA_DESC '
      'FROM ORDEM_SERVICO OS '
      'LEFT JOIN CLIENTES R  ON R.ID  = OS.ID_REMETENTE '
      'LEFT JOIN CLIENTES D  ON D.ID  = OS.ID_DESTINATARIO '
      'LEFT JOIN CLIENTES T  ON T.ID  = OS.ID_TOMADOR '
      'LEFT JOIN FROTA    F  ON F.ID  = OS.ID_FROTA '
      'LEFT JOIN ROTAS    RT ON RT.ID = OS.ID_ROTA '
      'WHERE OS.ID = :pID')
    Left = 784
    Top = 32
    ParamData = <
      item
        Name = 'PID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryOSID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryOSNUMERO: TIntegerField
      FieldName = 'NUMERO'
      Origin = 'NUMERO'
    end
    object qryOSSTATUS: TWideStringField
      FieldName = 'STATUS'
      Origin = 'STATUS'
      Size = 10
    end
    object qryOSCFOP: TWideStringField
      FieldName = 'CFOP'
      Origin = 'CFOP'
      Size = 10
    end
    object qryOSOBSERVACOES: TWideMemoField
      FieldName = 'OBSERVACOES'
      Origin = 'OBSERVACOES'
      BlobType = ftWideMemo
    end
    object qryOSDATA_FMT: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'DATA_FMT'
      Origin = 'DATA_FMT'
      ProviderFlags = []
      ReadOnly = True
      Size = 10
    end
    object qryOSVALOR_FRETE: TFMTBCDField
      FieldName = 'VALOR_FRETE'
      Origin = 'VALOR_FRETE'
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
    object qryOSSEGURO: TFMTBCDField
      FieldName = 'SEGURO'
      Origin = 'SEGURO'
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
    object qryOSBASE_ICMS: TFMTBCDField
      FieldName = 'BASE_ICMS'
      Origin = 'BASE_ICMS'
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
    object qryOSALIQUOTA: TCurrencyField
      FieldName = 'ALIQUOTA'
      Origin = 'ALIQUOTA'
      DisplayFormat = '#,##0.00'
    end
    object qryOSVALOR_ICMS: TFMTBCDField
      FieldName = 'VALOR_ICMS'
      Origin = 'VALOR_ICMS'
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
    object qryOSPESO: TFMTBCDField
      FieldName = 'PESO'
      Origin = 'PESO'
      DisplayFormat = '#,##0.000'
      Precision = 18
      Size = 3
    end
    object qryOSQUANTIDADE: TIntegerField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
    end
    object qryOSVALOR_MERCADORIA: TFMTBCDField
      FieldName = 'VALOR_MERCADORIA'
      Origin = 'VALOR_MERCADORIA'
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
    object qryOSKM_FMT: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'KM_FMT'
      Origin = 'KM_FMT'
      ProviderFlags = []
      ReadOnly = True
      Size = 18
    end
    object qryOSTOTAL_GERAL: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'TOTAL_GERAL'
      Origin = 'TOTAL_GERAL'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
    object qryOSTOM_NOME: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'TOM_NOME'
      Origin = 'RAZAO_SOCIAL'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object qryOSTOM_DOC: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'TOM_DOC'
      Origin = 'DOCUMENTO'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryOSTOM_LOCAL: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'TOM_LOCAL'
      Origin = 'TOM_LOCAL'
      ProviderFlags = []
      ReadOnly = True
      Size = 53
    end
    object qryOSREM_NOME: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'REM_NOME'
      Origin = 'RAZAO_SOCIAL'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object qryOSREM_DOC: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'REM_DOC'
      Origin = 'DOCUMENTO'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryOSREM_END: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'REM_END'
      Origin = 'REM_END'
      ProviderFlags = []
      ReadOnly = True
      Size = 112
    end
    object qryOSREM_LOCAL: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'REM_LOCAL'
      Origin = 'REM_LOCAL'
      ProviderFlags = []
      ReadOnly = True
      Size = 53
    end
    object qryOSDEST_NOME: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'DEST_NOME'
      Origin = 'RAZAO_SOCIAL'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object qryOSDEST_DOC: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'DEST_DOC'
      Origin = 'DOCUMENTO'
      ProviderFlags = []
      ReadOnly = True
    end
    object qryOSDEST_END: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'DEST_END'
      Origin = 'DEST_END'
      ProviderFlags = []
      ReadOnly = True
      Size = 112
    end
    object qryOSDEST_LOCAL: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'DEST_LOCAL'
      Origin = 'DEST_LOCAL'
      ProviderFlags = []
      ReadOnly = True
      Size = 53
    end
    object qryOSPLACA: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'PLACA'
      Origin = 'PLACA'
      ProviderFlags = []
      ReadOnly = True
      Size = 10
    end
    object qryOSFROTA_DESC: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'FROTA_DESC'
      Origin = 'DESCRICAO'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object qryOSROTA_DESC: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'ROTA_DESC'
      Origin = 'DESCRICAO'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
  end
  object qryNFe: TFDQuery
    Active = True
    Connection = Conexao.FDConnection1
    SQL.Strings = (
      'SELECT '
      '  NUMERO_NFE, '
      '  SERIE, '
      '  EMITENTE, '
      '  CHAVE_NFE, '
      '  CAST(PESO AS DECIMAL(15,3))             AS PESO, '
      '  QUANTIDADE, '
      '  CAST(VALOR_MERCADORIA AS DECIMAL(15,2)) AS VALOR_MERCADORIA '
      'FROM OS_NFE '
      'WHERE ID_OS = :pOS '
      'ORDER BY ID')
    Left = 784
    Top = 88
    ParamData = <
      item
        Name = 'POS'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object qryNFeNUMERO_NFE: TWideStringField
      FieldName = 'NUMERO_NFE'
      Origin = 'NUMERO_NFE'
    end
    object qryNFeSERIE: TWideStringField
      FieldName = 'SERIE'
      Origin = 'SERIE'
      Size = 3
    end
    object qryNFeEMITENTE: TWideStringField
      FieldName = 'EMITENTE'
      Origin = 'EMITENTE'
      Size = 100
    end
    object qryNFeCHAVE_NFE: TWideStringField
      FieldName = 'CHAVE_NFE'
      Origin = 'CHAVE_NFE'
      Size = 44
    end
    object qryNFePESO: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'PESO'
      Origin = 'PESO'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '#,##0.000'
      Precision = 18
      Size = 3
    end
    object qryNFeQUANTIDADE: TBCDField
      FieldName = 'QUANTIDADE'
      Origin = 'QUANTIDADE'
      Precision = 18
    end
    object qryNFeVALOR_MERCADORIA: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VALOR_MERCADORIA'
      Origin = 'VALOR_MERCADORIA'
      ProviderFlags = []
      ReadOnly = True
      DisplayFormat = '#,##0.00'
      Precision = 18
      Size = 2
    end
  end
  object dtsOS: TDataSource
    DataSet = qryOS
    Left = 784
    Top = 144
  end
  object dtsNFe: TDataSource
    DataSet = qryNFe
    Left = 784
    Top = 200
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Author = 'Sistema Transportes'
    DocumentInfo.Creator = 'FortesReport CE'
    DisplayName = 'Arquivo PDF'
    Left = 784
    Top = 256
  end
end
