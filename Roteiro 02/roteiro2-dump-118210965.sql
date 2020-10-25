-- Comentários e Resolução do Roteiro 02
-- (O arquivo gerado pelo dump começa na linha 360)




-- Questão 01

/*
  1º elemento: 10 caracteres
  2º elemento: String de tamanho indefinido
  3º elemento: 11 caracteres
  4º elemento: Inteiro
  5º elemento: 1 caractere
*/

CREATE TABLE tarefas (
  cpf CHAR(10),
  acao VARCHAR, 
  telefone CHAR(11),
  auxiliadores INTEGER,
  situacao CHAR(1)
);

INSERT‌ ‌INTO‌ ‌tarefas‌ ‌VALUES‌ ‌(2147483648,‌ ‌'limpar‌ ‌portas‌ ‌do‌ ‌térreo',‌ ‌'32323232955',‌ ‌4,‌ 'A');



-- Questão 02

/*
  Adicionado sem erros.
*/



-- Questão 03

/*
  Não permitir valores maiores que 32767
  Utiliza o tipo númerico smallint para restringir os valores aceitos
*/

ALTER TABLE tarefas ALTER COLUMN auxiliadores TYPE SMALLINT;



-- Questão 04

/*
  Remoção dos valores nulos
*/

DELETE FROM tarefas WHERE cpf IS NULL;

/*
  Mudança dos nomes dos atributos para os solicitados
*/

ALTER TABLE tarefas RENAME COLUMN cpf TO id;
ALTER TABLE tarefas RENAME COLUMN acao TO descricao;
ALTER TABLE tarefas RENAME COLUMN telefone TO func_resp_cpf;
ALTER TABLE tarefas RENAME COLUMN auxiliadores TO prioridade;
ALTER TABLE tarefas RENAME COLUMN situacao TO status;

/*
  Adição das constraints
*/

ALTER TABLE tarefas ALTER COLUMN id SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN descricao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN func_resp_cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN prioridade SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN status SET NOT NULL;



-- Questão 05

/*
  Adição de chave principal para a coluna id
*/

ALTER TABLE tarefas ADD PRIMARY KEY (id);



-- Questão 06

  -- A

  /*
    Adição da constraint para garantir o tamanho de 11 caracteres
  */

  ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_func_resp_cpf CHECK (LENGTH(func_resp_cpf) = 11);

  -- B

  /*
    Atualização das linhas com status 'A' para 'P', 'R' para 'E' e 'F' para 'C'
  */

  UPDATE tarefas SET status = 'P' WHERE status = 'A';
  UPDATE tarefas SET status = 'E' WHERE status = 'R';
  UPDATE tarefas SET status = 'C' WHERE status = 'F';


  /*
    Adição da constraint para garantir um status dentro das opções válidas
  */

  ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_status CHECK (status = 'P' OR status = 'E' OR status = 'C');



-- Questão 07

  /*
    Atualização dos valores em que a prioridade é maior que 5
  */

  UPDATE tarefas SET prioridade = 5 WHERE prioridade > 5;

  /*
    Adição da constraint para garantir os valores válidos de prioridade
  */

  ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_prioridade CHECK (prioridade >= 0 AND prioridade <= 5);



-- Questão 08

CREATE TABLE funcionario (
  cpf CHAR(11),
  data_nasc DATE,
  nome TEXT,
  funcao VARCHAR(11),
  nivel CHAR(1),
  superior_cpf CHAR(11)
);

/*
  Adição da chave primária
*/

ALTER TABLE funcionario ADD PRIMARY KEY (cpf);

/*
  Adição da chave estrangeira
*/

ALTER TABLE funcionario ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES funcionario (cpf);

/*
  Adição da constraint para validar a função
*/

ALTER TABLE funcionario ADD CONSTRAINT funcionario_chk_funcao CHECK (funcao = 'LIMPEZA' AND superior_cpf IS NOT NULL OR funcao = 'SUP_LIMPEZA');

/*
  Adição das constraint de NOT NULL
*/

ALTER TABLE funcionario ALTER COLUMN cpf SET NOT NULL;
ALTER TABLE funcionario ALTER COLUMN data_nasc SET NOT NULL;
ALTER TABLE funcionario ALTER COLUMN nome SET NOT NULL;
ALTER TABLE funcionario ALTER COLUMN funcao SET NOT NULL;
ALTER TABLE funcionario ALTER COLUMN nivel SET NOT NULL;

/*
  Adição da constraint para validar nível
*/

ALTER TABLE funcionario ADD CONSTRAINT funcionario_chk_nivel CHECK (nivel = 'J' OR nivel = 'P' OR nivel = 'S');



-- Questão 09

