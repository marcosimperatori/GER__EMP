unit upessoas;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ActnList, Menus, DBGrids, ExtCtrls, Buttons, ZDataset;

const
  PESSOAS      = 1;
  CLIENTES     = 2;
  CLI_FIS      = 21;
  CLI_JUR      = 22;
  FORNECEDORES = 3;
  FOR_FIS      = 31;
  FOR_JUR      = 32;

type

  { TfrmPessoas }

  TfrmPessoas = class(TForm)
    actAcoesMenu: TActionList;
    actInserirRegistro: TAction;
    actCopiarRegistro: TAction;
    actAlterar: TAction;
    actDeletar: TAction;
    actBuscar: TAction;
    actAtualizar: TAction;
    actRelatorios: TAction;
    actSelecionar: TAction;
    actOrdenar: TAction;
    btnSair: TBitBtn;
    bufCadastros: TBufDataset;
    DBGrid1: TDBGrid;
    dsCadastros: TDataSource;
    imgCadastro: TImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    panRodape: TPanel;
    ppmUtilitarios: TPopupMenu;
    ppmCadastros: TPopupMenu;
    Separator1: TMenuItem;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    tvwMenu: TTreeView;
    procedure actAlterarExecute(Sender: TObject);
    procedure actAtualizarExecute(Sender: TObject);
    procedure actBuscarExecute(Sender: TObject);
    procedure actDeletarExecute(Sender: TObject);
    procedure actInserirRegistroExecute(Sender: TObject);
    procedure actOrdenarExecute(Sender: TObject);
    procedure actRelatoriosExecute(Sender: TObject);
    procedure actSelecionarExecute(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tvwMenuClick(Sender: TObject);
  private
    FQuery: TZQuery;
    procedure AlterarConsulta(AOpcao: Integer);
    procedure Listar;
    procedure MontarTreeView;
  public
    property qrConsulta: TZQuery read FQuery write FQuery;
  end;

var
  frmPessoas: TfrmPessoas;

implementation

{$R *.lfm}

uses
  ualtpessoas, utilitarios, queries, ubusca, uselecionar,
  uprepararelatorio;

{ TfrmPessoas }

procedure TfrmPessoas.actInserirRegistroExecute(Sender: TObject);
begin
  with TfrmAltPessoa.create(self) do
  try
    modoEdicao := false;
    if ShowModal = mrOK then
    begin
      qrConsulta.SQL.Text:= listarPessoas;
      actAtualizar.Execute;
    end;
  finally
    Free;
  end;
end;

procedure TfrmPessoas.actOrdenarExecute(Sender: TObject);
begin
  bufCadastros.IndexFieldNames:='nome';
end;

procedure TfrmPessoas.actRelatoriosExecute(Sender: TObject);
begin
  with TfrmRelatorio.Create(self) do
  try
    NomeTabela:= 'produtos';
    NomeRelatorio:='rel_produtos';
    RegistroAtual:= bufCadastros.FieldByName('id').AsInteger;
    bufTemporario.CopyFromDataset(bufCadastros);
    ShowModal;
  finally
    free;
  end;
end;

procedure TfrmPessoas.actSelecionarExecute(Sender: TObject);
begin
  with TfrmSelecionar.create(self) do
  try
    if ShowModal = mrOK then
    begin
      if sqlComplemento.Contains('and') then
        sqlComplemento:= StringReplace(sqlComplemento,'and','where',[rfReplaceAll,rfIgnoreCase]);
      qrConsulta.SQL.Clear;
      qrConsulta.SQL.Text := (listarPessoas + sqlComplemento);
      qrConsulta.ParamByName('chave').AsString:= paramBusca;
    end
    else
    begin
      qrConsulta.SQL.Clear;
      qrConsulta.SQL.Text := listarPessoas;
    end;

    actAtualizar.Execute;
  finally
  end;
end;

procedure TfrmPessoas.DBGrid1DblClick(Sender: TObject);
begin
  actAlterar.Execute;
end;

procedure TfrmPessoas.actAlterarExecute(Sender: TObject);
begin
  with TfrmAltPessoa.create(self) do
  try
    modoEdicao := true;
    idRegistro := bufCadastros.FieldByName('id').AsInteger;
    bufPessoa.CopyFromDataset(bufCadastros);
    if ShowModal = mrOK then
    begin
      qrConsulta.SQL.Text:= listarPessoas;
      actAtualizar.Execute;
    end;
  finally
    Free;
  end;
end;

procedure TfrmPessoas.actAtualizarExecute(Sender: TObject);
begin
  Listar;
end;

procedure TfrmPessoas.actBuscarExecute(Sender: TObject);
var
  cCampo, cValor: String;
begin
  with TfrmBuscar.create(self) do
  try
    if ShowModal = mrOK then
    begin
      cCampo := Campo;
      cValor := Busca;

      if cCampo = 'id' then
        bufCadastros.Locate('id', StrToIntDef(cValor, 0), [])
      else
        bufCadastros.Locate('nome', cValor, [loPartialKey, loCaseInsensitive]);
    end;
  finally
    free;
  end;
end;

procedure TfrmPessoas.actDeletarExecute(Sender: TObject);
var
  qr: TZQuery;
begin
  if MessageDlg('Confirma a exclusão do registro?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
  begin
    try
      qr := NovaQuery;
      qr.SQL.Text:= deletarPessoa;
      qr.ParamByName('id').AsInteger:= bufCadastros.FieldByName('id').AsInteger;
      try
        qr.ExecSQL;
        MessageDlg('Registro excluído com sucesso!', mtInformation, [mbOK],0);
        qrConsulta.SQL.Text:= listarPessoas;
        actAtualizar.Execute;
      except
        MessageDlg('Não foi possível excluir o registro!', mtWarning, [mbOK],0);
      end;
    finally
      qr.Free;
    end;
  end;
end;

procedure TfrmPessoas.FormCreate(Sender: TObject);
begin
  qrConsulta:= NovaQuery;
end;

procedure TfrmPessoas.FormDestroy(Sender: TObject);
begin
  qrConsulta.Free;
end;

procedure TfrmPessoas.FormShow(Sender: TObject);
begin
  MontarTreeView;
  qrConsulta.SQL.Text:= listarPessoas;
  actAtualizar.Execute;
end;

procedure TfrmPessoas.tvwMenuClick(Sender: TObject);
var
  opcao: integer;
begin
  if tvwMenu.Selected = nil then
    exit;

  opcao := PtrInt(TObject(tvwMenu.Selected.Data));
  AlterarConsulta(opcao);
end;

procedure TfrmPessoas.AlterarConsulta(AOpcao: Integer);
begin
  case AOpcao of
    PESSOAS:      qrConsulta.SQL.Text := listarPessoas;
    CLIENTES:     qrConsulta.SQL.Text := listarClientes;
    CLI_FIS:      qrConsulta.SQL.Text := listarClientesFis + QuotedStr('F');
    CLI_JUR:      qrConsulta.SQL.Text := listarClientesJur + QuotedStr('J');
    FORNECEDORES: qrConsulta.SQL.Text := listarFornecedores;
    FOR_FIS:      qrConsulta.SQL.Text := listarFornecedoresFis + QuotedStr('F');
    FOR_JUR:      qrConsulta.SQL.Text := listarFornecedoresJur + QuotedStr('J');
  end;
  actAtualizar.Execute;
end;

procedure TfrmPessoas.Listar;
begin
  with qrConsulta do
  begin
    try
      Open;
    except
      MessageDlg('Não foi possível listar o registros!', mtWarning, [mbOK],0);
    end;
  end;

  with bufCadastros do
  begin
    DisableControls;
    Clear;
    CopyFromDataset(qrConsulta);
    First;
    EnableControls;
  end;
end;

procedure TfrmPessoas.MontarTreeView;
var
 raiz, cliente,fornec,filho: TTreeNode;
begin
  tvwMenu.Items.Clear;
  tvwMenu.BeginUpdate;
  raiz := tvwMenu.Items.Add(nil,'Pessoas');
  raiz.Data:= TObject(PtrInt(PESSOAS));
  raiz.ImageIndex:=9;

  cliente := tvwMenu.Items.AddChild(raiz,'Clientes');
  cliente.Data:= TObject(PtrInt(CLIENTES));
  cliente.ImageIndex := 11;

  filho := tvwMenu.Items.AddChild(cliente,'Física');
  filho.Data:= TObject(PtrInt(CLI_FIS));
  filho.ImageIndex:=10;

  filho := tvwMenu.Items.AddChild(cliente,'Jurídica');
  filho.Data:= TObject(PtrInt(CLI_JUR));
  filho.ImageIndex:=12;

  fornec := tvwMenu.Items.AddChild(raiz,'Fornecedores');
  fornec.Data:= TObject(PtrInt(FORNECEDORES));
  fornec.ImageIndex:=13;

  filho := tvwMenu.Items.AddChild(fornec,'Física');
  filho.Data:= TObject(PtrInt(FOR_FIS));
  filho.ImageIndex:=10;

  filho := tvwMenu.Items.AddChild(fornec,'Jurídica');
  filho.Data:= TObject(PtrInt(FOR_JUR));
  filho.ImageIndex:=12;

  tvwMenu.EndUpdate;
  tvwMenu.AutoExpand:= true;
end;

end.

