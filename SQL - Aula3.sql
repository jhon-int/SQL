CREATE DATABASE RH_Empresa

CREATE TABLE empresas
(
 id_empresa INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL
)

CREATE TABLE departamentos
(
 id_departamento INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL
)

CREATE TABLE cargos
(
 id_cargo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL
)

CREATE TABLE projetos
(
 id_projato INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL,
 percentual DECIMAL(3,2)
)

CREATE TABLE funcionarios
(
 id_funcionario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 sexo ENUM("F","M"),
 datanascimento DATE NOT NULL,
 admissao DATE NOT NULL,
 salario DECIMAL(8,2) DEFAULT 0,
 
 id_empresa INT NOT NULL,
 id_departamento INT NOT NULL,
 id_cargo INT NOT NULL,
 
 FOREIGN KEY(id_empresa) REFERENCES empresas (id_empresa),
 FOREIGN KEY(id_departamento) REFERENCES departamentos (id_departamento),
 FOREIGN KEY(id_cargo) REFERENCES cargos (id_cargo)
)

CREATE TABLE dependentes
(
 id_dependente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 sexo ENUM("F","M"),
 datanascimento DATE NOT NULL,
 
 id_funcionario INT NOT NULL,
 FOREIGN KEY(id_funcionario) REFERENCES funcionarios (id_funcionario)
)

CREATE TABLE funcionarios_projetos
(
 id_funcionario_projeto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 datai DATE NOT NULL,
 hora DECIMAL(3,2) NOT NULL,
 
 id_projato INT NOT NULL,
 id_funcionario INT NOT NULL,
 
 FOREIGN KEY(id_projato) REFERENCES projetos (id_projato),
 FOREIGN KEY(id_funcionario) REFERENCES funcionarios (id_funcionario)
)

INSERT INTO empresas(descritivo)
 VALUES ("Unidade Igaracu"), ("Unidade Barra Bonita")
 
INSERT INTO departamentos(descritivo)
 VALUES ("Financeiro"), ("Projetos"), ("Vendas"), ("Secretaria") 
 
INSERT INTO cargos(descritivo)
 VALUES ("Programador"), ("Diretor"), ("Secretaria"), ("DBA") 
 
INSERT INTO funcionarios(nome,sexo,datanascimento,admissao,salario,id_empresa,id_departamento,id_cargo)
 VALUES ("Rafael", "M", "1997/11/27", "2018/02/02", "4500.69", 2, 1, 1), ("Billian", "M", "1998/09/15", "20150/04/02", "6563.52", 3, 3, 3), ("Juninho", "M", "1993/08/20", "2012/08/02", "2563.52", 4, 4, 4)
 

/*Adicionar campo na tabela*/
ALTER TABLE cargos
 ADD teste INT NOT NULL 


/*Remover campo da tabela*/ 
ALTER TABLE departamentos DROP teste

/*Alterar o tipo de dado de um campo*/
ALTER TABLE cargos 
MODIFY teste VARCHAR(20)

/*Renomear um campo*/
ALTER TABLE cargos
CHANGE COLUMN teste testando VARCHAR(10)

/*Renomear uma tabela*/
ALTER TABLE cargo
RENAME TO cargos

/*Deletar um registro da tabela*/
DELETE FROM funcionarios
WHERE salario = 6563.52

/*Atulizar qualquer campo da tabela*/
UPDATE funcionarios  SET salario = salario + (salario*10/100)
WHERE sexo="M" AND id_empresa = 2 AND id_cargo IN (1,2)

UPDATE dependentes SET datanascimento = "2017/09/23"
WHERE sexo="M" AND id_funcionario = 2

UPDATE projetos SET percentual = 4.50
WHERE id_projato = 2

UPDATE funcionarios SET bairro = "centro"

/*Listar registro e campo*/
SELECT id_funcionario "Codigo", nome
FROM funcionarios
WHERE YEAR(admissao) = 2017 AND MONTH(admissao) = 02

/*Listar entra uma data e outra*/
SELECT id_funcionario "Codigo", nome
FROM funcionarios
WHERE admissao NOT BETWEEN "2016/01/01" AND "2018/01/01"

SELECT id_funcionario "Codigo", nome
FROM funcionarios
WHERE YEAR(admissao) = 2017 AND MONTH(admissao) IN (02,04,06)

/*listar todos os funcionarios do sexo masculino admitidos entre o ano de 2015 e 2017, cujo o salario variam de 1000 a 5000 reais. */
SELECT id_funcionario "Codigo", nome, sexo, salario, DATE_FORMAT(admissao,"%d/%M/%Y") admissao
FROM funcionarios
WHERE sexo="M" AND YEAR(admissao) BETWEEN 2015 AND 2018 AND salario BETWEEN 1000 AND 22000

/*listar codigo, nome e data de nascimento de todos os dependentes*/
SELECT id_dependente "Codigo", nome, DATE_FORMAT(datanascimento,"%d/%M/%Y") "Data de Nascimento", YEAR(CURRENT_DATE) - YEAR(datanascimento) "Idade"
FROM dependentes
ORDER BY datanascimento

