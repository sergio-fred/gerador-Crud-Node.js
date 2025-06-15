unit partes_ejs;


interface

Uses principal,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls, ExtCtrls, System.IOUtils;

  procedure salvarPartes_ejs();

implementation

procedure salvarPartes_ejs();
var
  EJS_B, EJS_C, EJS_R: TStringList;
  caminho, subpasta, subdir: string;
  Handle: THandle;
begin
  //Salvar arquivo BOOTSTRAP.ejs na pasta .\Views
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    subdir := '/Views';
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+'\bootstrap.ejs';
    EJS_B := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName)+subpasta+subdir+'\bootstrap.ejs';
    EJS_B.Add('<meta charset="UTF-8">  ');
    EJS_B.Add('<title>CRUD - 3 tabelas</title> ');
    EJS_B.Add('<!-- CSS (carrega bootstrap) -->  ');
    EJS_B.Add('  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.2/css/bootstrap.min.css"> ');
    EJS_B.Add('<style>  ');
    EJS_B.Add('  body { padding-top:5px; } ');
    EJS_B.Add('</style> ');
    EJS_B.SaveToFile(caminho);
   // ShellExecute(Handle, 'open', Pchar(caminho), nil, nil, SW_SHOWMAXIMIZED);
  finally
    FreeAndNil(EJS_B);
  end;

  //Salvar arquivo CABECALHO.ejs na pasta .\Views
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    subdir := '/Views';
    caminho := ExtractFilePath(Application.ExeName)+subpasta+subdir+'\cabecalho.ejs';
    EJS_C := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName)+subpasta+subdir+'\cabecalho.ejs';
    EJS_C.Add('<nav class="navbar navbar-light navbar-expand-sm" style="background-color: #c1c8e0;" >  ');
    EJS_C.Add('<!-- ESCREVA ABAIXO o nome do seu App... --> ');
    EJS_C.Add('<a class="navbar-brand" href="/"> Nome do App </a> ');
    EJS_C.Add('<ul class="navbar-nav mr-auto">  ');
    EJS_C.Add('<li class="nav-item">   ');
    EJS_C.Add('<!-- ESCREVA AQUI OS LINKs para href do MENU conforme sua App... --> ');
    EJS_C.Add('<a class="nav-link" href="/">Home</a> ');
    EJS_C.Add('</li> ');
    EJS_C.Add('<li class="nav-item"> ');
    EJS_C.Add('<a class="nav-link" href="/">Tabela mestre</a> ');
    EJS_C.Add('</li> ');
    EJS_C.Add('<li class="nav-item"> ');
    EJS_C.Add('<a class="nav-link" href="/">Tabela detalhes</a> ');
    EJS_C.Add('</li> ');
    EJS_C.Add('</ul> ');
    EJS_C.Add('</nav> ');
    EJS_C.Add('<div class="jumbotron" > ');
    EJS_C.Add('<!-- ALTERE os dados ABAIXOS com informacao do seu App... --> ');
    EJS_C.Add('<h1>CRUD com 2 tabelas</h1> ');
    EJS_C.Add('<p>Desenvolvido com Node.js, Express, Ejs, MySql</p> ');
    EJS_C.Add('</div> ');
    EJS_C.SaveToFile(caminho);
  //  ShellExecute(Handle, 'open', Pchar(caminho), nil, nil, SW_SHOWMAXIMIZED);
  finally
    FreeAndNil(EJS_C);
  end;

   //Salvar arquivo RODAPE.ejs na pasta .\Views
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    subdir := '/Views';
    caminho := ExtractFilePath(Application.ExeName)+subpasta+subdir+'\rodape.ejs';
    EJS_R := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+subdir+'\rodape.ejs';
    EJS_R.Add('<p class="text-center text-muted">&copy; Copyright 2021 - www.programador1.com</p>  ');
    EJS_R.SaveToFile(caminho);
   // ShellExecute(Handle, 'open', Pchar(caminho), nil, nil, SW_SHOWMAXIMIZED);
  finally
    FreeAndNil(EJS_R);
  end;


end;

end.
