unit javascript;

interface

Uses principal,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls, ExtCtrls, System.IOUtils;

  procedure salvarDb();

implementation

procedure salvarDb();
var
  JS: TStringList;
  caminho, subpasta, host, root, passw: string;
  Handle: THandle;
begin
  try
    //subpasta ou nome do projeto inserido no Form2.Edit1.Text
    subpasta := Form2.Edit1.Text;
    host :=     Form2.Edit2.Text;
    root :=     Form2.Edit3.Text;
    passw :=    Form2.Edit4.Text;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+ '\db.js';
    JS := TStringList.Create;
    if FileExists(caminho) then
    begin
      DeleteFile(caminho);
    end;
    caminho := ExtractFilePath(Application.ExeName) +subpasta+ '\db.js';
    JS.Add('var mysql = require("mysql"); ');
    JS.Add('// elementos para conexao com mysql ');
    JS.Add('var conexao = mysql.createConnection({ ');
    JS.Add('host: ' +'"'+ host +'",' );
    JS.Add('user:' +'"'+ root +'",' );
    JS.Add('password:' +'"'+ passw +'",' );
    JS.Add('database: ' +'"'+ principal.bd +'",' );
    JS.Add('multipleStatements: true ');
    JS.Add('});  ');
    JS.Add('//executar conexao com BD ');
    JS.Add('conexao.connect(); ');
    JS.Add('//exporta modulo globalmente para rotas app.get() e app.post()');
    JS.Add('module.exports = conexao; ');

    {
     //i := 0;
    //while i < Form2.Memo1.Lines.Count do
    //begin
    //  HTML.Add(AnsiToUtf8(Form2.Memo1.Lines[i]));
    //  HTML.Add('</br>');
    //  inc(i);
    //end;

     for i := 0 to Form2.Memo1.Lines.Count - 1 do
      begin
        HTML.Add(UTF8Encode(Form2.Memo1.Lines[i]));
        HTML.Add('</br>');
      end;
    }

    JS.SaveToFile(caminho);
   // ShellExecute(Handle, 'open', Pchar(caminho), nil, nil, SW_SHOWMAXIMIZED);
  finally
    FreeAndNil(JS);
  end;
end;

end.
