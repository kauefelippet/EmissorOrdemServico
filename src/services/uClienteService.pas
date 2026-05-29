unit uClienteService;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uClienteModel,
  uClienteRepository,
  uValidacoes,
  uFormatacao;

type
  TClienteService = class

  private
    FRepo: TClienteRepository;

  public
    constructor Create;
    destructor Destroy; override;

    // Listar
    procedure Listar(AQuery: TFDQuery; const AFiltro: string);

    // Find by ID
    function BuscarPorID(const AID: Integer): TClienteModel;

    // Salva decidindo internamente se for Insert ou Update via ID
    procedure Salvar(var ACliente: TCLienteModel);

    // Excluir
    procedure Excluir(const AID: Integer; const ANome: string);
  end;

implementation

constructor TClienteService.Create;
begin
  FRepo := TClienteRepository.Create;
end;

destructor TClienteService.Destroy;
begin
  FRepo.Free;
  inherited;
end;

procedure TClienteService.Listar(AQuery: TFDQuery; const AFiltro: string);
begin
  FRepo.Listar(AQuery, AFiltro);
end;

function TClienteService.BuscarPorID(const AID: Integer): TClienteModel;
begin
  Result := FRepo.BuscarPorID(AID);
end;

procedure TClienteService.Salvar(var ACliente: TClienteModel);
var
  sErro   : string;
  sDigitos: string;
begin
  sDigitos := TFormatacao.ApenasNumeros(ACliente.Documento);

  if not TValidacoes.DocumentoValido(sDigitos, sErro) then
    raise Exception.Create(sErro);

  ACliente.Documento := sDigitos;
  ACliente.CEP       := TFormatacao.ApenasNumeros(ACliente.CEP);

  if Trim(ACliente.RazaoSocial) = '' then
    raise Exception.Create('Razão Social é obrigatória.');

  if FRepo.DocumentoDuplicado(ACliente.Documento, ACliente.ID) then
    raise Exception.Create(
      'Já existe um cliente cadastrado com este ' +
      TFormatacao.TipoDocumento(ACliente.Documento) + '.');

  if ACliente.ID = 0 then
    FRepo.Inserir(ACliente)
  else
    FRepo.Atualizar(ACliente);
end;

procedure TClienteService.Excluir(const AID: Integer; const ANome: string);
begin
  try
    FRepo.Excluir(AID);
  except
    on E: Exception do
    begin
      if Pos('-530', E.Message) > 0 then
        raise Exception.Create(
          'O cliente "' + ANome + '" possui registros vinculados ' +
          '(OS, Frota, etc.) e não pode ser excluído.')
      else
        raise;
    end;
  end;
end;

end.
