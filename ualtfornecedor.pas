unit ualtfornecedor;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBCtrls,
  Buttons, ComCtrls, StdCtrls, DBGrids, ActnList, umdl, DB, BufDataset, queries,
  ZDataset, utilitarios;

type

  { TfrmAltFornecedor }

  TfrmAltFornecedor = class(TForm)
    btnAnterior: TSpeedButton;
    btnCancelar: TBitBtn;
    btnAplicar: TBitBtn;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnPrimeiro: TSpeedButton;
    btnProximo: TSpeedButton;
    btnUltimo: TSpeedButton;
    bufTelefones: TBufDataset;
    bufFornecedor: TBufDataset;
    cbxUf: TComboBox;
    dsTelefones: TDataSource;
    DBText2: TLabel;
    edtMunicipio: TEdit;
    edtLogradouro: TEdit;
    edtNumero: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtCep: TEdit;
    DBGrid1: TDBGrid;
    edtCpfCnpj: TEdit;
    edtApelido: TEdit;
    edtNome: TEdit;
    edtCodigo: TEdit;
    GroupBox1: TGroupBox;
    imgCadastros: TImageList;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    lblCodigo: TLabel;
    lblNome: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    btnInserir: TSpeedButton;
    panNavegacao: TPanel;
    rgpTipoPessoa: TRadioGroup;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure btnAnteriorClick(Sender: TObject);
    procedure btnAplicarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnPrimeiroClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    procedure edtApelidoClick(Sender: TObject);
    procedure edtCpfCnpjKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FEdicao: boolean;
    FId: Integer;
    FQuery: TZQuery;
    FListas: TListas;
    function CpfJaExiste(AInscricao: String): boolean;
    procedure ManipularCampos;
    function Salvar: boolean;
    procedure LocalizarRegistro(Codigo: Integer);
    procedure CarregarDados;
    procedure ListarTelefones(idRegistro: Integer);
    procedure SalvarTelefones(qry: Tzquery; IdRegistro: Integer);
  public
    property idRegistro: Integer read FId write FId;
    property modoEdicao: boolean read FEdicao write FEdicao;
  end;

var
  frmAltFornecedor: TfrmAltFornecedor;

implementation

{$R *.lfm}

uses
  ualttelefones;

{ TfrmAltFornecedor }

procedure TfrmAltFornecedor.FormShow(Sender: TObject);
begin
  if modoEdicao then
    LocalizarRegistro(idRegistro);

  HabilitarDesabilitarControles(Self);
end;

function TfrmAltFornecedor.CpfJaExiste(AInscricao: String): boolean;
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

function TfrmAltFornecedor.Salvar: boolean;
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
          sql.Text := atualizaFornecedor;
          ParamByName('id').AsInteger := idRegistro;
        end
        else
          sql.Text:= insereFornecedor;

        ParamByName('nome').asString        := edtNome.Text;
        ParamByName('apelido').asString     := edtApelido.text;
        ParamByName('cpfcnpj').asString     := edtCpfCnpj.text;
        ParamByName('cidade').asString      := edtMunicipio.text;
        ParamByName('uf').asString          := cbxUf.Text;
        ParamByName('bairro').asString      := edtBairro.text;
        ParamByName('logradouro').asString  := edtLogradouro.text;
        ParamByName('numero').asString      := edtNumero.text;
        ParamByName('complemento').asString := edtComplemento.text;

        if rgpTipoPessoa.ItemIndex = 0 then
          ParamByName('pessoa').asString    := 'F'
        else
          ParamByName('pessoa').asString    := 'J';

        Open;
        codigo:= fields[0].AsInteger;

        if not bufTelefones.IsEmpty then
        begin
          SalvarTelefones(qry,codigo);
        end;

        Connection.Commit;
        result := true;
      except
        on e: exception do
        begin
          ShowMessage(e.Message);
          Connection.Rollback;
          result := false;
        end;
      end;
    end;
  finally
    qry.Free;
  end;
end;

procedure TfrmAltFornecedor.btnPrimeiroClick(Sender: TObject);
begin
  bufFornecedor.First;
  LocalizarRegistro(bufFornecedor.FieldByName('id').AsInteger);
end;

procedure TfrmAltFornecedor.btnProximoClick(Sender: TObject);
begin
   bufFornecedor.Next;
  LocalizarRegistro(bufFornecedor.FieldByName('id').AsInteger);
end;

procedure TfrmAltFornecedor.btnUltimoClick(Sender: TObject);
begin
  bufFornecedor.Last;
  LocalizarRegistro(bufFornecedor.FieldByName('id').AsInteger);
end;

procedure TfrmAltFornecedor.edtApelidoClick(Sender: TObject);
begin
  ManipularCampos;
end;

procedure TfrmAltFornecedor.edtCpfCnpjKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8, #13]) then
    Key := #0;
end;

