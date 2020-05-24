/*Exercicio 2*/
CREATE DATABASE Faculdade

CREATE TABLE professor
(
 id_professor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 datanascimento DATE NOT NULL,
 sexo ENUM("F","M")
)

CREATE TABLE curso
(
 id_curso INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL
)

CREATE TABLE disciplina
(
 id_disciplina INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL,
 valor DECIMAL(8,2),
 
 id_professor INT NOT NULL,
 FOREIGN KEY(id_professor) REFERENCES professor (id_professor),
 
 id_curso INT NOT NULL,
 FOREIGN KEY(id_curso) REFERENCES curso (id_curso)
)

CREATE TABLE aluno
(
 id_aluno INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 datanacimento DATE NOT NULL,
 sexo ENUM("F","M"),
 
 id_curso INT NOT NULL,
 FOREIGN KEY(id_curso) REFERENCES curso (id_curso)
)

CREATE TABLE aluno_disciplina
(
 id_aluno_disciplina INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 datamatricula DATE NOT NULL,
 notafinal DECIMAL(2),
 
 id_disciplina INT NOT NULL,
 id_aluno INT NOT NULL,
 
 FOREIGN KEY(id_disciplina) REFERENCES disciplina (id_disciplina),
 FOREIGN KEY(id_aluno) REFERENCES aluno (id_aluno)
)

/*Exercicio 3*/
INSERT INTO professor(nome,datanascimento,sexo)
VALUES ("Jhonatan","1998/02/08","M"), ("Rafael","1997/11/27","M"), ("Abillian","1998/09/15","M")

INSERT INTO curso(descritivo)
VALUES ("Fisica"), ("Biologia"), ("Sistemas")

INSERT INTO disciplina(descritivo,valor,id_professor,id_curso)
VALUES ("Matematica","653.20",1,1), ("Logica","854.60",2,3), ("Micro","251.80",3,2)

INSERT INTO aluno(nome,datanacimento,sexo,id_curso)
VALUES ("Thomas","2000/02/18","M",1), ("Lucas","1999/11/02","M",1), ("Michele","2001/09/20","F",1)

INSERT INTO aluno_disciplina(datamatricula,notafinal,id_disciplina,id_aluno)
VALUES ("2018/02/23","10",1,1), ("2018/02/21","8",2,3), ("2018/02/22","7",3,2)

/*Exercicio 4*/
UPDATE disciplina SET valor = valor*1.10
WHERE id_curso = 1

/*Exercicio 5*/
ALTER TABLE aluno
ADD telefone INT NOT NULL

/*Exercicio 6*/
SELECT id_professor "Codigo do professor", nome, DATE_FORMAT(datanascimento,"%d/%M/%Y") datanacimento 
FROM professor
ORDER BY nome

/*Exercicio 7*/
SELECT d.id_disciplina "Codigo", d.descritivo, p.nome "Professor", c.descritivo "Curso"
FROM disciplina d
INNER JOIN professor p ON(d.id_professor=p.id_professor)
INNER JOIN curso c ON(d.id_curso=c.id_curso)
WHERE valor BETWEEN 100 AND 200 

/*Exercicio 8*/
SELECT a.id_aluno "Codigo", a.nome, d.descritivo "Disciplina", ad.notafinal "Nota", c.descritivo "Curso"
FROM aluno a
INNER JOIN curso c ON(a.id_curso=c.id_curso)
INNER JOIN aluno_disciplina ad ON(a.id_aluno=ad.id_aluno_disciplina)
INNER JOIN disciplina d ON(a.id_aluno=d.id_disciplina)

/*Criar uma SQL para listar todos os alunos que não possuem disciplinas registradas */
SELECT a.id_aluno "Codigo", a.nome, c.descritivo "Curso"
FROM aluno a
LEFT JOIN aluno_disciplina ad ON(a.id_aluno=ad.id_aluno)
INNER JOIN curso c ON(a.id_curso=c.id_curso)
WHERE ad.id_aluno_disciplina IS NULL
ORDER BY a.nome

/*Criar uma SQL que apresente o seguinte relatorio:
	codigo, nome, disciplina, nota, situação*/
SELECT a.id_aluno "Codigo", a.nome, d.descritivo "Disciplina", ad.notafinal "Nota", 
 CASE
  WHEN ad.notafinal < 3 THEN "Reprovado"
  WHEN ad.notafinal BETWEEN 3 AND 6 THEN "Exame"
  ELSE "Aprovado"
 END "Situacao"
FROM aluno a
LEFT JOIN aluno_disciplina ad ON(a.id_aluno=ad.id_aluno)
INNER JOIN disciplina d ON(ad.id_disciplina=d.id_disciplina)


/*Criar uma SQL que apresente o numero de disciplinas da faculdade*/
SELECT COUNT(id_disciplina) "Numero de disciplinas"
FROM disciplina

/*Qual a media total da faculdade*/
SELECT FORMAT(AVG(notafinal),2) "Media da Faculdade"
FROM aluno_disciplina

/*Qual a maior e a menor nota da faculdade*/
SELECT MAX(notafinal) "Maior nota", MIN(notafinal) "Menor nota"
FROM aluno_disciplina

/*Criar uma SQL que lista o numero de disciplinas usar por cada aluno*/
SELECT d.id_disciplina "Codigo", a.nome, c.descritivo, COUNT(ad.id_disciplina) "Numero de disciplinas"
FROM disciplina d
INNER JOIN aluno_disciplina ad ON(ad.id_disciplina=d.id_disciplina)
INNER JOIN aluno a ON(a.id_aluno=ad.id_aluno)
INNER JOIN curso c ON(c.id_curso=d.id_curso)
WHERE ad.notafinal >= 6
GROUP BY a.id_aluno
HAVING COUNT(ad.id_disciplina) >= 2 

