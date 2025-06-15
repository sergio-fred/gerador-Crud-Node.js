unit estrutura;

interface

Uses principal,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls,
  ExtCtrls, TabNotBk, OleCtrls, SHDocVw, DBClient,DB,ADODB,DBGrids, Vcl.Imaging.GIFImg;

procedure estruturaNodejs();
procedure salvarEjs();
procedure pastaApp();
var diretorio :string;

implementation

uses javascript, app, index_ejs, partes_ejs, insereMestre, insereDetalhes, editaDados, log;

//(1o.)estrutura pastas/arquivos no formato Node.js x Express x Ejs na pasta junto ao exe NodeApp1
procedure estruturaNodejs();
const
 NodeJs : array[1..3] of string = ('npm install express ejs mysql', 'npm init -y', 'md views');

var
 i,janelaCmd : integer;
 caminho: string;

 begin
Form2.ProgressBar1.Position := Form2.ProgressBar1.Position + 1;

Form2.memLista.Lines.Add('Aguarde o fim do processo...');
janelaCmd:= 0 ; // 0 Executará Cmd.exe modo Oculto e 1 Executará em modo Visual
caminho := ExtractFilePath(Application.ExeName);
diretorio := caminho;

if (Form2.Edit1.Text='') then
begin
  Application.MessageBox('Digite o nome do Projeto',0);
  Abort();
end;

if not DirectoryExists(caminho+Form2.Edit1.Text) then
begin
  createdir(caminho+Form2.Edit1.Text);
end
else begin
  Form2.memLista.Lines.Add(Form2.Edit1.Text + ' ...O projeto já existe');
  Application.MessageBox('Projeto JÁ EXISTE. Digite outro nome...',0);
  Abort();
end;

ShellExecute(0, nil, 'cmd.exe', PWideChar('/c md'+caminho+Form2.Edit1.Text),PWideChar(''+caminho+''),janelaCmd);

for i := 1 to 3 do
begin
  ShellExecute(0, nil, 'cmd.exe', PWideChar('/c ' + NodeJs[i]),PWideChar(''+caminho+Form2.Edit1.Text),janelaCmd);
end;

//atualizar mostra de arquivos no Explorer
 Form2.FileListBox1.ApplyFilePath(Form2.DirectoryListBox1.Directory);
 Form2.DirectoryListBox1.DirLabel.Caption := caminho+Form2.Edit1.Text;

 Form2.DirectoryListBox1.FileList := nil;
 Form2.FileListBox1.Directory := '.';
 Form2.DirectoryListBox1.FileList := Form2.FileListBox1; // reset
 Form2.DirectoryListBox1.Directory := caminho;
 Form2.DirectoryListBox1.OpenCurrent();
 Form2.SpeedButton1.Enabled := true;

end; //fim da função estruturaNodejs

//(2o.)Salva no projeto NODE todos os arquivos Ejs, Db e App
procedure salvarEjs();
begin
  //grava a pasta do Projeto e salva arquivos de Bd, Js, Ejs
  javascript.salvarDb();
  app.salvarApp();
  sleep(2000);

  partes_ejs.salvarPartes_ejs();
  index_ejs.salvarIndex_ejs();
  sleep(2000);

  insereMestre.salvar_insereMestre();
  insereDetalhes.salvar_inserirDetalhes();
  editaDados.editar_Dados();
  sleep(2000);
  //chamar função para gravar Log
  log.ListarArquivos(Form2.Edit1.Text, true);
  log.ListarArquivos(Form2.Edit1.Text+'\views', true);
  //atualizar mostra de arquivos no Explorer
  Form2.DirectoryListBox1.FileList := nil;
  Form2.DirectoryListBox1.FileList := Form2.FileListBox1;
  Form2.FileListBox1.Directory := Form2.Edit1.Text;

if FileExists(diretorio+Form2.Edit1.Text+'\views\editaDados.ejs') then
 begin
  //Application.MessageBox(PWideChar('Processo finalizado, veja a pasta do projeto...'),0);
  Showmessage('Processo finalizado, veja a pasta do projeto...');
  //chamar função para abrir a pasta do projeto
  pastaApp();
 end;
end;

procedure pastaApp();
var Handle: THandle;
begin
   ShellExecute (0, Pchar ('open'),
   Pchar (ExtractFileDir (Application.ExeName+Form2.Edit1.Text)),nil,nil,SW_SHOW);
end;


end.
