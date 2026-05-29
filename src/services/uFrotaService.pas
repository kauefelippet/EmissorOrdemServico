unit uFrotaService;

interface

uses
  System.SysUtils, FireDAC.Comp.Client,
  uFrotaModel, uFrotaRepository, uValidacoes, uFormatacao;

type
  TFrotaService = class
  private
    FRepo: TFrotaRepository;
  public
    constructor Create;
    destructor Destroy; override;

    // Listar
    procedure Listar(AQuery: TFDQuery; const AFiltro: string);

    // Find by ID
    function  BuscarPorID(const AID: Integer): TFrotaModel;

    // Carregar Proprietarios para ComboBox
    procedure CarregarProprietarios(ACbo: TFDQuery);

    // Salva decidindo internamente se for Insert ou Update via ID
    procedure Salvar(var AFrota: TFrotaModel);

    // Excluir
    procedure Excluir(const AID: Integer; const APlaca: string);
  end;

implementation

constructor TFrotaService.Create;
begin
  FRepo := TFrotaRepository.Create;
end;

destructor TFrotaService.Destroy;
begin
  FRepo.Free;
  inherited;
end;

procedure TFrotaService.Listar(AQuery: TFDQuery; const AFiltro: string);
begin
  FRepo.Listar(AQuery, AFiltro);
end;

function TFrotaService.BuscarPorID(const AID: Integer): TFrotaModel;
begin
  Result := FRepo.BuscarPorID(AID);
end;

procedure TFrotaService.CarregarProprietarios(ACbo: TFDQuery);
begin
  FRepo.CarregarProprietarios(ACbo);
end;

procedure TFrotaService.Salvar(var AFrota: TFrotaModel);
var
  sErro: string;
begin
  AFrota.Placa := TFormatacao.NormalizarPlaca(AFrota.Placa);

  if Trim(AFrota.Placa) = '' then
    raise Exception.Create('Placa é obrigatória.');

  if not TValidacoes.PlacaValida(AFrota.Placa, sErro) then
    raise Exception.Create(sErro);

  if Trim(AFrota.Tipo) = '' then
    raise Exception.Create('Tipo é obrigatório (Próprio ou Terceiro).');

  if FRepo.PlacaDuplicada(AFrota.Placa, AFrota.ID) then
    raise Exception.Create(
      'Já existe um veículo cadastrado com a placa ' +
      TFormatacao.FormatarPlaca(AFrota.Placa) + '.');

  if AFrota.ID = 0 then
    FRepo.Inserir(AFrota)
  else
    FRepo.Atualizar(AFrota);
end;

procedure TFrotaService.Excluir(const AID: Integer; const APlaca: string);
begin
  try
    FRepo.Excluir(AID);
  except
    on E: Exception do
    begin
      if Pos('-530', E.Message) > 0 then
        raise Exception.Create(
          'O veículo de placa ' + APlaca +
          ' possui OS vinculada e não pode ser excluído.')
      else
        raise;
    end;
  end;
end;

end.
