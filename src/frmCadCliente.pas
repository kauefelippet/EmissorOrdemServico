unit frmCadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Character, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, System.Net.HttpClient, System.JSON,
  FireDAC.Comp.Client, dmConexao;

type
  TCadCliente = class(TForm)
    grpDados: TGroupBox;
    Label1: TLabel;
    edtDocumento: TEdit;
    lblTipoDoc: TLabel;
    Label2: TLabel;
    edtRazaoSocial: TEdit;
    edtNomeFantasia: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtIERG: TEdit;
    grpEndereco: TGroupBox;
    Label5: TLabel;
    edtCEP: TEdit;
    btnBuscarCEP: TButton;
    Label6: TLabel;
    edtLogradouro: TEdit;
    Label7: TLabel;
    edtNumero: TEdit;
    Label8: TLabel;
    edtBairro: TEdit;
    Label9: TLabel;
    edtCidade: TEdit;
    Label10: TLabel;
    cboUF: TComboBox;
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
  private
    procedure PreencherUFs;
    procedure CarregarCliente;
    procedure BuscarCEP;
    function ApenasNumeros(const ATexto: string): string;
    function FormatarDocumento(const ANumeros: string): string;
    function ValidarCampos: Boolean;
  public
    ClienteID: Integer;
  end;

var
  CadCliente: TCadCliente;

implementation

{$R *.dfm}

// Executa ao abrir o form
procedure TCadCliente.FormCreate(Sender: TObject);
begin
  PreencherUFs;
  lblTipoDoc.Caption := '';
  lblTipoDoc.Font.Color := clGray;
end;

// Executa ao exibir o form
procedure TCadCliente.FormShow(Sender: TObject);
begin
  if ClienteID > 0 then
    CarregarCliente;
end;

// Preenche o campo das UFs
procedure TCadCliente.PreencherUFs;
begin
  cboUF.Items.Clear;
  cboUF.Items.Add('');
  cboUF.Items.AddStrings(['AC','AL','AP','AM','BA','CE','DF','ES','GO',
                          'MA','MT','MS','MG','PA','PB','PR','PE','PI',
                          'RJ','RN','RS','RO','RR','SC','SP','SE','TO']);
  cboUF.ItemIndex := 0;
end;

// Carrega dados do cadastro de Cliente para edicao
procedure TCadCliente.CarregarCliente;
var
  qry: TFDQuery;
begin
  qry := TFDquery.Create(nil);

  try
    qry.Connection := Conexao.Conexao;
    qry.SQL.Text := 'SELECT * FROM CLIENTES WHERE ID = :pID';
    qry.ParamByName('pID').AsInteger := ClienteID;
    qry.Open;

    if not qry.IsEmpty then
    begin
      edtDocumento.Text   := qry.FieldByName('DOCUMENTO').AsString;
      edtRazaoSocial.Text := qry.FieldByName('RAZAO_SOCIAL').AsString;
      edtNomeFantasia.Text:= qry.FieldByName('NOME_FANTASIA').AsString;
      edtIERG.Text        := qry.FieldByName('IE_RG').AsString;
      edtCEP.Text         := qry.FieldByName('CEP').AsString;
      edtLogradouro.Text  := qry.FieldByName('LOGRADOURO').AsString;
      edtNumero.Text      := qry.FieldByName('NUMERO').AsString;
      edtBairro.Text      := qry.FieldByName('BAIRRO').AsString;
      edtCidade.Text      := qry.FieldByName('CIDADE').AsString;
      cboUF.Text          := qry.FieldByName('UF').AsString;

      edtDocumentoChange(nil);
    end;
  finally
    qry.Free;
  end;
end;

// Remove caracteres que nao sejam digitos
function TCadCliente.ApenasNumeros(const ATexto: string): string;
var
  C: Char;
begin
  Result := '';
  for C in ATexto do
    if C in ['0'..'9'] then
      Result := Result + C;
end;

// Formata CPF e CNPJ
function TCadCliente.FormatarDocumento(const ANumeros: string): string;
begin
  case Length(ANumeros) of
    11: // CPF 000.000.000-00
      Result := Copy(ANumeros,1,3) + '.' +
                Copy(ANumeros,4,3) + '.' +
                Copy(ANumeros,7,3) + '-' +
                Copy(ANumeros,10,2);
    14: // CNPJ 00.000.000/0000-00
      Result := Copy(ANumeros,1,2)  + '.' +
                Copy(ANumeros,3,3)  + '.' +
                Copy(ANumeros,6,3)  + '/' +
                Copy(ANumeros,9,4)  + '-' +
                Copy(ANumeros,13,2);
  else
    Result := ANumeros;
  end;
end;

// Detecta se foi digitado CPF ou CNPJ
procedure TCadCliente.edtDocumentoChange(Sender: TObject);
var
  Digitos: string;
begin
  Digitos := ApenasNumeros(edtDocumento.Text);

  case Length(Digitos) of
    11:
    begin
      lblTipoDoc.Caption    := '✔ CPF';
      lblTipoDoc.Font.Color := clGreen;
    end;
    14:
    begin
      lblTipoDoc.Caption    := '✔ CNPJ';
      lblTipoDoc.Font.Color := clGreen;
    end;
    0:  lblTipoDoc.Caption := '';
  else
    begin
      lblTipoDoc.Caption    := Length(Digitos).ToString + ' dígitos';
      lblTipoDoc.Font.Color := clGray;
    end;
  end;
end;

// Aceita apenas numeros e backspace no campo CEP
procedure TCadCliente.edtCEPKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

