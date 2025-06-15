unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, Vcl.Grids, Vcl.DBGrids,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.DBCtrls,
  Vcl.Buttons, Shellapi, Vcl.Samples.Gauges, Vcl.FileCtrl, Wininet,
  Vcl.Imaging.GIFImg;

type
  TForm2 = class(TForm)
    MainMenu1: TMainMenu;
    NodeJS1: TMenuItem;
    JavaJSP1: TMenuItem;
    Php1: TMenuItem;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    FDQuery1schema_name: TStringField;
    FDQuery2: TFDQuery;
    DataSource2: TDataSource;
    PageControl1: TPageControl;
    FDQuery3: TFDQuery;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
    FDQuery3TABLE_SCHEMA: TStringField;
    FDQuery3TABLE_NAME: TStringField;
    FDQuery3COLUMN_NAME: TStringField;
    FDQuery3COLUMN_KEY: TStringField;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    TabSheet1: TTabSheet;
    FDConnection1: TFDConnection;
    Panel1: TPanel;
    Label10: TLabel;
    Edit2: TEdit;
    Label11: TLabel;
    Edit3: TEdit;
    Label12: TLabel;
    Edit4: TEdit;
    SpeedButton3: TSpeedButton;
    SpeedB1: TSpeedButton;
    Panel2: TPanel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    SpeedB2: TSpeedButton;
    Panel3: TPanel;
    SpeedB3: TSpeedButton;
    DBGrid2: TDBGrid;
    Panel4: TPanel;
    SpeedB4: TSpeedButton;
    Edit1: TEdit;
    Label9: TLabel;
    Panel5: TPanel;
    SpeedB5: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Label4: TLabel;
    FDQuery4: TFDQuery;
    FDQuery4TABLE_SCHEMA: TStringField;
    FDQuery4TABLE_NAME: TStringField;
    FDQuery4COLUMN_NAME: TStringField;
    FDQuery4COLUMN_KEY: TStringField;
    DBText1: TDBText;
    DBGrid3: TDBGrid;
    DBText2: TDBText;
    DBGrid4: TDBGrid;
    Shape1: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label13: TLabel;
    memLista: TMemo;
    LimparDados1: TMenuItem;
    Label7: TLabel;
    ProgressBar1: TProgressBar;
    procedure DBGrid2DblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure carregaAtributos();
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Php1Click(Sender: TObject);
    procedure DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ComboBox1Change(Sender: TObject);
    procedure LimparDados1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure mensagemSql();
  end;


var
  Form2: TForm2;
  var bd, tab_mestre, tab_detalhes, pk, pk2, fk, fk2, pk_det, pk_det2 : string;
      app : string;

implementation

uses estrutura, javascript, app, index_ejs, partes_ejs, insereMestre,
     insereDetalhes, editaDados, log, limparDados;

{$R *.dfm}

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
 //AO CHANGE NO DBCOMBOBOX para escolher o BD
   DBText1.Visible := false;
   DBText2.Visible := false;
   DBGrid3.Visible := false;
   DBGrid4.Visible := false;
   Label1.Visible := false;
   Shape1.Visible := false;
   Label2.Visible := false;
   //nome do Banco de Dados escolhido
   FDQuery2.Close();
   bd := ComboBox1.Text; //pegar item selecionado no ComboBox
   FdQuery2.ParamByName('paramBD').AsString := bd;
   FdQuery2.Open();

   if (FDQuery2.FieldByName('REFERENCED_COLUMN_NAME').IsNull) then
   begin
    SpeedB3.Enabled := false;
    SpeedB4.Enabled := false;
    SpeedB5.Enabled := false;
    mensagemSql();
    SpeedB2.Enabled := true;
    Panel2.Color := clMoneyGreen;
   end
   else
   begin
     carregaAtributos();
     SpeedB2.Enabled := false;
     SpeedB3.Enabled := true;
     Edit1.Enabled := true;
     Panel2.Color := clWhite;
     Panel3.Color := clMoneyGreen;
     SpeedB4.Enabled := false;
     SpeedB5.Enabled := false;
   end;
end;

procedure TForm2.DBGrid2DblClick(Sender: TObject);
begin
 tab_mestre :=  FDQuery2.FieldByName('REFERENCED_TABLE_NAME').value; //tabela mestre
 tab_detalhes :=  FDQuery2.FieldByName('TABLE_NAME').value;          //tabela destalhes
 pk := FDQuery2.FieldByName('REFERENCED_COLUMN_NAME').value;  //pk na tabela mestre
 pk2 := tab_mestre+'.'+FDQuery2.FieldByName('REFERENCED_COLUMN_NAME').value;  //pk na tabela mestre
 fk := FDQuery2.FieldByName('COLUMN_NAME').value;            //fk na tabela detalhes
 fk2 := tab_detalhes+'.'+FDQuery2.FieldByName('COLUMN_NAME').value;            //fk na tabela detalhes
 pk_det := FDQuery2.FieldByName('PK_DETALHES').value;         //pk na tabela detalhes
 pk_det2 := tab_detalhes+'.'+FDQuery2.FieldByName('PK_DETALHES').value;         //pk na tabela detalhes
 carregaAtributos();
 Label1.Visible := true;
 Shape1.Visible := true;
 Label2.Visible := true;
 DBText1.Visible := true;
 DBText2.Visible := true;
 DBGrid3.Visible := true;
 DBGrid4.Visible := true;
 SpeedB3.Enabled := false;
 SpeedB4.Enabled := true;
 Panel3.Color := clWhite;
 Panel4.Color := clMoneyGreen;
end;

