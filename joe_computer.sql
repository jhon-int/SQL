CREATE DATABASE joe_computer;

CREATE TABLE categorias
(
 id_categoria INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(40) NOT NULL
);

CREATE TABLE clientes
(
 id_cliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 datan DATE NOT NULL,
 uf CHAR(2)
);

CREATE TABLE vendedores
(
 id_vendedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 comissao INT NOT NULL
);

CREATE TABLE produtos
(
 id_produto INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(40) NOT NULL,
 datac DATE NOT NULL,
 estoque INT NOT NULL,
 custo DECIMAL(8,2) NOT NULL,
 lucro INT NOT NULL,
 venda DECIMAL(8,2) NOT NULL, 
 
 id_categoria INT NOT NULL,
 FOREIGN KEY(id_categoria) REFERENCES categorias (id_categoria)
);

CREATE TABLE nfv
(
 id_nfv INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 emissao DATE NOT NULL,
 valor DECIMAL(10,2) NOT NULL,
 
 id_vendedor INT NOT NULL,
 id_cliente INT NOT NULL,
 
 FOREIGN KEY(id_vendedor) REFERENCES vendedores (id_vendedor),
 FOREIGN KEY(id_cliente) REFERENCES clientes (id_cliente)
);

CREATE TABLE itens_nfv
(
 id_itens_nfv INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 valor DECIMAL(8,2) NOT NULL,
 quantidade INT NOT NULL,
 
 id_nfv INT NOT NULL,
 id_produto INT NOT NULL,
 
 FOREIGN KEY(id_nfv) REFERENCES nfv (id_nfv),
 FOREIGN KEY(id_produto) REFERENCES produtos (id_produto)
);

UPDATE produtos SET venda = custo+(custo*lucro/100);

/*criar uma SQL para listar todos os produtos paras suas seguintes categorias
codigop, nomep, data de cadastros formatada, categoria
ordem alfabetica*/
SELECT p.id_produto "Codigo", p.descritivo "Nome Produto", DATE_FORMAT(p.datac,"%d/%m/%Y") "Data Cadastro", c.descritivo "Categoria"
FROM produtos p
INNER JOIN categorias c ON(c.id_categoria=p.id_categoria)
ORDER BY p.descritivo

/*Criar uma SQL para listar todos os produtos que não foram vendidos
codigo, descitivo*/
SELECT p.id_produto "codigo", p.descritivo
FROM produtos p
LEFT JOIN itens_nfv itn ON(itn.id_produto=p.id_produto)
WHERE itn.id_produto IS NULL

/*Listar todos os vendedores que não realizaram nenhuma venda*/
SELECT v.id_vendedor "codigo", v.nome
FROM vendedores v
LEFT JOIN nfv ON(nfv.id_vendedor=v.id_vendedor)
WHERE nfv.id_vendedor IS NULL

/*Criar uma SQL que apresente o total comprado por cada cliente da loja
codigo, nome, valor*/
SELECT c.id_cliente "Codigo", c.nome, CONCAT("R$: ", FORMAT( SUM(n.valor),2)) "Total gasto por cliente"
FROM nfv n
LEFT JOIN clientes c ON(c.id_cliente=n.id_cliente)
GROUP BY n.id_cliente

/*Criar uma SQL para aparesentar o total de vendas realizadas por cada vendedor da loja
codigo, nome, total*/
SELECT v.id_vendedor "codigo", v.nome, CONCAT("R$: ", FORMAT(SUM(n.valor),2)) "Total Vendido", COUNT(n.id_vendedor) "Quantidade"
FROM vendedores v
LEFT JOIN nfv n ON(v.id_vendedor=n.id_vendedor)
GROUP BY v.id_vendedor

/*Criar uma SQL que apresente, Numero Nota Fiscal, Data de Emissão formatada, valor da nota, cliente, vendedor*/
SELECT n.id_nfv, DATE_FORMAT(n.emissao, "%d/%m/%Y") "Emissao", n.valor, c.nome, v.nome
FROM nfv n
LEFT JOIN clientes c ON(n.id_cliente=c.id_cliente)
LEFT JOIN vendedores v ON(n.id_vendedor=v.id_vendedor)


