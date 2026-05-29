unit frmCadFrota;

interface

uses
  Winapi.Windows, System.SysUtils, System.StrUtils, System.Character, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Dialogs, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  uFrotaModel, uFrotaService, uFormatacao, uNotificacao;

type
  TCadFrota = class(TForm)
    grpDados      : TGroupBox;
    lblPlaca      : TLabel;
    edtPlaca      : TEdit;
    lblDescricao  : TLabel;
    edtDescricao  : TEdit;
    lblTipo       : TLabel;
    cboTipo       : TComboBox;
    grpProprietario : TGroupBox;
    lblProprietario : TLabel;
    cboProprietario : TComboBox;
    qryProprietarios: TFDQuery;
    pnlBotoes   : TPanel;
    btnSalvar   : TButton;
    btnCancelar : TButton;
    dsProprietarios: TDataSource;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtPlacaExit(Sender: TObject);
    procedure edtPlacaKeyPress(Sender: TObject; var Key: Char);

  public
    FrotaID: Integer;

  private
    FService          : TFrotaService;
    FIDProprietarioSel: Integer;
    procedure CarregarProprietarios;
    procedure CarregarFrota;
    procedure PreencherCampos(const AFrota: TFrotaModel);
    function  ColetarCampos: TFrotaModel;
    procedure SelecionarProprietario(const AID: Integer);
  end;

var
  CadFrota: TCadFrota;

implementation

{$R *.dfm}

procedure TCadFrota.FormCreate(Sender: TObject);
begin
  FService           := TFrotaService.Create;
  FIDProprietarioSel := 0;

  cboTipo.Items.Clear;
  cboTipo.Items.Add('Próprio');
  cboTipo.Items.Add('Terceiro');
  cboTipo.ItemIndex := 0;

  KeyPreview         := True;
  btnSalvar.Default  := True;
  btnCancelar.Cancel := True;

  CarregarProprietarios;
end;

procedure TCadFrota.FormShow(Sender: TObject);
begin
  if FrotaID > 0 then
    CarregarFrota
  else
    edtPlaca.SetFocus;
end;

procedure TCadFrota.CarregarProprietarios;
begin
  FService.CarregarProprietarios(qryProprietarios);

  cboProprietario.Items.Clear;
  cboProprietario.Items.Add('— Nenhum —');

  qryProprietarios.First;
  while not qryProprietarios.Eof do
  begin
    cboProprietario.Items.Add(
      qryProprietarios.FieldByName('RAZAO_SOCIAL').AsString);
    qryProprietarios.Next;
  end;

  cboProprietario.ItemIndex := 0;
end;

procedure TCadFrota.SelecionarProprietario(const AID: Integer);
var
  I: Integer;
begin
  FIDProprietarioSel := 0;
  cboProprietario.ItemIndex := 0;

  if AID = 0 then Exit;

  qryProprietarios.First;
  I := 1;
  while not qryProprietarios.Eof do
  begin
    if qryProprietarios.FieldByName('ID').AsInteger = AID then
    begin
      cboProprietario.ItemIndex := I;
      FIDProprietarioSel        := AID;
      Break;
    end;
    qryProprietarios.Next;
    Inc(I);
  end;
end;

procedure TCadFrota.CarregarFrota;
var
  Frota: TFrotaModel;
begin
  Frota := FService.BuscarPorID(FrotaID);
  if Frota.ID > 0 then
    PreencherCampos(Frota);
end;

procedure TCadFrota.PreencherCampos(const AFrota: TFrotaModel);
begin
  edtPlaca.Text    := TFormatacao.FormatarPlaca(AFrota.Placa);
  edtDescricao.Text:= AFrota.Descricao;

  if AFrota.Tipo = 'T' then
    cboTipo.ItemIndex := 1
  else
    cboTipo.ItemIndex := 0;

  SelecionarProprietario(AFrota.IDProprietario);
  edtDescricao.SetFocus;
end;

function TCadFrota.ColetarCampos: TFrotaModel;
var
  I: Integer;
begin
  Result    := TFrotaModel.Novo;
  Result.ID := FrotaID;

  Result.Placa    := edtPlaca.Text;
  Result.Descricao:= Trim(edtDescricao.Text);
  Result.Tipo     := IfThen(cboTipo.ItemIndex = 1, 'T', 'P');


  FIDProprietarioSel := 0;
  I := cboProprietario.ItemIndex;
  if I > 0 then
  begin
    qryProprietarios.First;
    qryProprietarios.MoveBy(I - 1);
    FIDProprietarioSel := qryProprietarios.FieldByName('ID').AsInteger;
  end;

  Result.IDProprietario := FIDProprietarioSel;
end;

procedure TCadFrota.edtPlacaExit(Sender: TObject);
begin
  if edtPlaca.Text <> '' then
    edtPlaca.Text := TFormatacao.FormatarPlaca(edtPlaca.Text);
end;

procedure TCadFrota.edtPlacaKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key.IsLetterOrDigit or (Key = '-') or (Key = #8)) then
    Key := #0;
end;

procedure TCadFrota.btnSalvarClick(Sender: TObject);
var
  Frota: TFrotaModel;
begin
  Frota := ColetarCampos;
  try
    FService.Salvar(Frota);
    ModalResult := mrOk;
  except
    on E: Exception do
      TNotificacao.Erro(Self, E.Message);
  end;
end;

procedure TCadFrota.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
