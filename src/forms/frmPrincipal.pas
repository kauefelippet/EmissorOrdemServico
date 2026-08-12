unit frmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Graphics, uNotificacao;

type
  TPrincipal = class(TForm)
    mnuPrincipal: TMainMenu;
    // Cadastros
    mnuCadastros   : TMenuItem;
    mnuCadClientes : TMenuItem;
    mnuCadFrota    : TMenuItem;
    mnuCadRotas    : TMenuItem;
    // Movimento
    mnuTransporte   : TMenuItem;
    mnuMovOS       : TMenuItem;
    lblUsuario: TLabel;
    pnlStatus: TPanel;
    lblStatus: TLabel;
    // Configuracoes
    grpConfig: TGroupBox;
    lblDatabase: TLabel;
    edtDatabase: TEdit;
    btnSelDatabase: TButton;
    lblLogo: TLabel;
    edtLogo: TEdit;
    btnSelLogo: TButton;
    btnSalvarConfig: TButton;

    procedure FormCreate(Sender: TObject);
    procedure mnuCadClientesClick(Sender: TObject);
    procedure mnuCadFrotaClick(Sender: TObject);
    procedure mnuCadRotasClick(Sender: TObject);
    procedure mnuMovOSClick(Sender: TObject);
    procedure btnSelDatabaseClick(Sender: TObject);
    procedure btnSelLogoClick(Sender: TObject);
    procedure btnSalvarConfigClick(Sender: TObject);

  private
    procedure AbrirForm(AFormClass: TFormClass);
    procedure CarregarConfig;
  end;

var
  Principal: TPrincipal;

implementation

{$R *.dfm}

uses
  frmClientes,
  frmFrota,
  frmRotas,
  frmOS,
  dmConexao;

procedure TPrincipal.FormCreate(Sender: TObject);
begin
  Caption := 'Sistema para emissão de Ordem de Serviço de Transporte';

  pnlStatus.Align      := alBottom;
  pnlStatus.Height     := 28;
  pnlStatus.BevelOuter := bvNone;
  pnlStatus.Color      := $00F0F0F0;
  pnlStatus.Caption    := '';

  lblStatus.Caption    := 'Pronto';
  lblStatus.Left       := 8;
  lblStatus.Top        := 6;

  lblUsuario.Caption   := FormatDateTime('dd/mm/yyyy', Now);
  lblUsuario.Left      := pnlStatus.Width - lblUsuario.Width - 12;
  lblUsuario.Top       := 6;
  lblUsuario.Anchors   := [akTop, akRight];

  WindowState := wsMaximized;

  CarregarConfig;
end;

procedure TPrincipal.CarregarConfig;
begin
  edtDatabase.Text := Conexao.ConfigINI.DatabasePath;
  edtLogo.Text     := Conexao.ConfigINI.LogoPath;
end;

procedure TPrincipal.AbrirForm(AFormClass: TFormClass);
var
  I  : Integer;
  frm: TForm;
begin
  for I := 0 to Screen.FormCount - 1 do
    if Screen.Forms[I] is AFormClass then
    begin
      frm := Screen.Forms[I];
      frm.Show;
      frm.BringToFront;
      frm.SetFocus;
      Exit;
    end;

  frm := AFormClass.Create(Application);
  frm.Show;
end;

// Cadastros
procedure TPrincipal.mnuCadClientesClick(Sender: TObject);
begin
  AbrirForm(TClientes);
end;

procedure TPrincipal.mnuCadFrotaClick(Sender: TObject);
begin
  AbrirForm(TFrota);
end;

procedure TPrincipal.mnuCadRotasClick(Sender: TObject);
begin
  AbrirForm(TRotas);
end;

// Emissao
procedure TPrincipal.mnuMovOSClick(Sender: TObject);
begin
  AbrirForm(TOS);
end;

procedure TPrincipal.btnSelDatabaseClick(Sender: TObject);
var
  Path: string;
begin
  if Conexao.ConfigINI.SelecionarArquivo(Self, 'Selecionar banco de dados',
       'Firebird (*.fdb)|*.fdb|Todos (*.*)|*.*', Path) then
    edtDatabase.Text := Path;
end;

procedure TPrincipal.btnSelLogoClick(Sender: TObject);
var
  Path: string;
begin
  if Conexao.ConfigINI.SelecionarImagem(Self, Path) then
    edtLogo.Text := Path;
end;

procedure TPrincipal.btnSalvarConfigClick(Sender: TObject);
begin
  if (Trim(edtDatabase.Text) <> '') and not FileExists(edtDatabase.Text) then
  begin
    TNotificacao.Aviso(Self, 'Arquivo de banco de dados não encontrado.');
    Exit;
  end;

  if (Trim(edtLogo.Text) <> '') and not FileExists(edtLogo.Text) then
  begin
    TNotificacao.Aviso(Self, 'Arquivo de logo não encontrado.');
    Exit;
  end;

  Conexao.ConfigINI.DatabasePath(edtDatabase.Text);
  Conexao.ConfigINI.LogoPath(edtLogo.Text);

  TNotificacao.Sucesso(Self, 'Configurações salvas com sucesso!');
end;

end.