/*...*/
ALTER TABLE nfv ADD id_fp INT

CREATE TABLE forma_pagto
(
 id_fp INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(20) NOT NULL
)

/*Criar um sql que apresente o seguinte layout
codigo, nome, compra a vista, compra a prazo, total*/
CREATE OR REPLACE VIEW VW_compras AS
	SELECT clientes.id_cliente, clientes.nome, SUM(nfv.valor) "A_vista", 0 "A_prazo"
	FROM nfv
	INNER JOIN clientes ON(clientes.id_cliente = nfv.id_cliente)
	INNER JOIN forma_pagto ON(forma_pagto.id_fp = nfv.id_fp)
	WHERE nfv.id_fp = 1
	GROUP BY clientes.id_cliente

	UNION ALL

	SELECT clientes.id_cliente, clientes.nome, 0 "A_vista", SUM(nfv.valor) "A_prazo"
	FROM nfv
	INNER JOIN clientes ON(clientes.id_cliente = nfv.id_cliente)
	INNER JOIN forma_pagto ON(forma_pagto.id_fp = nfv.id_fp)
	WHERE nfv.id_fp = 2
	GROUP BY clientes.id_cliente
		

SELECT id_cliente, nome, SUM(A_vista) "Compras a vista", SUM(A_prazo) "Compras a prazo", SUM(A_vista + A_prazo) "Total" 
FROM vw_compras
GROUP BY id_cliente

/**/

CREATE TABLE fornecedores
(
 if_fornecedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 razao_social VARCHAR(40) NOT NULL
)

CREATE TABLE nfc
(
 id_nfc INT NOT NULL PRIMARY KEY,
 id_fornecedor INT NOT NULL,
 id_fp INT NOT NULL,
 valor DECIMAL(8,2) NOT NULL,
 emissao DATE NOT NULL,
 
 FOREIGN KEY (id_fornecedor) REFERENCES fornecedores (id_fornecedor),
 FOREIGN KEY (id_fp) REFERENCES forma_pagto (id_fp)
)

CREATE TABLE itens_nfc
(
 id_infc INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 id_nfc INT NOT NULL,
 id_produto INT NOT NULL,
 preco DECIMAL(6,2) NOT NULL,
 quantidade INT NOT NULL,
 
 FOREIGN KEY (id_nfc) REFERENCES nfc (id_nfc),
 FOREIGN KEY (id_produto) REFERENCES produtos (id_produto)
)

/*ano, compras, vendas, diferença*/
CREATE OR REPLACE VIEW VW_Relatorio_Diferenca AS
	SELECT YEAR(emissao) "ano", SUM(nfc.valor) "compras", 0 "vendas"
	FROM nfc
	GROUP BY YEAR(emissao)

	UNION ALL

	SELECT YEAR(emissao) "ano", 0 "compras", SUM(nfv.valor) "vendas"
	FROM nfv
	GROUP BY YEAR(emissao)
	

SELECT ano "Ano", SUM(compras) "Compras", SUM(vendas) "Vendas", SUM(vendas - compras) "Diferença"
FROM vw_relatorio_diferenca
GROUP BY ano

/*Subquery*/
SELECT ano "Ano", SUM(compras) "Compras", SUM(vendas) "Vendas", SUM(vendas - compras) "Diferença"
FROM (SELECT YEAR(emissao) "ano", SUM(nfc.valor) "compras", 0 "vendas" FROM nfc GROUP BY YEAR(emissao) UNION ALL 
      SELECT YEAR(emissao) "ano", 0 "compras", SUM(nfv.valor) "vendas" FROM nfv GROUP BY YEAR(emissao)) tab
GROUP BY ano

/*Criar uma SQL para calcular o percentual vendido de cada produto da empresa com relação ao total geral vendido*/
SELECT 
	produtos.id_produto, 
	produtos.descritivo,
	SUM(itens_nfv.quantidade*itens_nfv.valor) "Total Prod", 
	(SELECT SUM(itens_nfv.quantidade*itens_nfv.valor) FROM itens_nfv INNER JOIN nfv ON(nfv.id_nfv = itens_nfv.id_nfv) WHERE YEAR(nfv.emissao) IN (2017,2018)) "Total Geral", 
	CONCAT(FORMAT((SUM(itens_nfv.quantidade*itens_nfv.valor) / (SELECT SUM(itens_nfv.quantidade*itens_nfv.valor) FROM itens_nfv INNER JOIN nfv ON(nfv.id_nfv = itens_nfv.id_nfv) WHERE YEAR(nfv.emissao) IN (2017,2018))) * 100,2) ,"%") AS Percentual
