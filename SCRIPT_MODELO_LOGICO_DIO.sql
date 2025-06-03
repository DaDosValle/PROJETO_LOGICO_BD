-- CRIANDO BANCO DE DADOS E SUAS RESPECTIVAS TABELAS PARA O PROJETO DIO - REFINANDO O MODELO

-- PASSO 1 - CRIANDO E ACESSANDO O BD
CREATE DATABASE Ecommerce_DIO;

SHOW DATABASES;

USE ECOMMERCE_DIO;

-- CRIANDO AS TABELAS DO BD
-- POR PREFERENCIA OS ATRIBUTOS SERAO ADICIONADOS EM PORTUGUES

CREATE TABLE Cliente(
	idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Primeiro_Nome VARCHAR(15) NOT NULL,
    Primeiro_Sobrenome VARCHAR(15) NOT NULL,
    Demais_Sobrenome VARCHAR(15) DEFAULT 'Nao informado',
    Primeira_Compra ENUM('Sim','Nao'),
    CPF CHAR(11),
    Nacimento DATE NOT NULL,
    Genero ENUM("Masculino", "Feminino"),
    Email VARCHAR(55) DEFAULT 'Nao preenchido',
    Rua_Endereco VARCHAR(55) NOT NULL,
    Num_Casa_Endereco INT,
    Bairro_Endereco VARCHAR(30) NOT NULL,
    Cidade_Endereco VARCHAR(30) NOT NULL,
    Estado_Endereco VARCHAR(30) NOT NULL,
    CONSTRAINT Unique_Cliente_CPF UNIQUE(CPF)
);

CREATE TABLE Pagamento(
	idPagamento INT,
	Forma_Pagamento ENUM('Cartao_de_credito', 'Cartao_de_debito','PIX', 'Boleto') NOT NULL,
    Status_Pagamento ENUM('Pendente', 'Concluido', 'Erro'),
    Parcelamento ENUM('2','3','4','5','6','7','8','9','10','11','12'),
    Títular_Cartao VARCHAR(65) DEFAULT 'Exclusivo cartao',
    Num_Cartao CHAR(16) DEFAULT 'Exclusivo cartao',
    Validade_Cartao DATE,
    Abertura_Carrinho DATE NOT NULL,
    Data_Pagamento DATE,
    Cliente_idCliente INT NOT NULL,
    CONSTRAINT FK_Cliente_Pagamento FOREIGN KEY(Cliente_idCliente) REFERENCES Cliente(idCliente),
    PRIMARY KEY (idPagamento, Cliente_idCliente)
    );
-- CORRIGINDO ERRO DE REFERENCIA DA FK NA TABELA PEDIDO

CREATE TABLE Pedido(
	idPedido INT AUTO_INCREMENT PRIMARY KEY,
    Observacao_Opcional VARCHAR(55) DEFAULT 'Sem observacao',
    Frete FLOAT,
    idPagamento INT,
    Cliente_idCliente INT,
	CONSTRAINT FK_idPagamento_idCliente FOREIGN KEY(idPagamento, Cliente_idCliente) REFERENCES Pagamento(idPagamento, Cliente_idCliente)
);
CREATE TABLE Estoque(
	idEstoque INT AUTO_INCREMENT PRIMARY KEY,
	Produto_Estoque VARCHAR(30) DEFAULT 'Nao informado',
    Capacidade_Atual ENUM('ALTA', 'MODERADA', 'BAIXA'),
    Cidade_Distribuicao VARCHAR(30) NOT NULL,
    Estado_Distribuicao VARCHAR(30) NOT NULL
);

