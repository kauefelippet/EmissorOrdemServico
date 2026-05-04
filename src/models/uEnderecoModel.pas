unit uEnderecoModel;

interface

type
  // Representa os dados de endereço retornados pelo ViaCEP. Reutilizado por qualquer Form que consulte CEP
  TEnderecoModel = record
    CEP        : string;
    Logradouro : string;
    Bairro     : string;
    Cidade     : string;
    UF         : string;

    class function Novo: TEnderecoModel; static;
  end;

implementation

class function TEnderecoModel.Novo: TEnderecoModel;
begin
  Result.CEP        := '';
  Result.Logradouro := '';
  Result.Bairro     := '';
  Result.Cidade     := '';
  Result.UF         := '';
end;

end.
