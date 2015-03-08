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
SELECT winner,  (COUNT(*)) as count
FROM matches 
GROUP BY winner;

CREATE VIEW losses AS 
SELECT loser, (COUNT(*)) as count
FROM matches 
GROUP BY loser;

CREATE VIEW match_totals AS 
SELECT COALESCE(wins.winner,losses.loser) AS id, (COALESCE(wins.count,0)+COALESCE(losses.count,0)) AS matches_played 
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
ON standings.id = players.id
ORDER BY wins DESC; 

CREATE VIEW matches_played_winner AS
SELECT matches.id, players.name, matches.winner
FROM matches LEFT JOIN players ON matches.winner=players.id 
ORDER BY matches.id;

CREATE VIEW matches_played_loser AS
SELECT matches.id, players.name, matches.loser
FROM matches LEFT JOIN players ON matches.loser=players.id 
ORDER BY matches.id;

CREATE VIEW matches_played AS
SELECT matches_played_winner.name as winner_name, matches_played_winner.winner, matches_played_loser.name as loser_name, matches_played_loser.loser
FROM matches_played_winner JOIN matches_played_loser ON matches_played_winner.id = matches_played_loser.id
ORDER BY matches_played_winner.id DESC;


