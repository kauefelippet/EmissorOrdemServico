unit frmEmissaoOS;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.StrUtils, System.Math, System.Character,
  System.Generics.Collections, Xml.XMLIntf, Xml.XMLDoc,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.ValEdit, Vcl.Dialogs, Data.DB,
  FireDAC.Comp.Client, dmConexao,
  uOSModel, uOSNFeModel, uOSService,
  uRotaModel, uFormatacao, uNotificacao;

type
  TEmissaoOS = class(TForm)
    pnlHeader: TPanel;
    lblNumOS: TLabel;
    lblStatus: TLabel;
    dtpData: TDateTimePicker;
    pnlBotoes: TPanel;
    btnCancelarOS: TButton;
    btnFechar: TButton;
    btnSalvar: TButton;
    btnEmitir: TButton;
    pnlResumoLateral: TPanel;
    grpCarga: TGroupBox;
    lblPeso: TLabel;
    lblQtd: TLabel;
    lblValNF: TLabel;
    edtPeso: TEdit;
    edtQtd: TEdit;
    edtValNF: TEdit;
    grpFinanceiro: TGroupBox;
    lblFrete: TLabel;
    lblValICMS: TLabel;
    edtFrete: TEdit;
    edtValICMS: TEdit;
    pgcEmissao: TPageControl;
    tsPasso1: TTabSheet;
    tsPasso2: TTabSheet;
    tsPasso3: TTabSheet;
    grpPartes: TGroupBox;
    lblRemetente: TLabel;
    cboRemetente: TComboBox;
    lblDest: TLabel;
    cboDest: TComboBox;
    lblTomador: TLabel;
    cboTipoTomador: TComboBox;
    cboTomador: TComboBox;
    grpNFe: TGroupBox;
    gridNFe: TStringGrid;
    btnImportXML: TButton;
    btnAddNFe: TButton;
    btnRemNFe: TButton;
    grpTransporte: TGroupBox;
    lblFrota: TLabel;
    cboFrota: TComboBox;
    lblRota: TLabel;
    cboRota: TComboBox;
    lblKM: TLabel;
    edtKM: TEdit;
    grpTaxas: TGroupBox;
    lblCFOP: TLabel;
    edtCFOP: TEdit;
    lblSeguro: TLabel;
    edtSeguro: TEdit;
    lblBaseICMS: TLabel;
    edtBaseICMS: TEdit;
    lblAliquota: TLabel;
    edtAliquota: TEdit;
    grpObs: TGroupBox;
    memoObs: TMemo;
    btnRecalcularFrete: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEmitirClick(Sender: TObject);
    procedure btnCancelarOSClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnAddNFeClick(Sender: TObject);
    procedure btnRemNFeClick(Sender: TObject);
    procedure btnImportXMLClick(Sender: TObject);
    procedure cboRotaChange(Sender: TObject);
    procedure cboTipoTomadorChange(Sender: TObject);
    procedure edtValorChange(Sender: TObject);
    procedure edtBaseICMSChange(Sender: TObject);
    procedure edtAliquotaChange(Sender: TObject);
    procedure edtValorKeyPress(Sender: TObject; var Key: Char);
    procedure gridNFeSetEditText(Sender: TObject; ACol, ARow: Integer;
                                  const Value: string);
    procedure gridNFeSelectCell(Sender: TObject; ACol, ARow: Integer;
                                  var CanSelect: Boolean);
    procedure edtCargaExit(Sender: TObject);
    procedure edtFreteChange(Sender: TObject);
    procedure edtFreteExit(Sender: TObject);
    procedure btnRecalcularFreteClick(Sender: TObject);

  public
    OSID: Integer;

  private
    FService       : TOSService;
    FRotaAtual     : TRotaModel;
    FNFes          : TList<TOSNFeModel>;
    FBaseICMSAutoPreenchida: Boolean;
    FFreteManual: Boolean; // True se o usuario editou o frete manualmente
    // Listas paralelas dos ComboBoxes
    FIDsClientes   : TList<Integer>;
    FIDsFrota      : TList<Integer>;
    FIDsRotas      : TList<Integer>;

    procedure CarregarLookups;
    procedure CarregarOS;
    procedure PreencherCampos(const AOS: TOrdemServicoModel);
    function  ColetarCampos: TOrdemServicoModel;
    procedure AtualizarGridNFe;
    procedure RecalcularFrete;
    procedure RecalcularICMS;
    procedure AtualizarTotaisNFe;
    procedure AtualizarVisibilidadeCampos;
    procedure AtualizarStatusVisual(const AStatus: string);
    procedure DefinirEdicao(const AEditavel: Boolean);
    procedure SelecionarCombo(ACbo: TComboBox; AIDList: TList<Integer>;
                              AID: Integer);
    function  IDDaCombo(ACbo: TComboBox; AIDList: TList<Integer>): Integer;
    procedure ImportarXMLNFe(const AArquivo: string);
  end;

