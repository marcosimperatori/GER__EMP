unit ualtcompra;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, RxDBGrid, DateTimePicker, utilitarios,
  ZDataset;

type

  { TfrmAltCompra }

  TfrmAltCompra = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnAplicar: TBitBtn;
    btnProcessar: TBitBtn;
    dsItens: TDataSource;
    dtpEmissao: TDateTimePicker;
    edtCpfCnpj: TEdit;
    edtNome: TEdit;
    edtCodigo: TEdit;
    edtCodPessoa: TEdit;
    edtTipo: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    imgProdutos: TImageList;
    lblCodigo: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    lblNome: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    mmoObs: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    RxDBGrid1: TRxDBGrid;
    btnPesqPessoa: TSpeedButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolBar1: TToolBar;
    tbtInserir: TToolButton;
    tbtEditar: TToolButton;
    tbtDeletar: TToolButton;
    procedure btnPesqPessoaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbtInserirClick(Sender: TObject);
  private
    FQuery: TZQuery;
    FTipoPed: String;
    FBufItensPedido: TBufDataset;
    procedure AddItemPedido(AItem: TItemPedido);
    procedure InicializarBufItensPedido;
    function Salvar: boolean;
    function GravarItensPedido(ACodPedido: Integer; AQuery: TZQuery): Currency;
    procedure AtualizarTotalPedido(ACodPedido: Integer; ATotal: Currency;
      AQuery: TZQuery);
    procedure IncrementarEstoque(AProduto,AQtde: Integer;AQuery: TZQuery);
  public
    property tipo_Pedido: String read FTipoPed write FTipoPed;
    property ItensPedido: TBufDataset read FBufItensPedido write FBufItensPedido;
  end;

var
  frmAltCompra: TfrmAltCompra;


implementation

{$R *.lfm}

uses ualtpedidos, queries, upesqpessoas;

{ TfrmAltCompra }

procedure TfrmAltCompra.FormShow(Sender: TObject);
begin
  if tipo_Pedido = 'C' then
    edtTipo.Text := 'Compra'
  else
    edtTipo.Text := 'Venda';

  dtpEmissao.Date := Now;
end;

procedure TfrmAltCompra.FormCreate(Sender: TObject);
begin
  InicializarBufItensPedido;
  FQuery := NovaQuery;
end;

procedure TfrmAltCompra.btnPesqPessoaClick(Sender: TObject);
begin
  with TfrmPesqPessoas.Create(self) do
  try
    Cliente := false;
    if ShowModal = mrOK then
    begin
      edtCodPessoa.Text := inttostr(IdPessoa);
      edtNome.Text      := NomePes;
    end;
  finally
    free;
  end;
end;

procedure TfrmAltCompra.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBufItensPedido);
  FQuery.Free;
end;

procedure TfrmAltCompra.tbtInserirClick(Sender: TObject);
var
  r: TItemPedido;
begin
  with TfrmAltPedidos.Create(self) do
  try
    if ShowModal = mrOK then
      AddItemPedido(Item);
  finally
    free;
  end;
end;

procedure TfrmAltCompra.AddItemPedido(AItem: TItemPedido);
begin
  with FBufItensPedido do
  begin
    Append;
    FieldByName('id').AsInteger         := AItem.IdProduto;
    FieldByName('nome').AsString        := AItem.DescProduto;
    FieldByName('referencia').AsString  := AItem.Referencia;
    FieldByName('quantidade').AsInteger := AItem.Quantidade;
    FieldByName('valor').AsCurrency     := AItem.Valor;
    Post;
  end;
end;

procedure TfrmAltCompra.InicializarBufItensPedido;
begin
  FBufItensPedido := TBufDataset.Create(nil);

  with FBufItensPedido do
  begin
    FieldDefs.Add('iditem', ftInteger);
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('nome', ftString, 255);
    FieldDefs.Add('referencia', ftString, 100);
    FieldDefs.Add('quantidade', ftInteger);
    FieldDefs.Add('valor', ftFloat);
    CreateDataSet;
    IndexFieldNames := 'nome';
    Open;
  end;

  dsItens.DataSet := FBufItensPedido;
end;

function TfrmAltCompra.Salvar: boolean;
var
  idPedido: Integer;
  totalPedido: Currency;
begin
  with FQuery do
  begin
    Connection.StartTransaction;
    try
      SQL.Text:= inserePedido;
      ParamByName('pessoa').AsInteger    := StrToIntDef(Trim(edtCodPessoa.Text),0);
      ParamByName('tipo').asString       := tipo_Pedido;
      ParamByName('emissao').AsDate      := dtpEmissao.Date;
      ParamByName('processado').asString := 'N';
      ParamByName('obs').asString        := mmoObs.Lines.Text;
      ParamByName('cpfcnpj').asString    := edtCpfCnpj.Text;
      ParamByName('valor').AsCurrency    := 0;
      Open;
      idPedido := fields[0].AsInteger;

      //gravar os itens do pedido
      totalPedido := GravarItensPedido(idPedido,FQuery);

      //atualizar pedido com o valor total dos produtos
      AtualizarTotalPedido(idPedido,totalPedido,FQuery);

      Connection.Commit;
      result := true;
    except
      on e: exception do
      begin
        Connection.Rollback;
        result := false;
      end;
    end;
  end;
end;

function TfrmAltCompra.GravarItensPedido(ACodPedido: Integer; AQuery: TZQuery): Currency;
var
  valorProdutos: Currency;
begin
  valorProdutos := 0;
  with AQuery do
  begin
    with FBufItensPedido do
    begin
      First;
      while not eof do
      begin
        SQL.Text:= inserirItensPedido;
        ParamByName('pedido').AsInteger  := ACodPedido;
        AQuery.ParamByName('produto').AsInteger := FieldByName('id').AsInteger;
        AQuery.ParamByName('qtde').AsInteger    := FieldByName('quantidade').AsInteger;
        valorProdutos:= valorProdutos + FieldByName('valor').AsCurrency;
        AQuery.ExecSQL;

        // incrementar estoque
        IncrementarEstoque(FieldByName('id').AsInteger,FieldByName('quantidade').AsInteger,AQuery);
        Next;
      end;
    end;
  end;
  result := valorProdutos;
end;

procedure TfrmAltCompra.AtualizarTotalPedido(ACodPedido: Integer; ATotal: Currency;
  AQuery: TZQuery);
begin
  with AQuery do
  begin
    SQL.Text := atualizarValorTotalPedidos;
    ParamByName('total').AsCurrency := ATotal;
    ParamByName('id').AsInteger := ACodPedido;
    ExecSQL;
  end;
end;

procedure TfrmAltCompra.IncrementarEstoque(AProduto, AQtde: Integer;
  AQuery: TZQuery);
var
  qtdeAtual: Integer;
begin
  qtdeAtual := 0;
  with AQuery do
  begin
    //recupera a quantidade atual de produtos
    SQL.Text := ProdutoQtdePorId;
    ParamByName('id').AsInteger:= AProduto;
    Open;
    qtdeAtual := fields[1].AsInteger;
    qtdeAtual := qtdeAtual + AQtde;

    //incrementar a quantidade de produtos
    SQL.Text := atualizarEstoque;
    ParamByName('qtde').AsInteger := qtdeAtual;
    ParamByName('id').AsInteger   := AProduto;
    ExecSQL;
  end;
end;

end.

