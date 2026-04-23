unit frmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  frmClientes;

type
  TPrincipal = class(TForm)
    pnlSuperior: TPanel;
    btnClientes: TButton;
    frmClientes: TClientes;

    procedure btnClientesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Principal: TPrincipal;

implementation

{$R *.dfm}

procedure TPrincipal.btnClientesClick(Sender: TObject);
begin
  frmClientes := TClientes.Create(Self);
  try
    frmClientes.ShowModal;
  finally
    frmClientes.Free;
  end;
end;

end.
