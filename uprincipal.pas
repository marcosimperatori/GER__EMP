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
    procedure mniClientesClick(Sender: TObject);
    procedure mniFornecedoresClick(Sender: TObject);
  private

  public


  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

uses
  ucadclientes, ucadfornecedores;

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

procedure TfrmPrincipal.mniFornecedoresClick(Sender: TObject);
begin
  with TfrmFornecedores.create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

end.

