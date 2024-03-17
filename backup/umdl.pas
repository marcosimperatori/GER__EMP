unit umdl;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset, ZSqlUpdate, IniFiles,uprincipal;

type

  { TdmGerEmp }

  TdmGerEmp = class(TDataModule)
    conexao: TZConnection;
    qryClientes: TZQuery;
  private

  public

  end;

var
  dmGerEmp: TdmGerEmp;

implementation

{$R *.lfm}

end.

