unit uOSModel;

interface

uses
  System.SysUtils, System.Generics.Collections,
  uOSNFeModel;

const
  OS_STATUS_ABERTA    = 'ABERTA';
  OS_STATUS_EMITIDA   = 'EMITIDA';
  OS_STATUS_CANCELADA = 'CANCELADA';

  OS_TOMADOR_REMETENTE    = 0;
  OS_TOMADOR_DESTINATARIO = 1;
  OS_TOMADOR_TERCEIRO     = 2;

type
  TOrdemServicoModel = record
    ID              : Integer;
    Numero          : Integer;
    Data            : TDateTime;
    Status          : string;
    // Partes
    IDRemetente     : Integer;
    IDDestinatario  : Integer;
    IDTomador       : Integer;
    TipoTomador     : Integer;
    // Transporte
    IDFrota         : Integer;
    IDRota          : Integer;
    KM              : Double;
    // Carga
    CFOP            : string;
    PesoTotal       : Double;
    QuantidadeTotal : Integer;
    ValorMercadoria : Double;
    // Valores
    ValorFrete      : Double;
    Seguro          : Double;
    BaseICMS        : Double;
    Aliquota        : Double;
    ValorICMS       : Double;
    Observacoes     : string;
    // Auxiliares para exibição
    NomeRemetente   : string;
    NomeDestinatario: string;
    NomeTomador     : string;
    PlacaFrota      : string;
    DescricaoRota   : string;

    class function Novo: TOrdemServicoModel; static;

    function Editavel: Boolean;

    function PodeEmitir: Boolean;

    function PodeCancelar: Boolean;
  end;

implementation

class function TOrdemServicoModel.Novo: TOrdemServicoModel;
begin
  Result.ID              := 0;
  Result.Numero          := 0;
  Result.Data            := Now;
  Result.Status          := OS_STATUS_ABERTA;
  Result.IDRemetente     := 0;
  Result.IDDestinatario  := 0;
  Result.IDTomador       := 0;
  Result.TipoTomador     := OS_TOMADOR_REMETENTE;
  Result.IDFrota         := 0;
  Result.IDRota          := 0;
  Result.KM              := 0;
  Result.CFOP            := '';
  Result.PesoTotal       := 0;
  Result.QuantidadeTotal := 0;
  Result.ValorMercadoria := 0;
  Result.ValorFrete      := 0;
  Result.Seguro          := 0;
  Result.BaseICMS        := 0;
  Result.Aliquota        := 0;
  Result.ValorICMS       := 0;
  Result.Observacoes     := '';
  Result.NomeRemetente   := '';
  Result.NomeDestinatario:= '';
  Result.NomeTomador     := '';
  Result.PlacaFrota      := '';
  Result.DescricaoRota   := '';
end;

function TOrdemServicoModel.Editavel: Boolean;
begin
  Result := Status = OS_STATUS_ABERTA;
end;

function TOrdemServicoModel.PodeEmitir: Boolean;
begin
  Result := Status = OS_STATUS_ABERTA;
end;

function TOrdemServicoModel.PodeCancelar: Boolean;
begin
  Result := Status <> OS_STATUS_CANCELADA;
end;

end.
