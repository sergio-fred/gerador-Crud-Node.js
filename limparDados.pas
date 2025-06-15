unit limparDados;

interface


Uses principal, estrutura,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Shellapi, StdCtrls,
  ExtCtrls, TabNotBk, OleCtrls, SHDocVw, DBClient,DB,ADODB,DBGrids;

  procedure limpaInterface();

implementation


procedure limpaInterface();
begin
  Form2.Edit4.Clear;
  Form2.ComboBox1.Clear;
  Form2.Edit1.Clear;
  Form2.FDQuery1.Close;
  Form2.FDQuery2.Close;
  Form2.FDQuery3.Close;
  Form2.FDQuery4.Close;
  Form2.memLista.Clear;
  Form2.DBGrid3.Visible := false;
  Form2.DBGrid4.Visible := false;
  Form2.Shape1.Visible := false;
  Form2.Label1.Visible := false;
  Form2.Label2.Visible := false;
  Form2.Panel5.Color := clWhite;
  Form2.SpeedB5.Enabled := false;
  Form2.Panel4.Color := clWhite;
  Form2.SpeedB4.Enabled := false;
  Form2.Panel3.Color := clWhite;
  Form2.SpeedB3.Enabled := false;
  Form2.Panel2.Color := clWhite;
  Form2.SpeedB2.Enabled := false;
  Form2.Panel1.Color := clMoneyGreen;
  Form2.SpeedB1.Enabled := true;
  Form2.Edit1.Enabled := false;
  Form2.Edit4.SetFocus;
  Form2.ProgressBar1.Enabled := false;

end;


end.
