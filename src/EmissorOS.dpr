program EmissorOS;

uses
  Vcl.Forms,
  frmPrincipal in 'frmPrincipal.pas' {Principal},
  dmConexao in 'dmConexao.pas' {Conexao: TDataModule},
  frmClientes in 'frmClientes.pas' {Clientes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TConexao, Conexao);
  Application.CreateForm(TPrincipal, Principal);
  Application.CreateForm(TClientes, Clientes);
  Application.Run;
end.
