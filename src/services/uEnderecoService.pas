unit uEnderecoService;

// Responsabilidades:
//   1. Preencher lista de UFs em qualquer TComboBox
//   2. Consultar CEP via ViaCEP de forma assincrona

interface

uses
  System.SysUtils, System.Classes, System.Threading, System.Net.HttpClient, System.JSON,
  Vcl.StdCtrls,
  uEnderecoModel;

type
  TCallbackCEP = TProc<TEnderecoModel, string>;

  TEnderecoService = class
  public
    // Preenche qualquer TComboBox com os 27 estados + item vazio no topo
    class procedure PreencherUFs(ACbo: TComboBox);

    // Consulta CEP de forma assincrona
    // ACallback chamado na thread da UI com o resultado ou o erro
    class procedure BuscarCEP(const ACEP: string;
                               ACallback: TCallbackCEP);
  end;

implementation

class procedure TEnderecoService.PreencherUFs(ACbo: TComboBox);
begin
  ACbo.Items.Clear;
  ACbo.Items.Add('');
  ACbo.Items.AddStrings([
    'AC','AL','AP','AM','BA','CE','DF','ES','GO',
    'MA','MT','MS','MG','PA','PB','PR','PE','PI',
    'RJ','RN','RS','RO','RR','SC','SP','SE','TO'
  ]);
  ACbo.ItemIndex := 0;
end;

class procedure TEnderecoService.BuscarCEP(const ACEP: string;
                                            ACallback: TCallbackCEP);
begin
  TTask.Run(
    procedure
    var
      Http     : THTTPClient;
      Response : IHTTPResponse;
      JSON     : TJSONObject;
      Endereco : TEnderecoModel;
      sErro    : string;
    begin
      Endereco := TEnderecoModel.Novo;
      sErro    := '';
      Http     := THTTPClient.Create;
      try
        try
          Response := Http.Get('https://viacep.com.br/ws/' + ACEP + '/json/');

          if Response.StatusCode = 200 then
          begin
            JSON := TJSONObject.ParseJSONValue(
                      Response.ContentAsString) as TJSONObject;
            try
              if (JSON = nil) or (JSON.GetValue('erro') <> nil) then
                sErro := 'CEP não encontrado. Verifique e tente novamente.'
              else
              begin
                Endereco.CEP        := ACEP;
                Endereco.Logradouro := JSON.GetValue<string>('logradouro', '');
                Endereco.Bairro     := JSON.GetValue<string>('bairro',     '');
                Endereco.Cidade     := JSON.GetValue<string>('localidade', '');
                Endereco.UF         := JSON.GetValue<string>('uf',         '');
              end;
            finally
              JSON.Free;
            end;
          end
          else
            sErro := 'Serviço de CEP indisponível (HTTP ' +
                     Response.StatusCode.ToString + ').';

        except
          on E: Exception do
            sErro := 'Não foi possível consultar o CEP.' + sLineBreak +
                     'Verifique sua conexão com a internet.';
        end;

      finally
        Http.Free;
      end;

      TThread.Queue(nil,
        procedure
        begin
          ACallback(Endereco, sErro);
        end);
    end);
end;

end.
