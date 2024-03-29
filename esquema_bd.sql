CREATE TABLE PESSOAS(
ID INTEGER NOT NULL,
CLIENTE INTEGER,
FORNECEDOR INTEGER,
NOME VARCHAR(255) NOT NULL,
APELIDO_NOME_FANTASIA VARCHAR(255),
TIPO_PESSOA CHAR(1) NOT NULL,
CPF_CNPJ VARCHAR(20),
RG VARCHAR(20),
IE VARCHAR(20),
CIDADE VARCHAR(180),
UF CHAR(2),
BAIRRO VARCHAR(100),
LOGRADOURO VARCHAR(200),
NUMERO VARCHAR(5),
COMPLEMENTO VARCHAR(100)
);
COMMIT;

ALTER TABLE PESSOAS ADD CONSTRAINT PK_IDPESSOA PRIMARY KEY(ID);
COMMIT;

CREATE GENERATOR GEN_PESSOAS_ID;

SET TERM !! ;
CREATE TRIGGER PESSOAS_BI FOR PESSOAS
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE tmp DECIMAL(18,0);
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_PESSOAS_ID, 1);
  ELSE
  BEGIN
    tmp = GEN_ID(GEN_PESSOAS_ID, 0);
    if (tmp < new.ID) then
      tmp = GEN_ID(GEN_PESSOAS_ID, new.ID-tmp);
  END
END!!
SET TERM ; !!
COMMIT;

CREATE TABLE TELEFONES(
ID INTEGER NOT NULL,
ID_PESSOA INTEGER,
AREA CHAR(2),
NUMERO VARCHAR(14),
APARELHO VARCHAR(20),
DESCRICAO VARCHAR(120)
);
COMMIT;

ALTER TABLE TELEFONES ADD CONSTRAINT PK_IDTELEFONE PRIMARY KEY(ID);
ALTER TABLE TELEFONES ADD CONSTRAINT FK_PESSOA_TEL FOREIGN KEY(ID_PESSOA) REFERENCES PESSOAS(ID) ON UPDATE NO ACTION ON DELETE CASCADE;
COMMIT;

CREATE GENERATOR GEN_TELEFONES_ID;

SET TERM !! ;
CREATE TRIGGER TELEFONES_BI FOR TELEFONES
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE tmp DECIMAL(18,0);
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_TELEFONES_ID, 1);
  ELSE
  BEGIN
    tmp = GEN_ID(GEN_TELEFONES_ID, 0);
    if (tmp < new.ID) then
      tmp = GEN_ID(GEN_TELEFONES_ID, new.ID-tmp);
  END
END!!
SET TERM ; !!
COMMIT;

CREATE TABLE PRODUTOS(
ID INTEGER NOT NULL,
NOME VARCHAR(180) NOT NULL,
PRECO_VENDA_NORMAL NUMERIC(11,2),
PRECO_ULTIMA_COMPRA NUMERIC(11,2) DEFAULT 0,
PRECO_VENDA_PROMOCAO NUMERIC(11,2),
ESTOQUE INTEGER DEFAULT 0
);
COMMIT;

ALTER TABLE PRODUTOS ADD CONSTRAINT PK_IDPRODUTOS PRIMARY KEY(ID);
COMMIT;

CREATE GENERATOR GEN_PRODUTOS_ID;

SET TERM !! ;
CREATE TRIGGER PRODUTOS_BI FOR PRODUTOS
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE tmp DECIMAL(18,0);
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_PRODUTOS_ID, 1);
  ELSE
  BEGIN
    tmp = GEN_ID(GEN_PRODUTOS_ID, 0);
    if (tmp < new.ID) then
      tmp = GEN_ID(GEN_PRODUTOS_ID, new.ID-tmp);
  END
END!!
SET TERM ; !!
COMMIT;

CREATE TABLE PEDIDOS(
ID INTEGER NOT NULL,
ID_PESSOA INTEGER NOT NULL,
TIPO CHAR(1) NOT NULL,
EMISSAO DATE DEFAULT CURRENT_DATE NOT NULL,
PROCESSADO CHAR(1) NOT NULL,
OBSERVACAO VARCHAR(1000),
CPF_CNPJ VARCHAR(20),
VALOR_TOTAL NUMERIC(11,2) NOT NULL,
DATA_PROCES DATE,
DATA_ESTORNO DATE
);
COMMIT;

