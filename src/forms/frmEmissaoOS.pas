unit frmEmissaoOS;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.StrUtils, System.Math, System.Character,
  System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.ValEdit, Vcl.Dialogs,
  uOSModel, uOSNFeModel, uOSService,
  uRotaModel, uNotificacao, frmRelatorioOS;

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
    btnVisualizar: TButton;
    btnImprimir: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnEmitirClick(Sender: TObject);
    procedure btnCancelarOSClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
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
    procedure PreencherCombo(ACbo: TComboBox; AIDList: TList<Integer>;
                             AItens: TList<TLookupItem>);
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
  Itens: TList<TLookupItem>;
begin
  // Clientes — mesma lista alimenta remetente, destinatário e tomador
  Itens := FService.ListarClientesLookup;
  try
    FIDsClientes.Clear;
    PreencherCombo(cboRemetente, FIDsClientes, Itens);
    PreencherCombo(cboDest,      nil,          Itens);
    PreencherCombo(cboTomador,   nil,          Itens);
  finally
    Itens.Free;
  end;

  // Frota
  Itens := FService.ListarFrotaLookup;
  try
    FIDsFrota.Clear;
    PreencherCombo(cboFrota, FIDsFrota, Itens);
  finally
    Itens.Free;
  end;

  // Rotas
  Itens := FService.ListarRotasLookup;
  try
    FIDsRotas.Clear;
    PreencherCombo(cboRota, FIDsRotas, Itens);
  finally
    Itens.Free;
  end;
end;

// ─── Utilitários de ComboBox + Lista paralela ─────────────────────────────────
procedure TEmissaoOS.PreencherCombo(ACbo: TComboBox; AIDList: TList<Integer>;
  AItens: TList<TLookupItem>);
var
  Item: TLookupItem;
begin
  ACbo.Items.Clear;
  ACbo.Items.Add('— Selecione —');
  if Assigned(AIDList) then
    AIDList.Add(0);

  for Item in AItens do
  begin
    ACbo.Items.Add(Item.Descricao);
    if Assigned(AIDList) then
      AIDList.Add(Item.ID);
  end;

  ACbo.ItemIndex := 0;
end;

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
  if FService.ExigeTomadorTerceiro(AOS.TipoTomador) then
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
  AOS: TOrdemServicoModel;
begin
  AOS := TOrdemServicoModel.Novo;
  FService.RecalcularTotaisNFe(AOS, FNFes);

  edtPeso.Text  := FormatFloat('0.000', AOS.PesoTotal);
  edtQtd.Text   := AOS.QuantidadeTotal.ToString;
  edtValNF.Text := FormatFloat('0.00', AOS.ValorMercadoria);

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
  if not FFreteManual then Exit;

  edtBaseICMS.Text        := edtFrete.Text;
  FBaseICMSAutoPreenchida := False;
  RecalcularICMS;
end;

// ─── RecalcularFrete — usa Service com dados atuais da tela ──────────────────
procedure TEmissaoOS.RecalcularFrete;
var
  Frete, Base: Double;
begin
  if not FService.CalcularFreteAutomatico(
       FRotaAtual,
       StrToFloatDef(StringReplace(edtPeso.Text, ',', '.', [rfReplaceAll]), 0),
       StrToIntDef(edtQtd.Text, 0),
       StrToFloatDef(StringReplace(edtValNF.Text, ',', '.', [rfReplaceAll]), 0),
       StrToFloatDef(StringReplace(edtKM.Text,    ',', '.', [rfReplaceAll]), 0),
       FFreteManual, Frete) then
    Exit;

  edtFrete.Text := FormatFloat('0.00', Frete);

  if FService.CalcularBaseICMSAutomatica(Frete,
       Trim(edtBaseICMS.Text) <> '', FBaseICMSAutoPreenchida, Base) then
  begin
    edtBaseICMS.Text        := FormatFloat('0.00', Base);
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
  IDRota: Integer;