procedure TfrmAltFornecedor.FormCreate(Sender: TObject);
begin
  lblCodigo.Caption :='';
  lblNome.Caption   := '';
end;

procedure TfrmAltFornecedor.btnAnteriorClick(Sender: TObject);
begin
  bufFornecedor.Prior;
  LocalizarRegistro(bufFornecedor.FieldByName('id').AsInteger);
end;

procedure TfrmAltFornecedor.btnAplicarClick(Sender: TObject);
var
  resultado: boolean;
begin
  resultado := false;

  if Trim(edtCpfCnpj.Text) <> '' then
  begin
    if CpfJaExiste(Trim(edtCpfCnpj.Text)) then
    begin
      if MessageDlg('O CPF/CNPJ já está vinculado a outro registro, deseja continuar assim mesmo?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
        resultado := Salvar;
    end;
    exit;
  end
  else
   resultado := Salvar;

  if resultado then
    ModalResult:= mrOK;
end;

procedure TfrmAltFornecedor.btnCancelarClick(Sender: TObject);
begin
  HabilitarDesabilitarControles(self);
  btnAplicar.Kind    := bkClose;
  btnAplicar.Caption := '&Fechar';
  RestaurarValores(self,FListas);
end;

procedure TfrmAltFornecedor.btnInserirClick(Sender: TObject);
begin
  with TfrmAltTelefones.create(self) do
  try
    if ShowModal = mrok then
    begin
      with bufTelefones do
      begin
        Append;
        FieldByName('id').AsInteger       := Telefone.id;
        FieldByName('area').AsString      := Telefone.area;
        FieldByName('numero').AsString    := Telefone.numero;
        FieldByName('aparelho').AsString  := Telefone.aparelho;
        FieldByName('descricao').AsString := Telefone.descricao;
        Post;
      end;
    end;
  finally
    free;
  end;
end;

procedure TfrmAltFornecedor.LocalizarRegistro(Codigo: Integer);
begin
  bufFornecedor.Locate('id',Codigo,[]);
  CarregarDados;
end;

procedure TfrmAltFornecedor.CarregarDados;
begin
  with bufFornecedor do
  begin
    edtCodigo.Text      := inttostr(FieldByName('id').AsInteger);
    edtNome.Text        := FieldByName('nome').AsString;
    edtLogradouro.Text  := FieldByName('logradouro').AsString;
    edtNumero.Text      := FieldByName('numero').AsString;
    edtComplemento.Text := FieldByName('complemento').AsString;
    edtBairro.Text      := FieldByName('bairro').AsString;
    edtMunicipio.Text   := FieldByName('cidade').AsString;
    cbxUf.Text          := FieldByName('uf').AsString;
    lblCodigo.Caption   := edtCodigo.Text;
    lblNome.Caption     := edtNome.Text;

    if FieldByName('tipo_pessoa').AsString = 'F' then
      rgpTipoPessoa.ItemIndex:= 0
    else
      rgpTipoPessoa.ItemIndex:= 1;

    idRegistro := FieldByName('id').AsInteger;
  end;
  ListarTelefones(bufFornecedor.FieldByName('id').AsInteger);
end;

procedure TfrmAltFornecedor.ListarTelefones(idRegistro: Integer);
var
  qr: TZQuery;
begin
  qr := NovaQuery;
  with qr do
  begin
    sql.text := 'select t.* from telefones t where t.id_pessoa=:idPessoa';
    ParamByName('idpessoa').AsInteger:= idRegistro;
    Open;
  end;

  with bufTelefones do
  begin
    DisableControls;
    clear;
    CopyFromDataset(qr);
    First;
    EnableControls;
  end;
  qr.Free;
end;

procedure TfrmAltFornecedor.SalvarTelefones(qry: Tzquery;IdRegistro: Integer);
begin
  with qry do
  begin
    with bufTelefones do
    begin
      first;
      while not eof do
      begin
        qry.sql.text := inserirTelefone;

        if FieldByName('id').AsInteger = 0 then
          qry.ParamByName('id').Clear
        else
          qry.ParamByName('id').AsInteger := FieldByName('id').AsInteger;

        qry.ParamByName('pessoa').AsInteger   := IdRegistro;
        qry.ParamByName('area').AsString      := FieldByName('area').AsString;
        qry.ParamByName('numero').AsString    := FieldByName('numero').AsString;
        qry.ParamByName('aparelho').AsString  := FieldByName('aparelho').AsString;
        qry.ParamByName('descricao').AsString := FieldByName('descricao').AsString;
        qry.ExecSQL;
        next;
      end;
    end;
  end;
end;


procedure TfrmAltFornecedor.ManipularCampos;
begin
  HabilitarDesabilitarControles(self, false);
  btnAplicar.Kind    := bkOK;
  btnAplicar.Caption := '&Aplicar';
  FListas := PreencherListas(self);
end;


end.

