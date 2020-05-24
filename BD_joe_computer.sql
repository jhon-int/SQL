/*
SQLyog Enterprise - MySQL GUI v8.12 
MySQL - 5.7.21 : Database - joe_computer
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/`joe_computer` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `joe_computer`;

/*Table structure for table `categorias` */

DROP TABLE IF EXISTS `categorias`;

CREATE TABLE `categorias` (
  `id_categoria` int(11) NOT NULL AUTO_INCREMENT,
  `descritivo` varchar(40) NOT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `categorias` */

LOCK TABLES `categorias` WRITE;

insert  into `categorias`(`id_categoria`,`descritivo`) values (1,'disco rigido'),(2,'placa mae'),(3,'placa de video'),(4,'memoria ram'),(5,'processador');

UNLOCK TABLES;

/*Table structure for table `clientes` */

DROP TABLE IF EXISTS `clientes`;

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  `datan` date NOT NULL,
  `uf` char(2) DEFAULT NULL,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `clientes` */

LOCK TABLES `clientes` WRITE;

insert  into `clientes`(`id_cliente`,`nome`,`datan`,`uf`) values (1,'Wdson','1960-04-08','sp'),(2,'Bruno','1967-05-06','sp'),(3,'Barbara','2017-05-06','sp');

UNLOCK TABLES;

/*Table structure for table `forma_pagto` */

DROP TABLE IF EXISTS `forma_pagto`;

CREATE TABLE `forma_pagto` (
  `id_fp` int(11) NOT NULL AUTO_INCREMENT,
  `descritivo` varchar(20) NOT NULL,
  PRIMARY KEY (`id_fp`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

/*Data for the table `forma_pagto` */

LOCK TABLES `forma_pagto` WRITE;

insert  into `forma_pagto`(`id_fp`,`descritivo`) values (1,'A vista'),(2,'A prazo');

UNLOCK TABLES;

/*Table structure for table `fornec_prod` */

DROP TABLE IF EXISTS `fornec_prod`;

CREATE TABLE `fornec_prod` (
  `id_fornec_prod` int(11) NOT NULL AUTO_INCREMENT,
  `id_for` int(11) NOT NULL,
  `id_prod` int(11) NOT NULL,
  `datauc` date NOT NULL,
  `custouc` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id_fornec_prod`),
  KEY `id_for` (`id_for`),
  KEY `id_prod` (`id_prod`),
  CONSTRAINT `fornec_prod_ibfk_1` FOREIGN KEY (`id_for`) REFERENCES `fornecedores` (`id_fornecedor`),
  CONSTRAINT `fornec_prod_ibfk_2` FOREIGN KEY (`id_prod`) REFERENCES `produtos` (`id_produto`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

/*Data for the table `fornec_prod` */

LOCK TABLES `fornec_prod` WRITE;

insert  into `fornec_prod`(`id_fornec_prod`,`id_for`,`id_prod`,`datauc`,`custouc`) values (1,1,1,'2018-06-13','2000.00');

UNLOCK TABLES;

/*Table structure for table `fornecedores` */

DROP TABLE IF EXISTS `fornecedores`;

CREATE TABLE `fornecedores` (
  `id_fornecedor` int(11) NOT NULL AUTO_INCREMENT,
  `razaos` varchar(40) NOT NULL,
  PRIMARY KEY (`id_fornecedor`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `fornecedores` */

LOCK TABLES `fornecedores` WRITE;

insert  into `fornecedores`(`id_fornecedor`,`razaos`) values (1,'WO Corp.'),(2,'GC Corp.'),(3,'Vera Interprise');

UNLOCK TABLES;

/*Table structure for table `itens_nfc` */

DROP TABLE IF EXISTS `itens_nfc`;

CREATE TABLE `itens_nfc` (
  `id_infc` int(11) NOT NULL AUTO_INCREMENT,
  `id_nfc` int(11) NOT NULL,
  `id_produto` int(11) NOT NULL,
  `preco` decimal(6,2) NOT NULL,
  `quantidade` int(11) NOT NULL,
  PRIMARY KEY (`id_infc`),
  KEY `id_nfc` (`id_nfc`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `itens_nfc_ibfk_1` FOREIGN KEY (`id_nfc`) REFERENCES `nfc` (`id_nfc`),
  CONSTRAINT `itens_nfc_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

/*Data for the table `itens_nfc` */

LOCK TABLES `itens_nfc` WRITE;

insert  into `itens_nfc`(`id_infc`,`id_nfc`,`id_produto`,`preco`,`quantidade`) values (1,1000,1,'500.00',5),(2,1001,4,'1200.00',4),(3,1000,1,'800.00',10),(4,1000,1,'800.00',5),(10,1000,1,'2000.00',5);

UNLOCK TABLES;

/*Table structure for table `itens_nfv` */

DROP TABLE IF EXISTS `itens_nfv`;

CREATE TABLE `itens_nfv` (
  `id_itens_nfv` int(11) NOT NULL AUTO_INCREMENT,
  `valor` decimal(8,2) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `id_nfv` int(11) NOT NULL,
  `id_produto` int(11) NOT NULL,
  PRIMARY KEY (`id_itens_nfv`),
  KEY `id_nfv` (`id_nfv`),
  KEY `id_produto` (`id_produto`),
  CONSTRAINT `itens_nfv_ibfk_1` FOREIGN KEY (`id_nfv`) REFERENCES `nfv` (`id_nfv`),
  CONSTRAINT `itens_nfv_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id_produto`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `itens_nfv` */

LOCK TABLES `itens_nfv` WRITE;

insert  into `itens_nfv`(`id_itens_nfv`,`valor`,`quantidade`,`id_nfv`,`id_produto`) values (1,'500.00',5,1,1),(2,'800.00',2,2,2),(3,'900.00',1,3,3),(4,'600.00',5,1,1),(5,'1000.00',5,1,1);

UNLOCK TABLES;

/*Table structure for table `nfc` */

DROP TABLE IF EXISTS `nfc`;

CREATE TABLE `nfc` (
  `id_nfc` int(11) NOT NULL,
  `id_fornecedor` int(11) NOT NULL,
  `id_fp` int(11) NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `emissao` date NOT NULL,
  PRIMARY KEY (`id_nfc`),
  KEY `id_fornecedor` (`id_fornecedor`),
  KEY `id_fp` (`id_fp`),
  CONSTRAINT `nfc_ibfk_1` FOREIGN KEY (`id_fornecedor`) REFERENCES `fornecedores` (`id_fornecedor`),
  CONSTRAINT `nfc_ibfk_2` FOREIGN KEY (`id_fp`) REFERENCES `forma_pagto` (`id_fp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nfc` */

LOCK TABLES `nfc` WRITE;

insert  into `nfc`(`id_nfc`,`id_fornecedor`,`id_fp`,`valor`,`emissao`) values (1000,1,1,'500.00','2018-03-21'),(1001,2,2,'600.00','2017-03-21');

UNLOCK TABLES;

/*Table structure for table `nfv` */

DROP TABLE IF EXISTS `nfv`;

CREATE TABLE `nfv` (
  `id_nfv` int(11) NOT NULL AUTO_INCREMENT,
  `emissao` date NOT NULL,
  `valor` decimal(10,2) NOT NULL,
  `id_vendedor` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_fp` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_nfv`),
  KEY `id_vendedor` (`id_vendedor`),
  KEY `id_cliente` (`id_cliente`),
  KEY `FK_nfv` (`id_fp`),
  CONSTRAINT `FK_nfv` FOREIGN KEY (`id_fp`) REFERENCES `forma_pagto` (`id_fp`),
  CONSTRAINT `nfv_ibfk_1` FOREIGN KEY (`id_vendedor`) REFERENCES `vendedores` (`id_vendedor`),
  CONSTRAINT `nfv_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `nfv` */

LOCK TABLES `nfv` WRITE;

insert  into `nfv`(`id_nfv`,`emissao`,`valor`,`id_vendedor`,`id_cliente`,`id_fp`) values (1,'2017-08-02','500.00',2,1,1),(2,'2017-09-02','800.00',1,2,2),(3,'2017-10-06','750.00',2,3,1),(4,'2018-03-21','900.00',1,1,2),(5,'2018-06-06','500.00',1,1,1);

UNLOCK TABLES;

/*Table structure for table `produtos` */

DROP TABLE IF EXISTS `produtos`;

CREATE TABLE `produtos` (
  `id_produto` int(11) NOT NULL AUTO_INCREMENT,
  `descritivo` varchar(40) NOT NULL,
  `datac` date NOT NULL,
  `estoque` int(11) NOT NULL,
  `custo` decimal(8,2) NOT NULL,
  `lucro` int(11) NOT NULL,
  `venda` decimal(8,2) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  PRIMARY KEY (`id_produto`),
  KEY `id_categoria` (`id_categoria`),
  CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `produtos` */

LOCK TABLES `produtos` WRITE;

insert  into `produtos`(`id_produto`,`descritivo`,`datac`,`estoque`,`custo`,`lucro`,`venda`,`id_categoria`) values (1,'placa mãe asus','2017-05-02',30,'792.08',20,'649.20',2),(2,'sshd','2017-05-09',20,'272.86',20,'246.00',1),(3,'gtx 1070','2017-05-09',5,'1816.82',30,'1774.50',3),(4,'i7 7200','2017-05-09',8,'1597.20',20,'1440.00',5),(5,'memoria ram 8gb','2017-06-08',50,'505.78',35,'513.00',4);

UNLOCK TABLES;

/*Table structure for table `vendedores` */

DROP TABLE IF EXISTS `vendedores`;

CREATE TABLE `vendedores` (
  `id_vendedor` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) NOT NULL,
  `comissao` int(11) NOT NULL,
  PRIMARY KEY (`id_vendedor`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

/*Data for the table `vendedores` */

LOCK TABLES `vendedores` WRITE;

insert  into `vendedores`(`id_vendedor`,`nome`,`comissao`) values (1,'Rafael',15),(2,'Jhow',30),(3,'Milena',10);

UNLOCK TABLES;

/* Trigger structure for table `itens_nfc` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `compra_prod` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `compra_prod` AFTER INSERT ON `itens_nfc` FOR EACH ROW BEGIN
	UPDATE produtos SET estoque= estoque + new.quantidade WHERE id_produto = new.id_produto;
	
	INSERT INTO fornec_prod (id_for,id_prod,datauc,custouc) VALUES ((SELECT id_fornecedor FROM nfc WHERE id_nfc = new.id_nfc),new.id_produto,current_DAte,new.preco);
END */$$


DELIMITER ;

/* Trigger structure for table `itens_nfv` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `venda_prod` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'root'@'localhost' */ /*!50003 TRIGGER `venda_prod` AFTER INSERT ON `itens_nfv` FOR EACH ROW begin 
	update produtos set estoque = estoque - new.quantidade where id_produto = new.id_produto;
end */$$


DELIMITER ;

/* Procedure structure for procedure `AtPrice` */

/*!50003 DROP PROCEDURE IF EXISTS  `AtPrice` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `AtPrice`(in id int, per int)
begin
		
	
	if(id is null or id = "") then
		UPDATE produtos set custo=custo+(custo*(per/100));
	else
	    if(EXISTS(SELECT * from produtos where id_produto=id))then
		UPDATE produtos SET custo=custo+(custo*(per/100)) where id_produto=id;
	else 
	    SELECT "Produto nao Cadastrado." AS erro;
	       end if;
	  end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `compra_prod` */

/*!50003 DROP PROCEDURE IF EXISTS  `compra_prod` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `compra_prod`(in cod int, cod_prod int, valor DECIMAL(8,2), quant int)
BEGIN
	if(EXISTS(SELECT * from nfc where id_nfc = cod ))then
		if(EXISTS(SELECT * from produtos where id_produto = cod_prod))then
			insert into itens_nfc (id_nfc,id_produto,preco,quantidade) values (cod,cod_prod,valor,quant);
		else 
			SELECT "Produtos n cadastrado" as erro;
		end if;
	else 
		SELECT "NFC n existente" as erro;
	end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `ex8` */

/*!50003 DROP PROCEDURE IF EXISTS  `ex8` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `ex8`(IN cod INT ,p_i date,p_f date,OUT nome VARCHAR(40),out total DECIMAL(8,2))
BEGIN 
	if(EXISTS(SELECT * from clientes where id_cliente = cod))then 
		if(EXISTS(SELECT id_cliente from nfv where nfv.emissao BETWEEN p_i and p_f))then
			SELECT clientes.nome, sum(nfv.valor) into nome,total
			from nfv inner join clientes on(nfv.id_cliente=clientes.id_cliente)
			WHERE clientes.id_cliente = cod and nfv.emissao BETWEEN p_i and p_f;
		else 
			SELECT "Cliente naop efetuou compras" as erro;
		end if;
	else 
		SELECT "Cliente nao cadastrado" AS erro;
	end if;
END */$$
DELIMITER ;

/* Procedure structure for procedure `insert_venda` */

/*!50003 DROP PROCEDURE IF EXISTS  `insert_venda` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_venda`(in cod int, cod_prod int, quant int, valor DECIMAL(8,2))
BEGIN 
	if(EXISTS(SELECT * from nfv where id_nfv=cod))then
			if(EXISTS(SELECT * from produtos where id_produto=cod_prod))then
				if(quant <=(SELECT estoque from produtos where id_produto=cod_prod))then
					insert into itens_nfv (valor,quantidade,id_nfv,id_produto) values (valor,quant,cod,cod_prod);
				else
					SELECT "estoque insuficiente" AS erro;
				end if;
			else 
				SELECT "produto n existe" AS erro;
			end if;
	else 
		SELECT "nota fiscal n existe" as erro;
	end if;
end */$$
DELIMITER ;

/* Procedure structure for procedure `Vend` */

/*!50003 DROP PROCEDURE IF EXISTS  `Vend` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `Vend`(in cod int)
begin 
if(cod is null or cod = "") then
	select  vendedores.id_vendedor "Codigo", vendedores.Nome, sum(nfv.valor) "Total_Vendido", vendedores.Comissao
	from nfv inner join vendedores on(nfv.id_vendedor=vendedores.id_vendedor)
	group by vendedores.id_vendedor;
else
	IF(EXISTS(SELECT * FROM vendedores WHERE id_vendedor = cod)) THEN
		IF(cod NOT IN (SELECT id_vendedor FROM nfv))THEN
			SELECT "Vendedor nao efetuou vendas." AS erro; 	
		else
			select  vendedores.id_vendedor "Codigo", vendedores.Nome, sum(nfv.valor) "Total_Vendido", vendedores.Comissao
			from nfv inner join vendedores on(nfv.id_vendedor=vendedores.id_vendedor)
			where vendedores.id_vendedor = cod
			group by vendedores.id_vendedor;
		END IF;
	ELSE
		SELECT "Vendedor nao cadastrado." AS erro;
	end if;
end if;
	
end */$$
DELIMITER ;

/* Procedure structure for procedure `venda_data` */

/*!50003 DROP PROCEDURE IF EXISTS  `venda_data` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `venda_data`(in ini date,fim date)
begin 
	if(exists(SELECT * from nfv where emissao between ini and fim)) then
	
	SELECT nfv.id_nfv "NroNF", nfv.Valor, nfv.Emissao, clientes.nome "Cliente", vendedores.Nome, forma_pagto.descritivo "FPagto" 
	from nfv inner join forma_pagto on(forma_pagto.id_fp=nfv.id_fp) 
	inner join vendedores on(vendedores.id_vendedor=nfv.id_vendedor) 
	inner join clientes on(clientes.id_cliente=nfv.id_cliente)
	where emissao BETWEEN ini and fim
	order by emissao ;
	
	else 
		SELECT "Esse periodo nao existe." as erro;
		
	end if;
	
end */$$
DELIMITER ;

/*Table structure for table `venda_comp` */

DROP TABLE IF EXISTS `venda_comp`;

/*!50001 DROP VIEW IF EXISTS `venda_comp` */;
/*!50001 DROP TABLE IF EXISTS `venda_comp` */;

/*!50001 CREATE TABLE `venda_comp` (
  `ano` bigint(20) DEFAULT NULL,
  `compras` decimal(30,2) DEFAULT NULL,
  `vendas` decimal(32,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 */;

/*Table structure for table `vista_prazo` */

DROP TABLE IF EXISTS `vista_prazo`;

/*!50001 DROP VIEW IF EXISTS `vista_prazo` */;
/*!50001 DROP TABLE IF EXISTS `vista_prazo` */;

/*!50001 CREATE TABLE `vista_prazo` (
  `codigo` int(11) NOT NULL DEFAULT '0',
  `nome` varchar(40) NOT NULL DEFAULT '',
  `A_Vista` decimal(32,2) DEFAULT NULL,
  `A_Prazo` decimal(32,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 */;

/*View structure for view venda_comp */

/*!50001 DROP TABLE IF EXISTS `venda_comp` */;
/*!50001 DROP VIEW IF EXISTS `venda_comp` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `venda_comp` AS select year(`nfc`.`emissao`) AS `ano`,sum(`nfc`.`valor`) AS `compras`,0 AS `vendas` from `nfc` group by year(`nfc`.`emissao`) union all select year(`nfv`.`emissao`) AS `ano`,0 AS `compras`,sum(`nfv`.`valor`) AS `vendas` from `nfv` group by year(`nfv`.`emissao`) */;

/*View structure for view vista_prazo */

/*!50001 DROP TABLE IF EXISTS `vista_prazo` */;
/*!50001 DROP VIEW IF EXISTS `vista_prazo` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_prazo` AS select `clientes`.`id_cliente` AS `codigo`,`clientes`.`nome` AS `nome`,sum(`nfv`.`valor`) AS `A_Vista`,0 AS `A_Prazo` from (`clientes` join `nfv` on((`clientes`.`id_cliente` = `nfv`.`id_cliente`))) where (`nfv`.`id_fp` = 1) group by `clientes`.`id_cliente` union all select `clientes`.`id_cliente` AS `codigo`,`clientes`.`nome` AS `nome`,0 AS `A_Vista`,sum(`nfv`.`valor`) AS `A_Prazo` from (`clientes` join `nfv` on((`clientes`.`id_cliente` = `nfv`.`id_cliente`))) where (`nfv`.`id_fp` = 2) group by `clientes`.`id_cliente` */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
