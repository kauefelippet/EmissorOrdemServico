unit uOSRepository;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Variants,
  FireDAC.Comp.Client, Data.DB,
  uOSModel, uOSNFeModel, dmConexao;

type
  TOSRepository = class
  private
    function Conn: TFDConnection;
  public
    // OS
    procedure Listar(AQuery: TFDQuery; const AFiltro: string);
    function  BuscarPorID(const AID: Integer): TOrdemServicoModel;
    procedure Inserir(var AOS: TOrdemServicoModel);
    procedure Atualizar(const AOS: TOrdemServicoModel);
    procedure AtualizarStatus(const AID: Integer; const AStatus: string);
    procedure Excluir(const AID: Integer);

    // NF-es
    function  ListarNFes(const AIDAOS: Integer): TList<TOSNFeModel>;
    procedure InserirNFe(const ANFe: TOSNFeModel);
    procedure ExcluirNFe(const AID: Integer);
    procedure ExcluirNFesDaOS(const AIDAOS: Integer);

    // Lookups para os ComboBoxes
    procedure CarregarClientes(AQuery: TFDQuery);
    procedure CarregarFrota(AQuery: TFDQuery);
    procedure CarregarRotas(AQuery: TFDQuery);
  end;

implementation

function TOSRepository.Conn: TFDConnection;
begin
  Result := Conexao.Conexao;
  if Result = nil then
    raise Exception.Create('Conexão com o banco não disponível.');
end;

// Utilitário interno para parâmetros nullable
procedure SetNullableInt(AQuery: TFDQuery; const AParam: string; AValue: Integer);
begin
  AQuery.ParamByName(AParam).DataType := ftInteger;
  if AValue > 0 then
    AQuery.ParamByName(AParam).AsInteger := AValue
  else
    AQuery.ParamByName(AParam).Value := Null;
end;

// ─── Listar OS ────────────────────────────────────────────────────────────────
procedure TOSRepository.Listar(AQuery: TFDQuery; const AFiltro: string);
begin
  AQuery.Connection := Conn;
  AQuery.Close;

  if Trim(AFiltro) = '' then
    AQuery.SQL.Text :=
      'SELECT O.ID, O.NUMERO, O.DATA, O.STATUS, ' +
      '       R.RAZAO_SOCIAL AS REMETENTE, ' +
      '       D.RAZAO_SOCIAL AS DESTINATARIO, ' +
      '       O.VALOR_FRETE ' +
      'FROM ORDEM_SERVICO O ' +
      'LEFT JOIN CLIENTES R ON R.ID = O.ID_REMETENTE ' +
      'LEFT JOIN CLIENTES D ON D.ID = O.ID_DESTINATARIO ' +
      'ORDER BY O.NUMERO DESC'
  else
  begin
    AQuery.SQL.Text :=
      'SELECT O.ID, O.NUMERO, O.DATA, O.STATUS, ' +
      '       R.RAZAO_SOCIAL AS REMETENTE, ' +
      '       D.RAZAO_SOCIAL AS DESTINATARIO, ' +
      '       O.VALOR_FRETE ' +
      'FROM ORDEM_SERVICO O ' +
      'LEFT JOIN CLIENTES R ON R.ID = O.ID_REMETENTE ' +
      'LEFT JOIN CLIENTES D ON D.ID = O.ID_DESTINATARIO ' +
      'WHERE CAST(O.NUMERO AS VARCHAR(20)) CONTAINING :pFiltro ' +
      '   OR R.RAZAO_SOCIAL CONTAINING :pFiltro ' +
      '   OR D.RAZAO_SOCIAL CONTAINING :pFiltro ' +
      '   OR O.STATUS       CONTAINING :pFiltro ' +
      'ORDER BY O.NUMERO DESC';
    AQuery.ParamByName('pFiltro').AsString := Trim(AFiltro);
  end;

  AQuery.Open;
end;

// ─── BuscarPorID ──────────────────────────────────────────────────────────────
function TOSRepository.BuscarPorID(const AID: Integer): TOrdemServicoModel;
var
  qry: TFDQuery;
