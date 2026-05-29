unit frmRotas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.ExtCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, uRotaModel, uRotaService, uNotificacao,
  frmCadRota;

type
  TRotas = class(TForm)
    pnlTopo: TPanel;
    edtBusca: TEdit;
    pnlRodape: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    pnlCentro: TPanel;
    gridRotas: TDBGrid;
    qryRotas: TFDQuery;
    dsRotas: TDataSource;
    tmrBusca: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtBuscaChange(Sender: TObject);
    procedure tmrBuscaTimer(Sender: TObject);
    procedure gridRotasDblClick(Sender: TObject);
    procedure gridRotasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    FService  : TRotaService;
    FColunasOk: Boolean;
    procedure CarregarRotas(const AFiltro: string);
    procedure ConfigurarColunas;
    procedure AbrirCadastro(const ARotaID: Integer);
    procedure qryRotasTipoGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
  end;

var
  Rotas: TRotas;

implementation

{$R *.dfm}

procedure TRotas.FormCreate(Sender: TObject);
begin
  FService   := TRotaService.Create;
  FColunasOk := False;

  tmrBusca.Interval := 1500;
  tmrBusca.Enabled  := False;

  CarregarRotas('');
end;

procedure TRotas.FormDestroy(Sender: TObject);
begin
  FService.Free;
end;

procedure TRotas.ConfigurarColunas;
begin
  if FColunasOk then Exit;

  gridRotas.Columns.Clear;

  with gridRotas.Columns.Add do
  begin
    FieldName     := 'DESCRICAO';
    Title.Caption := 'Descrição';
    Width         := 280;
    ReadOnly      := True;
  end;
  with gridRotas.Columns.Add do
  begin
    FieldName     := 'TIPO_CALCULO';
    Title.Caption := 'Tipo de Cálculo';
    Width         := 160;
    ReadOnly      := True;
  end;
  with gridRotas.Columns.Add do
  begin
    FieldName     := 'VALOR_BASE';
    Title.Caption := 'Valor Base (R$)';
    Width         := 130;
    ReadOnly      := True;
  end;
  with gridRotas.Columns.Add do
  begin
    FieldName     := 'MULTIPLICADOR';
    Title.Caption := 'Multiplicador';
    Width         := 120;
    ReadOnly      := True;
  end;

  FColunasOk := True;
end;

procedure TRotas.qryRotasTipoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
var
  Rota: TRotaModel;
begin
  Rota.TipoCalculo := Sender.AsString;
  Text := Rota.TipoDescricao;
end;

procedure TRotas.CarregarRotas(const AFiltro: string);
var
  IDAtual: Integer;
begin
  IDAtual := 0;
  if not qryRotas.IsEmpty then
    IDAtual := qryRotas.FieldByName('ID').AsInteger;

  FService.Listar(qryRotas, AFiltro);

  qryRotas.FieldByName('TIPO_CALCULO').OnGetText := qryRotasTipoGetText;

  ConfigurarColunas;

  if IDAtual > 0 then
    qryRotas.Locate('ID', IDAtual, []);
end;

procedure TRotas.edtBuscaChange(Sender: TObject);
begin
  tmrBusca.Enabled  := False;
  tmrBusca.Enabled  := True;
end;

procedure TRotas.tmrBuscaTimer(Sender: TObject);
begin
  tmrBusca.Enabled  := False;
  CarregarRotas(edtBusca.Text);
end;

procedure TRotas.AbrirCadastro(const ARotaID: Integer);
var
  frmCad: TCadRota;
begin
  frmCad := TCadRota.Create(Self);
  try
    frmCad.RotaID  := ARotaID;
    frmCad.Caption := IfThen(ARotaID = 0, 'Nova Rota', 'Editar Rota');
    if frmCad.ShowModal = mrOk then
      CarregarRotas(edtBusca.Text);
  finally
    frmCad.Free;
  end;
end;

procedure TRotas.btnNovoClick(Sender: TObject);
begin
  AbrirCadastro(0);
end;

procedure TRotas.btnEditarClick(Sender: TObject);
begin
  if qryRotas.IsEmpty then
  begin
    TNotificacao.Aviso(Self, 'Selecione uma rota para editar.');
    Exit;
  end;
  AbrirCadastro(qryRotas.FieldByName('ID').AsInteger);
end;

procedure TRotas.gridRotasDblClick(Sender: TObject);
begin
  if not qryRotas.IsEmpty then
    AbrirCadastro(qryRotas.FieldByName('ID').AsInteger);
end;

procedure TRotas.gridRotasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    btnExcluirClick(Sender);
end;

procedure TRotas.btnExcluirClick(Sender: TObject);
var
  sDesc: string;
  nID  : Integer;
begin
  if qryRotas.IsEmpty then
  begin
    TNotificacao.Aviso(Self, 'Selecione uma rota para excluir.');
    Exit;
  end;

  sDesc := qryRotas.FieldByName('DESCRICAO').AsString;
  nID   := qryRotas.FieldByName('ID').AsInteger;

  if MessageDlg('Excluir a rota "' + sDesc + '"?' + sLineBreak +
                'Esta ação não pode ser desfeita.',
                mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FService.Excluir(nID, sDesc);
      CarregarRotas(edtBusca.Text);
      TNotificacao.Sucesso(Self, 'Rota excluída com sucesso.');
    except
      on E: Exception do
        TNotificacao.Erro(Self, E.Message);
    end;
  end;
end;

end.
