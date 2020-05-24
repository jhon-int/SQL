/*
SQLyog Enterprise - MySQL GUI v8.12 
MySQL - 5.5.27 : Database - facul
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/`facul` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `facul`;

/*Table structure for table `aluno` */

DROP TABLE IF EXISTS `aluno`;

CREATE TABLE `aluno` (
  `id_aluno` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  `sexo` enum('F','M') DEFAULT NULL,
  `datan` date NOT NULL,
  `id_curso` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_aluno`),
  KEY `id_curso` (`id_curso`),
  CONSTRAINT `aluno_ibfk_1` FOREIGN KEY (`id_curso`) REFERENCES `curso` (`id_curso`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

/*Data for the table `aluno` */

insert  into `aluno`(`id_aluno`,`nome`,`sexo`,`datan`,`id_curso`) values (1,'Gabriel','M','1996-03-27',1),(2,'Lucas ','M','1994-02-07',2),(3,'Pedro','M','1994-02-03',3),(4,'Patricia','F','1995-05-02',4),(5,'Thais','F','2000-01-01',1),(6,'Laura','F','1992-03-04',2),(7,'Jose','M','1993-02-05',3),(8,'Tiago','M','2000-01-02',4),(9,'Luan','M','1990-10-10',5),(10,'Joao','M','1995-02-03',5);

/*Table structure for table `aluno_disciplina` */

DROP TABLE IF EXISTS `aluno_disciplina`;

CREATE TABLE `aluno_disciplina` (
  `id_aluno_disciplina` int(11) NOT NULL AUTO_INCREMENT,
  `id_aluno` int(11) NOT NULL,
  `id_disciplina` int(11) NOT NULL,
  `Media` decimal(4,2) NOT NULL,
  PRIMARY KEY (`id_aluno_disciplina`),
  KEY `id_aluno` (`id_aluno`),
  KEY `id_disciplina` (`id_disciplina`),
  CONSTRAINT `aluno_disciplina_ibfk_1` FOREIGN KEY (`id_aluno`) REFERENCES `aluno` (`id_aluno`),
  CONSTRAINT `aluno_disciplina_ibfk_2` FOREIGN KEY (`id_disciplina`) REFERENCES `disciplina` (`id_disciplina`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;

/*Data for the table `aluno_disciplina` */

insert  into `aluno_disciplina`(`id_aluno_disciplina`,`id_aluno`,`id_disciplina`,`Media`) values (1,1,1,'7.00'),(2,1,2,'5.00'),(3,1,3,'6.00'),(4,2,1,'5.00'),(5,2,2,'6.00'),(6,2,3,'2.00'),(7,3,1,'5.00'),(8,3,2,'5.00'),(9,3,3,'8.00'),(10,4,4,'5.00'),(11,4,5,'6.00'),(12,4,6,'7.00'),(13,5,4,'6.00'),(14,5,1,'7.00'),(15,5,5,'6.00'),(16,6,4,'1.00'),(17,6,5,'3.00'),(18,6,6,'8.00'),(19,7,1,'8.00'),(20,7,2,'9.00'),(21,8,4,'7.00'),(22,9,1,'7.00'),(23,9,3,'6.00'),(24,9,7,'9.00'),(25,10,8,'9.00'),(26,10,9,'6.00'),(27,10,10,'8.00');

/*Table structure for table `curso` */

DROP TABLE IF EXISTS `curso`;

CREATE TABLE `curso` (
  `id_curso` int(11) NOT NULL AUTO_INCREMENT,
  `descritivo` varchar(30) NOT NULL,
  PRIMARY KEY (`id_curso`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `curso` */

insert  into `curso`(`id_curso`,`descritivo`) values (1,'Sistema para Internet'),(2,'Gestão de TI'),(3,'Logistica'),(4,'Meio Ambiente'),(5,'Navegação');

/*Table structure for table `curso_prof` */

DROP TABLE IF EXISTS `curso_prof`;

CREATE TABLE `curso_prof` (
  `id_curso_prof` int(11) NOT NULL AUTO_INCREMENT,
  `id_professor` int(11) NOT NULL,
  `id_curso` int(11) NOT NULL,
  `data_inicio` date DEFAULT NULL,
  PRIMARY KEY (`id_curso_prof`),
  KEY `id_professor` (`id_professor`),
  KEY `id_curso` (`id_curso`),
  CONSTRAINT `curso_prof_ibfk_1` FOREIGN KEY (`id_professor`) REFERENCES `professor` (`id_professor`),
  CONSTRAINT `curso_prof_ibfk_2` FOREIGN KEY (`id_curso`) REFERENCES `curso` (`id_curso`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

/*Data for the table `curso_prof` */

insert  into `curso_prof`(`id_curso_prof`,`id_professor`,`id_curso`,`data_inicio`) values (1,1,1,'2010-01-01'),(2,2,1,'2000-01-01'),(3,3,2,'1990-01-01'),(4,4,1,'1980-02-01'),(5,1,5,'2010-10-01'),(6,2,3,'2000-01-01'),(7,5,3,'1985-01-01'),(8,6,1,'1990-03-02'),(9,5,1,'2010-09-01');

/*Table structure for table `disciplina` */

DROP TABLE IF EXISTS `disciplina`;

CREATE TABLE `disciplina` (
  `id_disciplina` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(20) NOT NULL,
  `cargah` int(11) NOT NULL,
  `valor` decimal(6,2) DEFAULT NULL,
  `id_professor` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_disciplina`),
  KEY `id_professor` (`id_professor`),
  CONSTRAINT `disciplina_ibfk_1` FOREIGN KEY (`id_professor`) REFERENCES `professor` (`id_professor`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

/*Data for the table `disciplina` */

insert  into `disciplina`(`id_disciplina`,`descricao`,`cargah`,`valor`,`id_professor`) values (1,'Banco de dados I',4,'110.00',1),(2,'Banco de dados II',4,'110.00',1),(3,'Estrutura de dados',4,'110.00',2),(4,'Marketing',2,'55.00',6),(5,'Servidor I',4,'110.00',4),(6,'Servidor II',4,'100.00',5),(7,'Ingles I',2,'50.00',3),(8,'Ingles II',2,'50.00',3),(9,'Gestão da Produção',2,'50.00',6),(10,'Linguagem de Program',4,'100.00',2);

/*Table structure for table `professor` */

DROP TABLE IF EXISTS `professor`;

CREATE TABLE `professor` (
  `id_professor` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  PRIMARY KEY (`id_professor`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

/*Data for the table `professor` */

insert  into `professor`(`id_professor`,`nome`) values (1,'Wdson'),(2,'Cação'),(3,'Vera'),(4,'Simone'),(5,'Vania'),(6,'Robson'),(7,'Anderson');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
