unit index_ejs;

interface

Uses principal,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls, ExtCtrls, System.IOUtils;

  procedure salvarIndex_ejs();

implementation

procedure salvarIndex_ejs();
var
  EJS: TStringList;
  caminho, subpasta, subdir, mensagem: string;
  Handle: THandle;
begin
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    subdir := '/Views';
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+ '\index.ejs';;
    EJS := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+ '\index.ejs';

EJS.Add('<!DOCTYPE html>  ');
EJS.Add('<html lang="pt-br"> ');
EJS.Add('<head> <!--inclui cabeçalho do html -->  ');
EJS.Add('<meta charset="UTF-8"> ');
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
EJS.Add('<h4>' +principal.bd+ '</h4> ');
EJS.Add('        </li>  ');
EJS.Add('        <li class="nav-pill ml-auto">  ');
EJS.Add('          <a class="btn btn-outline-primary btn-sm" href="/inserirMestre">Novo Registro Mestre</a>  ');
EJS.Add('        </li>  ');
EJS.Add('      </ul>  ');
EJS.Add('    </div>  ');
EJS.Add('<div class="table table-striped table-responsive"> ');
EJS.Add('  <table class="table">  '); //TABELA RESPONSIVA
EJS.Add('  <thead>  ');
EJS.Add('  <tr>   ');
EJS.Add('  <th scope="col">#</th>   ');
    //busca nome campos da tabela Mestre
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       EJS.Add('<th scope="col">' +Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ '</th>');
       Form2.FDQuery3.next;
     end;
    //busca nome campos da tabela Detalhes
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
       EJS.Add('<th scope="col">' +Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ '</th>');
       Form2.FDQuery4.next;
     end;

EJS.Add('    </tr>   ');
EJS.Add('  </thead>   ');
EJS.Add('  <tbody>   ');
EJS.Add('  <% for (var i = 0; i < queryMestre.length; i++) { %> ');
EJS.Add('    <tr>   ');
EJS.Add('     <th scope="row"><%= 1+i %></th>  ');

//busca nome campos da tabela Mestre
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       EJS.Add('<td><%= queryMestre[i].' +Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ '%></td>');
       Form2.FDQuery3.next;
     end;
    //busca nome campos da tabela Detalhes
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
       EJS.Add('<td><%= queryMestre[i].' +Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ '%></td>');
       Form2.FDQuery4.next;
     end;
EJS.Add('      <td>     ');                                                             //chave PK MESTRE                    //chave PK DETALHES
EJS.Add('        <a class="btn btn-success btn-sm" href="/editaDados/<%=queryMestre[i].'+principal.pk+' %>/<%=queryMestre[i].'+principal.pk_det+' %>">Editar</a> ');
EJS.Add('      </td>   ');
EJS.Add('      <td>   ');
mensagem := QuotedStr('Tem certeza de apagar o registro de id: ');
EJS.Add('      <td>   ');
EJS.Add('        <a class="btn btn-info btn-sm" onclick="return confirm(' + mensagem + '+ <%= queryMestre[i].'+principal.pk+' %> );" href="/delete/<%= queryMestre[i].'+principal.pk+' %>">Deletar</a>  ');
EJS.Add('      </td>  ');
EJS.Add('      <td>   ');
EJS.Add('        <a class="btn btn-secondary btn-sm" href="/inserirDetalhes/<%= queryMestre[i].'+principal.pk+' %>">Incluir</a>  ');
EJS.Add('      </td>   ');
EJS.Add('    </tr>   ');
EJS.Add('    <% } %>   ');
 EJS.Add('   </tbody>  ');
EJS.Add(' </table>   ');
EJS.Add('</div>   ');
EJS.Add('</main>   ');
EJS.Add('<footer> <!--inclui rodapé do html -->   ');
EJS.Add('  <%- include("rodape.ejs"); %>    ');
EJS.Add('</footer>  ');
EJS.Add('<tr class="steps-container" data-steps-for="6681470c-91ce-eb96-c9be-8e89ca941e9d" style="display: none;">    ');
EJS.Add('<td colspan="6" class="no-padding"></td>  ');
EJS.Add('</tr>   ');
EJS.Add('</body>   ');
EJS.Add('</html>  ');
EJS.SaveToFile(caminho);
//ShellExecute(Handle, 'open', Pchar(caminho), nil, nil, SW_SHOWMAXIMIZED);
  finally
FreeAndNil(EJS);
  end;
end;

end.