CREATE TABLE Produto(
	idProduto INT AUTO_INCREMENT PRIMARY KEY,
	Nome_Produto VARCHAR(20) NOT NULL,
    Codigo_SSN INT NOT NULL,
    Nota_Avaliacao ENUM('1','2','3','4','5','6','7','8','9','10'),
    Categoria VARCHAR(20) DEFAULT 'Não especificado',
    Preco FLOAT NOT NULL,
    Percentual_Lucro FLOAT NOT NULL,
    Unidade_Disponiveis INT NOT NULL,
    Estoque_idEstoque INT,
    CONSTRAINT Unique_Produto_Codigo_SSN UNIQUE(Codigo_SSN),
    CONSTRAINT FK_Estoque_Produto FOREIGN KEY(Estoque_idEstoque) REFERENCES Estoque(idEstoque)
);
CREATE TABLE Pedido_Produto(
	Pedido_idPedido INT,
    Produto_idProduto INT,
    Quantidade INT,
    Percentual_Desconto FLOAT,
    Preco_Total FLOAT,
    PRIMARY KEY(Pedido_idPedido, Produto_idProduto),
    CONSTRAINT FK_Pedido_PedidoProduto FOREIGN KEY(Pedido_idPedido) REFERENCES Pedido(idPedido),
    CONSTRAINT FK_Produto_PedidoProduto FOREIGN KEY(Produto_idProduto) REFERENCES Produto(idProduto)
);
CREATE TABLE Fornecedor(
	idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
	Razao_Social VARCHAR(45) NOT NULL,
	CNPJ CHAR(14) NOT NULL,
    Cidade_Fornecedor VARCHAR(30) NOT NULL,
    Estado_Fornecedor VARCHAR(30) NOT NULL,
    Inicio_Parceria DATE NOT NULL,
    CONSTRAINT Unique_Fornecedor_Razao_Social UNIQUE(Razao_Social),
    CONSTRAINT Unique_Fornecedor_CNPJ UNIQUE(CNPJ)
);