var
  EmissaoOS: TEmissaoOS;

implementation

{$R *.dfm}

// ─── FormCreate ───────────────────────────────────────────────────────────────
procedure TEmissaoOS.FormCreate(Sender: TObject);
begin
  FService     := TOSService.Create;
  FNFes        := TList<TOSNFeModel>.Create;
  FIDsClientes := TList<Integer>.Create;
  FIDsFrota    := TList<Integer>.Create;
  FIDsRotas    := TList<Integer>.Create;
  FRotaAtual   := TRotaModel.Novo;
  FBaseICMSAutoPreenchida := True;
  FFreteManual := False;

  // Tipo de tomador
  cboTipoTomador.Items.Clear;
  cboTipoTomador.Items.Add('Remetente');
  cboTipoTomador.Items.Add('Destinatário');
  cboTipoTomador.Items.Add('Terceiro');
  cboTipoTomador.ItemIndex := 0;

  // Grid NF-e — cabeçalhos e configuração
  gridNFe.ColCount := 7;
  gridNFe.RowCount := 2;
  gridNFe.FixedRows := 1;
  gridNFe.Cells[0,0] := 'Nº NF-e';
  gridNFe.Cells[1,0] := 'Série';
  gridNFe.Cells[2,0] := 'Emitente';
  gridNFe.Cells[3,0] := 'Chave NF-e';
  gridNFe.Cells[4,0] := 'Peso';
  gridNFe.Cells[5,0] := 'Qtd';
  gridNFe.Cells[6,0] := 'Valor (R$)';
  gridNFe.Options := gridNFe.Options + [goEditing, goAlwaysShowEditor];
  gridNFe.OnSetEditText  := gridNFeSetEditText;
  gridNFe.OnSelectCell   := gridNFeSelectCell;

  // Larguras das colunas do grid NF-e
  gridNFe.ColWidths[0] := 80;
  gridNFe.ColWidths[1] := 50;
  gridNFe.ColWidths[2] := 180;
  gridNFe.ColWidths[3] := 200;
  gridNFe.ColWidths[4] := 80;
  gridNFe.ColWidths[5] := 60;
  gridNFe.ColWidths[6] := 100;

  // Campos calculados — somente leitura
  edtFrete.ReadOnly  := False;
  edtValICMS.ReadOnly:= True;
  edtPeso.ReadOnly   := True;
  edtQtd.ReadOnly    := True;
  edtValNF.ReadOnly  := True;

  // Eventos de recálculo
  edtSeguro.OnChange   := edtValorChange;
  edtBaseICMS.OnChange := edtBaseICMSChange;
  edtAliquota.OnChange := edtAliquotaChange;
  edtKM.OnChange       := edtValorChange;

  // Filtro numérico
  edtKM.OnKeyPress      := edtValorKeyPress;
  edtSeguro.OnKeyPress  := edtValorKeyPress;
  edtBaseICMS.OnKeyPress:= edtValorKeyPress;
  edtAliquota.OnKeyPress:= edtValorKeyPress;

  // Eventos OnExit
  edtPeso.OnExit   := edtCargaExit;
  edtQtd.OnExit    := edtCargaExit;
  edtValNF.OnExit  := edtCargaExit;
  edtKM.OnExit     := edtCargaExit;
  edtSeguro.OnExit := edtCargaExit;

  // Preenchimento manual do valor do frete
  edtFrete.OnChange    := edtFreteChange;
  edtFrete.OnKeyPress  := edtValorKeyPress; // mesmo filtro numérico
  edtFrete.OnExit      := edtFreteExit;

  KeyPreview       := True;
  btnFechar.Cancel := True;

  CarregarLookups;
end;

procedure TEmissaoOS.FormShow(Sender: TObject);
begin
  if OSID > 0 then
    CarregarOS
  else
  begin
    lblNumOS.Caption  := 'Nova OS';
    AtualizarStatusVisual(OS_STATUS_ABERTA);
    dtpData.Date      := Date;
    AtualizarVisibilidadeCampos;
  end;
end;

procedure TEmissaoOS.FormDestroy(Sender: TObject);
begin
  FNFes.Free;
  FIDsClientes.Free;
  FIDsFrota.Free;
  FIDsRotas.Free;
  FService.Free;
