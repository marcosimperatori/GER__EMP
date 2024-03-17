unit utilitarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZDataset, umdl;

function NovaQuery: TZQuery;

implementation


function NovaQuery: TZQuery;
begin
  result            := TZQuery.create(nil);
  result.Connection := dmGerEmp.conexao;
end;

end.

