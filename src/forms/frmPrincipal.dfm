object Principal: TPrincipal
  Left = 0
  Top = 0
  Caption = 'frmPrincipal'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mnuPrincipal
  OnCreate = FormCreate
  TextHeight = 15
  object pnlStatus: TPanel
    Left = 0
    Top = 400
    Width = 624
    Height = 41
    Align = alBottom
    TabOrder = 0
    object lblUsuario: TLabel
      Left = 544
      Top = 26
      Width = 53
      Height = 15
      Caption = 'lblUsuario'
    end
    object lblStatus: TLabel
      Left = 456
      Top = 16
      Width = 45
      Height = 15
      Caption = 'lblStatus'
    end
  end
  object grpConfig: TGroupBox
    Left = 16
    Top = 16
    Width = 592
    Height = 137
    Caption = 'Configura'#231#245'es'
    TabOrder = 1
    object lblDatabase: TLabel
      Left = 16
      Top = 24
      Width = 119
      Height = 15
      Caption = 'Banco de dados (FDB):'
    end
    object lblLogo: TLabel
      Left = 16
      Top = 76
      Width = 103
      Height = 15
      Caption = 'Logo para relat'#243'rio:'
    end
    object edtDatabase: TEdit
      Left = 16
      Top = 44
      Width = 470
      Height = 23
      TabOrder = 0
    end
    object btnSelDatabase: TButton
      Left = 496
      Top = 43
      Width = 75
      Height = 25
      Caption = 'Procurar...'
      TabOrder = 1
      OnClick = btnSelDatabaseClick
    end
    object edtLogo: TEdit
      Left = 16
      Top = 96
      Width = 470
      Height = 23
      TabOrder = 2
    end
    object btnSelLogo: TButton
      Left = 496
      Top = 95
      Width = 75
      Height = 25
      Caption = 'Procurar...'
      TabOrder = 3
      OnClick = btnSelLogoClick
    end
    object btnSalvarConfig: TButton
      Left = 496
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Salvar'
      TabOrder = 4
      OnClick = btnSalvarConfigClick
    end
  end
  object mnuPrincipal: TMainMenu
    object mnuCadastros: TMenuItem
      Caption = 'Cadastros'
      object mnuCadClientes: TMenuItem
        Caption = 'Clientes'
        OnClick = mnuCadClientesClick
      end
      object mnuCadFrota: TMenuItem
        Caption = 'Frota'
        OnClick = mnuCadFrotaClick
      end
      object mnuCadRotas: TMenuItem
        Caption = 'Rotas'
        OnClick = mnuCadRotasClick
      end
    end
    object mnuTransporte: TMenuItem
      Caption = 'Transporte'
      object mnuMovOS: TMenuItem
        Caption = 'Emiss'#227'o de OS'
        OnClick = mnuMovOSClick
      end
    end
  end
end
