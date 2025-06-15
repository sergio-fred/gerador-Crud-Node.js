program AppCrud;

uses
  Vcl.Forms,
  principal in 'principal.pas' {Form2},
  estrutura in 'estrutura.pas',
  javascript in 'javascript.pas',
  app in 'app.pas',
  index_ejs in 'index_ejs.pas',
  partes_ejs in 'partes_ejs.pas',
  insereMestre in 'insereMestre.pas',
  insereDetalhes in 'insereDetalhes.pas',
  editaDados in 'editaDados.pas',
  log in 'log.pas',
  limparDados in 'limparDados.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
