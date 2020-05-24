

CREATE DATABASE 

USE rh_empresa;

/*Table structure for table cargos */

DROP TABLE IF EXISTS cargos;

CREATE TABLE cargos (
  id_cargo INT(11) NOT NULL AUTO_INCREMENT,
  descritivo VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_cargo)
) 

/*Data for the table cargos */

LOCK TABLES cargos WRITE;

INSERT  INTO cargos(id_cargo,descritivo) VALUES (1,'Programador'),(2,'Diretor'),(3,'Secretaria'),(4,'DBA');

UNLOCK TABLES;

/*Table structure for table departamentos */

DROP TABLE IF EXISTS departamentos;

CREATE TABLE departamentos (
  id_departamento INT(11) NOT NULL AUTO_INCREMENT,
  descritivo VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_departamento)
) 

/*Data for the table departamentos */

LOCK TABLES departamentos WRITE;

INSERT  INTO departamentos(id_departamento,descritivo) VALUES (1,'Financeiro'),(2,'Projetos'),(3,'Vendas'),(4,'Secretaria');

UNLOCK TABLES;

/*Table structure for table dependentes */

DROP TABLE IF EXISTS dependentes;

CREATE TABLE dependentes (
  id_dependente INT(11) NOT NULL AUTO_INCREMENT,
  nome VARCHAR(40) NOT NULL,
  sexo ENUM('F','M') DEFAULT NULL,
  datanascimento DATE NOT NULL,
  id_funcionario INT(11) NOT NULL,
  PRIMARY KEY (id_dependente),
  KEY id_funcionario (id_funcionario),
  CONSTRAINT dependentes_ibfk_1 FOREIGN KEY (id_funcionario) REFERENCES funcionarios (id_funcionario)
) 

/*Data for the table dependentes */

LOCK TABLES dependentes WRITE;

INSERT  INTO dependentes(id_dependente,nome,sexo,datanascimento,id_funcionario) VALUES (1,'blagson','M','2000-05-06',1),(2,'pocahontas','F','1998-08-09',1),(3,'Biloba','F','1998-01-02',2),(4,'barba','M','1998-01-03',2),(5,'barbarosa','F','1997-01-03',2);

UNLOCK TABLES;

/*Table structure for table empresas */

DROP TABLE IF EXISTS empresas;

CREATE TABLE empresas (
  id_empresa INT(11) NOT NULL AUTO_INCREMENT,
  descritivo VARCHAR(20) NOT NULL,
  PRIMARY KEY (id_empresa)
) 

/*Data for the table empresas */

LOCK TABLES empresas WRITE;

INSERT  INTO empresas(id_empresa,descritivo) VALUES (1,'Unidade Igaracu'),(2,'Unidade Barra Bonita');

UNLOCK TABLES;

/*Table structure for table funcionarios */

DROP TABLE IF EXISTS funcionarios;

CREATE TABLE funcionarios (
  id_funcionario INT(11) NOT NULL AUTO_INCREMENT,
  nome VARCHAR(40) NOT NULL,
  sexo ENUM('F','M') DEFAULT NULL,
  datanascimento DATE NOT NULL,
  admissao DATE NOT NULL,
  salario DECIMAL(8,2) DEFAULT '0.00',
  id_empresa INT(11) NOT NULL,
  id_departamento INT(11) NOT NULL,
  id_cargo INT(11) NOT NULL,
  PRIMARY KEY (id_funcionario),
  KEY id_empresa (id_empresa),
  KEY id_departamento (id_departamento),
  KEY id_cargo (id_cargo),
  CONSTRAINT funcionarios_ibfk_1 FOREIGN KEY (id_empresa) REFERENCES empresas (id_empresa),
  CONSTRAINT funcionarios_ibfk_2 FOREIGN KEY (id_departamento) REFERENCES departamentos (id_departamento),
  CONSTRAINT funcionarios_ibfk_3 FOREIGN KEY (id_cargo) REFERENCES cargos (id_cargo)
) 

/*Data for the table funcionarios */

LOCK TABLES funcionarios WRITE;

INSERT  INTO funcionarios(id_funcionario,nome,sexo,datanascimento,admissao,salario,id_empresa,id_departamento,id_cargo) VALUES (1,'Rafael','M','1997-11-27','2018-02-02','4500.69',2,1,1),(2,'Jubileu','M','1998-08-05','2017-02-05','1098.90',1,1,2),(3,'Birileu','M','1998-05-06','2016-05-06','800.00',1,1,2),(4,'Milena','F','1999-05-08','2018-03-23','999.00',1,2,2);

