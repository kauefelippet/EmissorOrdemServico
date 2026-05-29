object CadFrota: TCadFrota
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Frota'
  ClientHeight = 360
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object grpDados: TGroupBox
    Left = 16
    Top = 16
    Width = 588
    Height = 145
    Caption = ' Dados do Ve'#237'culo '
    TabOrder = 0
    object lblPlaca: TLabel
      Left = 20
      Top = 32
      Width = 28
      Height = 15
      Caption = 'Placa'
    end
    object lblTipo: TLabel
      Left = 190
      Top = 32
      Width = 24
      Height = 15
      Caption = 'Tipo'
    end
    object lblDescricao: TLabel
      Left = 20
      Top = 92
      Width = 51
      Height = 15
      Caption = 'Descri'#231#227'o'
    end
    object edtPlaca: TEdit
      Left = 20
      Top = 52
      Width = 150
      Height = 23
      CharCase = ecUpperCase
      MaxLength = 8
      TabOrder = 0
      OnExit = edtPlacaExit
      OnKeyPress = edtPlacaKeyPress
    end
    object cboTipo: TComboBox
      Left = 190
      Top = 52
      Width = 160
      Height = 23
      Style = csDropDownList
      TabOrder = 1
    end
    object edtDescricao: TEdit
      Left = 20
      Top = 112
      Width = 540
      Height = 23
      TabOrder = 2
    end
  end
  object grpProprietario: TGroupBox
    Left = 16
    Top = 176
    Width = 588
    Height = 90
    Caption = ' Propriet'#225'rio '
    TabOrder = 1
    object lblProprietario: TLabel
      Left = 20
      Top = 30
      Width = 62
      Height = 15
      Caption = 'Propriet'#225'rio'
    end
    object cboProprietario: TComboBox
      Left = 20
      Top = 50
      Width = 540
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 304
    Width = 620
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 2
    object btnSalvar: TButton
      Left = 420
      Top = 12
      Width = 90
      Height = 32
      Caption = 'Salvar'
      Default = True
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 520
      Top = 12
      Width = 90
      Height = 32
      Cancel = True
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object qryProprietarios: TFDQuery
    Left = 544
    Top = 16
  end
  object dsProprietarios: TDataSource
    Left = 544
    Top = 72
  end
end