CREATE TABLE Produto_Fornecedor(
	Produto_idProduto INT,
    Fornecedor_idFornecedor INT,
    PRIMARY KEY(Produto_idProduto, Fornecedor_idFornecedor),
	CONSTRAINT FK_Produto_ProdutoFornecedor FOREIGN KEY(Produto_idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT FK_Fornecedor_ProdutoFornecedor FOREIGN KEY(Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor)
);
CREATE TABLE Funcionario(
	idFuncionario INT AUTO_INCREMENT PRIMARY KEY,
	Primeiro_Nome_Funcionario VARCHAR(20) NOT NULL,
    Sobrenome_Funcionario VARCHAR(20) NOT NULL
);

CREATE TABLE Produto_Funcionario(
	Funcionario_idFuncinario INT,
    Produto_idProduto INT,
    PRIMARY KEY(Funcionario_idFuncinario, Produto_idProduto),
    CONSTRAINT FK_Funcionario_ProdutoFuncionario FOREIGN KEY(Funcionario_idFuncinario) REFERENCES Funcionario(idFuncionario),
    CONSTRAINT FK_Produto_ProdutoFuncionario FOREIGN KEY(Produto_idProduto) REFERENCES Produto(idProduto)    
);

CREATE TABLE Logistica(
	idLogistica INT AUTO_INCREMENT PRIMARY KEY,
	Data_Envio DATE,
    Data_Entrega DATE,
    Codigo_Rastreio  INT,
    Status_Envio ENUM('Em separacao', 'Enviado', 'Em rota', 'Entregue')
);

CREATE TABLE Estoque_Logistica(
	Logistica_idLogistica INT NOT NULL,
    Estoque_idEstoque INT NOT NULL,
    PRIMARY KEY(Logistica_idLogistica, Estoque_idEstoque),
    CONSTRAINT FK_Logistica_EstoqueLogistica FOREIGN KEY(Logistica_idLogistica) REFERENCES Logistica(idLogistica),
    CONSTRAINT FK_Estoque_EstoqueLogistica FOREIGN KEY(Estoque_idEstoque) REFERENCES Estoque(idEstoque)
);
CREATE TABLE Estoque_Fornecedor(
	Estoque_idEstoque INT,
    Fornecedor_idFornecedor INT,
    PRIMARY KEY(Estoque_idEstoque, Fornecedor_idFornecedor),
    CONSTRAINT FK_Estoque_EstoqueFornecedor FOREIGN KEY(Estoque_idEstoque) REFERENCES Estoque(idEstoque),
    CONSTRAINT FK_Fornecedor_EstoqueFornecedor FOREIGN KEY(Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor)
);

-- PARA CONFIRMAR VOU RECUPERAR AS TABELAS RECEM CRIADAS
SHOW TABLES;
-- BUSCANDO AS CONSTRAINTS 

SHOW DATABASES;
USE information_schema;
SHOW TABLES;

SELECT *
FROM REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'ecommerce_DIO';

-- REVISANDO AS AULAS E NOTEI QUE NAO INSERIR TODAS A RESTRICOES NECESSARIAS

ALTER TABLE Pedido
DROP FOREIGN KEY FK_idPagamento_idCliente;

ALTER TABLE Pedido
	ADD CONSTRAINT FK_idPagamento_idCliente
	FOREIGN KEY(idPagamento, Cliente_idCliente)
    REFERENCES Pagamento(idPagamento, Cliente_idCliente)
	ON UPDATE CASCADE;
--
ALTER TABLE Pedido_Produto
DROP FOREIGN KEY FK_Pedido_PedidoProduto;

ALTER TABLE Pedido_Produto
ADD CONSTRAINT FK_Pedido_PedidoProduto FOREIGN KEY(Pedido_idPedido) REFERENCES Pedido(idPedido)
ON UPDATE CASCADE;
--
ALTER TABLE Pedido_Produto
DROP FOREIGN KEY FK_Produto_PedidoProduto;

ALTER TABLE Pedido_Produto
ADD CONSTRAINT FK_Produto_PedidoProduto FOREIGN KEY(Produto_idProduto) REFERENCES Produto(idProduto)
ON UPDATE CASCADE;
--
ALTER TABLE Produto_Fornecedor
DROP FOREIGN KEY FK_Produto_ProdutoFornecedor;

ALTER TABLE Produto_Fornecedor
ADD CONSTRAINT FK_Produto_ProdutoFornecedor FOREIGN KEY(Produto_idProduto) REFERENCES Produto(idProduto)
ON UPDATE CASCADE;
--
ALTER TABLE Produto_Fornecedor
DROP FOREIGN KEY Fornecedor_ProdutoFornecedor;

ALTER TABLE Produto_Fornecedor
ADD CONSTRAINT Fornecedor_ProdutoFornecedor FOREIGN KEY(Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor)
ON UPDATE CASCADE;
--
ALTER TABLE Estoque_Logisticar
DROP FOREIGN KEY FK_Logistica_EstoqueLogistica;

ALTER TABLE Estoque_Logistica
ADD CONSTRAINT FK_Logistica_EstoqueLogistica FOREIGN KEY(Logistica_idLogistica) REFERENCES Logistica(idLogistica)
ON UPDATE CASCADE;
--
ALTER TABLE Estoque_Logisticar
DROP FOREIGN KEY FK_Estoque_EstoqueLogistica;

ALTER TABLE Estoque_Logistica
ADD CONSTRAINT FK_Estoque_EstoqueLogistica FOREIGN KEY(Estoque_idEstoque) REFERENCES Estoque(idEstoque)
ON UPDATE CASCADE;
--

ALTER TABLE Estoque_Fornecedor
DROP FOREIGN KEY FK_Estoque_EstoqueFornecedor;

ALTER TABLE Estoque_Fornecedor
ADD CONSTRAINT FK_Estoque_EstoqueFornecedor FOREIGN KEY(Estoque_idEstoque) REFERENCES Estoque(idEstoque)
ON UPDATE CASCADE;
--

ALTER TABLE Estoque_Fornecedor
DROP FOREIGN KEY FK_Fornecedor_EstoqueFornecedor;

ALTER TABLE Estoque_Fornecedor
ADD CONSTRAINT FK_Fornecedor_EstoqueFornecedor FOREIGN KEY(Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor)
ON UPDATE CASCADE;