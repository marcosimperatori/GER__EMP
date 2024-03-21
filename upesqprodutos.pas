unit upesqprodutos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, DBGrids, ZDataset;

type

  { TfrmPesqProdutos }

  TfrmPesqProdutos = class(TForm)
    BitBtn1: TBitBtn;
    bufPessoas: TBufDataset;
    dsPessoas: TDataSource;
    DBGrid1: TDBGrid;
    edtPesquisa: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure edtPesquisaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FId: Integer;
    FNome: String;
    FValor: Currency;
    procedure ListaProdutos;
  public
    property IdProduto: Integer read FId write FId;
    property NomeProd: String read FNome write FNome;
    property VlrUnit: Currency read FValor write FValor;
  end;

var
  frmPesqProdutos: TfrmPesqProdutos;

implementation

{$R *.lfm}

uses utilitarios, queries;

{ TfrmPesqProdutos }

procedure TfrmPesqProdutos.FormShow(Sender: TObject);
begin
  ListaProdutos;
end;

procedure TfrmPesqProdutos.DBGrid1CellClick(Column: TColumn);
begin
  IdProduto := bufPessoas.FieldByName('id').AsInteger;
  NomeProd  := bufPessoas.FieldByName('nome').AsString;
  VlrUnit   := bufPessoas.FieldByName('preco_venda_normal').AsCurrency;
end;

procedure TfrmPesqProdutos.edtPesquisaChange(Sender: TObject);
begin
  ListaProdutos;
end;

procedure TfrmPesqProdutos.ListaProdutos;
var
  qr: TZQuery;
begin
  try
    qr := NovaQuery;
    with qr do
    begin
      sql.text := listarProdutos + ' WHERE UPPER(p.nome) LIKE UPPER(:busca)';
      ParamByName('busca').AsString:= '%' + Trim(edtPesquisa.text) + '%';
      Open;
      bufPessoas.Clear;
      bufPessoas.CopyFromDataset(qr);
      bufPessoas.First;
    end;
  finally
    qr.Free
  end;
end;

end.

