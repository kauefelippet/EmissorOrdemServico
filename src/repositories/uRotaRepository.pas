unit uRotaRepository;

interface

uses
  System.SysUtils, System.Variants, FireDAC.Comp.Client, Data.DB,
  uRotaModel, dmConexao;

type
  TRotaRepository = class
  private
    function Conn: TFDConnection;

  public

    // Busca todos ou filtra por texto (razão social, fantasia, documento)
    procedure Listar(AQuery: TFDQuery; const AFiltro: string);

    // Busca uma Rota por ID e preenche um TRotaModel
    function  BuscarPorID(const AID: Integer): TRotaModel;

    // CREATE
    procedure Inserir(const ARota: TRotaModel);

    // UPDATE
    procedure Atualizar(const ARota: TRotaModel);

    // DELETE
    procedure Excluir(const AID: Integer);
  end;

implementation

function TRotaRepository.Conn: TFDConnection;
begin
  Result := Conexao.Conexao;
  if Result = nil then
    raise Exception.Create('Conexão com o banco não disponível.');
end;

procedure TRotaRepository.Listar(AQuery: TFDQuery; const AFiltro: string);
begin
  AQuery.Connection := Conn;
  AQuery.Close;

  if Trim(AFiltro) = '' then
    AQuery.SQL.Text :=
      'SELECT ID, DESCRICAO, TIPO_CALCULO, VALOR_BASE, MULTIPLICADOR ' +
      'FROM ROTAS ORDER BY DESCRICAO'
  else
  begin
    AQuery.SQL.Text :=
      'SELECT ID, DESCRICAO, TIPO_CALCULO, VALOR_BASE, MULTIPLICADOR ' +
      'FROM ROTAS ' +
      'WHERE DESCRICAO    CONTAINING :pFiltro ' +
      '   OR TIPO_CALCULO CONTAINING :pFiltro ' +
      'ORDER BY DESCRICAO';
    AQuery.ParamByName('pFiltro').AsString := Trim(AFiltro);
  end;

  AQuery.Open;
end;

function TRotaRepository.BuscarPorID(const AID: Integer): TRotaModel;
var
  qry: TFDQuery;
begin
  Result := TRotaModel.Novo;
  qry    := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   := 'SELECT * FROM ROTAS WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.Open;

    if not qry.IsEmpty then
    begin
      Result.ID            := qry.FieldByName('ID').AsInteger;
      Result.Descricao     := qry.FieldByName('DESCRICAO').AsString;
      Result.TipoCalculo   := qry.FieldByName('TIPO_CALCULO').AsString;
      Result.ValorBase     := qry.FieldByName('VALOR_BASE').AsFloat;
      Result.Multiplicador := qry.FieldByName('MULTIPLICADOR').AsFloat;
    end;
  finally
    qry.Free;
  end;
end;

procedure TRotaRepository.Inserir(const ARota: TRotaModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'INSERT INTO ROTAS (DESCRICAO, TIPO_CALCULO, VALOR_BASE, MULTIPLICADOR) ' +
      'VALUES (:pDesc, :pTipo, :pBase, :pMult)';

    qry.ParamByName('pDesc').AsString  := ARota.Descricao;
    qry.ParamByName('pTipo').AsString  := ARota.TipoCalculo;

    qry.ParamByName('pBase').DataType := ftFloat;
    if ARota.ValorBase > 0 then
      qry.ParamByName('pBase').AsFloat := ARota.ValorBase
    else
      qry.ParamByName('pBase').Value := Null;

    qry.ParamByName('pMult').DataType := ftFloat;
    if ARota.UsaMultiplicador and (ARota.Multiplicador > 0) then
      qry.ParamByName('pMult').AsFloat := ARota.Multiplicador
    else
      qry.ParamByName('pMult').Value := Null;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TRotaRepository.Atualizar(const ARota: TRotaModel);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   :=
      'UPDATE ROTAS SET ' +
      '  DESCRICAO     = :pDesc, ' +
      '  TIPO_CALCULO  = :pTipo, ' +
      '  VALOR_BASE    = :pBase, ' +
      '  MULTIPLICADOR = :pMult, ' +
      '  UPDATED_AT    = :pUpdated ' +
      'WHERE ID = :pID';

    qry.ParamByName('pDesc').AsString      := ARota.Descricao;
    qry.ParamByName('pTipo').AsString      := ARota.TipoCalculo;
    qry.ParamByName('pUpdated').AsDateTime := Now;
    qry.ParamByName('pID').AsInteger       := ARota.ID;

    qry.ParamByName('pBase').DataType := ftFloat;
    if ARota.ValorBase > 0 then
      qry.ParamByName('pBase').AsFloat := ARota.ValorBase
    else
      qry.ParamByName('pBase').Value := Null;

    qry.ParamByName('pMult').DataType := ftFloat;
    if ARota.UsaMultiplicador and (ARota.Multiplicador > 0) then
      qry.ParamByName('pMult').AsFloat := ARota.Multiplicador
    else
      qry.ParamByName('pMult').Value := Null;

    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

procedure TRotaRepository.Excluir(const AID: Integer);
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conn;
    qry.SQL.Text   := 'DELETE FROM ROTAS WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := AID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

end.
