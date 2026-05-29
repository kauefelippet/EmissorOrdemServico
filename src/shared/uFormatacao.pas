unit uFormatacao;

// Unidade responsavel apenas por formatacao de dados para a interface

interface

type
  TFormatacao = class

  public

    // Remove tudo que nao for digito
    class function ApenasNumeros(const ATexto: string): string;

    // Formata CPF e CNPJ. Se nenhum retorna sem formatacao
    class function FormatarDocumento(const ANumeros: string): string;

    // Formata CEP
    class function FormatarCEP(const ANumeros: string): string;

    // Detecta se CPF ou CNPJ com base na quantidade de digitos. Retorna 'CPF', 'CNPJ' ou ''
    class function TipoDocumento(const ATexto: string): string;

    // Remove hifen e maiuscula para salvar no banco
    class function FormatarPlaca(const APlaca: string): string;

    // Formata para exibicao na interface
    class function NormalizarPlaca(const APlaca: string): string;
  end;

implementation

uses
  System.SysUtils;

class function TFormatacao.ApenasNumeros(const ATexto: string): string;
var
  C: Char;
begin
  Result := '';
  for C in ATexto do
    if C in ['0'..'9'] then
      Result := Result + C;
end;

class function TFormatacao.FormatarDocumento(const ANumeros: string): string;
var
  N: string;
begin
  N := ApenasNumeros(ANumeros);

  case Length(N) of
    // CPF
    11:
      Result := Copy(N,1,3) + '.' +
                Copy(N,4,3) + '.' +
                Copy(N,7,3) + '-' +
                Copy(N,10,2);
    // CNPJ
    14:
      Result := Copy(N,1,2)  + '.' +
                Copy(N,3,3)  + '.' +
                Copy(N,6,3)  + '/' +
                Copy(N,9,4)  + '-' +
                Copy(N,13,2);
  else
    // Nenhum
    Result := N;
  end;
end;

class function TFormatacao.FormatarCEP(const ANumeros: string): string;
var
  N: string;
begin
  N := ApenasNumeros(ANumeros);
  if Length(N) = 8 then
    Result := Copy(N,1,5) + '-' + Copy(N,6,3)
  else
    Result := N;
end;

class function TFormatacao.TipoDocumento(const ATexto: string): string;
begin
  case Length(ApenasNumeros(ATexto)) of
    11: Result := 'CPF';
    14: Result := 'CNPJ';
  else
    Result := '';
  end;
end;

class function TFormatacao.NormalizarPlaca(const APlaca: string): string;
begin
  Result := StringReplace(APlaca, '-', '', [rfReplaceAll]).ToUpper;
end;

class function TFormatacao.FormatarPlaca(const APlaca: string): string;
var
  P: string;
begin
  P := NormalizarPlaca(APlaca);
  if Length(P) = 7 then
    Result := Copy(P, 1, 3) + '-' + Copy(P, 4, 4)
  else
    Result := APlaca;
end;

end.
