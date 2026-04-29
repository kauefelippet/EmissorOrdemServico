unit frmClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  dmConexao, frmCadCliente;

type
  TClientes = class(TForm)
    pnlTopo: TPanel;
    edtBusca: TEdit;
    btnBuscar: TButton;
    pnlRodape: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    pnlCentro: TPanel;
    gridClientes: TDBGrid;
    qryClientes: TFDQuery;
    dsClientes: TDataSource;

    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtBuscaKeyPress(Sender: TObject; var Key: Char);
  private
    procedure CarregarClientes(const AFiltro: string);
    procedure ConfigurarColunas;
  public
    { Public declarations }
  end;

var
  Clientes: TClientes;

implementation

{$R *.dfm}

// Rodar assim que o Form for instanciado
procedure TClientes.FormCreate(Sender: TObject);
begin
  qryClientes.Connection := Conexao.Conexao;
  qryClientes.CachedUpdates := True;

  CarregarClientes('');
end;

// Método central de busca
procedure TClientes.CarregarClientes(const AFiltro: string);
begin
  qryClientes.Close;

  if Trim(AFiltro) = '' then
  begin
    qryClientes.SQL.Text :=
      'SELECT ID, DOCUMENTO, RAZAO_SOCIAL, NOME_FANTASIA, CEP, CIDADE, UF, CREATED_AT, UPDATED_AT ' +
      'FROM CLIENTES ' +
      'ORDER BY RAZAO_SOCIAL';
  end
  else
  begin
    qryClientes.SQL.Text :=
      'SELECT ID, DOCUMENTO, RAZAO_SOCIAL, NOME_FANTASIA, CEP, CIDADE, UF, CREATED_AT, UPDATED_AT ' +
      'FROM CLIENTES ' +
      'WHERE RAZAO_SOCIAL CONTAINING :pBusca ' +
      '   OR DOCUMENTO    CONTAINING :pBusca ' +
      'ORDER BY RAZAO_SOCIAL';

    qryClientes.ParamByName('pBusca').AsString := Trim(AFiltro);
  end;

  qryClientes.Open;
  ConfigurarColunas;
end;

// Adaptar colunas do grid
procedure TClientes.ConfigurarColunas;
begin
  gridClientes.Columns.Clear;

  with gridClientes.Columns.Add do
  begin
    FieldName      := 'DOCUMENTO';
    Title.Caption  := 'CPF / CNPJ';
    Width          := 130;
  end;

  with gridClientes.Columns.Add do
  begin
    FieldName      := 'RAZAO_SOCIAL';
    Title.Caption  := 'Razão Social';
    Width          := 280;
  end;

  with gridClientes.Columns.Add do
  begin
    FieldName      := 'NOME_FANTASIA';
    Title.Caption  := 'Nome Fantasia';
    Width          := 200;
  end;

  with gridClientes.Columns.Add do
  begin
    FieldName      := 'CIDADE';
    Title.Caption  := 'Cidade';
    Width          := 150;
  end;

  with gridClientes.Columns.Add do
  begin
    FieldName      := 'UF';
    Title.Caption  := 'UF';
    Width          := 45;
  end;
end;

// Buscar Clientes
procedure TClientes.btnBuscarClick(Sender: TObject);
begin
  CarregarClientes(edtBusca.Text);
end;

// Enter no campo de busca
procedure TClientes.edtBuscaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    CarregarClientes(edtBusca.Text);
  end;
end;

// Botao Novo
procedure TClientes.btnNovoClick(Sender: TObject);
var
  frmCad: TCadCliente;
begin
  frmCad := TCadCliente.Create(Self);
  try
    frmCad.ClienteID := 0;
    frmCad.Caption := 'Novo Cliente';

    if frmCad.ShowModal = mrOk then
      CarregarClientes(edtBusca.Text);
  finally
    frmCad.Free;
  end;
end;

// Botao Editar
procedure TClientes.btnEditarClick(Sender: TObject);
var
  frmCad:TCadCliente;
begin
  if qryClientes.IsEmpty then
  begin
    ShowMessage('Selecione um Cliente para editar.');
    Exit;
  end;

  frmCad := TCadCliente.Create(Self);
  try
    frmCad.ClienteID := qryClientes.FieldByName('ID').AsInteger;
    frmCad.Caption := 'Edição de Cliente';

    if frmCad.ShowModal = mrOk then
      CarregarClientes(edtBusca.Text);
  finally
    frmCad.Free;
  end;
end;

// Botao Excluir
procedure TClientes.btnExcluirClick(Sender: TObject);
var
  qry: TFDQuery;
  sNome: string;
begin
  if qryClientes.IsEmpty then
  begin
    ShowMessage('Nenhum Cliente selecionado. Clique em algum para selecionar');
    Exit;
  end;

  sNome := qryClientes.FieldByName('RAZAO_SOCIAL').AsString;

  if MessageDlg('Excluir o cliente "' + sNome + '"?'#13#10 +
                'Esta ação não pode ser desfeita.',
                mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    qry := TFDQuery.Create(nil);
    try
      qry.Connection := Conexao.Conexao;
      qry.SQL.Text := 'DELETE FROM CLIENTES WHERE ID = :pID';
      qry.ParamByName('pID').AsInteger := qryClientes.FieldByName('ID').AsInteger;
      try
        qry.ExecSQL;
        CarregarClientes(edtBusca.Text);
        ShowMessage('Cliente excluído com sucesso.');
      except
        on E: Exception do
          ShowMessage('Não foi possível excluir.'#13#10 +
                      'Verifique se o cliente possui OS vinculada.'#13#10 + E.Message);
      end;
    finally
      qry.Free;
    end;
  end;
end;

end.
