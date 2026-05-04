unit frmCadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.Character, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  System.Net.HttpClient, System.JSON, FireDAC.Comp.Client,
  dmConexao,
  uClienteModel, uClienteService,
  uEnderecoModel, uEnderecoService,
  uFormatacao, uNotificacao;

type
  TCadCliente = class(TForm)
    // Dados Cadastrais
    grpDados: TGroupBox;
    lblCPFCNPJ: TLabel;
    edtDocumento: TEdit;
    lblTipoDoc: TLabel;
    lblRazaoSocial: TLabel;
    edtRazaoSocial: TEdit;
    lblNomeFantasia: TLabel;
    edtNomeFantasia: TEdit;
    lblIERG: TLabel;
    edtIERG: TEdit;
    // Endereço
    grpEndereco: TGroupBox;
    lblCEP: TLabel;
    edtCEP: TEdit;
    btnBuscarCEP: TButton;
    lblLogradouro: TLabel;
    edtLogradouro: TEdit;
    lblNumero: TLabel;
    edtNumero: TEdit;
    lblBairro: TLabel;
    edtBairro: TEdit;
    lblCidade: TLabel;
    edtCidade: TEdit;
    lblUF: TLabel;
    cboUF: TComboBox;
    // Rodapé
    pnlBotoes: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    lblCriadoEm: TLabel;
    lblAtualizadoEm: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnBuscarCEPClick(Sender: TObject);
    procedure edtDocumentoChange(Sender: TObject);
    procedure edtCEPKeyPress(Sender: TObject; var Key: Char);

  public
    ClienteID: Integer; // 0 = novo | >0 = edicao

  private
    FService: TClienteService;
    procedure CarregarCliente;
    procedure PreencherCampos(const ACliente: TClienteModel);
    function  ColetarCampos: TClienteModel;
    procedure AplicarEndereco(AEndereco: TEnderecoModel;
                               AErro: string);
  end;

var
  CadCliente: TCadCliente;

implementation

{$R *.dfm}

procedure TCadCliente.FormCreate(Sender: TObject);
begin
  FService := TClienteService.Create;

  TEnderecoService.PreencherUFs(cboUF);

  lblTipoDoc.Caption    := '';
  lblTipoDoc.Font.Color := clGray;
  lblCriadoEm.Caption   := '';
  lblAtualizadoEm.Caption := '';

  // Atalhos de teclado
  KeyPreview         := True;
  btnSalvar.Default  := True;
  btnCancelar.Cancel := True;
end;

procedure TCadCliente.FormShow(Sender: TObject);
begin
  if ClienteID > 0 then
    CarregarCliente
  else
  begin
    lblCriadoEm.Caption     := '';
    lblAtualizadoEm.Caption := '';
    edtDocumento.SetFocus;
  end;
end;

procedure TCadCliente.CarregarCliente;
var
  Cliente: TClienteModel;
begin
  Cliente := FService.BuscarPorID(ClienteID);
  if Cliente.ID > 0 then
  begin
    PreencherCampos(Cliente);
    edtRazaoSocial.SetFocus;
  end;
end;

// Preenche campos com formatacao para exibicao
procedure TCadCliente.PreencherCampos(const ACliente: TClienteModel);
begin
  edtDocumento.Text    := TFormatacao.FormatarDocumento(ACliente.Documento);
  edtRazaoSocial.Text  := ACliente.RazaoSocial;
  edtNomeFantasia.Text := ACliente.NomeFantasia;
  edtIERG.Text         := ACliente.IERG;
  edtCEP.Text          := TFormatacao.FormatarCEP(ACliente.CEP);
  edtLogradouro.Text   := ACliente.Logradouro;
  edtNumero.Text       := ACliente.Numero;
  edtBairro.Text       := ACliente.Bairro;
  edtCidade.Text       := ACliente.Cidade;
  cboUF.Text           := ACliente.UF;

  edtDocumentoChange(nil);
end;

// Manda campos visuais para Model
function TCadCliente.ColetarCampos: TClienteModel;
begin
  Result              := TClienteModel.Novo;
  Result.ID           := ClienteID;
  Result.Documento    := edtDocumento.Text;
  Result.RazaoSocial  := Trim(edtRazaoSocial.Text);
  Result.NomeFantasia := Trim(edtNomeFantasia.Text);
  Result.IERG         := Trim(edtIERG.Text);
  Result.CEP          := edtCEP.Text;
  Result.Logradouro   := Trim(edtLogradouro.Text);
  Result.Numero       := Trim(edtNumero.Text);
  Result.Bairro       := Trim(edtBairro.Text);
  Result.Cidade       := Trim(edtCidade.Text);
  Result.UF           := cboUF.Text;
end;

// Detecta CPF ou CNPJ enquanto digita
procedure TCadCliente.edtDocumentoChange(Sender: TObject);
var
  Tipo   : string;
  nDigitos: Integer;
begin
  nDigitos := Length(TFormatacao.ApenasNumeros(edtDocumento.Text));
  Tipo     := TFormatacao.TipoDocumento(edtDocumento.Text);

  if Tipo <> '' then
  begin
    lblTipoDoc.Caption    := '✔ ' + Tipo;
    lblTipoDoc.Font.Color := clGreen;
  end
  else if nDigitos = 0 then
    lblTipoDoc.Caption := ''
  else
  begin
    lblTipoDoc.Caption    := nDigitos.ToString + ' dígitos';
    lblTipoDoc.Font.Color := clGray;
  end;
end;

// Só aceita dígitos e Backspace no campo CEP
procedure TCadCliente.edtCEPKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key.IsDigit or (Key = #8)) then
    Key := #0;
end;

// Callback do BuscarCEP
procedure TCadCliente.AplicarEndereco(AEndereco: TEnderecoModel;
                                       AErro: string);
begin
  btnBuscarCEP.Enabled := True;
  btnBuscarCEP.Caption := '🔍';

  if AErro <> '' then
  begin
    TNotificacao.Erro(Self, AErro);
    edtCEP.SetFocus;
    Exit;
  end;

  // Preenche os campos de endereço com o retorno da API
  edtLogradouro.Text := AEndereco.Logradouro;
  edtBairro.Text     := AEndereco.Bairro;
  edtCidade.Text     := AEndereco.Cidade;
  cboUF.Text         := AEndereco.UF;

  edtNumero.SetFocus;
end;

procedure TCadCliente.btnBuscarCEPClick(Sender: TObject);
var
  CEP: string;
begin
  CEP := TFormatacao.ApenasNumeros(edtCEP.Text);

  if Length(CEP) <> 8 then
  begin
    TNotificacao.Info(Self, 'Digite um CEP com 8 dígitos.');
    edtCEP.SetFocus;
    Exit;
  end;

  btnBuscarCEP.Enabled := False;
  btnBuscarCEP.Caption := '...';

  TEnderecoService.BuscarCEP(CEP, AplicarEndereco);
end;

procedure TCadCliente.btnSalvarClick(Sender: TObject);
var
  Cliente: TClienteModel;
begin
  Cliente := ColetarCampos;

  try
    FService.Salvar(Cliente);
    ModalResult := mrOk;
  except
    on E: Exception do
      TNotificacao.Erro(Self, E.Message);
  end;
end;

procedure TCadCliente.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
