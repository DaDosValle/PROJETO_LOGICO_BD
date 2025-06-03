SHOW DATABASES;
USE ecommerce_DIO;
SHOW TABLES;

-- Quantos pedidos foram feitos por cada cliente?
 SELECT
  C.idCliente AS Identificacao,
  C.Primeiro_Nome, 
  C.Primeiro_Sobrenome,
    COUNT(Pe.idPedido) AS Quantidade_Pedido,
    P.Status_Pagamento
FROM
  Cliente AS C
  JOIN Pagamento AS P ON C.idCliente = P.Cliente_idCliente
  JOIN Pedido AS Pe ON P.idPagamento = Pe.idPagamento AND P.Cliente_idCliente = Pe.Cliente_idCliente
GROUP BY 
  C.idCliente, C.Primeiro_Nome, C.Primeiro_Sobrenome, P.Status_Pagamento;
    
    -- CADA CLIENTE FEZ SOMENTE UM PEDIDO, MAS NEM TODOS OS PEDIDOS FORAM CONCLUIDO PAGAMENTO
    
 SELECT
  C.idCliente AS Identificacao,
  C.Primeiro_Nome, 
  C.Primeiro_Sobrenome,
  COUNT(Pe.idPedido) AS Quantidade_Pedido,
  P.Status_Pagamento
FROM
  Cliente AS C
  JOIN Pagamento AS P ON C.idCliente = P.Cliente_idCliente
  JOIN Pedido AS Pe ON P.idPagamento = Pe.idPagamento AND P.Cliente_idCliente = Pe.Cliente_idCliente
  WHERE P.Status_Pagamento = 'Concluido'
GROUP BY 
  C.idCliente, C.Primeiro_Nome, C.Primeiro_Sobrenome;
  
-- APENAS JOAO SILVA, PEDRO OLIVEIRA E ANA LIMA FIZERAM PEDIDO E CONCLUIRAM O PAGAMENTO COM SUCESSO
    
SHOW TABLES;

-- Algum vendedor também é fornecedor?
-- CONFORME ESTRATEGIA DO ECOMMERCE, NENHUM VENDEDOR, AQUI DENOMINADO COMO FUNCIONARIO, É AO MESMO TEMPO FORNECEDOR

-- PODEMOS TENTAR RECUPERAR OUTROS DADOS RELEVANTES

SELECT 
  F.Razao_Social AS Fornecedor,
  P.Nome_Produto AS Produto,
  F.Inicio_Parceria
FROM 
  Fornecedor F
  JOIN Produto_Fornecedor PF ON F.idFornecedor = PF.Fornecedor_idFornecedor
  JOIN Produto P ON PF.Produto_idProduto = P.idProduto
  ORDER BY Inicio_Parceria ASC
  LIMIT 1;
  
-- O FORNECEDOR COM RAZAO SOCIAL IMPORTADORA DE PRODUTOS S.A. É FORNECEDORA PARCEIRA MAIS ANTIGA D ECOMMERCE_DIO
-- A IMPORTADORA DE PRODUTOS S.A. FORNECE SMARTPHONE AO ECOMMERCE_DIO
--

SHOW TABLES;

-- Relação de produtos do nosso fornecedor mais antigo?

SELECT *
FROM PRODUTO;

SELECT
	F.Razao_Social AS Fornecedor,
    F.CNPJ,
    P.Nome_Produto,
    P.Codigo_SSN,
    P.Preco * P.Unidade_Disponiveis AS Valor_Total_em_Produto
FROM 
	Fornecedor AS F
    JOIN Produto_Fornecedor PF ON F.idFornecedor = PF.Fornecedor_idFornecedor
	JOIN Produto P ON PF.Produto_idProduto = P.idProduto
    WHERE Razao_Social = 'Importadora de Produtos S.A.';
    
    -- O FORNECEDOR IMPORTADORA DE PRODUTOS S.A.TEM ARMAZENADO O EQUIVALENTE A 50000
    
    SHOW TABLES;
    
    
    SELECT 
  F.Razao_Social AS Fornecedor,
  SUM(P.Preco * P.Unidade_Disponiveis) AS Valor_Total
FROM 
  Fornecedor AS F
  JOIN Produto_Fornecedor PF ON F.idFornecedor = PF.Fornecedor_idFornecedor
  JOIN Produto P ON PF.Produto_idProduto = P.idProduto
GROUP BY 
  F.Razao_Social
HAVING 
  SUM(P.Preco * P.Unidade_Disponiveis) < 50000
    