unit upedidos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ActnList, Menus, DBGrids, ExtCtrls, Buttons, ZDataset;

type

  { TfrmPedidos }

  TfrmPedidos = class(TForm)
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
    dsCadastros: TDataSource;
    DBGrid1: TDBGrid;
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
  private
    FQuery: TZQuery;
    procedure Listar;
  public
    property qrConsulta: TZQuery read FQuery write FQuery;
  end;

var
  frmPedidos: TfrmPedidos;

implementation

{$R *.lfm}

uses
  ualtfornecedor, utilitarios, queries, ubusca, uselecionar,
  uprepararelatorio;

{ TfrmPedidos }

procedure TfrmPedidos.actInserirRegistroExecute(Sender: TObject);
begin
  with TfrmAltFornecedor.create(self) do
  try
    modoEdicao := false;
    if ShowModal = mrOK then
    begin
      qrConsulta.SQL.Text:= listarFornecedores;
      actAtualizar.Execute;
    end;
  finally
    Free;
  end;
end;

procedure TfrmPedidos.actOrdenarExecute(Sender: TObject);
begin
  bufCadastros.IndexFieldNames:='nome';
end;

procedure TfrmPedidos.actRelatoriosExecute(Sender: TObject);
begin
  with TfrmRelatorio.Create(self) do
  try
    NomeTabela:= 'pessoas';
    NomeRelatorio:='rel_pessoas';
    RegistroAtual:= bufCadastros.FieldByName('id').AsInteger;
    bufTemporario.CopyFromDataset(bufCadastros);
    ShowModal;
  finally
    free;
  end;
end;

procedure TfrmPedidos.actSelecionarExecute(Sender: TObject);
begin
  with TfrmSelecionar.create(self) do
  try
    if ShowModal = mrOK then
    begin
      qrConsulta.SQL.Clear;
      qrConsulta.SQL.Text := (listarFornecedores + sqlComplemento);
      qrConsulta.ParamByName('chave').AsString:= paramBusca;
    end
    else
    begin
      qrConsulta.SQL.Clear;
      qrConsulta.SQL.Text := listarFornecedores;
    end;

    actAtualizar.Execute;
  finally
  end;
end;

procedure TfrmPedidos.DBGrid1DblClick(Sender: TObject);
begin
  actAlterar.Execute;
end;

procedure TfrmPedidos.actAlterarExecute(Sender: TObject);
begin
  with TfrmAltFornecedor.create(self) do
  try
    modoEdicao := true;
    idRegistro := bufCadastros.FieldByName('id').AsInteger;
    bufFornecedor.CopyFromDataset(bufCadastros);
    if ShowModal = mrOK then
    begin
      qrConsulta.SQL.Text:= listarFornecedores;
      actAtualizar.Execute;
    end;
  finally
    Free;
  end;
end;

procedure TfrmPedidos.actAtualizarExecute(Sender: TObject);
begin
  qrConsulta.SQL.Text:= listarFornecedores;
  Listar;
end;

procedure TfrmPedidos.actBuscarExecute(Sender: TObject);
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

procedure TfrmPedidos.actDeletarExecute(Sender: TObject);
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
        qrConsulta.SQL.Text:= listarFornecedores;
        actAtualizar.Execute;
      except
        MessageDlg('Não foi possível excluir o registro!', mtWarning, [mbOK],0);
      end;
    finally
      qr.Free;
    end;
  end;
end;

procedure TfrmPedidos.FormCreate(Sender: TObject);
begin
  qrConsulta:= NovaQuery;
end;

procedure TfrmPedidos.FormDestroy(Sender: TObject);
begin
  qrConsulta.Free;
end;

procedure TfrmPedidos.FormShow(Sender: TObject);
begin
  qrConsulta.SQL.Text:= listarFornecedores;
  actAtualizar.Execute;
end;

procedure TfrmPedidos.Listar;
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

end.

