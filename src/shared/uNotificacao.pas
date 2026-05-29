unit uNotificacao;

interface

uses
  System.SysUtils, System.UITypes, System.Math,
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Graphics;

type
  TTipoNotificacao = (tnSucesso, tnErro, tnAviso, tnInfo);

  TNotificacao = class
  public
    class procedure Sucesso(AOwner: TForm; const AMensagem: string);
    class procedure Erro   (AOwner: TForm; const AMensagem: string);
    class procedure Aviso  (AOwner: TForm; const AMensagem: string);
    class procedure Info   (AOwner: TForm; const AMensagem: string);
  private
    class procedure TimerClose(Sender: TObject);
    class procedure Exibir (AOwner: TForm; const AMensagem: string;
                            ATipo: TTipoNotificacao);
    class procedure FecharNotificacao(Sender: TObject);
  end;

implementation

class procedure TNotificacao.Exibir(AOwner: TForm; const AMensagem: string;
  ATipo: TTipoNotificacao);
var
  pnl    : TPanel;
  lbl    : TLabel;
  ico    : TLabel;
  timer  : TTimer;
  cor    : TColor;
  icone  : string;
begin
  case ATipo of
    tnSucesso: begin cor := $00A550;  icone := '✔'; end; // verde
    tnErro:    begin cor := $2020CC;  icone := '✖'; end; // vermelho
    tnAviso:   begin cor := $00A5FF;  icone := '⚠'; end; // laranja
    tnInfo:    begin cor := $B46004;  icone := 'ℹ'; end; // azul
  else
               begin cor := $444444;  icone := '•'; end;
  end;

  // ── Painel principal ────────────────────────────────────────────────────────
  pnl                 := TPanel.Create(AOwner);
  pnl.Parent          := AOwner;
  pnl.Color           := cor;
  pnl.BevelOuter      := bvNone;
  pnl.Height          := 44;
  pnl.Width           := Min(AOwner.ClientWidth - 32, 480);
  pnl.Caption         := '';
  pnl.ParentBackground := False;
  pnl.OnDblClick := FecharNotificacao;

  // Posiciona no canto inferior direito do Form
  pnl.Left := AOwner.ClientWidth  - pnl.Width  - 16;
  pnl.Top  := AOwner.ClientHeight - pnl.Height - 16;

  // Garante que fica acima de todos os outros controles
  pnl.BringToFront;

  // ── Ícone ────────────────────────────────────────────────────────────────────
  ico            := TLabel.Create(pnl);
  ico.Parent     := pnl;
  ico.Caption    := icone;
  ico.Font.Color := clWhite;
  ico.Font.Size  := 14;
  ico.Font.Style := [fsBold];
  ico.Left       := 12;
  ico.Top        := (pnl.Height - ico.Height) div 2;
  ico.AutoSize   := True;
  ico.OnDblClick := FecharNotificacao;

  // ── Texto da mensagem ─────────────────────────────────────────────────────
  lbl            := TLabel.Create(pnl);
  lbl.Parent     := pnl;
  lbl.Caption    := AMensagem;
  lbl.Font.Color := clWhite;
  lbl.Font.Size  := 10;
  lbl.Left       := 36;
  lbl.Width      := pnl.Width - 44;
  lbl.Top        := (pnl.Height - lbl.Height) div 2;
  lbl.AutoSize   := False;
  lbl.WordWrap   := False;
  lbl.EllipsisPosition := epEndEllipsis;
  lbl.OnDblClick := FecharNotificacao;

  // ── Timer para sumir automaticamente ─────────────────────────────────────
  timer          := TTimer.Create(pnl);
  timer.Interval := 2000;
  timer.OnTimer := TimerClose;
  timer.Enabled := True;
end;

class procedure TNotificacao.TimerClose(Sender: TObject);
begin
  with TTimer(Sender) do
  begin
    Enabled := False;
    Owner.Free;
  end;
end;

class procedure TNotificacao.FecharNotificacao(Sender: TObject);
var
  pnl: TPanel;
begin
  if Sender is TPanel then
    pnl := TPanel(Sender)
  else if Sender is TControl then
    pnl := TPanel(TControl(Sender).Parent)
  else
    Exit;

  pnl.Free;
end;

// ─── Métodos públicos ─────────────────────────────────────────────────────────
class procedure TNotificacao.Sucesso(AOwner: TForm; const AMensagem: string);
begin
  Exibir(AOwner, AMensagem, tnSucesso);
end;

class procedure TNotificacao.Erro(AOwner: TForm; const AMensagem: string);
begin
  Exibir(AOwner, AMensagem, tnErro);
end;

class procedure TNotificacao.Aviso(AOwner: TForm; const AMensagem: string);
begin
  Exibir(AOwner, AMensagem, tnAviso);
end;

class procedure TNotificacao.Info(AOwner: TForm; const AMensagem: string);
begin
  Exibir(AOwner, AMensagem, tnInfo);
end;

end.
