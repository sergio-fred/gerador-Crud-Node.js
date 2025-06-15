unit insereMestre;

interface

Uses principal,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls, ExtCtrls, System.IOUtils;

  procedure salvar_insereMestre();

implementation

procedure salvar_insereMestre();
var
  EJS: TStringList;
  caminho, subpasta, subdir: string;
  Handle: THandle;
begin
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    subdir := '/Views';
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+ '\inserirMestre.ejs';;
    EJS := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+ '\inserirMestre.ejs';

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
EJS.Add('    <div class="card-header">  ');
EJS.Add('      <ul class="nav nav-pills w-100"> ');
EJS.Add('        <li class="nav-pill active">  ');
//Nome do BD como nome do Sistema
EJS.Add('<h4>Insere na tabela Mestre</h4> ');
EJS.Add('        </li>  ');
EJS.Add('      </ul>  ');
EJS.Add('    </div>  ');
EJS.Add('</main> ');


EJS.Add('<div class="card">     ');
EJS.Add('<div class="card-body">    ');
EJS.Add('<form action="inserirMestre" method="post">    ');

    //busca nome campos da tabela Mestre
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       EJS.Add('<div>   ');
       EJS.Add('<div class="form-group">   ');
       //se campo diferente da chave primaria da tabela mestre inclui campos no .ejs
       if (Form2.FDQuery3.FieldByName('COLUMN_KEY').Value <> 'PRI') then
       begin
         EJS.Add('<label>' +Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ '</label>  ');
         EJS.Add('<input type="text" class="form-control form-control-sm" name="'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+'" value="<%= '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+' %> ">  ');
       end;

       EJS.Add('</div>   ');
       Form2.FDQuery3.next;
     end;
EJS.Add('<!-- Dados para inserir publicação  --> ');
EJS.Add(' <table class="table table-success table-striped">  ');
EJS.Add('<tr>   ');
EJS.Add(' <td colspan="2">Registros Relacionados a tabela Mestre </td>  ');
EJS.Add(' </tr>   ');
  //busca nome campos da tabela Detalhes
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
       EJS.Add('<tr>  ');
        //se campo diferente da chave primaria da tabela Detalhes inclui campos no .ejs
       if (Form2.FDQuery4.FieldByName('COLUMN_KEY').Value <> 'PRI') then
       begin
         EJS.Add('<td>' +Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ '</td> ');
         EJS.Add('<td><input class="form-control" type="text" name="'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+'" value="<%= '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+' %>" /></td>');
       end;

       EJS.Add('</tr>  ');
       Form2.FDQuery4.next;
     end;
EJS.Add('<td colspan="2">   ');
EJS.Add('<input class="btn btn-primary" id="button1" type="submit" name="btIncuirPub" value="Inserir"/>    ');
EJS.Add('<a class="btn btn-link" href="/">Voltar </a>   ');
EJS.Add('</td>   ');
EJS.Add('</tr>   ');
EJS.Add('</table> ');
EJS.Add('</form> ');
EJS.Add('</div> ');
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