/*
    Exemplos válidos
*/

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1950-12-31', 'Thiago Pinto', 'SUP_LIMPEZA', 'J', null);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', '1977-06-25', 'André Igor', 'SUP_LIMPEZA', 'J', null);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '1996-09-29', 'Lúcio Dantas', 'SUP_LIMPEZA', 'P', null);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1965-10-12', 'Alfredo Paz', 'LIMPEZA', 'P', 12345678913);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '1983-07-06', 'Maria das Dores', 'LIMPEZA', 'S', 12345678913);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1989-03-15', 'Marta Silva', 'LIMPEZA', 'P', 12345678915);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1992-08-20', 'Nazaré Tedesco', 'LIMPEZA', 'J', 12345678921);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1978-01-16', 'Junior Campos', 'LIMPEZA', 'P', 12345678921);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678910', '1985-11-14', 'Andrey Jarbas', 'LIMPEZA', 'S', 12345678921);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '2000-02-01', 'Ana Paula', 'LIMPEZA', 'S', 12345678921);


/*
    Exemplos NÃO válidos
*/

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES (null, '1950-12-31', 'Thiago Pinto', 'SUP_LIMPEZA', 'J', null);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', null, 'André Igor', 'SUP_LIMPEZA', 'J', null);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '1996-09-29', null, 'SUP_LIMPEZA', 'P', null);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1965-10-12', 'Alfredo Paz', null, 'P', 12345678913);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '1983-07-06', 'Maria das Dores', 'LIMPEZA', null, 12345678913);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1989-03-15', 'Marta Silva', 'LIMPEZA', 'P', null);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1992-08-20', 'Nazaré Tedesco', 'LIMPEZA', 'J', 12345678922);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1978-01-16', 'Junior Campos', 'LIMPEZA', 'P', 12345678918);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678910', '1985-11-14', 'Andrey Jarbas', 'FAXINA', 'S', 12345678921);

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '2000-02-01', 'Ana Paula', 'LIMPEZA', 'Z', 12345678921);



-- Questão 10

/*
    Remoção da constraint anteriormente criada
*/

ALTER TABLE funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;

/*
    Adição da constraint com ON DELETE CASCADE
*/

ALTER TABLE funcionario ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES funcionario (cpf) ON DELETE CASCADE;

/*
    Deletando o funcionario de cpf 12345678921 todos os seus subordinados foram deletados
*/

DELETE FROM funcionario WHERE cpf = '12345678921';


/*
  Inserção novamente dos funcionários criados no exemplo para testar a opção 2 (ignorando os erros dos funcionários que já estavam na relação)
*/

INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1950-12-31', 'Thiago Pinto', 'SUP_LIMPEZA', 'J', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', '1977-06-25', 'André Igor', 'SUP_LIMPEZA', 'J', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '1996-09-29', 'Lúcio Dantas', 'SUP_LIMPEZA', 'P', null);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1965-10-12', 'Alfredo Paz', 'LIMPEZA', 'P', 12345678913);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '1983-07-06', 'Maria das Dores', 'LIMPEZA', 'S', 12345678913);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1989-03-15', 'Marta Silva', 'LIMPEZA', 'P', 12345678915);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1992-08-20', 'Nazaré Tedesco', 'LIMPEZA', 'J', 12345678921);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1978-01-16', 'Junior Campos', 'LIMPEZA', 'P', 12345678921);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678910', '1985-11-14', 'Andrey Jarbas', 'LIMPEZA', 'S', 12345678921);
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '2000-02-01', 'Ana Paula', 'LIMPEZA', 'S', 12345678921);

/*
    Remoção da constraint anteriormente criada
*/

ALTER TABLE funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;

/*
    Adição da constraint com ON DELETE RESTRICT
*/

ALTER TABLE funcionario ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES funcionario (cpf) ON DELETE RESTRICT;

/*
    Ao tentar deletar o funcionário de cpf 12345678921 ocorreu um erro devido a constraint
*/

DELETE FROM funcionario WHERE cpf = '12345678921';



-- Questão 11

/*
    Remoção da constraint NOT NULL de func_resp_cpf
*/

ALTER TABLE tarefas ALTER COLUMN func_resp_cpf DROP NOT NULL;

/*
    Criação da constraint tarefas_chk_status_cpf_resp
*/

ALTER TABLE tarefas ADD CONSTRAINT tarefas_chk_status_cpf_resp CHECK (status = 'P' or (status = 'C' and (func_resp_cpf <> '' and func_resp_cpf is not null)) or (status = 'E' and (func_resp_cpf <> '' and func_resp_cpf is not null)));

/*
    Sendo possível realizar as inserções abaixo
*/

INSERT INTO tarefas VALUES (2147483660, 'Limpar chão do térreo', 32323232911, 5, 'E');

INSERT INTO tarefas VALUES (2147483661, 'Limpar chão do térreo', null, 3, 'P');

INSERT INTO tarefas VALUES (2147483662, 'Limpar chão do térreo', 32323232911, 1, 'C');

