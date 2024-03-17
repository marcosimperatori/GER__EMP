unit uselecionar;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

const
  OperadorFiltro: Array[0..4] of String = ('<','>','<>','=','like');

type

  { TfrmSelecionar }

  TfrmSelecionar = class(TForm)
    btnFiltrar: TBitBtn;
    edtPesquisar: TEdit;
    GroupBox1: TGroupBox;
    rgpColuna: TRadioGroup;
    rgpFiltro: TRadioGroup;
    procedure btnFiltrarClick(Sender: TObject);
    procedure rgpColunaSelectionChanged(Sender: TObject);
    procedure rgpFiltroSelectionChanged(Sender: TObject);
  private
    FBusca: String;
    FComplemento: String;

  public
    property sqlComplemento: String read FComplemento write FComplemento;
    property paramBusca: String read FBusca write FBusca;
  end;

var
  frmSelecionar: TfrmSelecionar;

implementation

{$R *.lfm}

{ TfrmSelecionar }

procedure TfrmSelecionar.btnFiltrarClick(Sender: TObject);
var
  operador,coluna: String;
begin
  operador := OperadorFiltro[rgpFiltro.ItemIndex];
  coluna   := LowerCase(rgpColuna.Items[rgpColuna.ItemIndex]);

  if rgpColuna.ItemIndex = 0 then
    paramBusca := Trim(edtPesquisar.Text)
  else
    paramBusca := '%' + Trim(edtPesquisar.Text) + '%';

  sqlComplemento := Format(' and %s %s :chave',[coluna, operador]); ShowMessage(sqlComplemento);
  ModalResult := mrOK;
end;

procedure TfrmSelecionar.rgpColunaSelectionChanged(Sender: TObject);
begin
  if edtPesquisar.CanFocus then
   edtPesquisar.SetFocus;
end;

procedure TfrmSelecionar.rgpFiltroSelectionChanged(Sender: TObject);
begin
  if edtPesquisar.CanFocus then
   edtPesquisar.SetFocus;
end;

end.

