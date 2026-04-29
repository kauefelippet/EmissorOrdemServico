object CadCliente: TCadCliente
  Left = 0
  Top = 0
  Caption = 'Cadastro de Cliente'
  ClientHeight = 425
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object grpDados: TGroupBox
    Left = 0
    Top = 0
    Width = 500
    Height = 165
    Align = alTop
    Caption = 'Dados Cadastrais'
    TabOrder = 0
    ExplicitTop = -6
    object Label1: TLabel
      Left = 12
      Top = 24
      Width = 59
      Height = 15
      Caption = 'CPF / CNPJ'
    end
    object lblTipoDoc: TLabel
      Left = 200
      Top = 44
      Width = 120
      Height = 15
    end
    object Label2: TLabel
      Left = 12
      Top = 72
      Width = 65
      Height = 15
      Caption = 'Raz'#227'o Social'
      Color = clBtnFace
      ParentColor = False
    end
    object Label3: TLabel
      Left = 12
      Top = 120
      Width = 79
      Height = 15
      Caption = 'Nome Fantasia'
    end
    object Label4: TLabel
      Left = 330
      Top = 120
      Width = 35
      Height = 15
      Caption = 'IE / RG'
    end
    object lblCriadoEm: TLabel
      Left = 325
      Top = 24
      Width = 3
      Height = 15
    end
    object lblAtualizadoEm: TLabel
      Left = 325
      Top = 40
      Width = 3
      Height = 15
    end
    object edtDocumento: TEdit
      Left = 12
      Top = 40
      Width = 180
      Height = 23
      TabOrder = 0
      OnChange = edtDocumentoChange
    end
    object edtRazaoSocial: TEdit
      Left = 12
      Top = 88
      Width = 400
      Height = 23
      TabOrder = 1
    end
    object edtNomeFantasia: TEdit
      Left = 12
      Top = 136
      Width = 300
      Height = 23
      TabOrder = 2
    end
    object edtIERG: TEdit
      Left = 330
      Top = 136
      Width = 130
      Height = 23
      TabOrder = 3
    end
  end
  object grpEndereco: TGroupBox
    Left = 0
    Top = 165
    Width = 500
    Height = 260
    Align = alClient
    Caption = 'Endere'#231'o'
    TabOrder = 1
    ExplicitLeft = 56
    ExplicitTop = 176
    ExplicitWidth = 185
    ExplicitHeight = 105
    object Label5: TLabel
      Left = 12
      Top = 24
      Width = 21
      Height = 15
      Caption = 'CEP'
    end
    object Label6: TLabel
      Left = 12
      Top = 72
      Width = 62
      Height = 15
      Caption = 'Logradouro'
    end
    object Label7: TLabel
      Left = 370
      Top = 72
      Width = 44
      Height = 15
      Caption = 'N'#250'mero'
    end
    object Label8: TLabel
      Left = 12
      Top = 120
      Width = 31
      Height = 15
      Caption = 'Bairro'
    end
    object Label9: TLabel
      Left = 12
      Top = 168
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object Label10: TLabel
      Left = 240
      Top = 168
      Width = 14
      Height = 15
      Caption = 'UF'
    end
    object edtCEP: TEdit
      Left = 12
      Top = 40
      Width = 100
      Height = 23
      MaxLength = 10
      TabOrder = 0
      OnKeyPress = edtCEPKeyPress
    end
    object btnBuscarCEP: TButton
      Left = 120
      Top = 38
      Width = 30
      Height = 25
      Caption = #55357#56589
      TabOrder = 1
      OnClick = btnBuscarCEPClick
    end
    object edtLogradouro: TEdit
      Left = 12
      Top = 88
      Width = 350
      Height = 23
      TabOrder = 2
    end
    object edtNumero: TEdit
      Left = 370
      Top = 88
      Width = 121
      Height = 23
      TabOrder = 3
    end
    object edtBairro: TEdit
      Left = 12
      Top = 136
      Width = 220
      Height = 23
      TabOrder = 4
    end
    object edtCidade: TEdit
      Left = 12
      Top = 184
      Width = 220
      Height = 23
      TabOrder = 5
    end
    object cboUF: TComboBox
      Left = 240
      Top = 184
      Width = 70
      Height = 23
      TabOrder = 6
    end
    object pnlBotoes: TPanel
      Left = 2
      Top = 217
      Width = 496
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      BevelWidth = 2
      Color = clCream
      ParentBackground = False
      TabOrder = 7
      ExplicitLeft = 192
      ExplicitTop = 240
      ExplicitWidth = 185
      object btnSalvar: TButton
        Left = 10
        Top = 8
        Width = 242
        Height = 25
        Caption = 'Salvar'
        TabOrder = 0
        OnClick = btnSalvarClick
      end
      object btnCancelar: TButton
        Left = 258
        Top = 8
        Width = 231
        Height = 25
        Caption = 'Cancelar'
        TabOrder = 1
        OnClick = btnCancelarClick
      end
    end
  end
end
