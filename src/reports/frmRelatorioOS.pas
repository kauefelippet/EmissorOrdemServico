unit frmRelatorioOS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, RLFilters, RLPDFFilter,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
  dmConexao;

type
  TRelatorioOS = class(TForm)
    RLOrdemServico: TRLReport;
    btHeader: TRLBand;
    imgLogo: TRLImage;
    lblTitulo: TRLLabel;
    lblPrefixoNum: TRLLabel;
    dbNumero: TRLDBText;
    lblData: TRLLabel;
    dbData: TRLDBText;
    lblStatus: TRLLabel;
    dbStatus: TRLDBText;
    lblCFOP: TRLLabel;
    dbCFOP: TRLDBText;
    rlDraw1: TRLDraw;

    btPartes: TRLBand;
    lblSecPartes: TRLLabel;
    pnlTomador: TRLPanel;
    lblTomTitulo: TRLLabel;
    dbTomNome: TRLDBText;
    dbTomDoc: TRLDBText;
    dbTomLocal: TRLDBText;
    pnlRemetente: TRLPanel;
    lblRemTitulo: TRLLabel;
    dbRemNome: TRLDBText;
    dbRemDoc: TRLDBText;
    dbRemEnd: TRLDBText;
    dbRemLocal: TRLDBText;
    pnlDestinatario: TRLPanel;
    lblDestTitulo: TRLLabel;
    dbDestNome: TRLDBText;
    dbDestDoc: TRLDBText;
    dbDestEnd: TRLDBText;
    dbDestLocal: TRLDBText;

    btHeaderNFe: TRLBand;
    lblSecNFe: TRLLabel;
    pnlColHdr: TRLPanel;
    hdrNum: TRLLabel;
    hdrSerie: TRLLabel;
    hdrEmit: TRLLabel;
    hdrChave: TRLLabel;
    hdrPeso: TRLLabel;
    hdrQtd: TRLLabel;
    hdrValor: TRLLabel;

    btMasterDetail: TRLBand; // Banda mestre invisível que aciona a leitura

    btNFeDetail: TRLSubDetail; // Contêiner do sub-relatório
    bndNFeRow: TRLBand;        // Banda filha de detalhe da NF-e
    dbNFeNum: TRLDBText;
    dbNFeSerie: TRLDBText;
    dbNFeEmit: TRLDBText;
    dbNFeChave: TRLDBText;
    dbNFePeso: TRLDBText;
    dbNFeQtd: TRLDBText;
    dbNFeValor: TRLDBText;

    btNFeFooter: TRLBand;      // Banda filha de sumário da NF-e
    pnlTotCarga: TRLPanel;
    lblTotCarga: TRLLabel;
    resNFePeso: TRLDBResult;
    resNFeQtd: TRLDBResult;
    resNFeValor: TRLDBResult;
    rlDrawLogistica: TRLDraw;
    lblSecLogistica: TRLLabel;
    lblVeiculo: TRLLabel;
    dbPlaca: TRLDBText;
    dbFrotaDesc: TRLDBText;

    btSummary: TRLBand;
    rlDrawSep: TRLDraw;
    lblSecFrete: TRLLabel;
    lblFreteTit: TRLLabel;
    dbValorFrete: TRLDBText;
    lblSeguroTit: TRLLabel;
    dbSeguro: TRLDBText;
    lblBaseICMSTit: TRLLabel;
    dbBaseICMS: TRLDBText;
    lblAliqTit: TRLLabel;
    dbAliquota: TRLDBText;
    lblICMSTit: TRLLabel;
    dbValorICMS: TRLDBText;
    pnlTotalGeral: TRLPanel;
    lblTotalGeralTit: TRLLabel;
    lblTotalSub: TRLLabel;
    dbTotalGeral: TRLDBText;
    lblObsTit: TRLLabel;
    dbObs: TRLDBMemo;
    lblAssTitle: TRLLabel;
    rlLinhaMot: TRLDraw;
    lblAssMot: TRLLabel;
    lblDataMot: TRLLabel;
    rlLinhaRem: TRLDraw;
    lblAssRem: TRLLabel;
    lblDataRem: TRLLabel;
    rlLinhaDest: TRLDraw;
    lblAssDest: TRLLabel;
    lblDataDest: TRLLabel;

    qryOS: TFDQuery;
    qryNFe: TFDQuery;
    dtsOS: TDataSource;
    dtsNFe: TDataSource;
    RLPDFFilter1: TRLPDFFilter;

    qryNFeNUMERO_NFE: TWideStringField;
    qryNFeSERIE: TWideStringField;
    qryNFeEMITENTE: TWideStringField;
    qryNFeCHAVE_NFE: TWideStringField;
    qryNFePESO: TFMTBCDField;
    qryNFeQUANTIDADE: TBCDField;
    qryNFeVALOR_MERCADORIA: TFMTBCDField;

    qryOSID: TIntegerField;
    qryOSNUMERO: TIntegerField;
    qryOSSTATUS: TWideStringField;
    qryOSCFOP: TWideStringField;
    qryOSOBSERVACOES: TWideMemoField;
    qryOSDATA_FMT: TWideStringField;
    qryOSVALOR_FRETE: TFMTBCDField;
    qryOSSEGURO: TFMTBCDField;
    qryOSBASE_ICMS: TFMTBCDField;
    qryOSALIQUOTA: TCurrencyField;
    qryOSVALOR_ICMS: TFMTBCDField;
    qryOSPESO: TFMTBCDField;
    qryOSQUANTIDADE: TIntegerField;
    qryOSVALOR_MERCADORIA: TFMTBCDField;
    qryOSKM_FMT: TWideStringField;
    qryOSTOTAL_GERAL: TFMTBCDField;
    qryOSTOM_NOME: TWideStringField;
    qryOSTOM_DOC: TWideStringField;
    qryOSTOM_LOCAL: TWideStringField;
    qryOSREM_NOME: TWideStringField;
    qryOSREM_DOC: TWideStringField;
    qryOSREM_END: TWideStringField;
    qryOSREM_LOCAL: TWideStringField;
    qryOSDEST_NOME: TWideStringField;
    qryOSDEST_DOC: TWideStringField;
    qryOSDEST_END: TWideStringField;
    qryOSDEST_LOCAL: TWideStringField;
    qryOSPLACA: TWideStringField;
    qryOSFROTA_DESC: TWideStringField;
    qryOSROTA_DESC: TWideStringField;

  private
    procedure FormatarCamposNumericos;
    procedure PrepararDados(const AOSID: Integer);
  public
    procedure Imprimir(const AOSID: Integer; const ALogoPath: string = '');
    procedure ExportarPDF(const AOSID: Integer; const ACaminho: string);
  end;

