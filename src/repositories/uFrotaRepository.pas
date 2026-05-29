unit uFrotaRepository;

interface

uses
  System.SysUtils, System.Variants, FireDAC.Comp.Client, Data.DB,
  uFrotaModel, dmConexao;

type
  TFrotaRepository = class
  private
    function Conn: TFDConnection;
  public
    constructor Create;
    procedure Listar(AQuery: TFDQuery; const AFiltro: string);
    function  BuscarPorID(const AID: Integer): TFrotaModel;
    function  PlacaDuplicada(const APlaca: string; const AID: Integer): Boolean;
    procedure Inserir(const AFrota: TFrotaModel);
    procedure Atualizar(const AFrota: TFrotaModel);
    procedure Excluir(const AID: Integer);
    procedure CarregarProprietarios(AQuery: TFDQuery);
  end;

implementation

constructor TFrotaRepository.Create;
begin
  inherited;
end;

function TFrotaRepository.Conn: TFDConnection;
begin
  Result := Conexao.Conexao;
  if Result = nil then
    raise Exception.Create('Conexão com o banco não disponível.');
end;

procedure TFrotaRepository.Listar(AQuery: TFDQuery; const AFiltro: string);
begin
  AQuery.Connection := Conn;
  AQuery.Close;

  if Trim(AFiltro) = '' then
    AQuery.SQL.Text :=
      'SELECT F.ID, F.PLACA, F.DESCRICAO, F.TIPO, ' +
      '       C.RAZAO_SOCIAL AS PROPRIETARIO ' +
      'FROM FROTA F ' +
      'LEFT JOIN CLIENTES C ON C.ID = F.ID_PROPRIETARIO ' +
      'ORDER BY F.PLACA'
  else
  begin
    AQuery.SQL.Text :=
      'SELECT F.ID, F.PLACA, F.DESCRICAO, F.TIPO, ' +
      '       C.RAZAO_SOCIAL AS PROPRIETARIO ' +
      'FROM FROTA F ' +
      'LEFT JOIN CLIENTES C ON C.ID = F.ID_PROPRIETARIO ' +
      'WHERE F.PLACA        CONTAINING :pFiltro ' +
      '   OR F.DESCRICAO    CONTAINING :pFiltro ' +
      '   OR C.RAZAO_SOCIAL CONTAINING :pFiltro ' +
      'ORDER BY F.PLACA';
    AQuery.ParamByName('pFiltro').AsString := Trim(AFiltro);
  end;

  AQuery.Open;
end;

function TFrotaRepository.BuscarPorID(const AID: Integer): TFrotaModel;
var
  qry: TFDQuery;
begin
  Result := TFrotaModel.Novo;
  qry    := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'SELECT F.*, C.RAZAO_SOCIAL AS PROPRIETARIO ' +
      'FROM FROTA F ' +
      'LEFT JOIN CLIENTES C ON C.ID = F.ID_PROPRIETARIO ' +
      'WHERE F.ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.Open;

    if not qry.IsEmpty then
    begin
      Result.ID               := qry.FieldByName('ID').AsInteger;
      Result.Placa            := qry.FieldByName('PLACA').AsString;
      Result.Descricao        := qry.FieldByName('DESCRICAO').AsString;
      Result.Tipo             := qry.FieldByName('TIPO').AsString;
      Result.IDProprietario   := qry.FieldByName('ID_PROPRIETARIO').AsInteger;
      Result.NomeProprietario := qry.FieldByName('PROPRIETARIO').AsString;
    end;
  finally
    qry.Free;
  end;
end;

function TFrotaRepository.PlacaDuplicada(const APlaca: string;
  const AID: Integer): Boolean;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'SELECT COUNT(*) AS TOTAL FROM FROTA ' +
      'WHERE PLACA = :pPlaca AND ID <> :pID';
    qry.ParamByName('pPlaca').AsString  := APlaca;
    qry.ParamByName('pID').AsInteger    := AID;
    qry.Open;
    Result := qry.FieldByName('TOTAL').AsInteger > 0;
  finally
    qry.Free;
  end;
end;

procedure TFrotaRepository.CarregarProprietarios(AQuery: TFDQuery);
begin
  AQuery.Connection := Conn;
  AQuery.SQL.Text   :=
    'SELECT ID, RAZAO_SOCIAL FROM CLIENTES ORDER BY RAZAO_SOCIAL';
  AQuery.Open;
end;

procedure TFrotaRepository.Inserir(const AFrota: TFrotaModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'INSERT INTO FROTA (PLACA, DESCRICAO, TIPO, ID_PROPRIETARIO) ' +
      'VALUES (:pPlaca, :pDesc, :pTipo, :pProp)';

    qry.ParamByName('pPlaca').AsString := AFrota.Placa;
    qry.ParamByName('pDesc').AsString  := AFrota.Descricao;
    qry.ParamByName('pTipo').AsString  := AFrota.Tipo;

    qry.ParamByName('pProp').DataType := ftInteger;
    if AFrota.IDProprietario > 0 then
      qry.ParamByName('pProp').AsInteger := AFrota.IDProprietario
    else
      qry.ParamByName('pProp').Value := Null;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TFrotaRepository.Atualizar(const AFrota: TFrotaModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'UPDATE FROTA SET ' +
      '  PLACA           = :pPlaca, ' +
      '  DESCRICAO       = :pDesc,  ' +
      '  TIPO            = :pTipo,  ' +
      '  ID_PROPRIETARIO = :pProp,  ' +
      '  UPDATED_AT      = :pUpdated ' +
      'WHERE ID = :pID';

    qry.ParamByName('pPlaca').AsString      := AFrota.Placa;
    qry.ParamByName('pDesc').AsString       := AFrota.Descricao;
    qry.ParamByName('pTipo').AsString       := AFrota.Tipo;
    qry.ParamByName('pUpdated').AsDateTime  := Now;
    qry.ParamByName('pID').AsInteger        := AFrota.ID;

    qry.ParamByName('pProp').DataType := ftInteger;
    if AFrota.IDProprietario > 0 then
      qry.ParamByName('pProp').AsInteger := AFrota.IDProprietario
    else
      qry.ParamByName('pProp').Value := Null;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TFrotaRepository.Excluir(const AID: Integer);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   := 'DELETE FROM FROTA WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

end.
