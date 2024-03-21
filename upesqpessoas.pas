unit upesqpessoas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, DBGrids, ZDataset;

type

  { TfrmPesqPessoas }

  TfrmPesqPessoas = class(TForm)
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
    FRelacao: Boolean;
    procedure ListarPessoas;
  public
    property IdPessoa: Integer read FId write FId;
    property NomePes: String read FNome write FNome;
    property Cliente: Boolean read FRelacao write FRelacao;
  end;

var
  frmPesqPessoas: TfrmPesqPessoas;

implementation

{$R *.lfm}

uses utilitarios, queries;

{ TfrmPesqPessoas }

procedure TfrmPesqPessoas.FormShow(Sender: TObject);
begin
  ListarPessoas;
end;

procedure TfrmPesqPessoas.DBGrid1CellClick(Column: TColumn);
begin
  IdPessoa := bufPessoas.FieldByName('id').AsInteger;
  NomePes  := bufPessoas.FieldByName('nome').AsString;
end;

procedure TfrmPesqPessoas.edtPesquisaChange(Sender: TObject);
begin
  ListarPessoas;
end;

procedure TfrmPesqPessoas.ListarPessoas;
var
  qr: TZQuery;
  stringSql: String;
begin
  if Cliente then
    stringSql := listarClientes
  else
    stringSql := listarFornecedores;

  try
    qr := NovaQuery;
    with qr do
    begin
      sql.text := stringSql + ' AND UPPER(p.nome) LIKE UPPER(:busca)';
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

