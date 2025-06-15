{
REGRAS PARA O GERADO DE CRUD
1) Atributos das tabelas não podem ter mesmo nomes;
2) As chaves primária e estrangeiras não podem ter mesmo nome;
3) AS tabelas mestre e detalhes precisam estar referenciadas com cláusula REFERENCE
4) As tabelas mestre e detalhes precisam estar normalizadas em 3a. forma normal (3FN)
}

unit app;

interface

Uses principal,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls, ExtCtrls, System.IOUtils;

  procedure salvarApp();

implementation

//salva rotas de get/post no App.js
procedure salvarApp();
var
  JS: TStringList;
  caminho, subpasta: string;
  Handle: THandle;
begin
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+ '\App.js';
    JS := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+ '\App.js';

    JS.Add('var express = require("express"); ');
    JS.Add('var app = express(); ');
    JS.Add('var dbCon = require("./db.js"); ');
    JS.Add('// configura apresentacao de paginas ejs - html ');
    JS.Add('app.set("view engine", "ejs"); ');
    JS.Add('// para uso de req.body dados vindo do ejs - html ');
    JS.Add('app.use(express.urlencoded( { extended: false } )); ');
    JS.Add('// -------ROTAS para acesso ao Banco de Dados--------// ');

    JS.Add('//(1) rota para pagina index.ejs, carregar tabela mestre ');
    JS.Add('app.get("/", function(req, res) { ');
    //COMPOSIÇÃO da SQL para a rota GET - SELECT renderizar index.ejs
    JS.Add('dbCon.query("SELECT * FROM ' +principal.tab_mestre+ ', ' +principal.tab_detalhes+ ' "+ ');
    JS.Add('" WHERE '+principal.pk2+'='+principal.fk2+' ORDER BY '+principal.pk2+' DESC", function(err, queryMestre) {  ');
    JS.Add('res.render("index.ejs", { //res.render carrega paginas ejs   ');
    JS.Add('queryMestre: queryMestre, ');
    //busca nome campos da tabela Mestre
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       JS.Add(' '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ': "", ');
       Form2.FDQuery3.next;
     end;
     //busca nome campos da tabela Detalhes
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
       JS.Add(' '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ': "", ');
       Form2.FDQuery4.next;
    end;
    JS.Add('});  ');
    JS.Add('});  ');
    JS.Add('});  ');

    //COMPOSIÇÃO da SQL para a rota POST - INSERT renderizar inserirMestre.ejs
    JS.Add('//(2) ====select da pagina INSERIR MESTRE======  ');
    JS.Add('app.get("/inserirMestre", function(req, res) { ');
    JS.Add(' dbCon.query("SELECT * FROM '+principal.tab_detalhes+' ", function(err, dataMestre) { ');
    JS.Add(' res.render("inserirMestre.ejs", {  ');
       JS.Add('dataMestre: dataMestre,            ');
    //busca nome campos da tabela Mestre
    JS.Add(' //definicao de atributos da tabela Mestre  ');  //VER QUANDO MESMO PK E FK, DEFINIÇÃO PARA APP JÁ EXISTENTE
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       JS.Add(' '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ': "", ');
       Form2.FDQuery3.next;
    end;
    //busca nome campos da tabela Detalhes
    JS.Add(' //definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
       JS.Add(' '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ': "", ');
       Form2.FDQuery4.next;
    end;
    JS.Add(' });  ');
    JS.Add(' });  ');
    JS.Add('});  ');

    // INSERE EM MESTRE, valores vindo de name dos input no body do html
    JS.Add('//(3) INSERE EM MESTRE, valores vindo da propriedade name dos input no body do html  ');
    JS.Add('app.post("/inserirMestre", function(req, res) {   ');
    //busca nome campos da tabela Mestre
    JS.Add('//definicao de atributos da tabela Mestre  ');
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       JS.Add(' let '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ' = req.body.'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+';' );
       Form2.FDQuery3.next;
    end;
     //busca nome campos da tabela Detalhes
    JS.Add(' //definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
     JS.Add(' let '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ' = req.body.'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+';' );
     Form2.FDQuery4.next;
    end;
     JS.Add(' let errors = false;  ');
     JS.Add(' if(!errors) {    ');
     JS.Add(' var insere_Mestre = {  ');
     //busca nome campos da tabela Mestre
     JS.Add(' //definicao de atributos da tabela Mestre  ');
     Form2.FDQuery3.First;
    While (not Form2.FDQuery3.Eof)  do
    begin
       JS.Add(' '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ' : '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+',' );
       Form2.FDQuery3.next;
    end;
    JS.Add( '}   ');
    JS.Add('}   ');
    JS.Add('//Sql insercao- definicao de inserDados para insercao MESTRE   ');
    JS.Add('dbCon.query("INSERT INTO '+principal.tab_mestre+' SET ?", insere_Mestre, function(err, result) {  ');
    JS.Add('if (err) {  ');
    JS.Add(' res.render("inserirMestre.ejs", {  ');
    //busca nome campos da tabela Mestre, nao imprime pk para insert
    JS.Add(' //definicao de atributos da tabela Mestre  ');
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       if AnsiCompareStr(Form2.FDQuery3.FieldByName('COLUMN_KEY').Value,'PRI')<>0 then
         JS.Add(' '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ' : insere_Mestre.'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+',' );
    Form2.FDQuery3.next;
    end;
    JS.Add(' }); ');
    JS.Add(' }   ');
    JS.Add('}); ');
    JS.Add('//---rota com sql duplo p/buscar PK (id) mestre e inserir como FK em detalhes --- ');
    JS.Add('dbCon.query("SELECT * FROM '+principal.tab_mestre+' ORDER BY '+principal.pk+' DESC limit 1", function(err, queryDetalhes) { '); //queryPub -->> queryDetalhes
    JS.Add(' //definicao de colecao de atributos da tabela Detalhes  ');
    JS.Add(' var insere_Detalhes = { ');
    //busca nome campos da tabela Detalhes
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
        if (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
                 JS.Add(' '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+' : '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+',' );
      Form2.FDQuery4.next;
    end;
    JS.Add(' '+principal.fk+': queryDetalhes[0].'+principal.pk+',  //pega ultimo (PK) id inserido na tabela mestre ');
    JS.Add('} ');
    JS.Add('// INSERE EM DETALHES, valores vindo de name dos input no body do html ');
    JS.Add('dbCon.query("INSERT INTO '+principal.tab_detalhes+' SET ?", insere_Detalhes, function(err, result) { ');
    JS.Add(' if (err) { ');
    JS.Add(' res.render("inserirMestre.ejs", {  ');
    JS.Add(' //definicoes para inputs em inserirMestre.ejs ');
    JS.Add(' insere_Detalhes : insere_Detalhes, ');
    //busca nome campos da tabela Mestre, nao imprime pk para insert
    JS.Add(' //definicao de atributos da tabela Mestre  ');
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
       //if AnsiCompareStr(Form2.FDQuery3.FieldByName('COLUMN_KEY').Value,'PRI')<>0 then
         JS.Add(' '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ' : insere_Mestre.'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+',' );
    Form2.FDQuery3.next;
    end;
    //busca nome campos da tabela Detalhes
    JS.Add(' //definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
        if (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
           JS.Add(' '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ' : insere_Detalhes.'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+',' );
      Form2.FDQuery4.next;
    end;
    JS.Add(' }); ');
    JS.Add('} else { ');
    JS.Add('res.redirect("/"); ');
    JS.Add(' } ');
    JS.Add(' }); ');
    JS.Add(' }); ');
    JS.Add('}); //fim app.post (3) insert insereMestre');

    JS.Add('//(4) CONSULTAR Mestre e INSERIR em Detalhes na pag. inserirDetalhes.ejs ');
    JS.Add('id = ""; ');
    JS.Add('app.get("/inserirDetalhes/:id", function(req, res) { ');
    JS.Add(' id = req.params.id; //recebe id da pagina editar.ejs ');
    JS.Add(' dbCon.query("SELECT * FROM '+principal.tab_mestre+' WHERE '+principal.pk2+' ="+id, function(err, queryEditar, fields) { ');
    JS.Add(' // render para editar.ejs com dados do livro da queryEditar ');
    JS.Add(' res.render("inserirDetalhes.ejs", { ');

    //busca nome campos da tabela Mestre, nao imprime pk para insert
    JS.Add(' //definicao de atributos da tabela Mestre  ');
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
    JS.Add(' '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ' : queryEditar[0].'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+',' );
    Form2.FDQuery3.next;
    end;
    //busca nome campos da tabela Detalhes
    JS.Add(' //definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
        if (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
             JS.Add(' '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ': "", ');
      Form2.FDQuery4.next;
    end;
    JS.Add(' }) ');
    JS.Add('}) ');
JS.Add( '}); //fim app.get (4) consulta inserirMestre para insercao Detalhes');

JS.Add('//(5)INICIO Insere novo reg. Detalhes relacionado, valores vindo de name dos input no body do html');
JS.Add('  ');
JS.Add('app.post("/inserirDetalhes", function(req, res) {    ///adicionar é o caminho indi cado na pag. html  ');
       //busca nome campos da tabela Detalhes
    JS.Add('//definicao de atributos da TABELA DETALHES ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
        if (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
        begin
        if (AnsiCompareStr(trim(Form2.FDQuery4.FieldByName('COLUMN_NAME').Value), trim(principal.fk))<>0) then
           JS.Add(' let '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+' = req.body.'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+'; ');
        end;
    Form2.FDQuery4.next;
    end;
JS.Add(' let '+trim(principal.fk)+' = id; ');
JS.Add(' let errors = false; ');
JS.Add(' if (!errors) {    ');
JS.Add(' var insere_Detalhe = {  ');
       //busca nome campos da tabela Detalhes
    JS.Add('//definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
    if (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
       JS.Add(''+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ': '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+', ');
    Form2.FDQuery4.next;
    end;

JS.Add(' }     ');
JS.Add('}      ');

JS.Add('//Sql insercao- definicao de variáveis para a colecao insere_Detalhe');
JS.Add('dbCon.query("INSERT INTO '+principal.tab_detalhes+' SET ?", insere_Detalhe, function(err, result) {  ');
JS.Add('if (err) {    ');
JS.Add(' res.render("/inserirDetalhes.ejs", { ');
    //busca nome campos da tabela Detalhes
    JS.Add('//definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
    if (AnsiCompareStr(Form2.FDQuery4.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
       JS.Add(''+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ': '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+', ');
    Form2.FDQuery4.next;
    end;
JS.Add(' });   ');
JS.Add('}else {');
JS.Add('  res.redirect("/"); ');
JS.Add(' }    ');
JS.Add(' });   ');
JS.Add('});   ');
JS.Add('//fim app.post (5) inserirDetalhes '); //(5) FIM FECHAMENTO DO POST inserirDetalhes

//(6) INICIO app.get SELECT para Definições de variáveis para edição nas tabelas de Livros e Publiacao
JS.Add('//(6) inicio app.get  editarDados ');
JS.Add('app.get("/editaDados/:id_m/:id_d", function (req, res, next) {     ');       //( 6A )
JS.Add('  let id_m = req.params.id_m; //recebe parâmetro id da pagina inserir.ejs     ');
JS.Add('  let id_d = req.params.id_d; //recebe parâmetro id da pagina inserir.ejs    ');
JS.Add('  var sql1= "SELECT * FROM '+principal.tab_mestre+', '+principal.tab_detalhes+' WHERE '+principal.pk2+'='+principal.fk2+' and '+principal.pk2+'="+id_m +" and '+principal.pk_det2+' ="+id_d; ');
JS.Add('  dbCon.query(sql1, function (err, queryDados) { //executa sql1 para queryDados  ');
JS.Add('    if (err) throw err;  ');
JS.Add('     res.render("editaDados.ejs", {    ');
JS.Add('     //definição de variáveis com valores de ejs-html para Tabela Mestre  ');
    //busca nome campos da tabela Mestre, nao imprime pk para insert
    JS.Add('//definicao de atributos da tabela Mestre  ');
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
    JS.Add(' '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ' : queryDados[0].'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+',' );
    Form2.FDQuery3.next;
    end;
    //busca nome campos da tabela Mestre, nao imprime pk para insert
    JS.Add('//definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
    JS.Add(' '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ' : queryDados[0].'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+',' );
    Form2.FDQuery4.next;
    end;
JS.Add(' });  ');
JS.Add('});    ');
JS.Add('});   ');  //(6) FIM app.get SELECT para Definições de variáveis

// (7) INICIO app.post para edição nas tabelas de Livros e Publiacao
JS.Add('app.post("/editaDados/:id_m", function (req, res, next) {    ');           //( 6B )
    //busca nome campos da tabela Mestre
    JS.Add('//definicao de atributos da tabela Mestre  ');
    JS.Add('let '+principal.pk+' = req.params.id_m;  ');
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
      if (AnsiCompareStr(Form2.FDQuery3.FieldByName('COLUMN_KEY').Value,'PRI')<>0) then
       JS.Add('let '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ' = req.body.'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+';' );
       Form2.FDQuery3.next;
    end;

    //busca nome campos da tabela Detalhes
    JS.Add('//definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
     JS.Add('let '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ' = req.body.'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+';' );
     Form2.FDQuery4.next;
    end;
    JS.Add('let errors = false; ');
    JS.Add('//definição coleção de atributos da tabela Mestre para atualização ');
    JS.Add(' if (!errors) {     ');
    JS.Add(' var edita_Dados = {    ');
    //busca nome campos da tabela Detalhes
    JS.Add(' //definicao de atributos da tabela Mestre para Edição  ');
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
     JS.Add(''+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ': '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+', ');
     Form2.FDQuery3.next;
    end;

JS.Add('} ');
JS.Add('//update Tabela Mestre   ');                                 ///??????????????? seria (id_m) no lugar de'+principal.pk2+'
JS.Add('dbCon.query("UPDATE '+principal.tab_mestre+' SET ? WHERE '+principal.pk2+'="+'+principal.pk+', edita_Dados, function (err, result) {  ');   //( 6C )
JS.Add(' if (err) {   ');
JS.Add(' //render para pagina editar.ejs  ');
JS.Add(' res.render("editaDados.ejs", {   ');
    //busca nome campos da tabela Mestre
    JS.Add('//definicao de atributos da tabela Mestre  ');
    Form2.FDQuery3.First;
    While not Form2.FDQuery3.Eof do
    begin
     JS.Add(' '+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+ ' : edita_Dados.'+Form2.FDQuery3.FieldByName('COLUMN_NAME').Value+',' );
     Form2.FDQuery3.next;
    end;
JS.Add('}); ');
JS.Add('}   ');
JS.Add('}); ');
JS.Add('} // fim do if (!errors) - Livros   ');
JS.Add('//definicao colecao de atributos da tabela Detalhes para atualizacao  ');
JS.Add('if (!errors) {   ');
JS.Add(' var edita_Detalhes = {  ');
//busca nome campos da tabela Detalhes
    JS.Add('//definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
     JS.Add(' '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+' : '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+',' );
     Form2.FDQuery4.next;
    end;
JS.Add('}   ');
JS.Add('//update Tabela de detalhes  ');
JS.Add('dbCon.query("UPDATE '+principal.tab_detalhes+' SET ? WHERE '+principal.pk_det2+' ="+ '+principal.pk_det+', edita_Detalhes, function (err, result) {  ');  //( 6D )
JS.Add('//render para pagina editaDados.ejs  ');
JS.Add('if (err) {      ');
JS.Add(' res.render("editaDados.ejs", {  ');
//busca nome campos da tabela Detalhes
JS.Add(' //definicao de atributos da tabela Detalhes  ');
    Form2.FDQuery4.First;
    While not Form2.FDQuery4.Eof do
    begin
     JS.Add(' '+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+ ' : edita_Detalhes.'+Form2.FDQuery4.FieldByName('COLUMN_NAME').Value+',' );
     Form2.FDQuery4.next;
    end;
JS.Add('})   ');
JS.Add('} else {   ');
JS.Add(' res.redirect("/");  ');
JS.Add(' }');
JS.Add(' });  ');
JS.Add('}// fim do if (!errors) - dados detalhes ');
JS.Add('}); //fim app.post '); //(7) FIM app.pos editar nas tabelas MESTRE e DETALHES

JS.Add(' // (8) INICIO ROTA PARA DELETAR DADOS (em cascata conf. BD) ');
JS.Add('  app.get("/delete/:id", function(req, res) {  ');
JS.Add('    let id = req.params.id;  ');
JS.Add('    dbCon.query("DELETE FROM '+principal.tab_mestre+' WHERE '+principal.pk2+'="+id, function(err, result) {  ');
JS.Add('     if (err) {    ');
JS.Add('     // se erro, redireciona para página principal  ');
JS.Add('        res.redirect("/");  ');
JS.Add('        } else {    ');
JS.Add('           res.redirect("/"); ');
JS.Add('        }  ');
JS.Add('    });   ');
JS.Add('  });   //(8) fim deletar dados  ');

JS.Add('//(9)-------INICIA SERVIDOR WEB--------// ');
JS.Add('app.listen(8080, function() {  ');
JS.Add('console.log("Servidor inicializado. Acesse http://localhost:8080") }); ');
JS.SaveToFile(caminho);
principal.app := caminho;
//ShellExecute(Handle, 'open', Pchar(caminho), nil, nil, SW_SHOWMAXIMIZED);
  finally
    FreeAndNil(JS);
  end;
end;

end.
