unit uClienteModel;

interface

type
  TClienteModel = record
    ID           : Integer;
    Documento    : string;
    RazaoSocial  : string;
    NomeFantasia : string;
    IERG         : string;
    CEP          : string;
    Logradouro   : string;
    Numero       : string;
    Bairro       : string;
    Cidade       : string;
    UF           : string;

    class function Novo: TClienteModel; static;
  end;

implementation

class function TClienteModel.Novo: TClienteModel;
begin
  Result.ID           := 0;
  Result.Documento    := '';
  Result.RazaoSocial  := '';
  Result.NomeFantasia := '';
  Result.IERG         := '';
  Result.CEP          := '';
  Result.Logradouro   := '';
  Result.Numero       := '';
  Result.Bairro       := '';
  Result.Cidade       := '';
  Result.UF           := '';
end;

end.
