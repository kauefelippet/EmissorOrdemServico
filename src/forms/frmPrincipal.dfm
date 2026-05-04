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
  TextHeight = 15
  object pnlSuperior: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 248
    ExplicitTop = 48
    ExplicitWidth = 185
    object btnClientes: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 41
      Hint = 'Acessar e gerenciar cadastros de Clientes'
      Caption = 'Clientes'
      TabOrder = 0
      OnClick = btnClientesClick
    end
  end
end
