unit insereDetalhes;

interface

Uses principal,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls, ExtCtrls, System.IOUtils;

  procedure salvar_inserirDetalhes();

implementation

procedure salvar_inserirDetalhes();
var
  EJS: TStringList;
  caminho, subpasta, subdir: string;
  Handle: THandle;
begin
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    subdir := '/Views';
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+ '\inserirDetalhes.ejs';;
    EJS := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+ '\inserirDetalhes.ejs';

EJS.Add('<!DOCTYPE html>  ');
EJS.Add('<html lang="pt-br"> ');
EJS.Add('<head> <!--inclui cabeçalho do html -->  ');
EJS.Add('  <%- include("bootstrap.ejs"); %> ');
EJS.Add('</head>  ');
EJS.Add('<body class="container">  ');
EJS.Add('<header> <!--inclui head do html, carrega bootstrap --> ');
EJS.Add('  <%- include("cabecalho.ejs"); %> ');
EJS.Add('</header> ');
EJS.Add('<main> ');
EJS.Add('</main> ');
EJS.Add('<div class="card">     ');
EJS.Add('<div class="card-header">  <h4>Inserir na Tabela Detalhes</h4> </div>    ');
EJS.Add(' <div class="card-body">   ');
EJS.Add(' <!-- <form> Consulta a Tabela Mestre  -->  ');
EJS.Add('<div class="form-row"> ');
    //busca nome campos da tabela Mestre
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       EJS.Add('<div class="col"> ');
       EJS.Add('<label>' +Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ '</label>  ');
       EJS.Add('<input type="text" class="form-control" name="'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+'" value="<%= '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+' %> " readonly="readonly">   ');
       EJS.Add('</div> ');
       Form2.FDQuery3.next;
     end;
EJS.Add(' <!-- fim </form> para consulta em Mestre --> ');
EJS.Add('</div> ');
EJS.Add('</div> ');
EJS.Add('<!-- Form para inclusao de nova regisgro Detalhes para Mestre --> ');
EJS.Add('<div class="card-body"> ');
EJS.Add('<form  action="/inserirDetalhes" method="post"> ');
EJS.Add('<table class="table table-success table-striped"> ');
EJS.Add('<tr>  ');
EJS.Add('<td colspan="2">Detalhes para tabela Mestre</td> ');
EJS.Add('</tr> ');
    //busca nome campos da tabela Detalhes
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
       //se campo diferente da chave primaria da tabela Detalhes inclui campos no .ejs
       if  (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
       begin
        if (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'MUL')<>0) then
        begin
         EJS.Add('<tr>  ');
         EJS.Add('<td>' +Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ '</td> ');
         EJS.Add('<td><input class="form-control" type="text" name="'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+'" value="<%= '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+' %>" /></td>');
         EJS.Add('</tr> ');
       end;
       end;
       Form2.FDQuery4.next;
     end;
EJS.Add('<tr>  ');
EJS.Add('<td colspan="2">  ');
EJS.Add('<input class="btn btn-primary" type="submit" name="btIncuirPub" value="Inserir"/>  ');
EJS.Add('<a class="btn btn-link" href="/">Voltar </a>  ');
EJS.Add('</td>  ');
EJS.Add('</tr> ');
EJS.Add('</table> ');
EJS.Add('</form> ');
EJS.Add('</div> ');
EJS.Add('</div> ');
EJS.Add(' ');
EJS.Add('<footer> <!--inclui rodapé do html -->   ');
EJS.Add('  <%- include("rodape.ejs"); %>    ');
EJS.Add('</footer>  ');
EJS.Add('</body>   ');
EJS.Add('</html>  ');
EJS.SaveToFile(caminho);
//ShellExecute(Handle, 'open', Pchar(caminho), nil, nil, SW_SHOWMAXIMIZED);
  finally
FreeAndNil(EJS);
  end;
end;

end.
