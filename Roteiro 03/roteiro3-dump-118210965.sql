--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.23
-- Dumped by pg_dump version 9.5.23

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_id_medicamento_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_cpf_vendedor_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_cpf_cliente_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_id_farm_fkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_cpf_gerente_fkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_id_venda_fkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_id_endereco_fkey;
ALTER TABLE ONLY public.endereco_cliente DROP CONSTRAINT endereco_cliente_cpf_cliente_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT unica_no_bairro;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT sede_unica;
ALTER TABLE ONLY public.medicamento DROP CONSTRAINT medicamento_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
ALTER TABLE ONLY public.farmacia DROP CONSTRAINT farmacia_pkey;
ALTER TABLE ONLY public.entrega DROP CONSTRAINT entrega_pkey;
ALTER TABLE ONLY public.endereco_cliente DROP CONSTRAINT endereco_cliente_pkey;
ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
DROP TABLE public.venda;
DROP TABLE public.medicamento;
DROP TABLE public.funcionario;
DROP TABLE public.farmacia;
DROP TABLE public.entrega;
DROP TABLE public.endereco_cliente;
DROP TABLE public.cliente;
DROP TYPE public.tipo_funcionario;
DROP TYPE public.tipo_endereco_cliente;
DROP TYPE public.estado;
DROP EXTENSION btree_gist;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: estado; Type: TYPE; Schema: public; Owner: tulioac
--

CREATE TYPE public.estado AS ENUM (
    'AL',
    'BA',
    'CE',
    'MA',
    'PB',
    'PE',
    'PI',
    'RN',
    'SE'
);


ALTER TYPE public.estado OWNER TO tulioac;

--
-- Name: tipo_endereco_cliente; Type: TYPE; Schema: public; Owner: tulioac
--

CREATE TYPE public.tipo_endereco_cliente AS ENUM (
    'RESIDENCIA',
    'TRABALHO',
    'OUTRO'
);


ALTER TYPE public.tipo_endereco_cliente OWNER TO tulioac;

--
-- Name: tipo_funcionario; Type: TYPE; Schema: public; Owner: tulioac
--

CREATE TYPE public.tipo_funcionario AS ENUM (
    'FARMACEUTICO',
    'VENDEDOR',
    'ENTREGADOR',
    'CAIXA',
    'ADMINISTRADOR'
);


ALTER TYPE public.tipo_funcionario OWNER TO tulioac;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.cliente (
    cpf character(11) NOT NULL,
    nome character varying(30) NOT NULL,
    data_nascimento date NOT NULL,
    CONSTRAINT cliente_chk_idade CHECK ((date_part('year'::text, age((data_nascimento)::timestamp with time zone)) >= (18)::double precision))
);


ALTER TABLE public.cliente OWNER TO tulioac;

--
-- Name: endereco_cliente; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.endereco_cliente (
    id integer NOT NULL,
    cpf_cliente character(11) NOT NULL,
    rua character varying(30) NOT NULL,
    numero integer NOT NULL,
    bairro character varying(30) NOT NULL,
    cidade character varying(30) NOT NULL,
    estado public.estado NOT NULL,
    tipo public.tipo_endereco_cliente NOT NULL
);


ALTER TABLE public.endereco_cliente OWNER TO tulioac;

--
-- Name: entrega; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.entrega (
    id integer NOT NULL,
    id_venda integer NOT NULL,
    data date,
    id_endereco integer NOT NULL
);


ALTER TABLE public.entrega OWNER TO tulioac;

--
-- Name: farmacia; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.farmacia (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    bairro character varying(30) NOT NULL,
    cidade character varying(30) NOT NULL,
    estado public.estado NOT NULL,
    tipo character varying(6) NOT NULL,
    cpf_gerente character(11) NOT NULL,
    tipo_gerente public.tipo_funcionario NOT NULL,
    CONSTRAINT farmacia_chk_gerente CHECK (((tipo_gerente = 'FARMACEUTICO'::public.tipo_funcionario) OR (tipo_gerente = 'ADMINISTRADOR'::public.tipo_funcionario))),
    CONSTRAINT farmacia_chk_tipo CHECK ((((tipo)::text = 'SEDE'::text) OR ((tipo)::text = 'FILIAL'::text)))
);


ALTER TABLE public.farmacia OWNER TO tulioac;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    nome character varying(30) NOT NULL,
    tipo public.tipo_funcionario NOT NULL,
    id_farm integer
);


ALTER TABLE public.funcionario OWNER TO tulioac;

--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.medicamento (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    preco numeric NOT NULL,
    receita boolean NOT NULL
);


ALTER TABLE public.medicamento OWNER TO tulioac;

--
-- Name: venda; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.venda (
    id integer NOT NULL,
    data date,
    id_medicamento integer NOT NULL,
    receita boolean NOT NULL,
    cpf_cliente character(11),
    cpf_vendedor character(11) NOT NULL,
    tipo_vendedor public.tipo_funcionario NOT NULL,
    CONSTRAINT venda_chk_receita CHECK (((receita = false) OR ((receita = true) AND (cpf_cliente IS NOT NULL)))),
    CONSTRAINT venda_chk_vendedor CHECK ((tipo_vendedor = 'VENDEDOR'::public.tipo_funcionario))
);


ALTER TABLE public.venda OWNER TO tulioac;

--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.cliente (cpf, nome, data_nascimento) VALUES ('12345678920', 'Ana', '2000-05-05');
INSERT INTO public.cliente (cpf, nome, data_nascimento) VALUES ('12345678921', 'Thiago', '1990-05-05');


