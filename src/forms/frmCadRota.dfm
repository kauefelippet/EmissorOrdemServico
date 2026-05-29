object CadRota: TCadRota
  Left = 0
  Top = 0
  Caption = 'Cadastro de Rota'
  ClientHeight = 420
  ClientWidth = 720
  Color = clWindow
  Constraints.MinHeight = 400
  Constraints.MinWidth = 680
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    720
    420)
  TextHeight = 15
  object grpDados: TGroupBox
    Left = 16
    Top = 12
    Width = 688
    Height = 320
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = ' Configura'#231#245'es da Rota '
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
      688
      320)
    object lblDescricao: TLabel
      Left = 20
      Top = 32
      Width = 52
      Height = 15
      Caption = 'Descri'#231#227'o'
      FocusControl = edtDescricao
    end
    object lblTipo: TLabel
      Left = 20
      Top = 92
      Width = 24
      Height = 15
      Caption = 'Tipo'
      FocusControl = cboTipo
    end
    object lblValorBase: TLabel
      Left = 20
      Top = 152
      Width = 79
      Height = 15
      Caption = 'Valor Base (R$)'
      FocusControl = edtValorBase
    end
    object lblMultiplicador: TLabel
      Left = 360
      Top = 152
      Width = 71
      Height = 15
      Caption = 'Multiplicador'
      FocusControl = edtMultiplicador
    end
    object lblDicaCalculo: TLabel
      Left = 20
      Top = 228
      Width = 640
      Height = 48
      AutoSize = False
      Caption = 'Frete = Valor Base (fixo por rota)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object edtDescricao: TEdit
      Left = 20
      Top = 52
      Width = 648
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object cboTipo: TComboBox
      Left = 20
      Top = 112
      Width = 320
      Height = 27
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = cboTipoChange
    end
    object edtValorBase: TEdit
      Left = 20
      Top = 172
      Width = 300
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnKeyPress = edtValorKeyPress
    end
    object edtMultiplicador: TEdit
      Left = 360
      Top = 172
      Width = 308
      Height = 25
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnKeyPress = edtValorKeyPress
    end
    object pnlBotoes: TPanel
      Left = 1
      Top = 278
      Width = 686
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      Color = clWindow
      ParentBackground = False
      TabOrder = 4
      DesignSize = (
        686
        41)
      object btnSalvar: TButton
        Left = 470
        Top = 4
        Width = 100
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
        Left = 578
        Top = 4
        Width = 100
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