// Consulta do CEP via API ViaCEP
procedure TCadCliente.BuscarCEP;
var
  Http: THTTPClient;
  Response: IHTTPResponse;
  JSON: TJSONObject;
  CEP: string;
begin
  CEP := ApenasNumeros(edtCEP.Text);

  if Length(CEP) <> 8 then
  begin
    ShowMessage('Digite um CEP com 8 dígitos.');
    edtCEP.SetFocus;
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  Http := THTTPClient.Create;
  try
    try
      Response := Http.Get('https://viacep.com.br/ws/' + CEP + '/json/');

      if Response.StatusCode = 200 then
      begin
        JSON := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
        try
          if (JSON = nil) or (JSON.GetValue('erro') <> nil) then
          begin
            ShowMessage('CEP ' + edtCep.Text + ' não encontrado.');
            Exit;
          end;

          edtLogradouro.Text := JSON.GetValue<string>('logradouro', '');
          edtBairro.Text     := JSON.GetValue<string>('bairro', '');
          edtCidade.Text     := JSON.GetValue<string>('localidade', '');
          cboUF.Text         := JSON.GetValue<string>('uf', '');

          edtNumero.SetFocus;
        finally
          JSON.Free;
        end;
      end
      else
        ShowMessage('Erro ao consultar o CEP ' + edtCep.Text + '. Verifique sua conexão.');

    except
      ShowMessage('Não foi possível consultar o CEP ' + edtCep.Text + '.'#13#10 +
                  'Verifique sua conexão com a internet.');
    end;
  finally
    Http.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TCadCliente.btnBuscarCEPClick(Sender: TObject);
begin
  BuscarCEP;
end;

// Validar campos
function TCadCliente.ValidarCampos: Boolean;
var
  Digitos: string;
begin
  Result := False;

  if Trim(edtDocumento.Text) = '' then
  begin
    ShowMessage('Informe o CPF ou CNPJ.');
    edtDocumento.SetFocus;
    Exit;
  end;

  Digitos := ApenasNumeros(edtDocumento.Text);
  if not (Length(Digitos) in [11, 14]) then
  begin
    ShowMessage('Documento inválido.'#13#10 +
                'CPF deve ter 11 dígitos e CNPJ 14 dígitos.');
    edtDocumento.SetFocus;
    Exit;
  end;

  if Trim(edtRazaoSocial.Text) = '' then
  begin
    ShowMessage('Razão Social é obrigatória.');
    edtRazaoSocial.SetFocus;
    Exit;
  end;

  Result := True;
end;

// Botao Salvar
procedure TCadCliente.btnSalvarClick(Sender: TObject);
var
  qry: TFDQuery;
  DocFormatado: string;
begin
  if not ValidarCampos then Exit;

  // Salva o documento formatado
  DocFormatado := FormatarDocumento(ApenasNumeros(edtDocumento.Text));

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conexao.Conexao;

    if ClienteID = 0 then
    begin
      // ── INSERT ──────────────────────────────────────────────────────────────
      qry.SQL.Text :=
        'INSERT INTO CLIENTES ' +
        '  (DOCUMENTO, RAZAO_SOCIAL, NOME_FANTASIA, IE_RG, ' +
        '   CEP, LOGRADOURO, NUMERO, BAIRRO, CIDADE, UF) ' +
        'VALUES ' +
        '  (:pDoc, :pRazao, :pFantasia, :pIE, ' +
        '   :pCEP, :pLogradouro, :pNumero, :pBairro, :pCidade, :pUF)';
    end
    else
    begin
      // ── UPDATE ──────────────────────────────────────────────────────────────
      qry.SQL.Text :=
        'UPDATE CLIENTES SET ' +
        '  DOCUMENTO    = :pDoc, ' +
        '  RAZAO_SOCIAL = :pRazao, ' +
        '  NOME_FANTASIA= :pFantasia, ' +
        '  IE_RG        = :pIE, ' +
        '  CEP          = :pCEP, ' +
        '  LOGRADOURO   = :pLogradouro, ' +
        '  NUMERO       = :pNumero, ' +
        '  BAIRRO       = :pBairro, ' +
        '  CIDADE       = :pCidade, ' +
        '  UF           = :pUF, ' +
        '  UPDATED_AT   = :pUpdated ' +
        'WHERE ID = :pID';

      qry.ParamByName('pUpdated').AsDateTime := Now;
      qry.ParamByName('pID').AsInteger       := ClienteID;
    end;

    // Parâmetros
    qry.ParamByName('pDoc').AsString       := DocFormatado;
    qry.ParamByName('pRazao').AsString     := Trim(edtRazaoSocial.Text);
    qry.ParamByName('pFantasia').AsString  := Trim(edtNomeFantasia.Text);
    qry.ParamByName('pIE').AsString        := Trim(edtIERG.Text);
    qry.ParamByName('pCEP').AsString       := ApenasNumeros(edtCEP.Text);
    qry.ParamByName('pLogradouro').AsString:= Trim(edtLogradouro.Text);
    qry.ParamByName('pNumero').AsString    := Trim(edtNumero.Text);
    qry.ParamByName('pBairro').AsString    := Trim(edtBairro.Text);
    qry.ParamByName('pCidade').AsString    := Trim(edtCidade.Text);
    qry.ParamByName('pUF').AsString        := cboUF.Text;

    try
      qry.ExecSQL;
      ShowMessage('Cliente salvo com sucesso!');
      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMessage('Erro ao salvar:'#13#10 + E.Message);
    end;

  finally
    qry.Free;
  end;
end;

procedure TCadCliente.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
