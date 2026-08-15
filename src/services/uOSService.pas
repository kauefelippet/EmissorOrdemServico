unit uOSService;

interface

uses
  System.SysUtils, System.Generics.Collections, System.StrUtils,
  Xml.XMLIntf, Xml.XMLDoc,
  FireDAC.Comp.Client,
  uOSModel, uOSNFeModel, uOSRepository, dmConexao,
  uRotaModel, uRotaRepository, uFormatacao;

type
  // XML de NF-e que não pôde ser interpretado
  EXMLNFeInvalido = class(Exception);

  // Item de lista para preenchimento de ComboBoxes (ID + texto exibido)
  TLookupItem = record
    ID       : Integer;
    Descricao: string;

    class function Novo(const AID: Integer;
                        const ADescricao: string): TLookupItem; static;
  end;

  TOSService = class
  private
    FRepo    : TOSRepository;
    FRotaRepo: TRotaRepository;
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

    function ListarClientesLookup: TList<TLookupItem>;
    function ListarFrotaLookup: TList<TLookupItem>;
    function ListarRotasLookup: TList<TLookupItem>;

    function BuscarRota(const AID: Integer): TRotaModel;

    // Regras de preenchimento
    function RotaExigeKM(const ARota: TRotaModel): Boolean;
    function ExigeTomadorTerceiro(const ATipoTomador: Integer): Boolean;
    function ResolverTomador(const AOS: TOrdemServicoModel;
                             const AIDTerceiro: Integer): Integer;

    // Cálculos
    function CalcularFrete(const ARota: TRotaModel;
                           APeso, AQtd, AValorNF, AKM: Double): Double;
    function CalcularICMS(ABase, AAliquota: Double): Double;

    // Retorna True quando o frete deve ser reescrito automaticamente
    function CalcularFreteAutomatico(const ARota: TRotaModel;
                                     APeso, AQtd, AValorNF, AKM: Double;
                                     const AFreteManual: Boolean;
                                     out AFrete: Double): Boolean;

    // Retorna True quando a base de ICMS deve acompanhar o frete calculado
    function CalcularBaseICMSAutomatica(const AFrete: Double;
                                        const ABaseICMSInformada,
                                              ABaseICMSAutoPreenchida: Boolean;
                                        out ABaseICMS: Double): Boolean;

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
    function  ImportarNFeDeXML(const AArquivo: string;
                               const AIDOS: Integer): TOSNFeModel;
  end;

implementation

class function TLookupItem.Novo(const AID: Integer;
  const ADescricao: string): TLookupItem;
begin
  Result.ID        := AID;
  Result.Descricao := ADescricao;
end;

constructor TOSService.Create;
begin
  FRepo     := TOSRepository.Create;
  FRotaRepo := TRotaRepository.Create;
end;

destructor TOSService.Destroy;
begin
  FRotaRepo.Free;
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

function TOSService.ListarClientesLookup: TList<TLookupItem>;
var
  qry: TFDQuery;
begin
  Result := TList<TLookupItem>.Create;
  qry    := TFDQuery.Create(nil);
  try
    FRepo.CarregarClientes(qry);
    qry.First;
    while not qry.Eof do
    begin
      Result.Add(TLookupItem.Novo(
        qry.FieldByName('ID').AsInteger,
        qry.FieldByName('RAZAO_SOCIAL').AsString));
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TOSService.ListarFrotaLookup: TList<TLookupItem>;
var
  qry: TFDQuery;
begin
  Result := TList<TLookupItem>.Create;
  qry    := TFDQuery.Create(nil);
  try
    FRepo.CarregarFrota(qry);
    qry.First;
    while not qry.Eof do
    begin
      Result.Add(TLookupItem.Novo(
        qry.FieldByName('ID').AsInteger,
        TFormatacao.FormatarPlaca(qry.FieldByName('PLACA').AsString) +
        ' — ' + qry.FieldByName('DESCRICAO').AsString));
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TOSService.ListarRotasLookup: TList<TLookupItem>;
var
  qry: TFDQuery;
