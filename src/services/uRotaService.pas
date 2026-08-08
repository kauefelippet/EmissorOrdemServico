unit uRotaService;

interface

uses
  System.SysUtils, FireDAC.Comp.Client,
  uRotaModel, uRotaRepository;

type
  TRotaService = class
  private
    FRepo: TRotaRepository;
  public
    constructor Create;
    destructor Destroy; override;

    // Listar
    procedure Listar(AQuery: TFDQuery; const AFiltro: string);

    // Find By ID
    function  BuscarPorID(const AID: Integer): TRotaModel;

    // Salva decidindo internamente se for Insert ou Update via ID
    procedure Salvar(var ARota: TRotaModel);

    // Excluir
    procedure Excluir(const AID: Integer; const ADescricao: string);
  end;

implementation

constructor TRotaService.Create;
begin
  FRepo := TRotaRepository.Create;
end;

destructor TRotaService.Destroy;
begin
  FRepo.Free;
  inherited;
end;

procedure TRotaService.Listar(AQuery: TFDQuery; const AFiltro: string);
begin
  FRepo.Listar(AQuery, AFiltro);
end;

function TRotaService.BuscarPorID(const AID: Integer): TRotaModel;
begin
  Result := FRepo.BuscarPorID(AID);
end;

procedure TRotaService.Salvar(var ARota: TRotaModel);
begin
  if Trim(ARota.Descricao) = '' then
    raise Exception.Create('Descrição da rota é obrigatória.');

  if Trim(ARota.TipoCalculo) = '' then
    raise Exception.Create('Tipo de cálculo é obrigatório.');

  if (ARota.TipoCalculo = TIPO_FIXO) and (ARota.ValorBase <= 0) then
    raise Exception.Create('Rota do tipo Fixo requer um Valor Base maior que zero.');

  if ARota.UsaMultiplicador and (ARota.Multiplicador <= 0) then
    raise Exception.Create(
      'O tipo "' + ARota.TipoDescricao + '" requer o Multiplicador preenchido.');

  if ARota.ID = 0 then
    FRepo.Inserir(ARota)
  else
    FRepo.Atualizar(ARota);
end;

procedure TRotaService.Excluir(const AID: Integer; const ADescricao: string);
begin
  try
    FRepo.Excluir(AID);
  except
    on E: Exception do
    begin
      if Pos('-530', E.Message) > 0 then
        raise Exception.Create(
          'A rota "' + ADescricao +
          '" está vinculada a uma OS e não pode ser excluída.')
      else
        raise;
    end;
  end;
end;

end.
