unit ualtpedidos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, Buttons, rxcurredit, utilitarios;

type

  { TfrmAltPedidos }

  TfrmAltPedidos = class(TForm)
    BitBtn1: TBitBtn;
    btnOk: TBitBtn;
    cetValorUnit: TCurrencyEdit;
    cedValorTotal: TCurrencyEdit;
    edtIdProduto: TEdit;
    edtNomeProduto: TEdit;
    edtQtde: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    btnPesquisar: TSpeedButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure edtQtdeExit(Sender: TObject);
  private
    FItem: TItemPedido;
    procedure calcularValorTotal;
  public
    property Item: TItemPedido read FItem write FItem;
  end;

var
  frmAltPedidos: TfrmAltPedidos;

implementation

{$R *.lfm}

uses upesqprodutos;

{ TfrmAltPedidos }

procedure TfrmAltPedidos.btnOkClick(Sender: TObject);
begin
  with Item do
  begin
    IdProduto   := strtoint(Trim(edtIdProduto.Text));
    DescProduto := edtNomeProduto.Text;
    Quantidade  := strtoint(Trim(edtQtde.Text));
    Valor       := cedValorTotal.Value;
  end;
end;

procedure TfrmAltPedidos.btnPesquisarClick(Sender: TObject);
begin
  with TfrmPesqProdutos.Create(self) do
  try
    if ShowModal = mrOK then
    begin
      edtIdProduto.Text   := inttostr(IdProduto);
      edtNomeProduto.Text := NomeProd;
      cetValorUnit.Value  := VlrUnit;
      if edtQtde.CanFocus then
        edtQtde.SetFocus;
    end;
  finally
    free;
  end;
end;

procedure TfrmAltPedidos.edtQtdeExit(Sender: TObject);
begin
  calcularValorTotal;
end;

procedure TfrmAltPedidos.calcularValorTotal;
begin
  try
    cedValorTotal.Value := (StrToInt(Trim(edtQtde.Text)) * cetValorUnit.Value);
  except
    cedValorTotal.Value := 0;
  end;
end;

end.

