unit urelpedidos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  ZDataset;

type

  { TfrmRelPedido }

  TfrmRelPedido = class(TForm)
    btnGerar: TBitBtn;
    rgpTipoRel: TRadioGroup;
    procedure btnGerarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FQuery: TZQuery;
    procedure DadosRelatorio;
    procedure GerarRelatorio;
  public

  end;

var
  frmRelPedido: TfrmRelPedido;

implementation

{$R *.lfm}

uses utilitarios, uvisualizardorrelatorio, queries;

{ TfrmRelPedido }

procedure TfrmRelPedido.FormCreate(Sender: TObject);
begin
  FQuery := NovaQuery;
end;

procedure TfrmRelPedido.btnGerarClick(Sender: TObject);
begin
  DadosRelatorio;
  GerarRelatorio;
end;

procedure TfrmRelPedido.FormDestroy(Sender: TObject);
begin
  FQuery.Free;
end;

procedure TfrmRelPedido.DadosRelatorio;
begin
  FQuery.SQL.Text:= listaPedidosRelatorio;

  if rgpTipoRel.ItemIndex = 0 then
    FQuery.ParamByName('tipo').AsString:= 'C'
  else
    FQuery.ParamByName('tipo').AsString:= 'V';

  FQuery.Open;
end;

procedure TfrmRelPedido.GerarRelatorio;
begin
  with TfrmVisualizador.Create(self) do
  try
    Screen.Cursor := crHourGlass;
    Position := poOwnerFormCenter;
    BorderStyle := bsSizeable;
    RelatorioBasico(FQuery, 'rel_pedidos');
    Screen.Cursor := crDefault;
    ShowModal;
  finally
    Free;
  end;
end;

end.