procedure TForm2.DBGrid2DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  nLinha: integer;
begin
  // obtém o número do registro (linha)
  nLinha := DBGrid2.DataSource.DataSet.RecNo;
  // verifica se o número da linha é par ou ímpar, aplicando as cores
  if Odd(nLinha) then
    DBGrid2.Canvas.Brush.Color := clCream
  else
    DBGrid2.Canvas.Brush.Color := clWhite;
  // pinta a linha
  DBGrid2.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TForm2.Edit1Enter(Sender: TObject);
begin
 SpeedB4.Enabled := false;
 SpeedB5.Enabled := true;
 Panel4.Color := clWhite;
 Panel5.Color := clMoneyGreen;
 SpeedButton1.Enabled := true;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin

DirectoryListBox1.Directory :=   ExtractFilePath(Application.ExeName);
DirectoryListBox1.DirLabel.Caption := ExtractFilePath(Application.ExeName);

DBGrid3.Visible := false;
DBGrid4.Visible := false;
SpeedButton1.Enabled := false;
SpeedB2.Enabled := false;
SpeedB3.Enabled := false;
SpeedB4.Enabled := false;
SpeedB5.Enabled := false;
Label1.Visible := false;
Shape1.Visible := false;
Label2.Visible := false;
//verifica se tem Internet, senao mensagem e termina App.
if  InternetCheckConnection('http://www.google.com/',  1,  0)  then begin
   Showmessage('Internet está Conectada');
 end
else
 begin
   Showmessage('SEM CONEXÃO COM INTERNET. Verifique e retorne. O App será fechado.');
   Application.Terminate();
 end;
end;

procedure TForm2.LimparDados1Click(Sender: TObject);
begin
  //Limpar dados para nova estrutura de App
  limparDados.limpaInterface();
end;

//carrega nome das tabelas mestre e detalhes
procedure TForm2.carregaAtributos();
begin
 FDQuery3.Close;
 FDQuery3.ParamByName('paramBDados1').Value := FDQuery2.FieldByName('TABLE_SCHEMA').value;
 FDQuery3.ParamByName('paramMestre').Value := FDQuery2.FieldByName('REFERENCED_TABLE_NAME').value;
 FDQuery3.Open;
 FDQuery4.Close;
 FdQuery4.ParamByName('paramBDados2').Value := FDQuery2.FieldByName('TABLE_SCHEMA').value;
 FDQuery4.ParamByName('paramDetalhe').Value := FDQuery2.FieldByName('TABLE_NAME').value;
 FDQuery4.Open;
end;

procedure TForm2.Php1Click(Sender: TObject);
begin
 Close();
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
var i : integer;
begin
    ProgressBar1.Enabled := true;
    ProgressBar1.Min := 0;
    ProgressBar1.Max := 100;
    for i := ProgressBar1.Min to ProgressBar1.Max do
    begin
      ProgressBar1.Position := i;
      Sleep(20);
    end;


    //chama Unit para PRODUZIR o projeto em Node.Js
   estrutura.estruturaNodejs();
   //chamar funcao para gravar no projeto Ejs, Bd e App
   estrutura.salvarEjs();
   SpeedButton1.Enabled := false;
end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
begin
FDConnection1.Close;
  try
    FDConnection1.Params.Clear;
    FDConnection1.Params.Add('DriverID=MySQL');
    FDConnection1.Params.Add('Server='+Edit2.Text);
    FDConnection1.Params.Add('Port=3306');
    FDConnection1.Params.Add('Database=mysql');
    FDConnection1.Params.Add('User_Name='+Edit3.Text);
    FDConnection1.Params.Add('Password='+Edit4.Text);
    FDConnection1.Open;
    // conectar FDConnection1
    FDConnection1.Connected := true;
    FDQuery1.Active := true;
    FDQuery2.Active := true;
    FDQuery3.Active := true;
    FDQuery4.Active := true;
  except
    on EDatabaseError do
      begin
        Application.MessageBox('Usuário ou senha invalida','Erro conexão BD', MB_ICONERROR);
        Abort;
      end;
  end;
  FDQuery1.Active := true;
  FDQuery1.Open();
  FDQuery1.First();
//Carregar Query1 com nome dos BDs
while not FDQuery1.Eof do
 begin
   //DBComboBox1.Items.add(FDQuery1.FieldByName('SCHEMA_NAME').value);
   ComboBox1.Items.add(FDQuery1.FieldByName('SCHEMA_NAME').value);
   FDQuery1.Next();
 end;
 ComboBox1.Font.Style := [fsBold];
 ComboBox1.Font.Size := 11;
 SpeedB1.Enabled := false;
 SpeedB2.Enabled := true;
 Panel1.Color := clWhite;
 Panel2.Color := clMoneyGreen;
end;


procedure TForm2.mensagemSql();
begin
   Application.MessageBox('Verifique o SQL, falta referência entre chaves'  +#13+
   'para o relacionamento entre as tabelas. Veja o exemplo abaixo: '     +#13+
   '                                                     '    +#13+
   'CREATE TABLE Tabela_Mestre ( ' +#13+
   'ID_mestre int(10) PRIMARY KEY AUTO_INCREMENT,' +#13+
   'Campo1 varchar(100),' +#13+
   'Campo2 varchar(100)); ' +#13+
   '                      ' +#13+
   'CREATE TABLE Tabela_Detalhes ( ' +#13+
   'ID_detalhes int PRIMARY KEY AUTO_INCREMENT,' +#13+
   'Campo1 varchar(100),' +#13+
   'Campo2 varchar(100),' +#13+
   'FK_detalhes int(10),' +#13+
   'CONSTRAINT FK_Mestre FOREIGN KEY (FK_Detalhes) REFERENCES Tabela_Mestre(ID_mestre)' +#13+
   'ON DELETE CASCADE ON UPDATE CASCADE);',
   'Aviso de erro', MB_ICONERROR);
end;

end.