FROM itens_nfv
INNER JOIN produtos ON(itens_nfv.id_produto = produtos.id_produto)
INNER JOIN nfv ON(nfv.id_nfv = itens_nfv.id_nfv)
WHERE YEAR(nfv.emissao) IN (2017,2018)
GROUP BY itens_nfv.id_itens_nfv


/*Criar um SQL que liste os valores a serem pagos de comissão a todos os vendedores da empresa no ano de 2018 
e indique o percentual do vendedor em relação ao total geral vendido no ano indicado*/
SELECT
	vendedores.id_vendedor,
	vendedores.nome,
	SUM(nfv.valor) "Total Vendido",
	CONCAT(vendedores.comissao,"%") "%comissão",
	FORMAT(SUM(nfv.valor * vendedores.comissao)/100,2)"Valor Comissão",
	CONCAT(FORMAT((SUM(nfv.valor) / (SELECT SUM(nfv.valor) FROM nfv WHERE YEAR(nfv.emissao) = 2017))*100,2),"%") "%Total"
FROM vendedores
INNER JOIN nfv ON(nfv.id_vendedor = vendedores.id_vendedor)
WHERE YEAR(nfv.emissao) IN (2017)
GROUP BY vendedores.id_vendedor

/*Criar um SQL para listar os 3 produtos mais vendidos na empresa no periodo de 2016 a 2018*/
SELECT 
	produtos.id_produto "Codigo", 
	produtos.descritivo "Produto",
	SUM(itens_nfv.quantidade) "Total Vendido"
FROM itens_nfv
INNER JOIN produtos ON(itens_nfv.id_produto = produtos.id_produto)
INNER JOIN nfv ON(nfv.id_nfv = itens_nfv.id_nfv)
WHERE YEAR(nfv.emissao) IN (2016,2017,2018)
GROUP BY itens_nfv.id_produto
ORDER BY SUM(itens_nfv.quantidade) DESC
LIMIT 3

/**/
SELECT 
	clientes.id_cliente,
	clientes.nome,
	(SELECT COALESCE(SUM(nfv.valor),0) FROM nfv WHERE nfv.id_fp = 1 AND nfv.id_cliente = clientes.id_cliente) "Total A Vista",
	(SELECT COALESCE(SUM(nfv.valor),0) FROM nfv WHERE nfv.id_fp = 2 AND nfv.id_cliente = clientes.id_cliente) "Total Prazo",
	(SELECT COALESCE(SUM(nfv.valor),0) FROM nfv WHERE nfv.id_cliente = clientes.id_cliente) "Total Geral"
FROM clientes
INNER JOIN nfv ON(clientes.id_cliente = nfv.id_cliente)
INNER JOIN forma_pagto ON(forma_pagto.id_fp = nfv.id_fp)
WHERE nfv.id_cliente = clientes.id_cliente
GROUP BY nfv.id_cliente
ORDER BY clientes.nome

/*criar uma SQL para listar todos os totais comprados e vendidos separadas por mes*/
SELECT
	MONTH(nfv.emissao) "Mês", 
	SUM(nfv.valor) "Total Comprado",
	COALESCE((SELECT SUM(nfc.valor) FROM nfc WHERE MONTH(nfv.emissao) = MONTH(nfc.emissao)),0) "Total Vendido"
FROM nfv
GROUP BY MONTH(nfv.emissao)

DELIMITER //
DROP PROCEDURE IF EXISTS lista_cliente //
CREATE PROCEDURE lista_cliente (IN cod INT)
BEGIN
	/*Corpo da Procedure*/
	IF (cod IS NULL) THEN
		SELECT * 
		FROM clientes;
		
        ELSE
        IF (cod IN (SELECT clientes.id_cliente FROM clientes)) THEN
            SELECT * 
            FROM clientes 
            WHERE clientes.id_cliente = cod;
        ELSE
            SELECT "Cliente não cadastrado!!" AS Mensagem;
        END IF;
        
	END IF;
