program EmissorOS;

uses
  Vcl.Forms,
  frmPrincipal in 'forms\frmPrincipal.pas' {Principal},
  dmConexao in 'infra\dmConexao.pas' {Conexao: TDataModule},
  frmClientes in 'forms\frmClientes.pas' {Clientes},
  frmCadCliente in 'forms\frmCadCliente.pas' {CadCliente},
  uClienteModel in 'models\uClienteModel.pas',
  uFormatacao in 'shared\uFormatacao.pas',
  uValidacoes in 'shared\uValidacoes.pas',
  uClienteRepository in 'repositories\uClienteRepository.pas',
  uClienteService in 'services\uClienteService.pas',
  uEnderecoModel in 'models\uEnderecoModel.pas',
  uEnderecoService in 'services\uEnderecoService.pas',
  uNotificacao in 'shared\uNotificacao.pas';

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
