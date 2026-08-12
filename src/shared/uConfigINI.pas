unit uConfigINI;

// Gerencia a leitura e gravacao das configuracoes do sistema em arquivo INI.
// Local do arquivo: lado a lado com o executavel do aplicativo.

interface

uses
  System.IniFiles, System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, uNotificacao;

type
  TConfigINI = class
  private
    FArqINI: string;
    function GetArqINI: string;
  public
    constructor Create;
    destructor Destroy; override;

    property ArqINI: string read GetArqINI;

    function DatabasePath: string; overload;
    procedure DatabasePath(const AValue: string); overload;

    function LogoPath: string; overload;
    procedure LogoPath(const AValue: string); overload;

    // Path persistido em INI (Seção/Chave)
    function LerString(const ASecao, AChave: string;
                       const APadrao: string = ''): string;
    procedure GravarString(const ASecao, AChave, AValor: string);

    // Helper generico para selecionar arquivo
    function SelecionarArquivo(AOwner: TComponent;
      const ATitulo, AFilter: string; out APath: string): Boolean;
    function SelecionarImagem(AOwner: TComponent;
      out APath: string): Boolean;
  end;

implementation

constructor TConfigINI.Create;
begin
  inherited;
  FArqINI := '';
end;

destructor TConfigINI.Destroy;
begin
  inherited;
end;

function TConfigINI.GetArqINI: string;
begin
  if FArqINI = '' then
    FArqINI := ChangeFileExt(Application.ExeName, '.ini');
  Result := FArqINI;
end;

function TConfigINI.DatabasePath: string;
begin
  Result := LerString('Banco', 'Caminho');
end;

procedure TConfigINI.DatabasePath(const AValue: string);
begin
  GravarString('Banco', 'Caminho', AValue);
end;

function TConfigINI.LogoPath: string;
begin
  Result := LerString('Logo', 'Caminho');
end;

procedure TConfigINI.LogoPath(const AValue: string);
begin
  GravarString('Logo', 'Caminho', AValue);
end;

function TConfigINI.LerString(const ASecao, AChave: string;
  const APadrao: string): string;
var
  Arq: TIniFile;
begin
  Result := APadrao;
  if not FileExists(ArqINI) then
    Exit;

  Arq := TIniFile.Create(ArqINI);
  try
    Result := Arq.ReadString(ASecao, AChave, APadrao);
  finally
    FreeAndNil(Arq);
  end;
end;

procedure TConfigINI.GravarString(const ASecao, AChave, AValor: string);
var
  Arq: TIniFile;
begin
  Arq := TIniFile.Create(ArqINI);
  try
    Arq.WriteString(ASecao, AChave, AValor);
  finally
    FreeAndNil(Arq);
  end;
end;

function TConfigINI.SelecionarArquivo(AOwner: TComponent;
  const ATitulo, AFilter: string; out APath: string): Boolean;
var
  dlg: TOpenDialog;
begin
  dlg             := TOpenDialog.Create(AOwner);
  dlg.Title       := ATitulo;
  dlg.Filter      := AFilter;
  dlg.Options     := [ofFileMustExist];
  Result          := dlg.Execute;
  if Result then
    APath := dlg.FileName
  else
    APath := '';
  dlg.Free;
end;

function TConfigINI.SelecionarImagem(AOwner: TComponent;
  out APath: string): Boolean;
const
  C_FILTER = 'Imagens (JPEG, PNG, BMP)|*.jpg;*.jpeg;*.png;*.bmp|' +
             'Todos os arquivos (*.*)|*.*';
begin
  Result := SelecionarArquivo(AOwner, 'Selecionar imagem da logo', C_FILTER, APath);
end;

end.
