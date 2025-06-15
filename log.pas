//http://theclub.com.br/Restrito/Revistas/201507/mani1507.aspx
unit log;

interface

uses principal,
  Windows, Messages, SysUtils, Classes, ComCtrls,  System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, StrUtils;

 procedure ListarArquivos(Diretorio: string; Sub: Boolean);
 function TemAtributo(Attr, Val : Integer): Boolean;

implementation

 procedure ListarArquivos(Diretorio: string; Sub: Boolean);
var
   F: TSearchRec;
   Ret: Integer;
   TempNome : string;

begin
  Ret := FindFirst(Diretorio+'\*.*', faAnyFile, F);
  try
    while Ret = 0 do
    begin
      if TemAtributo(F.Attr, faDirectory) then
      begin
        if (F.Name <> '.') And (F.Name <> '..') then
          if Sub = True then
          begin
            TempNome := Diretorio+'\' + F.Name;
            ListarArquivos(TempNome, True);
          end;
      end
      else
      begin
        if not ContainsText(Diretorio, 'node_modules') then
           Form2.memLista.Lines.Add(Diretorio+'\'+F.Name);
      end;
        Ret := FindNext(F);
    end;
  finally
  begin
    FindClose(F);
  end;
end;
end;

 function TemAtributo(Attr, Val: Integer): Boolean;
 begin
  Result := Attr and Val = Val;
 end;

end.

