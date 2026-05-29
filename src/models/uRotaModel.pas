unit uRotaModel;

interface

type
  TRotaModel = record
    ID           : Integer;
    Descricao    : string;
    TipoCalculo  : string;
    ValorBase    : Double;
    Multiplicador: Double;

    class function Novo: TRotaModel; static;

    function UsaMultiplicador: Boolean;

    function TipoDescricao: string;

    function LabelMultiplicador: string;
  end;

const
  TIPO_FIXO      = 'FIXO';
  TIPO_KM        = 'POR_KM';
  TIPO_PESO      = 'POR_PESO';
  TIPO_VOLUME    = 'POR_VOLUME';
  TIPO_VALOR_NF  = 'POR_VALOR';

implementation

class function TRotaModel.Novo: TRotaModel;
begin
  Result.ID            := 0;
  Result.Descricao     := '';
  Result.TipoCalculo   := TIPO_FIXO;
  Result.ValorBase     := 0;
  Result.Multiplicador := 0;
end;

function TRotaModel.UsaMultiplicador: Boolean;
begin
  Result := TipoCalculo <> TIPO_FIXO;
end;

function TRotaModel.TipoDescricao: string;
begin
  if      TipoCalculo = TIPO_FIXO     then Result := 'Fixo'
  else if TipoCalculo = TIPO_KM       then Result := 'Por KM'
  else if TipoCalculo = TIPO_PESO     then Result := 'Por Peso'
  else if TipoCalculo = TIPO_VOLUME   then Result := 'Por Volume'
  else if TipoCalculo = TIPO_VALOR_NF then Result := 'Por Valor da NF-e'
  else Result := TipoCalculo;
end;

function TRotaModel.LabelMultiplicador: string;
begin
  if      TipoCalculo = TIPO_KM       then Result := 'Valor por KM (R$)'
  else if TipoCalculo = TIPO_PESO     then Result := 'Valor por KG (R$)'
  else if TipoCalculo = TIPO_VOLUME   then Result := 'Valor por Volume (R$)'
  else if TipoCalculo = TIPO_VALOR_NF then Result := 'Fator sobre Valor NF (%)'
  else Result := 'Multiplicador';
end;

end.