begin
  IDRota     := IDDaCombo(cboRota, FIDsRotas);
  FRotaAtual := FService.BuscarRota(IDRota);

  if IDRota = 0 then
  begin
    FBaseICMSAutoPreenchida := True; // reseta ao trocar rota
    AtualizarVisibilidadeCampos;
    Exit;
  end;

  FFreteManual            := False;
  FBaseICMSAutoPreenchida := True;
  AtualizarVisibilidadeCampos;
  RecalcularFrete;
end;

procedure TEmissaoOS.AtualizarVisibilidadeCampos;
begin
  lblKM.Visible := FService.RotaExigeKM(FRotaAtual);
  edtKM.Visible := FService.RotaExigeKM(FRotaAtual);

  cboTomador.Visible := FService.ExigeTomadorTerceiro(cboTipoTomador.ItemIndex);
end;

procedure TEmissaoOS.cboTipoTomadorChange(Sender: TObject);
begin
  AtualizarVisibilidadeCampos;
end;

procedure TEmissaoOS.AtualizarStatusVisual(const AStatus: string);
begin
  lblStatus.Caption := AStatus;
  case IndexStr(AStatus,
    [OS_STATUS_ABERTA, OS_STATUS_EMITIDA, OS_STATUS_CANCELADA]) of
    0: lblStatus.Font.Color := $008000;
    1: lblStatus.Font.Color := $0050CC;
    2: lblStatus.Font.Color := $2020CC;
  end;
end;

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

procedure TEmissaoOS.btnAddNFeClick(Sender: TObject);
var
  NFe: TOSNFeModel;
begin
  NFe      := TOSNFeModel.Novo;
  NFe.IDOS := OSID;
  FNFes.Add(NFe);
  AtualizarGridNFe;
  gridNFe.Row := gridNFe.RowCount - 1;
  gridNFe.Col := 0;
end;

procedure TEmissaoOS.btnRemNFeClick(Sender: TObject);
var
  Linha: Integer;
begin
  Linha := gridNFe.Row - 1;
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

procedure TEmissaoOS.gridNFeSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := ARow > 0;
end;

procedure TEmissaoOS.gridNFeSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
var
  Idx: Integer;
  NFe: TOSNFeModel;
begin
  Idx := ARow - 1;
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

  FNFes[Idx] := NFe;

  if ACol in [4, 5, 6] then
    AtualizarTotaisNFe;
end;

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

// ─── ImportarXMLNFe — delega a leitura ao Service e exibe o resultado ────────
procedure TEmissaoOS.ImportarXMLNFe(const AArquivo: string);
var
  Model: TOSNFeModel;
begin
  try
    Model := FService.ImportarNFeDeXML(AArquivo, OSID);
    FNFes.Add(Model);

    TNotificacao.Sucesso(Self,
      'NF-e ' + Model.NumeroNFe + ' importada: ' +
      'Peso=' + FormatFloat('0.000', Model.Peso) + ' kg | ' +
      'Qtd=' + Model.Quantidade.ToString + ' | ' +
      'Valor=R$ ' + FormatFloat('0.00', Model.ValorMercadoria));

    AtualizarGridNFe;
    AtualizarTotaisNFe;

  except
    on E: EXMLNFeInvalido do
      TNotificacao.Erro(Self, E.Message);
    on E: Exception do
      TNotificacao.Erro(Self, 'Erro ao importar XML: ' + E.Message);
  end;
end;

function TEmissaoOS.ColetarCampos: TOrdemServicoModel;
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
  Result.IDTomador := FService.ResolverTomador(
    Result, IDDaCombo(cboTomador, FIDsClientes));
end;

procedure TEmissaoOS.edtBaseICMSChange(Sender: TObject);
begin
  FBaseICMSAutoPreenchida := False;
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

procedure TEmissaoOS.btnImprimirClick(Sender: TObject);
var
  Rel     : TRelatorioOS;
  LogoPath: string;
begin
  if OSID = 0 then
  begin
    TNotificacao.Aviso(Self, 'Salve a OS antes de imprimir.');
    Exit;
  end;

  // Ajuste o caminho para sua logo
  LogoPath := ExtractFilePath(Application.ExeName) + 'logo.png';

  Rel := TRelatorioOS.Create(Self);
  try
    Rel.Imprimir(OSID, LogoPath);
  finally
    Rel.Free;
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