end;

procedure TEmissaoOS.edtCargaExit(Sender: TObject);
begin
  RecalcularFrete; // recalcula sempre que sair de qualquer campo de carga
end;

// ─── CarregarLookups — preenche todos os ComboBoxes ──────────────────────────
procedure TEmissaoOS.CarregarLookups;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    // Clientes
    FService.CarregarClientes(qry);
    cboRemetente.Items.Clear; cboDest.Items.Clear; cboTomador.Items.Clear;
    FIDsClientes.Clear;

    cboRemetente.Items.Add('— Selecione —');
    cboDest.Items.Add('— Selecione —');
    cboTomador.Items.Add('— Selecione —');
    FIDsClientes.Add(0);

    qry.First;
    while not qry.Eof do
    begin
      cboRemetente.Items.Add(qry.FieldByName('RAZAO_SOCIAL').AsString);
      cboDest.Items.Add(qry.FieldByName('RAZAO_SOCIAL').AsString);
      cboTomador.Items.Add(qry.FieldByName('RAZAO_SOCIAL').AsString);
      FIDsClientes.Add(qry.FieldByName('ID').AsInteger);
      qry.Next;
    end;
    cboRemetente.ItemIndex := 0;
    cboDest.ItemIndex      := 0;
    cboTomador.ItemIndex   := 0;

    // Frota
    qry.Close;
    FService.CarregarFrota(qry);
    cboFrota.Items.Clear;
    FIDsFrota.Clear;
    cboFrota.Items.Add('— Selecione —');
    FIDsFrota.Add(0);
    qry.First;
    while not qry.Eof do
    begin
      cboFrota.Items.Add(
        TFormatacao.FormatarPlaca(qry.FieldByName('PLACA').AsString) +
        ' — ' + qry.FieldByName('DESCRICAO').AsString);
      FIDsFrota.Add(qry.FieldByName('ID').AsInteger);
      qry.Next;
    end;
    cboFrota.ItemIndex := 0;

    // Rotas — também armazena o model completo para cálculo
    qry.Close;
    FService.CarregarRotas(qry);
    cboRota.Items.Clear;
    FIDsRotas.Clear;
    cboRota.Items.Add('— Selecione —');
    FIDsRotas.Add(0);
    qry.First;
    while not qry.Eof do
    begin
      cboRota.Items.Add(qry.FieldByName('DESCRICAO').AsString);
      FIDsRotas.Add(qry.FieldByName('ID').AsInteger);
      qry.Next;
    end;
    cboRota.ItemIndex := 0;

  finally
    qry.Free;
  end;
end;

// ─── Utilitários de ComboBox + Lista paralela ─────────────────────────────────
procedure TEmissaoOS.SelecionarCombo(ACbo: TComboBox;
  AIDList: TList<Integer>; AID: Integer);
var I: Integer;
begin
  ACbo.ItemIndex := 0;
  for I := 0 to AIDList.Count - 1 do
    if AIDList[I] = AID then
    begin
      ACbo.ItemIndex := I;
      Break;
    end;
end;

function TEmissaoOS.IDDaCombo(ACbo: TComboBox;
  AIDList: TList<Integer>): Integer;
var I: Integer;
begin
  I := ACbo.ItemIndex;
  if (I >= 0) and (I < AIDList.Count) then
    Result := AIDList[I]
  else
    Result := 0;
end;

// ─── CarregarOS — busca OS existente e preenche ───────────────────────────────
procedure TEmissaoOS.CarregarOS;
var
  AOS : TOrdemServicoModel;
  NFes: TList<TOSNFeModel>;
  NFe : TOSNFeModel;
begin
  AOS  := FService.BuscarPorID(OSID);
  NFes := FService.ListarNFes(OSID);
  try
    FNFes.Clear;
    for NFe in NFes do
      FNFes.Add(NFe);
  finally
    NFes.Free;
  end;
  PreencherCampos(AOS);
end;

