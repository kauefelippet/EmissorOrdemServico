unit uClienteRepository;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, Data.DB,
  uClienteModel, dmConexao;

type
  TClienteRepository = class

  private
    FConn: TFDConnection;

  public
    constructor Create;

    // Busca todos ou filtra por texto (razão social, fantasia, documento)
    procedure Listar(AQuery: TFDQuery; const AFiltro: string);

    // Busca um cliente pelo ID e preenche um TClienteModel
    function BuscarPorID(const AID: Integer): TClienteModel;

    // Verifica se já existe outro cliente com o mesmo documento
    function DocumentoDuplicado(const ADocumento: string;
                                const AID: Integer): Boolean;

    // CREATE
    procedure Inserir(const ACliente: TClienteModel);

    // UPDATE
    procedure Atualizar(const ACliente: TClienteModel);

    // DELETE
    procedure Excluir(const AID: Integer);
  end;

implementation

constructor TCLienteRepository.Create;
begin
  FConn := Conexao.Conexao;
end;

procedure TClienteRepository.Listar(AQuery: TFDQuery; const AFiltro: string);
begin
  AQuery.Connection := FConn;
  AQuery.Close;

  if Trim(AFiltro) = '' then
    AQuery.SQL.Text :=
      'SELECT ID, DOCUMENTO, RAZAO_SOCIAL, NOME_FANTASIA, CIDADE, UF ' +
      'FROM CLIENTES ' +
      'ORDER BY RAZAO_SOCIAL'
  else
  begin
    AQuery.SQL.Text :=
      'SELECT ID, DOCUMENTO, RAZAO_SOCIAL, NOME_FANTASIA, CIDADE, UF ' +
      'FROM CLIENTES ' +
      'WHERE RAZAO_SOCIAL CONTAINING :pFiltro ' +
      '   OR NOME_FANTASIA CONTAINING :pFiltro ' +
      '   OR DOCUMENTO     CONTAINING :pFiltro ' +
      'ORDER BY RAZAO_SOCIAL';
    AQuery.ParamByName('pFiltro').AsString := Trim(AFiltro);
  end;

  AQuery.Open;
end;

function TClienteRepository.BuscarPorID(const AID: Integer): TClienteModel;
var
  qry: TFDQuery;
begin
  Result := TClienteModel.Novo;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.SQL.Text   := 'SELECT * FROM CLIENTES WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.Open;

    if not qry.IsEmpty then
    begin
      Result.ID           := qry.FieldByName('ID').AsInteger;
      Result.Documento    := qry.FieldByName('DOCUMENTO').AsString;
      Result.RazaoSocial  := qry.FieldByName('RAZAO_SOCIAL').AsString;
      Result.NomeFantasia := qry.FieldByName('NOME_FANTASIA').AsString;
      Result.IERG         := qry.FieldByName('IE_RG').AsString;
      Result.CEP          := qry.FieldByName('CEP').AsString;
      Result.Logradouro   := qry.FieldByName('LOGRADOURO').AsString;
      Result.Numero       := qry.FieldByName('NUMERO').AsString;
      Result.Bairro       := qry.FieldByName('BAIRRO').AsString;
      Result.Cidade       := qry.FieldByName('CIDADE').AsString;
      Result.UF           := qry.FieldByName('UF').AsString;
    end;
  finally
    qry.Free;
  end;
end;

// AID = 0 para inserção, AID > 0 para edição
function TClienteRepository.DocumentoDuplicado(const ADocumento: string;
                                               const AID: Integer): Boolean;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.SQL.Text   :=
      'SELECT COUNT(*) AS TOTAL FROM CLIENTES ' +
      'WHERE DOCUMENTO = :pDoc AND ID <> :pID';
    qry.ParamByName('pDoc').AsString  := ADocumento;
    qry.ParamByName('pID').AsInteger  := AID;
    qry.Open;
    Result := qry.FieldByName('TOTAL').AsInteger > 0;
  finally
    qry.Free;
  end;
end;

procedure TClienteRepository.Inserir(const ACliente: TClienteModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.SQL.Text   :=
      'INSERT INTO CLIENTES ' +
      '  (DOCUMENTO, RAZAO_SOCIAL, NOME_FANTASIA, IE_RG, ' +
      '   CEP, LOGRADOURO, NUMERO, BAIRRO, CIDADE, UF) ' +
      'VALUES ' +
      '  (:pDoc, :pRazao, :pFantasia, :pIE, ' +
      '   :pCEP, :pLogradouro, :pNumero, :pBairro, :pCidade, :pUF)';

    qry.ParamByName('pDoc').AsString        := ACliente.Documento;
    qry.ParamByName('pRazao').AsString      := ACliente.RazaoSocial;
    qry.ParamByName('pFantasia').AsString   := ACliente.NomeFantasia;
    qry.ParamByName('pIE').AsString         := ACliente.IERG;
    qry.ParamByName('pCEP').AsString        := ACliente.CEP;
    qry.ParamByName('pLogradouro').AsString := ACliente.Logradouro;
    qry.ParamByName('pNumero').AsString     := ACliente.Numero;
    qry.ParamByName('pBairro').AsString     := ACliente.Bairro;
    qry.ParamByName('pCidade').AsString     := ACliente.Cidade;
    qry.ParamByName('pUF').AsString         := ACliente.UF;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TClienteRepository.Atualizar(const ACliente: TClienteModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.SQL.Text   :=
      'UPDATE CLIENTES SET ' +
      '  DOCUMENTO     = :pDoc, ' +
      '  RAZAO_SOCIAL  = :pRazao, ' +
      '  NOME_FANTASIA = :pFantasia, ' +
      '  IE_RG         = :pIE, ' +
      '  CEP           = :pCEP, ' +
      '  LOGRADOURO    = :pLogradouro, ' +
      '  NUMERO        = :pNumero, ' +
      '  BAIRRO        = :pBairro, ' +
      '  CIDADE        = :pCidade, ' +
      '  UF            = :pUF, ' +
      '  UPDATED_AT    = :pUpdated ' +
      'WHERE ID = :pID';

    qry.ParamByName('pDoc').AsString        := ACliente.Documento;
    qry.ParamByName('pRazao').AsString      := ACliente.RazaoSocial;
    qry.ParamByName('pFantasia').AsString   := ACliente.NomeFantasia;
    qry.ParamByName('pIE').AsString         := ACliente.IERG;
    qry.ParamByName('pCEP').AsString        := ACliente.CEP;
    qry.ParamByName('pLogradouro').AsString := ACliente.Logradouro;
    qry.ParamByName('pNumero').AsString     := ACliente.Numero;
    qry.ParamByName('pBairro').AsString     := ACliente.Bairro;
    qry.ParamByName('pCidade').AsString     := ACliente.Cidade;
    qry.ParamByName('pUF').AsString         := ACliente.UF;
    qry.ParamByName('pUpdated').AsDateTime  := Now;
    qry.ParamByName('pID').AsInteger        := ACliente.ID;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TClienteRepository.Excluir(const AID: Integer);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FConn;
    qry.SQL.Text   := 'DELETE FROM CLIENTES WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;


end.