/*listar todos os funcionarios cuja a idade esteja entre 18 e 30 anos*/
SELECT id_funcionario "Codigo", nome, YEAR(CURRENT_DATE) - YEAR(datanascimento) "Idade"
FROM funcionarios
WHERE YEAR(CURRENT_DATE) - YEAR(datanascimento) BETWEEN 18 AND 30
ORDER BY nome

/*Listar id, nome e cargo funcionarios*/
SELECT id_funcionario "Codigo", nome, id_cargo "Cargo"
FROM funcionarios

/*Listar id, nome e cargo funcionarios da tabela funcionarios juntando com a tabela cargos*/
SELECT id_funcionario "Codigo", nome, cargos.descritivo "Cargo", departamentos.descritivo "Departamento"
FROM funcionarios 
INNER JOIN cargos ON(funcionarios.id_cargo=cargos.id_cargo)
INNER JOIN departamentos ON(funcionarios.id_departamento=departamentos.id_departamento)

/*Listar id, nome e cargo funcionarios da tabela funcionarios juntando com a tabela cargos resumido*/
SELECT id_funcionario "Codigo", nome, c.descritivo "Cargo", d.descritivo "Departamento"
FROM funcionarios f 
INNER JOIN cargos c ON(f.id_cargo=c.id_cargo)
INNER JOIN departamentos d ON(f.id_departamento=d.id_departamento)

/*Criar sql para listar codigo do dependente, nome dependete, nome funcionario*/
SELECT f.id_funcionario "Codigo", f.nome "Funcionarios", d.nome "Filhos"
FROM funcionarios f
INNER JOIN dependentes d
ON(f.id_funcionario=d.id_funcionario)


/*1-) Criar uma SQL que liste todos os funcionarios do sexo feminino com salario entre 1000 e 2000 de acordo com o layot abaixo
codigo nome sexo salario cargo departamento unidade da empresa*/
SELECT f.id_funcionario "Codigo", f.nome, f.sexo, c.descritivo "Cargo", d.descritivo "Departamento", e.descritivo "Unidade da Empresa"
FROM funcionarios f
INNER JOIN cargos c ON(f.id_cargo=c.id_cargo)
INNER JOIN departamentos d ON(f.id_departamento=d.id_departamento)
INNER JOIN empresas e ON(f.id_empresa=e.id_empresa)
WHERE salario BETWEEN 2000 AND 9000 AND sexo="F"
ORDER BY c.descritivo


/*2-) Criar uma SQL para listar os funcionarios com seus respectivos projetos de acondo com o layot da lousa
codigo nome projeto percentual*/
SELECT f.id_funcionario "Codigo", f.nome, p.descritivo "Projetos", p.percentual "Percentual"
FROM funcionarios_projetos fp
INNER JOIN funcionarios f ON(fp.id_funcionario=f.id_funcionario)
INNER JOIN projetos p ON(fp.id_projato=p.id_projato)

/*modelagem, inserir, alteração, select*/

/*Criar uma SQL para listar todos os funcionaros que não possuem dependentes*/
SELECT f.id_funcionario "Codigo", f.nome
FROM funcionarios f 
LEFT JOIN dependentes d ON (f.id_funcionario = d.id_funcionario)
WHERE d.id_funcionario IS NULL 

/*Criar uma SQL para listar todos os funcionarios que não desenvolvem projetos*/
SELECT f.id_funcionario "Codigo", f.nome
FROM funcionarios f
LEFT JOIN funcionarios_projetos fp ON(fp.id_funcionario=f.id_funcionario)
WHERE fp.id_funcionario_projeto IS NULL 

/*Criar uma SQL para listar todos os funcionarios de acordo com o seguinte layut, codigo funcionario, nome do funcionario, descritivo do cargo para todos que não possuem projeto*/
SELECT f.id_funcionario "Codigo", f.nome, c.descritivo
FROM funcionarios f
LEFT JOIN funcionarios_projetos fp ON(fp.id_funcionario=f.id_funcionario)
INNER JOIN cargos c ON(c.id_cargo=f.id_cargo)
WHERE fp.id_funcionario_projeto IS NULL 

/*Criar uma SQL para listar todos os projetos que não tem funcionarios associados, listar em ordem alfabetica pelo projetos*/
SELECT p.id_projato "Codigo", p.descritivo
FROM projetos p
LEFT JOIN funcionarios_projetos fp ON(fp.id_projato=p.id_projato)
WHERE fp.id_funcionario_projeto IS NULL
ORDER BY p.descritivo

/*id, nome, salario*/
SELECT id_funcionario "Codigo", nome, salario, FORMAT(salario*0.05,2) "Aumento", FORMAT(salario * 1.05,2) "Salario com Aumento" 
FROM funcionarios f
WHERE