begin
  Result := TList<TLookupItem>.Create;
  qry    := TFDQuery.Create(nil);
  try
    FRepo.CarregarRotas(qry);
    qry.First;
    while not qry.Eof do
    begin
      Result.Add(TLookupItem.Novo(
        qry.FieldByName('ID').AsInteger,
        qry.FieldByName('DESCRICAO').AsString));
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TOSService.BuscarRota(const AID: Integer): TRotaModel;
begin
  if AID = 0 then
    Result := TRotaModel.Novo
  else
    Result := FRotaRepo.BuscarPorID(AID);
end;

function TOSService.RotaExigeKM(const ARota: TRotaModel): Boolean;
begin
  Result := ARota.TipoCalculo = TIPO_KM;
end;

function TOSService.ExigeTomadorTerceiro(const ATipoTomador: Integer): Boolean;
begin
  Result := ATipoTomador = OS_TOMADOR_TERCEIRO;
end;

function TOSService.ResolverTomador(const AOS: TOrdemServicoModel;
  const AIDTerceiro: Integer): Integer;
begin
  case AOS.TipoTomador of
    OS_TOMADOR_REMETENTE   : Result := AOS.IDRemetente;
    OS_TOMADOR_DESTINATARIO: Result := AOS.IDDestinatario;
    OS_TOMADOR_TERCEIRO    : Result := AIDTerceiro;
  else Result := 0;
  end;
end;

function TOSService.CalcularFrete(const ARota: TRotaModel;
  APeso, AQtd, AValorNF, AKM: Double): Double;
var
  ValorVariavel: Double;
begin
  ValorVariavel := 0;

  case IndexStr(ARota.TipoCalculo,
    [TIPO_FIXO, TIPO_KM, TIPO_PESO, TIPO_VOLUME, TIPO_VALOR_NF]) of

    0:
      begin
        Result := ARota.ValorBase;
        Exit;
      end;

    1:
      ValorVariavel := ARota.Multiplicador * AKM;

    2:
      ValorVariavel := ARota.Multiplicador * APeso;

    3:
      ValorVariavel := ARota.Multiplicador * AQtd;

    4:
      ValorVariavel := AValorNF * (ARota.Multiplicador / 100);

  else
    Result := 0;
    Exit;
  end;

  Result := ValorVariavel + ARota.ValorBase;
end;

function TOSService.CalcularICMS(ABase, AAliquota: Double): Double;
begin
  if (ABase <= 0) or (AAliquota <= 0) then
    Result := 0
  else
    Result := ABase * (AAliquota / 100);
end;

function TOSService.CalcularFreteAutomatico(const ARota: TRotaModel;
  APeso, AQtd, AValorNF, AKM: Double; const AFreteManual: Boolean;
  out AFrete: Double): Boolean;
begin
  AFrete := 0;

  if ARota.ID = 0 then
    Exit(False);

  if AFreteManual then
    Exit(False);

  AFrete := CalcularFrete(ARota, APeso, AQtd, AValorNF, AKM);
  Result := True;
end;

function TOSService.CalcularBaseICMSAutomatica(const AFrete: Double;
  const ABaseICMSInformada, ABaseICMSAutoPreenchida: Boolean;
  out ABaseICMS: Double): Boolean;
begin
  ABaseICMS := AFrete;
  Result    := (not ABaseICMSInformada) or ABaseICMSAutoPreenchida;
end;

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

function TOSService.Salvar(var AOS: TOrdemServicoModel;
  const ANFes: TList<TOSNFeModel>): Integer;
var
  NFe: TOSNFeModel;
begin
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

  if AOS.Status = '' then
    AOS.Status := OS_STATUS_ABERTA;

  if AOS.ID = 0 then
  begin
    // Inserir ja retorna NUMERO e ID preenchidos em AOS via RETURNING
    FRepo.Inserir(AOS);
    Result := AOS.Numero;

    if AOS.ID > 0 then
    begin
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

procedure TOSService.Cancelar(const AID: Integer);
var
  OS: TOrdemServicoModel;
