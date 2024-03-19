unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, ComCtrls,
  Menus, lr_e_pdf, Translations;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    frTNPDFExport1: TfrTNPDFExport;
    imgPrincipal: TImageList;
    mniTodasAsPessoas: TMenuItem;
    mniFornecedores: TMenuItem;
    mniClientes: TMenuItem;
    ppmConfiguracoes: TPopupMenu;
    ppmRelatorios: TPopupMenu;
    ppmPedidos: TPopupMenu;
    ppmPessoas: TPopupMenu;
    ToolBar1: TToolBar;
    btnPessoas: TToolButton;
    btnProdutos: TToolButton;
    btnPedidos: TToolButton;
    btnRelatorios: TToolButton;
    btnConfiguracoes: TToolButton;
    procedure btnProdutosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mniClientesClick(Sender: TObject);
    procedure mniFornecedoresClick(Sender: TObject);
  private
    procedure AcertarConfiguracao;

  public


  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

uses
  ucadclientes, ucadfornecedores, ucadprodutos;

{ TfrmPrincipal }

procedure TfrmPrincipal.mniClientesClick(Sender: TObject);
begin
  with TfrmClientes.create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.btnProdutosClick(Sender: TObject);
begin
  with TfrmProdutos.create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  AcertarConfiguracao;
end;

procedure TfrmPrincipal.mniFornecedoresClick(Sender: TObject);
begin
  with TfrmFornecedores.create(self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;


procedure TfrmPrincipal.AcertarConfiguracao;
const
  DayNames        : array[1..7]  of string[3] = ('Dom','Seg','Ter','Qua','Qui','Sex','Sab');
  DayLongNames    : array[1..7]  of string[7] = ('Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sabado');
  MonthNames      : array[1..12] of string[3] = ('Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez');
  MonthLongNames  : array[1..12] of string[9] = ('Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro');
var
  i: Integer;
begin
  for i := 1 to 7 do
  begin
    ShortDayNames[i] := DayNames[i];
    LongDayNames[i]  := DayLongNames[i];
  end;

  for i := 1 to 12 do
  begin
    ShortMonthNames[i] := MonthNames[i];
    LongMonthNames[i]  := MonthLongNames[i];
  end;

   with FormatSettings do
   begin
     ShortDateFormat    := 'dd/mm/yyyy';
     CurrencyString     := 'R$';
     CurrencyFormat     := 0;
     CurrencyDecimals   := 2;
     NegCurrFormat      := 14;
     ThousandSeparator  := '.';
     DecimalSeparator   := ',';
     DateSeparator      := '/';
     TimeSeparator      := ':';
     TimeAMString       := 'AM';
     TimePMString       := 'PM';
     ShortTimeFormat    := 'hh:mm:ss';
   end;
   TranslateUnitResourceStrings('LclStrConsts','lclstrconsts.pt_BR.po','pt_BR','');
end;

end.

