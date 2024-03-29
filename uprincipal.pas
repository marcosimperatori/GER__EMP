unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, ComCtrls,
  Menus, lr_e_pdf;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    frTNPDFExport1: TfrTNPDFExport;
    imgPrincipal: TImageList;
    mniRelPedidos: TMenuItem;
    mniRelProdutos: TMenuItem;
    mniRelPessoas: TMenuItem;
    mniVenda: TMenuItem;
    mniCompra: TMenuItem;
    mniTodasAsPessoas: TMenuItem;
    mniFornecedores: TMenuItem;
    mniClientes: TMenuItem;
    ppmConfiguracoes: TPopupMenu;
    ppmRelatorios: TPopupMenu;
    ppmPedidos: TPopupMenu;
    ppmPessoas: TPopupMenu;
    ToolBar1: TToolBar;
    btnPessoas: TToolButton;
    btnProdutos: TToolButton;
    btnPedidos: TToolButton;
    btnRelatorios: TToolButton;
    btnConfiguracoes: TToolButton;
    procedure btnProdutosClick(Sender: TObject);
    procedure mniClientesClick(Sender: TObject);
    procedure mniCompraClick(Sender: TObject);
    procedure mniFornecedoresClick(Sender: TObject);
    procedure mniRelPedidosClick(Sender: TObject);
    procedure mniTodasAsPessoasClick(Sender: TObject);
    procedure mniVendaClick(Sender: TObject);
  private
  public


  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

uses
  ucadclientes, ucadfornecedores, ucadprodutos, upessoas, upedidos, urelpedidos;

{ TfrmPrincipal }

procedure TfrmPrincipal.mniClientesClick(Sender: TObject);
begin
  with TfrmClientes.create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.mniCompraClick(Sender: TObject);
begin
  with TfrmPedidos.create(self) do
  try
    TipoPedido := 'C';
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.btnProdutosClick(Sender: TObject);
begin
  with TfrmProdutos.create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.mniFornecedoresClick(Sender: TObject);
begin
  with TfrmFornecedores.create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.mniRelPedidosClick(Sender: TObject);
begin
  with TfrmRelPedido.create(self) do
  try
    ShowModal;
  finally
    free;
  end;
end;

procedure TfrmPrincipal.mniTodasAsPessoasClick(Sender: TObject);
begin
  with TfrmPessoas.create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.mniVendaClick(Sender: TObject);
begin
  with TfrmPedidos.create(self) do
  try
    TipoPedido := 'V';
    ShowModal;
  finally
    Free;
  end;
end;


end.

