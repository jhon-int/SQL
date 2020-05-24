CREATE DATABASE joe_computer

CREATE TABLE categorias
(
 id_categoria INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 descritivo VARCHAR(40) NOT NULL
)

CREATE TABLE clientes
(
 id_cliente INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 datan DATE NOT NULL,
 uf CHAR(2)
)

CREATE TABLE vendedores
(
 id_vendedor INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(40) NOT NULL,
 comissao INT NOT NULL
)

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
)

CREATE TABLE nfv
(
 id_nfv INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 emissao DATE NOT NULL,
 valor DECIMAL(10,2) NOT NULL,
 
 id_vendedor INT NOT NULL,
 id_cliente INT NOT NULL,
 
 FOREIGN KEY(id_vendedor) REFERENCES vendedores (id_vendedor),
 FOREIGN KEY(id_cliente) REFERENCES clientes (id_cliente)
)

CREATE TABLE itens_nfv
(
 id_itens_nfv INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 valor DECIMAL(8,2) NOT NULL,
 quantidade INT NOT NULL,
 
 id_nfv INT NOT NULL,
 id_produto INT NOT NULL,
 
 FOREIGN KEY(id_nfv) REFERENCES nfv (id_nfv),
 FOREIGN KEY(id_produto) REFERENCES produtos (id_produto)
)

UPDATE produtos SET venda = custo+(custo*lucro/100)

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