begin
  Result := TOrdemServicoModel.Novo;
  qry    := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'SELECT O.*, ' +
      '  R.RAZAO_SOCIAL  AS NOME_REM, ' +
      '  D.RAZAO_SOCIAL  AS NOME_DEST, ' +
      '  T.RAZAO_SOCIAL  AS NOME_TOM, ' +
      '  F.PLACA         AS PLACA_FROTA, ' +
      '  RT.DESCRICAO    AS DESC_ROTA ' +
      'FROM ORDEM_SERVICO O ' +
      'LEFT JOIN CLIENTES R  ON R.ID  = O.ID_REMETENTE ' +
      'LEFT JOIN CLIENTES D  ON D.ID  = O.ID_DESTINATARIO ' +
      'LEFT JOIN CLIENTES T  ON T.ID  = O.ID_TOMADOR ' +
      'LEFT JOIN FROTA    F  ON F.ID  = O.ID_FROTA ' +
      'LEFT JOIN ROTAS    RT ON RT.ID = O.ID_ROTA ' +
      'WHERE O.ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.Open;

    if not qry.IsEmpty then
    begin
      Result.ID              := qry.FieldByName('ID').AsInteger;
      Result.Numero          := qry.FieldByName('NUMERO').AsInteger;
      Result.Data            := qry.FieldByName('DATA').AsDateTime;
      Result.Status          := qry.FieldByName('STATUS').AsString;
      Result.IDRemetente     := qry.FieldByName('ID_REMETENTE').AsInteger;
      Result.IDDestinatario  := qry.FieldByName('ID_DESTINATARIO').AsInteger;
      Result.IDTomador       := qry.FieldByName('ID_TOMADOR').AsInteger;
      Result.IDFrota         := qry.FieldByName('ID_FROTA').AsInteger;
      Result.IDRota          := qry.FieldByName('ID_ROTA').AsInteger;
      Result.KM              := qry.FieldByName('KM').AsFloat;
      Result.CFOP            := qry.FieldByName('CFOP').AsString;
      Result.PesoTotal       := qry.FieldByName('PESO').AsFloat;
      Result.QuantidadeTotal := qry.FieldByName('QUANTIDADE').AsInteger;
      Result.ValorMercadoria := qry.FieldByName('VALOR_MERCADORIA').AsFloat;
      Result.ValorFrete      := qry.FieldByName('VALOR_FRETE').AsFloat;
      Result.Seguro          := qry.FieldByName('SEGURO').AsFloat;
      Result.BaseICMS        := qry.FieldByName('BASE_ICMS').AsFloat;
      Result.Aliquota        := qry.FieldByName('ALIQUOTA').AsFloat;
      Result.ValorICMS       := qry.FieldByName('VALOR_ICMS').AsFloat;
      Result.Observacoes     := qry.FieldByName('OBSERVACOES').AsString;
      Result.NomeRemetente   := qry.FieldByName('NOME_REM').AsString;
      Result.NomeDestinatario:= qry.FieldByName('NOME_DEST').AsString;
      Result.NomeTomador     := qry.FieldByName('NOME_TOM').AsString;
      Result.PlacaFrota      := qry.FieldByName('PLACA_FROTA').AsString;
      Result.DescricaoRota   := qry.FieldByName('DESC_ROTA').AsString;
    end;
  finally
    qry.Free;
  end;
end;

