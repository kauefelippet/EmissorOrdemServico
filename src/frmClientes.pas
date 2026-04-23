unit frmClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  dmConexao;

type
  TClientes = class(TForm)
    pnlTopo: TPanel;
    edtBusca: TEdit;
    btnBuscar: TButton;
    pnlRodape: TPanel;
    btnNovo: TButton;
    btnSalvar: TButton;
    btnExcluir: TButton;
    pnlCentro: TPanel;
    gridClientes: TDBGrid;
    qryClientes: TFDQuery;
    dsClientes: TDataSource;

    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    procedure CarregarClientes(const AFiltro: string);
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
end;

// Buscar Clientes
procedure TClientes.btnBuscarClick(Sender: TObject);
begin
  CarregarClientes(edtBusca.Text);
end;

// Botao Novo
procedure TClientes.btnNovoClick(Sender: TObject);
begin
  if not qryClientes.Active then
    CarregarClientes('');

  qryClientes.Append;
end;

// Botao Salvar
procedure TClientes.btnSalvarClick(Sender: TObject);
begin
  if not (qryClientes.State in [dsInsert, dsEdit]) then
  begin
    ShowMessage('Nenhuma alteração para salvar.');
    Exit;
  end;

  if Trim(qryClientes.FieldByName('DOCUMENTO').AsString) = '' then
  begin
    ShowMessage('Informe o Documento.');
    qryClientes.FieldByName('DOCUMENTO').FocusControl;
    Exit;
  end;

  if Trim(qryClientes.FieldByName('RAZAO_SOCIAL').AsString) = '' then
  begin
    ShowMessage('Informe a Razão Social.');
    qryClientes.FieldByName('RAZAO_SOCIAL').FocusControl;
    Exit;
  end;

  qryClientes.FieldByName('UPDATED_AT').AsDateTime := Now;
  qryClientes.Post;
  qryClientes.ApplyUpdates(-1);

  ShowMessage('Cliente salvo com sucesso!');
end;

// Botao Excluir
procedure TClientes.btnExcluirClick(Sender: TObject);
begin
  if qryClientes.IsEmpty then
  begin
    ShowMessage('Nenhum Cliente selecionado. Clique em algum para selecionar');
    Exit;
  end;

  if MessageDlg('Excluir Cliente?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    qryClientes.Delete;
    qryClientes.ApplyUpdates(-1);
    ShowMessage('Cliente excluído.');
  end;

end;


end.
