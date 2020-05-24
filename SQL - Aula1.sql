autoresCREATE DATABASE livraria

CREATE TABLE categoria
(
 id_cat INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL
)

CREATE TABLE autores
(
 id_autor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 datan DATE
)

CREATE TABLE livros
(
 id_livro INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 titulo VARCHAR(40) NOT NULL,
 id_cat INT NOT NULL, 
 FOREIGN KEY (id_cat) REFERENCES categoria (id_cat)
)

CREATE TABLE livros_autores
(
 id_liv_auto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 datae DATE NOT NULL,
 id_livro INT NOT NULL,
 id_autor INT NOT NULL,
 FOREIGN KEY (id_liv_auto) REFERENCES livros (id_livro),
 FOREIGN KEY (id_autor) REFERENCES autores (id_autor)
)

INSERT INTO categoria
(descritivo) VALUES ("terror"), ("aventura"), ("romance")

INSERT INTO autores
(nome,datan) VALUE ("Jhonatan","1998-02-08"), ("Rafael Goy","1997-11-27"), ("Billian Boner", "1998-09-15")

INSERT INTO livros
(titulo, id_cat) VALUES ("Anabelle",1)

INSERT INTO livros_autores
(id_livro,id_autor,datae) VALUES (1,1,"2017-03-10"), (1,2,"2017-03-10")
