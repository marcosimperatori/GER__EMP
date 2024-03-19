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
  Forms, rxnew, zcomponent, uprincipal, ualtfornecedor, umdl, utilitarios,
  queries, ucadfornecedores, ubusca, uselecionar, lazreportpdfexport,
  uprepararelatorio, ualttelefones, ucadprodutos
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

