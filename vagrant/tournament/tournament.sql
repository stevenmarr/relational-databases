-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players (
	id serial primary key, 
	name varchar);
CREATE TABLE matches (
	id serial, 
	winner serial references players (id) not null, 
	loser serial references players (id) not null);

CREATE VIEW wins AS 
SELECT winner,  COALESCE(COUNT(*),0) as count
FROM matches 
GROUP BY winner;

CREATE VIEW losses AS 
SELECT loser, COALESCE(COUNT(*), 0) as count
FROM matches 
GROUP BY loser;

--CREATE VIEW match_totals AS 
--SELECT COALESCE(wins.winner,losses.loser) AS id, (wins.count+losses.count) AS matches_played 
--FROM wins 
--FULL JOIN losses 
--ON wins.winner = losses.loser
--ORDER BY matches_played DESC;


CREATE VIEW match_totals AS 
SELECT COALESCE(wins.winner,losses.loser) AS id, (wins.count+losses.count) AS matches_played 
FROM wins 
FULL JOIN losses 
ON wins.winner = losses.loser
ORDER BY matches_played DESC;


CREATE VIEW standings AS
SELECT match_totals.id, match_totals.matches_played, COALESCE(wins.count,0) AS wins
FROM match_totals
LEFT JOIN wins
ON match_totals.id = wins.winner;

CREATE VIEW complete_standings AS
SELECT players.id, players.name, COALESCE(standings.matches_played,0) AS matches, COALESCE(standings.wins,0) AS wins
FROM standings
RIGHT JOIN players
ON standings.id = players.id; 
