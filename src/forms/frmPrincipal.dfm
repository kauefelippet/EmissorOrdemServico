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
    object mnuRelatorios: TMenuItem
      Caption = 'Relat'#243'rios'
      object mnuRelOSPeriodo: TMenuItem
        Caption = 'OS por Per'#237'odo'
        OnClick = mnuRelOSPeriodoClick
      end
      object mnuRelOSCliente: TMenuItem
        Caption = 'OS por Cliente'
        OnClick = mnuRelOSClienteClick
      end
    end
  end
end
