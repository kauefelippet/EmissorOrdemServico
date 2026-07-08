unit uOSService;

interface

uses
  System.SysUtils, System.Generics.Collections, System.StrUtils,
  FireDAC.Comp.Client,
  uOSModel, uOSNFeModel, uOSRepository, dmConexao,
  uRotaModel;

type
  TOSService = class
  private
    FRepo: TOSRepository;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Listar(AQuery: TFDQuery; const AFiltro: string);
    function  BuscarPorID(const AID: Integer): TOrdemServicoModel;
    function  ListarNFes(const AIDAOS: Integer): TList<TOSNFeModel>;

    // Lookups
    procedure CarregarClientes(AQuery: TFDQuery);
    procedure CarregarFrota(AQuery: TFDQuery);
    procedure CarregarRotas(AQuery: TFDQuery);

    // Cálculos
    function CalcularFrete(const ARota: TRotaModel;
                           APeso, AQtd, AValorNF, AKM: Double): Double;
    function CalcularICMS(ABase, AAliquota: Double): Double;
    procedure RecalcularTotaisNFe(var AOS: TOrdemServicoModel;
                                  const ANFes: TList<TOSNFeModel>);

    // Persistência
    function  Salvar(var AOS: TOrdemServicoModel;
                     const ANFes: TList<TOSNFeModel>): Integer;
    procedure Emitir(const AID: Integer);
    procedure Cancelar(const AID: Integer);
    procedure Excluir(const AID: Integer; const ANumero: Integer);

    // NF-e
    procedure AdicionarNFe(const ANFe: TOSNFeModel);
    procedure RemoverNFe(const AID: Integer);
  end;

implementation

constructor TOSService.Create;
begin
  FRepo := TOSRepository.Create;
end;

destructor TOSService.Destroy;
begin
  FRepo.Free;
  inherited;
end;

procedure TOSService.Listar(AQuery: TFDQuery; const AFiltro: string);
begin
  FRepo.Listar(AQuery, AFiltro);
end;

function TOSService.BuscarPorID(const AID: Integer): TOrdemServicoModel;
begin
  Result := FRepo.BuscarPorID(AID);
end;

function TOSService.ListarNFes(const AIDAOS: Integer): TList<TOSNFeModel>;
begin
  Result := FRepo.ListarNFes(AIDAOS);
end;

procedure TOSService.CarregarClientes(AQuery: TFDQuery);
begin
  FRepo.CarregarClientes(AQuery);
end;

procedure TOSService.CarregarFrota(AQuery: TFDQuery);
begin
  FRepo.CarregarFrota(AQuery);
end;

procedure TOSService.CarregarRotas(AQuery: TFDQuery);
begin
  FRepo.CarregarRotas(AQuery);
end;

// ─── CalcularFrete ────────────────────────────────────────────────────────────
function TOSService.CalcularFrete(const ARota: TRotaModel;
  APeso, AQtd, AValorNF, AKM: Double): Double;
begin
  case IndexStr(ARota.TipoCalculo,
    [TIPO_FIXO, TIPO_KM, TIPO_PESO, TIPO_VOLUME, TIPO_VALOR_NF]) of
    0: Result := ARota.ValorBase;                        // FIXO
    1: Result := ARota.Multiplicador * AKM;              // POR_KM
    2: Result := ARota.Multiplicador * APeso;            // POR_PESO
    3: Result := ARota.Multiplicador * AQtd;             // POR_VOLUME
    4: Result := ARota.Multiplicador * AValorNF;         // POR_VALOR
  else
    Result := 0;
  end;

  // Soma o valor base quando não for tipo FIXO (valor base adicional opcional)
  if (ARota.TipoCalculo <> TIPO_FIXO) and (ARota.ValorBase > 0) then
    Result := Result + ARota.ValorBase;
end;

// ─── CalcularICMS ─────────────────────────────────────────────────────────────
function TOSService.CalcularICMS(ABase, AAliquota: Double): Double;
begin
  if (ABase <= 0) or (AAliquota <= 0) then
    Result := 0
  else
    Result := ABase * (AAliquota / 100);
end;

// ─── RecalcularTotaisNFe — soma Peso, Qtd e ValorNF das NF-es ─────────────────
procedure TOSService.RecalcularTotaisNFe(var AOS: TOrdemServicoModel;
  const ANFes: TList<TOSNFeModel>);
var
  NFe: TOSNFeModel;
