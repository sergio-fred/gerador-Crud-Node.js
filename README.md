# gerador-Crud-Node.js
Gerador para CRUD em Node.js. É um executável win10 que aceita bd com 2 tabelas 1:N, gera app em Node.
(trata-se de um software em fase de teste, pode surgir anomalias funcionais. Favor relatar).

Tecnologia aplicada: delphi10, MySQL. Gera CRUD em Node.js, Express, MySQL 5.0+

Solicite ajuda em programador1.com@gmail.com

Vídeo no Youtube https://youtu.be/hEjCGKT44BM

a) PROCEDIMENTOS COM BANCO DE DADOS: 
Prepare o BD MySQL 5.0+ com 2 tabelas relacionadas em 1-para-muitos (1:n).
O relacionamento (1:n) deve ser referenciado, conforme ex.:

CREATE TABLE tabela_mestre ( ID_mestre integer PRIMARY KEY AUTOINCREMENT, Campo_mestre1 Text, Campo_mestre2 Text );
CREATE TABLE tabela_detalhes ( ID_detalhe integer PRIMARY KEY AUTOINCREMENT, Atributo_detalhe1 text, Atributo_detalhe2 text, FK_detalhe integer, FOREIGN KEY (FK_detalhe) REFERENCES tabela_mestre (ID_mestre) ON DELETE CASCADE);

b) PARA GERAR O App CRUD: 
Ao abrir o App acessa a internet, conecta o MySQL e carrega todos os BDs salvos.
1) Digite o local/Ip do MySQL, o usuário, a senha. Clique no botão carrega BD.
2) Escolha o BD que vai produzir o App Node.js.
3) Duplo clique na linha que aparece chave-primária e chave-estrangeira (as 2 devem estar nessa linha).
4) Digite o nome do projeto (sem espaço, acento, pontuação).
5) Clique no botão para produzir o App e aguardar o processamento.

c) ESTRUTURA DO BD e o CRUD GERADO: 
O App mostrará a estrutura do seu BD para conferência
Estando tudo correto, uma pasta será criada no disco com o App Node.js.

d) EXECUTAR O CRUD GERADO: 
Você precisará ter o Node.js versão 10+ instalado. Ver em https://nodejs.org/pt-br/
Instale o Node.js.
Veja a pasta criada com o App gerad0.
Abra o console de comando do sistema operacional (no Windons 10, win+R, digite 'CMD').
Abra a pasta do projeto e execute o servidor Node.js com: ' <node "Nome do projeto"> '
Abra o App gerado no navegador, via endereço http://localhost:3000

e) REQUISITOS DE TECNOLOGIA: 
Node.js, versão 14.0
Express, versão 4.17.1
SQLite, versão 5.0.2
Ejs, versão 3.1.6

© Copyright 2021 - www.programador1.com.br
