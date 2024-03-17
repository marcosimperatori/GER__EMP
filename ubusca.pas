unit ubusca;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TfrmBuscar }

  TfrmBuscar = class(TForm)
    btnSelecionar: TBitBtn;
    edtBuscar: TEdit;
    GroupBox1: TGroupBox;
    rgpCampoPesquisa: TRadioGroup;
    procedure btnSelecionarClick(Sender: TObject);
    procedure rgpCampoPesquisaSelectionChanged(Sender: TObject);
  private
    FBusca: String;
    FCampo: String;
    procedure CapturaSelecaoUsuario;
  public
    property Campo: String read FCampo write FCampo;
    property Busca: String read FBusca write FBusca;
  end;

var
  frmBuscar: TfrmBuscar;

implementation

{$R *.lfm}

{ TfrmBuscar }

procedure TfrmBuscar.rgpCampoPesquisaSelectionChanged(Sender: TObject);
begin
  if edtBuscar.CanFocus then
    edtBuscar.SetFocus;
end;

procedure TfrmBuscar.btnSelecionarClick(Sender: TObject);
begin
  CapturaSelecaoUsuario;
end;

procedure TfrmBuscar.CapturaSelecaoUsuario;
begin
  if rgpCampoPesquisa.ItemIndex = 0 then
    Campo := 'id'
  else
    Campo := 'nome';

  Busca := Trim(edtBuscar.Text);
  ModalResult := mrOK;
end;

end.