// ─── PreencherCampos — OS → tela ─────────────────────────────────────────────
procedure TEmissaoOS.PreencherCampos(const AOS: TOrdemServicoModel);
begin
  lblNumOS.Caption := 'OS Nº ' + AOS.Numero.ToString.PadLeft(4, '0');
  dtpData.Date     := AOS.Data;

  SelecionarCombo(cboRemetente, FIDsClientes, AOS.IDRemetente);
  SelecionarCombo(cboDest,      FIDsClientes, AOS.IDDestinatario);
  SelecionarCombo(cboFrota,     FIDsFrota,    AOS.IDFrota);
  SelecionarCombo(cboRota,      FIDsRotas,    AOS.IDRota);

  cboTipoTomador.ItemIndex := AOS.TipoTomador;
  if AOS.TipoTomador = OS_TOMADOR_TERCEIRO then
    SelecionarCombo(cboTomador, FIDsClientes, AOS.IDTomador);

  edtKM.Text      := IfThen(AOS.KM > 0, FormatFloat('0.00', AOS.KM), '');
  edtCFOP.Text    := AOS.CFOP;
  edtSeguro.Text  := IfThen(AOS.Seguro > 0, FormatFloat('0.00', AOS.Seguro), '');
  edtBaseICMS.Text:= IfThen(AOS.BaseICMS > 0, FormatFloat('0.00', AOS.BaseICMS), '');
  edtAliquota.Text:= IfThen(AOS.Aliquota > 0, FormatFloat('0.00', AOS.Aliquota), '');
  edtFrete.Text   := FormatFloat('R$ 0.00', AOS.ValorFrete);
  edtValICMS.Text := FormatFloat('R$ 0.00', AOS.ValorICMS);
  memoObs.Text    := AOS.Observacoes;

  AtualizarGridNFe;
  AtualizarTotaisNFe;
  AtualizarStatusVisual(AOS.Status);
  AtualizarVisibilidadeCampos;
  DefinirEdicao(AOS.Editavel);
end;

// ─── AtualizarGridNFe — sincroniza FNFes com o TStringGrid ───────────────────
procedure TEmissaoOS.AtualizarGridNFe;
var
  I  : Integer;
  NFe: TOSNFeModel;
begin
  gridNFe.RowCount := Max(2, FNFes.Count + 1);

  for I := 0 to FNFes.Count - 1 do
  begin
    NFe := FNFes[I];
    gridNFe.Cells[0, I+1] := NFe.NumeroNFe;
    gridNFe.Cells[1, I+1] := NFe.Serie;
    gridNFe.Cells[2, I+1] := NFe.Emitente;
    gridNFe.Cells[3, I+1] := NFe.ChaveNFe;
    gridNFe.Cells[4, I+1] := FormatFloat('0.000', NFe.Peso);
    gridNFe.Cells[5, I+1] := NFe.Quantidade.ToString;
    gridNFe.Cells[6, I+1] := FormatFloat('0.00', NFe.ValorMercadoria);
  end;
end;

// ─── AtualizarTotaisNFe — soma campos das NF-es e recalcula frete ─────────────
procedure TEmissaoOS.AtualizarTotaisNFe;
var
  TotalPeso: Double;
  TotalQtd : Integer;
  TotalVal : Double;
  NFe      : TOSNFeModel;
begin
  TotalPeso := 0; TotalQtd := 0; TotalVal := 0;
  for NFe in FNFes do
  begin
    TotalPeso := TotalPeso + NFe.Peso;
    TotalQtd  := TotalQtd  + NFe.Quantidade;
    TotalVal  := TotalVal  + NFe.ValorMercadoria;
  end;

  edtPeso.Text  := FormatFloat('0.000', TotalPeso);
  edtQtd.Text   := TotalQtd.ToString;
  edtValNF.Text := FormatFloat('0.00', TotalVal);

  RecalcularFrete;
end;

// Detecta quando usuário está digitando manualmente no frete
procedure TEmissaoOS.edtFreteChange(Sender: TObject);
begin
  // Só marca como manual se a mudança veio do usuário (teclado)
  // não do RecalcularFrete. Usa o foco para distinguir.
  if edtFrete.Focused then
  begin
    FFreteManual            := True;
    FBaseICMSAutoPreenchida := False; // se editou frete manualmente, base ICMS tbm fica livre
  end;
end;

// Ao sair do campo frete, recalcula ICMS com o novo valor manual
procedure TEmissaoOS.edtFreteExit(Sender: TObject);
begin
  if FFreteManual then
    RecalcularICMS;
end;

// ─── RecalcularFrete — usa Service com dados atuais da tela ──────────────────
procedure TEmissaoOS.RecalcularFrete;
var
  Frete: Double;
