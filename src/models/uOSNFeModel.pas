unit uOSNFeModel;

interface

type
  TOSNFeModel = record
    ID              : Integer;
    IDOS            : Integer;
    ChaveNFe        : string;
    NumeroNFe       : string;
    Serie           : string;
    Emitente        : string;
    Peso            : Double;
    Quantidade      : Integer;
    ValorMercadoria : Double;

    class function Novo: TOSNFeModel; static;
  end;

implementation

class function TOSNFeModel.Novo: TOSNFeModel;
begin
  Result.ID              := 0;
  Result.IDOS            := 0;
  Result.ChaveNFe        := '';
  Result.NumeroNFe       := '';
  Result.Serie           := '';
  Result.Emitente        := '';
  Result.Peso            := 0;
  Result.Quantidade      := 0;
  Result.ValorMercadoria := 0;
end;

end.