ALTER TABLE PEDIDOS ADD CONSTRAINT PK_IDPEDIDO PRIMARY KEY(ID);
ALTER TABLE PEDIDOS ADD CONSTRAINT FK_PEDIDO_PESSOA FOREIGN KEY(ID_PESSOA) REFERENCES PESSOAS(ID) ON UPDATE NO ACTION ON DELETE NO ACTION;
COMMIT;

CREATE GENERATOR GEN_PEDIDOS_ID;

SET TERM !! ;
CREATE TRIGGER PEDIDOS_BI FOR PEDIDOS
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE tmp DECIMAL(18,0);
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_PEDIDOS_ID, 1);
  ELSE
  BEGIN
    tmp = GEN_ID(GEN_PEDIDOS_ID, 0);
    if (tmp < new.ID) then
      tmp = GEN_ID(GEN_PEDIDOS_ID, new.ID-tmp);
  END
END!!
SET TERM ; !!
COMMIT;

CREATE TABLE PEDIDO_ITENS(
ID INTEGER NOT NULL,
ID_PEDIDO INTEGER NOT NULL,
ID_PRODUTO INTEGER NOT NULL,
QUANTIDADE DECIMAL(9,2)
);
COMMIT;

ALTER TABLE PEDIDO_ITENS ADD CONSTRAINT PK_PEDIDO_ITEM PRIMARY KEY(ID);
ALTER TABLE PEDIDO_ITENS ADD CONSTRAINT FK_ITEM_PEDIDO FOREIGN KEY(ID_PEDIDO) REFERENCES PEDIDOS(ID) ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE PEDIDO_ITENS ADD CONSTRAINT FK_ITEM_PED_PRODUTO FOREIGN KEY(ID_PRODUTO) REFERENCES PRODUTOS(ID) ON UPDATE NO ACTION ON DELETE NO ACTION;
COMMIT;

CREATE GENERATOR GEN_PEDIDO_ITENS_ID;

SET TERM !! ;
CREATE TRIGGER PEDIDO_ITENS_BI FOR PEDIDO_ITENS
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE tmp DECIMAL(18,0);
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_PEDIDO_ITENS_ID, 1);
  ELSE
  BEGIN
    tmp = GEN_ID(GEN_PEDIDO_ITENS_ID, 0);
    if (tmp < new.ID) then
      tmp = GEN_ID(GEN_PEDIDO_ITENS_ID, new.ID-tmp);
  END
END!!
SET TERM ; !!
COMMIT;

CREATE TABLE CONFIGURACAO(
ID INTEGER NOT NULL,
ESTOQUE_NEGATIVO CHAR(1) NOT NULL,
PEDIDO_SEM_CPF_CNPJ CHAR(1) NOT NULL,
CADASTRO_SEM_CPF_CNPJ CHAR(1) NOT NULL,
COMPUTADOR VARCHAR(6) NOT NULL,
NOME VARCHAR(120) NOT NULL,
CAMINHO_BD VARCHAR(255) NOT NULL,
DESCRICAO_BD VARCHAR(120)
);
COMMIT;

ALTER TABLE CONFIGURACAO ADD CONSTRAINT PK_IDCONFIG PRIMARY KEY(ID);
COMMIT;

CREATE GENERATOR GEN_CONFIGURACAO_ID;

SET TERM !! ;
CREATE TRIGGER CONFIGURACAO_BI FOR CONFIGURACAO
ACTIVE BEFORE INSERT POSITION 0
AS
DECLARE VARIABLE tmp DECIMAL(18,0);
BEGIN
  IF (NEW.ID IS NULL) THEN
    NEW.ID = GEN_ID(GEN_CONFIGURACAO_ID, 1);
  ELSE
  BEGIN
    tmp = GEN_ID(GEN_CONFIGURACAO_ID, 0);
    if (tmp < new.ID) then
      tmp = GEN_ID(GEN_CONFIGURACAO_ID, new.ID-tmp);
  END
END!!
SET TERM ; !!
COMMIT;