begin
  if FRotaAtual.ID = 0 then Exit;

  // Se usuário editou manualmente, não sobrescreve
  if FFreteManual then Exit;

  Frete := FService.CalcularFrete(
    FRotaAtual,
    StrToFloatDef(StringReplace(edtPeso.Text, ',', '.', [rfReplaceAll]), 0),
    StrToIntDef(edtQtd.Text, 0),
    StrToFloatDef(StringReplace(edtValNF.Text, ',', '.', [rfReplaceAll]), 0),
    StrToFloatDef(StringReplace(edtKM.Text,    ',', '.', [rfReplaceAll]), 0));

  edtFrete.Text := FormatFloat('0.00', Frete);

  if (Trim(edtBaseICMS.Text) = '') or FBaseICMSAutoPreenchida then
  begin
    edtBaseICMS.Text        := FormatFloat('0.00', Frete);
    FBaseICMSAutoPreenchida := True;
    RecalcularICMS;
  end;
end;

// ─── RecalcularICMS ───────────────────────────────────────────────────────────
procedure TEmissaoOS.RecalcularICMS;
var
  Base, Aliq, ICMS: Double;
begin
  Base := StrToFloatDef(
    StringReplace(edtBaseICMS.Text, ',', '.', [rfReplaceAll]), 0);
  Aliq := StrToFloatDef(
    StringReplace(edtAliquota.Text, ',', '.', [rfReplaceAll]), 0);

  ICMS := FService.CalcularICMS(Base, Aliq);
  edtValICMS.Text := FormatFloat('R$ 0.00', ICMS);
end;

// ─── Eventos de mudança de valor ─────────────────────────────────────────────
procedure TEmissaoOS.edtValorChange(Sender: TObject);
begin
  RecalcularFrete;
end;

procedure TEmissaoOS.btnRecalcularFreteClick(Sender: TObject);
begin
  FFreteManual            := False;
  FBaseICMSAutoPreenchida := True;
  RecalcularFrete;
end;

// ─── Muda a rota selecionada — atualiza FRotaAtual e recalcula ────────────────
procedure TEmissaoOS.cboRotaChange(Sender: TObject);
var
  qry   : TFDQuery;
  IDRota: Integer;
begin
  IDRota := IDDaCombo(cboRota, FIDsRotas);
  if IDRota = 0 then
  begin
    FRotaAtual              := TRotaModel.Novo;
    FBaseICMSAutoPreenchida := True; // reseta ao trocar rota
    AtualizarVisibilidadeCampos;
    Exit;
  end;

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conexao.Conexao;
    qry.SQL.Text   := 'SELECT * FROM ROTAS WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := IDRota;
    qry.Open;

    if not qry.IsEmpty then
    begin
      FRotaAtual.ID            := qry.FieldByName('ID').AsInteger;
      FRotaAtual.TipoCalculo   := qry.FieldByName('TIPO_CALCULO').AsString;
      FRotaAtual.ValorBase     := qry.FieldByName('VALOR_BASE').AsFloat;
      FRotaAtual.Multiplicador := qry.FieldByName('MULTIPLICADOR').AsFloat;
      FRotaAtual.Descricao     := qry.FieldByName('DESCRICAO').AsString;
    end;
  finally
    qry.Free;
  end;

  FFreteManual            := False; // nova rota reseta o frete manual
  FBaseICMSAutoPreenchida := True; // nova rota → base ICMS volta ao automático
  AtualizarVisibilidadeCampos;
  RecalcularFrete; // ← recalcula com a nova rota
end;

// ─── Visibilidade do campo KM e ComboBox Tomador ─────────────────────────────
procedure TEmissaoOS.AtualizarVisibilidadeCampos;
begin
  // Campo KM só aparece para rotas POR_KM
  lblKM.Visible := FRotaAtual.TipoCalculo = TIPO_KM;
  edtKM.Visible := FRotaAtual.TipoCalculo = TIPO_KM;

  // ComboBox Tomador só aparece se tipo = Terceiro
  cboTomador.Visible := cboTipoTomador.ItemIndex = OS_TOMADOR_TERCEIRO;
end;

procedure TEmissaoOS.cboTipoTomadorChange(Sender: TObject);
begin
  AtualizarVisibilidadeCampos;
end;

// ─── Status visual do badge ───────────────────────────────────────────────────
procedure TEmissaoOS.AtualizarStatusVisual(const AStatus: string);
begin
  lblStatus.Caption := AStatus;
  case IndexStr(AStatus,
    [OS_STATUS_ABERTA, OS_STATUS_EMITIDA, OS_STATUS_CANCELADA]) of
    0: lblStatus.Font.Color := $008000; // verde
    1: lblStatus.Font.Color := $0050CC; // azul
    2: lblStatus.Font.Color := $2020CC; // vermelho
  end;
end;

