CREATE TYPE tipo_funcionario AS ENUM ('FARMACEUTICO', 'VENDEDOR', 'ENTREGADOR', 'CAIXA', 'ADMINISTRADOR');

CREATE TYPE tipo_endereco_cliente AS ENUM ('RESIDENCIA', 'TRABALHO', 'OUTRO');

CREATE TYPE estado AS ENUM ('AL', 'BA', 'CE', 'MA', 'PB', 'PE', 'PI', 'RN', 'SE');



CREATE TABLE farmacia (
  id INTEGER PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  bairro VARCHAR(30) NOT NULL, 
  cidade VARCHAR(30) NOT NULL,
  estado estado NOT NULL,
  tipo VARCHAR(6) NOT NULL, 
  cpf_gerente CHAR(11) NOT NULL,
  tipo_gerente tipo_funcionario NOT NULL
);

ALTER TABLE farmacia ADD CONSTRAINT farmacia_chk_tipo CHECK(tipo='SEDE' OR tipo='FILIAL');

ALTER TABLE farmacia ADD CONSTRAINT sede_unica EXCLUDE USING gist (tipo WITH =,
nome WITH =) WHERE (tipo = 'SEDE');

ALTER TABLE farmacia ADD CONSTRAINT farmacia_chk_gerente CHECK (tipo_gerente='FARMACEUTICO' OR tipo_gerente='ADMINISTRADOR');

ALTER TABLE farmacia ADD CONSTRAINT unica_no_bairro EXCLUDE USING gist (bairro WITH =, cidade WITH =);



CREATE TABLE funcionario (
  cpf CHAR(11) PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  tipo tipo_funcionario NOT NULL,
  id_farm INTEGER REFERENCES farmacia (id)
);


ALTER TABLE farmacia ADD FOREIGN KEY (cpf_gerente) REFERENCES funcionario (cpf);



CREATE TABLE medicamento (
 id INTEGER PRIMARY KEY,
 nome VARCHAR(30) NOT NULL,
 preco NUMERIC NOT NULL,
 receita BOOLEAN NOT NULL
);



CREATE TABLE cliente (
 cpf CHAR(11) PRIMARY KEY,
 nome VARCHAR(30) NOT NULL,
 data_nascimento DATE NOT NULL
);

ALTER TABLE cliente ADD CONSTRAINT cliente_chk_idade CHECK(date_part('year', age(data_nascimento)) >= 18);



CREATE TABLE venda (
  id INTEGER PRIMARY KEY,
  data DATE, 
  id_medicamento INTEGER REFERENCES medicamento (id) ON DELETE RESTRICT NOT NULL,
  receita BOOLEAN NOT NULL,
  cpf_cliente CHAR(11) REFERENCES cliente (cpf),
  cpf_vendedor CHAR(11) REFERENCES funcionario (cpf) ON DELETE RESTRICT NOT NULL,
  tipo_vendedor tipo_funcionario NOT NULL 
);

ALTER TABLE venda ADD CONSTRAINT venda_chk_vendedor CHECK (tipo_vendedor = 'VENDEDOR');

ALTER TABLE venda ADD CONSTRAINT venda_chk_receita CHECK(receita = false OR (receita = TRUE AND cpf_cliente IS NOT NULL));



CREATE TABLE endereco_cliente (
  id INTEGER PRIMARY KEY,
  cpf_cliente CHAR(11) REFERENCES cliente (cpf) NOT NULL,
  rua VARCHAR(30) NOT NULL, 
  numero INTEGER NOT NULL,
  bairro VARCHAR(30) NOT NULL, 
  cidade VARCHAR(30) NOT NULL,
  estado estado NOT NULL,
  tipo tipo_endereco_cliente NOT NULL
);



CREATE TABLE entrega (
  id INTEGER PRIMARY KEY,
  id_venda INTEGER REFERENCES venda (id) NOT NULL,
  data DATE,
  id_endereco INTEGER REFERENCES endereco_cliente (id) NOT NULL
);



-- Testes de implementação  


-- Inserção dos funcionários

INSERT INTO funcionario VALUES ('12345678910', 'Claudia', 'FARMACEUTICO', null);

INSERT INTO funcionario VALUES ('12345678911', 'Jarbas', 'VENDEDOR', null);

INSERT INTO funcionario VALUES ('12345678912', 'Vania', 'ENTREGADOR', null);

INSERT INTO funcionario VALUES ('12345678913', 'Alberto', 'CAIXA', null);

INSERT INTO funcionario VALUES ('12345678914', 'Jaldete', 'ADMINISTRADOR', null);



-- Inserção das farmácias

-- Inserção da farmácia como sede

INSERT INTO farmacia VALUES (0, 'Drogasil', 'Bela Vista', 'Campina Grande', 'PB', 'SEDE', '12345678914', 'ADMINISTRADOR');

-- Atualização do gerente da farmácia 

UPDATE funcionario SET id_farm = 0 WHERE cpf = '12345678914';