UNLOCK TABLES;

/*Table structure for table funcionarios_projetos */

DROP TABLE IF EXISTS funcionarios_projetos;

CREATE TABLE funcionarios_projetos (
  id_funcionario_projeto INT(11) NOT NULL AUTO_INCREMENT,
  datai DATE NOT NULL,
  hora DECIMAL(3,2) NOT NULL,
  id_projato INT(11) NOT NULL,
  id_funcionario INT(11) NOT NULL,
  PRIMARY KEY (id_funcionario_projeto),
  KEY id_projato (id_projato),
  KEY id_funcionario (id_funcionario),
  CONSTRAINT funcionarios_projetos_ibfk_1 FOREIGN KEY (id_projato) REFERENCES projetos (id_projato),
  CONSTRAINT funcionarios_projetos_ibfk_2 FOREIGN KEY (id_funcionario) REFERENCES funcionarios (id_funcionario)
) 

/*Data for the table funcionarios_projetos */

LOCK TABLES funcionarios_projetos WRITE;

INSERT  INTO funcionarios_projetos(id_funcionario_projeto,datai,hora,id_projato,id_funcionario) VALUES (1,'0000-00-00','9.99',1,1);

UNLOCK TABLES;

/*Table structure for table projetos */

DROP TABLE IF EXISTS projetos;

CREATE TABLE projetos (
  id_projato INT(11) NOT NULL AUTO_INCREMENT,
  descritivo VARCHAR(20) NOT NULL,
  percentual DECIMAL(3,2) DEFAULT NULL,
  PRIMARY KEY (id_projato)
) 

/*Data for the table projetos */

LOCK TABLES projetos WRITE;

INSERT  INTO projetos(id_projato,descritivo,percentual) VALUES (1,'bacon','8.00'),(2,'hamburguer','9.00');

UNLOCK TABLES;

/* Procedure structure for procedure Listar_Dependentes */

/*!50003 DROP PROCEDURE IF EXISTS  Listar_Dependentes */;

DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS Listar_Dependentes //
CREATE PROCEDURE Listar_Dependentes (IN cod INT)
BEGIN
    IF(cod IS NULL OR cod = "")THEN
        SELECT "Codigo Invalido" AS Mensagem;
    ELSE
        IF(cod IN (SELECT funcionarios.id_funcionario FROM funcionarios))THEN
            IF(cod IN (SELECT dependentes.id_funcionario FROM dependentes))THEN
                SELECT 
                    dependentes.id_dependente "Codigo", 
                    dependentes.nome, 
                    dependentes.sexo, 
                    DATE_FORMAT(dependentes.datanascimento, "%d/%m/%Y") "Data Nascimento"
                FROM dependentes
                WHERE cod = dependentes.id_funcionario;
            ELSE
                SELECT "Funcionario não tem filhos" AS Mensagem;
            END IF;
        ELSE
            SELECT "Funcionario não existe" AS Mensagem;
        END IF;
    END IF;
END;
//
DELIMITER ;

CALL Listar_Dependentes (NULL);

/*Criar uma procedure que liste todos os funcionarios de uma determinada unidade da empresa que trabalhe 
mais do que 10 horas em projetos e possuem mais do que 2 dependentes.
codigo nome TotalDeHorasTrabalhadas TotalDep*/
DELIMITER //
DROP PROCEDURE IF EXISTS Listar_Funcionarios_Unidade //
CREATE PROCEDURE Listar_Funcionarios_Unidade (IN cod INT)
BEGIN
    IF(cod IS NULL OR cod = "")THEN
        SELECT "Codigo Invalido" AS Mensagem;
    ELSE
        IF(cod IN (SELECT funcionarios.id_empresa FROM funcionarios))THEN
            SELECT 
                    funcionarios.id_funcionario, 
                    funcionarios.nome, 
                    (SELECT SUM(funcionarios_projetos.hora) FROM funcionarios_projetos WHERE funcionarios_projetos.id_funcionario = funcionarios.id_funcionario) "Total_de_Horas",
                    (SELECT COUNT(dependentes.id_dependente) FROM dependentes WHERE dependentes.id_funcionario = funcionarios.id_funcionario) "Total_de_Dependentes"
            FROM funcionarios
            WHERE funcionarios.id_empresa = cod
            GROUP BY funcionarios.id_funcionario
            HAVING Total_de_Horas > 4
            AND Total_de_Dependentes > 1;
        ELSE
            SELECT "Unidade não cadastrada" AS Mensagem;
        END IF;
    END IF;