// ─── Habilita/desabilita campos conforme status ───────────────────────────────
procedure TEmissaoOS.DefinirEdicao(const AEditavel: Boolean);
begin
  cboRemetente.Enabled    := AEditavel;
  cboDest.Enabled         := AEditavel;
  cboTipoTomador.Enabled  := AEditavel;
  cboTomador.Enabled      := AEditavel;
  cboFrota.Enabled        := AEditavel;
  cboRota.Enabled         := AEditavel;
  edtKM.Enabled           := AEditavel;
  edtCFOP.Enabled         := AEditavel;
  edtSeguro.Enabled       := AEditavel;
  edtBaseICMS.Enabled     := AEditavel;
  edtAliquota.Enabled     := AEditavel;
  memoObs.Enabled         := AEditavel;
  btnAddNFe.Enabled       := AEditavel;
  btnRemNFe.Enabled       := AEditavel;
  btnImportXML.Enabled    := AEditavel;
  btnSalvar.Enabled       := AEditavel;
  btnEmitir.Enabled       := AEditavel;
  dtpData.Enabled         := AEditavel;
end;

// ─── NF-e: Adicionar linha manual ────────────────────────────────────────────
procedure TEmissaoOS.btnAddNFeClick(Sender: TObject);
var
  NFe: TOSNFeModel;
begin
  NFe      := TOSNFeModel.Novo;
  NFe.IDOS := OSID;
  FNFes.Add(NFe);
  AtualizarGridNFe;
  // Foco na última linha para digitação
  gridNFe.Row := gridNFe.RowCount - 1;
  gridNFe.Col := 0;
end;

// ─── NF-e: Remover linha selecionada ─────────────────────────────────────────
procedure TEmissaoOS.btnRemNFeClick(Sender: TObject);
var
  Linha: Integer;
