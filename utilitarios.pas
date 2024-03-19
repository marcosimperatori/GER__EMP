unit utilitarios;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, StdCtrls, Controls, ZDataset, umdl, rxcurredit,
  ExtCtrls, Buttons;

type
  TListas = record
    ValoresAntigos: TStringList;
    ValoresOriginais: TStringList;
  end;

function NovaQuery: TZQuery;
function StringToDecimal(AValor: String):Double;
procedure HabilitarDesabilitarControles(AForm: TForm; Ativado: boolean = true);
function PreencherListas(AForm: TForm): TListas;
procedure RestaurarValores(AForm: TForm; const Listas: TListas);

implementation


function NovaQuery: TZQuery;
begin
  result            := TZQuery.create(nil);
  result.Connection := dmGerEmp.conexao;
end;

function StringToDecimal(AValor: String): Double;
var
  temp: String;
begin
  temp := StringReplace(AValor,'.','',[rfReplaceAll]);
  result := StrToFloat(temp);
end;

procedure HabilitarDesabilitarControles(AForm: TForm; Ativado: boolean = true);
var
  i: Integer;
begin
  for i := 0 to AForm.ComponentCount -1 do
  begin
    if AForm.Components[i] is TEdit then
    begin
      if ((AForm.Components[i] as TEdit).Tag = 1) then
        (AForm.Components[i] as TEdit).ReadOnly := Ativado;
    end
    else if AForm.Components[i] is TCurrencyEdit then
    begin
      if ((AForm.Components[i] as TCurrencyEdit).Tag = 1) then
        (AForm.Components[i] as TCurrencyEdit).ReadOnly := Ativado
    end
    else if AForm.Components[i] is TPanel then
    begin
      if ((AForm.Components[i] as TPanel).Tag = 1) then
        (AForm.Components[i] as TPanel).Enabled := Ativado
    end;
  end;
end;

function PreencherListas(AForm: TForm): TListas;
var
  i: Integer;
  ctrl: TControl;
begin
  try
    Result.ValoresAntigos := TStringList.Create;
    Result.ValoresOriginais := TStringList.Create;

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      ctrl := TControl(AForm.Components[i]);
      if (ctrl is TEdit) or (ctrl is TCurrencyEdit) then
      begin
        Result.ValoresAntigos.Values[ctrl.Name] := TCustomEdit(ctrl).Text;
        Result.ValoresOriginais.Values[ctrl.Name] := TCustomEdit(ctrl).Text;
      end;
    end;
  except
    Result.ValoresAntigos.Free;
    Result.ValoresOriginais.Free;
  end;
end;

procedure RestaurarValores(AForm: TForm; const Listas: TListas);
var
  i: Integer;
  ctrl: TControl;
begin
  try
    for i := 0 to AForm.ComponentCount - 1 do
    begin
      ctrl := TControl(AForm.Components[i]);
      if (ctrl is TEdit) or (ctrl is TCurrencyEdit) then
      begin
        if Listas.ValoresAntigos.IndexOfName(ctrl.Name) <> -1 then
        begin
          if ctrl is TEdit then
            TCustomEdit(ctrl).Text := Listas.ValoresAntigos.Values[ctrl.Name]
          else if ctrl is TCurrencyEdit then
            TCurrencyEdit(ctrl).Value := StrToCurr(Listas.ValoresAntigos.Values[ctrl.Name]);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
    end;
  end;
end;


end.

