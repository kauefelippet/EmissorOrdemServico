program EmissorOS;

uses
  Vcl.Forms,
  frmPrincipal in 'frmPrincipal.pas' {Principal},
  dmConexao in 'dmConexao.pas' {Conexao: TDataModule},
  frmClientes in 'frmClientes.pas' {Clientes},
  frmCadCliente in 'frmCadCliente.pas' {CadCliente};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TConexao, Conexao);
  Application.CreateForm(TPrincipal, Principal);
  Application.CreateForm(TClientes, Clientes);
  Application.CreateForm(TCadCliente, CadCliente);
  Application.Run;
end.
