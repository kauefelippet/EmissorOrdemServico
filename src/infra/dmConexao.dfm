object Conexao: TConexao
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\Projects\EmissorOrdemServico\db\EMISSOROS.FDB'
      'User_Name=SYSDBA'
      'Password=1q2w3e4r'
      'Protocol=TCPIP'
      'Server=127.0.0.1'
      'Port=3050'
      'CharacterSet=utF8'
      'DriverID=FB')
    Left = 40
    Top = 24
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 144
    Top = 24
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 256
    Top = 24
  end
end
