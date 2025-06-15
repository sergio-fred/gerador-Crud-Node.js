unit editaDados;

interface

Uses principal,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls, ExtCtrls, System.IOUtils;

  procedure editar_Dados();

implementation

procedure editar_Dados();
var
  EJS: TStringList;
  caminho, subpasta, subdir: string;
  Handle: THandle;
begin
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    subdir := '/Views';
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+ '\editaDados.ejs';;
    EJS := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+ '\editaDados.ejs';

EJS.Add('<!DOCTYPE html>  ');
EJS.Add('<html lang="pt-br"> ');
EJS.Add('<head> <!--inclui cabeçalho do html --> ');
EJS.Add('<%- include("bootstrap.ejs"); %> ');
EJS.Add('</head>   ');
EJS.Add('<body class="container">   ');
EJS.Add('<header> <!--inclui head do html, carrega bootstrap -->   ');
EJS.Add('<%- include("cabecalho.ejs"); %>   ');
EJS.Add('</header>   ');
EJS.Add('<main>   ');
EJS.Add('<div class="card-header">   ');
EJS.Add('<ul class="nav nav-pills w-100">   ');
EJS.Add('<li class="nav-pill active">   ');
EJS.Add('<h4>Editar Tabela Mestre</h4>   ');
EJS.Add('</li>   ');
EJS.Add('</ul>   ');
EJS.Add('</div>   ');
EJS.Add('</main>   ');
EJS.Add('<form action="/editaDados/<%='+principal.pk+' %>" method="post">   ');

 //busca nome campos da tabela Mestre
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       EJS.Add('<div class="form-group">   ');
       //se campo diferente da chave primaria da tabela mestre inclui campos no .ejs
       if (Form2.FDQuery3.FieldByName('COLUMN_KEY').Value <> 'PRI') then                //ALTERAR E INCLUIR PK COm hidden
        begin
         EJS.Add('<label>' +Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ '</label>  ');
         EJS.Add('<input type="text" class="form-control form-control-sm" name="'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+'" value="<%= '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+' %> ">  ');
        end;

       EJS.Add('</div>   ');
       Form2.FDQuery3.next;
     end;
EJS.Add('<!-- Atualizar dados da tabela Publicacao-->');
EJS.Add('<div class="card-header">   ');
EJS.Add('<ul class="nav nav-pills w-100">   ');
EJS.Add('<li class="nav-pill active">   ');
EJS.Add('<h4>Editar Tabela de Detalhes</h4>   ');
EJS.Add('</li>   ');
EJS.Add('</ul>   ');
EJS.Add('</div>  ');

    //busca nome campos da tabela Detalhes
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
       //se campo diferente da chave primaria da tabela Detalhes inclui campos no .ejs
       if  (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
       begin
        if (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'MUL')<>0) then
        begin
         EJS.Add('<div class="form-group"> ');
         EJS.Add('<label>' +Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ '</label>  ');
         EJS.Add('<input class="form-control" type="text" name="'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+'" value="<%= '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+' %>" /> ');
         EJS.Add('</div> ');
        end;
       end;
       Form2.FDQuery4.next;
     end;

     //REPETIR O LAÇO ANTERIOR PARA IMPRIMIR SOMENTE O ID (PK) E O fk - logica em contrario  FUNCIONA
         //busca nome campos da tabela Detalhes
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
       //se campo diferente da chave primaria da tabela Detalhes inclui campos no .ejs
       if  (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')=0) OR (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'MUL')=0) then
       begin
         EJS.Add('<div class="form-group"> ');
         EJS.Add('<input class="form-control" type="text" name="'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+'" value="<%= '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+' %>" hidden /> ');
         EJS.Add('</div> ');
        end;
       Form2.FDQuery4.next;
     end;



EJS.Add('<div class="form-group">   ');
EJS.Add('<input type="submit" class="btn btn-info" value="Atualizar"/>   ');
EJS.Add('<a href="/" class="btn btn-outline-primary btn-sm">Voltar</a>   ');
EJS.Add('</div>   ');
EJS.Add('</form>   ');
EJS.Add('</div>   ');
EJS.Add('</div>   ');
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
