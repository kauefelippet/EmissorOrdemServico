unit dmConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Phys.IBBase, Vcl.Forms, uConfigINI;

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
  CaminhoBanco := FConfigINI.DatabasePath;

  if Trim(CaminhoBanco) = '' then
  begin
    CaminhoBanco :=
      IncludeTrailingPathDelimiter(
        ExtractFilePath(Application.ExeName)
      ) + 'Dados\EMISSOROS.FDB';
  end;

  FDConnection1.Params.Values['Database'] := CaminhoBanco;
end;

function TConexao.Conexao: TFDConnection;
var
  CaminhoFBClient: string;
begin
  CaminhoFBClient :=
    IncludeTrailingPathDelimiter(
      ExtractFilePath(Application.ExeName)
    ) + 'Firebird\fbclient.dll';

  FDPhysFBDriverLink1.VendorLib := CaminhoFBClient;

  if not FDConnection1.Connected then
  begin
    AplicarCaminhoBanco;
    FDConnection1.Connected := True;
  end;

  Result := FDConnection1;
end;

end.
