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

    procedure FormCreate(Sender: TObject);
    procedure mnuCadClientesClick(Sender: TObject);
    procedure mnuCadFrotaClick(Sender: TObject);
    procedure mnuCadRotasClick(Sender: TObject);
    procedure mnuMovOSClick(Sender: TObject);
    procedure mnuRelOSPeriodoClick(Sender: TObject);
    procedure mnuRelOSClienteClick(Sender: TObject);

  private
    procedure AbrirForm(AFormClass: TFormClass);
  end;

var
  Principal: TPrincipal;

implementation

{$R *.dfm}

uses
  frmClientes,
  frmFrota,
  frmRotas,
  frmOS;

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

// Movimento
procedure TPrincipal.mnuMovOSClick(Sender: TObject);
begin
  AbrirForm(TOS);
end;

// Relatórios
procedure TPrincipal.mnuRelOSPeriodoClick(Sender: TObject);
begin
  TNotificacao.Info(Self, 'Relatórios em desenvolvimento.');
end;

procedure TPrincipal.mnuRelOSClienteClick(Sender: TObject);
begin
  TNotificacao.Info(Self, 'Relatórios em desenvolvimento.');
end;

end.