begin
  OS := FRepo.BuscarPorID(AID);
  if not OS.PodeCancelar then
    raise Exception.Create('Esta OS já está cancelada.');
  FRepo.AtualizarStatus(AID, OS_STATUS_CANCELADA);
end;

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

// ─── ImportarNFeDeXML — lê tags da NF-e e devolve um TOSNFeModel ─────────────
function TOSService.ImportarNFeDeXML(const AArquivo: string;
  const AIDOS: Integer): TOSNFeModel;
var
  XML: IXMLDocument;

  function BuscarNo(ANode: IXMLNode; const ATag: string): IXMLNode;
  var
    I   : Integer;
    Nome: string;
    Sub : IXMLNode;
  begin
    Result := nil;
    if ANode = nil then Exit;

    for I := 0 to ANode.ChildNodes.Count - 1 do
    begin
      Sub  := ANode.ChildNodes[I];
      Nome := Sub.LocalName;
      if SameText(Nome, ATag) then
      begin
        Result := Sub;
        Exit;
      end;
      // Busca nos filhos recursivamente
      Result := BuscarNo(Sub, ATag);
      if Result <> nil then Exit;
    end;
  end;

  function NodeTxt(ANode: IXMLNode; const ATag: string): string;
  var N: IXMLNode;
  begin
    Result := '';
    N := BuscarNo(ANode, ATag);
    if N <> nil then Result := Trim(N.Text);
  end;

  function ToFloat(const S: string): Double;
  var Fmt: TFormatSettings;
  begin
    Fmt := TFormatSettings.Create('pt-BR');
    Fmt.DecimalSeparator := '.';
    Fmt.ThousandSeparator := #0;
    Result := StrToFloatDef(S, 0, Fmt);
  end;

begin
  Result := TOSNFeModel.Novo;

  XML := TXMLDocument.Create(nil);
  XML.Options := XML.Options + [doNodeAutoCreate];
  XML.LoadFromFile(AArquivo);
  XML.Active  := True;

  var Root   := XML.DocumentElement;
  var infNFe := BuscarNo(Root, 'infNFe');

  if infNFe = nil then
    raise EXMLNFeInvalido.Create('XML inválido: nó infNFe não encontrado.');

  Result.NumeroNFe := NodeTxt(infNFe, 'nNF');
  Result.Serie     := NodeTxt(infNFe, 'serie');

  var sChave := '';
  if infNFe.HasAttribute('Id') then
    sChave := infNFe.Attributes['Id'];
  Result.ChaveNFe := StringReplace(sChave, 'NFe', '', [rfReplaceAll]);

  var emit := BuscarNo(infNFe, 'emit');
  if emit <> nil then
    Result.Emitente := NodeTxt(emit, 'xNome');

  var total := BuscarNo(infNFe, 'total');
  if total <> nil then
  begin
    var ICMSTot := BuscarNo(total, 'ICMSTot');
    if ICMSTot <> nil then
    begin
      // Tenta vNF (valor total da NF-e), depois vProd (valor dos produtos)
      var vNF := NodeTxt(ICMSTot, 'vNF');
      var vProd := NodeTxt(ICMSTot, 'vProd');
      if vNF <> '' then
        Result.ValorMercadoria := ToFloat(vNF)
      else if vProd <> '' then
        Result.ValorMercadoria := ToFloat(vProd)
      else
        Result.ValorMercadoria := ToFloat(NodeTxt(total, 'vNFTot')); // fallback
    end
    else
      Result.ValorMercadoria := ToFloat(NodeTxt(total, 'vNFTot')); // fallback
  end;

  var transp := BuscarNo(infNFe, 'transp');
  var vol    := BuscarNo(transp,  'vol');
  if vol <> nil then
  begin
    Result.Peso       := ToFloat(NodeTxt(vol, 'pesoB'));
    Result.Quantidade := Round(ToFloat(NodeTxt(vol, 'qVol')));
  end;

  Result.IDOS := AIDOS;
end;

end.