/*Case, when*/
SELECT id_funcionario "Codigo", nome, salario,
 CASE
  WHEN salario<1000 THEN CONCAT(FORMAT(salario*1.15,2)," (15%)") 
  WHEN salario BETWEEN 1000 AND 5000 THEN CONCAT(FORMAT(salario*1.10,2)," (10%)") 
  ELSE CONCAT(FORMAT(salario*1.05,2)," (5%)")
 END "Salario com Aumento"
FROM funcionarios f

/*Criar uma SQL para apresentar o seguinte relatorio:
	codigo, nome, idade, classificação*/
SELECT d.id_dependente "Codigo", d.nome, YEAR(CURRENT_DATE) - YEAR(d.datanascimento) "Idade",
 CASE
  WHEN YEAR(CURRENT_DATE) - YEAR(d.datanascimento) <= 10 THEN "Criança"
  WHEN YEAR(CURRENT_DATE) - YEAR(d.datanascimento) BETWEEN 10 AND 18 THEN "Adolencente"
  ELSE "Adulto"
 END "Classificação"
FROM dependentes d

/*Soma salarios, contar numero de registros, media, mostrar maior e menor salario*/
SELECT SUM(salario) "Folha de pagamento total", COUNT(id_funcionario) "Numero de funcionarios", FORMAT(AVG(salario),2) "Media", MAX(salario)"Maior Salario", MIN(salario)"Menor Salario"
FROM funcionarios
WHERE id_empresa = 1

/*Criar uma SQL que apresente o numero de projetos da empresa*/
SELECT COUNT(id_projato) "Numero de projetos"
FROM projetos

SELECT e.id_empresa "Codigo", e.descritivo, COUNT(f.id_empresa) "Numero de Funcionarios"
FROM funcionarios f 
INNER JOIN empresas e ON(f.id_empresa=e.id_empresa)
GROUP BY e.id_empresa

/*Criar uma SQL que apresente o numero de funcionarios por departamento*/
SELECT d.id_departamento "Codigo", d.descritivo, COUNT(f.id_departamento) "Numero de Funcionarios por Departamento"
FROM funcionarios f
INNER JOIN departamentos d ON(d.id_departamento=f.id_departamento)
GROUP BY d.id_departamento

/*Criar uma SQL que liste o numero de funcionarios que trabalha em cada projeto desenvolvido na empresa*/
SELECT p.id_projato "Codigo", p.descritivo, COUNT(fp.id_projato)"Numero de Funcionarios por Projetos"
FROM funcionarios_projetos fp
INNER JOIN projetos p ON(p.id_projato=fp.id_projato)
GROUP BY p.id_projato

/*Criar uma SQL que apresente a folha de pagamento de cada unidade da emrpesa*/
SELECT e.id_empresa "Codigo", e.descritivo, CONCAT("R$: " ,FORMAT(SUM(f.salario),2)) "Folha de Pagamento" 
FROM funcionarios f
INNER JOIN empresas e ON(f.id_empresa=e.id_empresa)
GROUP BY f.salario

/*Criar uma SQL que apresentem os funcionarios que possuem mais que um dependentes*/
SELECT f.id_funcionario "Codigo", f.nome, COUNT(d.id_dependente) "Numero dependentes"
FROM funcionarios f
INNER JOIN dependentes d ON(f.id_funcionario=d.id_funcionario)
GROUP BY d.id_funcionario
HAVING COUNT(d.id_dependente) >=2

/*Criar uma SQL que apresente funcionarios que trabalham em mais de um projeto.
Somente os funcionarios cuja a idade esteja entre 18 e 25 anos.
A listagem devera vir em ordem de idade*/

SELECT f.id_funcionario "Codigo", f.nome, COUNT(fp.id_funcionario) "Numero de Projetos", YEAR(CURRENT_DATE) - YEAR(f.datanascimento) "Idade"
FROM funcionarios f
INNER JOIN funcionarios_projetos fp ON(f.id_funcionario=fp.id_funcionario)
INNER JOIN projetos p ON(p.id_projato=fp.id_projato)
WHERE YEAR(CURRENT_DATE) - YEAR(f.datanascimento) BETWEEN 18 AND 25
GROUP BY f.id_funcionario
HAVING COUNT(fp.id_funcionario) > 1
ORDER BY f.datanascimento

/*View => Tabela Virtual*/
CREATE OR REPLACE VIEW lista_imoveis AS
	SELECT imoveis.id_imovel "Codigo", tipo_imovel.descritivo "Tipo", imoveis.valor
	FROM imoveis
	INNER JOIN tipo_imovel ON(tipo_imovel.id_tipo_imovel = imoveis.id_tipo_imovel)
	
SELECT * FROM lista_imoveis

/*Criar uma sql para listar as seguintes informações: codigo imovel, tipo, valor, cliente*/
SELECT Codigo, Tipo, valor, clientes.nome
FROM lista_imoveis
INNER JOIN locacao ON(locacao.id_imovel = lista_imoveis.Codigo)
INNER JOIN clientes ON(clientes.id_cliente = locacao.id_cliente)

