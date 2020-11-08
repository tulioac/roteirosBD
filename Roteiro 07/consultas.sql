-- Consultar o nome dos jogadores que fizeram mais de 10 pontos em partidas

SELECT
  J.nome as Nome_Jogador,
  I.pontuacaojogador as Pontuacao_Partida
FROM
  jogador AS J
  LEFT JOIN
  InfoJogadorPartida AS I
  ON J.cpf=I.jogador_cpf
WHERE I.pontuacaojogador > 10
GROUP BY J.nome, I.pontuacaojogador;


-- Consultar as habilidades de cada jogador

SELECT
  J.nome as Nome_Jogador,
  H.descricao as Habilidade
FROM
  jogador AS J
  LEFT JOIN
  habilidade AS H
  ON J.cpf=H.jogador_cpf
GROUP BY J.nome, H.descricao;


-- Consultar as equipes participantes da liga 'Nordestina'

SELECT
  E.brasao as Brasao_equipe
FROM
  liga AS L
  LEFT JOIN
  equipe AS E
  ON E.liga_nome=L.nome
GROUP BY E.brasao;