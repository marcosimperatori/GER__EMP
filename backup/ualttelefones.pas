unit ualttelefones;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  TTelefone = record
    id: Integer;
    pessoa: Integer;
    area: String;
    numero: String;
    aparelho: String;
    descricao: String;
  end;

  { TfrmAltTelefones }

  TfrmAltTelefones = class(TForm)
    btnCancelar: TBitBtn;
    btnSalvar: TBitBtn;
    cbxAparelho: TComboBox;
    edtArea: TEdit;
    edtNumero: TEdit;
    edtDescricao: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure btnSalvarClick(Sender: TObject);
  private
    FTelefone: TTelefone;

  public
    property Telefone: TTelefone read FTelefone write FTelefone;
  end;

var
  frmAltTelefones: TfrmAltTelefones;

implementation

{$R *.lfm}

{ TfrmAltTelefones }

procedure TfrmAltTelefones.btnSalvarClick(Sender: TObject);
begin
  with Telefone do
  begin
    id        := 0;
    area      := edtArea.text;
    numero    := edtNumero.text;
    aparelho  := cbxAparelho.text;
    descricao := edtDescricao.text;
  end;
end;

end.