// ─── Inserir OS — retorna o NUMERO gerado e ja preenche o ID ──────────────────
procedure TOSRepository.Inserir(var AOS: TOrdemServicoModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;

    // INSERT retornando NUMERO e ID gerados pelo trigger via RETURNING.
    // RETURNING retorna ambas as colunas em um unico comando — sem segunda query.
    qry.SQL.Text :=
      'INSERT INTO ORDEM_SERVICO ' +
      '  (DATA, STATUS, ID_REMETENTE, ID_DESTINATARIO, ID_TOMADOR, ' +
      '   ID_FROTA, ID_ROTA, KM, CFOP, ' +
      '   PESO, QUANTIDADE, VALOR_MERCADORIA, ' +
      '   VALOR_FRETE, SEGURO, BASE_ICMS, ALIQUOTA, VALOR_ICMS, ' +
      '   OBSERVACOES) ' +
      'VALUES ' +
      '  (:pData, :pStatus, :pRem, :pDest, :pTom, ' +
      '   :pFrota, :pRota, :pKM, :pCFOP, ' +
      '   :pPeso, :pQtd, :pValNF, ' +
      '   :pFrete, :pSeguro, :pBase, :pAliq, :pICMS, ' +
      '   :pObs) ' +
      'RETURNING NUMERO, ID';

    qry.ParamByName('pData').AsDateTime   := AOS.Data;
    qry.ParamByName('pStatus').AsString   := AOS.Status;
    qry.ParamByName('pCFOP').AsString     := AOS.CFOP;
    qry.ParamByName('pPeso').AsFloat      := AOS.PesoTotal;
    qry.ParamByName('pQtd').AsInteger     := AOS.QuantidadeTotal;
    qry.ParamByName('pValNF').AsFloat     := AOS.ValorMercadoria;
    qry.ParamByName('pFrete').AsFloat     := AOS.ValorFrete;
    qry.ParamByName('pSeguro').AsFloat    := AOS.Seguro;
    qry.ParamByName('pBase').AsFloat      := AOS.BaseICMS;
    qry.ParamByName('pAliq').AsFloat      := AOS.Aliquota;
    qry.ParamByName('pICMS').AsFloat      := AOS.ValorICMS;
    qry.ParamByName('pObs').AsString      := AOS.Observacoes;
    qry.ParamByName('pKM').AsFloat        := AOS.KM;

    // Nullable FKs
    SetNullableInt(qry, 'pRem',   AOS.IDRemetente);
    SetNullableInt(qry, 'pDest',  AOS.IDDestinatario);
    SetNullableInt(qry, 'pTom',   AOS.IDTomador);
    SetNullableInt(qry, 'pFrota', AOS.IDFrota);
    SetNullableInt(qry, 'pRota',  AOS.IDRota);

    qry.Open; // RETURNING precisa de Open, não ExecSQL
    if not qry.IsEmpty then
    begin
      AOS.Numero := qry.FieldByName('NUMERO').AsInteger;
      AOS.ID     := qry.FieldByName('ID').AsInteger;
    end;
  finally
    qry.Free;
  end;
end;

// ─── Atualizar OS ─────────────────────────────────────────────────────────────
procedure TOSRepository.Atualizar(const AOS: TOrdemServicoModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'UPDATE ORDEM_SERVICO SET ' +
      '  DATA             = :pData,   STATUS    = :pStatus, ' +
      '  ID_REMETENTE     = :pRem,    ID_DESTINATARIO = :pDest, ' +
      '  ID_TOMADOR       = :pTom,    ID_FROTA  = :pFrota, ' +
      '  ID_ROTA          = :pRota,   KM        = :pKM, ' +
      '  CFOP             = :pCFOP,   PESO      = :pPeso, ' +
      '  QUANTIDADE       = :pQtd,    VALOR_MERCADORIA = :pValNF, ' +
      '  VALOR_FRETE      = :pFrete,  SEGURO    = :pSeguro, ' +
      '  BASE_ICMS        = :pBase,   ALIQUOTA  = :pAliq, ' +
      '  VALOR_ICMS       = :pICMS,   OBSERVACOES = :pObs, ' +
      '  UPDATED_AT       = :pUpdated ' +
      'WHERE ID = :pID';

    qry.ParamByName('pData').AsDateTime    := AOS.Data;
    qry.ParamByName('pStatus').AsString    := AOS.Status;
    qry.ParamByName('pCFOP').AsString      := AOS.CFOP;
    qry.ParamByName('pPeso').AsFloat       := AOS.PesoTotal;
    qry.ParamByName('pQtd').AsInteger      := AOS.QuantidadeTotal;
    qry.ParamByName('pValNF').AsFloat      := AOS.ValorMercadoria;
    qry.ParamByName('pFrete').AsFloat      := AOS.ValorFrete;
    qry.ParamByName('pSeguro').AsFloat     := AOS.Seguro;
    qry.ParamByName('pBase').AsFloat       := AOS.BaseICMS;
    qry.ParamByName('pAliq').AsFloat       := AOS.Aliquota;
    qry.ParamByName('pICMS').AsFloat       := AOS.ValorICMS;
    qry.ParamByName('pObs').AsString       := AOS.Observacoes;
    qry.ParamByName('pKM').AsFloat         := AOS.KM;
    qry.ParamByName('pUpdated').AsDateTime := Now;
    qry.ParamByName('pID').AsInteger       := AOS.ID;

    SetNullableInt(qry, 'pRem',   AOS.IDRemetente);
    SetNullableInt(qry, 'pDest',  AOS.IDDestinatario);
    SetNullableInt(qry, 'pTom',   AOS.IDTomador);
    SetNullableInt(qry, 'pFrota', AOS.IDFrota);
    SetNullableInt(qry, 'pRota',  AOS.IDRota);

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

// ─── AtualizarStatus ──────────────────────────────────────────────────────────
procedure TOSRepository.AtualizarStatus(const AID: Integer;
  const AStatus: string);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'UPDATE ORDEM_SERVICO SET STATUS = :pStatus, UPDATED_AT = :pUpd ' +
      'WHERE ID = :pID';
    qry.ParamByName('pStatus').AsString    := AStatus;
    qry.ParamByName('pUpd').AsDateTime     := Now;
    qry.ParamByName('pID').AsInteger       := AID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

// ─── Excluir OS ───────────────────────────────────────────────────────────────
procedure TOSRepository.Excluir(const AID: Integer);
begin
  ExcluirNFesDaOS(AID); // remove NF-es primeiro (FK)
  var qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   := 'DELETE FROM ORDEM_SERVICO WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

// ─── NF-es ────────────────────────────────────────────────────────────────────
function TOSRepository.ListarNFes(const AIDAOS: Integer): TList<TOSNFeModel>;
var
  qry : TFDQuery;
  NFe : TOSNFeModel;
begin
  Result := TList<TOSNFeModel>.Create;
  qry    := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'SELECT * FROM OS_NFE WHERE ID_OS = :pOS ORDER BY ID';
    qry.ParamByName('pOS').AsInteger := AIDAOS;
    qry.Open;

    while not qry.Eof do
    begin
      NFe                := TOSNFeModel.Novo;
      NFe.ID             := qry.FieldByName('ID').AsInteger;
      NFe.IDOS           := AIDAOS;
      NFe.ChaveNFe       := qry.FieldByName('CHAVE_NFE').AsString;
      NFe.NumeroNFe      := qry.FieldByName('NUMERO_NFE').AsString;
      NFe.Serie          := qry.FieldByName('SERIE').AsString;
      NFe.Emitente       := qry.FieldByName('EMITENTE').AsString;
      NFe.Peso           := qry.FieldByName('PESO').AsFloat;
      NFe.Quantidade     := qry.FieldByName('QUANTIDADE').AsInteger;
      NFe.ValorMercadoria:= qry.FieldByName('VALOR_MERCADORIA').AsFloat;
      Result.Add(NFe);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TOSRepository.InserirNFe(const ANFe: TOSNFeModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'INSERT INTO OS_NFE ' +
      '  (ID_OS, CHAVE_NFE, NUMERO_NFE, SERIE, EMITENTE, ' +
      '   PESO, QUANTIDADE, VALOR_MERCADORIA) ' +
      'VALUES ' +
      '  (:pOS, :pChave, :pNum, :pSerie, :pEmit, ' +
      '   :pPeso, :pQtd, :pValor)';
    qry.ParamByName('pOS').AsInteger    := ANFe.IDOS;
    qry.ParamByName('pChave').AsString  := ANFe.ChaveNFe;
    qry.ParamByName('pNum').AsString    := ANFe.NumeroNFe;
    qry.ParamByName('pSerie').AsString  := ANFe.Serie;
    qry.ParamByName('pEmit').AsString   := ANFe.Emitente;
    qry.ParamByName('pPeso').AsFloat    := ANFe.Peso;
    qry.ParamByName('pQtd').AsInteger   := ANFe.Quantidade;
    qry.ParamByName('pValor').AsFloat   := ANFe.ValorMercadoria;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TOSRepository.ExcluirNFe(const AID: Integer);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   := 'DELETE FROM OS_NFE WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TOSRepository.ExcluirNFesDaOS(const AIDAOS: Integer);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   := 'DELETE FROM OS_NFE WHERE ID_OS = :pOS';
    qry.ParamByName('pOS').AsInteger := AIDAOS;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

// ─── Lookups ──────────────────────────────────────────────────────────────────
procedure TOSRepository.CarregarClientes(AQuery: TFDQuery);
begin
  AQuery.Connection := Conn;
  AQuery.SQL.Text   :=
    'SELECT ID, DOCUMENTO, RAZAO_SOCIAL FROM CLIENTES ORDER BY RAZAO_SOCIAL';
  AQuery.Open;
end;

procedure TOSRepository.CarregarFrota(AQuery: TFDQuery);
begin
  AQuery.Connection := Conn;
  AQuery.SQL.Text   :=
    'SELECT ID, PLACA, DESCRICAO FROM FROTA ORDER BY PLACA';
  AQuery.Open;
end;

procedure TOSRepository.CarregarRotas(AQuery: TFDQuery);
begin
  AQuery.Connection := Conn;
  AQuery.SQL.Text   :=
    'SELECT ID, DESCRICAO, TIPO_CALCULO, VALOR_BASE, MULTIPLICADOR ' +
    'FROM ROTAS ORDER BY DESCRICAO';
  AQuery.Open;
end;

end.
