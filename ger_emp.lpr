program ger_emp;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, rxnew, zcomponent, uprincipal, ualtpessoas, umdl,
  utilitarios, queries, upedidos, ubusca, uselecionar, lazreportpdfexport,
  uprepararelatorio, ualttelefones, upessoas, ualtcompra, ualtpedidos, 
upesqprodutos
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TdmGerEmp, dmGerEmp);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.

