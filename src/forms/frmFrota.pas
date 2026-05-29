unit frmFrota;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Vcl.ExtCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, uFrotaService, uFormatacao, uNotificacao, frmCadFrota;


type
  TFrota = class(TForm)
    pnlTopo: TPanel;
    edtBusca: TEdit;
    pnlRodape: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    pnlCentro: TPanel;
    qryFrota: TFDQuery;
    dsFrota: TDataSource;
    tmrBusca: TTimer;
    gridFrota: TDBGrid;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtBuscaChange(Sender: TObject);
    procedure tmrBuscaTimer(Sender: TObject);
    procedure gridFrotaDblClick(Sender: TObject);
    procedure gridFrotaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    FService: TFrotaService;
    FColunasOk: Boolean;

    procedure CarregarFrota(const AFiltro: string);
    procedure ConfigurarColunas;
    procedure AbrirCadastro(const AFrotaID: Integer);
    procedure qryFrotaPlacaGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure qryFrotaTipoGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
  end;

var
  Frota: TFrota;

implementation

{$R *.dfm}

procedure TFrota.FormCreate(Sender: TObject);
begin
  FService   := TFrotaService.Create;
  FColunasOk := False;

  tmrBusca.Interval := 1500;
  tmrBusca.Enabled  := False;

  CarregarFrota('');
end;

procedure TFrota.FormDestroy(Sender: TObject);
begin
  FService.Free;
end;

procedure TFrota.ConfigurarColunas;
begin
  if FColunasOk then Exit;

  gridFrota.Columns.Clear;

  with gridFrota.Columns.Add do
  begin
    FieldName     := 'PLACA';
    Title.Caption := 'Placa';
    Width         := 100;
    ReadOnly      := True;
  end;
  with gridFrota.Columns.Add do
  begin
    FieldName     := 'DESCRICAO';
    Title.Caption := 'Descrição';
    Width         := 250;
    ReadOnly      := True;
  end;
  with gridFrota.Columns.Add do
  begin
    FieldName     := 'TIPO';
    Title.Caption := 'Tipo';
    Width         := 90;
    ReadOnly      := True;
  end;
  with gridFrota.Columns.Add do
  begin
    FieldName     := 'PROPRIETARIO';
    Title.Caption := 'Proprietário';
    Width         := 250;
    ReadOnly      := True;
  end;

  FColunasOk := True;
end;

procedure TFrota.qryFrotaPlacaGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := TFormatacao.FormatarPlaca(Sender.AsString);
end;

procedure TFrota.qryFrotaTipoGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if Sender.AsString = 'P' then Text := 'Próprio'
  else if Sender.AsString = 'T' then Text := 'Terceiro'
  else Text := '';
end;

procedure TFrota.CarregarFrota(const AFiltro: string);
var
  IDAtual: Integer;
begin
  IDAtual := 0;
  if not qryFrota.IsEmpty then
    IDAtual := qryFrota.FieldByName('ID').AsInteger;

  FService.Listar(qryFrota, AFiltro);

  qryFrota.FieldByName('PLACA').OnGetText := qryFrotaPlacaGetText;
  qryFrota.FieldByName('TIPO').OnGetText  := qryFrotaTipoGetText;

  ConfigurarColunas;

  if IDAtual > 0 then
    qryFrota.Locate('ID', IDAtual, []);
end;

procedure TFrota.edtBuscaChange(Sender: TObject);
begin
  tmrBusca.Enabled := False;
  tmrBusca.Enabled := True;
end;

procedure TFrota.tmrBuscaTimer(Sender: TObject);
begin
  tmrBusca.Enabled  := False;
  CarregarFrota(edtBusca.Text);
end;

procedure TFrota.AbrirCadastro(const AFrotaID: Integer);
var
  frmCad : TCadFrota;
begin
  frmCad := TCadFrota.Create(Self);
  try
    frmCad.FrotaID := AFrotaID;
    frmCad.Caption := IfThen(AFrotaID = 0, 'Nova Frota', 'Editar Frota');

    if frmCad.ShowModal = mrOk then
    begin
      CarregarFrota(edtBusca.Text);
      TNotificacao.Sucesso(Self, 'Frota salva com sucesso!')
    end
    else
      TNotificacao.Aviso(Self, 'Edição cancelada.');

  finally
    frmCad.Free;
  end;
end;

procedure TFrota.btnEditarClick(Sender: TObject);
begin
  if qryFrota.IsEmpty then
  begin
    TNotificacao.Aviso(Self, 'Selecione um veículo para editar.');
    Exit;
  end;
  AbrirCadastro(qryFrota.FieldByName('ID').AsInteger);
end;

procedure TFrota.btnExcluirClick(Sender: TObject);
var
  sPlaca: string;
  nID: Integer;
begin
  if qryFrota.IsEmpty then
  begin
    TNotificacao.Aviso(Self, 'Selecione um veículo para excluir.');
    Exit;
  end;

  sPlaca := TFormatacao.FormatarPlaca(qryFrota.FieldByName('PLACA').AsString);
  nID := qryFrota.FieldByName('ID').AsInteger;

  if MessageDlg('Excluir o veículo de placa "' + sPlaca + '"?' +
                sLineBreak + 'Esta ação não pode ser desfeita.',
                mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FService.Excluir(nID, sPlaca);
      CarregarFrota(edtBusca.Text);
      TNotificacao.Sucesso(Self, 'Veículo excluído com sucesso.');

    except
      on E: Exception do
        TNotificacao.Erro(Self, E.Message);
    end;
  end;

end;

procedure TFrota.btnNovoClick(Sender: TObject);
begin
  AbrirCadastro(0);
end;

procedure TFrota.gridFrotaDblClick(Sender: TObject);
begin
  if not qryFrota.IsEmpty then
    AbrirCadastro(qryFrota.FieldByName('ID').AsInteger);
end;

procedure TFrota.gridFrotaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    btnExcluirClick(Sender);
end;

end.
