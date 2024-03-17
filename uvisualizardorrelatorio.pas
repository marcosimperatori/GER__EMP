unit uvisualizardorrelatorio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms,db, Controls, Graphics, Dialogs, ComCtrls, Buttons,
  ActnList, ExtCtrls, ZDataset, LR_View,LR_Class, LR_DBSet,
  LazFileUtils, lr_e_pdf,BufDataset;

type

  { TfrmVisualizador }

  TfrmVisualizador = class(TForm)
    acSalvar: TAction;
    acSair: TAction;
    acZoomMenos: TAction;
    acZoomMais: TAction;
    acPrimeira: TAction;
    acAnterior: TAction;
    acProxima: TAction;
    acUltima: TAction;
    acProcurar: TAction;
    acImprimir: TAction;
    ActionList1: TActionList;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet1old: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    frDBDataSet3: TfrDBDataSet;
    frDBDataSet4: TfrDBDataSet;
    frPreview1: TfrPreview;
    frReport1: TfrReport;
    frReport2: TfrReport;
    frReport_old: TfrReport;
    exportaPDF: TfrTNPDFExport;
    frTNPDFExport1: TfrTNPDFExport;
    frTNPDFExport2: TfrTNPDFExport;
    ImageList1: TImageList;
    Panel1: TPanel;
    salvarRelatorio: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure acAnteriorExecute(Sender: TObject);
    procedure acImprimirExecute(Sender: TObject);
    procedure acPrimeiraExecute(Sender: TObject);
    procedure acProcurarExecute(Sender: TObject);
    procedure acProximaExecute(Sender: TObject);
    procedure acSairExecute(Sender: TObject);
    procedure acSalvarExecute(Sender: TObject);
    procedure acUltimaExecute(Sender: TObject);
    procedure acZoomMaisExecute(Sender: TObject);
    procedure acZoomMenosExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private

  public
    procedure RelatorioBasico(ZQuery1: TZQuery; FNome: String);
    procedure RelatorioCompleto(ABuf: TBufDataset; FNome: string);
  end;

var
  frmVisualizador: TfrmVisualizador;

implementation

uses umdl;

{$R *.lfm}

{ TfrmVisualizador }

procedure TfrmVisualizador.FormShow(Sender: TObject);
begin
  StatusBar1.Panels[0].text := 'Zoom: ' + FloatToStr(frPreview1.Zoom);
end;

procedure TfrmVisualizador.RelatorioBasico(ZQuery1: TZQuery; FNome: String);
begin
  frDBDataSet1.DataSet := ZQuery1;
  frReport1.LoadFromFile(ExtractFilePath(Application.ExeName) + FNome + '.lrf');
  frReport1.PrepareReport;
  frReport1.ShowReport;
  frPreview1.Zoom:= 110;
end;

procedure TfrmVisualizador.RelatorioCompleto(ABuf: TBufDataset; FNome: string);
begin
  frDBDataSet1.DataSet := ABuf;
  frReport1.LoadFromFile(ExtractFilePath(Application.ExeName) + FNome + '.lrf');
  frReport1.PrepareReport;
  frReport1.ShowReport;
  frPreview1.Zoom:= 110;
end;

procedure TfrmVisualizador.acPrimeiraExecute(Sender: TObject);
begin
  frPreview1.First;
end;

procedure TfrmVisualizador.acProcurarExecute(Sender: TObject);
begin
  frPreview1.Find;
end;

procedure TfrmVisualizador.acProximaExecute(Sender: TObject);
begin
  frPreview1.next;
end;

procedure TfrmVisualizador.acSairExecute(Sender: TObject);
begin
  close;
end;

procedure TfrmVisualizador.acSalvarExecute(Sender: TObject);
begin
  try
  if salvarRelatorio.Execute then
     frPreview1.ExportTo(salvarRelatorio.FileName);
  except
    on e: exception do
       showmessage('Erro ao salvar o relatório');
  end;
end;

procedure TfrmVisualizador.acUltimaExecute(Sender: TObject);
begin
  frPreview1.Last;
end;

procedure TfrmVisualizador.acZoomMaisExecute(Sender: TObject);
begin
  frPreview1.Zoom:= frPreview1.Zoom + 10;
  StatusBar1.Panels[0].text := 'Zoom: ' + FloatToStr(frPreview1.Zoom);
end;

procedure TfrmVisualizador.acZoomMenosExecute(Sender: TObject);
begin
  frPreview1.Zoom:= frPreview1.Zoom - 10;
  StatusBar1.Panels[0].text := 'Zoom: ' + FloatToStr(frPreview1.Zoom);
end;

procedure TfrmVisualizador.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  frReport_old.Free;
  frDBDataSet1old.Free;
  frDBDataSet2.free;
  frDBDataSet3.free;
  frPreview1.Free;
end;

procedure TfrmVisualizador.acAnteriorExecute(Sender: TObject);
begin
  frPreview1.Prev;
end;

procedure TfrmVisualizador.acImprimirExecute(Sender: TObject);
begin
  frPreview1.Print;
end;

end.