/*
    E gerando erro ao tentar a inserção abaixo
*/

INSERT INTO tarefas VALUES (2147483663, 'Limpar chão do térreo', null, 1, 'C');

/*
    Removendo a constraint de ON DELETE RESTRICT
*/  

ALTER TABLE funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;

/* 
  Remoção das relações de tarefas para adicionar poder adicionar a constraint
*/

DELETE FROM tarefas WHERE prioridade > -1;

/*
    Criando a constraint para ON DELETE SET NULL
*/

ALTER TABLE tarefas ADD CONSTRAINT tarefas_func_resp_cpf_fk FOREIGN KEY (func_resp_cpf) REFERENCES funcionario (cpf) ON DELETE SET NULL;

/*
  Adição de tarefas com cpfs existentes na tabela funcionario
*/


INSERT‌ ‌INTO‌ ‌tarefas‌ ‌VALUES‌ ‌(2147483646,‌ ‌'limpar‌ ‌chão‌ ‌do‌ ‌corredor‌ ‌central',‌'12345678911',‌ ‌0,‌ ‌'C');‌

INSERT‌ ‌INTO‌ ‌tarefas‌ ‌VALUES‌ ‌(2147483648,‌ ‌'limpar‌ ‌portas‌ ‌do‌ ‌térreo',‌ ‌'12345678914',‌ ‌4,‌ 'E');

/*
  Tentativa de deletar os funcionarios de cpf '12345678911' e '12345678914'
*/

DELETE FROM funcionario WHERE cpf = '12345678911';
DELETE FROM funcionario WHERE cpf = '12345678914';

/*
    Ao tentar o remover o funcionário com tarefa de status 'C' ou 'E' ocorre um erro pois tenta violar a constraint, sendo informado que só pode ser alterado.
*/




-- ////////////////////////////////////////////////////////////////////

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

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fk;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome text NOT NULL,
    funcao character varying(11) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT funcionario_chk_funcao CHECK (((((funcao)::text = 'LIMPEZA'::text) AND (superior_cpf IS NOT NULL)) OR ((funcao)::text = 'SUP_LIMPEZA'::text))),
    CONSTRAINT funcionario_chk_nivel CHECK (((nivel = 'J'::bpchar) OR (nivel = 'P'::bpchar) OR (nivel = 'S'::bpchar)))
);


ALTER TABLE public.funcionario OWNER TO tulioac;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: tulioac
--

CREATE TABLE public.tarefas (
    id character(10) NOT NULL,
    descricao character varying NOT NULL,
    func_resp_cpf character(11),
    prioridade smallint NOT NULL,
    status character(1) NOT NULL,
    CONSTRAINT tarefas_chk_func_resp_cpf CHECK ((length(func_resp_cpf) = 11)),
    CONSTRAINT tarefas_chk_prioridade CHECK (((prioridade >= 0) AND (prioridade <= 5))),
    CONSTRAINT tarefas_chk_status CHECK (((status = 'P'::bpchar) OR (status = 'E'::bpchar) OR (status = 'C'::bpchar))),
    CONSTRAINT tarefas_chk_status_cpf_resp CHECK (((status = 'P'::bpchar) OR ((status = 'C'::bpchar) AND ((func_resp_cpf <> ''::bpchar) AND (func_resp_cpf IS NOT NULL))) OR ((status = 'E'::bpchar) AND ((func_resp_cpf <> ''::bpchar) AND (func_resp_cpf IS NOT NULL)))))
);


ALTER TABLE public.tarefas OWNER TO tulioac;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678915', '1977-06-25', 'André Igor', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1989-03-15', 'Marta Silva', 'LIMPEZA', 'P', '12345678915');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1950-12-31', 'Thiago Pinto', 'SUP_LIMPEZA', 'J', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '1996-09-29', 'Lúcio Dantas', 'SUP_LIMPEZA', 'P', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678914', '1965-10-12', 'Alfredo Paz', 'LIMPEZA', 'P', '12345678913');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '1983-07-06', 'Maria das Dores', 'LIMPEZA', 'S', '12345678913');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1992-08-20', 'Nazaré Tedesco', 'LIMPEZA', 'J', '12345678921');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678919', '1978-01-16', 'Junior Campos', 'LIMPEZA', 'P', '12345678921');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678910', '1985-11-14', 'Andrey Jarbas', 'LIMPEZA', 'S', '12345678921');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678922', '2000-02-01', 'Ana Paula', 'LIMPEZA', 'S', '12345678921');


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: tulioac
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES ('2147483646', 'limpar chão do corredor central', '12345678911', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES ('2147483648', 'limpar portas do térreo', '12345678914', 4, 'E');


--
-- Name: funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: tarefas_func_resp_cpf_fk; Type: FK CONSTRAINT; Schema: public; Owner: tulioac
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_fk FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