END;
//
DELIMITER ;

CALL Listar_Funcionarios_Unidade (2);

/*Calcule e retorne o nro de funcionarios da empresa*/
DELIMITER //
DROP PROCEDURE IF EXISTS nro_func //
CREATE PROCEDURE nro_func (OUT nf INT)
BEGIN
    SELECT COUNT(*) INTO nf
    FROM funcionarios;
END;
//
DELIMITER ;

CALL nro_func(@funcionario);

SELECT @funcionario

/*Calcule o nro de projetos desenvolvidos na empresa*/
DELIMITER //
DROP PROCEDURE IF EXISTS nro_proj //
CREATE PROCEDURE nro_proj (OUT np INT)
BEGIN
    SELECT COUNT(*) INTO np
    FROM projetos;
END;
//
DELIMITER ;

CALL nro_proj(@projetos);

SELECT @projetos

/*Calcule o nro de cargos na empresa*/
DELIMITER //
DROP PROCEDURE IF EXISTS nro_cargos //
CREATE PROCEDURE nro_cargos (OUT nc INT)
BEGIN
    SELECT COUNT(*) INTO nc
    FROM cargos;
END;
//
DELIMITER ;

CALL nro_cargos(@cargos);

SELECT @cargos

/*procedure para calcular a folha de pagamento de toda a empresa */
DELIMITER //
DROP PROCEDURE IF EXISTS folha_pag //
CREATE PROCEDURE folha_pag (OUT fp DECIMAL(8,2))
BEGIN
    SELECT SUM(funcionarios.salario) INTO fp
    FROM funcionarios;
END;
//
DELIMITER ;

CALL folha_pag(@folha_pagamento);

SELECT CONCAT("R$: ",FORMAT(@folha_pagamento,2)) "Folha de Pagamento"

/*procedure para calcular o folha de pagamento de uma determinada empresa*/
DELIMITER //
DROP PROCEDURE IF EXISTS folha_pag_emp //
CREATE PROCEDURE folha_pag_emp (IN cod INT, OUT fp DECIMAL(8,2), OUT fpe VARCHAR(100))
BEGIN
    IF(cod NOT IN (SELECT empresas.id_empresa FROM empresas))THEN
        SELECT "Unidade não cadastrada" AS Mensagem;
    ELSE
        IF(cod IN (SELECT DISTINCT funcionarios.id_empresa FROM funcionarios))THEN
            SELECT SUM(funcionarios.salario) INTO fp
            FROM funcionarios
            WHERE funcionarios.id_empresa = cod;
            
            SELECT empresas.descritivo INTO fpe
            FROM empresas
            WHERE empresas.id_empresa = cod;
        ELSE
            SELECT "Não a funcionarios nesta empresa" AS Mensagem;
        END IF;
    END IF;
END;
//
DELIMITER ;

CALL folha_pag_emp(2,@folha_pag_emp,@nomeempresa);

SELECT CONCAT("R$: ",FORMAT(@folha_pag_emp,2)) "Folha de Pagamento", @nomeempresa "Nome da Empresa"

/*Procedure para calcular o nro de dependentes de um determinado funcionario da empresa indicando o nome do mesmo*/
DELIMITER //
DROP PROCEDURE IF EXISTS nro_dep_emp //
CREATE PROCEDURE nro_dep_emp (IN cod INT, OUT nd INT,OUT nomed VARCHAR(100))
BEGIN
    IF(cod NOT IN (SELECT funcionarios.id_funcionario FROM funcionarios))THEN
        SELECT "Funcionario não cadastrado" AS Mensagem;
    ELSE
        IF(cod IN (SELECT DISTINCT dependentes.id_funcionario FROM dependentes))THEN
            SELECT 
                    COUNT(dependentes.id_funcionario),
                    (SELECT funcionarios.nome FROM funcionarios WHERE funcionarios.id_funcionario = cod)
            FROM dependentes
            WHERE dependentes.id_funcionario = cod
            INTO nd, nomed;
        ELSE
            SELECT "Funcionario não tem dependentes" AS Mensagem;
        END IF;
    END IF;
END;
//
DELIMITER ;

CALL nro_dep_emp(2,@quantdep,@nomefunc);

SELECT @quantdep "Quantidade de Dependentes", @nomefunc "Nome do Funcionario"

