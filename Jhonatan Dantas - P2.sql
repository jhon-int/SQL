/*1- insert itens_nfv*/
DELIMITER //
DROP TRIGGER IF EXISTS valor_prod //
CREATE TRIGGER valor_prod
		BEFORE INSERT ON itens_nfv
	FOR EACH ROW
BEGIN
	IF ((SELECT produtos.estoque FROM produtos WHERE produtos.id_produto = new.id_produto) > 100) THEN
		SET new.valor = (SELECT produtos.venda*0.95 FROM produtos WHERE produtos.id_produto = new.id_produto);
	END IF;
	
	IF ((SELECT produtos.estoque FROM produtos WHERE produtos.id_produto = new.id_produto) <= 100) THEN
		SET new.valor = (SELECT produtos.venda FROM produtos WHERE produtos.id_produto = new.id_produto);
	END IF;
END;
//
DELIMITER ;

INSERT INTO itens_nfv (valor, quantidade, id_nfv, id_produto)
VALUES (500, 5, 1, 1)

/*2- update nfv*/
DELIMITER //
DROP TRIGGER IF EXISTS atualiza_nfv //
CREATE TRIGGER atualiza_nfv
		AFTER UPDATE ON itens_nfv
	FOR EACH ROW
BEGIN
	UPDATE nfv
	SET nfv.valor = new.valor * new.quantidade
	WHERE nfv.id_nfv = new.id_nfv;
END;
//
DELIMITER ;

/*3- insert nfv*/
DELIMITER //
DROP TRIGGER IF EXISTS desc_nfv //
CREATE TRIGGER desc_nfv
		BEFORE INSERT ON nfv
	FOR EACH ROW
BEGIN
	IF ((SELECT nfv.valor FROM nfv WHERE nfv.id_nfv = new.id_nfv) < 200) THEN
		SET new.valor = new.valor * 0.95;
	END IF;
	
	IF ((SELECT nfv.valor FROM nfv WHERE nfv.id_nfv = new.id_nfv) > 200 && (SELECT nfv.valor FROM nfv WHERE nfv.id_nfv = new.id_nfv) > 500) THEN
		SET new.valor = new.valor * 0.92;
	END IF;
	
	IF ((SELECT nfv.valor FROM nfv WHERE nfv.id_nfv = new.id_nfv) > 500) THEN
		SET new.valor = new.valor * 0.9;
	END IF;
END;
//
DELIMITER ;

INSERT INTO (emissao, valor, id_vendedor, id_cliente, id_fp) 
VALUES ('2018.05.02', 190, 1, 1, 1)

/*4- entrar codigo, sair razao social, total de produtos*/
DELIMITER //
DROP PROCEDURE IF EXISTS forn_emp //
CREATE PROCEDURE forn_emp (IN cod INT, OUT razao VARCHAR(50), OUT total_prod INT)
BEGIN
	IF(cod IN (SELECT fornecedores.id_fornecedor FROM fornecedores))THEN
		IF(cod IN (SELECT nfc.id_fornecedor FROM nfc WHERE nfc.id_fornecedor = cod))THEN
			SELECT 
				fornecedores.razaos,
				COUNT(nfc.id_fornecedor)
			FROM fornecedores
			INNER JOIN nfc ON(fornecedores.id_fornecedor = nfc.id_fornecedor)
			INTO razao, total_prod;
		ELSE
			SELECT "fornecedor não associado a nenhum produto" AS Mensagem;
		END IF;
	ELSE
		SELECT "fornecedor não existe" AS Mensagem;
	END IF;
END;
//
DELIMITER ;

/*5- in*/
DELIMITER //
DROP PROCEDURE IF EXISTS total_vend //
CREATE PROCEDURE total_vend (IN cod INT, datainicial DATE, datafinal DATE)
BEGIN
	IF(cod IN (SELECT produtos.id_produto FROM produtos))THEN
		IF(EXISTS(SELECT nfv.emissao FROM nfv WHERE nfv.emissao BETWEEN datainicial AND datafinal))THEN
			IF(cod IN (SELECT itens_nfv.id_nfv FROM itens_nfv WHERE itens_nfv.id_produto = cod))THEN
				SELECT DISTINCT
					itens_nfv.id_produto, 
					produtos.descritivo,
					SUM(itens_nfv.quantidade),
					categorias.descritivo
				FROM itens_nfv
				INNER JOIN produtos ON(produtos.id_produto = itens_nfv.id_produto)
				INNER JOIN categorias ON(categorias.id_categoria = produtos.id_categoria)
				WHERE itens_nfv.id_produto = cod;
			ELSE
				SELECT "nao ouve vendas deste produto" AS Mensagem;
			END IF;
		ELSE
			SELECT "nao ouve vendas neste pediodo" AS Mensagem;
		END IF;
	ELSE
		SELECT "produto nao cadastrado" AS Mensagem;
	END IF;
END;
//
DELIMITER ;

CALL total_vend(1, '2016/01/01', '2018/01/01');