unit ualtclientes;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBCtrls,
  Buttons, ComCtrls, StdCtrls, DBGrids, ActnList, umdl, DB, BufDataset, queries,
  ZDataset, utilitarios;

type

  { TfrmAltClientes }

  TfrmAltClientes = class(TForm)
    btnAnterior: TSpeedButton;
    btnCancelar: TBitBtn;
    btnAplicar: TBitBtn;
    btnEditar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnPrimeiro: TSpeedButton;
    btnProximo: TSpeedButton;
    btnUltimo: TSpeedButton;
    bufClientes: TBufDataset;
    bufTelefones: TBufDataset;
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
    procedure btnPrimeiroClick(Sender: TObject);
    procedure btnProximoClick(Sender: TObject);
    procedure btnUltimoClick(Sender: TObject);
    procedure edtApelidoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FEdicao: boolean;
    FId: Integer;
    FQuery: TZQuery;
    FListas: TListas;
    function CpfJaExiste(AInscricao: String): boolean;
    procedure ListarTelefones(idRegistro: Integer);
    procedure ManipularCampos;
    function Salvar: boolean;
    procedure LocalizarRegistro(Codigo: Integer);
    procedure CarregarDados;
    procedure SalvarTelefones(qry: Tzquery; IdRegistro: Integer);
  public
    property idRegistro: Integer read FId write FId;
    property modoEdicao: boolean read FEdicao write FEdicao;
  end;

var
  frmAltClientes: TfrmAltClientes;

implementation

{$R *.lfm}

{ TfrmAltClientes }

procedure TfrmAltClientes.FormShow(Sender: TObject);
begin
  if modoEdicao then
    LocalizarRegistro(idRegistro);

  HabilitarDesabilitarControles(Self);
end;

function TfrmAltClientes.CpfJaExiste(AInscricao: String): boolean;
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

function TfrmAltClientes.Salvar: boolean;
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
          sql.Text := atualizaCliente;
          ParamByName('id').AsInteger := idRegistro;
        end
        else
          sql.Text:= insereCliente;

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

procedure TfrmAltClientes.btnPrimeiroClick(Sender: TObject);
begin
  bufClientes.First;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltClientes.btnProximoClick(Sender: TObject);
begin
   bufClientes.Next;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltClientes.btnUltimoClick(Sender: TObject);
begin
  bufClientes.Last;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltClientes.edtApelidoClick(Sender: TObject);
begin
  ManipularCampos;
end;

procedure TfrmAltClientes.FormCreate(Sender: TObject);
begin
  lblCodigo.Caption :='';
  lblNome.Caption   := '';
end;

procedure TfrmAltClientes.btnAnteriorClick(Sender: TObject);
begin
  bufClientes.Prior;
  LocalizarRegistro(bufClientes.FieldByName('id').AsInteger);
end;

procedure TfrmAltClientes.btnAplicarClick(Sender: TObject);
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
    end
    else
      resultado := Salvar;
  end
  else
   resultado := Salvar;

  if resultado then
    ModalResult:= mrOK;
end;

procedure TfrmAltClientes.btnCancelarClick(Sender: TObject);
begin
  HabilitarDesabilitarControles(self);
  btnAplicar.Kind    := bkClose;
  btnAplicar.Caption := '&Fechar';
  RestaurarValores(self,FListas);
end;

procedure TfrmAltClientes.LocalizarRegistro(Codigo: Integer);
begin
  bufClientes.Locate('id',Codigo,[]);
  CarregarDados;
end;

procedure TfrmAltClientes.CarregarDados;
begin
  with bufClientes do
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
end;


procedure TfrmAltClientes.ListarTelefones(idRegistro: Integer);
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

procedure TfrmAltClientes.SalvarTelefones(qry: Tzquery;IdRegistro: Integer);
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


procedure TfrmAltClientes.ManipularCampos;
begin
  HabilitarDesabilitarControles(self, false);
  btnAplicar.Kind    := bkOK;
  btnAplicar.Caption := '&Aplicar';
  FListas := PreencherListas(self);
end;


end.