END;
//
DELIMITER ;

CALL lista_cliente(NULL);

/*Criar uma procedure que disponibilize ao vendedor uma listagem dos produtos com custo e ao cliente uma sem custo*/
DELIMITER //
DROP PROCEDURE IF EXISTS lista_produto //
CREATE PROCEDURE lista_produto (IN cod INT)
BEGIN
	IF(cod = 1) THEN
		SELECT produtos.id_produto "Codigo", produtos.descritivo, produtos.custo, produtos.venda 
		FROM produtos;
		
        ELSE
        IF(cod = 2) THEN
            SELECT produtos.id_produto "Codigo", produtos.descritivo, produtos.venda
            FROM produtos;
        ELSE
            SELECT "Codigo Invalido" AS Mensagem;
        END IF;
        
	END IF;
END;
//
DELIMITER ;

CALL lista_produto(2);

/*Adicionar Nova categoria em descritivo na tabela Categorias*/
DELIMITER //
DROP PROCEDURE IF EXISTS in_cat //
CREATE PROCEDURE in_cat (IN cat VARCHAR(30))
BEGIN
    IF cat <> "" AND cat IS NOT NULL THEN
        INSERT INTO categorias (descritivo) 
        VALUES (cat);
    ELSE 
        SELECT "Informação invalida!!" AS Mensagem;
    END IF;
END;
//
DELIMITER ;

CALL in_cat("bacon");

/*Adicionar Novo vendedor em nome, comicao na tabela vendedores*/
DELIMITER //
DROP PROCEDURE IF EXISTS in_ven //
CREATE PROCEDURE in_ven (IN vendedor VARCHAR(30), comissao INT)
BEGIN
    IF vendedor <> "" AND vendedor IS NOT NULL THEN
        IF comissao > 0 THEN
            INSERT INTO vendedores (nome,comissao) 
            VALUES (vendedor,comissao);
        
        ELSE 
            SELECT "Valor da comissao invalida!!" AS Mensagem;
        END IF;
    ELSE 
        SELECT "Nome do vendedor invalido!!" AS Mensagem;
    END IF;
END;
//
DELIMITER ;

CALL in_ven("Rafael",20);

/*Criar uma procedure para atualizar o preço de custo de um determinado produto ou de todos em x%.
Se a procedure receber como parametro vazio, então atualizara todos os produtos.
Se receber um codigo especifico devera atualizar somente ele.*/
DELIMITER //
DROP PROCEDURE IF EXISTS atualizar_preco //
CREATE PROCEDURE atualizar_preco (IN cod INT, per INT)
BEGIN
	IF(cod IS NULL) OR cod = "" THEN
		UPDATE produtos
		SET custo = custo + (custo*per/100);
		
    ELSE
        IF(cod IN (SELECT produtos.id_produto FROM produtos)) THEN
          UPDATE produtos
          SET custo = custo + (custo*per/100)
          WHERE produtos.id_produto = cod;  
        
        ELSE
            SELECT "Codigo Invalido" AS Mensagem;
    END IF;
	END IF;    
END;
//
DELIMITER ;

CALL atualizar_preco(2,2);

/*Criar uma procedure para listar todas as vendas realizadas no periodo indicado. A listagem deverá ser classificada por ordem de emissão (asc)
NroNF Valor Emissão Cliente Vendedor FPagto*/
DELIMITER //
DROP PROCEDURE IF EXISTS Listar_Vendas //
CREATE PROCEDURE Listar_Vendas (IN datai DATE, dataf DATE)
BEGIN
    IF(EXISTS(SELECT nfv.emissao FROM nfv WHERE nfv.emissao BETWEEN datai AND dataf)) THEN
        SELECT 
            nfv.id_nfv "Nr. NF", 
            CONCAT("R$: ", FORMAT(nfv.valor,2)) "Valor", 
            DATE_FORMAT(nfv.emissao,"%d/%m/%y") "Emissao", 
            clientes.nome "Cliente", 
            vendedores.nome "Vendedor", 
            forma_pagto.descritivo "Forma de pagamento"
        FROM nfv
        INNER JOIN clientes ON(clientes.id_cliente = nfv.id_cliente)
        INNER JOIN vendedores ON(vendedores.id_vendedor = nfv.id_vendedor)
        INNER JOIN forma_pagto ON(forma_pagto.id_fp = nfv.id_fp)
        WHERE nfv.emissao BETWEEN datai AND dataf
        ORDER BY nfv.emissao;
        
        ELSE
            SELECT "Codigo Invalido" AS Mensagem;
    END IF;
