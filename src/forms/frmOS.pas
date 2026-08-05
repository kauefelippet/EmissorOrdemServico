unit frmOS;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  uOSModel, uOSService, uNotificacao, frmRelatorioOS,
  frmEmissaoOS;

type
  TOS = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    lblSubtitulo: TLabel;
    edtBusca: TEdit;
    btnBuscar: TButton;
    pnlCentro: TPanel;
    gridOS: TDBGrid;
    pnlRodape: TPanel;
    btnExcluir: TButton;
    btnAbrir: TButton;
    btnNovo: TButton;
    tmrBusca: TTimer;
    qryOS: TFDQuery;
    dsOS: TDataSource;
    btnImprimir: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAbrirClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtBuscaChange(Sender: TObject);
    procedure tmrBuscaTimer(Sender: TObject);
    procedure gridOSDblClick(Sender: TObject);
    procedure gridOSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    FService  : TOSService;
    FColunasOk: Boolean;
    procedure CarregarOS(const AFiltro: string);
    procedure ConfigurarColunas;
    procedure AbrirEmissao(const AOSID: Integer);
    procedure qryOSStatusGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
  end;

var
  OS: TOS;

implementation

{$R *.dfm}

procedure TOS.FormCreate(Sender: TObject);
begin
  FService   := TOSService.Create;
  FColunasOk := False;
  tmrBusca.Interval := 1500;
  tmrBusca.Enabled  := False;
  CarregarOS('');
end;

procedure TOS.FormDestroy(Sender: TObject);
begin
  FService.Free;
end;

procedure TOS.ConfigurarColunas;
begin
  if FColunasOk then Exit;
  gridOS.Columns.Clear;

  with gridOS.Columns.Add do
  begin
    FieldName := 'NUMERO'; Title.Caption := 'Nº OS';
    Width := 70; ReadOnly := True;
  end;
  with gridOS.Columns.Add do
  begin
    FieldName := 'DATA'; Title.Caption := 'Data';
    Width := 100; ReadOnly := True;
  end;
  with gridOS.Columns.Add do
  begin
    FieldName := 'STATUS'; Title.Caption := 'Status';
    Width := 90; ReadOnly := True;
  end;
  with gridOS.Columns.Add do
  begin
    FieldName := 'REMETENTE'; Title.Caption := 'Remetente';
    Width := 230; ReadOnly := True;
  end;
  with gridOS.Columns.Add do
  begin
    FieldName := 'DESTINATARIO'; Title.Caption := 'Destinatário';
    Width := 230; ReadOnly := True;
  end;
  with gridOS.Columns.Add do
  begin
    FieldName := 'VALOR_FRETE'; Title.Caption := 'Frete (R$)';
    Width := 110; ReadOnly := True;
  end;

  FColunasOk := True;
end;

procedure TOS.qryOSStatusGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  case IndexStr(Sender.AsString,
    [OS_STATUS_ABERTA, OS_STATUS_EMITIDA, OS_STATUS_CANCELADA]) of
    0: Text := 'Aberta';
    1: Text := 'Emitida';
    2: Text := 'Cancelada';
  else Text := Sender.AsString;
  end;
end;

procedure TOS.CarregarOS(const AFiltro: string);
var
  IDAtual: Integer;
begin
  IDAtual := 0;
  if not qryOS.IsEmpty then
    IDAtual := qryOS.FieldByName('ID').AsInteger;

  FService.Listar(qryOS, AFiltro);
  qryOS.FieldByName('STATUS').OnGetText := qryOSStatusGetText;
  ConfigurarColunas;

  if IDAtual > 0 then
    qryOS.Locate('ID', IDAtual, []);
end;

procedure TOS.edtBuscaChange(Sender: TObject);
begin
  tmrBusca.Enabled := False;
  tmrBusca.Enabled := True;
  btnBuscar.Caption := '...';
end;

procedure TOS.tmrBuscaTimer(Sender: TObject);
begin
  tmrBusca.Enabled  := False;
  btnBuscar.Caption := 'Buscar';
  CarregarOS(edtBusca.Text);
end;

procedure TOS.btnBuscarClick(Sender: TObject);
begin
  CarregarOS(edtBusca.Text);
end;

procedure TOS.AbrirEmissao(const AOSID: Integer);
var
  frmEmissao: TEmissaoOS;
begin
  frmEmissao := TEmissaoOS.Create(Self);
  try
    frmEmissao.OSID := AOSID;
    if frmEmissao.ShowModal = mrOk then
      CarregarOS(edtBusca.Text);
  finally
    frmEmissao.Free;
  end;
end;

procedure TOS.btnNovoClick(Sender: TObject);
begin
  AbrirEmissao(0);
end;

procedure TOS.btnAbrirClick(Sender: TObject);
begin
  if qryOS.IsEmpty then
  begin
    TNotificacao.Aviso(Self, 'Selecione uma OS para abrir.');
    Exit;
  end;
  AbrirEmissao(qryOS.FieldByName('ID').AsInteger);
end;

procedure TOS.btnImprimirClick(Sender: TObject);
var
  Rel: TRelatorioOS;
begin
  if qryOS.IsEmpty then
  begin
    TNotificacao.Aviso(Self, 'Selecione uma OS para imprimir.');
    Exit;
  end;

  Rel := TRelatorioOS.Create(Self);
  try
    Rel.Imprimir(qryOS.FieldByName('ID').AsInteger,
                 ExtractFilePath(Application.ExeName) + 'logo.png');
  finally
    Rel.Free;
  end;
end;

procedure TOS.gridOSDblClick(Sender: TObject);
begin
  if not qryOS.IsEmpty then
    AbrirEmissao(qryOS.FieldByName('ID').AsInteger);
end;

procedure TOS.gridOSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then btnExcluirClick(Sender);
end;

procedure TOS.btnExcluirClick(Sender: TObject);
var
  nID, nNum: Integer;
begin
  if qryOS.IsEmpty then
  begin
    TNotificacao.Aviso(Self, 'Selecione uma OS para excluir.');
    Exit;
  end;

  nID  := qryOS.FieldByName('ID').AsInteger;
  nNum := qryOS.FieldByName('NUMERO').AsInteger;

  if MessageDlg('Excluir a OS nº ' + nNum.ToString + '?' + sLineBreak +
                'Esta ação não pode ser desfeita.',
                mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FService.Excluir(nID, nNum);
      CarregarOS(edtBusca.Text);
      TNotificacao.Sucesso(Self, 'OS excluída com sucesso.');
    except
      on E: Exception do TNotificacao.Erro(Self, E.Message);
    end;
  end;
end;

end.
