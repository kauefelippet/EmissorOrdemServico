object CadCliente: TCadCliente
  Left = 0
  Top = 0
  Caption = 'Cadastro de Cliente'
  ClientHeight = 560
  ClientWidth = 760
  Color = clWindow
  Constraints.MinHeight = 540
  Constraints.MinWidth = 720
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    760
    560)
  TextHeight = 15
  object grpDados: TGroupBox
    Left = 16
    Top = 12
    Width = 728
    Height = 190
    Anchors = [akLeft, akTop, akRight]
    Caption = ' Dados Cadastrais '
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentBackground = False
    ParentColor = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      728
      190)
    object lblCPFCNPJ: TLabel
      Left = 20
      Top = 30
      Width = 58
      Height = 15
      Caption = 'CPF / CNPJ'
      FocusControl = edtDocumento
    end
    object lblTipoDoc: TLabel
      Left = 220
      Top = 54
      Width = 177
      Height = 15
      Caption = 'Tipo detectado automaticamente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object lblRazaoSocial: TLabel
      Left = 20
      Top = 84
      Width = 67
      Height = 15
      Caption = 'Raz'#227'o Social'
      FocusControl = edtRazaoSocial
    end
    object lblNomeFantasia: TLabel
      Left = 20
      Top = 138
      Width = 79
      Height = 15
      Caption = 'Nome Fantasia'
      FocusControl = edtNomeFantasia
    end
    object lblIERG: TLabel
      Left = 540
      Top = 138
      Width = 36
      Height = 15
      Caption = 'IE / RG'
      FocusControl = edtIERG
    end
    object lblCriadoEm: TLabel
      Left = 564
      Top = 28
      Width = 136
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Criado em: --/--/---- --:--'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object lblAtualizadoEm: TLabel
      Left = 541
      Top = 46
      Width = 159
      Height = 15
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Atualizado em: --/--/---- --:--'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object edtDocumento: TEdit
      Left = 20
      Top = 50
      Width = 190
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = edtDocumentoChange
    end
    object edtRazaoSocial: TEdit
      Left = 20
      Top = 104
      Width = 680
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edtNomeFantasia: TEdit
      Left = 20
      Top = 158
      Width = 500
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edtIERG: TEdit
      Left = 540
      Top = 158
      Width = 160
      Height = 25
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object grpEndereco: TGroupBox
    Left = 16
    Top = 214
    Width = 728
    Height = 290
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Endere'#231'o '
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentBackground = False
    ParentColor = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      728
      290)
    object lblCEP: TLabel
      Left = 20
      Top = 30
      Width = 20
      Height = 15
      Caption = 'CEP'
      FocusControl = edtCEP
    end
    object lblLogradouro: TLabel
      Left = 20
      Top = 84
      Width = 62
      Height = 15
      Caption = 'Logradouro'
      FocusControl = edtLogradouro
    end
    object lblNumero: TLabel
      Left = 580
      Top = 84
      Width = 44
      Height = 15
      Caption = 'N'#250'mero'
      FocusControl = edtNumero
    end
    object lblBairro: TLabel
      Left = 20
      Top = 138
      Width = 31
      Height = 15
      Caption = 'Bairro'
      FocusControl = edtBairro
    end
    object lblCidade: TLabel
      Left = 20
      Top = 192
      Width = 36
      Height = 15
      Caption = 'Cidade'
      FocusControl = edtCidade
    end
    object lblUF: TLabel
      Left = 580
      Top = 192
      Width = 14
      Height = 15
      Caption = 'UF'
      FocusControl = cboUF
    end
    object edtCEP: TEdit
      Left = 20
      Top = 50
      Width = 120
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
      OnKeyPress = edtCEPKeyPress
    end
    object btnBuscarCEP: TButton
      Left = 156
      Top = 48
      Width = 110
      Height = 30
      Caption = 'Buscar CEP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnBuscarCEPClick
    end
    object edtLogradouro: TEdit
      Left = 20
      Top = 104
      Width = 540
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edtNumero: TEdit
      Left = 580
      Top = 104
      Width = 120
      Height = 25
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object edtBairro: TEdit
      Left = 20
      Top = 158
      Width = 680
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object edtCidade: TEdit
      Left = 20
      Top = 212
      Width = 540
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object cboUF: TComboBox
      Left = 566
      Top = 211
      Width = 70
      Height = 27
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object pnlBotoes: TPanel
      Left = 1
      Top = 248
      Width = 726
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 7
      DesignSize = (
        726
        41)
      object btnSalvar: TButton
        Left = 502
        Top = 4
        Width = 104
        Height = 32
        Anchors = [akTop, akRight]
        Caption = 'Salvar'
        Default = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnSalvarClick
      end
      object btnCancelar: TButton
        Left = 614
        Top = 4
        Width = 104
        Height = 32
        Anchors = [akTop, akRight]
        Cancel = True
        Caption = 'Cancelar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnCancelarClick
      end
    end
  end
end
