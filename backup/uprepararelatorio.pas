unit uprepararelatorio;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, ZDataset;

type

  { TfrmRelatorio }

  TfrmRelatorio = class(TForm)
    btnGerar: TBitBtn;
    bufTemporario: TBufDataset;
    rgpOpcaoRelatorio: TRadioGroup;
    procedure btnGerarClick(Sender: TObject);
  private
    FRegistro: integer;
    procedure RelatorioIndividual;
    procedure RelatorioCompleto;
  public
    property RegistroAtual: integer read FRegistro write FRegistro;
  end;

var
  frmRelatorio: TfrmRelatorio;

implementation

{$R *.lfm}

uses uvisualizardorrelatorio, umdl, utilitarios;

{ TfrmRelatorio }

procedure TfrmRelatorio.btnGerarClick(Sender: TObject);
begin
  if rgpOpcaoRelatorio.ItemIndex = 0 then
    RelatorioIndividual
  else
    RelatorioCompleto;
end;

procedure TfrmRelatorio.RelatorioCompleto;
begin
  with TfrmVisualizador.Create(self) do
  try
    Screen.Cursor := crHourGlass;
    Position := poOwnerFormCenter;
    BorderStyle := bsSizeable;
    RelatorioCompleto(bufTemporario, 'rel_pessoas');
    Screen.Cursor := crDefault;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmRelatorio.RelatorioIndividual;
var
  qr: TZQuery;
begin
  Screen.Cursor := crHourGlass;
  qr := NovaQuery;
  try
    with qr do
    begin
      sql.Text := 'select p.* from pessoas p where p.id = :id';
      ParamByName('id').AsInteger := RegistroAtual;
      Open;
      if not IsEmpty then
      begin
        with TfrmVisualizador.Create(self) do
        try
          Position := poOwnerFormCenter;
          BorderStyle := bsSizeable;
          RelatorioBasico(qr, 'rel_pessoas');
          Screen.Cursor := crDefault;
          ShowModal;
        finally
          Free;
        end;
      end
      else
      begin
        MessageDlg('Não foi possível gerar o relatório!', mtWarning, [mbOK],0);
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    qr.Free;
    Screen.Cursor := crDefault;
  end;
end;

end.
