unit ualtpessoas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBCtrls,
  Buttons, ComCtrls, StdCtrls, DBGrids, ActnList, umdl, DB, BufDataset, queries,
  ZDataset, utilitarios;

type

  { TfrmAltPessoa }

  TfrmAltPessoa = class(TForm)
    btnAnterior: TSpeedButton;
    btnCancelar: TBitBtn;
    btnAplicar: TBitBtn;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnInserir: TSpeedButton;
    btnPrimeiro: TSpeedButton;
    btnProximo: TSpeedButton;
    btnUltimo: TSpeedButton;
    bufTelefones: TBufDataset;
    bufPessoa: TBufDataset;
    cbxCliente: TCheckBox;
    cbxFornecedor: TCheckBox;
    cbxUf: TComboBox;
    cbxSexo: TComboBox;
    DBGrid1: TDBGrid;
    dsTelefones: TDataSource;
    DBText2: TLabel;
    edtReferencia: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    edtPais: TEdit;
    edRg: TEdit;
    edtEmail: TEdit;
    edtWebsite: TEdit;
    edtData: TEdit;
    edtApelido: TEdit;
    edtBairro: TEdit;
    edtCep: TEdit;
    edtCodigo: TEdit;
    edtComplemento: TEdit;
    edtCpfCnpj: TEdit;
    edtLogradouro: TEdit;
    edtMunicipio: TEdit;
    edtNome: TEdit;
    edtNumero: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Image1: TImage;
    imgCadastros: TImageList;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    panNavegacao: TPanel;
    rgpTipoPessoa: TRadioGroup;
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
  frmAltPessoa: TfrmAltPessoa;

implementation

{$R *.lfm}

uses
  ualttelefones;

{ TfrmAltPessoa }

procedure TfrmAltPessoa.FormShow(Sender: TObject);
begin
  if modoEdicao then
    LocalizarRegistro(idRegistro);

  HabilitarDesabilitarControles(Self);
end;

function TfrmAltPessoa.CpfJaExiste(AInscricao: String): boolean;
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

function TfrmAltPessoa.Salvar: boolean;
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

procedure TfrmAltPessoa.btnPrimeiroClick(Sender: TObject);
begin
  bufPessoa.First;
  LocalizarRegistro(bufPessoa.FieldByName('id').AsInteger);
end;

procedure TfrmAltPessoa.btnProximoClick(Sender: TObject);
begin
   bufPessoa.Next;
  LocalizarRegistro(bufPessoa.FieldByName('id').AsInteger);
end;

procedure TfrmAltPessoa.btnUltimoClick(Sender: TObject);
begin
  bufPessoa.Last;
  LocalizarRegistro(bufPessoa.FieldByName('id').AsInteger);
end;

procedure TfrmAltPessoa.edtApelidoClick(Sender: TObject);
begin
  ManipularCampos;
end;

procedure TfrmAltPessoa.edtCpfCnpjKeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', #8, #13]) then
    Key := #0;
end;

procedure TfrmAltPessoa.FormCreate(Sender: TObject);
begin
  edtData.Text:= DateTimeToStr(now);
end;

procedure TfrmAltPessoa.btnAnteriorClick(Sender: TObject);
begin
  bufPessoa.Prior;
  LocalizarRegistro(bufPessoa.FieldByName('id').AsInteger);
end;

procedure TfrmAltPessoa.btnAplicarClick(Sender: TObject);
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

procedure TfrmAltPessoa.btnCancelarClick(Sender: TObject);
begin
  HabilitarDesabilitarControles(self);
  btnAplicar.Kind    := bkClose;
  btnAplicar.Caption := '&Fechar';

  if FListas.ValoresAntigos.Count > 0 then;
  RestaurarValores(self,FListas);
end;

procedure TfrmAltPessoa.btnInserirClick(Sender: TObject);
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

procedure TfrmAltPessoa.LocalizarRegistro(Codigo: Integer);
begin
  bufPessoa.Locate('id',Codigo,[]);
  CarregarDados;
end;

procedure TfrmAltPessoa.CarregarDados;
begin
  with bufPessoa do
  begin
    edtCodigo.Text      := inttostr(FieldByName('id').AsInteger);
    edtNome.Text        := FieldByName('nome').AsString;
    edtLogradouro.Text  := FieldByName('logradouro').AsString;
    edtNumero.Text      := FieldByName('numero').AsString;
    edtComplemento.Text := FieldByName('complemento').AsString;
    edtBairro.Text      := FieldByName('bairro').AsString;
    edtMunicipio.Text   := FieldByName('cidade').AsString;
    cbxUf.Text          := FieldByName('uf').AsString;

    if FieldByName('cliente').AsInteger = 1 then
      cbxCliente.Checked  := true
    else
       cbxCliente.Checked := false;

     if FieldByName('fornecedor').AsInteger = 1 then
      cbxFornecedor.Checked  := true
    else
       cbxFornecedor.Checked := false;

    if FieldByName('tipo_pessoa').AsString = 'F' then
      rgpTipoPessoa.ItemIndex:= 0
    else
      rgpTipoPessoa.ItemIndex:= 1;

    idRegistro := FieldByName('id').AsInteger;
  end;
  ListarTelefones(bufPessoa.FieldByName('id').AsInteger);
end;

procedure TfrmAltPessoa.ListarTelefones(idRegistro: Integer);
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

procedure TfrmAltPessoa.SalvarTelefones(qry: Tzquery;IdRegistro: Integer);
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


procedure TfrmAltPessoa.ManipularCampos;
begin
  HabilitarDesabilitarControles(self, false);
  btnAplicar.Kind    := bkOK;
  btnAplicar.Caption := '&Aplicar';
  FListas := PreencherListas(self);
end;


end.

