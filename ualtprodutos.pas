unit ualtprodutos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBCtrls,
  Buttons, ComCtrls, StdCtrls, DBGrids, ActnList, umdl, DB, BufDataset, wformat,
  queries, ZDataset, utilitarios;

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
    DBText2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
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
    procedure btnPrimeiroClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FEdicao: boolean;
    FId: Integer;
    FQuery: TZQuery;
    function CpfJaExiste(AInscricao: String): boolean;
    function Salvar: boolean;
    procedure LocalizarRegistro(Codigo: Integer);
    procedure CarregarDados;
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
  begin
    LocalizarRegistro(idRegistro);
    panNavegacao.Enabled := true;
  end
  else
    panNavegacao.Enabled := false;

  Edit4.text := '1235.50';
  //Edit4.Format := '#0.00';
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
  codigo: Integer;
begin
  qry := NovaQuery;
  try
    with qry do
    begin
      Connection.StartTransaction;
      try
        if modoEdicao then
        begin
          sql.Text := atualizaProduto;
          ParamByName('id').AsInteger := idRegistro;
        end
        else
          sql.Text:= insereProduto;

       // ParamByName('nome').asString        := edtNome.Text;
       // ParamByName('apelido').asString     := edtApelido.text;
       // ParamByName('cpfcnpj').asString     := edtCpfCnpj.text;
       // ParamByName('cidade').asString      := edtMunicipio.text;
       // ParamByName('uf').asString          := cbxUf.Text;
       // ParamByName('bairro').asString      := edtBairro.text;
       // ParamByName('logradouro').asString  := edtLogradouro.text;
       // ParamByName('numero').asString      := edtNumero.text;
       // ParamByName('complemento').asString := edtComplemento.text;
       //
       // if rgpTipoPessoa.ItemIndex = 0 then
       //   ParamByName('pessoa').asString    := 'F'
       // else
       //   ParamByName('pessoa').asString    := 'J';

        Open;
        codigo:= fields[0].AsInteger;

        //salvar telefones vinculando ao registro que acabou de ser salvo

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

procedure TfrmAltProdutos.btnAnteriorClick(Sender: TObject);
begin
  bufClientes.Prior;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltProdutos.btnAplicarClick(Sender: TObject);
var
  resultado: boolean;
begin
  resultado := false;

  //if Trim(edtCpfCnpj.Text) <> '' then
  //begin
  //  if CpfJaExiste(Trim(edtCpfCnpj.Text)) then
  //  begin
  //    if MessageDlg('O CPF/CNPJ já está vinculado a outro registro, deseja continuar assim mesmo?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
  //      resultado := Salvar;
  //  end
  //  else
  //    resultado := Salvar;
  //end
  //else
   resultado := Salvar;

  if resultado then
    ModalResult:= mrOK;
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
    edtCodigo.Text      := inttostr(FieldByName('id').AsInteger);
    edtNome.Text        := FieldByName('nome').AsString;
    //edtLogradouro.Text  := FieldByName('logradouro').AsString;
    //edtNumero.Text      := FieldByName('numero').AsString;
    //edtComplemento.Text := FieldByName('complemento').AsString;
    //edtBairro.Text      := FieldByName('bairro').AsString;
    //edtMunicipio.Text   := FieldByName('cidade').AsString;
    //cbxUf.Text          := FieldByName('uf').AsString;
    //lblCodigo.Caption   := edtCodigo.Text;
    //lblNome.Caption     := edtNome.Text;
    //
    //if FieldByName('tipo_pessoa').AsString = 'F' then
    //  rgpTipoPessoa.ItemIndex:= 0
    //else
    //  rgpTipoPessoa.ItemIndex:= 1;
  end;
end;

end.

