-- 2. Criação das tabelas com os atributos

CREATE TABLE automovel
(
    placa char(7),
    marca varchar(20),
    modelo varchar(40),
    ano INTEGER
);

CREATE TABLE segurado
(
    nome varchar(40),
    cpf char(11),
    placa_carro char(7),
    cnpj_seguro char(14)
);

CREATE TABLE perito
(
    nome varchar(40),
    cpf char(11),
    cnpj_seguro char(14),
    id_pericia INTEGER
);

CREATE TABLE oficina
(
    cnpj char(14),
    endereco varchar(100),
    nome_fantasia varchar(20),
    id_reparo INTEGER
);

CREATE TABLE seguro
(
    cnpj char(14),
    nome_fantasia varchar(20),
    cpf_segurado char(11),
    cpf_perito char(11),
    cnpj_oficina char(14),
    id_sinistro INTEGER
);

CREATE TABLE sinistro
(
    id INTEGER,
    relato TEXT
);

CREATE TABLE pericia
(
    id INTEGER,
    laudo TEXT
);

CREATE TABLE reparo
(
    id INTEGER,
    valor NUMERIC
);


-- 3. Adição das chaves primárias por meio do ALTER TABLE

ALTER TABLE automovel ADD PRIMARY KEY (placa);

ALTER TABLE segurado ADD PRIMARY KEY (cpf);

ALTER TABLE perito ADD PRIMARY KEY (cpf);

ALTER TABLE oficina ADD PRIMARY KEY (cnpj);

ALTER TABLE seguro ADD PRIMARY KEY (cnpj);

ALTER TABLE sinistro ADD PRIMARY KEY (id);

ALTER TABLE pericia ADD PRIMARY KEY (id);

ALTER TABLE reparo ADD PRIMARY KEY (id);


-- 4. Adição das chaves estrangeiras

ALTER TABLE segurado ADD CONSTRAINT FK_Placa FOREIGN KEY (placa_carro) REFERENCES automovel(placa);

ALTER TABLE segurado ADD CONSTRAINT FK_Seguro FOREIGN KEY (cnpj_seguro) REFERENCES seguro(cnpj);

ALTER TABLE perito ADD CONSTRAINT Fk_Seguro FOREIGN KEY (cnpj_seguro) REFERENCES seguro(cnpj);

ALTER TABLE perito ADD CONSTRAINT FK_Pericia FOREIGN KEY (id_pericia) REFERENCES pericia(id);

ALTER TABLE oficina ADD CONSTRAINT FK_Reparo FOREIGN KEY (id_reparo) REFERENCES reparo(id);

ALTER TABLE seguro ADD CONSTRAINT FK_Segurado FOREIGN KEY (cpf_segurado) REFERENCES segurado(cpf);

ALTER TABLE seguro ADD CONSTRAINT FK_Perito FOREIGN KEY (cpf_perito) REFERENCES perito(cpf);

ALTER TABLE seguro ADD CONSTRAINT FK_Oficina FOREIGN KEY (cnpj_oficina) REFERENCES oficina(cnpj);

ALTER TABLE seguro ADD CONSTRAINT FK_Sinistro FOREIGN KEY (id_sinistro) REFERENCES sinistro(id);


-- 6. Remoção das tabelas criadas

DROP TABLE automovel;

DROP TABLE segurado;

DROP TABLE perito;

DROP TABLE oficina;

DROP TABLE seguro;

DROP TABLE sinistro;

DROP TABLE pericia;

DROP TABLE reparo;


-- 8. Criação das tabelas com as Constraints

CREATE TABLE automovel
(
    placa char(7) PRIMARY KEY NOT NULL,
    marca varchar(20),
    modelo varchar(40),
    ano INTEGER
);

CREATE TABLE segurado
(
    nome varchar(40),
    cpf char(11) PRIMARY KEY NOT NULL,
    placa_carro char(7) REFERENCES automovel(placa)
);

CREATE TABLE reparo
(
    id INTEGER PRIMARY KEY NOT NULL,
    valor NUMERIC
);

CREATE TABLE oficina
(
    cnpj char(14) PRIMARY KEY NOT NULL,
    endereco varchar(100),
    nome_fantasia varchar(20),
    id_reparo INTEGER REFERENCES reparo(id)
);

CREATE TABLE sinistro
(
    id INTEGER PRIMARY KEY NOT NULL,
    relato TEXT
);

CREATE TABLE seguro
(
    cnpj char(14) PRIMARY KEY NOT NULL,
    nome_fantasia varchar(20),
    cpf_segurado char(11) REFERENCES segurado(cpf),
    cnpj_oficina char(14) REFERENCES oficina(cnpj),
    id_sinistro INTEGER REFERENCES sinistro(id)
);

CREATE TABLE perito
(
    nome varchar(40),
    cpf char(11) PRIMARY KEY NOT NULL,
    cnpj_seguro char(14) REFERENCES seguro(cnpj),
    id_pericia INTEGER
);

CREATE TABLE pericia
(
    id INTEGER PRIMARY KEY NOT NULL,
    laudo TEXT
);

-- 9. Remoção das tabelas

DROP TABLE perito;

DROP TABLE seguro;

DROP TABLE segurado;

DROP TABLE oficina;

DROP TABLE sinistro;

DROP TABLE pericia;

DROP TABLE reparo;

DROP TABLE automovel;