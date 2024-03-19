unit ualtprodutos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBCtrls,
  Buttons, ComCtrls, StdCtrls, DBGrids, ActnList, MaskEdit, umdl, DB,
  BufDataset, queries, ZDataset, utilitarios, rxcurredit, rxspin;

type

  { TfrmAltProdutos }

  TfrmAltProdutos = class(TForm)
    btnAnterior: TSpeedButton;
    btnCancelar: TBitBtn;
    btnAplicar: TBitBtn;
    btnPrimeiro: TSpeedButton;
    btnProximo: TSpeedButton;
    btnUltimo: TSpeedButton;
    bufClientes: TBufDataset;
    cedPVP: TCurrencyEdit;
    cedPUC: TCurrencyEdit;
    cedPVN: TCurrencyEdit;
    cedEstoque_PVN: TCurrencyEdit;
    DBText2: TLabel;
    edtEstoque: TEdit;
    edtCodigo: TEdit;
    edtNome: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    panNavegacao: TPanel;
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnAplicarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnPrimeiroClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    procedure edtEstoqueKeyPress(Sender: TObject; var Key: char);
    procedure edtNomeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FEdicao: boolean;
    FId: Integer;
    FQuery: TZQuery;
    FListas: TListas;
    function CpfJaExiste(AInscricao: String): boolean;
    function Salvar: boolean;
    procedure LocalizarRegistro(Codigo: Integer);
    procedure CarregarDados;
    procedure ManipularCampos;
  public
    property idRegistro: Integer read FId write FId;
    property modoEdicao: boolean read FEdicao write FEdicao;
  end;

var
  frmAltProdutos: TfrmAltProdutos;

implementation

{$R *.lfm}

{ TfrmAltProdutos }

procedure TfrmAltProdutos.FormShow(Sender: TObject);
begin
  if modoEdicao then
    LocalizarRegistro(idRegistro);

  HabilitarDesabilitarControles(Self);
end;

function TfrmAltProdutos.CpfJaExiste(AInscricao: String): boolean;
var
  qry: TZQuery;
begin
  qry := NovaQuery;
  result := false;
  try
    with qry do
    begin
      sql.Text:= cpfJaCadastrado;
      ParamByName('inscricao').AsString := AInscricao;
      Open;
      if not IsEmpty then
        result := true;
    end;
  finally
    qry.Free;
  end;
end;

function TfrmAltProdutos.Salvar: boolean;
var
  qry: TZQuery;
begin
  qry := NovaQuery;
  try
    with qry do
    begin
      try
        if modoEdicao then
        begin
          sql.Text := atualizaProduto;
          ParamByName('id').AsInteger := idRegistro;
        end
        else
          sql.Text:= insereProduto;

        ParamByName('nome').AsString     := edtNome.Text;
        ParamByName('pvp').AsCurrency    := cedPVP.Value;
        ParamByName('pvn').AsCurrency    := cedPVN.Value;
        ExecSQL;
        result := true;
      except
        on e: exception do
        begin
          result := false;
        end;
      end;
    end;
  finally
    qry.Free;
  end;
end;

procedure TfrmAltProdutos.btnPrimeiroClick(Sender: TObject);
begin
  bufClientes.First;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltProdutos.btnProximoClick(Sender: TObject);
begin
   bufClientes.Next;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltProdutos.btnUltimoClick(Sender: TObject);
begin
  bufClientes.Last;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltProdutos.edtEstoqueKeyPress(Sender: TObject; var Key: char);
begin
  // permite que apenas números sejam digitados
  if not (Key in ['0'..'9', #8, #13]) then
    Key := #0;
end;

procedure TfrmAltProdutos.edtNomeClick(Sender: TObject);
begin
  ManipularCampos;
end;

procedure TfrmAltProdutos.btnAnteriorClick(Sender: TObject);
begin
  bufClientes.Prior;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltProdutos.btnAplicarClick(Sender: TObject);
var
  resultado: boolean;
begin
  if Salvar then
    ModalResult:= mrOK;
end;

procedure TfrmAltProdutos.btnCancelarClick(Sender: TObject);
begin
  HabilitarDesabilitarControles(self);
  btnAplicar.Kind    := bkClose;
  btnAplicar.Caption := '&Fechar';
  RestaurarValores(self,FListas);
end;

procedure TfrmAltProdutos.LocalizarRegistro(Codigo: Integer);
begin
  bufClientes.Locate('id',Codigo,[]);
  CarregarDados;
end;

procedure TfrmAltProdutos.CarregarDados;
begin
  with bufClientes do
  begin
    edtCodigo.Text       := inttostr(FieldByName('id').AsInteger);
    edtNome.Text         := FieldByName('nome').AsString;
    cedPVP.Value         := FieldByName('preco_venda_promocao').AsCurrency;
    cedPUC.Value         := FieldByName('preco_ultima_compra').AsCurrency;
    cedPVN.Value         := FieldByName('preco_venda_normal').AsCurrency;
    edtEstoque.Text      := IntToStr(FieldByName('estoque').AsInteger);
    cedEstoque_PVN.Value := (FieldByName('estoque').AsInteger * FieldByName('preco_venda_normal').AsCurrency);
    idRegistro           := FieldByName('id').AsInteger;
  end;
end;

procedure TfrmAltProdutos.ManipularCampos;
begin
  HabilitarDesabilitarControles(self, false);
  btnAplicar.Kind    := bkOK;
  btnAplicar.Caption := '&Aplicar';
  FListas := PreencherListas(self);
end;


end.

