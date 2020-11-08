-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2020-11-08 18:58:36.642

-- tables
-- Table: Equipe
CREATE TABLE Equipe
(
    idEquipe serial NOT NULL,
    brasao varchar NOT NULL,
    Liga_nome varchar(90) NOT NULL,
    CONSTRAINT Equipe_pk PRIMARY KEY (idEquipe)
);

-- Table: Estatisticas
CREATE TABLE Estatisticas
(
    id serial NOT NULL,
    Partida_idPartida int NOT NULL,
    Equipe1_idEquipe int NOT NULL,
    Equipe2_idEquipe int NOT NULL,
    CONSTRAINT Estatisticas_pk PRIMARY KEY (id)
);

-- Table: Habilidade
CREATE TABLE Habilidade
(
    id serial NOT NULL,
    descricao varchar(90) NOT NULL,
    Jogador_Cpf char(11) NOT NULL,
    CONSTRAINT Habilidade_pk PRIMARY KEY (id)
);

-- Table: InfoJogadorPartida
CREATE TABLE InfoJogadorPartida
(
    idInfo serial NOT NULL,
    Estatisticas_id int NOT NULL,
    Jogador_cpf char(11) NOT NULL,
    PosicaoJogador varchar(90) NOT NULL,
    PontuacaoJogador int NOT NULL,
    CONSTRAINT InfoJogadorPartida_pk PRIMARY KEY (idInfo)
);

-- Table: Jogador
CREATE TABLE Jogador
(
    cpf char(11) NOT NULL,
    Equipe_idEquipe int NOT NULL,
    nome varchar(90) NOT NULL,
    CONSTRAINT Jogador_pk PRIMARY KEY (cpf)
);

-- Table: Liga
CREATE TABLE Liga
(
    nome varchar(90) NOT NULL,
    periodo interval NOT NULL,
    CONSTRAINT Liga_pk PRIMARY KEY (nome)
);

-- Table: Partida
CREATE TABLE Partida
(
    idPartida serial NOT NULL,
    Liga_nome varchar(90) NOT NULL,
    CONSTRAINT Partida_pk PRIMARY KEY (idPartida)
);

-- foreign keys
-- Reference: Equipe_Liga (table: Equipe)
ALTER TABLE Equipe ADD CONSTRAINT Equipe_Liga
    FOREIGN KEY (Liga_nome)
    REFERENCES Liga (nome)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Estatisticas_Equipe (table: Estatisticas)
ALTER TABLE Estatisticas ADD CONSTRAINT Estatisticas_Equipe
    FOREIGN KEY (Equipe2_idEquipe)
    REFERENCES Equipe (idEquipe)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Estatisticas_Equipe1 (table: Estatisticas)
ALTER TABLE Estatisticas ADD CONSTRAINT Estatisticas_Equipe1
    FOREIGN KEY (Equipe1_idEquipe)
    REFERENCES Equipe (idEquipe)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Estatisticas_Partida (table: Estatisticas)
ALTER TABLE Estatisticas ADD CONSTRAINT Estatisticas_Partida
    FOREIGN KEY (Partida_idPartida)
    REFERENCES Partida (idPartida)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Habilidade_Jogador (table: Habilidade)
ALTER TABLE Habilidade ADD CONSTRAINT Habilidade_Jogador
    FOREIGN KEY (Jogador_Cpf)
    REFERENCES Jogador (cpf)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: InfoJogadorPartida_Estatisticas (table: InfoJogadorPartida)
ALTER TABLE InfoJogadorPartida ADD CONSTRAINT InfoJogadorPartida_Estatisticas
    FOREIGN KEY (Estatisticas_id)
    REFERENCES Estatisticas (id)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: InfoJogadorPartida_Jogador (table: InfoJogadorPartida)
ALTER TABLE InfoJogadorPartida ADD CONSTRAINT InfoJogadorPartida_Jogador
    FOREIGN KEY (Jogador_cpf)
    REFERENCES Jogador (cpf)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Jogador_Equipe (table: Jogador)
ALTER TABLE Jogador ADD CONSTRAINT Jogador_Equipe
    FOREIGN KEY (Equipe_idEquipe)
    REFERENCES Equipe (idEquipe)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Partida_Liga (table: Partida)
ALTER TABLE Partida ADD CONSTRAINT Partida_Liga
    FOREIGN KEY (Liga_nome)
    REFERENCES Liga (nome)
NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.



-- Comandos de inserção 

-- Criação da Liga
INSERT INTO Liga
VALUES
    ('Nordestina', '21 days');


-- Criação de duas equipes
INSERT INTO Equipe
VALUES
    (1, 'Cachorrão', 'Nordestina');

INSERT INTO Equipe
VALUES
    (2, 'Andorinha', 'Nordestina');


-- Criação de dois jogadores pra cada equipe
INSERT INTO Jogador
VALUES
    ('00011122233', 1, 'Juninho');
INSERT INTO Jogador
VALUES
    ('12345678912', 1, 'Pedrão');

INSERT INTO Jogador
VALUES
    ('31243245354', 2, 'Claudete');
INSERT INTO Jogador
VALUES
    ('42348732492', 2, 'Joana');


-- Adição de habilidades para cada jogador
INSERT INTO Habilidade
VALUES
    (0, 'Dar cambalhota sem os braços', '00011122233');

INSERT INTO Habilidade
VALUES
    (1, 'Dar mortal de costas', '12345678912');

INSERT INTO Habilidade
VALUES
    (2, 'Dar peixinho na grama', '31243245354');

INSERT INTO Habilidade
VALUES
    (3, 'Planta bananeira invertida', '42348732492');


-- Criação de uma partida
INSERT INTO Partida
VALUES
    (0, 'Nordestina');


-- Criação de uma Estatistica de partida
INSERT INTO Estatisticas
VALUES
    (0, 0, 1, 2);

-- Adição das informações de cada jogador nas estatísticas
INSERT INTO InfoJogadorPartida
VALUES
    (0, 0, '00011122233', 'Central', 5);

INSERT INTO InfoJogadorPartida
VALUES
    (1, 0, '12345678912', 'Ataque', 15);

INSERT INTO InfoJogadorPartida
VALUES
    (2, 0, '31243245354', 'Defesa', 3);

INSERT INTO InfoJogadorPartida
VALUES
    (3, 0, '42348732492', 'Pivô', 54);