END;
//
DELIMITER ;

CALL Listar_Vendas('2017/01/01', '2017/05/01');

/*Criar uma procedure para listar o total vendido por cada vendedor indicando o valor de comissão a ser pago para cada um.
codigo nome totalVendido valordeComissão*/
DELIMITER //
DROP PROCEDURE IF EXISTS Listar_Ven //
CREATE PROCEDURE Listar_Ven (IN cod INT)
BEGIN
    IF cod = "" OR cod IS NULL THEN
        SELECT 
                vendedores.id_vendedor "ID", 
                vendedores.nome "Vendedor", 
                CONCAT("R$: ", FORMAT(SUM(nfv.valor),2)) "Total de vendas", 
                CONCAT("R$: ", FORMAT(SUM(nfv.valor) * vendedores.comissao/100,2)) "Valor de Comissão"
        FROM vendedores
        INNER JOIN nfv ON(vendedores.id_vendedor = nfv.id_vendedor)
        GROUP BY vendedores.id_vendedor;
        
    ELSE        
        IF(cod IN (SELECT vendedores.id_vendedor FROM vendedores)) THEN
            IF(cod IN (SELECT nfv.id_vendedor FROM nfv)) THEN
                SELECT 
                        vendedores.id_vendedor "ID", 
                        vendedores.nome "Vendedor", 
                        CONCAT("R$: ", FORMAT(SUM(nfv.valor),2)) "Total de vendas", 
                        CONCAT("R$: ", FORMAT(SUM(nfv.valor) * vendedores.comissao/100,2)) "Valor de Comissão"
                FROM vendedores
                INNER JOIN nfv ON(vendedores.id_vendedor = nfv.id_vendedor)
                WHERE vendedores.id_vendedor = cod;
  
            ELSE
                SELECT "Vendedor não realizou vendas" AS Mensagem;
            END IF;
        ELSE
            SELECT "Vendedor não cadastrado" AS Mensagem;
        END IF;
    END IF;
END;
//
DELIMITER ;

CALL Listar_Ven(9);

/*Procedure para calcular e retornar o total comprado por um determinado cliente e um periodo indicado pelo usuario. (retornar o nome e o total)*/
DELIMITER //
DROP PROCEDURE IF EXISTS Cal_cli //
CREATE PROCEDURE Cal_cli (IN cod INT, inicio DATE, fim DATE, OUT vl DECIMAL(8,2), OUT nomec VARCHAR(100))
BEGIN
    IF(cod NOT IN (SELECT clientes.id_cliente FROM clientes)) THEN
        SELECT "Cliente não cadastrado" AS Mensagem;
    ELSE
        IF(EXISTS(SELECT nfv.emissao FROM nfv WHERE cod = nfv.id_cliente AND nfv.emissao BETWEEN inicio AND fim)) THEN
            SELECT 
                    SUM(nfv.valor),
                    (SELECT clientes.nome FROM clientes WHERE clientes.id_cliente = cod)
            FROM nfv
            WHERE nfv.id_cliente = cod
                AND nfv.emissao BETWEEN inicio AND fim
            INTO vl, nomec;
        ELSE
            SELECT "Não existe vendas para este cliente" AS mensagem;
        END IF;
    END IF;
END;
//
DELIMITER ;

CALL Cal_cli(1,'2016/01/01','2018/01/01',@valor,@nome);

SELECT CONCAT("R$: ",FORMAT(@valor,2)) "Valor", @nome "Nome do Cliente"

