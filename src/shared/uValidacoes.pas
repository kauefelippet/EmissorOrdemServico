unit uValidacoes;

// Unidade responsavel apenas pela validacao de dados. Deve retornar Boolean e motivo caso false.

interface

type
  TValidacoes = class

  public

    // Valida CPF
    class function CPFValido(const ANumeros: string): Boolean;

    // Valida CNPJ
    class function CNPJValido(const ANumeros: string): Boolean;

    // Valida CPF ou CNPJ automaticamente com base no tamanho. AErro retorna mensagem se for invalido
    class function DocumentoValido(const ANumeros: string; out AErro: string): Boolean;

    // Valida se o CEP tem 8 digitos
    class function CEPValido(const ANumeros: string): Boolean;

    // Valida se a placa usa padrao ABC1234 ou ABC1D23. AErro retorna mensagem se for invalido
    class function PlacaValida(const APlaca: string; out AErro: string): Boolean;
  end;

implementation

uses
  System.SysUtils, System.Character;

// ─── CPF ─────────────────────────────────────────────────────────────────────
class function TValidacoes.CPFValido(const ANumeros: string): Boolean;
var
  N: string;
  I, Soma, Resto, D1, D2: Integer;
begin
  Result := False;
  N := ANumeros;

  if Length(N) <> 11 then Exit;

  if (N = StringOfChar(N[1], 11)) then Exit;

  Soma := 0;
  for I := 1 to 9 do
    Soma := Soma + StrToInt(N[I]) * (11 - I);
  Resto := Soma mod 11;
  if Resto < 2 then D1 := 0 else D1 := 11 - Resto;
  if D1 <> StrToInt(N[10]) then Exit;

  Soma := 0;
  for I := 1 to 10 do
    Soma := Soma + StrToInt(N[I]) * (12 - I);
  Resto := Soma mod 11;
  if Resto < 2 then D2 := 0 else D2 := 11 - Resto;
  if D2 <> StrToInt(N[11]) then Exit;

  Result := True;
end;

// ─── CNPJ ────────────────────────────────────────────────────────────────────
class function TValidacoes.CNPJValido(const ANumeros: string): Boolean;
var
  N: string;
  I, Soma, Resto, D1, D2: Integer;
  Pesos1: array[0..11] of Integer;
  Pesos2: array[0..12] of Integer;
begin
  Result := False;
  N := ANumeros;

  if Length(N) <> 14 then Exit;
  if N = StringOfChar(N[1], 14) then Exit;

  Pesos1[0]  := 5; Pesos1[1]  := 4; Pesos1[2]  := 3; Pesos1[3]  := 2;
  Pesos1[4]  := 9; Pesos1[5]  := 8; Pesos1[6]  := 7; Pesos1[7]  := 6;
  Pesos1[8]  := 5; Pesos1[9]  := 4; Pesos1[10] := 3; Pesos1[11] := 2;

  Soma := 0;
  for I := 0 to 11 do
    Soma := Soma + StrToInt(N[I+1]) * Pesos1[I];
  Resto := Soma mod 11;
  if Resto < 2 then D1 := 0 else D1 := 11 - Resto;
  if D1 <> StrToInt(N[13]) then Exit;

  Pesos2[0]  := 6; Pesos2[1]  := 5; Pesos2[2]  := 4; Pesos2[3]  := 3;
  Pesos2[4]  := 2; Pesos2[5]  := 9; Pesos2[6]  := 8; Pesos2[7]  := 7;
  Pesos2[8]  := 6; Pesos2[9]  := 5; Pesos2[10] := 4; Pesos2[11] := 3;
  Pesos2[12] := 2;

  Soma := 0;
  for I := 0 to 12 do
    Soma := Soma + StrToInt(N[I+1]) * Pesos2[I];
  Resto := Soma mod 11;
  if Resto < 2 then D2 := 0 else D2 := 11 - Resto;
  if D2 <> StrToInt(N[14]) then Exit;

  Result := True;
end;

// ─── Documento (CPF ou CNPJ) ─────────────────────────────────────────────────
class function TValidacoes.DocumentoValido(const ANumeros: string;
                                           out AErro: string): Boolean;
begin
  AErro  := '';
  Result := False;

  case Length(ANumeros) of
    11:
      if not CPFValido(ANumeros) then
        AErro := 'CPF inválido. Verifique os dígitos.'
      else
        Result := True;
    14:
      if not CNPJValido(ANumeros) then
        AErro := 'CNPJ inválido. Verifique os dígitos.'
      else
        Result := True;
  else
    AErro := 'Documento inválido. CPF deve ter 11 dígitos e CNPJ 14 dígitos.';
  end;
end;

// ─── CEP ─────────────────────────────────────────────────────────────────────
class function TValidacoes.CEPValido(const ANumeros: string): Boolean;
begin
  Result := Length(ANumeros) = 8;
end;

// ─── Placa ───────────────────────────────────────────────────────────────────
class function TValidacoes.PlacaValida(const APlaca: string;
                                       out AErro: string): Boolean;
var
  P: string;
begin
  AErro  := '';
  Result := False;

  P := StringReplace(APlaca, '-', '', [rfReplaceAll]).ToUpper;

  if Length(P) <> 7 then
  begin
    AErro := 'Placa inválida. Use o formato ABC1234 ou ABC1D23.';
    Exit;
  end;

  if not (P[1].IsLetter and P[2].IsLetter and P[3].IsLetter) then
  begin
    AErro := 'Placa inválida. Os 3 primeiros caracteres devem ser letras.';
    Exit;
  end;

  if not P[4].IsDigit then
  begin
    AErro := 'Placa inválida. O 4º caractere deve ser um número.';
    Exit;
  end;

  if P[5].IsDigit then
  begin
    if not (P[6].IsDigit and P[7].IsDigit) then
    begin
      AErro := 'Placa inválida. Formato esperado: ABC1234.';
      Exit;
    end;
  end
  else if P[5].IsLetter then
  begin
    if not (P[6].IsDigit and P[7].IsDigit) then
    begin
      AErro := 'Placa inválida. Formato esperado: ABC1D23.';
      Exit;
    end;
  end
  else
  begin
    AErro := 'Placa inválida.';
    Exit;
  end;

  Result := True;
end;

end.
