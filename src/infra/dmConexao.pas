unit dmConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Phys.IBBase, uConfigINI;

type
  TConexao = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
  private
    { Private declarations }
    FConfigINI: TConfigINI;
    procedure AplicarCaminhoBanco;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Conexao: TFDConnection;
    property ConfigINI: TConfigINI read FConfigINI;
  end;

var
  Conexao: TConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TConexao.Create(AOwner: TComponent);
begin
  inherited;
  FConfigINI := TConfigINI.Create;
end;

destructor TConexao.Destroy;
begin
  FConfigINI.Free;
  inherited;
end;

procedure TConexao.AplicarCaminhoBanco;
var
  CaminhoBanco: string;
begin
  // Se houver um caminho configurado no INI, substitui o Database da conexao.
  // Caso contrario, mantem o que estiver definido no DFM (fallback).
  CaminhoBanco := FConfigINI.DatabasePath;
  if Trim(CaminhoBanco) <> '' then
    FDConnection1.Params.Values['Database'] := CaminhoBanco;
end;

function TConexao.Conexao: TFDConnection;
begin
  // Se n�o estiver conectado, aplica o caminho configurado e conecta
  if not FDConnection1.Connected then
  begin
    AplicarCaminhoBanco;
    FDConnection1.Connected := True;
  end;

  Result := FDConnection1; // retorna a conex�o ativa
end;

end.