var
  RelatorioOS: TRelatorioOS;

implementation

{$R *.dfm}

procedure TRelatorioOS.FormatarCamposNumericos;
begin
  if Assigned(qryOSVALOR_FRETE) then qryOSVALOR_FRETE.DisplayFormat := 'R$ #,##0.00';
  if Assigned(qryOSSEGURO) then qryOSSEGURO.DisplayFormat := 'R$ #,##0.00';
  if Assigned(qryOSBASE_ICMS) then qryOSBASE_ICMS.DisplayFormat := 'R$ #,##0.00';
  if Assigned(qryOSALIQUOTA) then qryOSALIQUOTA.DisplayFormat := '0.00''%';
  if Assigned(qryOSVALOR_ICMS) then qryOSVALOR_ICMS.DisplayFormat := 'R$ #,##0.00';
  if Assigned(qryOSPESO) then qryOSPESO.DisplayFormat := '#,##0.000';
  if Assigned(qryOSVALOR_MERCADORIA) then qryOSVALOR_MERCADORIA.DisplayFormat := 'R$ #,##0.00';
  if Assigned(qryOSTOTAL_GERAL) then qryOSTOTAL_GERAL.DisplayFormat := 'R$ #,##0.00';

  if Assigned(qryNFePESO) then qryNFePESO.DisplayFormat := '#,##0.000';
  if Assigned(qryNFeQUANTIDADE) then qryNFeQUANTIDADE.DisplayFormat := '#,##0';
  if Assigned(qryNFeVALOR_MERCADORIA) then qryNFeVALOR_MERCADORIA.DisplayFormat := 'R$ #,##0.00';

  if Assigned(resNFePeso) then resNFePeso.DisplayMask := '#,##0.000';
  if Assigned(resNFeQtd) then resNFeQtd.DisplayMask := '#,##0';
  if Assigned(resNFeValor) then resNFeValor.DisplayMask := 'R$ #,##0.00';
end;

procedure TRelatorioOS.PrepararDados(const AOSID: Integer);
begin
  FormatarCamposNumericos;

  qryOS.Close;
  qryOS.ParamByName('pID').AsInteger := AOSID;
  qryOS.Open;
  qryOS.FetchAll; // Garante que todos os dados subam para a memória e fiquem visíveis para o Fortes

  qryNFe.Close;
  qryNFe.ParamByName('pOS').AsInteger := AOSID;
  qryNFe.Open;
  qryNFe.FetchAll; // Idem para as notas
end;

procedure TRelatorioOS.Imprimir(const AOSID: Integer; const ALogoPath: string = '');
begin
  PrepararDados(AOSID);

  if qryOS.IsEmpty then
  begin
    ShowMessage('OS não encontrada no banco de dados.');
    Exit;
  end;

  if (ALogoPath <> '') and FileExists(ALogoPath) then
  begin
    imgLogo.Visible := True;
    imgLogo.Picture.LoadFromFile(ALogoPath);
  end
  else
    imgLogo.Visible := False;

  RLOrdemServico.PreviewModal;
end;

procedure TRelatorioOS.ExportarPDF(const AOSID: Integer; const ACaminho: string);
begin
  PrepararDados(AOSID);

  if not qryOS.IsEmpty then
  begin
    RLPDFFilter1.FileName := ACaminho;
    RLOrdemServico.SaveToFile(ACaminho);
  end;
end;

end.
