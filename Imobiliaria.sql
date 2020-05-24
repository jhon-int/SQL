/*
SQLyog Enterprise - MySQL GUI v8.12 
MySQL - 5.1.56-community : Database - imobiliaria
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/`imobiliaria` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `imobiliaria`;

/*Table structure for table `clientes` */

DROP TABLE IF EXISTS `clientes`;

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  `sexo` enum('F','M') NOT NULL,
  `rg` char(9) NOT NULL,
  `cpf` char(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `cidade` varchar(40) NOT NULL,
  `uf` char(2) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `rg` (`rg`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `clientes` */

insert  into `clientes`(`id_cliente`,`nome`,`sexo`,`rg`,`cpf`,`email`,`cidade`,`uf`) values (1,'Bartolomeu','M','456123456','78945612389','Bar@gmail.com','Jauh','SP'),(2,'Mr. Bacon','M','987654132','98745632102','Bacon@baconoso.com','Barra','SP'),(3,'Maria','F','562314564','5632145623','M@gmail.com','Jahu','SP');

/*Table structure for table `imoveis` */

DROP TABLE IF EXISTS `imoveis`;

CREATE TABLE `imoveis` (
  `id_imovel` int(11) NOT NULL AUTO_INCREMENT,
  `valor` decimal(8,2) NOT NULL,
  `numero_comodos` int(11) NOT NULL,
  `cidade` varchar(40) NOT NULL,
  `uf` char(2) NOT NULL,
  `id_tipo_imovel` int(11) NOT NULL,
  `id_proprietario` int(11) NOT NULL,
  PRIMARY KEY (`id_imovel`),
  KEY `id_tipo_imovel` (`id_tipo_imovel`),
  KEY `id_proprietario` (`id_proprietario`),
  CONSTRAINT `imoveis_ibfk_1` FOREIGN KEY (`id_tipo_imovel`) REFERENCES `tipo_imovel` (`id_tipo_imovel`),
  CONSTRAINT `imoveis_ibfk_2` FOREIGN KEY (`id_proprietario`) REFERENCES `proprietarios` (`id_proprietario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `imoveis` */

insert  into `imoveis`(`id_imovel`,`valor`,`numero_comodos`,`cidade`,`uf`,`id_tipo_imovel`,`id_proprietario`) values (1,'6600.00',8,'Barra Bonita','SP',1,3),(2,'450.00',4,'Boca','SP',2,2),(3,'850.00',3,'Jahu','SP',1,2);

/*Table structure for table `locacao` */

DROP TABLE IF EXISTS `locacao`;

CREATE TABLE `locacao` (
  `id_locacao` int(11) NOT NULL AUTO_INCREMENT,
  `data_inicio` date DEFAULT NULL,
  `data_fim` date DEFAULT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_imovel` int(11) NOT NULL,
  PRIMARY KEY (`id_locacao`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_imovel` (`id_imovel`),
  CONSTRAINT `locacao_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `locacao_ibfk_2` FOREIGN KEY (`id_imovel`) REFERENCES `imoveis` (`id_imovel`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `locacao` */

insert  into `locacao`(`id_locacao`,`data_inicio`,`data_fim`,`id_cliente`,`id_imovel`) values (1,'2018-02-06','2018-04-01',1,1),(2,'2018-05-05','2018-09-15',2,1),(3,'2018-05-02','2018-06-06',1,2),(4,'2018-01-01','2018-09-08',2,2);

/*Table structure for table `proprietarios` */

DROP TABLE IF EXISTS `proprietarios`;

CREATE TABLE `proprietarios` (
  `id_proprietario` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  `sexo` enum('F','M') NOT NULL,
  `rg` char(9) NOT NULL,
  `cpf` char(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `cidade` varchar(40) NOT NULL,
  `uf` char(2) NOT NULL,
  PRIMARY KEY (`id_proprietario`),
  UNIQUE KEY `rg` (`rg`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `proprietarios` */

insert  into `proprietarios`(`id_proprietario`,`nome`,`sexo`,`rg`,`cpf`,`email`,`cidade`,`uf`) values (1,'Bill','M','456123456','78945612345','Bill@gmail.com','Minas','MG'),(2,'Rafael','M','456123457','78945612347','Rafa@gmail.com','Boca','SP'),(3,'Milena Dias','F','456123462','78945612342','Mina@gmail.com','Barra','SP');

/*Table structure for table `telefones` */

DROP TABLE IF EXISTS `telefones`;

CREATE TABLE `telefones` (
  `id_telefone` int(11) NOT NULL AUTO_INCREMENT,
  `numero` varchar(14) NOT NULL,
  `id_proprietario` int(11) NOT NULL,
  PRIMARY KEY (`id_telefone`),
  UNIQUE KEY `numero` (`numero`),
  KEY `id_proprietario` (`id_proprietario`),
  CONSTRAINT `telefones_ibfk_1` FOREIGN KEY (`id_proprietario`) REFERENCES `proprietarios` (`id_proprietario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `telefones` */

insert  into `telefones`(`id_telefone`,`numero`,`id_proprietario`) values (1,'14965325678',1),(2,'14653245689',2);

/*Table structure for table `tipo_imovel` */

DROP TABLE IF EXISTS `tipo_imovel`;

CREATE TABLE `tipo_imovel` (
  `id_tipo_imovel` int(11) NOT NULL AUTO_INCREMENT,
  `descritivo` varchar(30) NOT NULL,
  PRIMARY KEY (`id_tipo_imovel`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

/*Data for the table `tipo_imovel` */

insert  into `tipo_imovel`(`id_tipo_imovel`,`descritivo`) values (1,'apartamento'),(2,'Casa'),(3,'Chacara'),(4,'Sala Comercial');

/*Table structure for table `exercicio_6` */

DROP TABLE IF EXISTS `exercicio_6`;

/*!50001 DROP VIEW IF EXISTS `exercicio_6` */;
/*!50001 DROP TABLE IF EXISTS `exercicio_6` */;

/*!50001 CREATE TABLE `exercicio_6` (
  `id_imovel` int(11) NOT NULL DEFAULT '0',
  `descritivo` varchar(30) NOT NULL,
  `Proprietario` varchar(40) NOT NULL,
  `Cliente` varchar(40) NOT NULL,
  `valor` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 */;

/*Table structure for table `lista_imoveis` */

DROP TABLE IF EXISTS `lista_imoveis`;

/*!50001 DROP VIEW IF EXISTS `lista_imoveis` */;
/*!50001 DROP TABLE IF EXISTS `lista_imoveis` */;

/*!50001 CREATE TABLE `lista_imoveis` (
  `Codigo` int(11) NOT NULL DEFAULT '0',
  `Tipo` varchar(30) NOT NULL,
  `valor` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 */;

/*Table structure for table `view_1` */

DROP TABLE IF EXISTS `view_1`;

/*!50001 DROP VIEW IF EXISTS `view_1` */;
/*!50001 DROP TABLE IF EXISTS `view_1` */;

/*!50001 CREATE TABLE `view_1` (
  `codigo` int(11) NOT NULL DEFAULT '0',
  `proprietario` varchar(40) NOT NULL,
  `receita` decimal(30,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 */;

/*Table structure for table `view_2` */

DROP TABLE IF EXISTS `view_2`;

/*!50001 DROP VIEW IF EXISTS `view_2` */;
/*!50001 DROP TABLE IF EXISTS `view_2` */;

/*!50001 CREATE TABLE `view_2` (
  `codigo` int(11) NOT NULL DEFAULT '0',
  `n_imoveis` bigint(21) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 */;

/*View structure for view exercicio_6 */

/*!50001 DROP TABLE IF EXISTS `exercicio_6` */;
/*!50001 DROP VIEW IF EXISTS `exercicio_6` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `exercicio_6` AS select `imoveis`.`id_imovel` AS `id_imovel`,`tipo_imovel`.`descritivo` AS `descritivo`,`proprietarios`.`nome` AS `Proprietario`,`clientes`.`nome` AS `Cliente`,`imoveis`.`valor` AS `valor` from ((((`locacao` join `imoveis` on((`locacao`.`id_imovel` = `imoveis`.`id_imovel`))) join `tipo_imovel` on((`tipo_imovel`.`id_tipo_imovel` = `imoveis`.`id_tipo_imovel`))) join `clientes` on((`clientes`.`id_cliente` = `locacao`.`id_cliente`))) join `proprietarios` on((`proprietarios`.`id_proprietario` = `imoveis`.`id_proprietario`))) where ((year(`locacao`.`data_inicio`) = 2018) and (`imoveis`.`valor` between 800 and 1500)) order by `imoveis`.`valor` */;

/*View structure for view lista_imoveis */

/*!50001 DROP TABLE IF EXISTS `lista_imoveis` */;
/*!50001 DROP VIEW IF EXISTS `lista_imoveis` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `lista_imoveis` AS select `imoveis`.`id_imovel` AS `Codigo`,`tipo_imovel`.`descritivo` AS `Tipo`,`imoveis`.`valor` AS `valor` from (`imoveis` join `tipo_imovel` on((`tipo_imovel`.`id_tipo_imovel` = `imoveis`.`id_tipo_imovel`))) */;

/*View structure for view view_1 */

/*!50001 DROP TABLE IF EXISTS `view_1` */;
/*!50001 DROP VIEW IF EXISTS `view_1` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_1` AS select `proprietarios`.`id_proprietario` AS `codigo`,`proprietarios`.`nome` AS `proprietario`,sum(`imoveis`.`valor`) AS `receita` from ((`locacao` join `imoveis` on((`locacao`.`id_imovel` = `imoveis`.`id_imovel`))) join `proprietarios` on((`proprietarios`.`id_proprietario` = `imoveis`.`id_proprietario`))) group by `imoveis`.`id_proprietario` */;

/*View structure for view view_2 */

/*!50001 DROP TABLE IF EXISTS `view_2` */;
/*!50001 DROP VIEW IF EXISTS `view_2` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_2` AS select `proprietarios`.`id_proprietario` AS `codigo`,count(`imoveis`.`id_imovel`) AS `n_imoveis` from ((`imoveis` join `proprietarios` on((`proprietarios`.`id_proprietario` = `imoveis`.`id_proprietario`))) join `locacao` on((`locacao`.`id_imovel` = `imoveis`.`id_imovel`))) group by `imoveis`.`id_proprietario` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