begin
  AOS.PesoTotal       := 0;
  AOS.QuantidadeTotal := 0;
  AOS.ValorMercadoria := 0;

  for NFe in ANFes do
  begin
    AOS.PesoTotal       := AOS.PesoTotal       + NFe.Peso;
    AOS.QuantidadeTotal := AOS.QuantidadeTotal  + NFe.Quantidade;
    AOS.ValorMercadoria := AOS.ValorMercadoria  + NFe.ValorMercadoria;
  end;
end;

// ─── Salvar ───────────────────────────────────────────────────────────────────
function TOSService.Salvar(var AOS: TOrdemServicoModel;
  const ANFes: TList<TOSNFeModel>): Integer;
var
  NFe: TOSNFeModel;
begin
  // Validações
  if AOS.IDRemetente = 0 then
    raise Exception.Create('Remetente é obrigatório.');

  if AOS.IDDestinatario = 0 then
    raise Exception.Create('Destinatário é obrigatório.');

  if AOS.IDTomador = 0 then
    raise Exception.Create('Tomador é obrigatório.');

  if AOS.IDFrota = 0 then
    raise Exception.Create('Frota é obrigatória.');

  if AOS.IDRota = 0 then
    raise Exception.Create('Rota é obrigatória.');

  // Garante status inicial
  if AOS.Status = '' then
    AOS.Status := OS_STATUS_ABERTA;

  if AOS.ID = 0 then
  begin
    Result := FRepo.Inserir(AOS);
    AOS.Numero := Result;

    // Salva NF-es vinculadas à OS recém-criada
    if Result > 0 then
    begin
      // Busca o ID real da OS inserida
      var qryID := TFDQuery.Create(nil);
      try
        qryID.Connection := Conexao.Conexao;
        qryID.SQL.Text :=
          'SELECT ID FROM ORDEM_SERVICO WHERE NUMERO = :pNum';
        qryID.ParamByName('pNum').AsInteger := Result;
        qryID.Open;
        if not qryID.IsEmpty then
          AOS.ID := qryID.FieldByName('ID').AsInteger;
      finally
        qryID.Free;
      end;

      for NFe in ANFes do
      begin
        var Temp := NFe;
        Temp.IDOS := AOS.ID;
        FRepo.InserirNFe(Temp);
      end;
    end;
  end
  else
  begin
    FRepo.Atualizar(AOS);
    // Regrava todas as NF-es (exclui e reinsere)
    FRepo.ExcluirNFesDaOS(AOS.ID);
    for NFe in ANFes do
    begin
      var Temp := NFe;
      Temp.IDOS := AOS.ID;
      FRepo.InserirNFe(Temp);
    end;
    Result := AOS.Numero;
  end;
end;

// ─── Emitir ───────────────────────────────────────────────────────────────────
procedure TOSService.Emitir(const AID: Integer);
var
  OS: TOrdemServicoModel;
begin
  OS := FRepo.BuscarPorID(AID);
  if not OS.PodeEmitir then
    raise Exception.Create(
      'Somente OS com status Aberta pode ser emitida.');
  FRepo.AtualizarStatus(AID, OS_STATUS_EMITIDA);
end;

// ─── Cancelar ─────────────────────────────────────────────────────────────────
procedure TOSService.Cancelar(const AID: Integer);
var
  OS: TOrdemServicoModel;
begin
  OS := FRepo.BuscarPorID(AID);
  if not OS.PodeCancelar then
    raise Exception.Create('Esta OS já está cancelada.');
  FRepo.AtualizarStatus(AID, OS_STATUS_CANCELADA);
end;

// ─── Excluir ──────────────────────────────────────────────────────────────────
procedure TOSService.Excluir(const AID: Integer; const ANumero: Integer);
var
  OS: TOrdemServicoModel;
begin
  OS := FRepo.BuscarPorID(AID);
  if OS.Status = OS_STATUS_EMITIDA then
    raise Exception.Create(
      'A OS ' + ANumero.ToString + ' está Emitida.' + sLineBreak +
      'Cancele-a antes de excluir.');
  FRepo.Excluir(AID);
end;

procedure TOSService.AdicionarNFe(const ANFe: TOSNFeModel);
begin
  FRepo.InserirNFe(ANFe);
end;

procedure TOSService.RemoverNFe(const AID: Integer);
begin
  FRepo.ExcluirNFe(AID);
end;

end.
