unit frmClientes;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client,
  Vcl.Dialogs,
  uClienteService, uFormatacao, uNotificacao,
  frmCadCliente,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Buttons;

type
  TClientes = class(TForm)
    pnlTopo: TPanel;
    pnlRodape: TPanel;
    pnlCentro: TPanel;
    edtBusca: TEdit;
    qryClientes: TFDQuery;
    dsClientes: TDataSource;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    tmrBusca: TTimer;
    gridClientes: TDBGrid;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtBuscaKeyPress(Sender: TObject; var Key: Char);
    procedure gridClientesDblClick(Sender: TObject);
    procedure gridClientesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtBuscaChange(Sender: TObject);
    procedure tmrBuscaTimer(Sender: TObject);

  private
    FService  : TClienteService;
    FColunasOk: Boolean;
    procedure CarregarClientes(const AFiltro: string);
    procedure ConfigurarColunas;
    procedure AbrirCadastro(const AClienteID: Integer);

    procedure qryClientesDocFormatadoGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
  end;

var
  Clientes: TClientes;

implementation

{$R *.dfm}

procedure TClientes.FormCreate(Sender: TObject);
begin
  FService   := TClienteService.Create;
  FColunasOk := False;
  CarregarClientes('');
end;

procedure TClientes.FormDestroy(Sender: TObject);
begin
  FService.Free;
end;

procedure TClientes.ConfigurarColunas;
begin
  if FColunasOk then Exit;

  gridClientes.Columns.Clear;

  with gridClientes.Columns.Add do
  begin
    FieldName     := 'DOCUMENTO';
    Title.Caption := 'CPF / CNPJ';
    Width         := 155;
    ReadOnly      := True;
  end;
  with gridClientes.Columns.Add do
  begin
    FieldName     := 'RAZAO_SOCIAL';
    Title.Caption := 'Razão Social';
    Width         := 280;
    ReadOnly      := True;
  end;
  with gridClientes.Columns.Add do
  begin
    FieldName     := 'NOME_FANTASIA';
    Title.Caption := 'Nome Fantasia';
    Width         := 200;
    ReadOnly      := True;
  end;
  with gridClientes.Columns.Add do
  begin
    FieldName     := 'CIDADE';
    Title.Caption := 'Cidade';
    Width         := 150;
    ReadOnly      := True;
  end;
  with gridClientes.Columns.Add do
  begin
    FieldName     := 'UF';
    Title.Caption := 'UF';
    Width         := 30;
    ReadOnly      := True;
  end;

  FColunasOk := True;
end;

procedure TClientes.qryClientesDocFormatadoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := TFormatacao.FormatarDocumento(Sender.AsString);
end;

procedure TClientes.tmrBuscaTimer(Sender: TObject);
begin
  tmrBusca.Enabled := False;
  CarregarClientes(edtBusca.Text);
end;

procedure TClientes.CarregarClientes(const AFiltro: string);
var
  IDAtual: Integer;
begin
  IDAtual := 0;
  if not qryClientes.IsEmpty then
    IDAtual := qryClientes.FieldByName('ID').AsInteger;

  FService.Listar(qryClientes, AFiltro);

  qryClientes.FieldByName('DOCUMENTO').OnGetText := qryClientesDocFormatadoGetText;

  ConfigurarColunas;

  if IDAtual > 0 then
    qryClientes.Locate('ID', IDAtual, []);
end;

procedure TClientes.edtBuscaChange(Sender: TObject);
begin
  tmrBusca.Enabled := False;
  tmrBusca.Enabled := True;
end;

procedure TClientes.edtBuscaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    CarregarClientes(edtBusca.Text);
  end;
end;

procedure TClientes.AbrirCadastro(const AClienteID: Integer);
var
  frmCad: TCadCliente;
begin
  frmCad := TCadCliente.Create(Self);
  try
    frmCad.ClienteID := AClienteID;
    frmCad.Caption   := IfThen(AClienteID = 0, 'Novo Cliente', 'Editar Cliente');

    if frmCad.ShowModal = mrOk then
    begin
      CarregarClientes(edtBusca.Text);
      TNotificacao.Sucesso(Self, 'Cliente salvo com sucesso!')
    end
    else
      TNotificacao.Aviso(Self, 'Edição cancelada.');

  finally
    frmCad.Free;
  end;
end;

procedure TClientes.btnNovoClick(Sender: TObject);
begin
  AbrirCadastro(0);
end;

procedure TClientes.btnEditarClick(Sender: TObject);
begin
  if qryClientes.IsEmpty then
  begin
    TNotificacao.Info(Self, 'Selecione um Cliente para editar.');
    Exit;
  end;
  AbrirCadastro(qryClientes.FieldByName('ID').AsInteger);
end;

procedure TClientes.gridClientesDblClick(Sender: TObject);
begin
  if not qryClientes.IsEmpty then
    AbrirCadastro(qryClientes.FieldByName('ID').AsInteger);
end;

procedure TClientes.gridClientesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    btnExcluirClick(Sender);
end;

procedure TClientes.btnExcluirClick(Sender: TObject);
var
  sNome: string;
  nID  : Integer;
begin
  if qryClientes.IsEmpty then
  begin
    TNotificacao.Info(Self, 'Selecione um Cliente para excluir.');
    Exit;
  end;

  sNome := qryClientes.FieldByName('RAZAO_SOCIAL').AsString;
  nID   := qryClientes.FieldByName('ID').AsInteger;

  if MessageDlg('Excluir o cliente "' + sNome + '"?' + sLineBreak +
                'Esta ação não pode ser desfeita.',
                mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FService.Excluir(nID, sNome);
      CarregarClientes(edtBusca.Text);
    TNotificacao.Sucesso(Self, 'Cliente excluído com sucesso.');
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  end;
end;

end.