begin
  Linha := gridNFe.Row - 1; // -1 pelo cabeçalho
  if (Linha < 0) or (Linha >= FNFes.Count) then
  begin
    TNotificacao.Aviso(Self, 'Selecione uma NF-e para remover.');
    Exit;
  end;

  if MessageDlg('Remover esta NF-e?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FNFes.Delete(Linha);
    AtualizarGridNFe;
    AtualizarTotaisNFe;
  end;
end;

// Impede edição do cabeçalho (linha 0)
procedure TEmissaoOS.gridNFeSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := ARow > 0;
end;

// Sincroniza o que o usuário digitou na grid com o FNFes
procedure TEmissaoOS.gridNFeSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
var
  Idx: Integer;
  NFe: TOSNFeModel;
begin
  Idx := ARow - 1; // desconta cabeçalho
  if (Idx < 0) or (Idx >= FNFes.Count) then Exit;

  NFe := FNFes[Idx];

  case ACol of
    0: NFe.NumeroNFe      := Value;
    1: NFe.Serie          := Value;
    2: NFe.Emitente       := Value;
    3: NFe.ChaveNFe       := Value;
    4: NFe.Peso           := StrToFloatDef(
                               StringReplace(Value, ',', '.', [rfReplaceAll]), 0);
    5: NFe.Quantidade     := StrToIntDef(Value, 0);
    6: NFe.ValorMercadoria:= StrToFloatDef(
                               StringReplace(Value, ',', '.', [rfReplaceAll]), 0);
  end;

  FNFes[Idx] := NFe; // record é valor — precisa reatribuir

  // Recalcula totais sempre que Peso, Qtd ou Valor forem editados
  if ACol in [4, 5, 6] then
    AtualizarTotaisNFe;
end;

// ─── NF-e: Importar XML ──────────────────────────────────────────────────────
procedure TEmissaoOS.btnImportXMLClick(Sender: TObject);
var
  dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(Self);
  try
    dlg.Title  := 'Selecionar XML de NF-e';
    dlg.Filter := 'XML NF-e (*.xml)|*.xml';
    dlg.Options:= [ofAllowMultiSelect, ofFileMustExist];

    if dlg.Execute then
    begin
      var Arquivo: string;
      for Arquivo in dlg.Files do
        ImportarXMLNFe(Arquivo);

      AtualizarGridNFe;
      AtualizarTotaisNFe;
    end;
  finally
    dlg.Free;
  end;
end;

// ─── ImportarXMLNFe — lê tags da NF-e e preenche um TOSNFeModel ──────────────
procedure TEmissaoOS.ImportarXMLNFe(const AArquivo: string);
var
  XML  : IXMLDocument;
  Model: TOSNFeModel;

  // Busca recursiva ignorando namespace — resolve o problema do xmlns
  function BuscarNo(ANode: IXMLNode; const ATag: string): IXMLNode;
  var
    I   : Integer;
    Nome: string;
    Sub : IXMLNode;
  begin
    Result := nil;
    if ANode = nil then Exit;

    for I := 0 to ANode.ChildNodes.Count - 1 do
    begin
      Sub  := ANode.ChildNodes[I];
      // LocalName remove o prefixo de namespace (ex: "nfe:ide" → "ide")
      Nome := Sub.LocalName;
      if SameText(Nome, ATag) then
      begin
        Result := Sub;
        Exit;
      end;
      // Busca nos filhos recursivamente
      Result := BuscarNo(Sub, ATag);
      if Result <> nil then Exit;
    end;
  end;

  function NodeTxt(ANode: IXMLNode; const ATag: string): string;
  var N: IXMLNode;
  begin
    Result := '';
    N := BuscarNo(ANode, ATag);
    if N <> nil then Result := Trim(N.Text);
  end;

  function ToFloat(const S: string): Double;
  begin
    // TFormatSettings.Invariant garante que '.' é sempre o separador decimal
    // independente do locale do Windows — essencial para XML que sempre usa '.'
    Result := StrToFloatDef(S, 0, TFormatSettings.Invariant);
  end;

begin
  try
    XML := TXMLDocument.Create(nil);
    XML.Options  := XML.Options + [doNodeAutoCreate];
    XML.LoadFromFile(AArquivo);
    XML.Active   := True;

    Model := TOSNFeModel.Novo;

    var Root   := XML.DocumentElement; // nfeProc ou NFe
    var infNFe := BuscarNo(Root, 'infNFe');

    if infNFe = nil then
    begin
      TNotificacao.Erro(Self, 'XML inválido: nó infNFe não encontrado.');
      Exit;
    end;

    // ── Identificação ──────────────────────────────────────────────────────
    Model.NumeroNFe := NodeTxt(infNFe, 'nNF');
    Model.Serie     := NodeTxt(infNFe, 'serie');

    // Chave — atributo Id do infNFe
    var sChave := '';
    if infNFe.HasAttribute('Id') then
      sChave := infNFe.Attributes['Id'];
    Model.ChaveNFe := StringReplace(sChave, 'NFe', '', [rfReplaceAll]);

    // ── Emitente ───────────────────────────────────────────────────────────
    var emit := BuscarNo(infNFe, 'emit');
    if emit <> nil then
      Model.Emitente := NodeTxt(emit, 'xNome');

    // ── Valor total dos produtos (total/vNFTot) ───────────────────────────
    var total   := BuscarNo(infNFe, 'total');
    if total <> nil then
      Model.ValorMercadoria := ToFloat(NodeTxt(total, 'vNFTot'));

    // ── Transporte: vol/pesoB e vol/qVol ──────────────────────────────────
    // No XML: transp → vol → pesoB / qVol
    var transp := BuscarNo(infNFe, 'transp');
    var vol    := BuscarNo(transp,  'vol');
    if vol <> nil then
    begin
      Model.Peso       := ToFloat(NodeTxt(vol, 'pesoB'));
      Model.Quantidade := Round(ToFloat(NodeTxt(vol, 'qVol')));
    end;

    Model.IDOS := OSID;
    FNFes.Add(Model);

    TNotificacao.Sucesso(Self,
      'NF-e ' + Model.NumeroNFe + ' importada: ' +
      'Peso=' + FormatFloat('0.000', Model.Peso) + ' kg | ' +
      'Qtd=' + Model.Quantidade.ToString + ' | ' +
      'Valor=R$ ' + FormatFloat('0.00', Model.ValorMercadoria));

    AtualizarGridNFe;
    AtualizarTotaisNFe;

  except
    on E: Exception do
      TNotificacao.Erro(Self, 'Erro ao importar XML: ' + E.Message);
  end;
end;

// ─── ColetarCampos — tela → Model ────────────────────────────────────────────
function TEmissaoOS.ColetarCampos: TOrdemServicoModel;
var
  IDTom: Integer;
begin
  Result               := TOrdemServicoModel.Novo;
  Result.ID            := OSID;
  Result.Data          := dtpData.Date;
  Result.Status        := OS_STATUS_ABERTA;
  Result.IDRemetente   := IDDaCombo(cboRemetente, FIDsClientes);
  Result.IDDestinatario:= IDDaCombo(cboDest,      FIDsClientes);
  Result.IDFrota       := IDDaCombo(cboFrota,     FIDsFrota);
  Result.IDRota        := IDDaCombo(cboRota,      FIDsRotas);
  Result.TipoTomador   := cboTipoTomador.ItemIndex;
  Result.CFOP          := Trim(edtCFOP.Text);
  Result.KM            := StrToFloatDef(
                           StringReplace(edtKM.Text, ',', '.', [rfReplaceAll]), 0);
  Result.Seguro        := StrToFloatDef(
                           StringReplace(edtSeguro.Text, ',', '.', [rfReplaceAll]), 0);
  Result.BaseICMS      := StrToFloatDef(
                           StringReplace(edtBaseICMS.Text, ',', '.', [rfReplaceAll]), 0);
  Result.Aliquota      := StrToFloatDef(
                           StringReplace(edtAliquota.Text, ',', '.', [rfReplaceAll]), 0);
  Result.ValorICMS     := StrToFloatDef(
                           StringReplace(edtValICMS.Text, 'R$ ', '', [rfReplaceAll])
                           .Replace(',', '.'), 0);
  Result.ValorFrete    := StrToFloatDef(
                           StringReplace(edtFrete.Text, 'R$ ', '', [rfReplaceAll])
                           .Replace(',', '.'), 0);
  Result.Observacoes   := memoObs.Text;

  // Totais das NF-es
  Result.PesoTotal       := StrToFloatDef(edtPeso.Text, 0);
  Result.QuantidadeTotal := StrToIntDef(edtQtd.Text, 0);
  Result.ValorMercadoria := StrToFloatDef(
                             StringReplace(edtValNF.Text, ',', '.', [rfReplaceAll]), 0);

  // Tomador: Remetente, Destinatário ou Terceiro
  case Result.TipoTomador of
    OS_TOMADOR_REMETENTE   : IDTom := Result.IDRemetente;
    OS_TOMADOR_DESTINATARIO: IDTom := Result.IDDestinatario;
    OS_TOMADOR_TERCEIRO    : IDTom := IDDaCombo(cboTomador, FIDsClientes);
  else IDTom := 0;
  end;
  Result.IDTomador := IDTom;
end;

// ─── Cálculos de ICMS ─────────────────────────────────────────────────────────
procedure TEmissaoOS.edtBaseICMSChange(Sender: TObject);
begin
  FBaseICMSAutoPreenchida := False; // usuário editou — não sobrescreve mais
  RecalcularICMS;
end;

procedure TEmissaoOS.edtAliquotaChange(Sender: TObject);
begin
  RecalcularICMS;
end;

// ─── Salvar ───────────────────────────────────────────────────────────────────
procedure TEmissaoOS.btnSalvarClick(Sender: TObject);
var
  AOS   : TOrdemServicoModel;
  Numero: Integer;
begin
  AOS := ColetarCampos;
  try
    Numero := FService.Salvar(AOS, FNFes);
    OSID   := AOS.ID;
    lblNumOS.Caption := 'OS Nº ' + Numero.ToString.PadLeft(4, '0');
    TNotificacao.Sucesso(Self, 'OS salva com sucesso!');
    ModalResult := mrOk;
  except
    on E: Exception do
      TNotificacao.Erro(Self, E.Message);
  end;
end;

// ─── Emitir ───────────────────────────────────────────────────────────────────
procedure TEmissaoOS.btnEmitirClick(Sender: TObject);
begin
  if OSID = 0 then
  begin
    TNotificacao.Aviso(Self, 'Salve a OS antes de emitir.');
    Exit;
  end;

  if MessageDlg('Emitir a OS?' + sLineBreak +
                'Após emitida, não poderá ser editada.',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FService.Emitir(OSID);
      AtualizarStatusVisual(OS_STATUS_EMITIDA);
      DefinirEdicao(False);
      TNotificacao.Sucesso(Self, 'OS emitida com sucesso!');
      ModalResult := mrOk;
    except
      on E: Exception do TNotificacao.Erro(Self, E.Message);
    end;
  end;
end;

// ─── Cancelar OS ──────────────────────────────────────────────────────────────
procedure TEmissaoOS.btnCancelarOSClick(Sender: TObject);
begin
  if OSID = 0 then Exit;

  if MessageDlg('Cancelar esta OS?' + sLineBreak +
                'Esta ação não pode ser desfeita.',
                mtWarning, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FService.Cancelar(OSID);
      AtualizarStatusVisual(OS_STATUS_CANCELADA);
      DefinirEdicao(False);
      TNotificacao.Sucesso(Self, 'OS cancelada.');
      ModalResult := mrOk;
    except
      on E: Exception do TNotificacao.Erro(Self, E.Message);
    end;
  end;
end;

procedure TEmissaoOS.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TEmissaoOS.edtValorKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key.IsDigit or (Key = ',') or (Key = '.') or (Key = #8)) then
    Key := #0;
end;

end.
