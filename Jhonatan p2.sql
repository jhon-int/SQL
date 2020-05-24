/*Exercicio 1*/
SELECT p.id_produto "codigo", p.descritivo, n.id_nfv "Numero NFV", DATE_FORMAT(n.emissao, "%d/%m/%Y") "Emissão", v.nome
FROM nfv n
INNER JOIN itens_nfv inv ON(inv.id_nfv=n.id_nfv) 
INNER JOIN produtos p ON(p.id_produto=inv.id_produto)
INNER JOIN clientes c ON(c.id_cliente=n.id_cliente)
INNER JOIN vendedores v ON(v.id_vendedor=n.id_vendedor)
WHERE MONTH(n.emissao) BETWEEN 10 AND 11
ORDER BY p.descritivo

/*Exercicio 2*/
SELECT p.id_produto "codigo", p.descritivo, c.descritivo 
FROM produtos p
LEFT JOIN categorias c ON(c.id_categoria=p.id_categoria)
LEFT JOIN itens_nfv inv ON(inv.id_produto=p.id_produto) 
WHERE inv.id_produto IS NULL
ORDER BY p.descritivo

/*Exercicio 3*/
SELECT v.id_vendedor "codigo", v.nome, CONCAT("R$: ", FORMAT(SUM(n.valor),2)) "Total Vendido", CONCAT("R$: ", FORMAT(MAX(n.valor),2)) "Maior valor", CONCAT("R$: ", FORMAT(MIN(n.valor),2)) "Menor Valor"
FROM nfv n
INNER JOIN vendedores v ON(v.id_vendedor=n.id_vendedor)
WHERE YEAR(n.emissao) = 2017 AND n.valor BETWEEN 200 AND 1000
GROUP BY n.id_vendedor

/*Exercicio 4*/
SELECT p.id_produto "codigo", p.descritivo, c.descritivo, CONCAT("R$: ",FORMAT(inv.valor,2)) "Venda atual", 
 CASE
  WHEN inv.valor < 200 THEN "5%"
  WHEN inv.valor BETWEEN 200 AND 500 THEN "10%"
  ELSE "15%"
 END "Desconto",
 CASE
  WHEN inv.valor < 200 THEN CONCAT("R$: ",FORMAT(inv.valor*0.95,2))
  WHEN inv.valor BETWEEN 200 AND 500 THEN CONCAT("R$: ",FORMAT(inv.valor*0.9,2))
  ELSE CONCAT("R$: ",FORMAT(inv.valor*0.85,2))
 END "Desconto"
FROM itens_nfv inv
INNER JOIN produtos p ON(p.id_produto=inv.id_produto)
LEFT JOIN categorias c ON(c.id_categoria=p.id_categoria)
ORDER BY p.descritivo
