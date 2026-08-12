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
  uNotificacao in 'shared\uNotificacao.pas',
  uFrotaModel in 'models\uFrotaModel.pas',
  frmFrota in 'forms\frmFrota.pas' {Frota},
  FrmCadFrota in 'forms\FrmCadFrota.pas' {CadFrota},
  uFrotaService in 'services\uFrotaService.pas',
  uFrotaRepository in 'repositories\uFrotaRepository.pas',
  uRotaModel in 'models\uRotaModel.pas',
  uRotaRepository in 'repositories\uRotaRepository.pas',
  uRotaService in 'services\uRotaService.pas',
  frmRotas in 'forms\frmRotas.pas' {Rotas},
  frmCadRota in 'forms\frmCadRota.pas' {CadRota},
  uOSNFeModel in 'models\uOSNFeModel.pas',
  uOSModel in 'models\uOSModel.pas',
  uOSRepository in 'repositories\uOSRepository.pas',
  uOSService in 'services\uOSService.pas',
  uConfigINI in 'shared\uConfigINI.pas',
  frmOS in 'forms\frmOS.pas' {OS},
  frmEmissaoOS in 'forms\frmEmissaoOS.pas' {TEmissaoOS},
  frmRelatorioOS in 'reports\frmRelatorioOS.pas' {RelatorioOS};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPrincipal, Principal);
  Application.CreateForm(TConexao, Conexao);
  Application.CreateForm(TFrota, Frota);
  Application.CreateForm(TCadFrota, CadFrota);
  Application.CreateForm(TRotas, Rotas);
  Application.CreateForm(TCadRota, CadRota);
  Application.CreateForm(TOS, OS);
  Application.CreateForm(TEmissaoOS, EmissaoOS);
  Application.CreateForm(TClientes, Clientes);
  Application.CreateForm(TCadCliente, CadCliente);
  Application.CreateForm(TOS, OS);
  Application.CreateForm(TEmissaoOS, EmissaoOS);
  Application.CreateForm(TRelatorioOS, RelatorioOS);
  Application.Run;
end.
