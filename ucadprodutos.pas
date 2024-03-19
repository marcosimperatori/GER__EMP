unit ucadprodutos;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  ComCtrls, ActnList, Menus, DBGrids, ExtCtrls, Buttons, ZDataset;

type

  { TfrmProdutos }

  TfrmProdutos = class(TForm)
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
  frmProdutos: TfrmProdutos;

implementation

{$R *.lfm}

uses
  ualtprodutos, utilitarios, queries, ubusca, uselecionar,
  uprepararelatorio;

{ TfrmProdutos }

procedure TfrmProdutos.actInserirRegistroExecute(Sender: TObject);
begin
  with TfrmAltProdutos.create(self) do
  try
    modoEdicao := false;
    if ShowModal = mrOK then
    begin
      qrConsulta.SQL.Text:= listarProdutos;
      actAtualizar.Execute;
    end;
  finally
    Free;
  end;
end;

procedure TfrmProdutos.actOrdenarExecute(Sender: TObject);
begin
  bufCadastros.IndexFieldNames:='nome';
end;

procedure TfrmProdutos.actRelatoriosExecute(Sender: TObject);
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

procedure TfrmProdutos.actSelecionarExecute(Sender: TObject);
begin
  with TfrmSelecionar.create(self) do
  try
    if ShowModal = mrOK then
    begin
      if sqlComplemento.Contains('and') then
        sqlComplemento:= StringReplace(sqlComplemento,'and','where',[rfReplaceAll,rfIgnoreCase]);
      qrConsulta.SQL.Clear;
      qrConsulta.SQL.Text := (listarProdutos + sqlComplemento);
      qrConsulta.ParamByName('chave').AsString:= paramBusca;
    end
    else
    begin
      qrConsulta.SQL.Clear;
      qrConsulta.SQL.Text := listarProdutos;
    end;

    actAtualizar.Execute;
  finally
  end;
end;

procedure TfrmProdutos.DBGrid1DblClick(Sender: TObject);
begin
  actAlterar.Execute;
end;

procedure TfrmProdutos.actAlterarExecute(Sender: TObject);
begin
  with TfrmAltProdutos.create(self) do
  try
    modoEdicao := true;
    idRegistro := bufCadastros.FieldByName('id').AsInteger;
    bufClientes.CopyFromDataset(bufCadastros);
    if ShowModal = mrOK then
    begin
      qrConsulta.SQL.Text:= listarProdutos;
      actAtualizar.Execute;
    end;
  finally
    Free;
  end;
end;

procedure TfrmProdutos.actAtualizarExecute(Sender: TObject);
begin
  qrConsulta.SQL.Text:= listarProdutos;
  Listar;
end;

procedure TfrmProdutos.actBuscarExecute(Sender: TObject);
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

procedure TfrmProdutos.actDeletarExecute(Sender: TObject);
var
  qr: TZQuery;
begin
  if MessageDlg('Confirma a exclusão do registro?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
  begin
    try
      qr := NovaQuery;
      qr.SQL.Text:= deletarProduto;
      qr.ParamByName('id').AsInteger:= bufCadastros.FieldByName('id').AsInteger;
      try
        qr.ExecSQL;
        MessageDlg('Registro excluído com sucesso!', mtInformation, [mbOK],0);
        qrConsulta.SQL.Text:= listarProdutos;
        actAtualizar.Execute;
      except
        MessageDlg('Não foi possível excluir o registro!', mtWarning, [mbOK],0);
      end;
    finally
      qr.Free;
    end;
  end;
end;

procedure TfrmProdutos.FormCreate(Sender: TObject);
begin
  qrConsulta:= NovaQuery;
end;

procedure TfrmProdutos.FormDestroy(Sender: TObject);
begin
  qrConsulta.Free;
end;

procedure TfrmProdutos.FormShow(Sender: TObject);
begin
  qrConsulta.SQL.Text:= listarProdutos;
  actAtualizar.Execute;
end;

procedure TfrmProdutos.Listar;
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