--
-- Data for Name: endereco_cliente; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.endereco_cliente (id, cpf_cliente, rua, numero, bairro, cidade, estado, tipo) VALUES (0, '12345678920', 'Rua Rodrigues Alves', 1800, 'Bela Vista', 'Campina Grande', 'PB', 'RESIDENCIA');
INSERT INTO public.endereco_cliente (id, cpf_cliente, rua, numero, bairro, cidade, estado, tipo) VALUES (1, '12345678920', 'Rua Alves', 105, 'Catolé', 'Campina Grande', 'PB', 'TRABALHO');
INSERT INTO public.endereco_cliente (id, cpf_cliente, rua, numero, bairro, cidade, estado, tipo) VALUES (2, '12345678921', 'Av. Dom Pedro II', 500, 'Universitário', 'Campina Grande', 'PB', 'OUTRO');


--
-- Data for Name: entrega; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.entrega (id, id_venda, data, id_endereco) VALUES (0, 2, NULL, 2);


--
-- Data for Name: farmacia; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.farmacia (id, nome, bairro, cidade, estado, tipo, cpf_gerente, tipo_gerente) VALUES (0, 'Drogasil', 'Bela Vista', 'Campina Grande', 'PB', 'SEDE', '12345678914', 'ADMINISTRADOR');
INSERT INTO public.farmacia (id, nome, bairro, cidade, estado, tipo, cpf_gerente, tipo_gerente) VALUES (1, 'RedePharma', 'Alto Branco', 'Campina Grande', 'PB', 'SEDE', '12345678910', 'FARMACEUTICO');
INSERT INTO public.farmacia (id, nome, bairro, cidade, estado, tipo, cpf_gerente, tipo_gerente) VALUES (2, 'RedePharma', 'Catolé', 'Campina Grande', 'PB', 'FILIAL', '12345678910', 'FARMACEUTICO');


--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.funcionario (cpf, nome, tipo, id_farm) VALUES ('12345678911', 'Jarbas', 'VENDEDOR', NULL);
INSERT INTO public.funcionario (cpf, nome, tipo, id_farm) VALUES ('12345678912', 'Vania', 'ENTREGADOR', NULL);
INSERT INTO public.funcionario (cpf, nome, tipo, id_farm) VALUES ('12345678913', 'Alberto', 'CAIXA', NULL);
INSERT INTO public.funcionario (cpf, nome, tipo, id_farm) VALUES ('12345678914', 'Jaldete', 'ADMINISTRADOR', 0);
INSERT INTO public.funcionario (cpf, nome, tipo, id_farm) VALUES ('12345678910', 'Claudia', 'FARMACEUTICO', 0);


--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.medicamento (id, nome, preco, receita) VALUES (0, 'Dorflex', 5.00, false);
INSERT INTO public.medicamento (id, nome, preco, receita) VALUES (1, 'Vitamina C', 10.00, false);
INSERT INTO public.medicamento (id, nome, preco, receita) VALUES (2, 'Rivotril', 50.00, true);


--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.venda (id, data, id_medicamento, receita, cpf_cliente, cpf_vendedor, tipo_vendedor) VALUES (0, NULL, 0, false, '12345678920', '12345678911', 'VENDEDOR');
INSERT INTO public.venda (id, data, id_medicamento, receita, cpf_cliente, cpf_vendedor, tipo_vendedor) VALUES (1, NULL, 0, false, NULL, '12345678911', 'VENDEDOR');
INSERT INTO public.venda (id, data, id_medicamento, receita, cpf_cliente, cpf_vendedor, tipo_vendedor) VALUES (2, NULL, 2, true, '12345678920', '12345678911', 'VENDEDOR');


--
-- Name: cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (cpf);


--
-- Name: endereco_cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.endereco_cliente
    ADD CONSTRAINT endereco_cliente_pkey PRIMARY KEY (id);


--
-- Name: entrega_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_pkey PRIMARY KEY (id);


--
-- Name: farmacia_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_pkey PRIMARY KEY (id);


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id);


--
-- Name: sede_unica; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT sede_unica EXCLUDE USING gist (tipo WITH =, nome WITH =) WHERE (((tipo)::text = 'SEDE'::text));


--
-- Name: unica_no_bairro; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT unica_no_bairro EXCLUDE USING gist (bairro WITH =, cidade WITH =);


--
-- Name: venda_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id);


--
-- Name: endereco_cliente_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.endereco_cliente
    ADD CONSTRAINT endereco_cliente_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: entrega_id_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_id_endereco_fkey FOREIGN KEY (id_endereco) REFERENCES public.endereco_cliente(id);


--
-- Name: entrega_id_venda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.entrega
    ADD CONSTRAINT entrega_id_venda_fkey FOREIGN KEY (id_venda) REFERENCES public.venda(id);


--
-- Name: farmacia_cpf_gerente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.farmacia
    ADD CONSTRAINT farmacia_cpf_gerente_fkey FOREIGN KEY (cpf_gerente) REFERENCES public.funcionario(cpf);


--
-- Name: funcionario_id_farm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_id_farm_fkey FOREIGN KEY (id_farm) REFERENCES public.farmacia(id);


--
-- Name: venda_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.cliente(cpf);


--
-- Name: venda_cpf_vendedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_cpf_vendedor_fkey FOREIGN KEY (cpf_vendedor) REFERENCES public.funcionario(cpf) ON DELETE RESTRICT;


--
-- Name: venda_id_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_id_medicamento_fkey FOREIGN KEY (id_medicamento) REFERENCES public.medicamento(id) ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--





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