-- Inserção da farmácia como sede

INSERT INTO farmacia VALUES (1, 'RedePharma', 'Alto Branco', 'Campina Grande', 'PB', 'SEDE', '12345678910', 'FARMACEUTICO');

-- Atualização do gerente da farmácia 

UPDATE funcionario SET id_farm = 0 WHERE cpf = '12345678910';


-- Tentativa de adicionar outra farmácia de mesmo nome como sede
-- Erro: Tenta violar a constraint de sede única

INSERT INTO farmacia VALUES (2, 'RedePharma', 'Catolé', 'Campina Grande', 'PB', 'SEDE', '12345678910', 'FARMACEUTICO');


-- Inserção de farmácia como filial

INSERT INTO farmacia VALUES (2, 'RedePharma', 'Catolé', 'Campina Grande', 'PB', 'FILIAL', '12345678910', 'FARMACEUTICO');

-- Tentativa de adicionar outra farmácia no mesmo bairro com mesmo nome
-- Erro: Tenta violar a constraint de única no bairro

INSERT INTO farmacia VALUES (3, 'RedePharma', 'Catolé', 'Campina Grande', 'PB', 'FILIAL', '12345678910', 'FARMACEUTICO');

-- Tentativa de adicionar uma farmácia com gerente não farmacêutico ou administrador
-- Erro: Tenta violar a constraint de tipo de gerente

INSERT INTO farmacia VALUES (3, 'Dias', 'Catolé', 'Campina Grande', 'PB', 'FILIAL', '12345678913', 'CAIXA');

-- Tentativa de adiocionar uma farmácia em um estado não cadastrado
-- Erro: Entrada inválida para o enum

INSERT INTO farmacia VALUES (3, 'Dias', 'Catolé', 'Campina Grande', 'SP', 'FILIAL', '12345678910', 'FARMACEUTICO');




-- Inserção dos clientes

INSERT INTO cliente VALUES ('12345678920', 'Ana', '2000-05-05');

INSERT INTO cliente VALUES ('12345678921', 'Thiago', '1990-05-05');

-- Tentativa de inserir cliente menor de idade
-- Erro: Tenta violar a constraint de idade

INSERT INTO cliente VALUES ('12345678922', 'Pedrinho', '2010-05-05');



-- Inserção dos endereços

INSERT INTO endereco_cliente VALUES (0, '12345678920', 'Rua Rodrigues Alves', 1800, 'Bela Vista', 'Campina Grande', 'PB', 'RESIDENCIA');

INSERT INTO endereco_cliente VALUES (1, '12345678920', 'Rua Alves', 105, 'Catolé', 'Campina Grande', 'PB', 'TRABALHO');

INSERT INTO endereco_cliente VALUES (2, '12345678921', 'Av. Dom Pedro II', 500, 'Universitário', 'Campina Grande', 'PB', 'OUTRO');

-- Tentativa de inserir um endereço de tipo não especificado
-- Erro: Entrada inválida para o enum
 
INSERT INTO endereco_cliente VALUES (3, '12345678920', 'Rua Rodrigues Alves', 1800, 'Bela Vista', 'Campina Grande', 'PB', 'Temporário');

-- Inserção dos medicamentos

INSERT INTO medicamento VALUES (0, 'Dorflex', 5.00, false);

INSERT INTO medicamento VALUES (1, 'Vitamina C', 10.00, false);

INSERT INTO medicamento VALUES (2, 'Rivotril', 50.00, true);

-- Inserção das vendas

INSERT INTO venda VALUES (0, null, 0, false, '12345678920', '12345678911', 'VENDEDOR');

INSERT INTO venda VALUES (1, null, 0, false, null, '12345678911', 'VENDEDOR');

-- Venda de um remédio com receita para um cliente cadastrado

INSERT INTO venda VALUES (2, null, 2, true, '12345678920', '12345678911', 'VENDEDOR');


-- Tentativa de vender um remédio com receita para um cliente não cadastrado
-- Erro: Tenta violar a constraint de receita

INSERT INTO venda VALUES (3, null, 2, true, null, '12345678911', 'VENDEDOR');

-- Tentativa de vender um remédio com um funcionário não vendedor
-- Erro: Tenta violar a constraint de receita

INSERT INTO venda VALUES (3, null, 2, true, '12345678910', '12345678911', 'FARMACEUTICO');



-- Inserção das entregas

INSERT INTO entrega VALUES (0, 2, null, 2);

-- Tentativa de entregar em um endereço não cadastrado
-- Erro: Tentar violar a constraint de foreign key 

INSERT INTO entrega VALUES (1, 1, null, 50);



-- Tentativas de exclusão

-- Tentativa de excluir um funcionário vinculado a uma venda
-- Erro: Tenta violar a constraint de foreign key

DELETE FROM funcionario WHERE cpf = '12345678911';


-- Tentativa de excluir um medicamento vinculado a uma venda
-- Erro: Tenta violar a constraint de foreign key