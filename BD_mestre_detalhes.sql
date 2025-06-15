
--BANCO DE DADOS mestre_detalhes para teste com o CRUD
CREATE TABLE tabela_mestre ( 
ID_mestre integer PRIMARY KEY AUTOINCREMENT, 
Campo_mestre1 Text, 
Campo_mestre2 Text );


CREATE TABLE tabela_detalhes ( 
ID_detalhe integer PRIMARY KEY AUTOINCREMENT, 
Atributo_detalhe1 text, 
Atributo_detalhe2 text, 
FK_detalhe integer, 
FOREIGN KEY (FK_detalhe) REFERENCES tabela_mestre (ID_mestre) 
ON DELETE CASCADE);