DELIMITER //
DROP TRIGGER IF EXISTS venda_prod //
CREATE TRIGGER venda_prod
        AFTER INSERT ON itens_nfv
    FOR EACH ROW
BEGIN
    UPDATE produtos 
    SET produtos.estoque = produtos.estoque - new.quantidade
    WHERE produtos.id_produto = new.id_produto;
END;
//
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS insert_itens_nfv //
CREATE PROCEDURE insert_itens_nfv (cod_nfv INT, cod_prod INT, valor DECIMAL(8,2), quant INT)
BEGIN
    IF(cod_nfv IN (SELECT nfv.id_nfv FROM nfv)) THEN
        IF(cod_prod IN (SELECT produtos.id_produto FROM produtos)) THEN
            IF(quant <= (SELECT produtos.estoque FROM produtos WHERE produtos.id_produto = cod_prod)) THEN
                INSERT INTO itens_nfv (id_nfv, id_produto, valor, quantidade)
                VALUES (cod_nfv, cod_prod, valor, quant);
            ELSE
                SELECT "Estoque insuficiente" AS Mensagem;
            END IF;
        ELSE
            SELECT "Produto não Existe" AS Mensagem;
        END IF;
    ELSE
        SELECT "Nota Fiscal de Venda não Existe" AS Mensagem;
    END IF;
END;
//
DELIMITER ;

CALL insert_itens_nfv(2,2,50,2);


DELIMITER //
DROP TRIGGER IF EXISTS compra_prod //
CREATE TRIGGER compra_prod
        AFTER INSERT ON itens_nfc
    FOR EACH ROW
BEGIN
    UPDATE produtos 
    SET produtos.estoque = produtos.estoque + new.quantidade
    WHERE produtos.id_produto = new.id_produto;
END;
//
DELIMITER ;

DELIMITER //
DROP PROCEDURE IF EXISTS insert_itens_nfc //
CREATE PROCEDURE insert_itens_nfc (cod_nfc INT, cod_prod INT, preco DECIMAL(8,2), quant INT)
BEGIN
    IF(cod_nfc IN (SELECT nfc.id_nfc FROM nfc)) THEN
        IF(cod_prod IN (SELECT produtos.id_produto FROM produtos)) THEN
            INSERT INTO itens_nfc (id_nfc, id_produto, preco, quantidade)
            VALUES (cod_nfc, cod_prod, preco, quant);
        ELSE
            SELECT "Produto não Existe" AS Mensagem;
        END IF;
    ELSE
        SELECT "Nota Fiscal de Compra não Existe" AS Mensagem;
    END IF;
END;
//
DELIMITER ;

CALL insert_itens_nfc(1000,2,50,2);

DELIMITER //
DROP TRIGGER IF EXISTS compra_prod //
CREATE TRIGGER compra_prod
        AFTER INSERT ON itens_nfc
    FOR EACH ROW
BEGIN
    UPDATE produtos 
    SET produtos.estoque = produtos.estoque + new.quantidade
    WHERE produtos.id_produto = new.id_produto;
    
END;
//
DELIMITER ;

CREATE TABLE forn_prod
(
    id_forn_prod INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    datauc DATE NOT NULL,
    custouc DECIMAL(8,2) NOT NULL,
    
    id_fornecedor INT NOT NULL,
    id_produto INT NOT NULL
)

    
DELIMITER //
DROP PROCEDURE IF EXISTS insert_itens_nfc2 //
CREATE PROCEDURE insert_itens_nfc2 (cod_nfc INT, cod_prod INT, preco DECIMAL(8,2), quant INT)
BEGIN
    IF(cod_nfc IN (SELECT nfc.id_nfc FROM nfc)) THEN
        IF(cod_prod IN (SELECT produtos.id_produto FROM produtos)) THEN
            INSERT INTO fornec_prod (id_for, id_prod, datauc, custouc)
            VALUES ((SELECT nfc.id_fornecedor FROM nfc WHERE nfc.cod_nfc = new.cod_nfc), new.cod_prod, CURRENT_DATE, new.preco);
        ELSE
            SELECT "Não Existe" AS Mensagem;
        END IF;
    ELSE
        SELECT "Não Existe" AS Mensagem;
    END IF;
END;
//
DELIMITER ;






