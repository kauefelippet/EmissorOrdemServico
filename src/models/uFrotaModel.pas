unit uFrotaModel;

interface

type
  TFrotaModel = record
    ID                : Integer;
    Placa             : string;
    Descricao         : string;
    Tipo              : string;
    IDProprietario    : Integer;
    NomeProprietario  : string;

    class function Novo: TFrotaModel; static;

    function TipoDescricao: string;
  end;

implementation

class function TFrotaModel.Novo: TFrotaModel;
begin
  Result.ID              := 0;
  Result.Placa           := '';
  Result.Descricao       := '';
  Result.Tipo            := 'P';
  Result.IDProprietario  := 0;
  Result.NomeProprietario:= '';
end;

function TFrotaModel.TipoDescricao: string;
begin
  if Tipo = 'P' then Result := 'Próprio'
  else if Tipo = 'T' then Result := 'Terceiro'
  else Result := '';
end;

end.
