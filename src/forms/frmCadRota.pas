unit frmCadRota;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.StrUtils, System.Character,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Dialogs, Vcl.Mask,
  uRotaModel, uRotaService, uNotificacao;

type
  TCadRota = class(TForm)
    grpDados: TGroupBox;

    lblDescricao: TLabel;
    edtDescricao: TEdit;

    lblTipo: TLabel;
    cboTipo: TComboBox;

    lblValorBase: TLabel;
    edtValorBase: TEdit;

    lblMultiplicador: TLabel;
    edtMultiplicador: TEdit;

    lblDicaCalculo: TLabel;

    pnlBotoes: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);

    procedure cboTipoChange(Sender: TObject);

    procedure edtValorKeyPress(Sender: TObject; var Key: Char);

  public
    RotaID: Integer;

  private
    FService: TRotaService;

    procedure PreencherTipos;
    procedure AtualizarCamposParaTipo;
    procedure CarregarRota;
    procedure PreencherCampos(const ARota: TRotaModel);

    function ColetarCampos: TRotaModel;
    function TipoSelecionado: string;
  end;

var
  CadRota: TCadRota;

implementation

{$R *.dfm}

procedure TCadRota.FormCreate(Sender: TObject);
begin
  FService := TRotaService.Create;

  PreencherTipos;

  KeyPreview         := True;
  btnSalvar.Default  := True;
  btnCancelar.Cancel := True;

  edtValorBase.OnKeyPress     := edtValorKeyPress;
  edtMultiplicador.OnKeyPress := edtValorKeyPress;

  AtualizarCamposParaTipo;
end;

procedure TCadRota.FormShow(Sender: TObject);
begin
  if RotaID > 0 then
    CarregarRota
  else
    edtDescricao.SetFocus;
end;

procedure TCadRota.FormDestroy(Sender: TObject);
begin
  FService.Free;
end;


procedure TCadRota.PreencherTipos;
begin
  cboTipo.Items.Clear;
  cboTipo.Items.Add('Fixo');
  cboTipo.Items.Add('Por KM');
  cboTipo.Items.Add('Por Peso (NF-e)');
  cboTipo.Items.Add('Por Volume (NF-e)');
  cboTipo.Items.Add('Por Valor (NF-e)');
  cboTipo.ItemIndex := 0;
end;

function TCadRota.TipoSelecionado: string;
begin
  case cboTipo.ItemIndex of
    0: Result := TIPO_FIXO;
    1: Result := TIPO_KM;
    2: Result := TIPO_PESO;
    3: Result := TIPO_VOLUME;
    4: Result := TIPO_VALOR_NF;
  else Result := TIPO_FIXO;
  end;
end;

procedure TCadRota.AtualizarCamposParaTipo;
var
  Rota: TRotaModel;
begin
  Rota.TipoCalculo := TipoSelecionado;

  edtMultiplicador.Enabled   := Rota.UsaMultiplicador;
  lblMultiplicador.Enabled   := Rota.UsaMultiplicador;
  lblMultiplicador.Caption   := Rota.LabelMultiplicador;

  if not Rota.UsaMultiplicador then
    edtMultiplicador.Text := '';

  case cboTipo.ItemIndex of
    0: lblDicaCalculo.Caption := 'Frete = Valor Base (fixo por rota)';
    1: lblDicaCalculo.Caption := 'Frete = KM informado na OS × Multiplicador';
    2: lblDicaCalculo.Caption := 'Frete = Peso bruto da NF-e × Multiplicador';
    3: lblDicaCalculo.Caption := 'Frete = Qtd./Volume da NF-e × Multiplicador';
    4: lblDicaCalculo.Caption := 'Frete = Valor da NF-e × Multiplicador (%)';
  end;

  if Rota.UsaMultiplicador then
    lblValorBase.Caption := 'Valor Base adicional (R$) — opcional'
  else
    lblValorBase.Caption := 'Valor Base (R$) *';
end;

procedure TCadRota.cboTipoChange(Sender: TObject);
begin
  AtualizarCamposParaTipo;
end;

procedure TCadRota.edtValorKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key.IsDigit or (Key = ',') or (Key = '.') or (Key = #8)) then
    Key := #0;
end;

procedure TCadRota.CarregarRota;
var
  Rota: TRotaModel;
begin
  Rota := FService.BuscarPorID(RotaID);
  if Rota.ID > 0 then
    PreencherCampos(Rota);
end;

procedure TCadRota.PreencherCampos(const ARota: TRotaModel);
var
  Fmt: TFormatSettings;
begin
  Fmt := TFormatSettings.Create('pt-BR');
  Fmt.DecimalSeparator := ',';
  Fmt.ThousandSeparator := '.';

  edtDescricao.Text := ARota.Descricao;

  case IndexStr(ARota.TipoCalculo,
    [TIPO_FIXO, TIPO_KM, TIPO_PESO, TIPO_VOLUME, TIPO_VALOR_NF]) of
    0: cboTipo.ItemIndex := 0;
    1: cboTipo.ItemIndex := 1;
    2: cboTipo.ItemIndex := 2;
    3: cboTipo.ItemIndex := 3;
    4: cboTipo.ItemIndex := 4;
  else cboTipo.ItemIndex := 0;
  end;

  if ARota.ValorBase > 0 then
    edtValorBase.Text := FormatFloat('0.00', ARota.ValorBase, Fmt)
  else
    edtValorBase.Text := '';

  if ARota.Multiplicador > 0 then
    edtMultiplicador.Text := FormatFloat('0.0000', ARota.Multiplicador, Fmt)
  else
    edtMultiplicador.Text := '';

  AtualizarCamposParaTipo;
  edtDescricao.SetFocus;
end;

function TCadRota.ColetarCampos: TRotaModel;
var
  Fmt: TFormatSettings;
begin
  Fmt := TFormatSettings.Create('pt-BR');
  Fmt.DecimalSeparator := ',';
  Fmt.ThousandSeparator := '.';

  Result              := TRotaModel.Novo;
  Result.ID           := RotaID;
  Result.Descricao    := Trim(edtDescricao.Text);
  Result.TipoCalculo  := TipoSelecionado;

  Result.ValorBase := StrToFloatDef(edtValorBase.Text, 0, Fmt);

  if Result.UsaMultiplicador then
    Result.Multiplicador := StrToFloatDef(edtMultiplicador.Text, 0, Fmt)
  else
    Result.Multiplicador := 0;
end;

procedure TCadRota.btnSalvarClick(Sender: TObject);
var
  Rota: TRotaModel;
begin
  Rota := ColetarCampos;
  try
    FService.Salvar(Rota);
    TNotificacao.Sucesso(Self, 'Rota salva com sucesso!');
    ModalResult := mrOk;
  except
    on E: Exception do
      TNotificacao.Erro(Self, E.Message);
  end;
end;

procedure TCadRota.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
